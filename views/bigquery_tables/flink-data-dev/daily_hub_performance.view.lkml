# Owner: Nazrin Guliyeva
# Created: 17-03-2022

# This view is created for onboarding task. It contains main KPIs such as # riders, # worked hours, # orders, etc. in daily hub level.

view: daily_hub_performance {
  sql_table_name: `flink-data-dev.sandbox_nazrin.daily_hub_performance`
    ;;

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Parameters     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  parameter: max_rank {
    type: number
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  dimension: rank_limit {
    label: "Rank limit"
    description: "Desired number for rank"
    type: number
    sql: {% parameter max_rank %} ;;
  }

  dimension: country_iso {
    label: "Country ISO"
    description: "Country code"
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: hub_code {
    label: "Hub code"
    description: "Hub code"
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: city {
    label: "City"
    description: "City"
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: daily_hub_uuid {
    description: "Unique ID for each recor"
    type: string
    sql: ${TABLE}.daily_hub_uuid ;;
  }

  dimension_group: order {
    label: "Order date"
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

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures       ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  measure: number_of_orders  {
    label: "# Orders"
    description: "Number of daily orders for hub"
    type: sum
    sql: ${TABLE}.number_of_orders;;
    value_format_name: decimal_0
  }

  measure: avg_number_of_items  {
    label: "AVG # Items"
    description: "AVG number of items in basket "
    type: average
    sql: ${TABLE}.avg_number_of_items ;;
    value_format_name: decimal_2
  }

  measure: avg_fulfillment_time_minutes  {
    label: "AVG fulfillment time by minutes"
    description: "Average fulfillment time in minutes"
    type: average
    sql: ${TABLE}.avg_fulfillment_time_minutes ;;
    value_format_name: decimal_2
  }

  measure: number_of_hours_worked_by_riders_minutes  {
    label: "# Hours"
    description: "Number of hours worked by riders"
    type: sum
    sql: ${TABLE}.number_of_hours_worked_by_riders_minutes ;;
    value_format_name: decimal_0
  }

  measure: number_of_worked_riders  {
    label: "# Riders"
    description: "Number of riders who worked in hub"
    type: sum
    sql: ${TABLE}.number_of_worked_riders ;;
    value_format_name: decimal_0
  }

  measure: utr  {
    label: "Rider UTR"
    description: "Utilisation Rate of Riders"
    sql: nullif(${number_of_orders},0)/nullif(${number_of_hours_worked_by_riders_minutes},0) ;;
    value_format_name: decimal_2
  }
}
