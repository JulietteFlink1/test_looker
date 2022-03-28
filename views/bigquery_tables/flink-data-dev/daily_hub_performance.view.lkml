# Owner: Nazrin Guliyeva
# Created: 17-03-2022

# This view is created for onboarding task. It contains main KPIs such as # riders, # worked hours, # orders, etc. in daily hub level.

view: daily_hub_performance {
  sql_table_name: `flink-data-dev.sandbox_nazrin.daily_hub_performance`;;

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Parameters     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  parameter: max_rank {
    label: "Max rank"
    description: "For specifying Top N by user"
    type: number
  }

  parameter: metric_selector {
    label: "Choose metric"
    description: "For sorting Top N Hubs based on selected metric"
    type: unquoted
    allowed_value: { value: "Order" }
    allowed_value: { value: "UTR" }
    allowed_value: { value: "AVG fulfillment time" }
    allowed_value: { value: "AVG # items" }
    allowed_value: { value: "# Riders" }
    allowed_value: { value: "# Hours" }

    default_value: "Order"
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  dimension: fulfillment_tier {
    type: tier
    tiers: [10,12,14,16,18,20]
    style: relational
    sql: ${avg_fulfillment_time_minutes_dimension} ;;
  }

  dimension: avg_fulfillment_time_minutes_dimension  {
    label: "AVG fulfillment time by minutes - dimension"
    description: "Average fulfillment time in minutes"
    type: number
    sql: ${TABLE}.avg_fulfillment_time_minutes ;;
    value_format_name: decimal_2
  }

  dimension: rank_limit {
    label: "Rank limit"
    type: number
    sql: {% parameter max_rank %} ;;
  }

  dimension: country_iso {
    label: "Country ISO"
    description: "Country code"
    type: string
    hidden: yes
    sql: ${TABLE}.country_iso
    ;;
  }

  dimension: hub_code {
    label: "Hub code"
    description: "Hub code"
    type: string
    hidden: yes
    sql: ${TABLE}.hub_code ;;
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
      date
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.order_date ;;
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~       Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  measure: chosen_metric {
    label_from_parameter: metric_selector
    type: number
    value_format_name: decimal_2
    sql:
      CASE
      WHEN {% parameter metric_selector %} = 'Order' THEN ${number_of_orders}
      WHEN {% parameter metric_selector %} = 'UTR' THEN ${utr}
      WHEN {% parameter metric_selector %} = 'AVG fulfillment time' THEN ${avg_fulfillment_time_minutes}
      WHEN {% parameter metric_selector %} = 'AVG # items' THEN ${avg_number_of_items}
      WHEN {% parameter metric_selector %} = '# Riders' THEN ${number_of_worked_riders}
      WHEN {% parameter metric_selector %} = '# Hours' THEN ${number_of_hours_worked_by_riders}
      ELSE NULL
    END ;;
  }

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


  measure: utr  {
    label: "Rider UTR"
    description: "Utilisation Rate of Riders"
    sql: ${number_of_orders}/nullif(${number_of_hours_worked_by_riders},0) ;;
    value_format_name: decimal_2
  }
}
