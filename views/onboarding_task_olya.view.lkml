# Owner:   Olga Botanova
# Created: 2022-06-23

# This views refers to onboarding task


view: onboarding_task_olya {
  sql_table_name: `flink-data-dev.sandbox.onboarding_task_olya`
    ;;
  view_label: "* Onboarding Data Olya *"

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  dimension_group: order_date {
    type: time
    group_label: "> Dates & Timestamps "
    timeframes: [
      date,
      week,
      month
    ]
    convert_tz: no
    label: "Order"
    datatype: date
    sql: ${TABLE}.order_date ;;
  }

  dimension: country_iso {
    type: string
    group_label: "> Georgaphic Data "
    label: "Country iso"
    sql: ${TABLE}.country_iso ;;
  }

  dimension: hub_code {
    type: string
    hidden: yes
    label: "Hub Code"
    sql: ${TABLE}.hub_code ;;
  }

  dimension: fulfillment_time_minutes {
    type: number
    hidden: yes
    sql: ${TABLE}.fulfillment_time_minutes ;;
  }

  dimension: number_of_items {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_items ;;
  }

  dimension: number_of_orders {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_orders ;;
  }

  dimension: number_of_riders {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_riders ;;
  }

  dimension: number_of_worked_hours {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_worked_hours ;;
  }

  dimension: number_of_orders_with_fulfillment_time {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_orders_with_fulfillment_time ;;
  }

  dimension: table_uuid {
    type: string
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.table_uuid ;;
  }

  dimension: date_granularity_pass_through {
    group_label: "> Parameters "
    description: "To use the parameter value in a table calculation (e.g WoW, % Growth) we need to materialize it into a dimension "
    type: string
    sql:
            {% if date_granularity._parameter_value == 'Day' %}
              "Day"
            {% elsif date_granularity._parameter_value == 'Week' %}
              "Week"
            {% elsif date_granularity._parameter_value == 'Month' %}
              "Month"
            {% endif %};;
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Parameters     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


  parameter: date_granularity {
    group_label: "> Dates & Timestamps "
    label: "Date Granularity"
    type: unquoted
    allowed_value: { value: "Day" }
    allowed_value: { value: "Week" }
    allowed_value: { value: "Month" }
    default_value: "Day"
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dynamic Dimensions  ~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


  dimension: date {
    group_label: "> Dates & Timestamps "
    label: "Date (Dynamic)"
    label_from_parameter: date_granularity
    sql:
    {% if date_granularity._parameter_value == 'Day' %}
      ${order_date_date}
    {% elsif date_granularity._parameter_value == 'Week' %}
      ${order_date_week}
    {% elsif date_granularity._parameter_value == 'Month' %}
      ${order_date_month}
    {% endif %};;
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures    ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


  measure: avg_fulfillment_time_min {
    type: number
    description: "Average fulfillment time for orders in minutes"
    label: "AVG Fulfillment Time"
    value_format: "hh:mm:ss"
    sql: if(${sum_number_of_orders_with_fulfillment_time} = 0, 0,
      (${fulfillment_time_min} * 60 / 86400.0) / ${sum_number_of_orders_with_fulfillment_time});;
  }

  measure: fulfillment_time_min {
    type: sum
    description: "Amount of fulfillment time in minutes"
    label: "SUM Fulfillment Time"
    value_format: "0.0"
    hidden: yes
    sql: ${fulfillment_time_minutes} ;;
  }

  measure: sum_number_of_orders_with_fulfillment_time {
    type: sum
    description: "Amount of orders with non-null fulfillment time"
    label: "# Orders with Fulfillment"
    value_format: "0.0"
    sql: ${number_of_orders_with_fulfillment_time} ;;
  }

  measure: avg_number_of_items {
    type: number
    label: "AVG # Items in Basket"
    value_format: "0.0"
    sql: if(${sum_number_of_orders} = 0, 0,
      ${sum_number_of_items} / ${sum_number_of_orders}) ;;
  }

  measure: sum_number_of_items {
    type: sum
    description: "Total amount of items"
    label: "# Items"
    sql: ${number_of_items} ;;
  }

  measure: sum_number_of_orders {
    type: sum
    description: "Number of successful orders"
    label: "# Orders"
    value_format: "#,##0"
    sql: ${number_of_orders} ;;
  }

  measure: sum_number_of_riders {
    type: sum
    description: "Number of worked riders"
    label: "# Riders"
    sql: ${number_of_riders} ;;
  }

  measure: sum_number_of_riders_worked_hours {
    type: sum
    description: "Sum of Worked hours by riders"
    label: "SUM Worked hours by Riders"
    value_format: "#,##0.0"
    sql: ${number_of_worked_hours} ;;
  }

  measure: count {
    type: count
    hidden: yes
    drill_fields: []
  }
}
