/* ================================================
   sth
   ================================================*/
   
-- base_sales_transactions
DROP TABLE IF EXISTS base_sales_transactions;

CREATE TABLE base_sales_transactions
SELECT *
FROM fact_transactions
WHERE 
	customer_id IS NOT NULL
	AND stockcode_type = 'product'
    AND is_zero_price = 0
	AND is_negative_quantity = 0;
    
-- base_orders
DROP TABLE IF EXISTS base_orders;

CREATE TABLE base_orders
SELECT
	invoice_no,
    customer_id,
    MIN(invoice_datetime) AS datetime,
    MIN(date) AS date,
    SUM(quantity) AS total_quantity,
    SUM(revenue) AS total_revenue,
    COUNT(stock_code) AS num_products
FROM fact_transactions
WHERE
	customer_id IS NOT NULL
	AND stockcode_type = 'product'
    AND is_zero_price = 0
	AND is_negative_quantity = 0
GROUP BY invoice_no, customer_id;

-- base_customers
DROP TABLE IF EXISTS base_customers;

CREATE TABLE base_customers
SELECT
	customer_id,
    MIN(date) AS first_purchase_date,
    MAX(date) AS last_purchase_date,
    COUNT(DISTINCT invoice_no) AS total_orders,
    SUM(revenue) AS total_revenue
FROM fact_transactions
GROUP BY customer_id;

-- base_customer_acquisition
DROP TABLE IF EXISTS base_customer_acquisition;

CREATE TABLE base_customer_acquisition
SELECT
	customer_id,
    MIN(date) AS first_purchase_date,
    MONTH(invoice_datetime) AS acquisition_month
FROM fact_transactions;

-- base_customer_monthly
DROP TABLE IF EXISTS base_customer_monthly;

