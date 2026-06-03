/*

The purpose of this script is to import the raw data into the table raw_online_retail. 
All data is preserved

*/

-- create a database named online_retail_analysis where the project is carried out
CREATE DATABASE online_retail_analysis DEFAULT CHARACTER SET utf8mb4;
USE online_retail_analysis;

DROP TABLE IF EXISTS raw_online_retail;


-- create table raw_online_retail to store data. 
-- Note that datatype VARCHAR is used to keep the integrity of the original data
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


-- The following script serves as an efficient method to import data, 
-- since import by TABLE DATA IMPORT WIZARD has showed to be extremely slow
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