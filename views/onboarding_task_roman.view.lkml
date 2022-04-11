view: onboarding_task_roman {
  sql_table_name: `flink-data-dev.sandbox.onboarding_task_roman`
    ;;

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: fulfillment_time_minutes_total {
    type: number
    sql: ${TABLE}.fulfillment_time_minutes_total ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: number_of_items_total {
    type: number
    sql: ${TABLE}.number_of_items_total ;;
  }

  dimension: number_of_orders_total {
    type: number
    sql: ${TABLE}.number_of_orders_total ;;
  }

  dimension: number_of_orders_with_fulfillment_time {
    type: number
    sql: ${TABLE}.number_of_orders_with_fulfillment_time ;;
  }

  dimension: number_of_worked_hours_riders_total {
    type: number
    sql: ${TABLE}.number_of_worked_hours_riders_total ;;
  }

  dimension: number_of_worked_riders_total {
    type: number
    sql: ${TABLE}.number_of_worked_riders_total ;;
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

  dimension: table_uuid {
    type: string
    primary_key: yes
    sql: ${TABLE}.table_uuid ;;
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  measure: count {
    type: count
    drill_fields: []
  }

  measure: avg_fulfillment_time_minutes {
    label: "AVG # Minutes Fulfillment"
    description: "Average # minutes needed to fulfill the order"
    hidden:  no
    type: number
    sql: ${fulfillment_time_minutes_total} / NULLIF(${number_of_orders_with_fulfillment_time},0);;
    value_format_name: decimal_1
  }

  measure: avg_number_of_basket_items {
    label: "AVG # Items In Basket"
    description: "Average # items in a basket"
    hidden:  no
    type: number
    sql: ${number_of_items_total} / ${number_of_orders_total};;
    value_format_name: decimal_1
  }

  # ~~~~
  # SUMS
  # ~~~~

  measure: sum_number_of_orders{
    label: "# Orders"
    description: "Total # of orders"
    hidden:  no
    type: number
    sql: ${number_of_orders_total};;
  }

  measure: sum_number_of_riders{
    label: "# Riders"
    description: "Total # Riders worked in a day in the hub"
    hidden:  no
    type: number
    sql: ${number_of_worked_riders_total};;
  }

}
