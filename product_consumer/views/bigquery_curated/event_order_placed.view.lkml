view: event_order_placed {
  sql_table_name: `flink-data-dev.curated.event_order_placed`
    ;;

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~     Dimensions    ~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

  # ======= IDs ======= #

  dimension: anonymous_id {
    group_label: "IDs Dimension"
    type: string
    sql: ${TABLE}.anonymous_id ;;
  }

  dimension: checkout_id {
    group_label: "IDs Dimension"
    type: string
    sql: ${TABLE}.checkout_id ;;
  }

  dimension: device_id {
    group_label: "IDs Dimension"
    type: string
    sql: ${TABLE}.device_id ;;
  }

  dimension: event_id {
    group_label: "IDs Dimension"
    type: string
    sql: ${TABLE}.event_id ;;
  }

  dimension: order_id {
    group_label: "IDs Dimension"
    type: string
    sql: ${TABLE}.order_id ;;
  }

  dimension: order_uuid {
    group_label: "IDs Dimension"
    type: string
    sql: ${TABLE}.order_uuid ;;
  }

  dimension: user_id {
    group_label: "IDs Dimension"
    type: string
    sql: ${TABLE}.user_id ;;
  }

  # ======= Device Dimension ======= #

  dimension: app_version {
    group_label: "Device Dimension"
    type: string
    sql: ${TABLE}.app_version ;;
  }

  dimension: device_model {
    group_label: "Device Dimension"
    type: string
    sql: ${TABLE}.device_model ;;
  }

  dimension: device_type {
    group_label: "Device Dimension"
    type: string
    sql: ${TABLE}.device_type ;;
  }

  dimension: platform {
    group_label: "Device Dimension"
    type: string
    sql: ${TABLE}.platform ;;
  }

  dimension: os_version {
    group_label: "Device Dimension"
    type: string
    sql: ${TABLE}.os_version ;;
  }

  dimension: page_path {
    group_label: "Device Dimension"
    type: string
    hidden: yes
    sql: ${TABLE}.page_path ;;
  }


  # ======= Location Dimension ======= #

  dimension: country_iso {
    group_label: "Location Dimension"
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: hub_code {
    group_label: "Location Dimension"
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: locale {
    group_label: "Location Dimension"
    type: string
    sql: ${TABLE}.locale ;;
  }

  dimension: timezone {
    group_label: "Location Dimension"
    type: string
    sql: ${TABLE}.timezone ;;
  }

  # ======= Generic Dimension ======= #

  dimension: event_name {
    group_label: "Generic Dimension"
    type: string
    sql: ${TABLE}.event_name ;;
  }

  # ======= Order Dimension ======= #

  dimension: delivery_fee {
    group_label: "Order Dimension"
    type: number
    sql: ${TABLE}.delivery_fee ;;
  }

  dimension: delivery_pdt {
    group_label: "Order Dimension"
    type: number
    sql: ${TABLE}.delivery_pdt ;;
  }

  dimension: delivery_postcode {
    group_label: "Order Dimension"
    type: string
    sql: ${TABLE}.delivery_postcode ;;
  }

  dimension: currency {
    group_label: "Order Dimension"
    type: string
    sql: ${TABLE}.currency ;;
  }

  dimension: discount_code {
    group_label: "Order Dimension"
    type: string
    hidden: yes
    sql: ${TABLE}.discount_code ;;
  }

  dimension: discount_value {
    group_label: "Order Dimension"
    type: number
    sql: ${TABLE}.discount_value ;;
  }

  dimension: flag_rider_tip {
    group_label: "Order Dimension"
    type: yesno
    sql: ${TABLE}.flag_rider_tip ;;
  }

  dimension: number_of_products_ordered {
    group_label: "Order Dimension"
    type: number
    sql: ${TABLE}.number_of_products_ordered ;;
  }

  dimension: revenue {
    group_label: "Order Dimension"
    type: number
    sql: ${TABLE}.revenue ;;
  }

  dimension: rider_tip_value {
    group_label: "Order Dimension"
    type: number
    sql: ${TABLE}.rider_tip_value ;;
  }

  dimension: payment_method {
    group_label: "Order Dimension"
    type: string
    sql: ${TABLE}.payment_method ;;
  }

  dimension: products {
    group_label: "Order Dimension"
    hidden: yes
    sql: ${TABLE}.products ;;
  }

  # ======= Dates / Timestamps =======

  dimension_group: event_timestamp {
    group_label: "Date Dimension"
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
    hidden: yes
    sql: ${TABLE}.event_timestamp ;;
  }

  dimension_group: received {
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
    hidden: yes
    sql: ${TABLE}.received_at ;;
  }

  dimension_group: order {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.order_date ;;
  }

# ======= Measures =======

  measure: total_revenue {
    group_label: "Measure Dimensions"
    type: sum
    sql: ${TABLE}.revenue ;;
  }

  measure: total_rider_tip {
    group_label: "Measure Dimensions"
    type: sum
    sql: ${TABLE}.rider_tip_value ;;
  }

  measure: total_delivery_fee {
    group_label: "Measure Dimensions"
    type: sum
    sql: ${TABLE}.delivery_fee ;;
  }

  measure: total_number_orders {
    group_label: "Measure Dimensions"
    type:  count_distinct
    sql: ${TABLE}.order_uuid ;;
  }

  measure: avg_order_value {
    group_label: "Measure Dimensions"
    type: number
    sql: ${total_revenue}/${total_revenue} ;;
  }

  measure: all_users {
    group_label: "Measure Dimensions"
    description: "Number of all users regardless of their login status."
    type: count_distinct
    sql: ${TABLE}.anonymous_id ;;
  }

  measure: count {
    group_label: "Measure Dimensions"
    type: count
    drill_fields: [event_name]
  }
}
