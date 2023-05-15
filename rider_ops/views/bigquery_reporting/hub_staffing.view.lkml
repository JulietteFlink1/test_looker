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
    convert_tz: yes
  }

  dimension_group: block_starts_at_timestamp {
    type: time
    timeframes: [
      raw,
      time,
      minute30,
      hour_of_day,
      time_of_day,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.block_starts_at_timestamp ;;
    convert_tz: yes
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

  dimension: number_of_online_rider_minutes {
    type: number
    label: "# Online Minutes"
    sql: ${TABLE}.number_of_online_rider_minutes ;;
    value_format_name: decimal_1
    hidden: yes
  }

  dimension: number_of_rider_hub_one_tasks_minutes {
    type: number
    label: "# Hub One Tasks Minutes"
    sql: ${TABLE}.number_of_rider_hub_one_tasks_minutes ;;
    value_format_name: decimal_1
    hidden: yes
  }

  dimension: number_of_rider_equipment_issue_minutes {
    type: number
    label: "# Equipment Issue Minutes"
    sql: ${TABLE}.number_of_rider_equipment_issue_minutes ;;
    value_format_name: decimal_1
    hidden: yes
  }

  dimension: number_of_rider_large_order_support_minutes {
    type: number
    label: "# Large Order Support Minutes"
    sql: ${TABLE}.number_of_rider_large_order_support_minutes ;;
    value_format_name: decimal_1
    hidden: yes
  }

  dimension: number_of_rider_accident_minutes {
    type: number
    label: "# Accident Minutes"
    sql: ${TABLE}.number_of_rider_accident_minutes ;;
    value_format_name: decimal_1
    hidden: yes
  }

  dimension: number_of_rider_temporary_offline_break_minutes {
    type: number
    label: "# Temporary Offline Break Minutes"
    sql: ${TABLE}.number_of_rider_temporary_offline_break_minutes ;;
    value_format_name: decimal_1
    hidden: yes
  }

  dimension: number_of_rider_total_temporary_offline_minutes {
    type: number
    label: "# Total Temporary Offline Minutes"
    sql: ${TABLE}.number_of_rider_total_temporary_offline_minutes ;;
    value_format_name: decimal_1
    hidden: yes
  }

  dimension: number_of_rider_unresponsive_minutes {
    type: number
    label: "# Unresponsive Minutes"
    sql: ${TABLE}.number_of_rider_unresponsive_minutes ;;
    value_format_name: decimal_1
    hidden: yes
  }

  dimension: number_of_rider_other_temporary_offline_minutes {
    type: number
    label: "# Other Temporary Offline Minutes"
    sql: ${TABLE}.number_of_rider_other_temporary_offline_minutes ;;
    value_format_name: decimal_1
    hidden: yes
  }

  dimension_group: shift {
    type: time
    timeframes: [
      raw,
      time,
      minute30,
      hour_of_day,
      time_of_day,
      date,
      week,
      month,
      quarter,
      year,
      day_of_week,
      day_of_week_index
    ]
    sql: ${TABLE}.block_starts_at_timestamp ;;
    convert_tz: yes
  }

  dimension: staffing_uuid {
    type: string
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.staffing_uuid ;;
  }

  dimension_group: last_update {
    type: time
    timeframes: [
      time,
      hour,
      minute
    ]
    convert_tz: yes
    datatype: datetime
    sql: ${TABLE}.last_updated_timestamp ;;
  }


  measure: sum_orders{
    type: sum
    label:"# Orders"
    sql:${number_of_orders};;
    value_format_name: decimal_0
  }

  measure: sum_planned_employees{
    type: sum
    label:"# Scheduled Employees"
    hidden: yes
    description: "Number of Scheduled Employees"
    sql:${number_of_planned_employees};;
    value_format_name: decimal_1
  }

  measure: sum_planned_employees_external{
    type: sum
    hidden: yes
    label: "# Scheduled External Employees"
    description: "Number of Scheduled External Employees"
    sql:${number_of_planned_employees_external};;
    value_format_name: decimal_1
  }

  measure: sum_worked_employees{
    type: sum
    label:"# Worked Employees"
    hidden: yes
    description: "Number of Worked Employees"
    sql:${number_of_worked_employees};;
    value_format_name: decimal_1
  }

  measure: sum_worked_employees_external{
    type: sum
    hidden: yes
    label: "# Worked External Employees"
    description: "Number of Worked External Employees"
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
    label: "# Unassigned External Employees"
    description: "Number of Unassigned External Employees"
    sql:${number_of_unassigned_employees_external};;
    value_format_name: decimal_1
  }

  measure: sum_planned_hours{
    type: sum
    label:"# Filled Hours (Incl. Deleted Excused No Show)"
    description: "Number of Scheduled(Assigned) Hours (including deleted shifts with missing punch and absence, where shift date <= deletion date)"
    sql:${number_of_planned_minutes}/60;;
    value_format_name: decimal_1
  }

  measure: sum_planned_hours_excluding_deleted_shifts{
    type: number
    label:"# Filled Hours (excl. Deleted Excused No Show)"
    description: "Number of Scheduled(Assigned) Hours (excluding deleted shifts with missing punch and absence, where shift date <= deletion date)"
    sql:${sum_planned_hours} - ${number_of_deleted_excused_no_show_minutes};;
    value_format_name: decimal_1
  }

  measure: sum_planned_hours_external{
    type: sum
    label: "# Filled External Hours"
    description: "Number of Scheduled External Hours"
    sql:${number_of_planned_minutes_external}/60;;
    value_format_name: decimal_1
  }

  measure: sum_planned_hours_external_partnership{
    type: sum
    label: "# Filled External Partnership Hours"
    description: "Number of Scheduled External Partnership Hours"
    sql:${TABLE}.number_of_planned_minutes_external_partnership/60;;
    value_format_name: decimal_1
  }

  measure: pct_assigned_hours_external_partnership {
    label: "% Filled External Partnership Hours"
    description: "Share of External Partnership Hours from total Filled Hours"
    type: number
    sql: ${sum_planned_hours_external_partnership}/${sum_planned_hours};;
    value_format_name: percent_1
  }

  measure: sum_planned_hours_external_one_time{
    type: sum
    label: "# Filled External One-time Hours"
    description: "Number of Scheduled External One-time Hours"
    sql: ${TABLE}.number_of_planned_minutes_external_one_time/60;;
    value_format_name: decimal_1
  }

  measure: pct_assigned_hours_external_one_time {
    label: "% Filled External One-time Hours"
    description: "Share of External One-time Hours from total Filled Hours"
    type: number
    sql: ${sum_planned_hours_external_one_time}/${sum_planned_hours};;
    value_format_name: percent_1
    }

  measure: sum_worked_hours{
    type: sum
    label:"# Punched Hours"
    description: "Number of Worked Hours"
    sql:${number_of_worked_minutes}/60;;
    value_format_name: decimal_1
  }

  measure: sum_worked_hours_external{
    type: sum
    label: "# Punched External Hours"
    description: "Number of Worked External Hours"
    sql:${number_of_worked_minutes_external}/60;;
    value_format_name: decimal_1
  }

  measure: sum_worked_hours_external_partnership{
    type: sum
    label: "# Punched External Partnership Hours"
    description: "Number of Worked External Partnership Hours"
    sql: ${TABLE}.number_of_worked_minutes_external_partnership/60;;
    value_format_name: decimal_1
  }

  measure: pct_worked_hours_external_partnership {
    label: "% Punched External Partnership Hours"
    description: "Share of External Partnership Hours from total Punched Hours"
    type: number
    sql: ${sum_worked_hours_external_partnership}/${sum_worked_hours};;
    value_format_name: percent_1
  }

  measure: sum_worked_hours_external_one_time{
    type: sum
    label: "# Punched External One-time Hours"
    description: "Number of Worked External Partnership Hours"
    sql: ${TABLE}.number_of_worked_minutes_external_one_time/60;;
    value_format_name: decimal_1
  }

  measure: pct_worked_hours_external_one_time {
    label: "% Punched External One-time Hours"
    description: "Share of External One-time Hours from total Punched Hours"
    type: number
    sql: ${sum_worked_hours_external_one_time}/${sum_worked_hours};;
    value_format_name: percent_1
  }

  measure: number_of_scheduled_hours {
    label: "# Scheduled Hours"
    description: "# Scheduled Hours (Post-Adjustments) (Assigned + Open)"
    type: number
    sql: ${number_of_unassigned_hours}+${sum_planned_hours};;
    value_format_name: decimal_1
  }

  measure: number_of_scheduled_hours_external {
    label: "# Scheduled External Hours"
    description: "# Scheduled External Hours (Post-Adjustments) (Assigned + Open)"
    type: number
    sql: ${number_of_unassigned_hours_external}+${sum_planned_hours_external};;
    value_format_name: decimal_1
  }

  measure: pct_no_show_employees{
    label:"% Actual No Show Hours"
    type: number
    description: "% Actual No Show Hours"
    sql:(${sum_no_show_hours})/nullif(${sum_planned_hours},0) ;;
    value_format_name: percent_1
  }

  measure: pct_assigned_hours{
    label:"% Assigned Hours"
    type: number
    description: "Assigned Hours / (Assigned Hours + Open Hours)"
    sql:(${sum_planned_hours})/nullif(${sum_planned_hours} + ${number_of_unassigned_hours},0) ;;
    value_format_name: percent_1
  }

  measure: avg_employees_utr{
    label:"UTR"
    type: number
    description: "# Orders (Excl. Cancellations) (Excl. Click & Collect and External Orders for rider position) / # Punched Hours"
    sql:${sum_orders}/ NULLIF(${sum_worked_hours}, 0) ;;
    value_format_name: decimal_2
  }


  measure: number_of_unassigned_hours{
    type: sum
    label:"# Open Hours"
    description: "Number of Unassigned(Open) Hours"
    sql:(${number_of_unassigned_minutes_internal}+${number_of_unassigned_minutes_external})/60;;
    value_format_name: decimal_1
  }

  measure: number_of_unassigned_hours_external{
    type: sum
    label: "# Open External Hours"
    description: "Number of Unassigned(Open) External Hours"
    sql:${number_of_unassigned_minutes_external}/60;;
    value_format_name: decimal_1
  }

  measure: sum_no_show_hours{
    label:"# Actual No Show Hours"
    type: sum
    description: "Sum of No Show Hours"
    sql:${number_of_no_show_minutes}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_excused_no_show_minutes{
    label:"# Excused No Show Hours (included in No show)"
    type: sum
    description: "Sum of Excused No Show Hours (shifts with missing punch and absence)"
    sql:${TABLE}.number_of_excused_no_show_minutes/60;;
    value_format_name: decimal_1
  }

  measure: number_of_unexcused_no_show_minutes{
    label:"# Unexcused No Show Hours (included in No show)"
    type: sum
    description: "Sum of Unexcused No Show Hours (shifts with missing punch and no absence)"
    sql:${TABLE}.number_of_unexcused_no_show_minutes/60;;
    value_format_name: decimal_1
  }

  measure: number_of_deleted_excused_no_show_minutes{
    label:"# Deleted Excused No Show Hours (included in No show)"
    type: sum
    description: "Sum of Deleted Excused No Show Hours (deleted shifts with missing punch and absence, where shift date <= deletion date)"
    sql:${TABLE}.number_of_deleted_excused_no_show_minutes/60;;
    value_format_name: decimal_1
  }

  measure: number_of_deleted_unexcused_no_show_minutes{
    label:"# Deleted Unexcused No Show Hours (not included in No show)"
    type: sum
    description: "Sum of Deleted Unexcused No Show Hours (deleted shifts with missing punch and no absence, where shift date <= deletion date)"
    sql:${TABLE}.number_of_deleted_unexcused_no_show_minutes/60;;
    value_format_name: decimal_1
  }

  measure: sum_no_show_hours_external{
    label: "# No Show External Hours"
    type: sum
    description: "Sum of No Show External Hours"
    sql:${number_of_no_show_minutes_external}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_actual_break_duration_hours{
    label:"# Actual Break Duration Hours"
    type: sum
    description: "Sum of Actual Break Duration Hours"
    sql:${TABLE}.number_of_actual_break_duration_minutes/60;;
    value_format_name: decimal_1
  }

  measure: number_of_planned_break_duration_hours{
    label:"# Planned Break Duration Hours"
    type: sum
    description: "Sum of Planned Break Duration Hours"
    sql:${TABLE}.number_of_planned_break_duration_minutes/60;;
    value_format_name: decimal_1
  }

  measure: number_of_online_rider_hours {
    type: sum
    label: "# Rider Online Hours"
    description: "Number of hours rider spent online.
    It is calculated based on rider state change reason in Workforce app."
    sql: ${number_of_online_rider_minutes}/60 ;;
    value_format_name: decimal_2
  }

  measure: number_of_rider_hub_one_tasks_hours {
    type: sum
    label: "# Rider Hub One Tasks Hours"
    description: "Number of hours rider spent temporary offline due to doing hub one tasks or shelf restocking.
    It is calculated based on rider state change reason in Workforce app."
    sql: ${number_of_rider_hub_one_tasks_minutes}/60 ;;
    value_format_name: decimal_2
  }

  measure: number_of_rider_equipment_issue_hours {
    type: sum
    label: "# Rider Equipment Issue Hours"
    description: "Number of hours rider spent temporary offline due to equipment issues.
    It is calculated based on rider state change reason."
    sql: ${number_of_rider_equipment_issue_minutes}/60 ;;
    value_format_name: decimal_2
  }

  measure: number_of_rider_large_order_support_hours {
    type: sum
    label: "# Rider Large Order Support Hours"
    description: "Number of hours rider spent temporary offline due to supporting large orders.
    It is calculated based on rider state change reason."
    sql: ${number_of_rider_large_order_support_minutes}/60 ;;
    value_format_name: decimal_2
  }

  measure: number_of_rider_accident_hours {
    type: sum
    label: "# Rider Accident Hours"
    description: "Number of hours rider spent temporary offline due to an accident.
    It is calculated based on rider state change reason."
    sql: ${number_of_rider_equipment_issue_minutes}/60 ;;
    value_format_name: decimal_2
  }

  measure: number_of_rider_temporary_offline_break_hours {
    type: sum
    label: "# Rider Temporary Offline Break Hours"
    description: "Number of hours rider spent temporary offline due to taking break.
    It is calculated based on rider state change reason."
    sql: ${number_of_rider_temporary_offline_break_minutes}/60 ;;
    value_format_name: decimal_2
  }

  measure: number_of_rider_total_temporary_offline_hours {
    type: sum
    label: "# Rider Temporary Offline Hours"
    description: "Number of hours rider spent temporary offline.
    It is calculated based on rider state change reason."
    sql: ${number_of_rider_total_temporary_offline_minutes}/60 ;;
    value_format_name: decimal_2
  }

  measure: number_of_rider_other_temporary_offline_hours {
    type: sum
    label: "# Rider Other Temporary Offline Break Hours"
    description: "Number of hours rider spent temporary offline due to doing other tasks than hub one tasks, shelf restocking, equipment issues, supporting large orders, accident and breaks.
    It is calculated based on rider state change reason."
    sql: ${number_of_rider_other_temporary_offline_minutes}/60 ;;
    value_format_name: decimal_2
  }

  measure: number_of_rider_unresponsive_hours {
    type: sum
    label: "# Temporary Offline Hours"
    description: "Number of hours rider spent temporary offline due to: doing hub one tasks, equipment issues, supporting large orders, accidend and breaks.
    It is calculated based on rider state change reason."
    sql: ${number_of_rider_unresponsive_minutes}/60 ;;
    value_format_name: decimal_2
  }

}
