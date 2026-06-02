# Data Quality Report

## Missing Values

No SQL `NULL` values were found in the raw import. Missingness appears as blank strings. The dataset contains **4,382 blank product descriptions** and **243,007 blank customer identifiers**.

Blank customer identifiers represent approximately **22.8% of all transaction records** and will affect customer-level analyses such as RFM segmentation, cohort analysis, retention, churn, customer lifetime, and CLV.

## Duplicate Records

A total of **32,907 duplicate groups** were identified, corresponding to **34,335 redundant duplicate records** (**3.22% of all observations**). Duplicate records have the potential to inflate revenue, order frequency, and customer-level metrics and will therefore be reviewed during the cleaning phase.

## Cancellation and Return Transactions

The dataset contains **19,494 cancellation records** and **22,950 records with negative quantities**. Investigation revealed that **19,493 cancellation records** were associated with negative quantities. One exceptional record was identified as a manual transaction (`StockCode = 'M'`) with a positive quantity.

Additionally, **3,457 records** contained negative quantities without a corresponding cancellation invoice, suggesting the presence of returns, adjustments, or other non-standard transaction types.

## Price Validation

A total of **6,225 records** contained non-positive prices, including **6,220 zero-price transactions** and **5 negative-price transactions**.

Zero-price transactions were distributed across normal product stock codes rather than being concentrated in administrative records. These transactions may represent promotional, complimentary, replacement, or bundled items rather than data-entry errors.

The five negative-price transactions represent a negligible proportion of the dataset and are likely associated with corrections or accounting adjustments.

## Description Quality

A total of **4,382 records** contained blank product descriptions. Additional inspection identified operational descriptions such as `damaged`, `damages`, `missing`, `found`, `Adjustment`, `Dotcom`, `smashed`, and `thrown away`.

These records indicate that the dataset contains operational, inventory-related, and administrative activities in addition to standard retail sales transactions.

## Customer Identifier Quality

A total of **243,007 transaction records** contained blank customer identifiers. While these records remain usable for transaction-level and revenue-level analysis, they cannot be used for customer-level analytics and may require separate treatment during the cleaning phase.

## Business Outliers

Several extreme quantity observations were identified. Many were associated with low-cost products and customers exhibiting wholesale purchasing behavior, which is consistent with the dataset description. Quantity outliers therefore cannot automatically be classified as data quality issues.

Extreme price outliers were primarily linked to non-product stock codes such as `M`, `AMAZONFEE`, `BANK CHARGES`, and bad debt adjustments. These records represent financial or administrative transactions rather than customer purchases and should be evaluated separately during the cleaning phase.

## Key Implications for Data Cleaning

The data quality assessment identified four major areas requiring treatment during the cleaning phase:

1. Removal of redundant duplicate records.
2. Separation of cancellations, returns, and standard sales transactions.
3. Treatment of blank customer identifiers for customer-level analyses.
4. Identification and exclusion of administrative and financial adjustment records from retail sales analytics.
