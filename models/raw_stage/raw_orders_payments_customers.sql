{{ config(materialized='view') }}

SELECT
    raw_orders.order_id,
    raw_orders.customer_id,
    raw_orders.order_date,
    raw_orders.status,
    raw_payments.payment_method,
    raw_payments.amount,
    raw_customers.first_name,
    raw_customers.last_name
FROM
    {{ source("dl_gss", "dl_gss_raw_orders") }} AS raw_orders
LEFT JOIN
    {{ source("dl_gss", "dl_gss_raw_payments") }} AS raw_payments
    ON
        raw_orders.order_id = raw_payments.order_id
LEFT JOIN
    {{ source("dl_gss", "dl_gss_raw_customers") }} AS raw_customers
    ON
        raw_orders.customer_id = raw_customers.customer_id
