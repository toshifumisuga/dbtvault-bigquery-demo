{%- set yaml_metadata -%}
source_model: stg_order
src_pk: ORDER_PK
src_ldts: LOAD_DATE
as_of_dates_table: as_of_date
bridge_walk:
  CUSTOMER_ORDER:
    bridge_link_pk: LINK_ORDER_CUSTOMER_PK
    bridge_end_date: END_DATE
    bridge_load_date: LOAD_DATE
    link_table: l_customer_order
    link_pk: LINK_ORDER_CUSTOMER_PK
    link_fk1: CUSTOMER_FK
    link_fk2: ORDER_FK
    eff_sat_table: eff_sat
    eff_sat_pk: LINK_ORDER_CUSTOMER_PK
    eff_sat_end_date: END_DATE
    eff_sat_load_date: LOAD_DATE
stage_tables_ldts:
  stg_customer: LOAD_DATE
  stg_order: LOAD_DATE
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{% set source_model = metadata_dict["source_model"] %}
{% set src_pk = metadata_dict["src_pk"] %}
{% set src_ldts = metadata_dict["src_ldts"] %}
{% set as_of_dates_table = metadata_dict["as_of_dates_table"] %}
{% set bridge_walk = metadata_dict["bridge_walk"] %}
{% set stage_tables_ldts = metadata_dict["stage_tables_ldts"] %}

{{ automate_dv.bridge(source_model=source_model,
                    src_pk=src_pk,
                    src_ldts=src_ldts,
                    bridge_walk=bridge_walk,
                    as_of_dates_table=as_of_dates_table,
                    stage_tables_ldts=stage_tables_ldts) }} 
