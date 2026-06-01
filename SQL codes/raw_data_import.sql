CREATE DATABASE online_retail_analysis DEFAULT CHARACTER SET utf8mb4;
USE online_retail_analysis;

DROP TABLE IF EXISTS raw_online_retail;

CREATE TABLE raw_online_retail (

    Invoice VARCHAR(50),
    StockCode VARCHAR(50),
    Description TEXT,
    Quantity VARCHAR(50),
    InvoiceDate VARCHAR(50),
    Price VARCHAR(50),
    Customer_ID VARCHAR(50),
    Country VARCHAR(100)

);

SET GLOBAL local_infile = 1;

SHOW GLOBAL VARIABLES LIKE 'local_infile';

SHOW VARIABLES LIKE 'local_infile';
SHOW GLOBAL VARIABLES LIKE 'local_infile';

LOAD DATA LOCAL INFILE 'C:/Users/Binh_Hong_Ngoc/Meine Daten/SQL/Projects/Customer Lifecycle and Revenue Analytics for an Online Retail using SQL/Dataset/online_retail_II.csv'
INTO TABLE raw_online_retail
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(Invoice, StockCode, Description, Quantity, InvoiceDate, Price, Customer_ID, Country);