/* ==================================================
   1. Customer base overview
   ==================================================*/
  
-- Total customers
-- Result: 5852
SELECT COUNT(*)
FROM base_customers;

-- Total orders
-- Result: 36594
SELECT SUM(total_orders) AS total_orders
FROM base_customers;

-- Total revenue
-- Result: 17068567.97
SELECT SUM(total_revenue) AS total_revenue
FROM base_customers;

-- Average revenue per customer
-- Result: 2916.71
SELECT ROUND(AVG(total_revenue),2) as avg_revenue
FROM base_customers;

-- Average oders per customer
-- Result: 6.25
SELECT ROUND(AVG(total_orders),2) as avg_orders
FROM base_customers;

-- Average Oder Value (AOV)
-- Result: 466.43
SELECT ROUND(SUM(total_revenue)/SUM(total_orders),2) AS aov
FROM base_customers;

SELECT AVG(avg_order_value)
FROM base_customers; -- 384.4049171365

-- Average customer lifetime (days)
-- Result: 273.81
SELECT ROUND(AVG(active_days),2) AS avg_lifetime
FROM base_customers;

/*==================================================
   2. Customer Acquisition Analysis
  ==================================================*/
  
  -- 