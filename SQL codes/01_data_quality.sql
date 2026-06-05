/*
This script profiles the raw Online Retail II dataset before cleaning and modeling.
The objective is to identify data quality issues that may affect customer-level,
revenue-level, and lifecycle analytics. Note that this does not include cleaning or modifying data.
Steps needed:
- 1. Dataset Overview
- 2. Missing Values
- 3. Duplicate Records
- 4. Cancellation and Negative Quantity
- 5. Price Validation
- 6. Description profiling
- 7. Customer Id's Quality
- 8. Outliers Assessment
*/

USE online_retail_analysis;

/* ============================================================
   1. Dataset Overview
   ============================================================ */
   
-- Check the total number of transaction rows to validate dataset size after raw import.
-- Result: 1,067,371 rows.
SELECT COUNT(*) AS total_rows
FROM raw_online_retail;

-- Examine the number of unique invoices.
-- Result: 53,628 unique invoices.
SELECT COUNT(DISTINCT Invoice) AS unique_invoices
FROM raw_online_retail;

-- Check the number of unique products.
-- Result: 5,132 unique stock codes.
SELECT COUNT(DISTINCT StockCode) AS unique_products
FROM raw_online_retail;

-- Inspect the number of unique customer ids
-- Result: 5,943 unique customer identifiers.
SELECT COUNT(DISTINCT Customer_ID) AS unique_customers
FROM raw_online_retail;

-- Investigate the transaction date range.
-- Result: 2009-12-01 07:45:00 to 2011-12-09 12:50:00.
SELECT
    MIN(InvoiceDate) AS first_invoice_date,
    MAX(InvoiceDate) AS last_invoice_date
FROM raw_online_retail;


/* ============================================================
   2. Missing Values
   ============================================================ */

-- Investigate NULL values and blank strings across all columns.
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
   3. Duplicate Records
   ============================================================ */

-- Examine exact duplicate groups across all raw columns.
-- Result: 32,907 duplicate groups.
SELECT 
	Invoice,
    StockCode, 
    Description, 
    Quantity, 
    InvoiceDate, 
    Price, 
    Customer_ID, 
    Country, 
    COUNT(*) AS duplicate_count
FROM raw_online_retail
GROUP BY Invoice, StockCode, Description, Quantity, InvoiceDate, Price, Customer_ID, Country
HAVING COUNT(*) > 1;

-- Check the number of redundant duplicate rows beyond the first occurrence.
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
   4. Cancellation and Negative Quantity
   ============================================================ */

-- Check the cancellation records which are marked with prefix 'C' in invoice.
-- Result: 19,494 cancellation records.
SELECT COUNT(*) AS cancellation_transactions
FROM raw_online_retail
WHERE Invoice LIKE 'C%';

-- Examine the records with negative quantities
-- Result: 22,950 rows with negative quantities.
SELECT COUNT(*) AS negative_quantity_transactions
FROM raw_online_retail
WHERE CAST(Quantity AS SIGNED) < 0;

-- Check the cancellation records that also have negative quantities
-- Purpose: validate whether cancellation invoices consistently come with negative quantities.
-- Result: 19,493 rows.
SELECT COUNT(*) AS cancelled_negative_quantity_transactions
FROM raw_online_retail
WHERE Invoice LIKE 'C%'
  AND CAST(Quantity AS SIGNED) < 0;
  
-- Find the cancellation invoices with non-negative quantities.
-- Result: 1 row; StockCode = 'M', Description = 'Manual'.
SELECT *
FROM raw_online_retail
WHERE Invoice LIKE 'C%'
  AND CAST(Quantity AS SIGNED) >= 0;

-- Examine negative quantities without cancellation invoice prefix.
-- Result: 3,457 rows.
SELECT COUNT(*) AS negative_quantity_without_cancellation_transactions
FROM raw_online_retail
WHERE Invoice NOT LIKE 'C%'
  AND CAST(Quantity AS SIGNED) < 0;
  
-- Check the descriptions of records with negative quantities
-- Result: typical descriptions include "missing", "lost", "damaged", "bad", "can't find", "wrong", "Dotcom", "?"
SELECT *
FROM raw_online_retail
WHERE Invoice NOT LIKE 'C%'
  AND CAST(Quantity AS SIGNED) < 0;


/* ============================================================
   5. Price Validation
   ============================================================ */
   
-- Examine the price range
-- Result: min price is -53594.36 and max price is 38970.00
SELECT MIN(CAST(Price AS DECIMAL(10,2))) AS min_price, MAX(CAST(Price AS DECIMAL(10,2))) AS max_price
FROM raw_online_retail;

