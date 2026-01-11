-- Category translation
DROP TABLE IF EXISTS stg.category_translation;
CREATE TABLE stg.category_translation AS
SELECT
    product_category_name,
    product_category_name_english
FROM public.category_name_translation;

-- Staging: Products
DROP TABLE IF EXISTS stg.products;
CREATE TABLE stg.products AS
SELECT
    product_id,
    product_category_name,
    product_weight_g::numeric,
    product_length_cm::numeric,
    product_height_cm::numeric,
    product_width_cm::numeric
FROM public.products;

-- Dimension: Products
DROP TABLE IF EXISTS mart.dim_products;
CREATE TABLE mart.dim_products AS
SELECT
    p.product_id,
    COALESCE(t.product_category_name_english, 'Other') AS product_category_name,
    CASE
        WHEN t.product_category_name_english IN (
            'bed_bath_table','furniture_decor','office_furniture'
        ) THEN 'Home & Furniture'
        WHEN t.product_category_name_english IN (
            'housewares','garden_tools'
        ) THEN 'Home Decor & Garden'
        WHEN t.product_category_name_english IN (
            'fashion_bags_accessories','fashion_shoes'
        ) THEN 'Fashion & Accessories'
        ELSE 'Other'
    END AS macro_category,
    p.product_weight_g,
    p.product_length_cm,
    p.product_height_cm,
    p.product_width_cm
FROM stg.products p
LEFT JOIN stg.category_translation t
    ON p.product_category_name = t.product_category_name;
