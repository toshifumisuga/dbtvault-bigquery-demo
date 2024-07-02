select
    id as order_id,
    user_id as customer_id,
    order_date,
    status

from `lot-data-platform-dev`.misc_datavault_test.raw_orders
