/* ================================================
   sth
   ================================================*/
   
-- base_sales_transactions
DROP TABLE IF EXISTS base_sales_transactions;

CREATE TABLE base_sales_transactions
SELECT *
FROM fact_transactions
WHERE stockcode_type = 'product'
	AND customer_id IS NOT NULL
    AND is_cancelled = 0
	AND is_negative_quantity = 0
    AND is_negative_price = 0;
    
-- base_orders
DROP TABLE IF EXISTS base_orders;

