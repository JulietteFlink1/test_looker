view: onboarding_task_artur {
  sql_table_name: `flink-data-prod.sandbox_artur.onboarding_task_artur`
    ;;

  dimension: average_fulfillment_time {
    type: number
    sql: ${TABLE}.average_fulfillment_time ;;
    hidden: yes
  }

  measure: avg_average_fulfillment_time {
    label: "Average fulfillment time"
    type: average
    sql_distinct_key: ${date_date},${country_iso},${hub_code};;
    sql: ${average_fulfillment_time} ;;
    value_format: "0"
  }

  dimension: average_number_of_items {
    type: number
    hidden: yes
    sql: ${TABLE}.average_number_of_items ;;
  }

  measure: avg_average_number_of_items {
    label: "Average number of items"
    type: average
    sql_distinct_key: ${date_date},${country_iso},${hub_code};;
    sql: ${average_number_of_items} ;;
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

  dimension: number_of_hours_worked {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_hours_worked ;;
  }

  measure: sum_number_of_hours_worked  {
    label: "Hours worked by riders"
    type: sum
    sql: ${number_of_hours_worked}
    value_format: "#.0;($#.0)";;
  }

  dimension: number_of_orders {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_orders ;;
  }

  measure: sum_number_of_orders {
    label: "Orders"
    type: sum
    sql: ${number_of_orders} ;;
  }

  dimension: number_of_riders {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_riders ;;
  }

  measure: sum_number_of_riders {
    label: "Riders"
    type: sum
    sql: ${number_of_riders} ;;
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
  sql: ${date_day_of_week_index} <= DAYOFWEEK(current_date()) AND ${date_day_of_week_index} >= 0  ;;
}

  filter: WoW {
    type: yesno
    sql: ${date_date}<date_add(date_trunc(date_add(date_trunc(current_date(), week), interval -1 week), ISOWEEK), interval 1 week) ;;
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
    sql: ${sum_number_of_orders} / NULLIF (${sum_number_of_riders},0) ;;
    value_format: "#.0;($#.0)"
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
