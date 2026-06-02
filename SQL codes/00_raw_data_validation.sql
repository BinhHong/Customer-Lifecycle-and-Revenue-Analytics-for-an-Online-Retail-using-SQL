/*
00_raw_data_validation.sql

Project: Customer Lifecycle and Revenue Analytics for an Online Retail Company

Purpose:
Validate that the raw CSV import completed successfully before performing
data quality assessment, cleaning, and business analysis.

This script verifies:
- Dataset size
- Date coverage
- Number of invoices
- Number of products
- Number of customers
- Raw data structure
*/

USE online_retail_analysis;


/* ============================================================
   1. Import Validation
   ============================================================ */

-- Check: Total number of imported rows.
-- Purpose: Verify import completeness.
-- Expected Result: 1,067,371 rows.
SELECT COUNT(*) AS total_rows
FROM raw_online_retail;


-- Check: Transaction date range.
-- Purpose: Verify dataset coverage period.
-- Expected Result: 2009-12-01 to 2011-12-09.
SELECT
    MIN(InvoiceDate) AS min_invoice_date,
    MAX(InvoiceDate) AS max_invoice_date
FROM raw_online_retail;


-- Check: Number of unique invoices.
-- Purpose: Verify transaction volume.
SELECT COUNT(DISTINCT Invoice) AS unique_invoices
FROM raw_online_retail;


-- Check: Number of unique products.
-- Purpose: Verify product catalog size.
SELECT COUNT(DISTINCT StockCode) AS unique_products
FROM raw_online_retail;


-- Check: Number of unique customer identifiers.
-- Purpose: Verify customer base size.
SELECT COUNT(DISTINCT Customer_ID) AS unique_customers
FROM raw_online_retail;


/* ============================================================
   2. Raw Data Inspection
   ============================================================ */

-- Check: Sample records from the raw import.
-- Purpose: Verify column structure and imported values.
SELECT *
FROM raw_online_retail
LIMIT 10;