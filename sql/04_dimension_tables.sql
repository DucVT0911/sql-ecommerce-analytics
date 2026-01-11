-- Dimension: Customers
DROP TABLE IF EXISTS mart.dim_customers;
CREATE TABLE mart.dim_customers AS
SELECT
    customer_unique_id,
    customer_city,
    customer_state
FROM (
    SELECT
        c.customer_unique_id,
        c.customer_city,
        c.customer_state,
        ROW_NUMBER() OVER (
            PARTITION BY c.customer_unique_id
            ORDER BY o.order_purchase_ts DESC
        ) AS rn
    FROM stg.customers c
    JOIN stg.orders o
        ON c.customer_id = o.customer_id
) t
WHERE rn = 1;

-- Dimension: Date
DROP TABLE IF EXISTS mart.dim_date;
CREATE TABLE mart.dim_date AS
WITH date_range AS (
    SELECT generate_series(
        MIN(order_purchase_ts)::date,
        MAX(order_purchase_ts)::date,
        '1 day'::interval
    )::date AS date
    FROM stg.orders
)
SELECT
    date,
    EXTRACT(YEAR FROM date) AS year,
    EXTRACT(MONTH FROM date) AS month,
    EXTRACT(DAY FROM date) AS day,
    EXTRACT(QUARTER FROM date) AS quarter,
    EXTRACT(DOW FROM date) AS weekday
FROM date_range;

-- Dimension: Sellers
DROP TABLE IF EXISTS mart.dim_sellers;
CREATE TABLE mart.dim_sellers AS
SELECT DISTINCT
    seller_id,
    seller_city,
    seller_state
FROM public.sellers;
