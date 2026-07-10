/* =====================================================
   1. Customer Lifetime
   =====================================================*/

-- Average Customer Lifetime
-- Result: 273.81 days, max = 738 days and min = 0 day
SELECT
	ROUND(AVG(active_days),2) AS avg_lifetime,
    MAX(active_days) AS max_lifetime,
    MIN(active_days) AS min_lifetime
FROM base_customers;

-- Median Customer Lifetime
-- Result: 223.00 days
WITH rnumb AS(
	SELECT
		customer_id,
		active_days,
		ROW_NUMBER() OVER(ORDER BY active_days) AS rn,
        COUNT(*) OVER() AS total_rows
	FROM base_customers)
SELECT
	ROUND(AVG(active_days),2) AS mean_lifetime
FROM rnumb
WHERE rn IN(FLOOR((total_rows+1)/2), FLOOR((total_rows+2)/2));

-- Lifetime Distribution
SELECT
	CASE
		WHEN active_days <= 30 THEN '0-30 days'
        WHEN active_days <= 90 THEN '31-90 days'
        WHEN active_days <= 180 THEN '91-180 days'
        WHEN active_days <= 365 THEN '181-365 days'
        ELSE '>365 days'
	END AS lifetime_type,
    COUNT(*) AS customers
FROM base_customers
GROUP BY lifetime_type;


/* ==================================================
   2. Cohort Analysis
   ==================================================*/

-- 
WITH ch AS(
SELECT
	o.customer_id,
    c.first_order_month AS cohort,
    DATE_FORMAT(o.order_date, '%Y-%m') AS activity_month,
    TIMESTAMPDIFF(MONTH, c.first_order_date, o.order_date) AS cohort_age    
FROM base_orders o INNER JOIN base_customers c
	ON o.customer_id = c.customer_id),
active_customers AS(
	SELECT
		cohort,
		cohort_age,
		COUNT(*) AS customers
	FROM ch
	GROUP BY cohort, cohort_age)
SELECT *,
	FIRST_VALUE(customers) OVER(PARTITION BY cohort ORDER BY cohort_age) AS cohort_size,
    ROUND(customers*100/FIRST_VALUE(customers) OVER(PARTITION BY cohort ORDER BY cohort_age),2) AS retention
FROM active_customers
ORDER BY cohort, cohort_age;
