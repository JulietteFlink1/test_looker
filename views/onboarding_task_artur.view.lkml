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
    value_format: "0"
  }

  dimension: avg_num_of_items {
    type: number
    hidden: yes
    sql: ${TABLE}.avg_num_of_items ;;
  }

  measure: avg_item_numbers {
    type: average
    sql: ${avg_num_of_items} ;;
    value_format: "#.00;($#.00)"
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
    value_format: "#.0;($#.0)";;
  }

  dimension: num_of_orders {
    type: number
    hidden: yes
    sql: ${TABLE}.num_of_orders ;;
  }

  measure: sum_num_of_orders {
    label: "Orders"
    type: sum
    sql: ${num_of_orders} ;;
  }

  dimension: num_of_riders {
    type: number
    hidden: yes
    sql: ${TABLE}.num_of_riders ;;
  }

  measure: sum_num_of_riders {
    label: "Riders"
    type: sum
    sql: ${num_of_riders} ;;
  }

  dimension_group: date {
    type: time
    timeframes: [
      date,
      week,
      day_of_week,
      day_of_week_index,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.report_date ;;
  }

dimension: until_today {
  type: yesno
  sql: ${date_day_of_week_index} <= WEEKDAY(NOW()) AND ${date_day_of_week_index} >= 0  ;;
}






  filter: WoW {
    type: yesno
    sql: ${date_date}>=date_trunc(date_add(date_trunc(current_date(), week), interval -1 week), ISOWEEK)
    AND ${date_date}<date_add(date_trunc(date_add(date_trunc(current_date(), week), interval -1 week), ISOWEEK), interval 1 week) ;;
  }


  measure: last_updated_date {
    type: date
    sql: MIN(${date_date}) ;;

  }

  dimension: table_uuid {
    type: string
    primary_key: yes
    sql: ${TABLE}.table_uuid ;;

  }

  measure: UTR {
    type: number
    sql: ${sum_num_of_orders} / NULLIF (${sum_num_of_riders},0) ;;
    value_format: "#.0;($#.0)"
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
