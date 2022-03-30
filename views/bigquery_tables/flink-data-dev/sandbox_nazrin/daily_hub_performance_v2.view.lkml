# Owner: Nazrin Guliyeva
# Created: 17-03-2022

# This view is created for onboarding task. It contains main KPIs such as # riders, # worked hours, # orders, etc. in daily hub level.

view: daily_hub_performance_v2 {
  sql_table_name: `flink-data-dev.sandbox_nazrin.daily_hub_performance_v2`;;

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Parameters     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  parameter: max_rank {
    label: "Max rank"
    description: "For specifying Top/Bottom N by user"
    type: number
  }


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  dimension: rank_limit {
    label: "Rank limit"
    type: number
    sql: {% parameter max_rank %} ;;
  }

  dimension: country_iso {
    label: "Country ISO"
    description: "Country"
    type: string
    hidden: yes
    sql: ${TABLE}.country_iso
      ;;
  }

  dimension: order_dow {
    label: "Day of the week"
    description: "Order day of the week"
    type: string
    sql: ${TABLE}.order_dow
      ;;
  }

  dimension: hub_code {
    label: "Hub code"
    description: "Hub"
    type: string
    hidden: yes
    sql: ${TABLE}.hub_code ;;
  }


  dimension: daily_hub_uuid {
    description: "Unique ID for each recor"
    type: string
    hidden: yes
    sql: ${TABLE}.daily_hub_uuid ;;
  }

  dimension_group: order {
    label: "Order date"
    type: time
    timeframes: [
      raw,
      date,
      week
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.order_date ;;
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~       Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


  measure: number_of_orders  {
    label: "# Orders"
    description: "Number of daily orders per hub"
    type: sum
    sql: ${TABLE}.number_of_orders;;
    value_format_name: decimal_0
  }

  measure: number_of_items  {
    label: "# Items"
    description: "Number of items in basket "
    type: sum
    sql: ${TABLE}.number_of_items ;;
    value_format_name: decimal_2
  }

  measure: avg_number_of_items  {
    label: "AVG # Items"
    description: "AVG number of items in basket "
    type: number
    sql: ${number_of_orders}/${number_of_items} ;;
    value_format_name: decimal_2
  }

 measure: fulfillment_time_minutes  {
    label: "Fulfillment time by minutes"
    description: "Fulfillment time in minutes"
    type: sum
    hidden: yes
    sql: ${TABLE}.fulfillment_time_minutes ;;
    value_format_name: decimal_2
  }

  measure: avg_fulfillment_time_minutes  {
    label: "AVG fulfillment time by minutes"
    description: "Average fulfillment time in minutes"
    type: number
    sql: ${fulfillment_time_minutes}/nullif(${number_of_orders},0) ;;
    value_format_name: decimal_2
  }

  measure: number_of_hours_worked_by_riders  {
    label: "# Hours"
    description: "Number of hours worked by riders"
    type: sum
    sql: ${TABLE}.number_of_hours_worked_by_riders ;;
    value_format_name: decimal_0
  }

  measure: number_of_worked_riders  {
    label: "# Riders"
    description: "Number of riders who worked in hub"
    type: sum
    sql: ${TABLE}.number_of_worked_riders ;;
    value_format_name: decimal_0
  }
}
