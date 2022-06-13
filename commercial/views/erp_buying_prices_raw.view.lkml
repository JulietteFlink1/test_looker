include: "/**/*.view"

view: erp_buying_prices_raw {

  sql_table_name: `flink-data-prod.curated.erp_buying_prices`;;

  required_access_grants: [can_view_buying_information]
  view_label: "* ERP Vendor Prices *"

  dimension: erp_vendor_name {
    label: "Vendor Name"
    type: string
    sql: ${TABLE}.erp_vendor_name ;;

    # this field is not part of the refactored table anymore, but can be derived from e.g. erp_product_hub_vendor_assignment_v2
    hidden: no
  }

  dimension: erp_item_name {
    label: "Product Name (ERP)"
    type: string
    sql: ${TABLE}.erp_item_name ;;

    # this field is not part of the refactored table anymore, but can be derived from e.g. erp_product_hub_vendor_assignment_v2
    hidden: yes
  }

  dimension: valid_to {
    label: "Price Valid To"
    type: date
    convert_tz: no
    datatype: date
    sql: ${TABLE}.valid_to ;;
  }

  dimension: valid_from {
    label: "Price Valid From"
    type: date
    convert_tz: no
    datatype: date
    sql: ${TABLE}.valid_from ;;
  }

  dimension: is_price_promotional {
    label: "Is Promotional Price"
    description: "Yes/No: Is the price a special promo price or the regular price"
    type: yesno
    sql: ${TABLE}.is_price_promotional ;;
  }

  dimension: vendor_price {
    label: "Buying Price"
    type: number
    sql: ${TABLE}.vendor_price ;;
    value_format_name: decimal_4
  }



  # =========  hidden   =========
  dimension: currency {
    type: string
    sql: ${TABLE}.currency ;;
    hidden: yes
  }

  dimension_group: ingestion_timestamp {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.ingestion_timestamp ;;
    hidden: yes
  }

  dimension: report_date {
    type: date
    datatype: date
    sql: ${TABLE}.ingestion_timestamp ;;
    hidden: no
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
    # for joining only
    hidden: yes
  }

  dimension: erp_vendor_id {
    type: string
    sql: ${TABLE}.erp_vendor_id ;;
    # for joining only
    hidden: yes
  }

  dimension: erp_warehouse_id {
    type: string
    sql: ${TABLE}.erp_warehouse_id ;;
    # for joining only
    hidden: yes
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
    # for joining only
    hidden: yes
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
    # for joining only
    hidden: yes
  }

  measure: ctn_skus {

    label: "# Unique SKUs"

    type: count_distinct
    sql: ${sku} ;;
  }

  # =========  IDs   =========
  dimension: table_uuid {
    type: string
    sql: ${TABLE}.table_uuid ;;
    hidden: yes
    primary_key: yes
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


  measure: avg_vendor_price {
    label: "AVG Buying Price"
    description: "The  sum of COGS divided by the sum of Item Quantity Sold"
    type: average
    sql: ${vendor_price} ;;
    value_format_name: decimal_4
  }

  }
