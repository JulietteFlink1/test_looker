view: city_level_employees_capacity {
  sql_table_name: `flink-data-prod.reporting.city_level_employees_capacity`
    ;;

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension_group: end_period {
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
    sql: ${TABLE}.end_period ;;
  }

  dimension: number_of_active_employees {
    type: number
    sql: ${TABLE}.number_of_active_employees ;;
  }

  dimension: number_of_ext_employees {
    type: number
    sql: ${TABLE}.number_of_ext_employees ;;
  }

  dimension: number_of_no_show_employees {
    type: number
    sql: ${TABLE}.number_of_no_show_employees ;;
  }

  dimension: number_of_planned_employees {
    type: number
    sql: ${TABLE}.number_of_planned_employees ;;
  }

  dimension: number_of_weeks {
    type: number
    sql: ${TABLE}.number_of_weeks ;;
  }

  dimension: position_name {
    type: string
    sql: ${TABLE}.position_name ;;
  }

  dimension_group: start_period {
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
    sql: ${TABLE}.start_period ;;
  }

  dimension: timezone {
    type: string
    sql: ${TABLE}.timezone ;;
  }

  dimension: total_contracted_hours {
    type: number
    sql: ${TABLE}.total_contracted_hours ;;
  }

  dimension: total_no_show_employees_hours {
    type: number
    sql: ${TABLE}.total_no_show_employees_hours ;;
  }

  dimension: total_planned_employees_hours {
    type: number
    sql: ${TABLE}.total_planned_employees_hours ;;
  }

  dimension: total_weekly_active_contracted_hours {
    type: number
    sql: ${TABLE}.total_weekly_active_contracted_hours ;;
  }

  dimension: total_worked_active_employees_hours {
    type: number
    sql: ${TABLE}.total_worked_active_employees_hours ;;
  }

  dimension: total_worked_ext_employees_hours {
    type: number
    sql: ${TABLE}.total_worked_ext_employees_hours ;;
  }

  dimension: week_group {
    type: number
    sql: ${TABLE}.week_group ;;
  }

  dimension: week_number_report {
    type: number
    sql: ${TABLE}.week_number_report ;;
  }

  dimension_group: year {
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
    sql: ${TABLE}.year ;;
  }


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


  measure: sum_contracted_hours {
    type: sum
    sql:${total_contracted_hours};;
    value_format_name: decimal_0
  }

  measure: sum_no_show_employees_hours {
    type: sum
    sql:${total_no_show_employees_hours};;
    value_format_name: decimal_0
  }
  measure: sum_planned_employees_hours {
    type: sum
    sql:${total_planned_employees_hours};;
    value_format_name: decimal_0
  }
  measure: sum_total_weekly_active_contracted_hours {
    type: sum
    sql:${total_weekly_active_contracted_hours};;
    value_format_name: decimal_0
  }
  measure: sum_worked_active_employees_hours {
    type: sum
    sql:${total_worked_active_employees_hours};;
    value_format_name: decimal_0
  }
  measure: sum_worked_ext_employees_hours {
    type: sum
    sql:${total_worked_ext_employees_hours};;
    value_format_name: decimal_0
  }

  measure: count {
    type: count
    drill_fields: [position_name]
  }
}
