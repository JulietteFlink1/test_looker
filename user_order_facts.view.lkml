view: user_order_facts {
  derived_table: {
    datagroup_trigger: flink_default_datagroup
    sql: SELECT
        user_email
        , COUNT(DISTINCT id) AS lifetime_orders
        , SUM(total_gross_amount) AS lifetime_revenue_gross
        , SUM(total_net_amount) AS lifetime_revenue_net
        , MIN(created)  AS first_order
        , MAX(created)  AS latest_order
        , COUNT(DISTINCT FORMAT_TIMESTAMP('%Y%m', created))  AS number_of_distinct_months_with_orders
      FROM order_order
      GROUP BY user_email
 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: user_email {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.user_email ;;
  }

  dimension_group: first_order {
    type: time
    # datatype: timestamp
    sql: ${TABLE}.first_order ;;
  }

  dimension: is_first_order {
    type: yesno
    sql: ${first_order_date} IS NOT NULL ;;
  }

  measure: new_customer_orders {
    type: count
    filters: [lifetime_orders: "=1"]
  }

  measure: returning_customer_orders {
    type: count
    filters: [lifetime_orders: ">1"]
    }

  dimension_group: latest_order {
    type: time
    sql: ${TABLE}.latest_order ;;
  }

  dimension: number_of_distinct_months_with_orders {
    type: number
    sql: ${TABLE}.number_of_distinct_months_with_orders ;;
  }

  dimension: days_as_customer {
    description: "Days between first and latest order"
    type: number
    sql: TIMESTAMP_DIFF(${TABLE}.latest_order, ${TABLE}.first_order, DAY)+1 ;;
  }

  dimension: days_as_customer_tiered {
    type: tier
    tiers: [0, 1, 7, 14, 21, 28, 30, 60, 90, 120]
    sql: ${days_as_customer} ;;
    style: integer
  }

  ##### Lifetime Behavior - Order Counts ######

  dimension: lifetime_orders {
    type: number
    sql: ${TABLE}.lifetime_orders ;;
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

  measure: average_lifetime_orders {
    type: average
    value_format_name: decimal_2
    sql: ${lifetime_orders} ;;
  }

  ##### Lifetime Behavior - Revenue ######

  dimension: lifetime_revenue_gross {
    type: number
    sql: ${TABLE}.lifetime_revenue_gross ;;
  }

  dimension: lifetime_revenue_net {
    type: number
    sql: ${TABLE}.lifetime_revenue_net ;;
  }


  dimension: lifetime_revenue_tier {
    type: tier
    tiers: [0, 25, 50, 100, 200, 500, 1000]
    sql: ${lifetime_revenue_gross} ;;
    style: integer
  }

  measure: average_lifetime_revenue {
    type: average
    value_format_name: usd
    sql: ${lifetime_revenue_gross} ;;
  }

  set: detail {
    fields: [
      user_email,
      lifetime_orders,
      lifetime_revenue_gross,
      lifetime_revenue_net,
      first_order_time,
      latest_order_time,
      number_of_distinct_months_with_orders
    ]
  }
}
