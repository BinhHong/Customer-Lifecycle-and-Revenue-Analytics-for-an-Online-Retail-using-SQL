# Customer-Lifecycle-and-Revenue-Analytics-for-an-Online-Retail-using-SQL

# 1. Business & Data Understanding
# Phase 1 — Business & Data Understanding

## Business Problem

The company is a UK-based non-store online retailer specializing in unique all-occasion gift products, with a substantial proportion of customers operating as wholesalers. While transaction activity and revenue generation are available, understanding customer behavior and long-term value remains critical for sustainable growth.

Management requires deeper insight into customer purchasing patterns and their impact on business performance. Key business questions include:

* Which customers generate the highest long-term value?
* How concentrated is revenue among customer groups?
* To what extent does the business depend on repeat customers?
* How quickly do customers become inactive?
* Which customer segments should receive strategic attention?

The objective is to move beyond transactional reporting and develop a customer-centric analytical framework that supports business decision-making.

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
