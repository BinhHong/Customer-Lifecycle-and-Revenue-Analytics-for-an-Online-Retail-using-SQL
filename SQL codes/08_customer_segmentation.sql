/* =================================================
   1. RFM Segmentation
   =================================================*/

-- 
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
		NTILE(5) OVER(ORDER BY recency DESC) AS R,
		NTILE(5) OVER(ORDER BY frequency) AS F,
		NTILE(5) OVER(ORDER BY monetary) AS M
	FROM summary
	ORDER BY customer_id
	)
SELECT
	CASE
		WHEN R=5 AND F=5 AND M=5 THEN 'champion'
        WHEN R>=4 AND F>=3 AND M=5 THEN 'valuable customer'
        WHEN R>=4 AND F>=4 THEN 'loyal customer'
        WHEN R=5 AND F=1 THEN 'new customer'
        WHEN R<=2 AND F>=4 THEN 'at risk'
        WHEN R=1 AND F=1 AND M=1 THEN 'low valued customer'
	END AS segment,
    COUNT(*) AS customers
FROM rfm
GROUP BY segment;