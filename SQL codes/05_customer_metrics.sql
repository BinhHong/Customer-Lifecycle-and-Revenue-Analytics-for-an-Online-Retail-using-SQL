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

-- Average orders per customer
-- Result: 6.25
SELECT ROUND(AVG(total_orders),2) as avg_orders
FROM base_customers;

-- Average Order Value (AOV)
-- Result: 466.43
SELECT ROUND(SUM(total_revenue)/SUM(total_orders),2) AS aov
FROM base_customers;

-- Average customer lifetime (days)
-- Result: 273.81
SELECT ROUND(AVG(active_days),2) AS avg_lifetime
FROM base_customers;


/*==================================================
   2. Customer Acquisition Analysis
  ==================================================*/
  
-- New customers per month
-- Result: 
SELECT first_order_month, COUNT(*) AS customer_acquisition
FROM base_customers
GROUP BY first_order_month
ORDER BY first_order_month;

-- Month with highest acquisition
-- Result: 2009-12 with 951 new customers
WITH monthly_acquisition AS
(SELECT first_order_month, COUNT(*) AS customer_acquisition
FROM base_customers
GROUP BY first_order_month
ORDER BY first_order_month
)
SELECT first_order_month, customer_acquisition
FROM monthly_acquisition
WHERE customer_acquisition = 
	(SELECT MAX(customer_acquisition)
    FROM monthly_acquisition
    );

-- Cumulative number of customers and fluctuations between months
WITH monthly_acquisition AS
(SELECT first_order_month, COUNT(*) AS customer_acquisition
FROM base_customers
GROUP BY first_order_month
ORDER BY first_order_month
)
SELECT *, 
	SUM(customer_acquisition) OVER(ORDER BY first_order_month) AS cumulative_customers,
    LAG(customer_acquisition) OVER(ORDER BY first_order_month) AS previous_month_customers,
    customer_acquisition - LAG(customer_acquisition) OVER(ORDER BY first_order_month) AS customer_growth,
    ROUND((customer_acquisition - LAG(customer_acquisition) OVER(ORDER BY first_order_month))/LAG(customer_acquisition) OVER(ORDER BY first_order_month)*100,2) 
		AS 'Growth Rate (%)'
FROM monthly_acquisition;