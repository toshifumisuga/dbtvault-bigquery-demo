{%- set source_model = "stg_order" -%}
{%- set src_pk = "LINK_ORDER_CUSTOMER_PK" -%}
{%- set src_fk = ["ORDER_PK", "CUSTOMER_PK"] -%}
{%- set src_ldts = "LOAD_DATE" -%}
{%- set src_source = "RECORD_SOURCE" -%}

{{ automate_dv.hub(
        src_pk=src_pk,
        src_nk=src_nk,
        src_ldts=src_ldts,
        src_source=src_source,
        source_model=source_model
    ) 
}}
