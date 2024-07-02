{%- set yaml_metadata -%}
source_model: 'raw_stg_orders'
derived_columns:
  ORDER_KEY: 'order_id'
  RECORD_SOURCE: '!order'
  # source_model側のcreate_time等を利用して、作成されたタイミングの日付を残す。
  # → 変更履歴を管理するため、該当データがいつ時点で作成されたものか、という情報が有用です。
  EFFECTIVE_FROM: 'order_date'
  # バッチの実行タイミング等を残すもの。
  # 何かバグがあった時に、いつ作成されたデータなのか判断する際に利用。
  LOAD_DATE: CURRENT_DATE()
  
# PKがupdateされることは基本的にはないはずですが、履歴管理が目的なのでここをハッシュ化します。
# source_model側が持っているカラムのうち、PKに該当するものをハッシュ化し、複数ある場合は変更履歴の保持のため、その組み合わせもはハッシュ化する
hashed_columns:
  ORDER_PK:
    - 'order_id'
  CUSTOMER_PK:
    - 'customer_id'
  LINK_ORDER_CUSTOMER_PK:
    - 'order_id'
    - 'customer_id'
    
  # 元のテーブルに含まれるテーブルのカラムを全て選択してハッシュ化する
  # → 該当カラムの一部に変更があったときに、このカラムだけで差分を見ることでレコード単位で変化に気付けるようになる。
  ORDER_HASHDIFF:
    is_hashdiff: true
    columns:
      - 'customer_id'
      - 'order_id'
      - 'order_date'
      - 'status'
{%- endset -%}

{% set metadata_dict = fromyaml(yaml_metadata) %}

{% set source_model = metadata_dict['source_model'] %}

{% set derived_columns = metadata_dict['derived_columns'] %}

{% set hashed_columns = metadata_dict['hashed_columns'] %}

{{ automate_dv.stage(include_source_columns=true,
                    source_model=source_model,
                    derived_columns=derived_columns,
                    hashed_columns=hashed_columns,
                    ranked_columns=none) }}
