-- =========================================================
-- Product Category Translation & Macro Category Mapping
-- =========================================================
-- This script:
-- 1. Translates Portuguese product categories to English
-- 2. Maps detailed categories into high-level macro categories
-- 3. Builds the product dimension table for analytics
-- =========================================================


-- ---------------------------------------------------------
-- Category name translation (PT -> EN)
-- ---------------------------------------------------------
DROP TABLE IF EXISTS stg.category_translation;

CREATE TABLE stg.category_translation AS
SELECT
    product_category_name,
    product_category_name_english
FROM public.category_name_translation;


-- ---------------------------------------------------------
-- Staging: Products
-- ---------------------------------------------------------
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


-- ---------------------------------------------------------
-- Dimension: Products with Macro Category Mapping
-- ---------------------------------------------------------
DROP TABLE IF EXISTS mart.dim_products;

CREATE TABLE mart.dim_products AS
SELECT
    p.product_id,

    -- Original and translated category
    p.product_category_name AS initial_category_name,
    COALESCE(t.product_category_name_english, 'Other') AS product_category_name,

    -- Macro category mapping
    CASE

        /* =========================
           HOME & FURNITURE
        ========================== */
        WHEN t.product_category_name_english IN (
            'bed_bath_table',
            'furniture_decor',
            'furniture_living_room',
            'furniture_bedroom',
            'furniture_mattress_and_upholstery',
            'office_furniture',
            'home_appliances',
            'home_appliances_2',
            'air_conditioning'
        ) THEN 'Home & Furniture'


        /* =========================
           HOME DECOR & GARDEN
        ========================== */
        WHEN t.product_category_name_english IN (
            'housewares',
            'garden_tools',
            'party_supplies',
            'stationery',
            'home_comfort',
            'home_comfort_2'
        ) THEN 'Home Decor & Garden'


        /* =========================
           FASHION & ACCESSORIES
        ========================== */
        WHEN t.product_category_name_english IN (
            'fashion_bags_accessories',
            'fashion_shoes',
            'fashion_male_clothing',
            'fashion_female_clothing',
            'fashion_underwear_beach',
            'fashion_sport',
            'watches_gifts'
        ) THEN 'Fashion & Accessories'


        /* =========================
           BEAUTY & HEALTH
        ========================== */
        WHEN t.product_category_name_english IN (
            'health_beauty',
            'perfumery',
            'baby',
            'diapers_and_hygiene'
        ) THEN 'Beauty & Health'


        /* =========================
           ELECTRONICS & APPLIANCES
        ========================== */
        WHEN t.product_category_name_english IN (
            'electronics',
            'computers_accessories',
            'telephony',
            'fixed_telephony',
            'tablets_printing_image',
            'small_appliances',
            'small_appliances_home_oven_and_coffee'
        ) THEN 'Electronics & Appliances'


        /* =========================
           SPORTS, TOYS & LEISURE
        ========================== */
        WHEN t.product_category_name_english IN (
            'sports_leisure',
            'toys',
            'cool_stuff'
        ) THEN 'Sports, Toys & Leisure'


        /* =========================
           BOOKS & MEDIA
        ========================== */
        WHEN t.product_category_name_english IN (
            'books_general_interest',
            'books_technical',
            'books_imported',
            'cds_dvds_musicals'
        ) THEN 'Books & Media'


        /* =========================
           FOOD, PETS & SERVICES
        ========================== */
        WHEN t.product_category_name_english IN (
            'food',
            'food_drink',
            'drinks',
            'pet_shop',
            'services',
            'security_and_services',
            'signaling_and_security',
            'industry_commerce_and_business',
            'agro_industry_and_commerce'
        ) THEN 'Food, Pets & Services'


        /* =========================
           FALLBACK
        ========================== */
        ELSE 'Other'
    END AS macro_category,

    -- Physical attributes
    p.product_weight_g,
    p.product_length_cm,
    p.product_height_cm,
    p.product_width_cm

FROM stg.products p
LEFT JOIN stg.category_translation t
    ON p.product_category_name = t.product_category_name;


-- ---------------------------------------------------------
-- Validation checks
-- ---------------------------------------------------------

-- Check duplicate product_id
SELECT
    product_id,
    COUNT(*) AS cnt
FROM mart.dim_products
GROUP BY product_id
HAVING COUNT(*) > 1;

-- Check missing products in fact table
SELECT
    COUNT(*) AS missing_items
FROM mart.fact_order_items oi
LEFT JOIN mart.dim_products p
    ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;

-- Categories without English translation
SELECT DISTINCT
    p.product_category_name
FROM stg.products p
LEFT JOIN stg.category_translation t
    ON p.product_category_name = t.product_category_name
WHERE t.product_category_name_english IS NULL;

-- Category distribution
SELECT
    macro_category,
    COUNT(*) AS product_count
FROM mart.dim_products
GROUP BY macro_category
ORDER BY product_count DESC;

SELECT
    product_category_name,
    macro_category,
    COUNT(*) AS product_count
FROM mart.dim_products
GROUP BY product_category_name, macro_category
ORDER BY macro_category, product_count DESC;
