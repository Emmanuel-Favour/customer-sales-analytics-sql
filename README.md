# 🧠 Advanced SQL Customer & Sales Insights Project

This project focuses on in-depth data exploration and reporting using the AdventureWorks 2005 database. It simulates a real-world business intelligence scenario where customer and sales data are extracted, cleaned, and analyzed to generate meaningful insights for business decisions.
Hi there, you can view the Query sheet [here](https://docs.google.com/spreadsheets/d/1aFGKyx8Xj9u5qSSREf7iSbXgePJHcEeXlHDC7rkZBCU/edit?gid=654943228#gid=654943228)
📊 Project Overview
The project is structured into two key parts:

> Customer Intelligence
The first part centers on customer profiling, segmentation, and activity analysis. It explores how individual customers engage with the business and how their transactions and behaviors can be monitored for targeting and retention strategies.

Key features implemented:

* Extraction of detailed customer identity, contact, and location data.
* Sales metrics such as total number of orders, total spend (with tax), and most recent order date.
* Smart addressing system with a fallback if formal titles are missing.
* Classification of customers as Active or Inactive based on their engagement over the past year.
* Segmentation of high-value dormant customers.
* Breakdown of address lines into structured components.
* Targeted extraction of North American customers who exceed spending or frequency thresholds.

> Sales Reporting & Analytics
This section focuses on building scalable reporting logic to understand business performance across geographies and time periods.

Highlights include:

* Monthly sales reporting at the Country and Region level.
* Aggregated metrics: number of orders, unique customers, sales representatives, and revenue (including tax).
* Cumulative revenue tracking for temporal trends.
* Regional performance ranking system based on revenue.
* Country-level tax insights:
* ean tax rate calculation using the highest tax per state.
* Percentage of states with tax data to ensure transparency in metrics.

> 🛠️ Technologies Used

* AdventureWorks2005 Sample Database from BigQuery data warehouse
* Common Table Expressions (CTEs)
* Subqueries, Window Functions
* Data Aggregation, Ranking, String Parsing
