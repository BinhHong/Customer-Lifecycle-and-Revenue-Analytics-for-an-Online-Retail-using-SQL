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
	ROUND(AVG(active_days),2) AS median_lifetime
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

-- Cohort Count Table
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
		COUNT(DISTINCT customer_id) AS customers
	FROM ch
	GROUP BY cohort, cohort_age)
SELECT
	cohort,
    SUM(CASE WHEN cohort_age = 0 THEN customers END) AS month0,
    SUM(CASE WHEN cohort_age = 1 THEN customers END) AS month1,
    SUM(CASE WHEN cohort_age = 2 THEN customers END) AS month2,
    SUM(CASE WHEN cohort_age = 3 THEN customers END) AS month3,
    SUM(CASE WHEN cohort_age = 4 THEN customers END) AS month4,
    SUM(CASE WHEN cohort_age = 5 THEN customers END) AS month5,
    SUM(CASE WHEN cohort_age = 6 THEN customers END) AS month6,
    SUM(CASE WHEN cohort_age = 7 THEN customers END) AS month7,
    SUM(CASE WHEN cohort_age = 8 THEN customers END) AS month8,
    SUM(CASE WHEN cohort_age = 9 THEN customers END) AS month9,
    SUM(CASE WHEN cohort_age = 10 THEN customers END) AS month10,
    SUM(CASE WHEN cohort_age = 11 THEN customers END) AS month11,
    SUM(CASE WHEN cohort_age = 12 THEN customers END) AS month12,
    SUM(CASE WHEN cohort_age = 13 THEN customers END) AS month13,
    SUM(CASE WHEN cohort_age = 14 THEN customers END) AS month14,
    SUM(CASE WHEN cohort_age = 15 THEN customers END) AS month15,
    SUM(CASE WHEN cohort_age = 16 THEN customers END) AS month16,
    SUM(CASE WHEN cohort_age = 17 THEN customers END) AS month17,
    SUM(CASE WHEN cohort_age = 18 THEN customers END) AS month18,
    SUM(CASE WHEN cohort_age = 19 THEN customers END) AS month19,
    SUM(CASE WHEN cohort_age = 20 THEN customers END) AS month20,
    SUM(CASE WHEN cohort_age = 21 THEN customers END) AS month21,
    SUM(CASE WHEN cohort_age = 22 THEN customers END) AS month22,
    SUM(CASE WHEN cohort_age = 23 THEN customers END) AS month23,
    SUM(CASE WHEN cohort_age = 24 THEN customers END) AS month24
FROM active_customers
GROUP BY cohort
ORDER BY cohort;


-- Cohort Retention Table
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
	GROUP BY cohort, cohort_age),
cohort_table AS(
	SELECT
		cohort,
		SUM(CASE WHEN cohort_age = 0 THEN customers END) AS month0,
		SUM(CASE WHEN cohort_age = 1 THEN customers END) AS month1,
		SUM(CASE WHEN cohort_age = 2 THEN customers END) AS month2,
		SUM(CASE WHEN cohort_age = 3 THEN customers END) AS month3,
		SUM(CASE WHEN cohort_age = 4 THEN customers END) AS month4,
		SUM(CASE WHEN cohort_age = 5 THEN customers END) AS month5,
		SUM(CASE WHEN cohort_age = 6 THEN customers END) AS month6,
		SUM(CASE WHEN cohort_age = 7 THEN customers END) AS month7,
		SUM(CASE WHEN cohort_age = 8 THEN customers END) AS month8,
		SUM(CASE WHEN cohort_age = 9 THEN customers END) AS month9,
		SUM(CASE WHEN cohort_age = 10 THEN customers END) AS month10,
		SUM(CASE WHEN cohort_age = 11 THEN customers END) AS month11,
		SUM(CASE WHEN cohort_age = 12 THEN customers END) AS month12,
		SUM(CASE WHEN cohort_age = 13 THEN customers END) AS month13,
		SUM(CASE WHEN cohort_age = 14 THEN customers END) AS month14,
		SUM(CASE WHEN cohort_age = 15 THEN customers END) AS month15,
		SUM(CASE WHEN cohort_age = 16 THEN customers END) AS month16,
		SUM(CASE WHEN cohort_age = 17 THEN customers END) AS month17,
		SUM(CASE WHEN cohort_age = 18 THEN customers END) AS month18,
		SUM(CASE WHEN cohort_age = 19 THEN customers END) AS month19,
		SUM(CASE WHEN cohort_age = 20 THEN customers END) AS month20,
		SUM(CASE WHEN cohort_age = 21 THEN customers END) AS month21,
		SUM(CASE WHEN cohort_age = 22 THEN customers END) AS month22,
		SUM(CASE WHEN cohort_age = 23 THEN customers END) AS month23,
		SUM(CASE WHEN cohort_age = 24 THEN customers END) AS month24
	FROM active_customers
	GROUP BY cohort
	)
SELECT
	cohort,
	ROUND(month0*100/month0,2) AS month0,
    ROUND(month1*100/month0,2) AS month1,
    ROUND(month2*100/month0,2) AS month2,
    ROUND(month3*100/month0,2) AS month3,
    ROUND(month4*100/month0,2) AS month4,
    ROUND(month5*100/month0,2) AS month5,
    ROUND(month6*100/month0,2) AS month6,
    ROUND(month7*100/month0,2) AS month7,
    ROUND(month8*100/month0,2) AS month8,
    ROUND(month9*100/month0,2) AS month9,
    ROUND(month10*100/month0,2) AS month10,
    ROUND(month11*100/month0,2) AS month11,
    ROUND(month12*100/month0,2) AS month12,
    ROUND(month13*100/month0,2) AS month13,
    ROUND(month14*100/month0,2) AS month14,
    ROUND(month15*100/month0,2) AS month15,
    ROUND(month16*100/month0,2) AS month16,
    ROUND(month17*100/month0,2) AS month17,
    ROUND(month18*100/month0,2) AS month18,
    ROUND(month19*100/month0,2) AS month19,
    ROUND(month20*100/month0,2) AS month20,
    ROUND(month21*100/month0,2) AS month21,
    ROUND(month22*100/month0,2) AS month22,
    ROUND(month23*100/month0,2) AS month23,
    ROUND(month24*100/month0,2) AS month24
FROM cohort_table;
-- Interpretation:
-- Month 0 represents the acquisition month (100%).
-- Subsequent months show the percentage of customers
-- from the original cohort who remained active.


/* ==================================================
   3. Churn and Retention Status
   ==================================================*/

-- Churn and Retention Status
WITH analysis AS(
	SELECT
		customer_id,    
		DATEDIFF((SELECT MAX(order_date) FROM base_orders), last_order_date) AS days_since_last_purchase
	FROM base_customers
	)
SELECT
	CASE
		WHEN days_since_last_purchase <= 60 THEN 'Active'
        WHEN days_since_last_purchase <= 120 THEN 'At risk'
        ELSE 'Churned'
	END AS status,
    COUNT(*) AS customers,
    ROUND(COUNT(*)*100/SUM(COUNT(*)) OVER(),2) AS pct
FROM analysis
GROUP BY status;