CREATE DATABASE Olist_Store_Analysis;

USE Olist_Store_Analysis;

SELECT 'Orders' AS Table_Name, COUNT(*) AS Total_Rows
FROM dbo.olist_orders_dataset

UNION ALL

SELECT 'Customers', COUNT(*)
FROM dbo.olist_customers_dataset

UNION ALL

SELECT 'Order_Items', COUNT(*)
FROM dbo.olist_order_items_dataset

UNION ALL

SELECT 'Payments', COUNT(*)
FROM dbo.olist_order_payments_dataset

UNION ALL

SELECT 'Reviews', COUNT(*)
FROM dbo.olist_order_reviews_dataset

UNION ALL

SELECT 'Products', COUNT(*)
FROM dbo.olist_products_dataset

UNION ALL

SELECT 'Sellers', COUNT(*)
FROM dbo.olist_sellers_dataset

UNION ALL

SELECT 'Geolocation', COUNT(*)
FROM dbo.olist_geolocation_dataset

UNION ALL

SELECT 'Category_Translation', COUNT(*)
FROM dbo.product_category_name_translation;