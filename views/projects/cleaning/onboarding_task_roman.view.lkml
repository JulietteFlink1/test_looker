view: test_content_validator {
  sql_table_name: `flink-data-prod.sandbox.onboarding_task_roman`
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
    description: "Total # of minutes spend by the hub to fulfill all the orders in a day"
    sql: ${TABLE}.fulfillment_time_minutes_total ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: number_of_items_total {
    type: number
    hidden: yes
    description: "Total number of items delivered by the hub in a day"
    sql: ${TABLE}.number_of_items_total ;;
  }

  dimension: number_of_orders_total {
    type: number
    hidden: yes
    description: "Total number of orders fulfilled by the hub in a day"
    sql: ${TABLE}.number_of_orders_total ;;
  }

  dimension: number_of_orders_with_fulfillment_time {
    type: number
    hidden: yes
    description: "Total number of orders fulfilled by the hub in a day where fulfillment time is available"
    sql: ${TABLE}.number_of_orders_with_fulfillment_time ;;
  }

  dimension: number_of_worked_hours_riders_total {
    type: number
    hidden: yes
    description: "Total number of hours worked by riders in the hub in a day"
    sql: ${TABLE}.number_of_worked_hours_riders_total ;;
  }

  dimension: number_of_worked_riders_total {
    type: number
    hidden: yes
    description: "Total number of riders worked in the hub in a day"
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
    hidden: yes
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
    label: "AVG Fulfillment Time Minutes"
    description: "Average # minutes needed to fulfill the order"
    hidden:  no
    type: average
    sql: ${fulfillment_time_minutes_total} / NULLIF(${number_of_orders_with_fulfillment_time},0);;
    value_format_name: decimal_1
  }

  measure: avg_number_of_basket_items {
    label: "AVG # Items In Basket"
    description: "Average # items in a basket"
    hidden:  no
    type: average
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
    type: sum
    sql: ${number_of_orders_total};;
    value_format: "0"
  }

  measure: sum_number_of_riders{
    label: "# Riders"
    description: "Total # Riders worked in a day in the hub"
    hidden:  no
    type: sum
    sql: ${number_of_worked_riders_total};;
    value_format: "0"
  }

}
