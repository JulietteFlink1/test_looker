view: customers {
  sql_table_name: `flink-data-dev.curated.customers`
    ;;
  drill_fields: [customer_id]

  dimension: customer_id {
    primary_key: yes
    type: string
    sql: ${TABLE}.customer_id ;;
  }

  dimension_group: account_created_at_timestamp {
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
    sql: ${TABLE}.account_created_at_timestamp ;;
  }

  dimension: customer_email {
    type: string
    sql: ${TABLE}.customer_email ;;
  }

  dimension: customer_uuid {
    type: string
    primary_key: yes
    sql: ${TABLE}.customer_uuid ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: first_order_cart_discount_name {
    type: string
    sql: ${TABLE}.first_order_cart_discount_name ;;
  }

  dimension: first_order_city {
    type: string
    sql: ${TABLE}.first_order_city ;;
  }

  dimension: first_order_country {
    type: string
    sql: ${TABLE}.first_order_country ;;
  }

  dimension: first_order_discount_code {
    type: string
    sql: ${TABLE}.first_order_discount_code ;;
  }

  dimension: first_order_discount_name {
    type: string
    sql: ${TABLE}.first_order_discount_name ;;
  }

  dimension: first_order_hub {
    type: string
    sql: ${TABLE}.first_order_hub ;;
  }

  dimension: first_order_phone_number {
    type: string
    sql: ${TABLE}.first_order_phone_number ;;
  }

  dimension: first_order_platform {
    type: string
    sql: ${TABLE}.first_order_platform ;;
  }

  dimension: is_discount_acquisition {
    type: yesno
    sql: ${TABLE}.is_discount_acquisition ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  measure: count {
    type: count
    drill_fields: [customer_id, last_name, first_order_cart_discount_name, first_order_discount_name, first_name]
  }
}
