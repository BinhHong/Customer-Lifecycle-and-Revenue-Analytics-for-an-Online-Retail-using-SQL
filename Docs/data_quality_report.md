# Data Quality Report

## Missing Values

No `NULL` values were found in the raw data, missing information appears as blank strings. The dataset contains **4,382 blank product descriptions** and **243,007 blank customer IDs**.

Blank customer IDs represent approximately **22.8%** of all transaction records and will affect customer-level analyses such as RFM segmentation, cohort analysis, retention, churn, customer lifetime, and CLV.

## Duplicate Records

A total of **32,907 duplicate groups** were identified, corresponding to **34,335 redundant duplicate records**, which account for **3.22% of all observations**. Duplicate records pose a risk of inflating revenue, order frequency, and customer-level metrics and will therefore be reviewed during the cleaning phase.

## Cancellation and Return Transactions

The dataset contains **19,494 cancellation records** and **22,950 records with negative quantities**. Investigation revealed that **19,493 cancellation records** were associated with negative quantities. One exceptional record was identified as a manual transaction (`StockCode = 'M'`) with a positive quantity.

Additionally, **3,457** records contained negative quantities without a cancellation invoice prefix. Description-level inspection showed that these records are primarily linked to operational and inventory-related events such as damages, missing stock, stock checks, dotcom/Amazon set issues, and manual adjustments. These records should therefore be treated as non-standard operational adjustments rather than normal customer returns.

## Price Validation

A total of **6,225 records** contained non-positive prices, including **6,220 zero-price transactions** and **5 negative-price transactions**.

Zero-price transactions were distributed across normal product stock codes rather than being concentrated in administrative records. These transactions may represent promotional, complimentary, replacement, or bundled items rather than data-entry errors.

The five negative-price transactions represent a negligible proportion of the dataset and are associated with **Stockcode = "B"** and **Description = "Adjust bad debt"**. They are likely related to corrections or accounting adjustments. Interestingly, they are also corresponding to Invoices with prefix "A".

## Description Quality

A total of **4,382 records** contained blank product descriptions. Additional inspection identified operational descriptions such as `damaged`, `damages`, `missing`, `found`, `Adjustment`, `Dotcom`, `smashed`, and `thrown away`.

These records indicate that the dataset contains operational, inventory-related, and administrative activities in addition to standard retail sales transactions.

## Customer ID Quality

A total of **243,007 transaction records** contained blank customer IDs. While these records remain usable for transaction-level and revenue-level analysis, they cannot be used for customer-level analytics and may require separate treatment during the cleaning phase.

## StockCode Structure

Although the dataset documentation describes `StockCode` as a unique 5-digit product ID, multiple StockCode formats were identified, including product variants, administrative codes, shipping charges, gift vouchers, adjustment records, and test transactions like `M`, `BANK CHARGES`, `AMAZONFEE`, `gift_0001_20`, `C2`, `C3`, `TEST001`, `ADJUST2`.

This finding indicates that the dataset contains both retail sales and operational/accounting activities. Non-product StockCodes will be classified separately during the cleaning phase.

## Country Value

Several non-standard country values were identified, including `EIRE`, `RSA`, `European Community`, `Channel Islands`, `West Indies`, and `Unspecified`.

These values appear to represent valid business locations or regional groupings rather than data-entry errors. No country values were modified during the data quality assessment.

## Business Outliers

Several extreme quantity observations were identified. Many were associated with low-cost products and customers exhibiting wholesale purchasing behavior, which is consistent with the dataset description. Quantity outliers therefore cannot automatically be classified as data quality issues.

Extreme price outliers were primarily linked to non-product stock codes such as `M`, `AMAZONFEE`, `BANK CHARGES`, and bad debt adjustments. These records represent financial or administrative transactions rather than customer purchases and should be evaluated separately during the cleaning phase.


## Key Implications for Data Cleaning

The data quality assessment identified five major areas requiring treatment during the cleaning phase:

1. Removal of redundant duplicate records.
2. Separation of cancellation transactions, negative-quantity records, and standard sales transactions.
3. Standardization of blank descriptions and blank customer IDs as `NULL` values.
4. Classification of non-product StockCodes such as shipping charges, gift vouchers, test records, administrative records, and financial adjustments.
5. Preservation of legitimate wholesale-like transactions while excluding operational/accounting records from core retail sales analytics.