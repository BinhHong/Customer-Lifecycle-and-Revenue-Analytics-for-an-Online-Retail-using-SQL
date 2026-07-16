# Customer Lifecycle Analytics for an Online Retailer using SQL

# Executive Summary

# Business and Data Understanding

## Business Problem

The company is a UK-based non-store online retailer focusing on unique all-occasion gift products, with a substantial proportion of customers operating as wholesalers. While transaction activity and revenue generation are available, understanding customer behavior and long-term value remains critical for sustainable growth.

Management requires deeper insights into customer purchasing patterns and their impact on business performance. Key business questions include:

* Which customers generate the highest long-term value?
* How concentrated is revenue among customer groups?
* To what extent does the business depend on repeat customers?
* How quickly do customers become inactive?
* Which customer segments should receive strategic attention?

## Dataset
The Online Retail II dataset is transactional and recorded at the order-item level. One row represents one product line item within an invoice. The transactions are recorded from 2009-12-01 to 2011-12-09.

Attribute Information:
- InvoiceNo: A 6-digit integral number uniquely assigned to each transaction. If this code starts with the letter 'C', it indicates a cancellation.
- StockCode: A 5-digit integral number uniquely assigned to each distinct product.
- Description: Product name.
- Quantity: The quantities of each product per transaction.
- InvoiceDate: The day and time when a transaction was generated.
- UnitPrice: Product price per unit in sterling (£).
- CustomerID: A 5-digit integral number uniquely assigned to each customer.
- Country: The name of the country where a customer resides.

# Project Objectives

This project aims to build a SQL-based analytics framework to evaluate customer behavior through customer lifecycle analysis. The project focuses on the following analytical perspectives:

* Customer behavior and purchasing patterns
* Customer retention and churn
* Cohort analysis
* Customer segmentation using RFM and behavioral analysis
* Customer lifecycle analytics
* Customer lifetime value analysis (CLV)

The objective is to move beyond transactional reporting and develop a customer-centric analytical framework that supports business decision-making.
# Tools and SQL Techniques
- MySQL 8.0
- MySQL Workbench
- JOINs
- CTEs
- Window functions
- Cohort analysis
- RFM scoring
- Star-schema modeling
- Data-quality profiling
# Methodology

## Data Setup and Validation
The data preparation includes 4 careful and detailed steps:
- Raw Data Setup: A MySQL database was created to serve as the foundation for the analytical workflow. The dataset was imported into a raw staging table, preserving the original source data before any transformations or cleaning activities were performed.
## Data Quality Assessment
## Data cleaning and Transformation
## Data Modelling
A star schema was implemented to support customer lifecycle analytics.
- fact_transactions stores transaction-level records.
- dim_customers stores customer attributes.
- dim_products stores product attributes.
- dim_date supports time-based analysis and cohort calculations.

![Data Model](Images/model.png?raw=true)

## Creating base tables
For the purpose of analyzing the customer lifecycle 3 base tables have been created:
- base transactions
- base customers
- base orders

## Customer Analytics
The following customer lifcycle analyses has been carried out:
- customer foundation and acquisition
- customer engagement, which includes Purchase Frequency, Repeat Purchase Rate, Purchase Interval Analysis and Purchase Behavior
- customer lifetime and retention, Cohort Analysis and Churn Status
- customer segmentation, which consists of RFM Segmentation and Customer Lifecycle Segmentation
- historical CLV

# Business Insights and Recommendations

# Conclusion

The analysis shows that the retailer has a valuable repeat-purchasing customer base, but business performance is unevenly distributed. A relatively small group of Champions, Loyal customers, and VIP customers generates a large share of revenue, while almost half of the observed customer base is classified as churned.

The most important business opportunity is therefore not simply to acquire more customers. The company should protect its highest-value relationships, convert first-time buyers into repeat customers within the first three months, and intervene before inactive customers exceed the 120-day churn threshold. At the same time, the substantial decline in observed customer acquisition between 2010 and 2011 should be investigated and addressed.

Together, these actions would reduce dependence on a small group of customers, strengthen retention, and improve long-term customer value.

