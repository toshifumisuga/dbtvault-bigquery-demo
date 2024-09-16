SELECT
    order_id,
    customer_id,
    order_date,
    status
FROM
    {{ source("dl_gss", "dl_gss_raw_orders") }}
