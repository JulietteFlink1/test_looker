view: customers_metrics {
  sql_table_name: `flink-data-staging.curated.customers_metrics`
    ;;

  dimension: reorder_number_28_days {
    type: number
    sql: ${TABLE}._28_day_reorder_number ;;
  }

  dimension: reorder_number_30_days {
    type: number
    sql: ${TABLE}._30_day_reorder_number ;;
  }

  dimension: lifetime_revenue_gross {
    type: number
    sql: ${TABLE}.amt_lifetime_revenue_gross ;;
  }

  dimension: lifetime_revenue_net {
    type: number
    sql: ${TABLE}.amt_lifetime_revenue_net ;;
  }

  dimension: lifetime_revenue_tier {
    type: tier
    tiers: [0, 25, 50, 100, 200, 500, 1000]
    sql: ${lifetime_revenue_gross} ;;
    style: integer
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: user_email {
    type: string
    sql: ${TABLE}.customer_email ;;
  }

  dimension: customer_id {
    type: string
    sql: ${TABLE}.customer_id ;;
  }

  dimension: favourite_order_day {
    type: string
    sql: ${TABLE}.favourite_order_day ;;
  }

  dimension: favourite_order_hour {
    type: string
    sql: ${TABLE}.favourite_order_hour ;;
  }

  dimension_group: first_order {
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

  dimension: first_order_id {
    type: string
    sql: ${TABLE}.first_order_uuid ;;
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

  dimension_group: latest_order {
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

  dimension: days_betw_first_and_last_order {
    group_label: "* First Order Date *"
    description: "Days between first and latest order"
    type: number
    sql: TIMESTAMP_DIFF(${latest_order_raw}, ${first_order_raw}, DAY)+1 ;;
  }

  dimension_group: duration_between_first_order_and_now {
    group_label: "* First Order Date *"
    type: duration
    sql_start: ${first_order_raw} ;;
    sql_end: CURRENT_TIMESTAMP() ;;
  }

  dimension_group: duration_between_first_order_month_and_now {
    group_label: "* First Order Date *"
    type: duration
    sql_start: DATE_TRUNC(${first_order_raw}, MONTH);;
    sql_end: CURRENT_TIMESTAMP();;
    intervals: [month]
  }

  dimension_group: duration_between_first_order_week_and_now {
    group_label: "* First Order Date *"
    type: duration
    sql_start: DATE_TRUNC(${first_order_raw}, WEEK);;
    sql_end: CURRENT_TIMESTAMP();;
    intervals: [week]
  }

  dimension: latest_order_id {
    type: string
    sql: ${TABLE}.latest_order_uuid ;;
  }

  dimension: lifetime_orders {
    type: number
    sql: ${TABLE}.lifetime_orders ;;
  }

  dimension: number_of_distinct_months_with_orders {
    type: number
    sql: ${TABLE}.number_of_distinct_months_with_orders ;;
  }

  dimension: orders_per_month {
    type: number
    sql: ${TABLE}.orders_per_month ;;
  }

  dimension: orders_per_week {
    type: number
    sql: ${TABLE}.orders_per_week ;;
  }

  dimension: top_1_category {
    type: string
    sql: ${TABLE}.top_1_category ;;
  }

  dimension: top_1_product {
    type: string
    sql: ${TABLE}.top_1_product ;;
  }

  dimension: top_2_category {
    type: string
    sql: ${TABLE}.top_2_category ;;
  }

  dimension: top_2_product {
    type: string
    sql: ${TABLE}.top_2_product ;;
  }

  dimension: top_3_product {
    type: string
    sql: ${TABLE}.top_3_product ;;
  }

  dimension: has_reordered_within_30_days {
    description: "Boolean dimension. Takes the value yes if the user has reordered within 30 days after their first order."
    type: yesno
    sql: case when ${reorder_number_30_days} > 0 then True else False end ;;
  }

  dimension: repeat_customer {
    description: "Lifetime Count of Orders > 1"
    type: yesno
    sql: ${lifetime_orders} > 1 ;;
  }

  dimension: lifetime_orders_tier {
    type: tier
    tiers: [0, 1, 2, 3, 5, 10]
    sql: ${lifetime_orders} ;;
    style: integer
  }

  dimension: orders_per_week_tier {
    type: tier
    tiers: [1, 2, 3]
    sql: ${orders_per_week} ;;
    style: relational
  }

  dimension: orders_per_month_tier {
    type: tier
    tiers: [1, 2, 3]
    sql: ${orders_per_month} ;;
    style: relational
  }

  dimension_group: time_since_sign_up {
    group_label: "* User Dimensions *"
    type: duration
    sql_start: ${first_order_raw} ;;
    sql_end: ${orders_cl.created_raw} ;;
  }

  dimension_group: time_between_sign_up_month_and_now {
    group_label: "* User Dimensions *"
    hidden: yes
    type: duration
    sql_start: DATE_TRUNC(${first_order_raw}, MONTH) ;;
    sql_end: CURRENT_TIMESTAMP() ;;
  }

  dimension_group: time_between_sign_up_week_and_now {
    group_label: "* User Dimensions *"
    hidden: yes
    type: duration
    sql_start: DATE_TRUNC(${first_order_raw}, WEEK) ;;
    sql_end: CURRENT_TIMESTAMP();;
  }


  ################## Measures

  measure: cnt_30_day_retention {
    type: count
    filters: [has_reordered_within_30_days: "yes"]
  }

  measure: count {
    type: count
    drill_fields: []
  }

  measure: avg_lifetime_orders {
    type: average
    value_format_name: decimal_2
    sql: ${lifetime_orders} ;;
  }

  measure: avg_lifetime_revenue {
    type: average
    value_format_name: euro_accounting_2_precision
    sql: ${lifetime_revenue_gross} ;;
  }
}
