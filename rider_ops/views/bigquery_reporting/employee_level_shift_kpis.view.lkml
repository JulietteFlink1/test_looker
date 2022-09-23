view: employee_level_shift_kpis {
  sql_table_name: `flink-data-prod.reporting.employee_level_shift_kpis`
    ;;

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: external_agency_name {
    type: string
    sql: ${TABLE}.external_agency_name ;;
  }

  dimension: fleet_type {
    type: string
    sql: ${TABLE}.fleet_type ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: is_external {
    type: yesno
    sql: ${TABLE}.is_external ;;
  }

  dimension_group: last_updated_timestamp {
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
    sql: ${TABLE}.last_updated_timestamp ;;
  }

  dimension: number_of_absence_minutes {
    type: number
    sql: ${TABLE}.number_of_absence_minutes ;;
  }

  dimension: number_of_deleted_excused_no_show_minutes {
    type: number
    sql: ${TABLE}.number_of_deleted_excused_no_show_minutes ;;
  }

  dimension: number_of_deleted_unexcused_no_show_minutes {
    type: number
    sql: ${TABLE}.number_of_deleted_unexcused_no_show_minutes ;;
  }

  dimension: number_of_end_early_minutes {
    type: number
    sql: ${TABLE}.number_of_end_early_minutes ;;
  }

  dimension: number_of_end_late_minutes {
    type: number
    sql: ${TABLE}.number_of_end_late_minutes ;;
  }

  dimension: number_of_excused_no_show_minutes {
    type: number
    sql: ${TABLE}.number_of_excused_no_show_minutes ;;
  }

  dimension: number_of_no_show_minutes {
    type: number
    sql: ${TABLE}.number_of_no_show_minutes ;;
  }

  dimension: number_of_planned_minutes {
    type: number
    sql: ${TABLE}.number_of_planned_minutes ;;
  }

  dimension: number_of_sick_minutes {
    type: number
    sql: ${TABLE}.number_of_sick_minutes ;;
  }

  dimension: number_of_start_early_minutes {
    type: number
    sql: ${TABLE}.number_of_start_early_minutes ;;
  }

  dimension: number_of_start_late_minutes {
    type: number
    sql: ${TABLE}.number_of_start_late_minutes ;;
  }

  dimension: number_of_unexcused_no_show_minutes {
    type: number
    sql: ${TABLE}.number_of_unexcused_no_show_minutes ;;
  }

  dimension: number_of_unpaid_absence_minutes {
    type: number
    sql: ${TABLE}.number_of_unpaid_absence_minutes ;;
  }

  dimension: number_of_vacation_minutes {
    type: number
    sql: ${TABLE}.number_of_vacation_minutes ;;
  }

  dimension: number_of_worked_minutes {
    type: number
    sql: ${TABLE}.number_of_worked_minutes ;;
  }

  dimension: position_name {
    type: string
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

  dimension: staff_number {
    type: number
    sql: ${TABLE}.staff_number ;;
  }

  measure: count {
    type: count
    drill_fields: [external_agency_name, position_name]
  }
}
