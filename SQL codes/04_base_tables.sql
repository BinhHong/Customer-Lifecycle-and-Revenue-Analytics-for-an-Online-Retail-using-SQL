/* ================================================
   For the purpose of analyzing customer lifecycle, we focus only on valid customer purchase transactions.
   The following records are therefore excluded:
		1. anonymous transactions
		2. non-product records
		3. zero-price transactions
        4. negative-quantity transactions
   ================================================*/

USE online_retail_analysis;

-- base_transactions
DROP TABLE IF EXISTS base_transactions;

CREATE TABLE base_transactions
SELECT
	invoice_no,
    stock_code,
    customer_id,
    invoice_datetime,
    DATE(invoice_datetime) AS invoice_date,
    quantity,
    unit_price,
    revenue
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
    MIN(invoice_datetime) AS order_datetime,
    MIN(invoice_date) AS order_date,
    SUM(quantity) AS total_quantity,
    SUM(revenue) AS total_revenue,
    COUNT(DISTINCT stock_code) AS distinct_products,
    COUNT(*) AS product_lines
FROM base_transactions
GROUP BY invoice_no, customer_id;

-- base_customers
DROP TABLE IF EXISTS base_customers;

CREATE TABLE base_customers
SELECT
	customer_id,
    COUNT(DISTINCT invoice_no) AS total_orders,
    SUM(total_quantity) AS total_quantity,
	SUM(total_revenue) AS total_revenue,
    AVG(total_revenue) AS avg_order_value,
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
	DATE_FORMAT(MIN(order_date), '%Y-%m') AS first_order_month,
	DATE_FORMAT(MAX(order_date), '%Y-%m') AS last_order_month,
    DATEDIFF(MAX(order_date), MIN(order_date)) AS active_days,
    TIMESTAMPDIFF(MONTH, MIN(order_date), MAX(order_date)) AS active_months
FROM base_orders
GROUP BY customer_id;

-- validation
-- Check base_transactions rows
-- Result: 776577
SELECT COUNT(*) AS base_transaction_rows
FROM base_transactions;

-- Check base_orders rows
-- Result: 36594
SELECT COUNT(*) AS base_order_rows
FROM base_orders;

-- Check base_customers rows
-- Result: 5852
SELECT COUNT(*) AS base_customer_rows
FROM base_customers;