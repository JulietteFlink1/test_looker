view: discounts {
  sql_table_name: `flink-data-prod.curated.discounts`;;

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
    sql: ${TABLE}.cart_discount_type ;;
  }

  dimension_group: created {
    label: "Cate Discount Code Creation"
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
    type: string
    sql: ${TABLE}.use_case ;;
  }

  measure: used {
    label: "Discounts Used"
    sql: ${TABLE}.used ;;
    type: sum
    value_format_name: decimal_0
  }


  measure: count {
    type: count
    drill_fields: [discount_id, discount_name]
  }
}
