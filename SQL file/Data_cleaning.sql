---Check duplicate order IDs

SELECT
    order_id,
    COUNT(*) AS Duplicate_Count
FROM dbo.olist_orders_dataset
GROUP BY order_id
HAVING COUNT(*) > 1;

---Check missing values

SELECT
    COUNT(*) AS Total_Orders,
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END)
        AS Missing_Order_ID,
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END)
        AS Missing_Customer_ID,
    SUM(CASE WHEN order_purchase_timestamp IS NULL THEN 1 ELSE 0 END)
        AS Missing_Purchase_Date,
    SUM(CASE WHEN order_delivered_customer_date IS NULL THEN 1 ELSE 0 END)
        AS Missing_Delivery_Date
FROM dbo.olist_orders_dataset;

---Check order status

SELECT
    order_status,
    COUNT(*) AS Total_Orders
FROM dbo.olist_orders_dataset
GROUP BY order_status
ORDER BY Total_Orders DESC;

---Check invalid numeric values

SELECT
    COUNT(*) AS Total_Rows,
    SUM(CASE
        WHEN TRY_CONVERT(DECIMAL(18,2), price) IS NULL
        THEN 1 ELSE 0
    END) AS Invalid_Price_Rows,
    SUM(CASE
        WHEN TRY_CONVERT(DECIMAL(18,2), freight_value) IS NULL
        THEN 1 ELSE 0
    END) AS Invalid_Freight_Rows
FROM dbo.olist_order_items_dataset;

---Create analysis views

CREATE OR ALTER VIEW dbo.vw_Orders_Clean AS
SELECT
    order_id,
    customer_id,
    order_status,

    TRY_CONVERT(DATETIME2, order_purchase_timestamp)
        AS order_purchase_timestamp,

    TRY_CONVERT(DATETIME2, order_delivered_customer_date)
        AS order_delivered_customer_date,

    TRY_CONVERT(DATETIME2, order_delivered_carrier_date)
        AS order_delivered_carrier_date,

    TRY_CONVERT(DATETIME2, order_approved_at)
        AS order_approved_at,

    TRY_CONVERT(DATETIME2, order_estimated_delivery_date)
        AS order_estimated_delivery_date

FROM dbo.olist_orders_dataset;


---Create a clean Order Items view

CREATE OR ALTER VIEW dbo.vw_Order_Items_Clean AS
SELECT
    order_id,
    order_item_id,
    product_id,
    seller_id,

    TRY_CONVERT(DATETIME2, shipping_limit_date)
        AS shipping_limit_date,

    TRY_CONVERT(DECIMAL(18,2), price)
        AS price,

    TRY_CONVERT(DECIMAL(18,2), freight_value)
        AS freight_value,

    TRY_CONVERT(DECIMAL(18,2), price)
      + TRY_CONVERT(DECIMAL(18,2), freight_value)
        AS Total_Item_Value

FROM dbo.olist_order_items_dataset;


---Create a clean Payments view

CREATE OR ALTER VIEW dbo.vw_Payments_Clean AS
SELECT
    order_id,
    TRY_CONVERT(INT, payment_sequential)
        AS payment_sequential,
    payment_type,
    TRY_CONVERT(INT, payment_installments)
        AS payment_installments,
    TRY_CONVERT(DECIMAL(18,2), payment_value)
        AS payment_value
FROM dbo.olist_order_payments_dataset;

---Create a clean Products view

CREATE OR ALTER VIEW dbo.vw_Products_Clean AS
SELECT
    product_id,
    product_category_name,
    TRY_CONVERT(DECIMAL(18,2), product_weight_g)
        AS product_weight_g
FROM dbo.olist_products_dataset;
