# Customer Lifecycle Analytics in SQL: From Raw Data to Business Insights

# Executive Summary

This project develops a complete SQL-based customer lifecycle analytics framework using the Online Retail II dataset. Starting from raw transactional data, the project performs data validation, data quality assessment, data cleaning, star schema modelling, and customer analytics to understand customer behaviour throughout the customer lifecycle.

The analysis focuses on customer acquisition, engagement, retention, segmentation, and historical customer lifetime value (CLV). The objective is to move beyond transactional reporting and provide actionable business insights and recommendations that support customer-centric decision-making.

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
The Online Retail II dataset is recorded at the order-item level. One row represents one product line item within an invoice. The transactions are recorded from 2009-12-01 to 2011-12-09.

Attribute Information:
- InvoiceNo: A 6-digit integral number uniquely assigned to each transaction. If this code starts with the letter 'C', it indicates a cancellation.
- StockCode: A 5-digit integral number uniquely assigned to each distinct product.
- Description: Product name.
- Quantity: The quantities of each product per transaction.
- InvoiceDate: The day and time when a transaction was generated.
- UnitPrice: Product price per unit in sterling (£).
- CustomerID: A 5-digit integral number uniquely assigned to each customer.
- Country: The name of the country where a customer resides.

# Tools and SQL Techniques
- MySQL 8.0 
- MySQL Workbench
- JOINs
- CTEs
- Window functions
- CASE Expressions
- Star Schema Modelling
- Cohort Analysis
- RFM Segmentation

# Methodology

## Data Preparation
The data preparation includes 3 careful and detailed steps:
- [Raw Data Setup and Validation](SQL%20codes/00_raw_data_validation.sql)
- [Data Quality Assessment](SQL%20codes/01_data_quality.sql) and [Data Quality Report](Docs/data_quality_report.md)
- [Data Cleaning and Transformation](SQL%20codes/02_data_cleaning.sql)
## Data Modelling
A star schema was implemented to support customer lifecycle analytics.
- fact_transactions stores transaction-level records.
- dim_customers stores customer attributes.
- dim_products stores product attributes.
- dim_date supports time-based analysis and cohort calculations.

[View Data Model Diagram](Images/model.png)

## Analytical base tables
To simplify customer lifecycle analysis, 3 reusable base tables were created:
- base transactions
- base customers
- base orders

## Customer Analytics
The following customer lifecycle analyses have been carried out:
- [customer foundation and acquisition](SQL%20codes/05_customer_metrics.sql)
- [customer engagement](SQL%20codes/06_customer_engagement.sql), which includes Purchase Frequency, Repeat Purchase Rate, Purchase Interval Analysis and Purchase Behavior
- [customer lifetime and retention, Cohort Analysis and Churn Status](SQL%20codes/07_customer_lifetime_and_retention.sql)
- [customer segmentation](SQL%20codes/08_customer_segmentation.sql), which consists of RFM Segmentation and Customer Lifecycle Segmentation
- [historical CLV](SQL%20codes/09_historical_clv.sql)

# Business Insights and Recommendations
Business insights and recommendations are available in:
- [View Business Insights](Docs/Business_insights.md)
- [View Recommendations](Docs/Recommendations.md)
# Conclusion

The analysis shows that the retailer has a valuable repeat-purchasing customer base, but business performance is unevenly distributed. A relatively small group of Champions, Loyal customers, and VIP customers generates a large share of revenue, while almost half of the observed customer base is classified as churned.

The analysis suggests that sustainable business growth depends not only on acquiring new customers but also on increasing customer retention and maximizing customer lifetime value.. The company should protect its highest-value relationships, convert first-time buyers into repeat customers within the first three months, and intervene before inactive customers exceed the 120-day churn threshold. At the same time, the substantial decline in observed customer acquisition between 2010 and 2011 should be investigated and addressed.

Together, these actions would reduce dependence on a small group of customers, strengthen retention, and improve long-term customer value.