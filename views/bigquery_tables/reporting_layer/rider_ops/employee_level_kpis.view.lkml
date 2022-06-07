# Owner:   Omar Alshobaki
# Created: 2022-06-01
# This view contains daily aggregation of shift and ops related kpis as well as employment info in per distinct hub employee and position

view: employee_level_kpis {
  sql_table_name: `flink-data-dev.reporting.employee_level_kpis`
    ;;

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  dimension: table_uuid {
    type: string
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.table_uuid ;;
  }

  dimension: position_name {
    type: string
    label: "Position Name"
    sql: ${TABLE}.position_name ;;
  }

  dimension: rider_id {
    type: string
    label: "Rider ID"
    sql: ${TABLE}.rider_id ;;
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
    label: "Staff Number"
    sql: ${TABLE}.staff_number ;;
  }

  dimension: acquisition_channel {
    type: string
    label: "Acquisition Channel"
    sql: ${TABLE}.acquisition_channel ;;
  }

  dimension: ats_id {
    type: string
    label: "ATS ID"
    sql: ${TABLE}.ats_id ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: external_agency_name {
    type: string
    label: "External Agency Name"
    sql: ${TABLE}.external_agency_name ;;
  }

  dimension: fleet_type {
    type: string
    label: "Fleet Type"
    description: "Internal/Partnership/One-Time"
    sql: ${TABLE}.fleet_type ;;
  }

  dimension_group: hire {
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
    sql: ${TABLE}.hire_date ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: is_external {
    type: yesno
    sql: ${TABLE}.is_external ;;
  }

  dimension: type_of_contract {
    type: string
    description: "Based on fountain data: full-time, part-time, min/max, 15, 30, etc"
    sql: ${TABLE}.type_of_contract ;;
  }

  dimension: weekly_contracted_hours {
    type: number
    sql: ${TABLE}.weekly_contracted_hours ;;
  }

  dimension_group: time_between_hire_date_and_today {
    type: duration
    sql_start: timestamp(${TABLE}.hire_date) ;;
    sql_end: current_timestamp ;;
    group_label: "Rider Tenure - time since hired "
  }


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


  measure: number_of_scheduled_weeks {
    type: number
    hidden: yes
    sql:1 + date_DIFF( safe_cast(max(${shift_date}) as date),safe_cast(min(${shift_date}) as date), week) ;;
  }


  measure: last_worked_date {
    datatype: date
    description: "date of the last worked/punched shift"
    sql: max(case when ${TABLE}.number_of_worked_minutes > 0 then ${TABLE}.shift_date end ) ;;
  }

  measure: first_worked_date {
    datatype: date
    description: "date of the first worked/punched shift"
    sql: (min(case when ${TABLE}.number_of_worked_minutes > 0 then ${TABLE}.shift_date end) ) ;;
  }


  measure: number_of_at_customer_time_minutes {
    type: average
    label: "AVG At Customer Time Minutes"
    sql: ${TABLE}.number_of_at_customer_time_minutes ;;
    value_format_name: decimal_1
  }

  measure: number_of_delivered_orders {
    type: sum
    label: "# Delivered Orders"
    sql: ${TABLE}.number_of_delivered_orders ;;
  }

  measure: number_of_early_punched_out_hours {
    type: sum
    label: "# Early Punched Out Hours"
    description: "Employee Punch Out Before shift end"
    sql: ${TABLE}.number_of_end_early_minutes/60 ;;
    value_format_name: decimal_1
  }

  measure: number_of_late_punched_out_hours {
    type: sum
    label: "# Late Punched Out Hours"
    description: "Employee Punch Out After shift end"
    sql: ${TABLE}.number_of_end_late_minutes/60 ;;
    value_format_name: decimal_1
  }


  measure: number_of_orders_with_available_nps_score {
    type: sum
    hidden: yes
    sql: ${TABLE}.number_of_orders_with_available_nps_score ;;
  }

  measure: number_of_scheduled_hours {
    type: sum
    label: "# Scheduled Hours"
    sql: ${TABLE}.number_of_planned_minutes/60 ;;
    value_format_name: decimal_1
  }

  measure: number_of_products_with_damaged_products_issues_post {
    type: sum
    sql: ${TABLE}.number_of_products_with_damaged_products_issues_post ;;
  }

  measure: number_of_riding_to_hub_minutes {
    type: average
    label: "AVG Riding to Hub Time Minutes"
    sql: ${TABLE}.number_of_return_to_hub_time_minutes ;;
    value_format_name: decimal_1
  }

  measure: number_of_sick_hours {
    type: sum
    label: "# Sickness Hours"
    sql: ${TABLE}.number_of_sick_minutes/60 ;;
    value_format_name: decimal_1
  }

  measure: number_of_early_punched_in_minutes {
    type: sum
    label: "# Early Punched in Hours"
    description: "Employee Punch in before shift start"
    sql: ${TABLE}.number_of_start_early_minutes/60 ;;
    value_format_name: decimal_1
  }

  measure: number_of_late_punched_in_minutes {
    type: sum
    label: "# Late Punched in Hours"
    description: "Employee Punch in After shift start"
    sql: ${TABLE}.number_of_start_late_minutes/60 ;;
    value_format_name: decimal_1
  }

  measure: number_of_worked_hours {
    type: sum
    label: "# Worked Hours"
    sql: ${TABLE}.number_of_worked_minutes/60 ;;
    value_format_name: decimal_1
  }

  measure: number_of_no_show_hours {
    type: sum
    label: "# No Show Hours"
    sql: ${TABLE}.number_of_no_show_minutes/60 ;;
    value_format_name: decimal_1
  }

  measure: pct_no_show_hours {
    type: number
    hidden: no
    label: "% No Show Hours "
    sql: ${number_of_no_show_hours}/${number_of_scheduled_hours} ;;
    value_format: "0%"
  }

  measure: pct_sickness_hours {
    type: number
    hidden: no
    label: "% Sickness Hours "
    sql: ${number_of_sick_hours}/${number_of_scheduled_hours} ;;
    value_format: "0%"
  }

  measure: pct_contract_fulfillment {
    type: number
    hidden: no
    label: "% Contracted Hours Fulfillment "
    sql: ${number_of_worked_hours}/(${weekly_contracted_hours}*${number_of_scheduled_weeks}) ;;
    value_format: "0%"
  }

  measure: sum_nps_score {
    type: sum
    hidden: yes
    sql: ${TABLE}.sum_nps_score ;;
  }

  measure: avg_nps_score {
    type: number
    label: "AVG NPS Score"
    sql: ${sum_nps_score}/nullif(${number_of_orders_with_available_nps_score},0) ;;
  }

}
