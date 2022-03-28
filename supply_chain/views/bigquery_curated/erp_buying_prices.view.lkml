include: "/**/*.view"

view: erp_buying_prices {

  sql_table_name: `flink-data-prod.curated.erp_buying_prices`;;

  required_access_grants: [can_view_buying_information]
  view_label: "* ERP Vendor Prices *"



  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



  # =========  __main__   =========
  dimension: net_income {
    label: "Net Income"
    description: "The incoming cash defined as net item-price"
    type: number
    sql:  ${orderline.unit_price_gross_amount} / nullif((1 + ${orderline.tax_rate}) ,0);;
    value_format_name: eur
  }

  dimension: margin_absolute {
    label: "Margin (absolute)"
    description: "The absolute margin defined as Net Income substracted by the Buying Price"
    type: number
    sql: ${net_income} - ${vendor_price} ;;
    value_format_name: eur
  }

  dimension: margin_relative {
    label: "Margin (%)"
    description: "The relative margin defined as the Margin (absolute) divided by the Net Income"
    type: number
    sql: ${margin_absolute} / nullif(${net_income},0) ;;
    value_format_name: percent_1
  }

  dimension: erp_vendor_name {
    label: "Vendor Name"
    type: string
    sql: ${TABLE}.erp_vendor_name ;;
  }

  dimension: erp_item_name {
    label: "Product Name (ERP)"
    type: string
    sql: ${TABLE}.erp_item_name ;;
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
    description: "The average buying price"
    type: average
    sql: ${TABLE}.vendor_price ;;
    value_format_name: decimal_4
  }

  measure: sum_total_net_income {
    label: "€ Total Net Income"
    description: "The sum of all unit_prices multiplied by the quantity of products sold"
    type: sum
    sql: (${orderline.quantity} * ${net_income}) ;;
    value_format_name: eur
    sql_distinct_key: concat(${table_uuid}, ${orderline.order_lineitem_uuid}) ;;
  }

  measure: sum_total_margin_abs {
    label: "€ Total Margin"
    description: "The sum of all margins defined as Net Income minus Buying Price"
    type: sum
    sql: (${orderline.quantity} * ${margin_absolute}) ;;
    value_format_name: eur
    sql_distinct_key: concat(${table_uuid}, ${orderline.order_lineitem_uuid}) ;;
  }

  measure: pct_total_margin_relative {
    label: "% Total Margin"
    description: "The € Total Margin divided by the € Total Net Income"
    type: number
    sql: ${sum_total_margin_abs} / nullif( ${sum_total_net_income} ,0);;
    value_format_name: percent_1
  }

}
