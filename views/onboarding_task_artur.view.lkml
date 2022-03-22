view: onboarding_task_artur {
  sql_table_name: `flink-data-dev.sandbox_artur.onboarding_task_artur`
    ;;

  dimension: avg_fulfillment_time {
    hidden:yes
    type: number
    sql: ${TABLE}.avg_fulfillment_time ;;
  }

  dimension: avg_num_of_items {
    hidden:yes
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

  dimension: num_of_hours_worked {
    hidden:yes
    type: number
    sql: ${TABLE}.num_of_hours_worked ;;
  }

  dimension: num_of_orders {
    hidden:yes
    type: number
    sql: ${TABLE}.num_of_orders ;;
  }

  dimension: num_of_riders {
    hidden:yes
    type: number
    sql: ${TABLE}.num_of_riders ;;
  }

  dimension_group: order {
    type: time
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

  measure: avg_fulfillment {
    type: number
    drill_fields: []
  }

  measure: avg_items {
    type: number
    drill_fields: []
  }

  measure: hours_worked {
    type: number
    drill_fields: []
  }

  measure: orders {
    type: number
    drill_fields: []
  }

  measure: riders {
    type: number
    drill_fields: []
  }
}
