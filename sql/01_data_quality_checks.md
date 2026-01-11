Data Quality Checks
===================

This file contains exploratory SQL queries used to validate raw data
before building staging and analytics tables.

The goal is to detect:
- Null values in critical fields
- Orphan records
- Duplicates
- Data anomalies
-- Check missing order timestamps
SELECT *
FROM public.orders
WHERE order_purchase_timestamp IS NULL;

-- Product table volume
SELECT COUNT(*)
FROM public.products;

-- Distinct products sold
SELECT COUNT(DISTINCT product_id)
FROM public.order_items;

-- Missing product categories
SELECT *
FROM public.products
WHERE product_category_name IS NULL;

-- Orphan order_items
SELECT COUNT(*)
FROM public.order_items oi
LEFT JOIN public.orders o
    ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;

-- Duplicate customers
SELECT customer_id, COUNT(*)
FROM public.customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

