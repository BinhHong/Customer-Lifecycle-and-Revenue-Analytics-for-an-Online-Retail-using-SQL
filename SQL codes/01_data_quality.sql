/*

This script profiles the raw Online Retail II dataset before cleaning and modeling.
The objective is to identify data quality issues that may affect customer-level,
revenue-level, and lifecycle analytics.

Important:
This script does not clean or modify data. It only audits the raw import.
*/

USE online_retail_analysis;


/* ============================================================
   1. Dataset Overview
   ============================================================ */
   
-- Check: Total number of transaction rows.
-- Purpose: Validate dataset size after raw import.
-- Result: 1,067,371 rows.
SELECT COUNT(*) AS total_rows
FROM raw_online_retail;


-- Check: Number of unique invoices.
-- Purpose: Estimate transaction/order volume.
-- Result: 53,628 unique invoices.
SELECT COUNT(DISTINCT Invoice) AS unique_invoices
FROM raw_online_retail;


-- Check: Number of unique products.
-- Purpose: Estimate product variety in the dataset.
-- Result: 5,132 unique stock codes.
SELECT COUNT(DISTINCT StockCode) AS unique_products
FROM raw_online_retail;


-- Check: Number of unique customer identifiers.
-- Purpose: Estimate identifiable customer base.
-- Result: 5,943 unique customer identifiers.
SELECT COUNT(DISTINCT Customer_ID) AS unique_customers
FROM raw_online_retail;


-- Check: Transaction date range.
-- Purpose: Confirm dataset coverage period.
-- Result: 2009-12-01 07:45:00 to 2011-12-09 12:50:00.
SELECT
    MIN(InvoiceDate) AS first_invoice_date,
    MAX(InvoiceDate) AS last_invoice_date
FROM raw_online_retail;



/* ============================================================
   2. Missing Values
   ============================================================ */

-- Check: NULL values and blank strings across all columns.
-- Purpose: Distinguish true SQL NULL values from blank strings imported from CSV.
-- Result: No SQL NULL values found, 4,382 blank descriptions and 243,007 blank customer identifiers.
SELECT
    SUM(Invoice IS NULL) AS null_invoice,
    SUM(TRIM(Invoice) = '') AS blank_invoice,

    SUM(StockCode IS NULL) AS null_stockcode,
    SUM(TRIM(StockCode) = '') AS blank_stockcode,

    SUM(Description IS NULL) AS null_description,
    SUM(TRIM(Description) = '') AS blank_description,

    SUM(Quantity IS NULL) AS null_quantity,
    SUM(TRIM(Quantity) = '') AS blank_quantity,

    SUM(InvoiceDate IS NULL) AS null_invoice_date,
    SUM(TRIM(InvoiceDate) = '') AS blank_invoice_date,

    SUM(Price IS NULL) AS null_price,
    SUM(TRIM(Price) = '') AS blank_price,

    SUM(Customer_ID IS NULL) AS null_customer_id,
    SUM(TRIM(Customer_ID) = '') AS blank_customer_id,

    SUM(Country IS NULL) AS null_country,
    SUM(TRIM(Country) = '') AS blank_country
FROM raw_online_retail;



/* ============================================================
   3. Duplicate Record Assessment
   ============================================================ */

-- Check: Exact duplicate groups across all raw columns.
-- Purpose: Identify repeated transaction rows that may inflate revenue and customer metrics.
-- Result: 32,907 duplicate groups.
SELECT Invoice, StockCode, Description, Quantity, InvoiceDate, Price, Customer_ID, Country, COUNT(*) AS duplicate_count
FROM raw_online_retail
GROUP BY Invoice, StockCode, Description, Quantity, InvoiceDate, Price, Customer_ID, Country
HAVING COUNT(*) > 1;


-- Check: Number of redundant duplicate rows beyond the first occurrence.
-- Purpose: Estimate the scale of duplication requiring treatment during cleaning.
-- Result: 34,335 duplicate rows.
SELECT SUM(duplicate_count - 1) AS duplicate_rows
FROM (
    SELECT COUNT(*) AS duplicate_count
    FROM raw_online_retail
    GROUP BY
        Invoice,
        StockCode,
        Description,
        Quantity,
        InvoiceDate,
        Price,
        Customer_ID,
        Country
    HAVING COUNT(*) > 1
) AS duplicate_groups;



/* ============================================================
   4. Cancellation and Negative Quantity Assessment
   ============================================================ */

-- Check: Cancellation records identified by invoice prefix 'C'.
-- Purpose: Quantify transactions explicitly marked as cancellations.
-- Result: 19,494 cancellation records.
SELECT COUNT(*) AS cancellation_rows
FROM raw_online_retail
WHERE Invoice LIKE 'C%';


-- Check: Records with negative quantities.
-- Purpose: Identify returns, cancellations, or adjustment transactions.
-- Result: 22,950 rows with negative quantities.
SELECT COUNT(*) AS negative_quantity_rows
FROM raw_online_retail
WHERE CAST(Quantity AS SIGNED) < 0;


-- Check: Cancellation records that also have negative quantities.
-- Purpose: Validate whether cancellation invoices consistently use negative quantities.
-- Result: 19,493 rows.
SELECT COUNT(*) AS cancelled_negative_quantity_rows
FROM raw_online_retail
WHERE Invoice LIKE 'C%'
  AND CAST(Quantity AS SIGNED) < 0;


