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

-- Time to Second Purchase
WITH sc_order AS(
	SELECT
		customer_id,
		order_date AS first_order_date,
		LEAD(order_date) OVER(PARTITION BY customer_id ORDER BY order_date) AS second_order_date,
		ROW_NUMBER() OVER(PARTITION BY customer_id) AS rn
	FROM base_orders)
SELECT
	customer_id, first_order_date, second_order_date, 
    DATEDIFF(second_order_date, first_order_date) AS days_to_second_order
FROM sc_order
WHERE rn = 1;

/* ===================================================
   3. Purchase Interval Analysis
   ===================================================*/

-- Overall Average Customers Purchase Inverval
-- Result: 52.12 days
WITH order_interval AS(
	SELECT	customer_id, 
		order_date,
		LAG(order_date) OVER(PARTITION BY customer_id ORDER BY order_date) AS previous_order_date,
		DATEDIFF(order_date, LAG(order_date) OVER(PARTITION BY customer_id ORDER BY order_date)) AS days_between_orders
	FROM base_orders
    )
SELECT ROUND(AVG(days_between_orders),2) AS overall_avg_interval
FROM order_interval;

-- Customers Purchase Inverval
WITH order_interval AS(
	SELECT	customer_id, 
		order_date,
		LAG(order_date) OVER(PARTITION BY customer_id ORDER BY order_date) AS previous_order_date,
		DATEDIFF(order_date, LAG(order_date) OVER(PARTITION BY customer_id ORDER BY order_date)) AS days_between_orders
	FROM base_orders
    )
SELECT 
	customer_id,
    ROUND(AVG(days_between_orders),2) AS order_interval
FROM order_interval
GROUP BY customer_id;

-- Average Customers Purchase Inverval
-- Result: 103.43
WITH order_interval AS(
	SELECT	customer_id, 
		order_date,
		LAG(order_date) OVER(PARTITION BY customer_id ORDER BY order_date) AS previous_order_date,
		DATEDIFF(order_date, LAG(order_date) OVER(PARTITION BY customer_id ORDER BY order_date)) AS days_between_orders
	FROM base_orders
    ),
avg_order_interval AS(
	SELECT 
		customer_id,
		ROUND(AVG(days_between_orders),2) AS order_interval
	FROM order_interval
	GROUP BY customer_id)
SELECT ROUND(AVG(order_interval),2) AS avg_order_interval
FROM avg_order_interval;

-- Median Customers Purchase Inverval
-- Result: 72.88
WITH order_intervals AS(
	SELECT	customer_id, 
		order_date,
		LAG(order_date) OVER(PARTITION BY customer_id ORDER BY order_date) AS previous_order_date,
		DATEDIFF(order_date, LAG(order_date) OVER(PARTITION BY customer_id ORDER BY order_date)) AS days_between_orders
	FROM base_orders
    ),
avg_interval AS (
	SELECT 
		customer_id,
		ROUND(AVG(days_between_orders),2) AS avg_order_interval
	FROM order_intervals
	GROUP BY customer_id),
avg_interval_not_null AS(
	SELECT
		avg_order_interval,
		ROW_NUMBER() OVER(ORDER BY avg_order_interval) AS rn,
		COUNT(*) OVER() AS total_rows
	FROM avg_interval
	WHERE avg_order_interval IS NOT NULL)
SELECT ROUND(AVG(avg_order_interval),2) AS median_order_interval
FROM avg_interval_not_null
WHERE rn IN (FLOOR((total_rows+1)/2),FLOOR((total_rows+2)/2));

-- Distribution of Customer Average Purchase Intervals
WITH order_intervals AS(
	SELECT	customer_id, 
		order_date,
		LAG(order_date) OVER(PARTITION BY customer_id ORDER BY order_date) AS previous_order_date,
		DATEDIFF(order_date, LAG(order_date) OVER(PARTITION BY customer_id ORDER BY order_date)) AS days_between_orders
	FROM base_orders
    ),
avg_intervals AS(
	SELECT 
		customer_id,
		COALESCE(ROUND(AVG(days_between_orders),2), 0) AS order_interval
	FROM order_intervals
	GROUP BY customer_id)
SELECT
	CASE
		WHEN order_interval < 52 THEN 'quick'
        WHEN order_interval < 72 THEN 'medium'
        WHEN order_interval < 103 THEN 'slow'
        ELSE 'very slow'
	END AS purchase_interval_type,
    COUNT(*) AS customers  
FROM avg_intervals
GROUP BY purchase_interval_type;


/* ===================================================
   4. When and how do customers purchase?
   ===================================================*/
   
-- Monthly Purchase Pattern
WITH orders AS
	(SELECT
		*,
		DATE_FORMAT(order_date, '%Y-%m') AS `year_month`
	FROM base_orders)
SELECT
	`year_month`,
    COUNT(*) AS orders,
    LAG(COUNT(*)) OVER(ORDER BY `year_month`) AS previous_orders,
    ROUND((COUNT(*) - LAG(COUNT(*)) OVER(ORDER BY `year_month`))/LAG(COUNT(*)) OVER(ORDER BY `year_month`)*100,2) AS growth_order_pct
FROM orders
GROUP BY `year_month`;

-- Weekday Purchasing Pattern
WITH wd AS (
	SELECT *,
		CASE
			WHEN WEEKDAY(order_date) = 1 THEN 'Sunday'
			WHEN WEEKDAY(order_date) = 2 THEN 'Monday'
			WHEN WEEKDAY(order_date) = 3 THEN 'Tuesday'
			WHEN WEEKDAY(order_date) = 4 THEN 'Wednesday'
			WHEN WEEKDAY(order_date) = 5 THEN 'Thursday'
			WHEN WEEKDAY(order_date) = 6 THEN 'Friday'
			WHEN WEEKDAY(order_date) = 7 THEN 'Saturday'
		END AS weekday
	FROM base_orders)
SELECT
	weekday,
    COUNT(*)
FROM wd
GROUP BY weekday;

SELECT *
FROM base_orders
WHERE WEEKDAY(order_date) = 6;