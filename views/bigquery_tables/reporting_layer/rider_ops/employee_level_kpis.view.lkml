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
    sql: ${TABLE}.type_of_contract ;;
  }

  dimension: weekly_contracted_hours {
    type: number
    sql: ${TABLE}.weekly_contracted_hours ;;
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


  measure: number_of_at_customer_time_minutes {
    type: sum
    label: "# At Customer Time Minutes"
    sql: ${TABLE}.number_of_at_customer_time_minutes ;;
  }

  measure: number_of_delivered_orders {
    type: sum
    label: "# Delivered Orders"
    sql: ${TABLE}.number_of_delivered_orders ;;
  }

  measure: number_of_end_early_minutes {
    type: sum
    label: "# Shift End Early Minutes"
    sql: ${TABLE}.number_of_end_early_minutes ;;
  }

  measure: number_of_end_late_minutes {
    type: sum
    label: "# Shift End Late Minutes"
    sql: ${TABLE}.number_of_end_late_minutes ;;
  }

  measure: number_of_no_show_hours {
    type: sum
    label: "# No Show Hours"
    sql: ${TABLE}.number_of_no_show_minutes/60 ;;
  }

  measure: number_of_orders_with_available_nps_score {
    type: sum
    hidden: yes
    sql: ${TABLE}.number_of_orders_with_available_nps_score ;;
  }

  measure: number_of_planned_minutes {
    type: sum
    label: "# Scheduled Hours"
    sql: ${TABLE}.number_of_planned_minutes/60 ;;
  }

  measure: number_of_products_with_damaged_products_issues_post {
    type: sum
    sql: ${TABLE}.number_of_products_with_damaged_products_issues_post ;;
  }

  measure: number_of_return_to_hub_time_minutes {
    type: sum
    sql: ${TABLE}.number_of_return_to_hub_time_minutes ;;
  }

  measure: number_of_sick_hours {
    type: sum
    sql: ${TABLE}.number_of_sick_minutes/60 ;;
  }

  measure: number_of_start_early_minutes {
    type: sum
    sql: ${TABLE}.number_of_start_early_minutes ;;
  }

  measure: number_of_start_late_minutes {
    type: sum
    sql: ${TABLE}.number_of_start_late_minutes ;;
  }

  measure: number_of_worked_hours {
    type: sum
    label: "# Worked Hours"
    sql: ${TABLE}.number_of_worked_minutes/60 ;;
  }

  measure: sum_nps_score {
    type: sum
    sql: ${TABLE}.sum_nps_score ;;
  }

}
