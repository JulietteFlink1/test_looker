view: hub_staffing {
  sql_table_name: `flink-data-prod.reporting.hub_staffing`
    ;;

  dimension_group: block_ends_at_timestamp {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.block_ends_at_timestamp ;;
  }

  dimension_group: block_starts_at_timestamp {
    type: time
    timeframes: [
      raw,
      time,
      hour_of_day,
      time_of_day,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.block_starts_at_timestamp ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: is_hub_open {
    type: number
    sql: ${TABLE}.is_hub_open ;;
  }

  dimension: number_of_employees_needed {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_employees_needed ;;
  }

  dimension: number_of_forecast_riders_needed {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_forecast_riders_needed ;;
  }

  dimension: number_of_no_show_employees {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_no_show_employees ;;
  }

  dimension: number_of_orders {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_orders ;;
  }

  dimension: number_of_planned_employees {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_planned_employees ;;
  }

  dimension: number_of_predicted_orders {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_predicted_orders ;;
  }

  dimension: number_of_predicted_orders_lower_bound {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_predicted_orders_lower_bound ;;
  }

  dimension: number_of_predicted_orders_upper_bound {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_predicted_orders_upper_bound ;;
  }

  dimension: number_of_worked_employees {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_worked_employees ;;
  }

  dimension: position_name {
    type: string
    hidden: no
    sql: ${TABLE}.position_name ;;
  }

  dimension_group: shift {
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
    sql: ${TABLE}.shift_date ;;
  }

  dimension: staffing_uuid {
    type: string
    hidden: yes
    sql: ${TABLE}.staffing_uuid ;;
  }


  measure: sum_employees_needed {
    type: sum
    label:"# Actual Needed Employees"
    description: "Number of needed Employees based on actual order demand"
    sql:${number_of_employees_needed};;
    value_format_name: decimal_1
  }


  measure: sum_forecast_riders_needed{
    type: sum
    label:"# Forecasted Needed Employees"
    description: "Number of Needed Employees Based on Forecasted Order Demand"
    sql:${number_of_forecast_riders_needed};;
    value_format_name: decimal_1
  }


  measure: sum_orders{
    type: sum
    label:"# Actual Orders"
    sql:${number_of_orders};;
    value_format_name: decimal_0
  }


  measure: sum_planned_employees{
    type: sum
    label:"# Planned Employees"
    description: "Number of Planned/Scheduled Employees"
    sql:${number_of_planned_employees};;
    value_format_name: decimal_1
  }


  measure: sum_predicted_orders{
    type: sum
    label:"# Forecasted Orders"
    description: "Number of Forecasted Orders"
    sql:${number_of_predicted_orders};;
    value_format_name: decimal_1
  }


  measure: sum_worked_employees{
    type: sum
    label:"# Worked Employees"
    description: "Number of Worked Employees"
    sql:${number_of_worked_employees};;
    value_format_name: decimal_1
  }


  measure: sum_no_show_employees{
    label:"# No_Show Employees"
    type: number
    description: "Number of No_Show Employees"
    sql:${sum_planned_employees} - ${sum_worked_employees} ;;
    value_format_name: decimal_1
  }


  measure: avg_employees_utr{
    label:"# Average UTR"
    type: number
    description: "Average Employees UTR"
    sql:${sum_orders} / ${sum_worked_employees} ;;
    value_format_name: decimal_1
  }

  measure: count {
    type: count
    drill_fields: [position_name]
  }
}
