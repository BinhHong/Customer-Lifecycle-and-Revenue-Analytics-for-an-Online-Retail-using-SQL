/* =================================================
   1. RFM Segmentation
   =================================================*/

-- RFM Segmentation
WITH summary AS(
	SELECT
		customer_id,
		DATEDIFF((SELECT MAX(order_date) FROM base_orders), last_order_date) AS recency,
		total_orders AS frequency,
		total_revenue AS monetary
	FROM base_customers
	),
rfm AS(
	SELECT
		customer_id,
        recency,
        frequency,
        monetary,
		NTILE(5) OVER(ORDER BY recency DESC) AS R,
		NTILE(5) OVER(ORDER BY frequency) AS F,
		NTILE(5) OVER(ORDER BY monetary) AS M
	FROM summary
	ORDER BY customer_id
	)
SELECT
	CASE
		WHEN R=5 AND F=5 AND M=5 THEN 'Champions'
        WHEN R>=4 AND F>=4 THEN 'Loyal customers'
        WHEN R>=4 AND F>=3 AND M=5 THEN 'High-value customers'        
        WHEN R=5 AND F=1 THEN 'New customers'
        WHEN R<=2 AND F>=4 THEN 'At risk'
        ELSE 'Others'
	END AS Segment,
    COUNT(*) AS Customers,
    SUM(frequency) AS Total_orders,
    SUM(monetary) AS Revenue,
    ROUND(SUM(monetary)/SUM(frequency),2) AS Average_order_value
FROM rfm
GROUP BY Segment;


/* =================================================
   2. Customer Lifecycle Segmentation
   =================================================*/
   
-- Customer Lifecycle Segmentation
WITH analysis AS(
	SELECT *,
		DATEDIFF((SELECT MAX(order_date) FROM base_orders),last_order_date) AS days_since_last_purchase,
		DATEDIFF((SELECT MAX(order_date) FROM base_orders),first_order_date) AS days_since_first_purchase
	FROM base_customers
	)
SELECT
	CASE
		WHEN days_since_first_purchase <=30 THEN 'New'
		WHEN days_since_last_purchase <= 60 THEN 'Active'
        WHEN days_since_last_purchase <= 120 THEN 'At risk'
        ELSE 'Churned'
	END AS Lifecycle_stage,
    COUNT(*) AS Customers,
    ROUND(AVG(total_orders),2) AS Avg_orders,
    ROUND(AVG(total_revenue),2) AS Avg_revenue
FROM analysis
GROUP BY Lifecycle_stage;

-- Lifecycle vs RFM
WITH analysis AS(
	SELECT *,
		DATEDIFF((SELECT MAX(order_date) FROM base_orders),last_order_date) AS days_since_last_purchase,
		DATEDIFF((SELECT MAX(order_date) FROM base_orders),first_order_date) AS days_since_first_purchase
	FROM base_customers
	),
summary AS(
	SELECT
		customer_id,
		total_orders,
		total_revenue,
		days_since_last_purchase,
		days_since_first_purchase
	FROM analysis
	),
rfm AS(
	SELECT 
		*,
		NTILE(5) OVER(ORDER BY days_since_last_purchase DESC) AS R,
		NTILE(5) OVER(ORDER BY total_orders) AS F,
		NTILE(5) OVER(ORDER BY total_revenue) AS M
	FROM summary
	),
lifecycle AS(
	SELECT
		customer_id,
		CASE
			WHEN R=5 AND F=5 AND M=5 THEN 'champions'
            WHEN R>=4 AND F>=4 THEN 'loyal customers'
			WHEN R>=4 AND F>=3 AND M=5 THEN 'valuable customers'			
			WHEN R=5 AND F=1 THEN 'new customers'
			WHEN R<=2 AND F>=4 THEN 'at risk'
			ELSE 'others'
		END AS RFM_Segment,
		CASE
			WHEN days_since_first_purchase <=30 THEN 'New'
			WHEN days_since_last_purchase <= 60 THEN 'Active'
			WHEN days_since_last_purchase <= 120 THEN 'At risk'
			ELSE 'Churned'
		END AS Lifecycle
	FROM rfm
	)
SELECT
	Lifecycle,
    COUNT(CASE WHEN RFM_Segment = 'champions' THEN customer_id END) AS 'Champions',
    COUNT(CASE WHEN RFM_Segment = 'valuable customers' THEN customer_id END) AS 'Valuable customers',
    COUNT(CASE WHEN RFM_Segment = 'loyal customers' THEN customer_id END) AS 'Loyal customers',
    COUNT(CASE WHEN RFM_Segment = 'new customers' THEN customer_id END) AS 'New customers',
    COUNT(CASE WHEN RFM_Segment = 'at risk' THEN customer_id END) AS 'At risk',
	COUNT(CASE WHEN RFM_Segment = 'others' THEN customer_id END) AS 'Others'
FROM lifecycle
GROUP BY Lifecycle;