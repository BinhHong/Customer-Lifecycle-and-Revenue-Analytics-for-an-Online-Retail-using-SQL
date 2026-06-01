-- 1. Dataset Overview
-- 1067371 rows in the dataset
SELECT COUNT(*) AS total_rows
FROM raw_online_retail;
-- there are 53628 unique invoices
SELECT COUNT(DISTINCT Invoice) AS unique_invoices
FROM raw_online_retail;
-- there are 5132 unique products
SELECT COUNT(DISTINCT StockCode) AS unique_products
FROM raw_online_retail;
-- there are 5943 unique customers
SELECT COUNT(DISTINCT Customer_ID) AS unique_customers
FROM raw_online_retail;
-- min and max of invoice date: 2009-12-01 07:45:00 and 2011-12-09 12:50:00
SELECT MIN(InvoiceDate),
       MAX(InvoiceDate)
FROM raw_online_retail;

-- 2. Missing Values
-- there are 4382 missing descriptions and 243007 missing customer ids
SELECT
SUM(Invoice IS NULL OR Invoice='') AS missing_invoice,
SUM(StockCode IS NULL OR StockCode='') AS missing_stockcode,
SUM(Description IS NULL OR Description='') AS missing_description,
SUM(Quantity IS NULL OR Quantity='') AS missing_quantity,
SUM(InvoiceDate IS NULL OR InvoiceDate='') AS missing_invoice_date,
SUM(Price IS NULL OR Price='') AS missing_price,
SUM(Customer_ID IS NULL OR Customer_ID='') AS missing_customer_id,
SUM(Country IS NULL OR Country='') AS missing_country
FROM raw_online_retail;

-- 3. Duplicate Records
-- there are total 32907 duplicate groups
SELECT Invoice, StockCode, Description, Quantity, InvoiceDate, Price, Customer_ID, Country, COUNT(*) AS duplicate_count
FROM raw_online_retail
GROUP BY Invoice, StockCode, Description, Quantity, InvoiceDate, Price, Customer_ID, Country
HAVING COUNT(*) > 1;

-- there are total 34335 duplicate rows
SELECT SUM(duplicate_count-1) AS duplicate_rows
FROM (SELECT Invoice, StockCode, Description, Quantity, InvoiceDate, Price, Customer_ID, Country, COUNT(*) AS duplicate_count
FROM raw_online_retail
GROUP BY Invoice, StockCode, Description, Quantity, InvoiceDate, Price, Customer_ID, Country
HAVING COUNT(*) > 1) t;

-- 4. Cancellations
-- there are total 19494 cancelled transactions
SELECT COUNT(*)
FROM raw_online_retail
WHERE Invoice LIKE 'C%';

-- 5. Negative Quantities
-- there are 22950 rows with negative quantities
SELECT COUNT(*) AS negative_quantity_rows
FROM raw_online_retail
WHERE CAST(Quantity AS SIGNED) < 0;
-- because the number of negative quantities is bigger than the number of cancelled transactions, 
-- we need to find out where the extra 3,456 negative rows come from.
-- there are 19493 rows with both transactions being cancelled and Quantity being negative:
SELECT COUNT(*)
FROM raw_online_retail
WHERE Invoice LIKE 'C%'
	AND CAST(Quantity AS SIGNED) < 0;
-- this suggests that there are transactions not being cancelled but quantities are still negative (3457 rows):
SELECT COUNT(*)
FROM raw_online_retail
WHERE Invoice NOT LIKE 'C%'
	AND CAST(Quantity AS SIGNED) < 0;
-- there is only one row with cancelled transaction but positive quantity
-- C496350	M	Manual	1	2010-02-01 08:24:00	373.57		United Kingdom
-- Description = Manual suggests it is likely administrative adjustment.
-- this row is likely a data entry error or unusual cancellation record
SELECT *
FROM raw_online_retail
WHERE Invoice LIKE 'C%'
	AND CAST(Quantity AS SIGNED) >= 0;



-- 6. Invalid Prices
-- check rows with invalid prices
SELECT *
FROM raw_online_retail
WHERE CAST(Price AS DECIMAL(10,2)) <= 0;
-- there are 6225 those rows and we need to understand them
SELECT COUNT(*)
FROM raw_online_retail
WHERE CAST(Price AS DECIMAL(10,2)) <= 0;
-- Zero	6220
-- Negative	5
SELECT
CASE
    WHEN CAST(Price AS DECIMAL(10,2)) < 0 THEN 'Negative'
    WHEN CAST(Price AS DECIMAL(10,2)) = 0 THEN 'Zero'
END AS price_type,
COUNT(*) AS rows_count
FROM raw_online_retail
WHERE CAST(Price AS DECIMAL(10,2)) <= 0
GROUP BY price_type;

-- the 5 negative prices correspond to 0.0005% of the transactions. These are possibly data entry errors, corrections or accounting adjustments
-- The largest group is: NULL description = 4,382 rows
SELECT Description, COUNT(*) AS cnt
FROM raw_online_retail
WHERE CAST(Price AS DECIMAL(10,2)) = 0
GROUP BY Description
ORDER BY cnt DESC
LIMIT 20;
-- check with Description
SELECT Description,
       COUNT(*) AS cnt
FROM raw_online_retail
WHERE Description IS NULL
OR Description = ''
GROUP BY Description
ORDER BY cnt DESC;

SELECT
	CASE
		WHEN Description IS NULL THEN "null_description"
        WHEN Description = "" THEN "actual_description"
	END AS description_type,
    COUNT(*)
FROM raw_online_retail
WHERE Description IS NULL OR Description = ""
GROUP BY description_type;

-- check with StockCode


-- 7. Customer_ID Quality
-- there are 243007 customers without IDs
SELECT COUNT(*)
FROM raw_online_retail
WHERE Customer_ID IS NULL
OR Customer_ID='';

-- 8. Business Outliers
-- biggest quantities: from 80995 to 7128
SELECT *
FROM raw_online_retail
ORDER BY CAST(Quantity AS SIGNED) DESC
LIMIT 20;
-- largest prices: from 38970.0 to 10953.5
SELECT *
FROM raw_online_retail
ORDER BY CAST(Price AS DECIMAL(10,2)) DESC
LIMIT 20;