USE online_retail_analysis;

SELECT COUNT(*) AS total_rows
FROM raw_online_retail;

SELECT MIN(InvoiceDate) AS min_invoice_date,
       MAX(InvoiceDate) AS max_invoice_date
FROM raw_online_retail;

SELECT COUNT(DISTINCT Invoice) AS unique_invoices
FROM raw_online_retail;

SELECT COUNT(DISTINCT StockCode) AS unique_products
FROM raw_online_retail;

SELECT COUNT(DISTINCT Customer_ID) AS unique_customers
FROM raw_online_retail;

SELECT *
FROM raw_online_retail
LIMIT 10;