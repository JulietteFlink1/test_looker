view: onboarding_task_artur {
  sql_table_name: `flink-data-dev.sandbox_artur.onboarding_task_artur`
    ;;

  dimension: avg_fulfillment_time {
    type: number
    sql: ${TABLE}.avg_fulfillment_time ;;
    hidden: yes
  }

  measure: avg_fulfil_time {
    type: average
    sql: ${avg_fulfillment_time} ;;
    value_format: "$#.00;($#.00)"
  }

  dimension: avg_num_of_items {
    type: number
    hidden: yes
    sql: ${TABLE}.avg_num_of_items ;;
  }

  measure: avg_item_numbers {
    type: average
    sql: ${avg_num_of_items} ;;
    value_format: "$#.00;($#.00)"
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
    type: number
    hidden: yes
    sql: ${TABLE}.num_of_hours_worked ;;
  }

  measure: worked_hours  {
    type: sum
    sql: ${num_of_hours_worked}
    value_format: "$#.00;($#.00)";;
  }

  dimension: num_of_orders {
    type: number
    hidden: yes
    sql: ${TABLE}.num_of_orders ;;
  }

  measure: orders {
    type: sum_distinct
    sql: ${num_of_orders} ;;
    value_format: "$#.00;($#.00)"
  }

  dimension: num_of_riders {
    type: number
    hidden: yes
    sql: ${TABLE}.num_of_riders ;;
  }

  measure: riders {
    type: sum
    sql: ${num_of_riders} ;;
    value_format: "$#.00;($#.00)"
  }

  dimension_group: date {
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
    sql: ${TABLE}.report_date ;;
  }

  dimension: table_uuid {
    type: string
    primary_key: yes
    sql: ${TABLE}.table_uuid ;;

  }

  measure: count {
    type: count
    drill_fields: []
  }
}
