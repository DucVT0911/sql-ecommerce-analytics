# Load Olist CSV Data into PostgreSQL using Python

This document describes the **Python ingestion step** in an end-to-end analytics project:

**CSV → Python (Pandas) → PostgreSQL → SQL Modeling → Power BI**

The purpose of this script is to load raw Olist CSV files into PostgreSQL as a **raw/staging layer** for further transformation using SQL.

---

## 1. Tech Stack

- Python
- Pandas
- SQLAlchemy
- PostgreSQL
- Power BI

---

## 2. Datasets Loaded

| Table Name | CSV File |
|-----------|----------|
| customers | olist_customers_dataset.csv |
| orders | olist_orders_dataset.csv |
| order_items | olist_order_items_dataset.csv |
| payments | olist_order_payments_dataset.csv |
| reviews | olist_order_reviews_dataset.csv |
| products | olist_products_dataset.csv |
| sellers | olist_sellers_dataset.csv |
| geolocation | olist_geolocation_dataset.csv |
| category_name_translation | product_category_name_translation.csv |

---

## 3. Database Connection

The script connects to a local PostgreSQL database named `olist_analytics`.

> Replace `username` and `password` with your own PostgreSQL credentials.

---

## 4. Python Script – Load CSV to PostgreSQL

```python
import pandas as pd
from sqlalchemy import create_engine

# Create PostgreSQL engine
engine = create_engine(
    "postgresql://username:password@localhost:5432/olist_analytics"
)

# Path to CSV files
bath = "C:\\Users\\Trong Duc Vu\\Desktop\\Datasets\\Olist\\"

# Mapping between table names and CSV files
files = {
    "customers": "olist_customers_dataset.csv",
    "orders": "olist_orders_dataset.csv",
    "order_items": "olist_order_items_dataset.csv",
    "payments": "olist_order_payments_dataset.csv",
    "reviews": "olist_order_reviews_dataset.csv",
    "products": "olist_products_dataset.csv",
    "sellers": "olist_sellers_dataset.csv",
    "geolocation": "olist_geolocation_dataset.csv",
    "category_name_translation": "product_category_name_translation.csv"
}

# Load each CSV into PostgreSQL
for table, file in files.items():
    df = pd.read_csv(bath + file)
    df.to_sql(table, engine, if_exists="replace", index=False)
    print(f"{table} loaded successfully.")
```
---
## 5. What This Script Does

- Connects to PostgreSQL using SQLAlchemy

- Reads CSV files using Pandas

- Loads each dataset into PostgreSQL

- Replaces existing tables if they already exist

- Creates a raw data layer for analytics

- This layer is intentionally kept clean but unmodeled, allowing SQL to handle business logic and transformations later.
---
## 6. Next Steps in the Project
**SQL (PostgreSQL)**

- Data cleaning and type casting

- Star schema modeling

- Fact and dimension tables

- Business logic implementation

**Power BI**

- Connect to PostgreSQL

- Build semantic model

- Write DAX measures

- Design dashboards
---
## 7. Recommended Project Structure
```sql-ecommerce-analytics/
├── data/
│   └── data_source.md
├── sql/
│   ├── staging/
│   ├── marts/
│   └── star_schema/
├── dashboard/
│   └── powerbi_screenshots.md
├── etl/
│   └── load_csv_python.md
└── README.md
```
---
## 8. Why This Approach

- Reproducible ETL process

- Clear separation between raw data and analytics layer

- Scalable and production-oriented

- Mirrors real-world Data Analyst / Analytics Engineer workflows

This file documents the Python ingestion layer of the Olist Analytics project.
