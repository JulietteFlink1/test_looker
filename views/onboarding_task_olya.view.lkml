# Owner:   Olga Botanova
# Created: 2022-06-23

# This views refers to onboarding task


view: onboarding_task_olya {
  sql_table_name: `flink-data-dev.sandbox.onboarding_task_olya`
    ;;
  view_label: "Onboarding task Olya"

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimentions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  dimension_group: date {
    type: time
    group_label: "Order date/time"
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

  dimension: country_iso {
    type: string
    label: "Country iso"
    sql: ${TABLE}.country_iso ;;
  }

  dimension: hub_code {
    type: string
    label: "Hub code"
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

  dimension: table_uuid {
    type: string
    primary_key: yes
    sql: ${TABLE}.table_uuid ;;
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Metrics     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  measure: fulfillment_time_min {
    type: number
    hidden: yes
    sql: ${TABLE}.fulfillment_time_minutes ;;
  }

  measure: avg_fulfillment_time_minutes {
    type: number
    label: "AVG fulfillment time min"
    sql: ${fulfillment_time_min} / ${number_of_orders} ;;
  }

  measure: sum_number_of_items {
    type: sum
    hidden: yes
    sql: ${TABLE}.number_of_items ;;
  }

  measure: count {
    type: count
    hidden: yes
    drill_fields: []
  }
}
