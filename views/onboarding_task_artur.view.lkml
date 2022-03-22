view: onboarding_task_artur {
  sql_table_name: `flink-data-dev.sandbox_artur.onboarding_task_artur`
    ;;

  measure: avg_fulfillment_time {

    type: number
    sql: ${TABLE}.avg_fulfillment_time ;;
  }

  measure: avg_num_of_items {

    type: number
    sql: ${TABLE}.avg_num_of_items ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  measure: num_of_hours_worked {

    type: number
    sql: ${TABLE}.num_of_hours_worked ;;
  }

  measure: num_of_orders {

    type: number
    sql: ${TABLE}.num_of_orders ;;
  }

  dimension: num_of_riders {

    type: number
    sql: ${TABLE}.num_of_riders ;;
  }

  dimension_group: order {
    type:  time
    timeframes: [
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

  measure: count {
    type: count
    drill_fields: []
  }

}
