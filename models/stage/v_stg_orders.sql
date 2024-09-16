{{ config(materialized='view') }}

{%- set yaml_metadata -%}
source_model: 'raw_orders_payments_customers'
derived_columns:
  ORDER_KEY: 'order_id'
  CUSTOMER_KEY: 'customer_id'
  # 後続で意味をなすので、一旦説明は割愛
  # !をつけることで、定数として定義されます。
  RECORD_SOURCE: '!raw_orders_payments_customers'
  # source_model側のcreate_time等を利用して、作成されたタイミングの日付を残す。
  # → 変更履歴を管理するため、該当データがいつ時点で作成されたものか、という情報が有用です。
  EFFECTIVE_FROM: 'order_date'
  # バッチの実行タイミング等を残すもの。
  # 何かバグがあった時に、いつ作成されたデータなのか判断する際に利用。
  LOAD_DATE: CURRENT_DATE('Asia/Tokyo')
  START_DATE: "order_date"
  END_DATE: "DATE('9999-12-31')"
  
# PKがupdateされることは基本的にはないはずですが、履歴管理が目的なのでここをハッシュ化します。
# source_model側が持っているカラムのうち、PKに該当するものをハッシュ化し、複数ある場合は変更履歴の保持のため、その組み合わせもハッシュ化する
hashed_columns:
  ORDER_PK:
    - ORDER_KEY
  CUSTOMER_PK:
    - CUSTOMER_KEY
  LINK_ORDER_CUSTOMER_PK:
    - ORDER_KEY
    - CUSTOMER_KEY
    
  # 元のテーブルに含まれるテーブルのカラムを、項目ごとにハッシュ化する。
  # → 該当カラムの一部に変更があったときに、このハッシュ値の差分を見ることでレコード単位で変化に気付けるようになる。
  ORDER_HASHDIFF:
    is_hashdiff: true
    columns:
      - ORDER_KEY
      - CUSTOMER_KEY
      - EFFECTIVE_FROM
      - 'status'
  PAYMENT_HASHDIFF:
    is_hashdiff: true
    columns:
      - ORDER_KEY
      - 'payment_method'
      - 'amount'
  CUSTOMER_HASHDIFF:
    is_hashdiff: true
    columns:
      - CUSTOMER_KEY
      - 'first_name'
      - 'last_name'
# 今回は利用しませんが、以下のような定義も可能
# null_columns:
#   required: 
#     - customer_id
#   optional:
#     - CUSTOMER_REF
#     - NATIONALITY 
# ranked_columns:
#    AUTOMATE_DV_RANK:
#    partition_by: customer_id
#    order_by: BOOKING_DATE
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}
{% set source_model = metadata_dict['source_model'] %}
{% set derived_columns = metadata_dict['derived_columns'] %}
{% set hashed_columns = metadata_dict['hashed_columns'] %}

{{ automate_dv.stage(
            include_source_columns=true,
            source_model=source_model,
            derived_columns=derived_columns,
            hashed_columns=hashed_columns,
            ranked_columns=none
            ) 
}}
