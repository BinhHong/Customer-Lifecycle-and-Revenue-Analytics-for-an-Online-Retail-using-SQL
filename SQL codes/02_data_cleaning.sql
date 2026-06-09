/* ============================================================
   In this script, we create Clean Transaction Table. The process includes:
   1. Preserve the raw table unchanged.
   2. Remove exact duplicate records.
   3. Standardize blank values as SQL NULL.
   4. Convert raw text fields into proper analytical data types.
   5. Create derived revenue 
   6. Create transaction classification flags.
   6. Classify StockCode into product and non-product types.
   ============================================================ */

DROP TABLE IF EXISTS raw_online_retail_dedup;

-- create the deduplicate table
CREATE TABLE raw_online_retail_dedup (
    Invoice VARCHAR(50),
    StockCode VARCHAR(50),
    Description TEXT,
    Quantity VARCHAR(50),
    InvoiceDate VARCHAR(50),
    Price VARCHAR(50),
    Customer_ID VARCHAR(50),
    Country VARCHAR(100),

    UNIQUE KEY uq_raw_row (
        Invoice,
        StockCode,
        Description(255),
        Quantity,
        InvoiceDate,
        Price,
        Customer_ID,
        Country
    )
);

INSERT IGNORE INTO raw_online_retail_dedup
SELECT *
FROM raw_online_retail;

-- Check the number of rows
-- Result: 1033036 rows
SELECT COUNT(*) AS dedup_rows
FROM raw_online_retail_dedup;

DROP TABLE IF EXISTS clean_online_retail;

-- create the clean online retail table
CREATE TABLE clean_online_retail AS
SELECT
    -- Invoice and Stockcode
    Invoice AS invoice_no,
    StockCode AS stock_code,

    -- Text fields: Description and Country
    NULLIF(TRIM(Description), '') AS product_description,
    TRIM(Country) AS country,

    -- Convert Quantity, InvoiceDate and Price data types to numeric and datetime fields
    CAST(Quantity AS SIGNED) AS quantity,
    CAST(InvoiceDate AS DATETIME) AS invoice_datetime,
    CAST(Price AS DECIMAL(10,2)) AS unit_price,

    -- Customer ID conversion
	CASE
		WHEN Customer_ID IS NULL OR TRIM(Customer_ID) = '' THEN NULL
		ELSE CAST(CAST(Customer_ID AS DECIMAL(10,0)) AS UNSIGNED)
	END AS customer_id,

    -- Derived revenue
    CAST(Quantity AS SIGNED) * CAST(Price AS DECIMAL(10,2)) AS revenue,

    -- StockCode classification
	CASE
		WHEN StockCode REGEXP '^[0-9]{5}([A-Za-z]+)?$'
			THEN 'product'

		ELSE 'non_product'
	END AS stockcode_type,

    -- Transaction classification flags
    CASE
        WHEN Invoice LIKE 'C%' THEN 1 ELSE 0
    END AS is_cancelled,

    CASE
        WHEN CAST(Quantity AS SIGNED) < 0 THEN 1 ELSE 0
    END AS is_negative_quantity,

    CASE
        WHEN CAST(Quantity AS SIGNED) < 0
             AND Invoice NOT LIKE 'C%' THEN 1 ELSE 0
    END AS is_negative_non_cancelled,

    CASE
        WHEN CAST(Price AS DECIMAL(10,2)) = 0 THEN 1 ELSE 0
    END AS is_zero_price,

    CASE
        WHEN CAST(Price AS DECIMAL(10,2)) < 0 THEN 1 ELSE 0
    END AS is_negative_price

FROM raw_online_retail_dedup;


/* ============================================================
   Validation Checks
   ============================================================ */

SELECT COUNT(*) AS clean_rows
FROM clean_online_retail;

-- Check key data quality flags after deduplication.
SELECT
    SUM(customer_id IS NULL) AS missing_customer_ids,
    SUM(is_cancelled) AS cancelled_rows,
    SUM(is_negative_quantity) AS negative_quantity_rows,
    SUM(is_negative_non_cancelled) AS negative_non_cancelled_rows,
    SUM(is_zero_price) AS zero_price_rows,
    SUM(is_negative_price) AS negative_price_rows
FROM clean_online_retail;