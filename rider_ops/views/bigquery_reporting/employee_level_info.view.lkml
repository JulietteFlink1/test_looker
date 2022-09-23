view: employee_level_info {
  sql_table_name: `flink-data-prod.reporting.employee_level_info`
    ;;

  dimension: assigned_position_name {
    type: string
    sql: ${TABLE}.assigned_position_name ;;
  }

  dimension: ats_id {
    type: string
    sql: ${TABLE}.ats_id ;;
  }

  dimension: auth0_id {
    type: string
    sql: ${TABLE}.auth0_id ;;
  }

  dimension: channel {
    type: string
    sql: ${TABLE}.channel ;;
  }

  dimension_group: contract_end {
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
    sql: ${TABLE}.contract_end_date ;;
  }

  dimension: contract_id {
    type: number
    sql: ${TABLE}.contract_id ;;
  }

  dimension_group: contract_start {
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
    sql: ${TABLE}.contract_start_date ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension_group: employee_leave {
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
    sql: ${TABLE}.employee_leave_date ;;
  }

  dimension_group: employment_end {
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
    sql: ${TABLE}.employment_end_date ;;
  }

  dimension: employment_id {
    type: number
    sql: ${TABLE}.employment_id ;;
  }

  dimension: employment_type {
    type: string
    sql: ${TABLE}.employment_type ;;
  }

  dimension: hire_date {
    type: string
    sql: ${TABLE}.hire_date ;;
  }

  dimension: home_hub_code {
    type: string
    sql: ${TABLE}.home_hub_code ;;
  }

  dimension: is_active {
    type: yesno
    sql: ${TABLE}.is_active ;;
  }

  dimension: is_external {
    type: yesno
    sql: ${TABLE}.is_external ;;
  }

  dimension_group: last_absence {
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
    sql: ${TABLE}.last_absence_date ;;
  }

  dimension_group: last_planned {
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
    sql: ${TABLE}.last_planned_date ;;
  }

  dimension_group: last_worked {
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
    sql: ${TABLE}.last_worked_date ;;
  }

  dimension: max_weekly_contracted_hours {
    type: number
    sql: ${TABLE}.max_weekly_contracted_hours ;;
  }

  dimension: min_weekly_contracted_hours {
    type: number
    sql: ${TABLE}.min_weekly_contracted_hours ;;
  }

  dimension: position_name {
    type: string
    sql: ${TABLE}.position_name ;;
  }

  dimension: rider_id {
    type: string
    sql: ${TABLE}.rider_id ;;
  }

  dimension: staff_number {
    type: number
    sql: ${TABLE}.staff_number ;;
  }

  dimension: type_of_contract {
    type: string
    sql: ${TABLE}.type_of_contract ;;
  }

  dimension: weekly_contracted_hours {
    type: number
    sql: ${TABLE}.weekly_contracted_hours ;;
  }

  measure: count {
    type: count
    drill_fields: [position_name, assigned_position_name]
  }
}
