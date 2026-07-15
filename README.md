# Customer Lifecycle Analytics for an Online Retail using SQL

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

# Methodology

## Data preparation
- Raw Data Setup: A dedicated MySQL database was created to serve as the foundation for the analytical workflow. The dataset was imported into a raw staging table, preserving the original source data before any transformations or cleaning activities were performed.
- Raw Data Validation
- Data Quality
- Data cleaning

## Data Model
A star schema was implemented to support customer lifecycle analytics.
- fact_transactions stores transaction-level records.
- dim_customers stores customer attributes.
- dim_products stores product attributes.
- dim_date supports time-based analysis and cohort calculations.

![Data Model](Images/model.png?raw=true)

## Creating base tables

## Analyse
- Customer status was determined relative to the last transaction date in the dataset, which is 2011-12-09 (the analysis date), rather than the current calendar date. This avoids bias caused by the limited observation window and reflects the customer's status at the end of the recorded period.
- for 07 customer lifetime: Customer status thresholds were derived from the observed purchase behavior of the dataset. The overall average purchase interval was 52 days, while the average customer purchase interval was 103 days (median 73 days). Based on these findings, customers were classified as:

Active: last purchase within 60 days
At Risk: last purchase between 61 and 120 days
Churned: no purchase for more than 120 days
- RFM Segmentation: 

# Key findings and Business Insights
## Customer base overview and acquisition

* The observed customer base contains **5,852 customers**, who placed **36,594 valid orders** and generated approximately **£17.07 million** in revenue during the observation period.

* On average customers placed **6.25 orders**, generated **£2,916.71 in revenue**, and remained active for approximately **274 days**. This suggests that the business has an established customer base rather than relying exclusively on isolated transactions.

* The overall **Average Order Value was £466.43**, indicating nocticeable order sizes. This is consistent with the presence of wholesale customers.

* Customer acquisition was strongest in **March 2010** with **441 customers** but subsequently became weaker. It fell from **3,288 customers during January–November 2010** to **1,509 during January–November 2011**, a decline of approximately **54%**. The business continued adding customers, but the pace of customer-base growth was slower. It is worth noting that **951 customers first observed in December 2009** should be treated as the initial observed customer base rather than as confirmed new acquisitions and **28 customers recorded in December 2011** should not be considered in acquisition analyse because the dataset contains only the first nine days of that month.

* Acquisition showed recurring strength during **September and October** in both 2010 and 2011. In addition to that, it weakened after March 2010 and at the end of 2010. This suggests that acquisition may have depended on seasonal demand.

## Customer Engagement
- Customer engagement is highly skewed. The **median customer placed only 3 orders**, while the average was **6.25**, indicating that a relatively small group of highly active customers drives overall purchasing volume. Loyal and power customers together account for about **22%** of all customers.

- Customer retention is solid, with a **72.35% repeat purchase rate**, but **27.65% of customers purchased only once**. The average time to a second purchase is approximately **99 days**, making the first three months after acquisition the most critical period for retention.

- Purchasing cycles differ significantly across customers. The **median purchase interval is about 73 days**, compared with an average of **103 days**, suggesting that most customers reorder within two to three months, while a smaller group returns much less frequently.

- Customer activity is strongly seasonal. Orders increase significantly from **September through November**, **Thursday** is the busiest purchasing day, and the **median order value (£302.55)** is well below the average (£466.43), confirming that a small number of very large orders drives the average order value.
## Customer Lifetime, Retention and Cohort Analysis
- Customers remained active for an average of **274 days** (median **223 days**), with **38.5%** staying active for more than one year. However, nearly **32%** of customers became inactive within the first month, indicating that early customer loss remains a significant challenge.

- Cohort analysis shows that customer retention declines rapidly after the acquisition month across almost all cohorts. Nevertheless, a consistent group of customers continues purchasing over extended periods, demonstrating the business's ability to build long-term customer relationships despite early loss.

- At the end of the observation period, **41.15%** of customers were classified as **Active**, **12.12%** as **At Risk**, and **46.74%** as **Churned**. Almost half of the customer base had not purchased within the defined churn threshold, highlighting customer retention as a key business challenge.

- Later cohorts generally exhibit similar retention patterns to earlier cohorts, suggesting that customer retention performance remained relatively stable over time. Future growth is therefore likely to depend more on improving retention than on increasing acquisition alone.

## Customer Segmentation

- Customer value is highly concentrated. Although **Champions (481 customers)** represent only **8.2%** of the customer base, they generated **£8.10 million**, nearly **half of the total revenue**, making them the company's most valuable customer segment.

- **Loyal customers (1,096 customers)** form the largest high-value segment, contributing **9,898 orders** and **£3.84 million** in revenue. Together, Champions and Loyal customers account for only **27% of customers** but generate the majority of business activity and revenue.

- Lifecycle segmentation shows a clear relationship between customer activity and value. **Active customers** place an average of **11.14 orders** and generate over **£5,665** each, while **Churned customers** average only **2.86 orders** and **£1,046** in revenue. Maintaining customer activity has a significant impact on long-term customer value.

