view: discounts {
  sql_table_name: `flink-data-dev.dbt_jdavies_curated.discounts`;;

  dimension: discount_id {
    hidden: yes
    type: string
    sql: ${TABLE}.discount_id ;;
    group_label: "> IDs"

  }

  dimension: discount_uuid {
    hidden: yes
    primary_key: yes
    type: string
    sql: ${TABLE}.discount_uuid ;;
    group_label: "> IDs"
  }

  dimension: cart_discount_id {
    label: "Card Discount ID"
    type: string
    sql: ${TABLE}.cart_discount_id ;;
    group_label: "> IDs"
  }

  dimension: cart_discount_type {
    label: "Card Discount Type"
    type: string
    hidden:  yes
    sql: ${TABLE}.cart_discount_type ;;
  }

  dimension: discount_value_type {
    label: "Discount Value Type"
    type: string
    sql: ${TABLE}.discount_value_type ;;
  }

  dimension: backend_source {
    label: "Backend Source"
    type: string
    sql: ${TABLE}.backend_source ;;
  }

  dimension: minimum_order_value {
    label: "Minimum Order Value"
    type: number
    sql: ${TABLE}.minimum_order_value ;;
  }

  dimension_group: created {
    label: "Discount Code Creation"
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
    sql: ${TABLE}.created_at ;;
  }

  dimension: discount_code {
    label: "Discount Code"
    type: string
    sql: ${TABLE}.discount_code ;;
  }

  dimension: discount_description {
    label: "Discount Code Description"
    type: string
    sql: ${TABLE}.discount_description ;;
  }

  dimension: discount_group {
    label: "Discount Code Group"
    type: string
    sql: ${TABLE}.discount_group ;;
  }

  dimension: discount_name {
    label: "Discount Code Name"
    type: string
    sql: ${TABLE}.discount_name ;;
  }

  dimension: is_active {
    label: "Discount Code Is Active"
    type: yesno
    sql: ${TABLE}.is_active ;;
  }

  dimension: is_free_delivery_discount {
    label: "Free Delivery Discount"
    type: yesno
    sql: ${TABLE}.is_free_delivery_discount ;;
  }

  dimension_group: last_modified {
    label: "Date Discount Code Last Modified At"
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
    sql: ${TABLE}.last_modified_at ;;
  }

  dimension: max_applications {
    label: "Max Discount Applications"
    type: number
    sql: ${TABLE}.max_applications ;;
  }

  dimension: max_applications_per_customer {
    label: "Max Discount Applications per Customer"
    type: number
    sql: ${TABLE}.max_applications_per_customer ;;
  }

  dimension_group: valid_from {
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
    sql: ${TABLE}.valid_from ;;
  }

  dimension_group: valid_until {
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
    sql: ${TABLE}.valid_until ;;
  }

  dimension: discount_value {
    type: number
    sql: ${TABLE}.discount_value ;;
  }

  dimension: use_case {
    alias: [discount_use_case]
    type: string
    sql: ${TABLE}.use_case ;;
  }

  dimension: used {
    label: "Discounts Used"
    sql: ${TABLE}.used ;;
    value_format_name: decimal_0
  }


  measure: count {
    type: count
    drill_fields: [discount_id, discount_name]
  }
}
