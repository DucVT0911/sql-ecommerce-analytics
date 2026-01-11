```
-- Create staging schema
CREATE SCHEMA IF NOT EXISTS stg;

-- Staging: Orders
DROP TABLE IF EXISTS stg.orders;
CREATE TABLE stg.orders AS
SELECT
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp::timestamp AS order_purchase_ts,
    order_delivered_customer_date::timestamp AS delivered_ts,
    order_estimated_delivery_date::timestamp AS estimated_ts
FROM public.orders
WHERE order_purchase_timestamp IS NOT NULL;

-- Staging: Customers
DROP TABLE IF EXISTS stg.customers;
CREATE TABLE stg.customers AS
SELECT DISTINCT
    customer_id,
    customer_unique_id,
    customer_city,
    customer_state
FROM public.customers;

-- Staging: Order Items
DROP TABLE IF EXISTS stg.order_items;
CREATE TABLE stg.order_items AS
SELECT
    order_id,
    product_id,
    seller_id,
    price,
    freight_value
FROM public.order_items
WHERE price > 0;

-- Staging: Payments
DROP TABLE IF EXISTS stg.payments;
CREATE TABLE stg.payments AS
SELECT
    order_id,
    payment_type,
    payment_installments::int,
    payment_value::numeric
FROM public.payments;

-- Staging: Reviews
DROP TABLE IF EXISTS stg.reviews;
CREATE TABLE stg.reviews AS
SELECT
    review_id,
    order_id,
    review_score::int,
    review_creation_date::date,
    review_answer_timestamp::timestamp
FROM public.reviews;
```