- The comparison between Lifecycle and RFM segments confirms that **Champions, Loyal, and High-value customers are almost Active**, whereas **At-risk RFM customers are entirely classified as Churned**. 

## Historical Customer Lifetime Value
- The average historical CLV was **£2,916.71**, while the median was only **£856.02**, indicating a highly right-skewed customer value distribution. A relatively small number of customers generated remarkably high revenue.

- Customer value is heavily concentrated. Only **15 VIP customers (0.26%)** generated historical revenue exceeding **£100,000** each, with the highest-value customer contributing nearly **£581,000** during the observation period.

- Nearly **48% of customers** belong to the **Low CLV** segment, whereas only **19%** are classified as **High** or **VIP** customers. This highlights the importance of identifying and retaining the small group of customers that drive business performance.

- The majority of VIP customers also achieved the highest **RFM scores (R=5, F=5, M=5)**, confirming a strong relationship between purchasing frequency, recent activity, and long-term customer value.

# Business Recommendations
## Customer base overview and acquisition

1. **Investigate the causes of the acquisition decline.**
   The 54% reduction in acquisition between 2010 and 2011 is large enough to require management attention. The business should review historical marketing activity, acquisition channels, customer geography, and market conditions to determine whether the decline resulted from lower campaign activity, weaker demand or market saturation.

2. **Replicate successful acquisition activity from peak periods and increase acquisition activity before the autumn peak.**
   March 2010 and the recurring September-October should be reviewed for successful campaigns, promotions and product ranges. Proven acquisition tactics from these periods should be documented and reused in future campaigns. Marketing and sales campaigns should begin before this period.

3. **Balance acquisition investment with customer retention.**
   The business already has customers placing multiple orders and remaining active for roughly nine months on average. As acquisition slows, protecting and expanding value from existing customers becomes increasingly important. Resources should therefore be divided between acquiring new customers and encouraging existing customers to place additional orders.


4. **Develop different strategies for wholesale and smaller customers.**
   The high AOV suggests that wholesale or bulk purchasers significantly influence business performance. They should receive incentives through proactive customer services, while lower-value customers may respond better to automated retention campaigns.
## Customer Engagement

- **Implement a second-purchase campaign** targeting first-time customers between **60 and 90 days** after their initial order using reminder emails or personalized offers to increase repeat purchases.

- **Develop a loyalty strategy** by rewarding loyal and power customers with exclusive discounts or priority service while encouraging repeat customers to move into higher-value segments.

- **Prepare proactively for peak demand** by increasing inventory, marketing activity, and sales outreach before the September–November buying season to maximize seasonal revenue opportunities.

- **Align operational resources with purchasing behavior** by allocating additional customer support and order-processing capacity on high-demand weekdays, particularly **Thursdays**.

## Customer Lifetime, Retention and Cohort Analysis

- **Strengthen early customer engagement.** Since a large proportion of customers become inactive within the first month, implement welcome campaigns, product recommendations, and follow-up communications immediately after the first purchase to encourage continued engagement.

- **Prioritize retention of at-risk customers.** Customers in the **60–120 day** inactivity window should receive targeted retention campaigns, personalized promotions, or reminder emails before they transition into the churned segment.

- **Develop win-back campaigns for churned customers.** Nearly half of the customer base is classified as churned. Re-engagement campaigns with tailored offers or seasonal promotions may recover a portion of these previously valuable customers at a lower cost than acquiring new ones.

- **Monitor cohort retention as a core business KPI.** Rather than focusing solely on customer acquisition, evaluate whether marketing initiatives and customer experience improvements lead to stronger long-term customer relationships.

## Customer Segmentation
- **Prioritize retention of Champions and Loyal customers.** Provide exclusive benefits, priority service, personalized offers, and loyalty rewards to protect these customers.

- **Launch targeted win-back campaigns for At-risk and Churned customers.** Personalized promotions, product recommendations, and incentives should focus on customers whose purchasing activity has significantly declined before they are permanently lost.

- **Develop customer migration strategies between segments.** Encourage customers to progress from New to Loyal or Champion through personalized communication, loyalty programmes, and repeat-purchase incentives.

- **Allocate marketing resources according to customer value.** Invest more heavily in retaining high-value customer segments while using automated, lower-cost marketing campaigns for lower-value customers to maximize return on marketing investment.

## Historical Customer Lifetime Value
- **Prioritize retention of VIP and High-CLV customers.** Provide dedicated account management, exclusive offers, volume incentives, and personalized services to protect the customers who contribute the greatest revenue.

- **Identify customers with the potential to move into higher-value segments.** Target medium-value customers with loyalty programmes designed to increase purchase frequency and long-term customer value.

- **Allocate marketing budgets based on customer value.** Invest retention resources proportionally to historical customer value while using cost-efficient automated campaigns for lower-value customer segments.