-- Check: Negative quantities without cancellation invoice prefix.
-- Purpose: Identify returns or adjustments not explicitly marked as cancellation invoices.
-- Result: 3,457 rows.
SELECT COUNT(*) AS negative_quantity_without_cancellation_rows
FROM raw_online_retail
WHERE Invoice NOT LIKE 'C%'
  AND CAST(Quantity AS SIGNED) < 0;


-- Check: Cancellation invoices with non-negative quantities.
-- Purpose: Identify exceptions to the expected cancellation pattern.
-- Result: 1 row; StockCode = 'M', Description = 'Manual'.
SELECT *
FROM raw_online_retail
WHERE Invoice LIKE 'C%'
  AND CAST(Quantity AS SIGNED) >= 0;



/* ============================================================
   5. Price Validation
   ============================================================ */

-- Check: Records with non-positive prices.
-- Purpose: Identify zero-price and negative-price transactions requiring review.
-- Result: 6,225 records.
SELECT COUNT(*) AS non_positive_price_rows
FROM raw_online_retail
WHERE CAST(Price AS DECIMAL(10,2)) <= 0;


-- Check: Breakdown of zero-price and negative-price records.
-- Purpose: Separate potentially promotional or complimentary transactions from invalid/correction records.
-- Result: 6,220 zero-price rows and 5 negative-price rows.
SELECT
    CASE
        WHEN CAST(Price AS DECIMAL(10,2)) < 0 THEN 'Negative'
        WHEN CAST(Price AS DECIMAL(10,2)) = 0 THEN 'Zero'
    END AS price_type,
    COUNT(*) AS rows_count
FROM raw_online_retail
WHERE CAST(Price AS DECIMAL(10,2)) <= 0
GROUP BY price_type;


-- Check: Description patterns among zero-price records.
-- Purpose: Inspect whether zero-price rows are linked to specific products or operational records.
SELECT
    Description,
    COUNT(*) AS rows_count
FROM raw_online_retail
WHERE CAST(Price AS DECIMAL(10,2)) = 0
GROUP BY Description
ORDER BY rows_count DESC
LIMIT 20;


-- Check: StockCode distribution among zero-price records.
-- Purpose: Determine whether zero-price rows are concentrated in a few administrative stock codes.
-- Finding: Zero-price rows are distributed across normal product stock codes.
SELECT
    StockCode,
    COUNT(*) AS rows_count
FROM raw_online_retail
WHERE CAST(Price AS DECIMAL(10,2)) = 0
GROUP BY StockCode
ORDER BY rows_count DESC;


-- Check: Price range for selected stock codes that frequently appear with zero price.
-- Purpose: Verify whether these stock codes also appear with positive prices.
-- Finding: Selected stock codes have both zero and positive prices, suggesting valid products with occasional zero-price entries.
SELECT
    StockCode,
    MIN(CAST(Price AS DECIMAL(10,2))) AS min_price,
    MAX(CAST(Price AS DECIMAL(10,2))) AS max_price,
    COUNT(*) AS total_rows
FROM raw_online_retail
WHERE StockCode IN (
    '46000M', 'PADS', '22501', '79321', '21116',
    '22423', '23084', '46000S', '22734', '22139'
)
GROUP BY StockCode;



/* ============================================================
   6. Description Quality
   ============================================================ */

-- Check: Description missingness type.
-- Purpose: Confirm whether missing descriptions are stored as SQL NULL or blank strings.
-- Result: 4,382 blank descriptions and 0 NULL descriptions.
SELECT
    CASE
        WHEN Description IS NULL THEN 'null_description'
        WHEN TRIM(Description) = '' THEN 'blank_description'
    END AS description_type,
    COUNT(*) AS rows_count
FROM raw_online_retail
WHERE Description IS NULL
   OR TRIM(Description) = ''
GROUP BY description_type;


-- Check: Non-standard operational descriptions.
-- Purpose: Inspect descriptions that may represent inventory, operational, or administrative records.
SELECT
    Description,
    COUNT(*) AS rows_count
FROM raw_online_retail
WHERE LOWER(TRIM(Description)) IN (
    'check',
    'damaged',
    'damages',
    '?',
    'found',
    'missing',
    'amazon',
    'sold as set on dotcom',
    'adjustment',
    'dotcom',
    'thrown away',
    'smashed',
    'unsaleable, destroyed.'
)
GROUP BY Description
ORDER BY rows_count DESC;



/* ============================================================
   7. Customer Identifier Quality
   ============================================================ */

-- Check: Blank customer identifiers.
-- Purpose: Quantify transaction rows that cannot support customer-level analytics.
-- Result: 243,007 transaction rows with blank customer identifiers.
SELECT COUNT(*) AS blank_customer_id_rows
FROM raw_online_retail
WHERE Customer_ID IS NULL
   OR TRIM(Customer_ID) = '';



/* ============================================================
   8. Business Outlier Assessment
   ============================================================ */

-- Check: Largest quantity values.
-- Purpose: Identify extreme quantity transactions and assess potential wholesale behavior or data issues.
-- Finding: Top quantities range from 7,128 to 80,995 units.
SELECT *
FROM raw_online_retail
ORDER BY CAST(Quantity AS SIGNED) DESC
LIMIT 20;


-- Check: Largest unit price values.
-- Purpose: Identify extreme price records and separate product sales from financial/administrative transactions.
-- Finding: Extreme prices are associated mainly with 'M', 'AMAZONFEE', 'BANK CHARGES', and bad debt adjustments.
SELECT *
FROM raw_online_retail
ORDER BY CAST(Price AS DECIMAL(10,2)) DESC
LIMIT 20;
