SELECT
    order_id,
    customer_id,
    order_date,
    status,
    update_date
FROM
    {{ source("dl_gss", "dl_gss_raw_orders") }}
