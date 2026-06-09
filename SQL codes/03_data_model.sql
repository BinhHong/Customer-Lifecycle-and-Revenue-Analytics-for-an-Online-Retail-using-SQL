/* =================================================
   In this script, fact and dimension tables are created for later customer lifecycle analysis.
   Tables created:
   1. dim_customers
   2. dim_products
   3. dim_date
   4. fact_transactions
   ================================================= */

USE online_retail_analysis;

-- create dim_customers
DROP TABLE IF EXISTS dim_customers;
CREATE TABLE dim_customers
SELECT
	customer_id,
    CASE
		WHEN COUNT(DISTINCT country) = 1 THEN MAX(country)
        ELSE 'Multiple'
	END AS country
FROM clean_online_retail
WHERE customer_id IS NOT NULL
GROUP BY customer_id;

-- create dim_products
DROP TABLE IF EXISTS dim_products;
CREATE TABLE dim_products
SELECT
	stock_code,
    MAX(product_description) AS product_description,
    MAX(stockcode_type) AS stockcode_type
FROM clean_online_retail
GROUP BY stock_code;

-- create dim_date
DROP TABLE IF EXISTS dim_date;
CREATE TABLE dim_date
SELECT DISTINCT
	DATE(invoice_datetime) AS date,
    YEAR(invoice_datetime) AS year,
    MONTH(invoice_datetime) AS month,
    QUARTER(invoice_datetime) AS quarter,
    DATE_FORMAT(invoice_datetime, '%Y-%m') AS `year_month`
FROM clean_online_retail;

-- create fact_transactions
DROP TABLE IF EXISTS fact_transactions;
CREATE TABLE fact_transactions
SELECT
	invoice_no,
    stock_code,
    customer_id,
    invoice_datetime,
    DATE(invoice_datetime) AS date,
    quantity,
    unit_price,
    revenue,
    stockcode_type,
    is_cancelled,
	is_negative_quantity,
    is_negative_non_cancelled,
	is_zero_price,
    is_negative_price
FROM clean_online_retail;