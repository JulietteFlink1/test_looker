view: employees_hub_level_capacity {
  sql_table_name: `flink-data-prod.reporting.employees_hub_level_capacity`
    ;;

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: number_of_employees {
    type: number
    sql: ${TABLE}.number_of_employees ;;
  }

  dimension: position_name {
    type: string
    sql: ${TABLE}.position_name ;;
  }

  dimension_group: shift_week {
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
    sql: ${TABLE}.shift_week ;;
  }



  dimension: total_no_show_hours {
    type: number
    sql: ${TABLE}.total_no_show_hours ;;
  }

  dimension: total_planned_hours {
    type: number
    sql: ${TABLE}.total_planned_hours ;;
  }

  dimension: total_weekly_contracted_hours {
    type: number
    sql: ${TABLE}.total_weekly_contracted_hours ;;
  }

  dimension: total_worked_hours {
    type: number
    sql: ${TABLE}.total_worked_hours ;;
  }

  dimension: total_ext_planned_hours {
    type: number
    sql: ${TABLE}.total_ext_planned_hours ;;
  }

  dimension: total_ext_worked_hours {
    type: number
    sql: ${TABLE}.total_ext_worked_hours ;;
  }


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


  measure: sum_no_show_hours {
    group_label: ">> Operational KPIs"
    type: sum
    sql:${total_no_show_hours};;
    value_format_name: decimal_0
  }

  measure: sum_planned_hours {
    group_label: ">> Operational KPIs"
    type: sum
    sql:${total_planned_hours};;
    value_format_name: decimal_0
  }

  measure: sum_weekly_contracted_hours {
    group_label: ">> Operational KPIs"
    type: sum
    sql:${total_weekly_contracted_hours};;
    value_format_name: decimal_0
  }

  measure: sum_worked_hours {
    group_label: ">> Operational KPIs"
    type: sum
    sql:${total_worked_hours};;
    value_format_name: decimal_0
  }

  measure: sum_ext_planned_hours {
    group_label: ">> Operational KPIs"
    type: sum
    sql:${total_ext_planned_hours};;
    value_format_name: decimal_0
  }

  measure: sum_ext_worked_hours {
    group_label: ">> Operational KPIs"
    type: sum
    sql:${total_ext_worked_hours};;
    value_format_name: decimal_0
  }

}
