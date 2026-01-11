CREATE SCHEMA IF NOT EXISTS mart;

-- Fact table: Orders (order-level grain)
DROP TABLE IF EXISTS mart.fact_orders;
CREATE TABLE mart.fact_orders AS
WITH payment_per_order AS (
    SELECT
        order_id,
        MAX(payment_type) AS payment_type
    FROM stg.payments
    GROUP BY order_id
),
reviews AS (
    SELECT
        order_id,
        AVG(review_score) AS average_score
    FROM stg.reviews
    GROUP BY order_id
)
SELECT
    o.order_id,
    o.order_status,
    o.order_purchase_ts,
    o.order_purchase_ts::date AS order_date,
    c.customer_unique_id,
    p.payment_type,
    r.average_score,
    COUNT(*) AS total_items,
    SUM(oi.price) AS order_revenue
FROM stg.orders o
JOIN stg.order_items oi ON o.order_id = oi.order_id
JOIN stg.customers c ON o.customer_id = c.customer_id
LEFT JOIN payment_per_order p ON o.order_id = p.order_id
LEFT JOIN reviews r ON o.order_id = r.order_id
GROUP BY
    o.order_id,
    o.order_status,
    o.order_purchase_ts,
    c.customer_unique_id,
    p.payment_type,
    r.average_score;

CREATE INDEX idx_fact_orders_date
ON mart.fact_orders (order_purchase_ts);

-- Fact table: Order Items
DROP TABLE IF EXISTS mart.fact_order_items;
CREATE TABLE mart.fact_order_items AS
SELECT
    oi.order_id,
    oi.product_id,
    oi.seller_id,
    oi.price AS item_price,
    oi.freight_value
FROM stg.order_items oi
JOIN stg.orders o ON oi.order_id = o.order_id;
