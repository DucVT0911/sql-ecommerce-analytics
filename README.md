SQL E-Commerce Analytics Project
================================

Overview
--------
This project analyzes a real-world e-commerce dataset (100,000+ orders)
with a strong focus on advanced SQL analytics, business insights,
and end-to-end analytics data modeling.

The project demonstrates how raw transactional data can be transformed
into decision-ready analytics using Python, PostgreSQL, and Power BI.


Dataset
-------
- Brazilian E-Commerce Public Dataset by Olist
- Source: Kaggle
- Size: approximately 100,000 orders
- Data covers customers, orders, payments, products, sellers, and reviews


Tools and Technologies
----------------------
- Python: data ingestion (CSV to PostgreSQL)
- PostgreSQL: data storage, transformation, and analytics
- pgAdmin 4: database management
- SQL: CTEs, window functions, cohort analysis, star schema modeling
- Power BI: data visualization and dashboarding
- DAX: business metrics and advanced analytics


Project Workflow
================

Step 1: Data Ingestion (Python)
-------------------------------
- Load raw CSV files into PostgreSQL using pandas and SQLAlchemy
- Ingest data as-is into the public schema
- No cleaning or transformation is performed in Python
- Python is used strictly for data ingestion and automation


Step 2: Data Quality Assessment (SQL)
-------------------------------------
- Validate data completeness and integrity
- Check null values in critical fields (timestamps, prices, categories)
- Identify orphan records (order_items without matching orders)
- Detect duplicates and inconsistent primary / foreign keys
- Explore data anomalies such as zero-price items and missing categories


Step 3: Data Cleaning and Staging (SQL)
---------------------------------------
- Create a staging schema (stg) for cleaned data
- Standardize timestamps and data types
- Remove invalid, canceled, or incomplete transactions
- Normalize and prepare orders, customers, products, payments,
  reviews, and sellers for analytics consumption


Step 4: Analytics Data Modeling (SQL)
-------------------------------------
- Build an analytics schema (mart) using a star schema design
- Define correct table grain for analysis
  - fact_orders (order-level metrics)
  - fact_order_items (item-level metrics)
- Create dimension tables
  - dim_customers
  - dim_products with category mapping
  - dim_sellers
  - dim_date
- SQL acts as the single source of truth for analytics


Step 5: Business Metrics and Advanced Analytics (Power BI DAX)
--------------------------------------------------------------
- Implement business logic using DAX in Power BI
- Core metrics include
  - Total Revenue
  - Total Orders
  - Quantity Sold
  - Average Order Value (AOV)
  - Orders per Customer
  - New vs Returning Customers
  - Customer Repeat Rate
  - Customer Retention by Cohort
  - Month-over-Month Growth
  - Year-over-Year Growth
  - Contribution and performance analysis


Step 6: Visualization and Reporting (Power BI)
----------------------------------------------
- Connect Power BI directly to PostgreSQL analytics tables
- Build interactive dashboards with multiple report pages
  - Executive Overview
  - Sales Performance Analysis
  - Product and Category Performance
  - Customer and Geographic Insights
- Focus on translating data into actionable business insights


End-to-End Architecture
=======================
CSV Files
Python Data Ingestion
PostgreSQL Raw Tables (public schema)
SQL Staging Layer (stg)
SQL Analytics Layer (mart)
Power BI Data Model
DAX Measures
Business Dashboards


Key Business Questions
=====================
- How does revenue evolve over time?
- How do new and returning customers contribute to total sales?
- What is the customer repeat and retention behavior?
- Which products and categories drive the most revenue?
- How does customer purchasing behavior change across cohorts?
- What factors influence order value and repeat purchases?


Repository Structure
====================
- /sql
  - data quality checks
  - staging transformations
  - analytics and mart modeling
- /powerbi
  - Power BI report file
