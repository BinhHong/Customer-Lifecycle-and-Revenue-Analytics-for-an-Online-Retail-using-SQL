# Customer-Lifecycle-and-Revenue-Analytics-for-an-Online-Retail-using-SQL

# 1. Business & Data Understanding


## Business Problem

The company is a UK-based non-store online retailer specializing in unique all-occasion gift products, with a substantial proportion of customers operating as wholesalers. While transaction activity and revenue generation are available, understanding customer behavior and long-term value remains critical for sustainable growth.

Management requires deeper insight into customer purchasing patterns and their impact on business performance. Key business questions include:

* Which customers generate the highest long-term value?
* How concentrated is revenue among customer groups?
* To what extent does the business depend on repeat customers?
* How quickly do customers become inactive?
* Which customer segments should receive strategic attention?

The objective is to move beyond transactional reporting and develop a customer-centric analytical framework that supports business decision-making.


Note: date 2009-12-01 07:45:00 to 2011-12-09 12:50:00
---

## Project Objectives

This project aims to build a SQL-based analytics framework to evaluate customer behavior and revenue performance through customer lifecycle analysis.

The project focuses on three analytical perspectives:

### Customer Intelligence

* Analyze customer purchasing behavior
* Identify high-value customer segments
* Understand customer lifecycle patterns
* Measure customer engagement and purchasing frequency

### Revenue Intelligence

* Analyze revenue generation patterns
* Evaluate revenue concentration across customers
* Measure customer contribution to business performance

### Retention Intelligence

* Assess customer retention and churn patterns
* Analyze customer survival behavior over time
* Evaluate long-term customer value and lifecycle development

---

## Data Granularity (Grain Definition)

The dataset is transactional and recorded at the order-item level.

**Grain definition:**

> One row represents one product line item within a transaction (invoice).

This implies:

* One invoice may contain multiple products
* One customer may place multiple invoices
* Revenue calculations must consider transaction-level aggregation
* Customer-level metrics require transformation from transactional data

Understanding the data grain is critical to avoid aggregation errors and double-counting issues during analysis.

---

## Business Entities

The following analytical entities are derived from the transactional dataset:

### Customer

Represents individual customers and their purchasing behavior.

Potential analytical metrics:

* Customer lifetime
* Total revenue contribution
* Purchase frequency
* First and most recent purchase activity

### Orders

Represents transaction-level activity.

Potential analytical metrics:

* Order value
* Number of products per order
* Order frequency

### Products

Represents individual items sold by the business.

Potential analytical metrics:

* Product popularity
* Quantity sold
* Product revenue contribution

### Time

Derived from transaction timestamps.

Potential analytical metrics:

* Monthly trends
* Cohort periods
* Seasonal patterns

### Geography

Represents customer location information.

Potential analytical metrics:

* Revenue distribution by country
* Customer distribution by country

---

## Initial Assumptions

Attribute Information:
InvoiceNo: Invoice number. Nominal. A 6-digit integral number uniquely assigned to each transaction. If this code starts with the letter 'c', it indicates a cancellation.
StockCode: Product (item) code. Nominal. A 5-digit integral number uniquely assigned to each distinct product.
Description: Product (item) name. Nominal.
Quantity: The quantities of each product (item) per transaction. Numeric.
InvoiceDate: Invice date and time. Numeric. The day and time when a transaction was generated.
UnitPrice: Unit price. Numeric. Product price per unit in sterling (Â£).
CustomerID: Customer number. Nominal. A 5-digit integral number uniquely assigned to each customer.
Country: Country name. Nominal. The name of the country where a customer resides.

The following assumptions are established before data profiling and validation:

* Invoice numbers beginning with **"C"** indicate canceled transactions.
* Negative quantities are expected to represent returned items.
* Missing customer identifiers likely indicate anonymous transactions.
* Initial revenue calculations are based on:

Revenue = Quantity × UnitPrice

* Customer behavior may vary between wholesalers and regular customers.

These assumptions will be validated and refined during the data quality assessment phase.

---

## Metric Definitions & Assumptions

Metric definitions will remain provisional until exploratory profiling and data quality assessment are completed.

Definitions to be finalized include:

* Active Customer
* Repeat Customer
* Customer Churn
* Customer Retention
* Revenue Definition
* Customer Lifetime Value (CLV) methodology

These definitions will establish analytical consistency across all subsequent phases of the project.

## Success Metrics

This project is considered successful if it delivers:

* A reusable SQL analytical framework for customer lifecycle and revenue analysis
* Reliable customer and revenue metrics derived from transactional data
* Meaningful customer segmentation using RFM and behavioral analysis
* Retention and churn insights that support business decision-making
* Actionable recommendations based on customer and revenue patterns
* A reproducible and well-documented analytical workflow

---

## Analytical Scope

### Included Scope

The project focuses on:

* Customer lifecycle analytics
* Revenue analytics
* Customer segmentation
* Cohort analysis
* Customer retention and churn
* Customer behavior and purchasing patterns
* Customer value analysis (CLV)

### Excluded Scope

The following areas are outside the scope of this project:

* Profitability analysis (cost information unavailable)
* Marketing attribution analysis
* Inventory analysis
* Machine learning or predictive modeling

## Raw Data Setup

A dedicated MySQL database was created to serve as the foundation for the analytical workflow. The Online Retail II dataset was imported into a raw staging table, preserving the original source data before any transformations or cleaning activities were performed.

Key activities completed during this phase:

* Created the project database (`online_retail_analysis`)
* Imported the complete Online Retail II transactional dataset into a raw staging table
* Validated import integrity through row-count and structure verification
* Established a reproducible raw data layer to support subsequent data quality assessment and transformation processes

This raw layer serves as the single source of truth throughout the project and remains unchanged during later analytical stages.



# To do next:
- in 6: invalid prices, check with Stockcode (done)
- correct words with missing and empty (e.g. misisng Descriptions or empty Desc?) right from the start (done)
- 01 data quality: step 4 fertig (done)
- Description: what does B mean? they are all associated with negative Prices, Description "Adjust bad debt" and Customer IDs are blank.
- what does StockCode = 'M', Description = 'Manual' mean? they are in the only row with C invoice (meaning cancellation) and negative quantity.
- kha nang cao la nen kiem tra cac Stockcode toan letters, khong co so. Kha nang chi co 3 loai: 5 chu so, 5 chu so va 1 letter, toan letter?
- Nho no: sua lai 1 ti Phase 4 data cleaning: nicht mehr "return" but "negative quantity", 
6. data model.sql xong nhung chua chay