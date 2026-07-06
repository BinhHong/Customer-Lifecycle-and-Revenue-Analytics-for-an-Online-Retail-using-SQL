/* ==================================================
   1. Customer Purchase Frequency
   ==================================================*/
   
-- Average order per customer
-- Result: 6.25
SELECT	ROUND(AVG(total_orders),2) AS avg_order
FROM	base_customers;

-- Median orders per customer
-- Result: 3.00
WITH numbered AS(
	SELECT
		total_orders,
		ROW_NUMBER() OVER(ORDER BY total_orders) AS rn,
		COUNT(*) OVER() AS total_rows
	FROM	base_customers
)
SELECT	ROUND(AVG(total_orders),2) AS median_order
FROM	numbered
WHERE	rn IN(FLOOR((total_rows+1)/2), FLOOR((total_rows+2)/2));

-- distribution of total orders
SELECT
    total_orders,
    COUNT(*) AS customers,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),2) AS pct_customers
FROM base_customers
GROUP BY total_orders
ORDER BY total_orders;

-- Customers segmentation
SELECT
	CASE
		WHEN total_orders = 1 THEN 'one_time'
        WHEN total_orders IN(2,3) THEN 'occasional'
        WHEN total_orders BETWEEN 4 AND 7 THEN 'repeat'
        WHEN total_orders BETWEEN 8 AND 13 THEN 'loyal'
        WHEN total_orders > 13 THEN 'power'
	END AS customer_type,
    COUNT(*) AS customers
FROM base_customers
GROUP BY customer_type;

-- Top purchasing customers
SELECT	customer_id, total_orders
FROM	base_customers
ORDER BY total_orders DESC
LIMIT 10;


/* ==================================================
   2. Repeat Purchase Rate
   ==================================================*/
   
-- Repeat customers percentage
-- Result: 72.35 %
SELECT	
	CASE
		WHEN total_orders = 1 THEN 'one_time'
        ELSE 'repeat'
	END AS customer_type,
    COUNT(*) AS customers,
    ROUND(COUNT(*)*100/SUM(COUNT(*)) OVER(),2) AS pct_customers
FROM	base_customers
GROUP BY customer_type;


/* ===================================================
   3. Purchase Interval Analysis
   ===================================================*/

-- Customers Purchase Inverval
WITH order_interval AS(
	SELECT	customer_id, 
		order_date,
		LAG(order_date) OVER(PARTITION BY customer_id ORDER BY order_date) AS previous_order_date,
		DATEDIFF(order_date, LAG(order_date) OVER(PARTITION BY customer_id ORDER BY order_date)) AS days_between_orders
	FROM base_orders
    )
SELECT *,
	ROUND(AVG(days_between_orders) OVER(PARTITION BY customer_id),2) AS avg_days_between_orders,
    ROUND(AVG(days_between_orders) OVER(),2) AS global_avg_days_between_orders
FROM order_interval;

WITH order_interval AS(
	SELECT	customer_id, 
		order_date,
		LAG(order_date) OVER(PARTITION BY customer_id ORDER BY order_date) AS previous_order_date,
		DATEDIFF(order_date, LAG(order_date) OVER(PARTITION BY customer_id ORDER BY order_date)) AS days_between_orders
	FROM base_orders
    )
SELECT 
	customer_id,
    ROUND(AVG(days_between_orders),2)
FROM order_interval
GROUP BY customer_id;