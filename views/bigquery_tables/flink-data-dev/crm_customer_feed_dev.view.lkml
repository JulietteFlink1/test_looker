view: crm_customer_feed {
  sql_table_name: `flink-data-dev.curated.crm_customer_feed`
    ;;

  dimension: _28_day_reorder_number {
    type: number
    sql: ${TABLE}._28_day_reorder_number ;;
  }

  dimension: _30_day_reorder_number {
    type: number
    sql: ${TABLE}._30_day_reorder_number ;;
  }

  dimension: amt_lifetime_revenue_gross {
    type: number
    sql: ${TABLE}.amt_lifetime_revenue_gross ;;
  }

  dimension: amt_lifetime_revenue_net {
    type: number
    sql: ${TABLE}.amt_lifetime_revenue_net ;;
  }

  dimension: avg_order_value {
    type: number
    sql: ${TABLE}.avg_order_value ;;
  }

  dimension: avg_orders_per_month {
    type: number
    sql: ${TABLE}.avg_orders_per_month ;;
  }

  dimension: avg_orders_per_week {
    type: number
    sql: ${TABLE}.avg_orders_per_week ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: customer_email {
    type: string
    sql: ${TABLE}.customer_email ;;
  }

  dimension: customer_id {
    type: string
    sql: ${TABLE}.customer_id ;;
  }

  dimension: customer_uuid {
    type: string
    primary_key: yes
    sql: ${TABLE}.customer_uuid ;;
  }

  dimension: delta_to_pdt_of_latest_order {
    type: number
    sql: ${TABLE}.delta_to_pdt_of_latest_order ;;
  }

  dimension: external_id {
    type: string
    sql: ${TABLE}.external_id ;;
  }

  dimension: favourite_order_day {
    type: string
    sql: ${TABLE}.favourite_order_day ;;
  }

  dimension: favourite_order_hour {
    type: string
    sql: ${TABLE}.favourite_order_hour ;;
  }

  dimension: first_delivery_pdt_minutes {
    type: number
    sql: ${TABLE}.first_delivery_pdt_minutes ;;
  }

  dimension: first_fulfillment_time_minutes {
    type: number
    sql: ${TABLE}.first_fulfillment_time_minutes ;;
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

  dimension: first_order_number {
    type: string
    sql: ${TABLE}.first_order_number ;;
  }

  dimension_group: first_order_timestamp {
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
    sql: ${TABLE}.first_order_timestamp ;;
  }

  dimension: first_platform {
    type: string
    sql: ${TABLE}.first_platform ;;
  }

  dimension: has_opted_out {
    type: yesno
    sql: ${TABLE}.has_opted_out ;;
  }

  dimension: is_discount_acquisition {
    type: yesno
    sql: ${TABLE}.is_discount_acquisition ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension_group: last_order_with_voucher {
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
    sql: ${TABLE}.last_order_with_voucher ;;
  }

  dimension: latest_order_number {
    type: string
    sql: ${TABLE}.latest_order_number ;;
  }

  dimension_group: latest_order_timestamp {
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
    sql: ${TABLE}.latest_order_timestamp ;;
  }

  dimension: number_of_distinct_months_with_orders {
    type: number
    sql: ${TABLE}.number_of_distinct_months_with_orders ;;
  }

  dimension: number_of_lifetime_orders {
    type: number
    sql: ${TABLE}.number_of_lifetime_orders ;;
  }

  dimension: top_1_category {
    type: string
    sql: ${TABLE}.top_1_category ;;
  }

  dimension: top_1_product {
    type: string
    sql: ${TABLE}.top_1_product ;;
  }

  dimension: top_1_subcategory {
    type: string
    sql: ${TABLE}.top_1_subcategory ;;
  }

  dimension: top_2_category {
    type: string
    sql: ${TABLE}.top_2_category ;;
  }

  dimension: top_2_product {
    type: string
    sql: ${TABLE}.top_2_product ;;
  }

  dimension: top_2_subcategory {
    type: string
    sql: ${TABLE}.top_2_subcategory ;;
  }

  dimension: top_3_product {
    type: string
    sql: ${TABLE}.top_3_product ;;
  }

  measure: count {
    type: count
    drill_fields: [first_order_cart_discount_name, first_name, last_name, first_order_discount_name]
  }
}
