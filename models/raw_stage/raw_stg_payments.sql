SELECT
    order_id,
    payment_method,
    amount
FROM
    {{ source("dl_gss", "dl_gss_raw_payments") }}