-- Check the records with non-positive prices.
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

-- Investigate the negative prices.
-- Result: they are all associated with StockCode "B", Description "Adjust bad debt" and Customer IDs are blank.
SELECT *
FROM raw_online_retail
WHERE CAST(Price AS DECIMAL(10,2)) < 0;

-- Check the records with Stockcode = "B".
-- Result: beside the negative price rows, there is also a record with positive price and blank Customer ID.
SELECT *
FROM raw_online_retail
WHERE StockCode = "B";

-- Check Invoices with prefix "A".
-- Result: this produces the same result as query with Stockcode = "B".
SELECT *
FROM raw_online_retail
WHERE Invoice LIKE "A%";

-- Check description patterns among zero-price records.
-- Inspect whether zero-price rows are linked to specific products or operational records.
SELECT
    Description,
    COUNT(*) AS rows_count
FROM raw_online_retail
WHERE CAST(Price AS DECIMAL(10,2)) = 0
GROUP BY Description
ORDER BY rows_count DESC;

-- Investigate StockCode distribution among zero-price records.
-- Finding: Zero-price rows are distributed across normal product stock codes.
SELECT
    StockCode,
    COUNT(*) AS rows_count
FROM raw_online_retail
WHERE CAST(Price AS DECIMAL(10,2)) = 0
GROUP BY StockCode
ORDER BY rows_count DESC;

-- Check price range for selected stock codes that frequently appear with zero price.
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
   6. Description profiling
   ============================================================ */

-- Examine the missingness type of descriptions
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

-- Check the non-standard operational descriptions.
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
   7. Customer Id's Quality
   ============================================================ */

-- Count the NULL or blank customer IDs.
-- Result: 243,007 blank transaction rows.
SELECT
	CASE
		WHEN Customer_ID IS NULL THEN "null"
        WHEN TRIM(Customer_ID) = "" THEN "blank"
	END AS customer_ID_missing_type,
    COUNT(*) AS count
FROM raw_online_retail
WHERE Customer_ID IS NULL OR TRIM(Customer_ID) = ""
GROUP BY customer_ID_missing_type;



/* ============================================
   8. StockCode Overview
   ============================================ */
   
-- Check StockCode types
-- Result: 932385 codes with 5 digits, 128893 codes with 5 digits and some letters, 5477 codes with only letters and 616 other codes
SELECT
    CASE
        WHEN TRIM(StockCode) REGEXP '^[0-9]{5}$'
            THEN '5 digits'

        WHEN TRIM(StockCode) REGEXP '^[0-9]{5}[A-Za-z]+$'
            THEN '5 digits + letters'

        WHEN TRIM(StockCode) REGEXP '^[A-Za-z]+$'
            THEN 'Letters only'

        ELSE 'Other'
    END AS stockcode_type,
    COUNT(*) AS cnt
FROM raw_online_retail
GROUP BY stockcode_type;

-- Check StockCode marked with "Other"
WITH sc_type AS (
	SELECT
		*,
		CASE
			WHEN TRIM(StockCode) REGEXP '^[0-9]{5}$'
				THEN '5 digits'

			WHEN TRIM(StockCode) REGEXP '^[0-9]{5}[A-Za-z]+$'
				THEN '5 digits + letters'

			WHEN TRIM(StockCode) REGEXP '^[A-Za-z]+$'
				THEN 'Letters only'

			ELSE 'Other'
		END AS stockcode_type
	FROM raw_online_retail
)

SELECT *
FROM sc_type
WHERE stockcode_type = "Other";



/* ==================================================
   9. Country Profiling
   ================================================== */

-- Examine Country
-- Result: Some non-standard country values were identified:`EIRE`, `RSA`, `European Community`, `Channel Islands`, `West Indies`, and `Unspecified`.
SELECT DISTINCT Country
FROM raw_online_retail;



/* ============================================================
   8. Outliers
   ============================================================ */

-- Check the largest quantity values.
-- Finding: Top quantities range from 7,128 to 80,995 units.
SELECT *
FROM raw_online_retail
ORDER BY CAST(Quantity AS SIGNED) DESC
LIMIT 20;

-- Check the largest unit price values.
-- Finding: Extreme prices are associated mainly with 'M', 'AMAZONFEE', 'BANK CHARGES', and bad debt adjustments.
SELECT *
FROM raw_online_retail
ORDER BY CAST(Price AS DECIMAL(10,2)) DESC
LIMIT 20;