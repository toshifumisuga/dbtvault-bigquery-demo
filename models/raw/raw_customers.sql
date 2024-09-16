SELECT
    customer_id,
    first_name,
    last_name
FROM
    {{ source("dl_gss", "dl_gss_raw_customers") }}
