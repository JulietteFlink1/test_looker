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

  dimension: block_start_time {
    type: string
    hidden: yes
    sql: split(${block_starts_at_timestamp_time}," ")[offset(1)];;
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
    sql: ${TABLE}.number_of_forecasted_employees_needed ;;
  }

  dimension: number_of_no_show_employees {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_no_show_employees ;;
  }

  dimension: number_of_no_show_employees_external {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_no_show_employees_external ;;
  }

  dimension: number_of_no_show_employees_internal {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_no_show_employees_internal ;;
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

  dimension: number_of_planned_employees_internal {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_planned_employees_internal ;;
  }

  dimension: number_of_planned_employees_external {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_planned_employees_external ;;
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

  dimension: number_of_worked_employees_external {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_worked_employees_external ;;
  }

  dimension: number_of_worked_employees_internal {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_worked_employees_internal ;;
  }

  dimension: number_of_planned_minutes {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_planned_minutes ;;
  }

  dimension: number_of_planned_minutes_external {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_planned_minutes_external ;;
  }

  dimension: number_of_planned_minutes_internal {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_planned_minutes_internal ;;
  }

  dimension: number_of_worked_minutes {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_worked_minutes ;;
  }

  dimension: number_of_worked_minutes_internal {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_worked_minutes_internal ;;
  }

  dimension: number_of_worked_minutes_external {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_worked_minutes_external ;;
  }

  dimension: number_of_no_show_minutes {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_no_show_minutes ;;
  }

  dimension: number_of_no_show_minutes_internal {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_no_show_minutes_internal ;;
  }

  dimension: number_of_no_show_minutes_external {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_no_show_minutes_external ;;
  }

  dimension: number_of_unassigned_minutes_internal {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_unassigned_minutes_internal ;;
  }

  dimension: number_of_unassigned_minutes_external {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_unassigned_minutes_external ;;
  }

  dimension: number_of_unassigned_employees_internal {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_unassigned_employees_internal ;;
  }

  dimension: number_of_unassigned_employees_external {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_unassigned_employees_external ;;
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
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.staffing_uuid ;;
  }


  dimension: number_of_target_orders_per_employee {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_target_orders_per_employee ;;
  }


  measure: sum_forecast_riders_needed{
    type: sum
    label:"# Forecasted Hours"
    description: "Number of Needed Employee Hours Based on Forecasted Order Demand"
    sql:NULLIF(${number_of_forecast_riders_needed},0)*0.5;;
    value_format_name: decimal_1
  }


  measure: sum_orders{
    type: sum
    label:"# Orders"
    sql:${number_of_orders};;
    value_format_name: decimal_0
  }

  measure: number_of_target_utr{
    type: average
    label:"Target UTR"
    description: "Target UTR used in Forecsating Rider Hours"
    sql:${number_of_target_orders_per_employee};;
    value_format_name: decimal_2
  }

  measure: sum_planned_employees{
    type: sum
    label:"# Scheduled Employees"
    description: "Number of Scheduled Employees"
    sql:${number_of_planned_employees};;
    value_format_name: decimal_1
  }

  measure: sum_planned_employees_external{
    type: sum
    label:"# Scheduled Ext Employees"
    description: "Number of Scheduled Ext Employees"
    sql:${number_of_planned_employees_external};;
    value_format_name: decimal_1
  }


  measure: sum_predicted_orders{
    type: sum
    label:"# Forecasted Orders"
    description: "Number of Forecasted Orders"
    sql:${number_of_predicted_orders};;
    value_format_name: decimal_0
  }


  measure: sum_worked_employees{
    type: sum
    label:"# Worked Employees"
    description: "Number of Worked Employees"
    sql:${number_of_worked_employees};;
    value_format_name: decimal_1
  }

  measure: sum_worked_employees_external{
    type: sum
    label:"# Worked Ext Employees"
    description: "Number of Worked Ext Employees"
    sql:${number_of_worked_employees_external};;
    value_format_name: decimal_1
  }


  measure: sum_unassigned_employees{
    type: sum
    hidden: yes
    label:"# Unassigned Employees"
    description: "Number of Unassigned Employees"
    sql:${number_of_unassigned_employees_internal}+${number_of_unassigned_employees_external};;
    value_format_name: decimal_1
  }

  measure: sum_unassigned_employees_external{
    type: sum
    hidden: yes
    label:"# Unassigned Ext Employees"
    description: "Number of Unassigned Ext Employees"
    sql:${number_of_unassigned_employees_external};;
    value_format_name: decimal_1
  }


  measure: pct_no_show_employees{
    label:"% No Show Hours"
    type: number
    description: "# No Show Hours"
    sql:(${sum_no_show_hours})/nullif(${sum_planned_hours},0) ;;
    value_format_name: percent_1
  }


  measure: sum_planned_hours{
    type: sum
    label:"# Scheduled Hours"
    description: "Number of Scheduled Hours"
    sql:${number_of_planned_minutes}/60;;
    value_format_name: decimal_1
  }

  measure: sum_planned_hours_external{
    type: sum
    label:"# Scheduled Ext Hours"
    description: "Number of Scheduled Ext Hours"
    sql:${number_of_planned_minutes_external}/60;;
    value_format_name: decimal_1
  }

  measure: sum_worked_hours{
    type: sum
    label:"# Worked Hours"
    description: "Number of Worked Hours"
    sql:${number_of_worked_minutes}/60;;
    value_format_name: decimal_1
  }

  measure: sum_worked_hours_external{
    type: sum
    label:"# Worked Ext Hours"
    description: "Number of Worked Ext Hours"
    sql:${number_of_worked_minutes_external}/60;;
    value_format_name: decimal_1
  }


  measure: avg_employees_utr{
    label:"UTR"
    type: number
    description: "Average Employees UTR"
    sql:${sum_orders}/ NULLIF(${sum_worked_hours}, 0) ;;
    value_format_name: decimal_2
  }


  measure: number_of_unassigned_hours{
    type: sum
    label:"# Unassigned Hours"
    description: "Number of Unassigned(Open) Hours"
    sql:(${number_of_unassigned_minutes_internal}+${number_of_unassigned_minutes_external})/60;;
    value_format_name: decimal_1
  }

  measure: number_of_unassigned_hours_external{
    type: sum
    label:"# Unassigned Ext Hours"
    description: "Number of Unassigned(Open) Ext Hours"
    sql:${number_of_unassigned_minutes_external}/60;;
    value_format_name: decimal_1
  }

  measure: sum_no_show_hours{
    label:"# No Show Hours"
    type: sum
    description: "Sum of No Show Hours"
    sql:${number_of_no_show_minutes}/60;;
    value_format_name: decimal_1
  }

  measure: sum_no_show_hours_external{
    label:"# No Show Ext Hours"
    type: sum
    description: "Sum of No Show Ext Hours"
    sql:${number_of_no_show_minutes_external}/60;;
    value_format_name: decimal_1
  }

  measure: sum_hours_needed {
    type: number
    label:"# Actual Needed Hours"
    description: "Number of needed Employees based on actual order demand"
    sql:ceiling(${sum_orders} / (${number_of_target_utr} / 2));;
    value_format_name: decimal_1
  }


  measure: expected_utr {
    type: number
    label:"# Projected Rider UTR"
    description: "Forecasted Orders / Scheduled Rider Hours"
    sql:${sum_predicted_orders} / ${sum_planned_hours};;
    value_format_name: decimal_1
  }

  measure: pct_over_stafing {
    type: number
    label:"% Over Staffing "
    description: "When Forecasted Hours > Scheduled Hours: (Forecasted Hours - Scheduled Hours) / Forecasted Hours"
    sql:case when ${sum_forecast_riders_needed} > ${sum_planned_hours}
                  then (${sum_forecast_riders_needed} - ${sum_planned_hours} )  / ${sum_forecast_riders_needed}
             else
                  0
        end          ;;
    value_format_name: percent_0
  }

  measure: pct_under_stafing {
    type: number
    label:"% Under Staffing "
    description: "When Forecasted Hours < Scheduled Hours: (Scheduled Hours - Forecasted Hours) / Forecasted Hours"
    sql:case when ${sum_forecast_riders_needed} < ${sum_planned_hours}
                  then (${sum_planned_hours} - ${sum_forecast_riders_needed})  / ${sum_forecast_riders_needed}
             else
                  0
        end          ;;
    value_format_name: percent_0
  }

  measure: forecast_deviation {
    type: number
    label:"% Forecast Deviation "
    description: "absolute (Forecasted Orders / Actual Orders)"
    sql:abs(${sum_predicted_orders}/${sum_orders});;
    value_format_name: percent_0
  }


}
