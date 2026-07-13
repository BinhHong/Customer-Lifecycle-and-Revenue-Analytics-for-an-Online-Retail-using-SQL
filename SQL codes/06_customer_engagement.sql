/* ==================================================
   1. Customer Purchase Frequency
   ==================================================*/
   
-- Average orders per customer
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

-- Distribution of total orders
SELECT
    total_orders,
    COUNT(*) AS customers,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),2) AS pct_customers
FROM base_customers
GROUP BY total_orders
ORDER BY total_orders;

-- Purchase Frequency Segmentation
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
-- Result: 99.02 days in average
WITH sc_order AS(
	SELECT
		customer_id,
		order_date AS first_order_date,
		LEAD(order_date) OVER(PARTITION BY customer_id ORDER BY order_date) AS second_order_date,
		ROW_NUMBER() OVER(PARTITION BY customer_id) AS rn
	FROM base_orders),
	sc AS(
	SELECT
		customer_id, first_order_date, second_order_date, 
		DATEDIFF(second_order_date, first_order_date) AS days_to_second_order
	FROM sc_order
	WHERE rn = 1)
SELECT
	ROUND(AVG(days_to_second_order),2) AS avg_days_to_second_order
FROM sc;

/* ===================================================
   3. Purchase Interval Analysis
   ===================================================*/

-- Overall Average Purchase Inverval
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
-- Result: 103.43 days
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
-- Result: 72.88 days
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
		WHEN order_interval < 31 THEN '<30 days'
        WHEN order_interval < 91 THEN '31-90 days'
        WHEN order_interval < 181 THEN '91-180 days'
        ELSE '>180 days'
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
WITH wd AS(
	SELECT
		CASE
			WHEN WEEKDAY(order_date) = 6 THEN 'Sunday'
			WHEN WEEKDAY(order_date) = 0 THEN 'Monday'
			WHEN WEEKDAY(order_date) = 1 THEN 'Tuesday'
			WHEN WEEKDAY(order_date) = 2 THEN 'Wednesday'
			WHEN WEEKDAY(order_date) = 3 THEN 'Thursday'
			WHEN WEEKDAY(order_date) = 4 THEN 'Friday'
			WHEN WEEKDAY(order_date) = 5 THEN 'Saturday'
		END AS weekday,
		COUNT(*) AS orders
	FROM base_orders
	GROUP BY weekday)
SELECT
	*,
    ROUND(orders/SUM(orders) OVER()*100,2) AS weekday_pct
FROM wd;

-- Basket size
-- Result: 20.93 products per order and 286.90 quantity per order in average
SELECT
	ROUND(AVG(distinct_products),2) AS avg_product,
    ROUND(AVG(total_quantity),2) AS avg_quantity
FROM base_orders;

-- Recall that AOV = 466.43, min = 0.38 and max = 168469.60
SELECT 
	ROUND(SUM(total_revenue)/COUNT(*),2) AS aov,
    MIN(total_revenue) AS min_order_value,
    MAX(total_revenue) AS max_order_value
FROM base_orders;

-- Median Order Value
-- Result: 302.55. So order values are right-skewed distributed.
WITH rnumber AS(
	SELECT
		invoice_no,
		total_revenue,
		ROW_NUMBER() OVER(ORDER BY total_revenue) AS rn,
		COUNT(*) OVER() AS total_rows
	FROM base_orders)
SELECT
	ROUND(AVG(total_revenue),2) AS median_order_value
FROM rnumber
WHERE rn IN(FLOOR((total_rows+1)/2),FLOOR((total_rows+2)/2));

-- Order Value Distribution
SELECT
	CASE
		WHEN total_revenue < 10 THEN '<10 €'
        WHEN total_revenue < 50 THEN '10-50 €'
        WHEN total_revenue < 302 THEN '50-302 €'
        WHEN total_revenue < 466 THEN '302-466 €'
        WHEN total_revenue < 1000 THEN '466-1000 €'
        ELSE '>1000 €'
	END AS order_value_type,
    COUNT(*) AS orders
FROM base_orders
GROUP BY order_value_type;