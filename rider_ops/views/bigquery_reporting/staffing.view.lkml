# Owner:   Nazrin Guliyeva
# Created: 2022-05-06

# This model is built on top of the existing hub_staffing model. It provides employee-related KPIs
# such as worked minutes, no show minutes, planned employees, etc. calculated per each position
# on a hub + 30-min slot level

view: staffing {
  sql_table_name: `flink-data-prod.reporting.staffing`
    ;;

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  dimension: city {
    label: "City"
    type: string
    sql: ${TABLE}.city ;;
    hidden: yes
  }

  dimension: country_iso {
    label: "Country"
    type: string
    sql: ${TABLE}.country_iso ;;
    hidden: yes
  }

  dimension: hub_code {
    label: "Hub code"
    type: string
    sql: ${TABLE}.hub_code ;;
    hidden: yes
  }

  dimension_group: end_timestamp {
    label: "End of 30 mins slot"
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
    sql: ${TABLE}.end_timestamp ;;
    hidden: yes
  }
  dimension_group: last_update {
    type: time
    timeframes: [
      time
    ]
    convert_tz: yes
    datatype: datetime
    sql: ${TABLE}.last_updated_timestamp ;;
  }
  ##### Riders

  dimension: number_of_deleted_unexcused_no_show_minutes_rider {
    label: "# Deleted Unexcused Rider No Show Hours (Excl. in No Show metric)"
    type: number
    sql: ${TABLE}.number_of_deleted_unexcused_no_show_minutes_rider ;;
    hidden: yes
  }

  dimension: number_of_deleted_excused_no_show_minutes_rider {
    label: "# Deleted Excused Rider No Show Hours (included in No show metric)"
    type: number
    sql: ${TABLE}.number_of_deleted_excused_no_show_minutes_rider ;;
    hidden: yes
  }

  dimension: number_of_scheduled_hours_rider_dimension {
    label: "# Scheduled Rider Hours (Incl. Deleted Excused No Show) - Dimension"
    type: number
    sql: (${TABLE}.number_of_planned_minutes_rider + ${TABLE}.number_of_unassigned_minutes_external_rider+${TABLE}.number_of_unassigned_minutes_internal_rider)/60 ;;
    hidden: yes
  }

  dimension: number_of_no_show_minutes_internal_rider {
    label: "# No Show Internal Rider Minutes"
    type: number
    sql: ${TABLE}.number_of_no_show_minutes_internal_rider ;;
    hidden: yes
  }

  dimension: number_of_no_show_minutes_external_rider {
    label: "# No Show External Rider Minutes"
    type: number
    sql: ${TABLE}.number_of_no_show_minutes_external_rider ;;
    hidden: yes
  }
  dimension: number_of_leave_minutes_rider_dimension {
    label: "# Leave Rider Minutes"
    type: number
    sql: ${TABLE}.number_of_leave_minutes_rider ;;
    hidden: yes
  }

  dimension: number_of_leave_minutes_internal_rider {
    label: "# Leave Internal Rider Minutes"
    type: number
    sql: ${TABLE}.number_of_leave_minutes_internal_rider ;;
    hidden: yes
  }

  dimension: number_of_leave_minutes_external_rider {
    label: "# Leave External Rider Minutes"
    type: number
    sql: ${TABLE}.number_of_leave_minutes_external_rider ;;
    hidden: yes
  }
  dimension: number_of_excused_no_show_minutes_internal_rider {
    label: "# Excused Internal No Show Rider Minutes"
    type: number
    sql: ${TABLE}.number_of_excused_no_show_minutes_internal_rider ;;
    hidden: yes
  }
  dimension: number_of_excused_no_show_minutes_external_rider {
    label: "# Excused External No Show Rider Minutes"
    type: number
    sql: ${TABLE}.number_of_excused_no_show_minutes_external_rider ;;
    hidden: yes
  }
  dimension: number_of_excused_no_show_minutes_rider {
    label: "# Excused No Show Rider Minutes"
    type: number
    sql: ${TABLE}.number_of_excused_no_show_minutes_rider ;;
    hidden: yes
  }

  dimension: number_of_planned_minutes_rider {
    label: "# Planned Rider Minutes"
    type: number
    sql: ${TABLE}.number_of_planned_minutes_rider ;;
    hidden: yes
  }

  dimension: number_of_unassigned_employees_external_rider {
    label: "# Unassigned External Riders"
    type: number
    sql: ${TABLE}.number_of_unassigned_employees_external_rider ;;
    hidden: yes
  }

  dimension: number_of_unassigned_employees_internal_rider {
    label: "# Unassigned Internal Riders"
    type: number
    sql: ${TABLE}.number_of_unassigned_employees_internal_rider ;;
    hidden: yes
  }
  dimension: number_of_unassigned_minutes_external_rider {
    label: "# Unassigned External Rider Minutes"
    type: number
    sql: ${TABLE}.number_of_unassigned_minutes_external_rider ;;
    hidden: yes
  }

  dimension: number_of_unassigned_minutes_internal_rider_dimension {
    label: "# Unassigned Internal Rider Minutes"
    type: number
    sql: ${TABLE}.number_of_unassigned_minutes_internal_rider ;;
    hidden: yes
  }
  dimension: number_of_worked_employees_external_rider {
    label: "# Worked External Riders"
    type: number
    sql: ${TABLE}.number_of_worked_employees_external_rider ;;
    hidden: yes
  }
  dimension: number_of_worked_employees_internal_rider {
    label: "# Worked Internal Riders"
    type: number
    sql: ${TABLE}.number_of_worked_employees_internal_rider ;;
    hidden: yes
  }

  dimension: number_of_worked_employees_rider {
    label: "# Worked Riders"
    type: number
    sql: ${TABLE}.number_of_worked_employees_rider ;;
    hidden: yes
  }
  dimension: number_of_worked_minutes_external_rider {
    label: "# Worked External Rider Minutes"
    type: number
    sql: ${TABLE}.number_of_worked_minutes_external_rider ;;
    hidden: yes
  }
  dimension: number_of_worked_minutes_rider {
    label: "# Worked Rider Minutes"
    type: number
    sql: ${TABLE}.number_of_worked_minutes_rider ;;
    hidden: yes
  }
  dimension: number_of_planned_employees_internal_rider {
    label: "# Planned Internal Riders"
    type: number
    sql: ${TABLE}.number_of_planned_employees_internal_rider ;;
    hidden: yes
  }

  dimension: number_of_planned_employees_rider {
    label: "# Planned Riders"
    type: number
    sql: ${TABLE}.number_of_planned_employees_rider ;;
    hidden: yes
  }
  dimension: number_of_planned_minutes_external_rider {
    label: "# Planned External Rider Minutes"
    type: number
    sql: ${TABLE}.number_of_planned_minutes_external_rider ;;
    hidden: yes
  }
  dimension: number_of_planned_minutes_internal_rider {
    label: "# Planned Internal Rider Minutes"
    type: number
    sql: ${TABLE}.number_of_planned_minutes_internal_rider ;;
    hidden: yes
  }

  dimension: number_of_worked_minutes_internal_rider {
    label: "# Worked Internal Rider Minutes"
    type: number
    sql: ${TABLE}.number_of_worked_minutes_internal_rider ;;
    hidden: yes

  }

  dimension: number_of_unexcused_no_show_minutes_rider {
    label: "# Unexcused No Show Rider minutes"
    type: number
    sql: ${TABLE}.number_of_unexcused_no_show_minutes_rider ;;
    hidden: yes

  }

  dimension: number_of_online_minutes_rider {
    type: number
    label: "# Online Minutes"
    sql: ${TABLE}.number_of_online_minutes_rider ;;
    value_format_name: decimal_1
    hidden: yes
  }

  dimension: number_of_hub_one_tasks_minutes_rider {
    type: number
    label: "# Hub One Tasks Minutes"
    sql: ${TABLE}.number_of_hub_one_tasks_minutes_rider ;;
    value_format_name: decimal_1
    hidden: yes
  }

  dimension: number_of_equipment_issue_minutes_rider {
    type: number
    label: "# Equipment Issue Minutes"
    sql: ${TABLE}.number_of_equipment_issue_minutes_rider ;;
    value_format_name: decimal_1
    hidden: yes
  }

  dimension: number_of_large_order_support_minutes_rider {
    type: number
    label: "# Large Order Support Minutes"
    sql: ${TABLE}.number_of_large_order_support_minutes_rider ;;
    value_format_name: decimal_1
    hidden: yes
  }

  dimension: number_of_accident_minutes_rider {
    type: number
    label: "# Accident Minutes"
    sql: ${TABLE}.number_of_accident_minutes_rider ;;
    value_format_name: decimal_1
    hidden: yes
  }

  dimension: number_of_temporary_offline_break_minutes_rider {
    type: number
    label: "# Temporary Offline Break Minutes"
    sql: ${TABLE}.number_of_temporary_offline_break_minutes_rider ;;
    value_format_name: decimal_1
    hidden: yes
  }

  dimension: number_of_total_temporary_offline_minutes_rider {
    type: number
    label: "# Total Temporary Offline Minutes"
    sql: ${TABLE}.number_of_total_temporary_offline_minutes_rider ;;
    value_format_name: decimal_1
    hidden: yes
  }

  dimension: number_of_unresponsive_minutes_rider {
    type: number
    label: "# Unresponsive Minutes"
    sql: ${TABLE}.number_of_unresponsive_minutes_rider ;;
    value_format_name: decimal_1
    hidden: yes
  }

  dimension: number_of_other_temporary_offline_minutes_rider {
    type: number
    label: "# Other Temporary Offline Minutes"
    sql: ${TABLE}.number_of_other_temporary_offline_minutes_rider ;;
    value_format_name: decimal_1
    hidden: yes
  }

  ##### Shift Lead

  dimension: number_of_unexcused_no_show_minutes_shift_lead {
    label: "# Unexcused No Show Shift Lead minutes"
    type: number
    sql: ${TABLE}.number_of_unexcused_no_show_minutes_shift_lead ;;
    hidden: yes

  }

  dimension: number_of_excused_no_show_minutes_external_shift_lead {
    label: "# Excused No Show External Shift Lead Minutes"
    type: number
    sql: ${TABLE}.number_of_excused_no_show_minutes_external_shift_lead ;;
    hidden: yes

  }
  dimension: number_of_excused_no_show_minutes_internal_shift_lead {
    label: "# Excused No Show Internal Shift Lead Minutes"
    type: number
    sql: ${TABLE}.number_of_excused_no_show_minutes_internal_shift_lead ;;
    hidden: yes

  }
  dimension: number_of_excused_no_show_minutes_shift_lead {
    label: "# Excused No Show Shift Lead Minutes"
    type: number
    sql: ${TABLE}.number_of_excused_no_show_minutes_shift_lead ;;
    hidden: yes

  }

  dimension: number_of_no_show_minutes_external_shift_lead {
    label: "# No Show External Shift Lead Minutes"
    type: number
    sql: ${TABLE}.number_of_no_show_minutes_external_shift_lead ;;
    hidden: yes

  }
  dimension: number_of_no_show_minutes_internal_shift_lead {
    label: "# No Show Internal Shift Lead Minutes"
    type: number
    sql: ${TABLE}.number_of_no_show_minutes_internal_shift_lead ;;
    hidden: yes

  }
  dimension: number_of_no_show_minutes_shift_lead {
    label: "# No Show Shift Lead Minutes"
    type: number
    sql: ${TABLE}.number_of_no_show_minutes_shift_lead ;;
    hidden: yes

  }
  dimension: number_of_planned_employees_external_shift_lead {
    label: "# Planned External Shift Leads"
    type: number
    sql: ${TABLE}.number_of_planned_employees_external_shift_lead ;;
    hidden: yes

  }
  dimension: number_of_planned_employees_internal_shift_lead {
    label: "# Planned Internal Shift Leads"
    type: number
    sql: ${TABLE}.number_of_planned_employees_internal_shift_lead ;;
    hidden: yes

  }
  dimension: number_of_planned_employees_shift_lead {
    label: "# Planned Shift Leads"
    type: number
    sql: ${TABLE}.number_of_planned_employees_shift_lead ;;
    hidden: yes

  }
  dimension: number_of_planned_minutes_external_shift_lead {
    label: "# Planned External Shift Lead Minutes"
    type: number
    sql: ${TABLE}.number_of_planned_minutes_external_shift_lead ;;
    hidden: yes

  }
  dimension: number_of_planned_minutes_internal_shift_lead {
    label: "# Planned Internal Shift Lead Minutes"
    type: number
    sql: ${TABLE}.number_of_planned_minutes_internal_shift_lead ;;
    hidden: yes

  }
  dimension: number_of_planned_minutes_shift_lead {
    label: "# Planned Shift Lead Minutes"
    type: number
    sql: ${TABLE}.number_of_planned_minutes_shift_lead ;;
    hidden: yes

  }
  dimension: number_of_unassigned_employees_external_shift_lead {
    label: "# Unassigned External Shift Leads"
    type: number
    sql: ${TABLE}.number_of_unassigned_employees_external_shift_lead ;;
    hidden: yes

  }
  dimension: number_of_unassigned_employees_internal_shift_lead {
    label: "# Unassigned Internal Shift Leads"
    type: number
    hidden: yes

  }
  dimension: number_of_unassigned_minutes_external_shift_lead {
    label: "# Unassigned External Shift Lead Minutes"
    type: number
    sql: ${TABLE}.number_of_unassigned_minutes_external_shift_lead ;;
    hidden: yes

  }
  dimension: number_of_unassigned_minutes_internal_shift_lead {
    label: "# Unassigned Internal Shift Lead Minutes"
    type: number
    sql: ${TABLE}.number_of_unassigned_minutes_internal_shift_lead ;;
    hidden: yes
  }
  dimension: number_of_worked_employees_external_shift_lead {
    label: "# Worked External Shift Leads"
    type: number
    sql: ${TABLE}.number_of_worked_employees_external_shift_lead ;;
    hidden: yes
  }
  dimension: number_of_worked_minutes_external_shift_lead {
    label: "# Worked External Shift Lead Minutes"
    type: number
    sql: ${TABLE}.number_of_worked_minutes_external_shift_lead ;;
    hidden: yes
  }
  dimension: number_of_worked_employees_internal_shift_lead {
    label: "# Worked Internal Shift Leads"
    type: number
    sql: ${TABLE}.number_of_worked_employees_internal_shift_lead ;;
    hidden: yes
  }
  dimension: number_of_worked_employees_shift_lead {
    label: "# Worked Shift Leads"
    type: number
    sql: ${TABLE}.number_of_worked_employees_shift_lead ;;
    hidden: yes
  }
  dimension: number_of_worked_minutes_internal_shift_lead {
    label: "# Worked Internal Shift Leads"
    type: number
    sql: ${TABLE}.number_of_worked_minutes_internal_shift_lead ;;
    hidden: yes
  }
  dimension: number_of_worked_minutes_shift_lead {
    label: "# Worked Shift Lead Minutes"
    type: number
    sql: ${TABLE}.number_of_worked_minutes_shift_lead ;;
    hidden: yes
  }

  dimension: number_of_worked_minutes_ops_associate_plus {
    alias: [number_of_worked_minutes_deputy_shift_lead]
    label: "# Worked Shift Lead Minutes"
    type: number
    sql: ${TABLE}.number_of_worked_minutes_ops_associate_plus ;;
    hidden: yes
  }

  dimension: number_of_planned_minutes_ops_associate_plus {
    label: "# Filled (Assigned) Shift Lead Minutes"
    type: number
    sql: ${TABLE}.number_of_planned_minutes_ops_associate_plus ;;
    hidden: yes
  }

  dimension: number_of_worked_minutes_ops_associate_dimension {
    label: "# Punched Ops Associate Minutes"
    type: number
    sql: ${TABLE}.number_of_worked_minutes_ops_associate ;;
    hidden: yes
  }

  dimension: number_of_planned_minutes_ops_associate_dimension {
    label: "# Filled (Assigned) Ops Associate Minutes"
    type: number
    sql: ${TABLE}.number_of_planned_minutes_ops_associate ;;
    value_format_name: decimal_1
    hidden: yes
  }

  dimension: number_of_deleted_excused_no_show_minutes_shift_lead {
    label: "# Deleted Excused Shift Lead No Show Hours (included in No show metric)"
    type: number
    sql: ${TABLE}.number_of_deleted_excused_no_show_minutes_shift_lead ;;
    hidden: yes
  }

  dimension: number_of_deleted_unexcused_no_show_minutes_shift_lead {
    label: "# Deleted Unexcused Shift Lead No Show Hours (Excl. in No Show metric)"
    type: number
    sql: ${TABLE}.number_of_deleted_unexcused_no_show_minutes_shift_lead ;;
    hidden: yes
  }

  dimension_group: shift {
    label: "Shift"
    type: time
    timeframes: [
      raw,
      date,
      minute30,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.shift_date ;;
    hidden: yes
  }

  dimension: staffing_uuid {
    type: string
    sql: ${TABLE}.staffing_uuid ;;
    hidden: yes
    primary_key: yes
  }

  dimension_group: start_timestamp {
    label: "Timeslot"
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
    sql: ${TABLE}.start_timestamp ;;
    convert_tz: yes
    hidden: yes
  }

  dimension: timezone {
    type: string
    sql: ${TABLE}.timezone ;;
    hidden: yes
  }

  dimension: number_of_worked_minutes_hub_staff {
    label: "# Punched Hub Staff Minutes"
    description: "# Punched Ops Associate Hours (Picker, WH, Ops Associate, Rider Captain and Ops Associate +) + # Planned Shift Lead hours"
    type: number
    sql: ${number_of_worked_minutes_ops_associate_dimension}+${number_of_worked_minutes_shift_lead}+${number_of_worked_minutes_ops_associate_plus};;
    value_format_name: decimal_1
    hidden: yes
  }

  dimension: number_of_planned_minutes_hub_staff {
    label: "# Filled (Assigned) Hub Staff Minutes"
    description: "# Filled (Assigned) Ops Associate Hours (Picker, WH, Ops Associate, Rider Captain and Ops Associate +) + # Planned Shift Lead hours Excl. hours from shifts with project code = 'Refilled shift'"
    type: number
    sql: ${number_of_planned_minutes_ops_associate_dimension}+${number_of_planned_minutes_shift_lead}+${number_of_planned_minutes_ops_associate_plus};;
    value_format_name: decimal_1
    hidden: yes
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  measure: count {
    type: count
    drill_fields: []
    hidden: yes
  }

###### Ops Associate

  measure: number_of_planned_employees_ops_associate {
    group_label: "> Ops Associate Measures"
    label: "# Planned Ops Associates"
    type: sum
    sql: ${TABLE}.number_of_planned_employees_ops_associate;;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: number_of_planned_employees_internal_ops_associate {
    group_label: "> Ops Associate Measures"
    label: "# Planned Internal Ops Associates"
    type: sum
    sql: ${TABLE}.number_of_planned_employees_internal_ops_associate;;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: number_of_planned_employees_external_ops_associate {
    group_label: "> Ops Associate Measures"
    label: "# Planned External Ops Associates"
    type: sum
    sql: ${TABLE}.number_of_planned_employees_external_ops_associate;;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: number_of_worked_minutes_ops_associate {
    group_label: "> Ops Associate Measures"
    label: "# Punched Ops Associate Minutes"
    type: sum
    sql: ${TABLE}.number_of_worked_minutes_ops_associate ;;
    hidden: yes
  }

  measure: number_of_worked_minutes_internal_ops_associate {
    group_label: "> Ops Associate Measures"
    label: "# Punched Internal Ops Associate Minutes"
    type: sum
    sql: ${TABLE}.number_of_worked_minutes_internal_ops_associate ;;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: number_of_worked_minutes_external_ops_associate {
    group_label: "> Ops Associate Measures"
    label: "# Punched External Ops Associate Minutes"
    type: sum
    sql: ${TABLE}.number_of_worked_minutes_external_ops_associate ;;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: number_of_no_show_employees_ops_associate {
    group_label: "> Ops Associate Measures"
    label: "# No Show Ops Associates"
    type: sum
    sql: ${TABLE}.number_of_no_show_employees_ops_associate;;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: number_of_no_show_employees_internal_ops_associate {
    group_label: "> Ops Associate Measures"
    label: "# No Show Internal Ops Associates"
    type: sum
    sql: ${TABLE}.number_of_no_show_employees_internal_ops_associate;;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: number_of_no_show_employees_external_ops_associate {
    group_label: "> Ops Associate Measures"
    label: "# No Show External Ops Associates"
    type: sum
    sql: ${TABLE}.number_of_no_show_employees_external_ops_associate;;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: number_of_no_show_minutes_ops_associate {
    group_label: "> Ops Associate Measures"
    label: "# No Show Ops Associate Minutes"
    type: sum
    sql: ${TABLE}.number_of_no_show_minutes_ops_associate;;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: number_of_no_show_minutes_internal_ops_associate {
    group_label: "> Ops Associate Measures"
    label: "# No Show Internal Ops Associate Minutes"
    type: sum
    sql: ${TABLE}.number_of_no_show_minutes_internal_ops_associate;;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: number_of_no_show_minutes_external_ops_associate {
    group_label: "> Ops Associate Measures"
    label: "# No Show External Ops Associate Minutes"
    type: sum
    sql: ${TABLE}.number_of_no_show_minutes_external_ops_associate;;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: number_of_excused_no_show_minutes_ops_associate {
    group_label: "> Ops Associate Measures"
    label: "# Excused No Show Ops Associate Minutes"
    type: sum
    sql: ${TABLE}.number_of_excused_no_show_minutes_ops_associate;;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: number_of_deleted_excused_no_show_minutes_ops_associate {
    group_label: "> Ops Associate Measures"
    label: "# Deleted Excused No Show Ops Associate Minutes"
    type: sum
    sql: ${TABLE}.number_of_deleted_excused_no_show_minutes_ops_associate;;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: number_of_unexcused_no_show_minutes_ops_associate {
    group_label: "> Ops Associate Measures"
    label: "# Unexcused No Show Ops Associate Minutes"
    type: sum
    sql: ${TABLE}.number_of_unexcused_no_show_minutes_ops_associate;;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: number_of_deleted_unexcused_no_show_minutes_ops_associate {
    group_label: "> Ops Associate Measures"
    label: "# Deleted Unexcused No Show Ops Associate Minutes"
    type: sum
    sql: ${TABLE}.number_of_deleted_unexcused_no_show_minutes_ops_associate;;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: number_of_leave_minutes_ops_associate {
    group_label: "> Ops Associate Measures"
    label: "# Leave Ops Associate Minutes"
    type: sum
    sql: ${TABLE}.number_of_leave_minutes_ops_associate;;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: number_of_leave_minutes_internal_ops_associate {
    group_label: "> Ops Associate Measures"
    label: "# Leave Internal Ops Associate Minutes"
    type: sum
    sql: ${TABLE}.number_of_leave_minutes_internal_ops_associate;;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: number_of_leave_minutes_external_ops_associate {
    group_label: "> Ops Associate Measures"
    label: "# Leave External Ops Associate Minutes"
    type: sum
    sql: ${TABLE}.number_of_leave_minutes_external_ops_associate;;
    value_format_name: decimal_1
    hidden: yes
  }

##### Ops Associate +

  measure: number_of_planned_employees_ops_associate_plus {
    alias: [number_of_planned_employees_deputy_shift_lead]
    group_label: "> Ops Associate + Measures"
    label: "# Planned Ops Associate +"
    type: sum
    sql: ${TABLE}.number_of_planned_employees_ops_associate_plus ;;
    value_format_name: decimal_0
    hidden: yes
  }

  measure: number_of_planned_employees_internal_ops_associate_plus {
    alias: [number_of_planned_employees_internal_deputy_shift_lead]
    group_label: "> Ops Associate + Measures"
    label: "# Planned Internal Ops Associate +"
    type: sum
    sql: ${TABLE}.number_of_planned_employees_internal_ops_associate_plus ;;
    value_format_name: decimal_0
    hidden: yes
  }

  measure: number_of_planned_employees_external_ops_associate_plus {
    alias: [number_of_planned_employees_external_deputy_shift_lead]
    group_label: "> Ops Associate + Measures"
    label: "# Planned External Ops Associate +"
    type: sum
    sql: ${TABLE}.number_of_planned_employees_external_ops_associate_plus ;;
    value_format_name: decimal_0
    hidden: yes
  }

  measure: number_of_worked_hours_ops_associate_plus {
    alias: [number_of_worked_hours_deputy_shift_lead]
    group_label: "> Ops Associate + Measures"
    label: "# Punched Ops Associate + Hours"
    type: sum
    sql: ${TABLE}.number_of_worked_minutes_ops_associate_plus/60 ;;
    value_format_name: decimal_1
  }

  measure: number_of_worked_hours_internal_ops_associate_plus {
    alias: [number_of_worked_hours_internal_deputy_shift_lead]
    group_label: "> Ops Associate + Measures"
    label: "# Punched Internal Ops Associate + Hours"
    type: sum
    sql: ${TABLE}.number_of_worked_minutes_internal_ops_associate_plus/60 ;;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: number_of_worked_hours_external_ops_associate_plus {
    alias: [number_of_worked_hours_external_deputy_shift_lead]
    group_label: "> Ops Associate + Measures"
    label: "# External Punched Ops Associate + Hours"
    type: sum
    sql: ${TABLE}.number_of_worked_minutes_external_ops_associate_plus/60 ;;
    value_format_name: decimal_1
  }

  measure: number_of_no_show_employees_ops_associate_plus {
    alias: [number_of_no_show_employees_deputy_shift_lead]
    group_label: "> Ops Associate + Measures"
    label: "# No Show Ops Associate +"
    type: sum
    sql: ${TABLE}.number_of_no_show_employees_ops_associate_plus ;;
    value_format_name: decimal_0
    hidden: yes
  }

  measure: number_of_no_show_employees_internal_ops_associate_plus {
    alias: [number_of_no_show_employees_internal_deputy_shift_lead]
    group_label: "> Ops Associate + Measures"
    label: "# No Show Internal Ops Associate +"
    type: sum
    sql: ${TABLE}.number_of_no_show_employees_internal_ops_associate_plus ;;
    value_format_name: decimal_0
    hidden: yes
  }

  measure: number_of_no_show_employees_external_ops_associate_plus {
    alias: [number_of_no_show_employees_external_deputy_shift_lead]
    group_label: "> Ops Associate + Measures"
    label: "# No Show External Ops Associate +"
    type: sum
    sql: ${TABLE}.number_of_no_show_employees_external_ops_associate_plus ;;
    value_format_name: decimal_0
    hidden: yes
  }

  measure: number_of_no_show_hours_ops_associate_plus {
    alias: [number_of_no_show_hours_deputy_shift_lead]
    group_label: "> Ops Associate + Measures"
    label: "# No Show Ops Associate + Hours"
    type: sum
    sql: ${TABLE}.number_of_no_show_minutes_ops_associate_plus/60;;
    value_format_name: decimal_1
  }

  measure: number_of_no_show_hours_internal_ops_associate_plus {
    alias: [number_of_no_show_hours_internal_deputy_shift_lead]
    group_label: "> Ops Associate + Measures"
    label: "# Internal No Show Ops Associate + Hours"
    type: sum
    sql: ${TABLE}.number_of_no_show_minutes_internal_ops_associate_plus/60;;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: number_of_no_show_hours_external_ops_associate_plus {
    alias: [number_of_no_show_hours_external_deputy_shift_lead]
    group_label: "> Ops Associate + Measures"
    label: "# External No Show Ops Associate + Hours"
    type: sum
    sql: ${TABLE}.number_of_no_show_minutes_external_ops_associate_plus/60;;
    value_format_name: decimal_1
  }

  measure: number_of_excused_no_show_hours_ops_associate_plus {
    alias: [number_of_excused_no_show_hours_deputy_shift_lead]
    group_label: "> Ops Associate + Measures"
    label: "# Excused No Show Ops Associate + Hours"
    type: sum
    sql: ${TABLE}.number_of_excused_no_show_minutes_ops_associate_plus/60;;
    value_format_name: decimal_1
  }

  measure: number_of_deleted_excused_no_show_hours_ops_associate_plus {
    alias: [number_of_deleted_excused_no_show_hours_deputy_shift_lead]
    group_label: "> Ops Associate + Measures"
    label: "# Deleted Excused No Show Ops Associate + Hours"
    type: sum
    sql: ${TABLE}.number_of_deleted_excused_no_show_minutes_ops_associate_plus/60;;
    value_format_name: decimal_1
  }

  measure: number_of_unexcused_no_show_hours_ops_associate_plus {
    alias: [number_of_unexcused_no_show_hours_deputy_shift_lead]
    group_label: "> Ops Associate + Measures"
    label: "# Unexcused No Show Ops Associate + Hours"
    type: sum
    sql: ${TABLE}.number_of_unexcused_no_show_minutes_ops_associate_plus/60;;
    value_format_name: decimal_1
  }

  measure: number_of_deleted_unexcused_no_show_hours_ops_associate_plus {
    alias: [number_of_deleted_unexcused_no_show_hours_deputy_shift_lead]
    group_label: "> Ops Associate + Measures"
    label: "# Deleted Unexcused No Show Ops Associate + Hours (Excl. in No Show metric)"
    type: sum
    sql: ${TABLE}.number_of_deleted_unexcused_no_show_minutes_ops_associate_plus/60;;
    value_format_name: decimal_1
  }

  measure: number_of_unassigned_employees_internal_ops_associate_plus {
    alias: [number_of_unassigned_employees_internal_deputy_shift_lead]
    group_label: "> Ops Associate + Measures"
    label: "# Unassigned (Open) Internal Ops Associate +"
    type: sum
    sql: ${TABLE}.number_of_unassigned_employees_internal_ops_associate_plus ;;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: number_of_unassigned_employees_external_ops_associate_plus {
    alias: [number_of_unassigned_employees_external_deputy_shift_lead]
    group_label: "> Ops Associate + Measures"
    label: "# Unassigned External Ops Associate +"
    type: sum
    sql: ${TABLE}.number_of_unassgined_employees_external_ops_associate_plus ;;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: number_of_unassigned_employees_ops_associate_plus {
    alias: [number_of_unassigned_employees_deputy_shift_lead]
    group_label: "> Ops Associate + Measures"
    label: "# Unassigned (Open) Ops Associate +"
    type: number
    sql: ${number_of_unassigned_employees_internal_ops_associate_plus}+${number_of_unassigned_employees_external_ops_associate_plus};;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: number_of_unassigned_hours_internal_ops_associate_plus {
    alias: [number_of_unassigned_hours_internal_deputy_shift_lead]
    group_label: "> Ops Associate + Measures"
    label: "# Unassigned (Open) Internal Ops Associate + Hours"
    type: sum
    sql: ${TABLE}.number_of_unassigned_minutes_internal_ops_associate_plus/60;;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: number_of_unassigned_hours_external_ops_associate_plus {
    alias: [number_of_unassigned_hours_external_deputy_shift_lead]
    group_label: "> Ops Associate + Measures"
    label: "# Open External Ops Associate + Hours"
    type: sum
    sql: ${TABLE}.number_of_unassigned_minutes_external_ops_associate_plus/60;;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: number_of_unassigned_hours_ops_associate_plus {
    alias: [number_of_unassigned_hours_deputy_shift_lead]
    group_label: "> Ops Associate + Measures"
    label: "# Open Ops Associate + Hours"
    type: number
    sql: ${number_of_unassigned_hours_internal_ops_associate_plus}+${number_of_unassigned_hours_external_ops_associate_plus};;
    value_format_name: decimal_1
  }

  measure: number_of_planned_hours_external_ops_associate_plus {
    alias: [number_of_planned_hours_external_deputy_shift_lead]
    group_label: "> Ops Associate + Measures"
    label: "# Planned External Ops Associate + Hours"
    type: sum
    sql: ${TABLE}.number_of_planned_minutes_external_ops_associate_plus/60 ;;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: number_of_planned_hours_internal_ops_associate_plus {
    alias: [number_of_planned_hours_internal_deputy_shift_lead]
    group_label: "> Ops Associate + Measures"
    label: "# Planned Internal Ops Associate + Hours"
    type: sum
    sql: ${TABLE}.number_of_planned_minutes_internal_ops_associate_plus/60 ;;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: number_of_planned_hours_ops_associate_plus {
    alias: [number_of_planned_hours_deputy_shift_lead]
    group_label: "> Ops Associate + Measures"
    label: "# Filled (Assigned) Planned Ops Associate + Hours"
    description: "# Filled (Assigned) Ops Associate + Hours Excl. hours from shifts with project code = 'Refilled shift'"
    type: sum
    sql: ${TABLE}.number_of_planned_minutes_ops_associate_plus/60 ;;
    value_format_name: decimal_1
  }

  measure: number_of_worked_employees_ops_associate_plus {
    alias: [number_of_worked_employees_deputy_shift_lead]
    group_label: "> Ops Associate + Measures"
    label: "# Punched Ops Associate +"
    type: sum
    sql: ${TABLE}.number_of_worked_employees_ops_associate_plus ;;
    value_format_name: decimal_0
    hidden: yes
  }

  measure: number_of_worked_employees_internal_ops_associate_plus {
    alias: [number_of_worked_employees_internal_deputy_shift_lead]
    group_label: "> Ops Associate + Measures"
    label: "# Punched Internal Ops Associate +"
    type: sum
    sql: ${TABLE}.number_of_worked_employees_internal_ops_associate_plus ;;
    value_format_name: decimal_0
    hidden: yes
  }

  measure: number_of_worked_employees_external_ops_associate_plus {
    alias: [number_of_worked_employees_external_deputy_shift_lead]
    group_label: "> Ops Associate + Measures"
    label: "# Punched External Ops Associate +"
    type: sum
    sql: ${TABLE}.number_of_worked_employees_external_ops_associate_plus ;;
    value_format_name: decimal_0
    hidden: yes
  }

  measure: number_of_planned_hours_availability_based_ops_associate_plus {
    alias: [number_of_planned_hours_availability_based_deputy_shift_lead]
    group_label: "> Ops Associate + Measures"
    label: "# Filled (Assigned) Ops Associate + Hours Based on Availability"
    type: sum
    sql: ${TABLE}.number_of_planned_minutes_availability_based_ops_associate_plus/60;;
    description:"Number of filled (Assigned) hours that are overlapping with provided availability (Ops Associate +) Excl. hours from shifts with project code = 'Refilled shift'"
    value_format_name: decimal_1
  }

  measure: pct_of_planned_hours_availability_based_ops_associate_plus {
    alias: [pct_of_planned_hours_availability_based_deputy_shift_lead]
    group_label: "> Ops Associate + Measures"
    label: "% Filled (Assigned) Ops Associate + Hours Based on Availability"
    type: number
    sql:${number_of_planned_hours_availability_based_ops_associate_plus}/nullif(${number_of_planned_hours_ops_associate_plus},0) ;;
    description:"Share of Filled Hours based on Availability from total Filled Hours Excl. hours from shifts with project code = 'Refilled shift' - (# Filled (Assigned) Hours Based on Availability / # Filled (Assigned) Hours)"
    value_format_name: percent_1
  }

  measure: number_of_planned_hours_availability_based_external_ops_associate_plus {
    alias: [number_of_planned_hours_availability_based_external_deputy_shift_lead]
    group_label: "> Ops Associate + Measures"
    label: "# Filled (Assigned) External Ops Associate + Hours Based on Availability"
    type: sum
    sql: ${TABLE}.number_of_planned_minutes_availability_based_external_ops_associate_plus/60;;
    description:"Number of filled (Assigned) hours that are overlapping with provided availability (External Ops Associate +) Excl. hours from shifts with project code = 'Refilled shift'"
    value_format_name: decimal_1
  }

  measure: number_of_planned_hours_availability_based_internal_ops_associate_plus {
    alias: [number_of_planned_hours_availability_based_internal_deputy_shift_lead]
    group_label: "> Ops Associate + Measures"
    label: "# Filled (Assigned) Internal Ops Associate + Hours Based on Availability"
    type: sum
    sql: ${TABLE}.number_of_planned_minutes_availability_based_internal_ops_associate_plus/60;;
    description:"Number of filled (Assigned) hours that are overlapping with provided availability (Internal Ops Associate +) Excl. hours from shifts with project code = 'Refilled shift'"
    value_format_name: decimal_1
  }

  measure: number_of_availability_hours_ops_associate_plus {
    alias: [number_of_availability_hours_deputy_shift_lead]
    group_label: "> Ops Associate + Measures"
    label: "# Ops Associate + Availability Hours"
    type: sum
    sql: ${TABLE}.number_of_availability_minutes_ops_associate_plus/60;;
    description:"Number of hours that were provided as available by the employee (Ops Associate +)"
    value_format_name: decimal_1
  }

  measure: number_of_scheduled_hours_ops_associate_plus {
    alias: [number_of_scheduled_hours_deputy_shift_lead]
    group_label: "> Ops Associate + Measures"
    label: "# Scheduled Ops Associate + Hours"
    description: "# Scheduled Ops Associate + Hours (Assigned + Unassigned) Excl. hours from shifts with project code = 'Refilled shift'"
    type: number
    sql: ${number_of_unassigned_hours_ops_associate_plus}+${number_of_planned_hours_ops_associate_plus};;
    value_format_name: decimal_1
  }

  measure: number_of_scheduled_hours_external_ops_associate_plus {
    alias: [number_of_scheduled_hours_external_deputy_shift_lead]
    group_label: "> Ops Associate + Measures"
    label: "# External Scheduled Ops Associate + Hours"
    description: "# External Scheduled Ops Associate + Hours (Assigned + Unassigned) Excl. hours from shifts with project code = 'Refilled shift'"
    type: number
    sql: (${number_of_unassigned_hours_external_ops_associate_plus}+${number_of_planned_hours_external_ops_associate_plus})/60;;
    value_format_name: decimal_1
  }

  measure: pct_no_show_hours_ops_associate_plus {
    alias: [pct_no_show_hours_deputy_shift_lead]
    group_label: "> Ops Associate + Measures"
    label: "% No Show Ops Associate + Hours Excl. Refilled Hours"
    description: "% No Show Ops Associate + Hours (Picker, WH, Rider Captain, Ops Associate). Calculated as: (# No Show Hours Excl. Refilled Hours) / (# Planned Hours - # Planned EC Hours + # Open NS+ Hours) "
    type: number
    sql:(${number_of_no_show_hours_ops_associate_plus})/nullif(${number_of_planned_hours_ops_associate_plus}-${number_of_planned_hours_ops_associate_plus_ec_shift}+${number_of_unassigned_hours_ops_associate_plus_ns_shift},0) ;;
    value_format_name: percent_1
  }

  # =========  Hours   =========

  ##### Overpunched Hours

  measure: number_of_overpunched_hours_rider {
    group_label: "> Rider Measures"
    type: sum
    label: "# Overpunched Rider Hours"
    sql: case
          when ${number_of_worked_minutes_rider} > ${number_of_planned_minutes_rider}
            then (${number_of_worked_minutes_rider} - ${number_of_planned_minutes_rider})/60
          else 0
        end;;
    description: "When # Worked Hours > # Assigned Hours then # Worked Hours - # Assigned Hours"
    value_format_name: decimal_1
  }

  measure: pct_overpunched_hours_rider {
    group_label: "> Rider Measures"
    type: number
    label: "% Overpunched Rider Hours"
    description: "Share of Overpunched hours over Punched hours."
    value_format_name: percent_2
    sql: ${number_of_overpunched_hours_rider}/nullif(${number_of_worked_hours_rider},0) ;;
  }

  measure: number_of_overpunched_hours_shift_lead {
    group_label: "> Shift Lead Measures"
    type: sum
    label: "# Overpunched Shift Lead Hours"
    sql: case
        when ${number_of_worked_minutes_shift_lead} > ${number_of_planned_minutes_shift_lead}
          then (${number_of_worked_minutes_shift_lead} - ${number_of_planned_minutes_shift_lead})/60
        else 0
      end;;
    description: "When # Worked Hours > # Assigned Hours then # Worked Hours - # Assigned Hours"
    value_format_name: decimal_1
  }

  measure: number_of_overpunched_hours_ops_associate {
    group_label: "> Ops Associate Measures"
    type: sum
    label: "# Overpunched Ops Associate Hours"
    sql: case
        when ${number_of_worked_minutes_ops_associate_dimension} > ${number_of_planned_minutes_ops_associate_dimension}
          then (${number_of_worked_minutes_ops_associate_dimension} - ${number_of_planned_minutes_ops_associate_dimension})/60
        else 0
      end;;
    description: "When # Worked Hours > # Assigned Hours then # Worked Hours - # Assigned Hours"
    value_format_name: decimal_1
  }

  measure: pct_overpunched_hours_ops_associate {
    group_label: "> Ops Associate Measures"
    type: number
    label: "% Overpunched Ops Associate Hours"
    description: "Share of Overpunched hours over Punched hours."
    value_format_name: percent_2
    sql: ${number_of_overpunched_hours_ops_associate}/nullif(${number_of_worked_hours_ops_associate},0) ;;
  }

  measure: number_of_overpunched_hours_hub_staff {
    group_label: "> Hub Staff Measures"
    type: sum
    label: "# Overpunched Hub Staff Hours"
    sql: case
        when ${number_of_worked_minutes_hub_staff} > ${number_of_planned_minutes_hub_staff}
          then (${number_of_worked_minutes_hub_staff} - ${number_of_planned_minutes_hub_staff})/60
        else 0
      end;;
    description: "When # Worked Hours > # Assigned Hours then # Worked Hours - # Assigned Hours"
    value_format_name: decimal_1
  }

  measure: number_of_overpunched_hours_ops_associate_plus {
    alias: [number_of_overpunched_hours_deputy_shift_lead]
    group_label: "> Ops Associate + Measures"
    type: sum
    label: "# Overpunched Ops Associate + Hours"
    sql: case
        when ${number_of_worked_minutes_ops_associate_plus} > ${number_of_planned_minutes_ops_associate_plus}
          then (${number_of_worked_minutes_ops_associate_plus} - ${number_of_planned_minutes_ops_associate_plus})/60
        else 0
      end;;
    description: "When # Worked Hours > # Assigned Hours then # Worked Hours - # Assigned Hours"
    value_format_name: decimal_1
  }

  ##### All
  measure: number_of_worked_hours_rider {
    group_label: "> Rider Measures"
    label: "# Punched Rider Hours"
    type: sum
    sql: ${number_of_worked_minutes_rider}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_worked_hours_onboarding {
    group_label: "> Rider Measures"
    label: "# Punched Onboarding Hours"
    description: "The sum of worked hours with position name Onboarding. Included in Rider UTR calculations."
    type: sum
    sql: ${TABLE}.number_of_worked_minutes_onboarding/60;;
    value_format_name: decimal_1
  }

  measure: number_of_worked_hours_rider_ec_shift {
    group_label: "> Rider Measures"
    label: "# Punched EC Rider Hours"
    description: "# Punched Rider Hours from shifts with project code = 'EC shift'"
    type: sum
    sql: ${TABLE}.number_of_worked_minutes_ec_shift_rider/60;;
    value_format_name: decimal_1
  }

  measure: number_of_worked_hours_rider_wfs_shift {
    group_label: "> Rider Measures"
    label: "# Punched WFS Rider Hours"
    description: "# Punched Rider Hours from shifts with project code = 'WFS shift'"
    type: sum
    sql: ${TABLE}.number_of_worked_minutes_wfs_shift_rider/60;;
    value_format_name: decimal_1
  }

  measure: number_of_worked_hours_rider_wfs_shift_extended {
    group_label: "> Rider Measures"
    label: "# Extended Punched WFS Rider Hours"
    description: "# Extended Punched Rider Hours from shifts with project code = 'WFS extend beg/end 1/2/4'."
    type: sum
    sql: ${TABLE}.number_of_worked_minutes_wfs_shift_extended_rider/60;;
    value_format_name: decimal_1
  }

  measure: number_of_worked_hours_rider_ns_shift {
    group_label: "> Rider Measures"
    label: "# Punched NS+ Rider Hours"
    description: "# Punched Rider Hours from shifts with project code = 'NS+ shift'"
    type: sum
    sql: ${TABLE}.number_of_worked_minutes_ns_shift_rider/60;;
    value_format_name: decimal_1
  }

  measure: number_of_worked_hours_rider_refilled_shift {
    group_label: "> Rider Measures"
    label: "# Punched Refilled Rider Hours"
    description: "# Punched Rider Hours from shifts with project code = 'Refilled shift'"
    type: sum
    sql: ${TABLE}.number_of_worked_minutes_refilled_shift_rider/60;;
    value_format_name: decimal_1
  }

  measure: number_of_worked_hours_rider_extra {
    group_label: "> Rider Measures"
    label: "# Extra Punched Rider Hours (EC, NS+, WFS, Refilled)"
    description: "# Punched Rider Hours from shifts with project code NS+. WFS, EC and Refilled shifts"
    type: number
    sql: ${number_of_worked_hours_rider_ns_shift} +
    ${number_of_worked_hours_rider_ec_shift} +
    ${number_of_worked_hours_rider_wfs_shift} +
    ${number_of_worked_hours_rider_refilled_shift}
    ;;
    value_format_name: decimal_1
  }


  measure: number_of_idle_hours_rider_quinyx {
    group_label: "> Rider Measures"
    label: "# Idle Rider Hours (Quinyx Based)"
    description: "Sum of idle time (min) - the difference between worked minutes and rider handling time minutes. Rider handling time outliers (suspicious timestamps) could be excluded if there is no viable geofencing data."
    type: number
    sql: ${number_of_worked_hours_rider}-${orders_with_ops_metrics.sum_rider_handling_time_hours_last_mile};;
    value_format_name: decimal_1
  }

  measure: number_of_idle_hours_rider {
    group_label: "> Rider Measures"
    label: "# Idle Rider Hours (Online Hours Based)"
    description: "Sum of idle time (hours) - the difference between online hours and rider handling time hours. Rider handling time outliers (suspicious timestamps) could be excluded if there is no viable geofencing data."
    type: number
    sql: ${number_of_online_hours_rider}-${orders_with_ops_metrics.sum_rider_handling_time_hours_last_mile};;
    value_format_name: decimal_1
  }

  measure: pct_rider_idle_time_quinyx {
    group_label: "> Rider Measures"
    type: number
    label: "% Rider Worked Time Spent Idle (Quinyx Based)"
    description: "% of worked time (hours) not spent handling an order - compares the difference between worked time (hours) and rider handling time (hours) with total worked time (hours). Rider handling time outliers (suspicious timestamps) could be excluded if there is no viable geofencing data."
    sql: ${number_of_idle_hours_rider_quinyx} / nullif(${number_of_worked_hours_rider},0) ;;
    value_format_name: percent_2
  }

  measure: pct_rider_idle_time {
    group_label: "> Rider Measures"
    type: number
    label: "% Rider Worked Time Spent Idle (Online Hours Based)"
    description: "% of online time (hours) not spent handling an order - compares the difference between online time (hours) and rider handling time (hours) with total online time (hours). Rider handling time outliers (suspicious timestamps) could be excluded if there is no viable geofencing data."
    sql: ${number_of_idle_hours_rider} / nullif(${number_of_online_hours_rider},0) ;;
    value_format_name: percent_2
  }

  measure: number_of_worked_hours_shift_lead {
    group_label: "> Shift Lead Measures"
    label: "# Punched Shift Lead Hours"
    type: sum
    sql: ${number_of_worked_minutes_shift_lead}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_worked_hours_ops_associate {
    alias: [number_of_worked_hours_ops_staff]
    group_label: "> Ops Associate Measures"
    label: "# Punched Ops Associate Hours"
    description: "# Punched Ops Associate Hours (Picker, WH, Rider Captain, Ops Associate)"
    type: number
    sql: ${number_of_worked_minutes_ops_associate}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_worked_hours_ops_associate_ec_shift {
    group_label: "> Ops Associate Measures"
    label: "# Punched EC Ops Associate Hours"
    description: "# Punched Ops Associate Hours from shifts with project code = 'EC shift'"
    type: sum
    sql: ${TABLE}.number_of_worked_minutes_ec_shift_ops_associate/60;;
    value_format_name: decimal_1
  }

  measure: number_of_worked_hours_ops_associate_wfs_shift {
    group_label: "> Ops Associate Measures"
    label: "# Punched WFS Ops Associate Hours"
    description: "# Punched Ops Associate Hours from shifts with project code = 'WFS shift'"
    type: sum
    sql: ${TABLE}.number_of_worked_minutes_wfs_shift_ops_associate/60;;
    value_format_name: decimal_1
  }

  measure: number_of_worked_hours_ops_associate_wfs_shift_extended {
    group_label: "> Ops Associate Measures"
    label: "# Extended Punched WFS Ops Associate Hours"
    description: "# Extended Punched Ops Associate Hours from shifts with project code = 'WFS extend beg/end 1/2/4'."
    type: sum
    sql: ${TABLE}.number_of_worked_minutes_wfs_shift_extended_ops_associate/60;;
    value_format_name: decimal_1
  }

  measure: number_of_worked_hours_ops_associate_ns_shift {
    group_label: "> Ops Associate Measures"
    label: "# Punched NS+ Ops Associate Hours"
    description: "# Punched Ops Associate Hours from shifts with project code = 'NS+ shift'"
    type: sum
    sql: ${TABLE}.number_of_worked_minutes_ns_shift_ops_associate/60;;
    value_format_name: decimal_1
  }

  measure: number_of_worked_hours_ops_associate_refilled_shift {
    group_label: "> Ops Associate Measures"
    label: "# Punched Refilled Ops Associate Hours"
    description: "# Punched Ops Associate Hours from shifts with project code = 'Refilled shift'"
    type: sum
    sql: ${TABLE}.number_of_worked_minutes_refilled_shift_ops_associate/60;;
    value_format_name: decimal_1
  }

  measure: number_of_worked_hours_ops_associate_extra {
    group_label: "> Ops Associate Measures"
    label: "# Extra Punched Ops Associate Hours (EC, NS+, WFS, Refilled)"
    description: "# Punched Ops Associate Hours from shifts with project code NS+. WFS, EC and Refilled shifts"
    type: number
    sql: ${number_of_worked_hours_ops_associate_ns_shift} +
    ${number_of_worked_hours_ops_associate_ec_shift} +
    ${number_of_worked_hours_ops_associate_wfs_shift} +
    ${number_of_worked_hours_ops_associate_refilled_shift};;
    value_format_name: decimal_1
  }

# since shift lead do not consistently punch in/out then we need to consider worked hours = planned hours
  measure: number_of_worked_hours_hub_staff {
    group_label: "> Hub Staff Measures"
    label: "# Punched Hub Staff Hours"
    description: "# Punched Ops Associate Hours (Picker, WH, Ops Associate, Rider Captain and Ops Associate +) + # Planned Shift Lead hours"
    type: number
    sql: ${number_of_worked_hours_ops_associate}+${number_of_planned_hours_shift_lead}+${number_of_worked_hours_ops_associate_plus};;
    value_format_name: decimal_1
  }

  ##### External
  measure: number_of_worked_hours_external_rider {
    group_label: "> Rider Measures"
    label: "# External Punched Rider Hours"
    type: sum
    sql: ${number_of_worked_minutes_external_rider}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_worked_hours_external_shift_lead {
    group_label: "> Shift Lead Measures"
    label: "# External Punched Shift Lead Hours"
    type: sum
    sql: ${number_of_worked_minutes_external_shift_lead}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_worked_hours_external_hub_staff {
    group_label: "> Hub Staff Measures"
    label: "# External Punched Hub Staff Hours"
    description: "# Punched External Ops Associate Hours (Picker, WH, Ops Associate, Rider Captain and Ops Associate +) + # Planned External Shift Lead hours"
    type: number
    sql: (${number_of_worked_minutes_external_ops_associate}+sum(${number_of_planned_minutes_external_shift_lead}))/60 + ${number_of_worked_hours_external_ops_associate_plus};;
    value_format_name: decimal_1
  }

  measure: number_of_worked_hours_external_ops_associate {
    alias: [number_of_worked_hours_external_ops_staff]
    group_label: "> Ops Associate Measures"
    label: "# External Punched Ops Associate Hours"
    description: "# Punched External Ops Associate Hours (Picker, WH, Rider Captain, Ops Associate)"
    type: number
    sql: ${number_of_worked_minutes_external_ops_associate}/60;;
    value_format_name: decimal_1
  }

  # =========  Employees   =========
  #### All
  measure: sum_of_worked_employees_rider {
    group_label: "> Rider Measures"
    label: "# Punched Riders"
    type: sum
    sql: ${number_of_worked_employees_rider};;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: sum_of_worked_employees_shift_lead {
    group_label: "> Shift Lead Measures"
    label: "# Punched Shift Leads"
    type: sum
    sql: ${number_of_worked_employees_shift_lead};;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: sum_of_worked_employees_ops_associate {
    group_label: "> Ops Associate Measures"
    label: "# Punched Ops Associates"
    type: sum
    sql: ${TABLE}.number_of_worked_employees_ops_associate;;
    value_format_name: decimal_1
    hidden: yes
  }

  #### External

  measure: sum_of_worked_employees_external_ops_associate {
    group_label: "> Ops Associate Measures"
    label: "# Punched External Ops Associates"
    type: sum
    sql: ${TABLE}.number_of_worked_employees_external_ops_associate;;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: sum_of_worked_employees_external_rider {
    group_label: "> Rider Measures"
    label: "# Punched External Riders"
    type: sum
    sql: ${number_of_worked_employees_external_rider};;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: sum_of_worked_employees_external_shift_lead {
    group_label: "> Shift Lead Measures"
    label: "# Punched External Shift Leads"
    type: sum
    sql: ${number_of_worked_employees_external_shift_lead};;
    value_format_name: decimal_1
    hidden: yes
  }

  #### Internal

  measure: sum_of_worked_employees_internal_ops_associate {
    group_label: "> Ops Associate Measures"
    label: "# Punched Internal Ops Associates"
    type: sum
    sql: ${TABLE}.number_of_worked_employees_internal_ops_associate;;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: sum_of_worked_employees_internal_rider {
    group_label: "> Rider Measures"
    label: "# Punched Internal Riders"
    type: sum
    sql: ${number_of_worked_employees_internal_rider};;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: sum_of_worked_employees_internal_shift_lead {
    group_label: "> Shift Lead Measures"
    label: "# Punched Internal Shift Leads"
    type: sum
    sql: ${number_of_worked_employees_internal_shift_lead};;
    value_format_name: decimal_1
    hidden: yes
  }

  # =========  Unassigned Employees   =========
  ##### All

  measure: sum_of_unassigned_employees_internal_ops_associate {
    group_label: "> Ops Associate Measures"
    label: "# Unassigned (Open) Internal Ops Associates"
    type: sum
    sql: ${TABLE}.number_of_unassigned_employees_internal_ops_associate;;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: sum_of_unassigned_employees_external_ops_associate {
    group_label: "> Ops Associate Measures"
    label: "# Unassigned External Ops Associates"
    type: sum
    sql: ${TABLE}.number_of_unassgined_employees_external_ops_associate;;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: sum_of_unassigned_employees_ops_associate {
    group_label: "> Ops Associate Measures"
    label: "# Unassigned (Open) Ops Associates"
    type: number
    sql: ${sum_of_unassigned_employees_internal_ops_associate}+${sum_of_unassigned_employees_external_ops_associate};;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: sum_of_unassigned_employees_rider {
    group_label: "> Rider Measures"
    label: "# Unassigned Riders"
    type: sum
    sql: ${number_of_unassigned_employees_external_rider}+${number_of_unassigned_employees_internal_rider};;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: sum_of_unassigned_employees_shift_lead {
    group_label: "> Shift Lead Measures"
    label: "# Unassigned Shift Leads"
    type: sum
    sql: ${number_of_unassigned_employees_external_shift_lead}+${number_of_unassigned_employees_internal_shift_lead};;
    value_format_name: decimal_1
    hidden: yes
  }

  # =========  Open Hours   =========

  measure: number_of_unassigned_minutes_internal_ops_associate {
    group_label: "> Ops Associate Measures"
    label: "# Internal Unassigned (Open) Ops Associate Minutes"
    type: sum
    sql: ${TABLE}.number_of_unassigned_minutes_internal_ops_associate;;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: number_of_unassigned_minutes_external_ops_associate {
    group_label: "> Ops Associate Measures"
    label: "# External Unassigned (Open) Ops Associate Minutes"
    type: sum
    sql: ${TABLE}.number_of_unassigned_minutes_external_ops_associate;;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: number_of_unassigned_hours_ops_associate {
    alias: [number_of_unassigned_hours_ops_staff]
    group_label: "> Ops Associate Measures"
    label: "# Open Ops Associate Hours"
    description: "# Open (Unassigned) Ops Associate Hours (Picker, WH, Rider Captain, Ops Associate)"
    type: number
    sql: (${number_of_unassigned_minutes_internal_ops_associate}+${number_of_unassigned_minutes_external_ops_associate})/60;;
    value_format_name: decimal_1
  }

  measure: number_of_unassigned_hours_rider {
    group_label: "> Rider Measures"
    label: "# Open Rider Hours"
    type: sum
    sql: (${number_of_unassigned_minutes_external_rider}+${number_of_unassigned_minutes_internal_rider_dimension})/60;;
    value_format_name: decimal_1
  }

  measure: number_of_unassigned_hours_internal_rider {
    group_label: "> Rider Measures"
    label: "# Open Internal Rider Hours"
    type: sum
    sql: (${number_of_unassigned_minutes_internal_rider_dimension})/60;;
    value_format_name: decimal_1
  }

  measure: number_of_unassigned_hours_rider_ec_shift {
    group_label: "> Rider Measures"
    label: "# Open EC Rider Hours"
    description: "# Open Rider Hours from shifts with project code = 'EC shift'"
    type: sum
    sql: ${TABLE}.number_of_unassigned_minutes_ec_shift_rider/60;;
    value_format_name: decimal_1
  }

  measure: number_of_unassigned_hours_rider_wfs_shift {
    group_label: "> Rider Measures"
    label: "# Open WFS Rider Hours"
    description: "# Open Rider Hours from shifts with project code = 'WFS shift'"
    type: sum
    sql: ${TABLE}.number_of_unassigned_minutes_wfs_shift_rider/60;;
    value_format_name: decimal_1
  }

  measure: number_of_unassigned_hours_rider_wfs_shift_extended {
    group_label: "> Rider Measures"
    label: "# Extended Open WFS Rider Hours"
    description: "# Extended Open Rider Hours from shifts with project code = 'WFS extend beg/end 1/2/4'."
    type: sum
    sql: ${TABLE}.number_of_unassigned_minutes_wfs_shift_extended_rider/60;;
    value_format_name: decimal_1
  }

  measure: number_of_unassigned_hours_rider_ns_shift {
    group_label: "> Rider Measures"
    label: "# Open NS+ Rider Hours"
    description: "# Open Rider Hours from shifts with project code = 'NS+ shift'"
    type: sum
    sql: ${TABLE}.number_of_unassigned_minutes_ns_shift_rider/60;;
    value_format_name: decimal_1
  }

  measure: number_of_unassigned_hours_rider_refilled_shift {
    group_label: "> Rider Measures"
    label: "# Open Refilled Rider Hours"
    description: "# Open Rider Hours from shifts with project code = 'Refilled shift'"
    type: sum
    sql: ${TABLE}.number_of_unassigned_minutes_refilled_shift_rider/60;;
    value_format_name: decimal_1
  }

  measure: number_of_unassigned_hours_ops_associate_ec_shift {
    group_label: "> Ops Associate Measures"
    label: "# Open EC Ops Associate Hours"
    description: "# Open Ops Associate Hours from shifts with project code = 'EC shift'"
    type: sum
    sql: ${TABLE}.number_of_unassigned_minutes_ec_shift_ops_associate/60;;
    value_format_name: decimal_1
  }

  measure: number_of_unassigned_hours_ops_associate_wfs_shift {
    group_label: "> Ops Associate Measures"
    label: "# Open WFS Ops Associate Hours"
    description: "# Open Ops Associate Hours from shifts with project code = 'WFS shift'"
    type: sum
    sql: ${TABLE}.number_of_unassigned_minutes_wfs_shift_ops_associate/60;;
    value_format_name: decimal_1
  }

  measure: number_of_unassigned_hours_ops_associate_wfs_shift_extended {
    group_label: "> Ops Associate Measures"
    label: "# Extended Open WFS Ops Associate Hours"
    description: "# Extended Open Ops Associate Hours from shifts with project code = 'WFS extend beg/end 1/2/4'."
    type: sum
    sql: ${TABLE}.number_of_unassigned_minutes_wfs_shift_extended_ops_associate/60;;
    value_format_name: decimal_1
  }

  measure: number_of_unassigned_hours_ops_associate_ns_shift {
    group_label: "> Ops Associate Measures"
    label: "# Open NS+ Ops Associate Hours"
    description: "# Open Ops Associate Hours from shifts with project code = 'NS+ shift'"
    type: sum
    sql: ${TABLE}.number_of_unassigned_minutes_ns_shift_ops_associate/60;;
    value_format_name: decimal_1
  }

  measure: number_of_unassigned_hours_shift_lead_ns_shift {
    group_label: "> Shift Lead Measures"
    label: "# Open NS+ Shift Lead Hours"
    description: "# Open Shift Lead Hours from shifts with project code = 'NS+ shift'"
    type: sum
    sql: ${TABLE}.number_of_unassigned_minutes_ns_shift_shift_lead/60;;
    value_format_name: decimal_1
  }

  measure: number_of_unassigned_hours_ops_associate_plus_ns_shift {
    group_label: "> Ops Associate + Measures"
    label: "# Open NS+ Ops Associate + Hours"
    description: "# Open Ops Associate + Hours from shifts with project code = 'NS+ shift'"
    type: sum
    sql: ${TABLE}.number_of_unassigned_minutes_ns_shift_ops_associate_plus/60;;
    value_format_name: decimal_1
  }

  measure: number_of_unassigned_hours_ops_associate_refilled_shift {
    group_label: "> Ops Associate Measures"
    label: "# Open Refilled Ops Associate Hours"
    description: "# Open Ops Associate Hours from shifts with project code = 'Refilled shift'"
    type: sum
    sql: ${TABLE}.number_of_unassigned_minutes_refilled_shift_ops_associate/60;;
    value_format_name: decimal_1
  }

  measure: number_of_unassigned_hours_shift_lead {
    group_label: "> Shift Lead Measures"
    label: "# Open Shift Lead Hours"
    type: sum
    sql: (${number_of_unassigned_minutes_external_shift_lead}+${number_of_unassigned_minutes_internal_shift_lead})/60;;
    value_format_name: decimal_1
  }

  measure: number_of_unassigned_hours_hub_staff {
    group_label: "> Hub Staff Measures"
    label: "# Open Hub Staff Hours"
    description: "# Open (Unassigned) Hub Staff Hours (Picker, WH, Rider Captain, Ops Associate, Shift Lead, Ops Associate +)"
    type: number
    sql: ${number_of_unassigned_hours_ops_associate}+${number_of_unassigned_hours_shift_lead}+${number_of_unassigned_hours_ops_associate_plus};;
    value_format_name: decimal_1
  }

  measure: number_of_unassigned_ns_hours_hub_staff {
    group_label: "> Hub Staff Measures"
    label: "# Open NS+ Hub Staff Hours"
    description: "# Open (Unassigned) NS+ Hub Staff Hours (Picker, WH, Rider Captain, Ops Associate, Shift Lead, Ops Associate +)"
    type: number
    sql: ${number_of_unassigned_hours_ops_associate_ns_shift}+${number_of_unassigned_hours_shift_lead_ns_shift}+${number_of_unassigned_hours_ops_associate_plus};;
    value_format_name: decimal_1
  }

  ##### Planned (filled)

  measure: number_of_planned_minutes_ops_associate {
    group_label: "> Ops Associate Measures"
    label: "# Filled (Assigned) Ops Associate Minutes"
    type: sum
    sql: ${TABLE}.number_of_planned_minutes_ops_associate ;;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: number_of_planned_hours_ops_associate {
    alias: [number_of_planned_hours_ops_staff]
    group_label: "> Ops Associate Measures"
    label: "# Filled (Assigned) Ops Associate Hours"
    description: "# Filled Ops Associate Hours (Picker, WH, Rider Captain, Ops Associate) Excl. hours from shifts with project code = 'Refilled shift'"
    type: number
    sql: ${number_of_planned_minutes_ops_associate}/60 ;;
    value_format_name: decimal_1
  }

  measure: number_of_planned_hours_ops_associate_ec_shift {
    group_label: "> Ops Associate Measures"
    label: "# Filled (Assigned) EC Ops Associate Hours"
    description: "# Filled Ops Associate Hours from shifts with project code = 'EC shift'"
    type: sum
    sql: ${TABLE}.number_of_planned_minutes_ec_shift_ops_associate/60;;
    value_format_name: decimal_1
  }

  measure: number_of_planned_hours_ops_associate_plus_ec_shift {
    alias: [number_of_planned_hours_deputy_shift_lead_ec_shift]
    group_label: "> Ops Associate + Measures"
    label: "# Filled (Assigned) EC Ops Associate + Hours"
    description: "# Filled Ops Associate + Hours from shifts with project code = 'EC shift'"
    type: sum
    sql: ${TABLE}.number_of_planned_minutes_ec_shift_ops_associate_plus/60;;
    value_format_name: decimal_1
  }

  measure: number_of_planned_hours_ops_associate_wfs_shift {
    group_label: "> Ops Associate Measures"
    label: "# Filled (Assigned) WFS Ops Associate Hours"
    description: "# Filled Ops Associate Hours from shifts with project code = 'WFS shift'"
    type: sum
    sql: ${TABLE}.number_of_planned_minutes_wfs_shift_ops_associate/60;;
    value_format_name: decimal_1
  }

  measure: number_of_planned_hours_ops_associate_wfs_shift_extended {
    group_label: "> Ops Associate Measures"
    label: "# Extended Filled (Assigned) WFS Ops Associate Hours"
    description: "# Extended Filled Ops Associate Hours from shifts with project code = 'WFS extend beg/end 1/2/4'."
    type: sum
    sql: ${TABLE}.number_of_planned_minutes_wfs_shift_extended_ops_associate/60;;
    value_format_name: decimal_1
  }

  measure: number_of_planned_hours_ops_associate_ns_shift {
    group_label: "> Ops Associate Measures"
    label: "# Filled (Assigned) NS+ Ops Associate Hours"
    description: "# Filled Ops Associate Hours from shifts with project code = 'NS+ shift'"
    type: sum
    sql: ${TABLE}.number_of_planned_minutes_ns_shift_ops_associate /60;;
    value_format_name: decimal_1
  }

  measure: number_of_planned_hours_ops_associate_refilled_shift {
    group_label: "> Ops Associate Measures"
    label: "# Filled (Assigned) Refilled Ops Associate Hours"
    description: "# Filled Ops Associate Hours from shifts with project code = 'Refilled shift'"
    type: sum
    sql: ${TABLE}.number_of_planned_minutes_refilled_shift_ops_associate /60;;
    value_format_name: decimal_1
  }

  measure: number_of_planned_minutes_internal_ops_associate {
    group_label: "> Ops Associate Measures"
    label: "# Filled (Assigned) Internal Ops Associate Minutes"
    type: sum
    sql: ${TABLE}.number_of_planned_minutes_internal_ops_associate ;;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: number_of_planned_minutes_external_ops_associate {
    group_label: "> Ops Associate Measures"
    label: "# Filled (Assigned) External Ops Associate Minutes"
    type: sum
    sql: ${TABLE}.number_of_planned_minutes_external_ops_associate ;;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: number_of_planned_hours_internal_ops_associate {
    group_label: "> Ops Associate Measures"
    label: "# Filled (Assigned) Internal Ops Associate Hours"
    description: "# Filled Internal Ops Associate Hours Excl. hours from shifts with project code = 'Refilled shift'"
    type: sum
    sql: ${TABLE}.number_of_planned_minutes_internal_ops_associate/60 ;;
    value_format_name: decimal_1
  }

  measure: number_of_planned_hours_external_ops_associate {
    group_label: "> Ops Associate Measures"
    label: "# Filled (Assigned) External Ops Associate Hours"
    description: "# Filled External Ops Associate Hours Excl. hours from shifts with project code = 'Refilled shift'"
    type: sum
    sql: ${TABLE}.number_of_planned_minutes_external_ops_associate/60 ;;
    value_format_name: decimal_1
  }

  measure: number_of_planned_hours_rider {
    group_label: "> Rider Measures"
    label: "# Filled (Assigned) Rider Hours"
    description: "# Filled Rider Hours Excl. hours from shifts with project code = 'Refilled shift'"
    type: sum
    sql: ${number_of_planned_minutes_rider}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_planned_hours_internal_rider {
    group_label: "> Rider Measures"
    label: "# Filled (Assigned) Internal Rider Hours"
    description: "# Filled Internal Rider Hours Excl. hours from shifts with project code = 'Refilled shift'"
    type: sum
    sql: ${number_of_planned_minutes_internal_rider}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_planned_hours_external_rider {
    group_label: "> Rider Measures"
    label: "# Filled (Assigned) External Rider Hours"
    description: "# Filled External Rider Hours Excl. hours from shifts with project code = 'Refilled shift'"
    type: sum
    sql: ${number_of_planned_minutes_external_rider}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_planned_hours_rider_ec_shift {
    group_label: "> Rider Measures"
    label: "# Filled (Assigned) EC Rider Hours"
    description: "# Filled Rider Hours from shifts with project code = 'EC shift'"
    type: sum
    sql: ${TABLE}.number_of_planned_minutes_ec_shift_rider/60;;
    value_format_name: decimal_1
  }

  measure: number_of_planned_hours_rider_wfs_shift {
    group_label: "> Rider Measures"
    label: "# Filled (Assigned) WFS Rider Hours"
    description: "# Filled Rider Hours from shifts with project code = 'WFS shift'"
    type: sum
    sql: ${TABLE}.number_of_planned_minutes_wfs_shift_rider/60;;
    value_format_name: decimal_1
  }

  measure: number_of_planned_hours_rider_wfs_shift_extended {
    group_label: "> Rider Measures"
    label: "# Extended Filled (Assigned) WFS Rider Hours"
    description: "# Extended Filled Rider Hours from shifts with project code = 'WFS extend beg/end 1/2/4'."
    type: sum
    sql: ${TABLE}.number_of_planned_minutes_wfs_shift_extended_rider/60;;
    value_format_name: decimal_1
  }


  measure: number_of_planned_hours_rider_ns_shift {
    group_label: "> Rider Measures"
    label: "# Filled (Assigned) NS+ Rider Hours"
    description: "# Filled Rider Hours from shifts with project code = 'NS+ shift'"
    type: sum
    sql: ${TABLE}.number_of_planned_minutes_ns_shift_rider/60;;
    value_format_name: decimal_1
  }

  measure: number_of_planned_hours_rider_refilled_shift {
    group_label: "> Rider Measures"
    label: "# Filled (Assigned) Refilled Rider Hours"
    description: "# Filled Rider Hours from shifts with project code = 'Refilled shift'"
    type: sum
    sql: ${TABLE}.number_of_planned_minutes_refilled_shift_rider/60;;
    value_format_name: decimal_1
  }

  measure: number_of_planned_hours_availability_based_rider {
    group_label: "> Rider Measures"
    label: "# Filled (Assigned) Rider Hours Based on Availability"
    type: sum
    sql: ${TABLE}.number_of_planned_minutes_availability_based_rider/60;;
    description:"Number of filled (Assigned) hours that are overlapping with provided availability (Rider) Excl. hours from shifts with project code = 'Refilled shift'"
    value_format_name: decimal_1
  }

  measure: pct_of_planned_hours_availability_based_rider {
    group_label: "> Rider Measures"
    label: "% Filled (Assigned) Rider Hours Based on Availability"
    type: number
    sql:${number_of_planned_hours_availability_based_rider}/nullif(${number_of_planned_hours_rider},0) ;;
    description:"Share of Filled Hours based on Availability from total Filled Hours Excl. hours from shifts with project code = 'Refilled shift' - (# Filled (Assigned) Hours Based on Availability / # Filled (Assigned) Hours)"
    value_format_name: percent_1
  }

  measure: number_of_planned_hours_availability_based_external_rider {
    group_label: "> Rider Measures"
    label: "# Filled (Assigned) External Rider Hours Based on Availability"
    type: sum
    sql: ${TABLE}.number_of_planned_minutes_availability_based_external_rider/60;;
    description:"Number of filled (Assigned) hours that are overlapping with provided availability (External Rider) Excl. hours from shifts with project code = 'Refilled shift'"
    value_format_name: decimal_1
  }

  measure: number_of_planned_hours_availability_based_internal_rider {
    group_label: "> Rider Measures"
    label: "# Filled (Assigned) Internal Rider Hours Based on Availability"
    type: sum
    sql: ${TABLE}.number_of_planned_minutes_availability_based_internal_rider/60;;
    description:"Number of filled (Assigned) hours that are overlapping with provided availability (Internal Rider) Excl. hours from shifts with project code = 'Refilled shift'"
    value_format_name: decimal_1
  }

  measure: number_of_availability_hours_rider {
    group_label: "> Rider Measures"
    label: "# Rider Availability Hours"
    type: sum
    sql: ${TABLE}.number_of_availability_minutes_rider/60;;
    description:"Number of hours that were provided as available by the employee (Rider)"
    value_format_name: decimal_1
  }

  measure: number_of_planned_hours_shift_lead {
    group_label: "> Shift Lead Measures"
    label: "# Filled (Assigned) Shift Lead Hours"
    type: sum
    sql: ${number_of_planned_minutes_shift_lead}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_planned_hours_shift_lead_ec_shift {
    group_label: "> Shift Lead Measures"
    label: "# Filled (Assigned) EC Shift Lead Hours"
    description: "# Filled Shift Lead Hours from shifts with project code = 'EC shift'"
    type: sum
    sql: ${TABLE}.number_of_planned_minutes_ec_shift_shift_lead/60;;
    value_format_name: decimal_1
  }

  measure: number_of_planned_hours_availability_based_shift_lead {
    group_label: "> Shift Lead Measures"
    label: "# Filled (Assigned) Shift Lead Hours Based on Availability"
    type: sum
    sql: ${TABLE}.number_of_planned_minutes_availability_based_shift_lead/60;;
    description:"Number of filled (Assigned) hours that are overlapping with provided availability (Shift Lead)"
    value_format_name: decimal_1
  }

  measure: pct_of_planned_hours_availability_based_shift_lead {
    group_label: "> Shift Lead Measures"
    label: "% Filled (Assigned) Shift Lead Hours Based on Availability"
    type: number
    sql:${number_of_planned_hours_availability_based_shift_lead}/nullif(${number_of_planned_hours_shift_lead},0) ;;
    description:"Share of Filled Hours based on Availability from total Filled Hours - (# Filled (Assigned) Hours Based on Availability / # Filled (Assigned) Hours)"
    value_format_name: percent_1
  }

  measure: number_of_planned_hours_availability_based_external_shift_lead {
    group_label: "> Shift Lead Measures"
    label: "# Filled (Assigned) External Shift Lead Hours Based on Availability"
    type: sum
    sql: ${TABLE}.number_of_planned_minutes_availability_based_external_shift_lead/60;;
    description:"Number of filled (Assigned) hours that are overlapping with provided availability (External Shift Lead)"
    value_format_name: decimal_1
  }

  measure: number_of_planned_hours_availability_based_internal_shift_lead {
    group_label: "> Shift Lead Measures"
    label: "# Filled (Assigned) Internal Shift Lead Hours Based on Availability"
    type: sum
    sql: ${TABLE}.number_of_planned_minutes_availability_based_internal_shift_lead/60;;
    description:"Number of filled (Assigned) hours that are overlapping with provided availability (Internal Shift Lead)"
    value_format_name: decimal_1
  }

  measure: number_of_availability_hours_shift_lead {
    group_label: "> Shift Lead Measures"
    label: "# Shift Lead Availability Hours"
    type: sum
    sql: ${TABLE}.number_of_availability_minutes_shift_lead/60;;
    description:"Number of hours that were provided as available by the employee (Shift Lead)"
    value_format_name: decimal_1
  }

  measure: number_of_planned_hours_hub_staff {
    group_label: "> Hub Staff Measures"
    label: "# Filled (Assigned) Hub Staff Hours Excl. Refilled Hours"
    description: "# Filled Hub Staff Hours (Picker, WH, Rider Captain, Ops Associate, Shift Lead, Ops Associate +) Excl. hours from shifts with project code = 'Refilled shift'"
    type: number
    sql: ${number_of_planned_hours_ops_associate}+${number_of_planned_hours_shift_lead}+${number_of_planned_hours_ops_associate_plus};;
    value_format_name: decimal_1
  }

  measure: number_of_planned_hours_hub_staff_ec_shift {
    group_label: "> Hub Staff Measures"
    label: "# Filled (Assigned) EC Hub Staff Hours"
    description: "# Filled Hub Staff Hours from shifts with project code = 'EC shift'"
    type: number
    sql: ${number_of_planned_hours_ops_associate_ec_shift} + ${number_of_planned_hours_shift_lead_ec_shift}
      + ${number_of_planned_hours_ops_associate_plus_ec_shift};;
    value_format_name: decimal_1
  }

  measure: number_of_planned_hours_availability_based_hub_staff {
    group_label: "> Hub Staff Measures"
    label: "# Filled (Assigned) Hub Staff Hours Based on Availability Excl. Refilled Hours"
    type: sum
    sql: (${TABLE}.number_of_planned_minutes_availability_based_ops_associate +
      ${TABLE}.number_of_planned_minutes_availability_based_shift_lead + ${TABLE}.number_of_planned_minutes_availability_based_ops_associate_plus)/60;;
    description:"Number of filled (Assigned) hours that are overlapping with provided availability (Hub Staff) Excl. hours from shifts with project code = 'Refilled shift'"
    value_format_name: decimal_1
  }

  measure: pct_of_planned_hours_availability_based_hub_staff {
    group_label: "> Hub Staff Measures"
    label: "% Filled (Assigned) Hub Staff Hours Based on Availability Excl. Refilled Hours"
    type: number
    sql:${number_of_planned_hours_availability_based_hub_staff}/nullif(${number_of_planned_hours_hub_staff},0) ;;
    description:"Share of Filled Hours based on Availability from total Filled Hours Excl. hours from shifts with project code = 'Refilled shift' - (# Filled (Assigned) Hours Based on Availability / # Filled (Assigned) Hours)"
    value_format_name: percent_1
  }

  measure: number_of_planned_hours_availability_based_external_hub_staff {
    group_label: "> Hub Staff Measures"
    label: "# Filled (Assigned) External Hub Staff Hours Based on Availability Excl. Refilled Hours"
    type: sum
    sql: (${TABLE}.number_of_planned_minutes_availability_based_external_ops_associate +
      ${TABLE}.number_of_planned_minutes_availability_based_external_shift_lead + ${TABLE}.number_of_planned_minutes_availability_based_external_ops_associate_plus)/60;;
    description:"Number of filled (Assigned) hours that are overlapping with provided availability (External Hub Staff) Excl. hours from shifts with project code = 'Refilled shift'"
    value_format_name: decimal_1
  }

  measure: number_of_planned_hours_availability_based_internal_hub_staff {
    group_label: "> Hub Staff Measures"
    label: "# Filled (Assigned) Internal Hub Staff Hours Based on Availability Excl. Refilled Hours"
    type: sum
    sql: (${TABLE}.number_of_planned_minutes_availability_based_internal_ops_associate +
      ${TABLE}.number_of_planned_minutes_availability_based_internal_shift_lead + ${TABLE}.number_of_planned_minutes_availability_based_internal_ops_associate_plus)/60;;
    description:"Number of filled (Assigned) hours that are overlapping with provided availability (Internal Hub Staff) Excl. hours from shifts with project code = 'Refilled shift'"
    value_format_name: decimal_1
  }

  measure: number_of_availability_hours_hub_staff {
    group_label: "> Hub Staff Measures"
    label: "# Hub Staff Availability Hours"
    type: sum
    sql: (${TABLE}.number_of_availability_minutes_ops_associate +
      ${TABLE}.number_of_availability_minutes_shift_lead + ${TABLE}.number_of_availability_minutes_ops_associate_plus)/60;;
    description:"Number of hours that were provided as available by the employee (Hub Staff)"
    value_format_name: decimal_1
  }

  # =========  Scheduled Hours (Post-adjustments)   =========
  ##### All

  measure: number_of_scheduled_hours_rider {
    group_label: "> Rider Measures"
    label: "# Scheduled Rider Hours Excl. Refilled Hours"
    description: "# Scheduled Rider Hours (Assigned + Unassigned) Excl. hours from shifts with project code = 'Refilled shift'"
    type: number
    sql: ${number_of_unassigned_hours_rider}+${number_of_planned_hours_rider};;
    value_format_name: decimal_1
  }

  measure: number_of_scheduled_hours_internal_rider {
    group_label: "> Rider Measures"
    label: "# Scheduled Internal Rider Hours Excl. Refilled Hours"
    description: "# Scheduled Internal Rider Hours (Assigned + Unassigned) Excl. hours from shifts with project code = 'Refilled shift'"
    type: number
    sql: ${number_of_unassigned_hours_internal_rider}+${number_of_planned_hours_internal_rider};;
    value_format_name: decimal_1
  }

  measure: number_of_scheduled_hours_rider_ec_shift {
    group_label: "> Rider Measures"
    label: "# Scheduled EC Rider Hours"
    description: "# Scheduled Rider Hours (Assigned + Unassigned EC shift hours)"
    type: number
    sql: ${number_of_unassigned_hours_rider_ec_shift}+${number_of_planned_hours_rider_ec_shift};;
    value_format_name: decimal_1
  }

  measure: number_of_scheduled_hours_rider_wfs_shift {
    group_label: "> Rider Measures"
    label: "# Scheduled WFS Rider Hours"
    description: "# Scheduled Rider Hours (Assigned + Unassigned WFS shift hours)"
    type: number
    sql: ${number_of_unassigned_hours_rider_wfs_shift}+${number_of_planned_hours_rider_wfs_shift};;
    value_format_name: decimal_1
  }

  measure: number_of_scheduled_hours_rider_wfs_shift_extended {
    group_label: "> Rider Measures"
    label: "# Extended Scheduled WFS Rider Hours"
    description: "# Extended Scheduled Rider Hours (Assigned + Unassigned WFS shift hours)"
    type: number
    sql: ${number_of_unassigned_hours_rider_wfs_shift_extended}+${number_of_planned_hours_rider_wfs_shift_extended};;
    value_format_name: decimal_1
  }

  measure: number_of_scheduled_hours_rider_ns_shift {
    group_label: "> Rider Measures"
    label: "# Scheduled NS+ Rider Hours"
    description: "# Scheduled Rider Hours (Assigned + Unassigned NS+ shift hours)"
    type: number
    sql: ${number_of_unassigned_hours_rider_ns_shift}+${number_of_planned_hours_rider_ns_shift};;
    value_format_name: decimal_1
  }

  measure: number_of_scheduled_hours_rider_refilled_shift {
    group_label: "> Rider Measures"
    label: "# Scheduled Refilled Rider Hours"
    description: "# Scheduled Rider Hours (Assigned + Unassigned Refilled hours)"
    type: number
    sql: ${number_of_unassigned_hours_rider_refilled_shift}+${number_of_planned_hours_rider_refilled_shift};;
    value_format_name: decimal_1
  }

  measure: number_of_scheduled_hours_rider_extra {
    group_label: "> Rider Measures"
    label: "# Extra Scheduled Rider Hours (EC, NS, WFS, Refilled)"
    description: "# Extra Scheduled Rider Hours  (Assigned + Unassigned EC, NS+, WFS and Refilled shift hours)"
    type: number
    sql: (
    ${number_of_unassigned_hours_rider_ec_shift} +
    ${number_of_unassigned_hours_rider_ns_shift} +
    ${number_of_unassigned_hours_rider_wfs_shift} +
    ${number_of_unassigned_hours_rider_refilled_shift}
    ) +
    (
    ${number_of_planned_hours_rider_ec_shift} +
    ${number_of_planned_hours_rider_ns_shift} +
    ${number_of_planned_hours_rider_wfs_shift} +
    ${number_of_planned_hours_rider_refilled_shift}
    );;
    value_format_name: decimal_1
  }

  measure: number_of_scheduled_hours_shift_lead {
    group_label: "> Shift Lead Measures"
    label: "# Scheduled Shift Lead Hours"
    description: "# Scheduled Shift Lead Hours  (Assigned + Unassigned)"
    type: number
    sql: ${number_of_unassigned_hours_shift_lead}+${number_of_planned_hours_shift_lead};;
    value_format_name: decimal_1
  }

  measure: number_of_scheduled_hours_hub_staff {
    group_label: "> Hub Staff Measures"
    label: "# Scheduled Hub Staff Hours Excl. Refilled Hours"
    description: "# Scheduled Hub Staff Hours (Picker, WH, Rider Captain, Ops Associate, Shift Lead) (Assigned + Unassigned) Excl. hours from assinged shifts with project code = 'Refilled shift'"
    type: number
    sql: ${number_of_scheduled_hours_ops_associate}+${number_of_scheduled_hours_shift_lead}+${number_of_scheduled_hours_ops_associate_plus};;
    value_format_name: decimal_1
  }

  measure: number_of_scheduled_hours_ops_associate {
    alias: [number_of_scheduled_hours_ops_staff]
    group_label: "> Ops Associate Measures"
    label: "# Scheduled Ops Associate Hours Excl. Refilled Hours"
    description: "# Scheduled Ops Associate Hours (Picker, WH, Rider Captain, Ops Associate) (Assigned + Unassigned) Excl. hours from assinged shifts with project code = 'Refilled shift'"
    type: number
    sql: ${number_of_unassigned_hours_ops_associate}+${number_of_planned_hours_ops_associate};;
    value_format_name: decimal_1
  }

  measure: number_of_scheduled_hours_internal_ops_associate {
    group_label: "> Ops Associate Measures"
    label: "# Scheduled Internal Ops Associate Hours Excl. Refilled Hours"
    description: "# Scheduled Internal Ops Associate Hours (Picker, WH, Rider Captain, Ops Associate) (Assigned + Unassigned) Excl. hours from assinged shifts with project code = 'Refilled shift'"
    type: number
    sql: ${number_of_unassigned_minutes_internal_ops_associate}/60+${number_of_planned_hours_internal_ops_associate};;
    value_format_name: decimal_1
  }

  measure: number_of_scheduled_hours_ops_associate_ec_shift {
    group_label: "> Ops Associate Measures"
    label: "# Scheduled EC Ops Associate Hours"
    description: "# Scheduled Ops Associate Hours (Picker, WH, Rider Captain, Ops Associate) (Assigned + Unassigned EC Shift Hours)"
    type: number
    sql: ${number_of_unassigned_hours_ops_associate_ec_shift}+${number_of_planned_hours_ops_associate_ec_shift};;
    value_format_name: decimal_1
  }

  measure: number_of_scheduled_hours_ops_associate_wfs_shift {
    group_label: "> Ops Associate Measures"
    label: "# Scheduled WFS Ops Associate Hours"
    description: "# Scheduled Ops Associate Hours (Picker, WH, Rider Captain, Ops Associate) (Assigned + Unassigned WFS Shift Hours)"
    type: number
    sql: ${number_of_unassigned_hours_ops_associate_wfs_shift}+${number_of_planned_hours_ops_associate_wfs_shift};;
    value_format_name: decimal_1
  }

  measure: number_of_scheduled_hours_ops_associate_wfs_shift_extended {
    group_label: "> Ops Associate Measures"
    label: "# Extended Scheduled WFS Ops Associate Hours"
    description: "# Extended Scheduled Ops Associate Hours (Picker, WH, Rider Captain, Ops Associate) (Assigned + Unassigned WFS Shift Hours)"
    type: number
    sql: ${number_of_unassigned_hours_ops_associate_wfs_shift_extended}+${number_of_planned_hours_ops_associate_wfs_shift_extended};;
    value_format_name: decimal_1
  }


  measure: number_of_scheduled_hours_ops_associate_ns_shift {
    group_label: "> Ops Associate Measures"
    label: "# Scheduled NS+ Ops Associate Hours"
    description: "# Scheduled Ops Associate Hours (Picker, WH, Rider Captain, Ops Associate) (Assigned + Unassigned NS+ Shift Hours)"
    type: number
    sql: ${number_of_unassigned_hours_ops_associate_ns_shift}+${number_of_planned_hours_ops_associate_ns_shift};;
    value_format_name: decimal_1
  }

  measure: number_of_scheduled_hours_ops_associate_refilled_shift {
    group_label: "> Ops Associate Measures"
    label: "# Scheduled Refilled Ops Associate Hours"
    description: "# Scheduled Ops Associate Hours (Picker, WH, Rider Captain, Ops Associate) (Assigned + Unassigned 'Refilled Shift' Hours)"
    type: number
    sql: ${number_of_unassigned_hours_ops_associate_refilled_shift}+${number_of_planned_hours_ops_associate_refilled_shift};;
    value_format_name: decimal_1
  }

  measure: number_of_scheduled_hours_ops_associate_extra {
    group_label: "> Ops Associate Measures"
    label: "# Extra Scheduled Ops Associate Hours (EC, NS+, WFS, Refilled)"
    description: "# Extra Scheduled Ops Associate Hours  (Assigned + Unassigned EC, NS+, WFS and Refilled hours)"
    type: number
    sql: ${number_of_scheduled_hours_ops_associate_ec_shift} +
    ${number_of_scheduled_hours_ops_associate_wfs_shift} +
    ${number_of_scheduled_hours_ops_associate_ns_shift} +
    ${number_of_scheduled_hours_ops_associate_refilled_shift}
    ;;
    value_format_name: decimal_1
  }

  ##### External

  measure: number_of_scheduled_hours_external_rider {
    group_label: "> Rider Measures"
    label: "# External Scheduled Rider Hours Excl. Refilled Hours"
    description: "# External Scheduled Rider Hours  (Assigned + Unassigned) Excl. hours from assinged shifts with project code = 'Refilled shift'"
    type: sum
    sql: (${number_of_unassigned_minutes_external_rider}+${number_of_planned_minutes_external_rider})/60;;
    value_format_name: decimal_1
  }

  measure: number_of_scheduled_hours_external_ops_associate {
    alias: [number_of_scheduled_hours_external_ops_staff]
    group_label: "> Ops Associate Measures"
    label: "# External Scheduled Ops Associate Hours Excl. Refilled Hours"
    description: "# External Scheduled Ops Associate Hours  (Assigned + Unassigned) (Picker, WH, Rider Captain, Ops Associate) Excl. hours from assinged shifts with project code = 'Refilled shift'"
    type: number
    sql: (${number_of_unassigned_minutes_external_ops_associate}+${number_of_planned_minutes_external_ops_associate})/60;;
    value_format_name: decimal_1
  }

  measure: number_of_scheduled_hours_external_shift_lead {
    group_label: "> Shift Lead Measures"
    label: "# External Scheduled Shift Lead Hours"
    description: "# External Scheduled Shift Lead Hours"
    type: sum
    sql: (${number_of_unassigned_minutes_external_shift_lead}+${number_of_planned_minutes_external_shift_lead})/60;;
    value_format_name: decimal_1
  }

  measure: number_of_scheduled_hours_external_hub_staff {
    group_label: "> Hub Staff Measures"
    label: "# External Scheduled Hub Staff Hours Excl. Refilled Hours"
    description: "# External Scheduled Hub Staff Hours (Picker, WH, Rider Captain, Ops Associate, Shift Lead) (Assigned + Unassigned) Excl. hours from assinged shifts with project code = 'Refilled shift'"
    type: number
    sql: (${number_of_scheduled_hours_external_ops_associate}+${number_of_scheduled_hours_external_shift_lead})/60;;
    value_format_name: decimal_1
  }

  # ========  Leave Minutes  ==========

  measure: number_of_leave_minutes_rider {
    group_label: "> Rider Measures"
    label: "# Leave Rider Minutes"
    type: sum
    sql: ${number_of_leave_minutes_rider_dimension};;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: number_of_leave_hours_rider {
    group_label: "> Rider Measures"
    label: "# Leave Rider Hours"
    type: sum
    sql: ${number_of_leave_minutes_rider_dimension}/60;;
    value_format_name: decimal_1
    hidden: yes
  }

  # =========  No Show Hours   =========
  ##### All

  measure: number_of_no_show_hours_ops_associate {
    alias: [number_of_no_show_hours_ops_staff]
    group_label: "> Ops Associate Measures"
    label: "# No Show Ops Associate Hours without Refilled Hours"
    description: "# Ops Associate Shift hours (Picker, WH, Rider Captain, Ops Associate) with missing punch and an absence applied or approved (incl. deleted shift and excl. shifts with project code = 'Refilled shift')  + Unassigned Hours from shifts with project code = 'NS+ shift'"
    type: number
    sql: (${number_of_no_show_minutes_ops_associate}+
         ${number_of_unassigned_hours_ops_associate_ns_shift})/60;;
    value_format_name: decimal_1
  }

  measure: number_of_no_show_hours_ops_associate_incl_ec_shift {
    group_label: "> Ops Associate Measures"
    label: "# No Show Ops Associate Hours without Refilled Hours & with EC Shifts"
    description: "# No Show Rider Hours including EC shifts"
    type: number
    sql: ${number_of_no_show_hours_ops_associate}+${number_of_no_show_hours_ops_associate_ec_shift};;
    value_format_name: decimal_1
  }

  measure: number_of_no_show_hours_ops_associate_incl_refilled_hours {
    group_label: "> Ops Associate Measures"
    label: "# No Show Ops Associate Hours with Refilled Hours"
    description: "# Shift hours with missing punch with an absence applied or approved (incl. deleted shift and shifts with project code = 'Refilled shift')"
    type: number
    sql: (${number_of_no_show_minutes_ops_associate}+
      ${number_of_no_show_minutes_refilled_shift_ops_associate})/60;;
    value_format_name: decimal_1
  }

  measure: number_of_no_show_minutes_rider {
    label: "# No Show Rider Minutes"
    type: sum
    sql: ${TABLE}.number_of_no_show_minutes_rider ;;
    hidden: yes
  }

  measure: number_of_no_show_hours_rider {
    group_label: "> Rider Measures"
    label: "# No Show Rider Hours with Refilled Hours"
    description: "# Shift hours with missing punch with an absence applied or approved (incl. deleted shift and excl. shifts with project code = 'Refilled shift')  + Unassinged Hours from shifts with project code = 'NS+ shift'"
    type: number
    sql: (${number_of_no_show_minutes_rider}+
         ${number_of_unassigned_hours_rider_ns_shift})/60;;
    value_format_name: decimal_1
  }

  measure: number_of_no_show_hours_rider_incl_refilled_hours {
    group_label: "> Rider Measures"
    label: "# No Show Rider Hours with Refilled Hours"
    description: "# Shift hours with missing punch with an absence applied or approved (incl. deleted shift and shifts with project code = 'Refilled shift')"
    type: number
    sql: (${number_of_no_show_minutes_rider}+
      ${number_of_no_show_minutes_refilled_shift_rider})/60;;
    value_format_name: decimal_1
  }

  measure: number_of_no_show_hours_rider_ec_shift {
    group_label: "> Rider Measures"
    label: "# No Show EC Rider Hours"
    description: "# No Show Rider Hours from shifts with project code = 'EC shift'"
    type: sum
    sql: ${TABLE}.number_of_no_show_minutes_ec_shift_rider/60;;
    value_format_name: decimal_1
  }

  measure: number_of_no_show_hours_rider_incl_ec_shift {
    group_label: "> Rider Measures"
    label: "# No Show Rider Hours without Refilled Hours & with EC Shift"
    description: "# No Show Rider Hours excluding Refilled Hours and including EC shifts"
    type: number
    sql: ${number_of_no_show_hours_rider}+${number_of_no_show_hours_rider_ec_shift};;
    value_format_name: decimal_1
  }

  measure: number_of_no_show_hours_rider_wfs_shift {
    group_label: "> Rider Measures"
    label: "# No Show WFS Rider Hours"
    description: "# No Show Rider Hours from shifts with project code = 'WFS shift'"
    type: sum
    sql: ${TABLE}.number_of_no_show_minutes_wfs_shift_rider/60;;
    value_format_name: decimal_1
  }

  measure: number_of_no_show_hours_rider_wfs_shift_extended {
    group_label: "> Rider Measures"
    label: "# Extended No Show WFS Rider Hours"
    description: "# Extended No Show Rider Hours from shifts with project code = 'WFS extend beg/end 1/2/4'."
    type: sum
    sql: ${TABLE}.number_of_no_show_minutes_wfs_shift_extended_rider/60;;
    value_format_name: decimal_1
  }

  measure: number_of_no_show_hours_rider_ns_shift {
    group_label: "> Rider Measures"
    label: "# No Show NS+ Rider Hours"
    description: "# No Show Rider Hours from shifts with project code = 'NS+ shift'"
    type: sum
    sql: ${TABLE}.number_of_no_show_minutes_ns_shift_rider/60;;
    value_format_name: decimal_1
  }

  measure: number_of_no_show_minutes_refilled_shift_rider {
    group_label: "> Rider Measures"
    label: "# Refilled No Show Rider Minutes"
    type: sum
    hidden: yes
    sql: ${TABLE}.number_of_no_show_minutes_refilled_shift_rider;;
    value_format_name: decimal_1
  }

  measure: number_of_no_show_hours_rider_refilled_shift {
    group_label: "> Rider Measures"
    label: "# Refilled No Show Rider Hours"
    description: "# No Show Rider Hours from shifts with project code = 'Refilled shift'"
    type: number
    sql: ${number_of_no_show_minutes_refilled_shift_rider}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_no_show_hours_ops_associate_ec_shift {
    group_label: "> Ops Associate Measures"
    label: "# No Show EC Ops Associate Hours"
    description: "# No Show Ops Associate Hours from shifts with project code = 'EC shift'"
    type: sum
    sql: ${TABLE}.number_of_no_show_minutes_ec_shift_ops_associate/60;;
    value_format_name: decimal_1
  }

  measure: number_of_no_show_hours_ops_associate_wfs_shift {
    group_label: "> Ops Associate Measures"
    label: "# No Show WFS Ops Associate Hours"
    description: "# No Show Ops Associate Hours from shifts with project code = 'WFS shift'"
    type: sum
    sql: ${TABLE}.number_of_no_show_minutes_wfs_shift_ops_associate/60;;
    value_format_name: decimal_1
  }

  measure: number_of_no_show_hours_ops_associate_wfs_shift_extended {
    group_label: "> Ops Associate Measures"
    label: "# Extended No Show WFS Ops Associate Hours"
    description: "# Extended No Show Ops Associate Hours from shifts with project code = 'WFS extend beg/end 1/2/4'."
    type: sum
    sql: ${TABLE}.number_of_no_show_minutes_wfs_shift_extended_ops_associate/60;;
    value_format_name: decimal_1
  }

  measure: number_of_no_show_hours_ops_associate_ns_shift {
    group_label: "> Ops Associate Measures"
    label: "# No Show NS+ Ops Associate Hours"
    description: "# No Show Ops Associate Hours from shifts with project code = 'NS+ shift'"
    type: sum
    sql: ${TABLE}.number_of_no_show_minutes_ns_shift_ops_associate/60;;
    value_format_name: decimal_1
  }

  measure: number_of_no_show_minutes_refilled_shift_ops_associate {
    group_label: "> Ops Associate Measures"
    label: "# Refilled No Show Ops Associate Minutes"
    type: sum
    hidden: yes
    sql: ${TABLE}.number_of_no_show_minutes_refilled_shift_ops_associate;;
    value_format_name: decimal_1
  }

  measure: number_of_no_show_hours_ops_associate_refilled_shift {
    group_label: "> Ops Associate Measures"
    label: "# Refilled No Show Ops Associate Hours"
    description: "# No Show Ops Associate Hours from shifts with project code = 'Refilled shift'"
    type: number
    sql: ${number_of_no_show_minutes_refilled_shift_ops_associate}/60;;
    value_format_name: decimal_1
  }


  measure: number_of_no_show_hours_shift_lead {
    group_label: "> Shift Lead Measures"
    label: "# No Show Shift Lead Hours"
    type: sum
    sql: ${number_of_no_show_minutes_shift_lead}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_no_show_hours_hub_staff {
    group_label: "> Hub Staff Measures"
    label: "# No Show Hub Staff Hours without Refilled Hours"
    description: "# No Show Hub Staff Hours (Ops Associate, Shift Lead, Ops Associate +)"
    type: number
    sql: ${number_of_no_show_hours_ops_associate}+${number_of_no_show_hours_shift_lead}+${number_of_no_show_hours_ops_associate_plus};;
    value_format_name: decimal_1
  }

  ##### External

  measure: number_of_no_show_hours_external_rider {
    group_label: "> Rider Measures"
    label: "# External No Show Rider Hours"
    type: sum
    sql: ${number_of_no_show_minutes_external_rider}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_no_show_hours_external_ops_associate {
    alias: [number_of_no_show_hours_external_ops_staff]
    group_label: "> Ops Associate Measures"
    label: "# External No Show Ops Associate Hours"
    description: "# External No Show Ops Associate Hours (Picker, WH, Rider Captain, Ops Associate)"
    type: number
    sql: ${number_of_no_show_minutes_external_ops_associate}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_no_show_hours_external_shift_lead {
    group_label: "> Shift Lead Measures"
    label: "# External No Show Shift Lead Hours"
    type: sum
    sql: ${number_of_no_show_minutes_external_shift_lead}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_no_show_hours_external_hub_staff {
    group_label: "> Hub Staff Measures"
    label: "# External No Show Hub Staff Hours"
    description: "# External No Show Hub Staff Hours (Picker, WH, Rider Captain, Ops Associate, Shift Lead, Ops Associate +)"
    type: number
    sql: ${number_of_no_show_hours_external_ops_associate}+${number_of_no_show_hours_external_shift_lead}+${number_of_no_show_hours_external_ops_associate_plus};;
    value_format_name: decimal_1
  }

##### Excused No Show

  measure: number_of_excused_no_show_hours_rider {
    group_label: "> Rider Measures"
    label: "# Excused No Show Rider Hours"
    type: sum
    sql: ${number_of_excused_no_show_minutes_rider}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_excused_no_show_hours_shift_lead {
    group_label: "> Shift Lead Measures"
    label: "# Excused No Show Shift Lead Hours"
    type: sum
    sql: ${number_of_excused_no_show_minutes_shift_lead}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_excused_no_show_hours_hub_staff {
    group_label: "> Hub Staff Measures"
    label: "# Excused No Show Hub Staff Hours"
    description: "# Excused No Show Hub Staff Hours (Picker, WH, Rider Captain, Ops Associate, Shift Lead, Ops Associate +)"
    type: number
    sql: (${number_of_excused_no_show_minutes_ops_associate}+sum(${number_of_excused_no_show_minutes_shift_lead}))/60+${number_of_excused_no_show_hours_ops_associate_plus};;
    value_format_name: decimal_1
  }

  measure: number_of_excused_no_show_hours_ops_associate {
    alias: [number_of_excused_no_show_hours_ops_staff]
    group_label: "> Ops Associate Measures"
    label: "# Excused No Show Ops Associate Hours"
    description: "# Excused No Show Ops Associate Hours (Picker, WH, Rider Captain, Ops Associate)"
    type: number
    sql: ${number_of_excused_no_show_minutes_ops_associate}/60;;
    value_format_name: decimal_1
  }

##### Unexcused No Show
  measure: number_of_unexcused_no_show_hours_rider {
    group_label: "> Rider Measures"
    label: "# Unexcused No Show Rider Hours"
    type: sum
    sql: ${number_of_unexcused_no_show_minutes_rider}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_unexcused_no_show_hours_shift_lead {
    group_label: "> Shift Lead Measures"
    label: "# Unexcused No Show Shift Lead Hours"
    type: sum
    sql: ${number_of_unexcused_no_show_minutes_shift_lead}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_unexcused_no_show_hours_hub_staff {
    group_label: "> Hub Staff Measures"
    label: "# Unexcused No Show Hub Staff Hours"
    description: "# Unexcused No Show Hub Staff Hours (Picker, WH, Rider Captain, Ops Associate, Shift Lead, Ops Associate +)"
    type: number
    sql: (${number_of_unexcused_no_show_minutes_ops_associate}+sum(${number_of_unexcused_no_show_minutes_shift_lead}))/60 + ${number_of_unexcused_no_show_hours_ops_associate_plus};;
    value_format_name: decimal_1
  }

  measure: number_of_unexcused_no_show_hours_ops_associate {
    alias: [number_of_unexcused_no_show_hours_ops_staff]
    group_label: "> Ops Associate Measures"
    label: "# Unexcused No Show Ops Associate Hours"
    description: "# Unexcused No Show Ops Associate Hours (Picker, WH, Rider Captain, Ops Associate)"
    type: number
    sql: ${number_of_unexcused_no_show_minutes_ops_associate}/60;;
    value_format_name: decimal_1
  }

  ##### Deleted Excused

  measure: number_of_deleted_excused_no_show_hours_rider {
    group_label: "> Rider Measures"
    label: "# Deleted Excused No Show Rider Hours"
    type: sum
    sql: ${number_of_deleted_excused_no_show_minutes_rider}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_deleted_excused_no_show_hours_shift_lead {
    group_label: "> Shift Lead Measures"
    label: "# Deleted Excused No Show Shift Lead Hours"
    type: sum
    sql: ${number_of_deleted_excused_no_show_minutes_shift_lead}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_deleted_excused_no_show_hours_ops_associate {
    alias: [number_of_deleted_excused_no_show_hours_ops_staff]
    group_label: "> Ops Associate Measures"
    label: "# Deleted Excused No Show Ops Associate Hours"
    description: "# Deleted Excused No Show Ops Associate Hours (Picker, WH, Rider Captain, Ops Associate)"
    type: number
    sql: ${number_of_deleted_excused_no_show_minutes_ops_associate}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_deleted_excused_no_show_hours_hub_staff {
    group_label: "> Hub Staff Measures"
    label: "# Deleted Excused No Show Hub Staff Hours"
    description: "# Deleted Excused No Show Hub sTAFF Hours (Picker, WH, Rider Captain, Ops Associate, Shift Lead, Ops Associate +)"
    type: number
    sql: (${number_of_deleted_excused_no_show_minutes_ops_associate}/60)+${number_of_deleted_excused_no_show_hours_shift_lead}+${number_of_deleted_excused_no_show_hours_ops_associate_plus};;
    value_format_name: decimal_1
  }

  ##### Deleted Unexcused

  measure: number_of_deleted_unexcused_no_show_hours_rider {
    group_label: "> Rider Measures"
    label: "# Deleted Unexcused No Show Rider Hours (Excl. in No Show metric)"
    type: sum
    sql: ${number_of_deleted_unexcused_no_show_minutes_rider}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_deleted_unexcused_no_show_hours_shift_lead {
    group_label: "> Shift Lead Measures"
    label: "# Deleted Unexcused No Show Shift Lead Hours (Excl. in No Show metric)"
    type: sum
    sql: ${number_of_deleted_unexcused_no_show_minutes_shift_lead}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_deleted_unexcused_no_show_hours_ops_associate {
    alias: [number_of_deleted_unexcused_no_show_hours_ops_staff]
    group_label: "> Ops Associate Measures"
    label: "# Deleted Unexcused No Show Ops Associate Hours (Excl. in No Show metric)"
    description: "# Deleted Unexcused No Show Ops Associate Hours (Picker, WH, Rider Captain, Ops Associate)"
    type: number
    sql: ${number_of_deleted_unexcused_no_show_minutes_ops_associate}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_deleted_unexcused_no_show_hours_hub_staff {
    group_label: "> Hub Staff Measures"
    label: "# Deleted Unexcused No Show Hub Staff Hours (Excl. in No Show metric)"
    description: "# Deleted Unexcused No Show Hub Staff Hours (Picker, WH, Rider Captain, Ops Associate, Shift Lead, Ops Associate +)"
    type: number
    sql: (${number_of_deleted_unexcused_no_show_minutes_ops_associate}/60) + ${number_of_deleted_unexcused_no_show_hours_shift_lead} + ${number_of_deleted_unexcused_no_show_hours_ops_associate_plus};;
    value_format_name: decimal_1
  }

  # =========  No Show %   =========
  measure: pct_no_show_hours_rider {
    group_label: "> Rider Measures"
    label: "% No Show Rider Hours without Refilled Hours"
    description: "# No Show Hours without Refilled Hours / (# Planned Hours - # Planned EC Hours + # Open NS+ Rider Hours)"
    type: number
    sql:(${number_of_no_show_hours_rider})/nullif(${number_of_planned_hours_rider}-${number_of_planned_hours_rider_ec_shift}+${number_of_unassigned_hours_rider_ns_shift},0) ;;
    value_format_name: percent_1
  }

  measure: pct_no_show_hours_rider_incl_refilled_hours {
    group_label: "> Rider Measures"
    label: "% No Show Rider Hours with Refilled Hours"
    description: "# No Show Hours with Refilled Hours / (# Planned Hours - # Planned EC Hours + # Planned Refilled Hours)"
    type: number
    sql:(${number_of_no_show_hours_rider_incl_refilled_hours})/nullif(${number_of_planned_hours_rider}-${number_of_planned_hours_rider_ec_shift}+${number_of_planned_hours_rider_refilled_shift},0) ;;
    value_format_name: percent_1
  }

  measure: pct_no_show_hours_rider_ops_associate {
    group_label: "> All Staff Measures"
    label: "% No Show Rider + Ops Associate without Refilled Hours"
    description: "# No Show Hours (Excl. Refilled Hours)/ (# Planned Hours - # Planned EC Hours + # Open NS+ Rider Hours)"
    type: number
    sql:(${number_of_no_show_hours_rider}+${number_of_no_show_hours_ops_associate})
            /nullif(${number_of_planned_hours_rider} + ${number_of_planned_hours_ops_associate}
                    -${number_of_planned_hours_rider_ec_shift} - ${number_of_planned_hours_ops_associate_ec_shift}
                    + ${number_of_unassigned_hours_rider_ns_shift} + ${number_of_unassigned_hours_ops_associate_ns_shift} ,0) ;;
    value_format_name: percent_1
  }

  measure: pct_no_show_hours_rider_incl_ec_shift {
    group_label: "> Rider Measures"
    label: "% No Show Rider Hours without Refilled Hours & with EC Shifts"
    description: " (# No Show Hours Excl. Refilled Hours + # EC No Show Hours) / (# Planned Hours + # Open NS+ Rider Hours)"
    type: number
    sql:(${number_of_no_show_hours_rider}+${number_of_no_show_hours_rider_ec_shift})/nullif(${number_of_planned_hours_rider}+${number_of_unassigned_hours_rider_ns_shift},0) ;;
    value_format_name: percent_1
  }

  measure: pct_no_show_hours_rider_ec_shift {
    group_label: "> Rider Measures"
    label: "% No Show EC Rider Hours"
    description: "# EC No Show Hours / # Planned EC Hours"
    type: number
    sql:(${number_of_no_show_hours_rider_ec_shift})/nullif(${number_of_planned_hours_rider_ec_shift},0) ;;
    value_format_name: percent_1
  }

  measure: pct_no_show_hours_shift_lead {
    group_label: "> Shift Lead Measures"
    label: "% No Show Shift Lead Hours"
    description: "# No Show Hours / (# Planned Hours - # Planned EC Hours)"
    type: number
    sql:(${number_of_no_show_hours_shift_lead})/nullif(${number_of_planned_hours_shift_lead}-${number_of_planned_hours_ops_associate_plus_ec_shift},0) ;;
    value_format_name: percent_1
  }

  measure: pct_no_show_hours_hub_staff {
    group_label: "> Hub Staff Measures"
    label: "% No Show Hub Staff Hours without Refilled Hours"
    description: "% No Show Hub Staff Hours (Picker, WH, Rider Captain, Ops Associate, Shift Lead, Ops Associate +) (# No Show Hours / (# Planned Hours - # Planned EC Hours + # Open NS+ Hours)"
    type: number
    sql:(${number_of_no_show_hours_hub_staff})/nullif(${number_of_planned_hours_hub_staff}-${number_of_planned_hours_hub_staff_ec_shift}+${number_of_unassigned_ns_hours_hub_staff},0) ;;
    value_format_name: percent_1
  }
  measure: pct_no_show_hours_ops_associate {
    alias: [pct_no_show_hours_ops_staff]
    group_label: "> Ops Associate Measures"
    label: "% No Show Ops Associate Hours without Refilled Hours"
    description: "% No Show Ops Associate Hours (Picker, WH, Rider Captain, Ops Associate) (# No Show Hours Excl. Refilled Hours / (# Planned Hours - # Planned EC Hours + # Open NS+ Hours) "
    type: number
    sql:(${number_of_no_show_hours_ops_associate})/nullif(${number_of_planned_hours_ops_associate}-${number_of_planned_hours_ops_associate_ec_shift}+${number_of_unassigned_hours_ops_associate_ns_shift},0) ;;
    value_format_name: percent_1
  }

  measure: pct_no_show_hours_ops_associate_incl_refilled_hours {
    group_label: "> Ops Associate Measures"
    label: "% No Show Ops Associate Hours with Refilled Hours"
    description: "# No Show Hours with Refilled Hours / (# Planned Hours - # Planned EC Hours + # Planned Refilled Hours)"
    type: number
    sql:(${number_of_no_show_hours_ops_associate_incl_refilled_hours})/nullif(${number_of_planned_hours_ops_associate}-${number_of_planned_hours_ops_associate_ec_shift}+${number_of_planned_hours_ops_associate_refilled_shift},0) ;;
    value_format_name: percent_1
  }

  measure: pct_no_show_hours_ops_associate_ec_shift {
    group_label: "> Ops Associate Measures"
    label: "% No Show EC Ops Associate Hours"
    description: "# EC No Show Hours / # Planned EC Hours"
    type: number
    sql:(${number_of_no_show_hours_ops_associate_ec_shift})/nullif(${number_of_planned_hours_ops_associate_ec_shift},0) ;;
    value_format_name: percent_1
  }

  measure: pct_no_show_hours_ops_associate_incl_ec_shift {
    group_label: "> Ops Associate Measures"
    label: "% No Show Ops Associate Hourswithout Refilled Hours & with EC Shifts"
    description: "(# No Show Hours + # EC No Show Hours) / # Planned Hours"
    type: number
    sql:${number_of_no_show_hours_ops_associate_incl_ec_shift}/nullif(${number_of_planned_hours_ops_associate}+${number_of_unassigned_hours_ops_associate_ns_shift},0) ;;
    value_format_name: percent_1
  }

  # =========  Workforce App   =========


  measure: number_of_online_hours_rider {
    group_label: "> Rider Measures"
    type: sum
    label: "# Rider Online Hours"
    description: "Number of hours rider spent online.
    It is calculated based on rider state change reason in Workforce app."
    sql: ${number_of_online_minutes_rider}/60 ;;
    value_format_name: decimal_2
  }

  measure: number_of_hub_one_tasks_hours_rider {
    group_label: "> Rider Measures"
    type: sum
    label: "# Rider Hub One Tasks Hours"
    description: "Number of hours rider spent temporary offline due to doing hub one tasks or shelf restocking.
    It is calculated based on rider state change reason in Workforce app."
    sql: ${number_of_hub_one_tasks_minutes_rider}/60 ;;
    value_format_name: decimal_2
  }

  measure: number_of_equipment_issue_hours_rider {
    group_label: "> Rider Measures"
    type: sum
    label: "# Rider Equipment Issue Hours"
    description: "Number of hours rider spent temporary offline due to equipment issues.
    It is calculated based on rider state change reason."
    sql: ${number_of_equipment_issue_minutes_rider}/60 ;;
    value_format_name: decimal_2
  }

  measure: number_of_large_order_support_hours {
    group_label: "> Rider Measures"
    type: sum
    label: "# Rider Large Order Support Hours"
    description: "Number of hours rider spent temporary offline due to supporting large orders.
    It is calculated based on rider state change reason."
    sql: ${number_of_large_order_support_minutes_rider}/60 ;;
    value_format_name: decimal_2
  }

  measure: number_of_accident_hours {
    group_label: "> Rider Measures"
    type: sum
    label: "# Rider Accident Hours"
    description: "Number of hours rider spent temporary offline due to an accident.
    It is calculated based on rider state change reason."
    sql: ${number_of_accident_minutes_rider}/60 ;;
    value_format_name: decimal_2
  }

  measure: number_of_temporary_offline_break_hours {
    group_label: "> Rider Measures"
    type: sum
    label: "# Rider Temporary Offline Break Hours"
    description: "Number of hours rider spent temporary offline due to taking break.
    It is calculated based on rider state change reason."
    sql: ${number_of_temporary_offline_break_minutes_rider}/60 ;;
    value_format_name: decimal_2
  }

  measure: number_of_total_temporary_offline_hours_rider {
    group_label: "> Rider Measures"
    type: sum
    label: "# Rider Temporary Offline Hours"
    description: "Number of hours rider spent temporary offline."
    sql: ${number_of_total_temporary_offline_minutes_rider}/60 ;;
    value_format_name: decimal_2
  }

  measure: number_of_other_temporary_offline_hours_rider {
    group_label: "> Rider Measures"
    type: sum
    label: "# Rider Other Temporary Offline Hours"
    description: "Number of hours rider spent temporary offline due to doing other tasks than hub one tasks, shelf restocking, equipment issues, supporting large orders, accident and breaks.
    It is calculated based on rider state change reason."
    sql: ${number_of_other_temporary_offline_minutes_rider}/60 ;;
    value_format_name: decimal_2
  }

  measure: number_of_unresponsive_hours_rider {
    group_label: "> Rider Measures"
    type: sum
    label: "# Rider Unresponsive Hours"
    description: "Number of minutes rider spent temporary offline due to order rejection or expiration. It is calculated based on rider state change reason."
    sql: ${number_of_unresponsive_minutes_rider}/60 ;;
    value_format_name: decimal_2
  }


  # =========  UTR   =========

  ## For a quick check only, needs to be deleted afterwards
  measure: deprecated_utr_rider {
    group_label: "> Rider Measures"
    label: "[old] Rider UTR (does not include onboarding)"
    description: "# Orders (without Click & Collect and External Orders) / # Punched Rider Hours"
    type: number
    hidden: yes
    sql: ${orders_with_ops_metrics.number_of_unique_flink_delivered_orders}/ nullif(${number_of_worked_hours_rider}}, 0) ;;
    value_format_name: decimal_2
  }

  measure: utr_rider {
    group_label: "> Rider Measures"
    label: "Rider UTR"
    description: "# Orders (excl. Click & Collect and External Orders) / # Punched Rider Hours (incl. Onboarding)"
    type: number
    sql: ${orders_with_ops_metrics.number_of_unique_flink_delivered_orders}/ nullif(${number_of_worked_hours_rider}+${number_of_worked_hours_onboarding}, 0) ;;
    value_format_name: decimal_2
  }

  parameter: slp_parameter_coefficient_a {
    label: "SLP Parameter A"
    type: number
    description: "When 18m <= fulfillment_time < 45m then UTR - A * fulfillment_time"
    default_value: "0.01"
  }

  parameter: slp_parameter_coefficient_b {
    label: "SLP Parameter B"
    type: number
    description: "When 45m <= fulfillment_time < 60m then (UTR - B) * (60 - fulfillment_time)/15))"
    default_value: "0.27"
  }

  measure: avg_fulfillment_time_slp_utr_ride{
    group_label: "> Rider Measures"
    label: "Rider SLP UTR"
    hidden: yes
    type: number
    sql: case
          when ${orders_with_ops_metrics.avg_fulfillment_time} < 18
            then ${ops.utr_rider}
          when ${orders_with_ops_metrics.avg_fulfillment_time} >= 18
            and ${orders_with_ops_metrics.avg_fulfillment_time} < 45
              then ${ops.utr_rider} - ({% parameter slp_parameter_coefficient_a %} * ${orders_with_ops_metrics.avg_fulfillment_time})
          when ${orders_with_ops_metrics.avg_fulfillment_time} >= 45
            and ${orders_with_ops_metrics.avg_fulfillment_time} < 60
              then (${ops.utr_rider}- {% parameter slp_parameter_coefficient_b %}) * (60 - (${orders_with_ops_metrics.avg_fulfillment_time}))/15
          when ${orders_with_ops_metrics.avg_fulfillment_time} >= 60
            then 0
          end;;
    value_format_name: decimal_2
  }

  measure: all_staff_utr {
    label: "All Staff UTR"
    type: number
    description: "# Orders (incl. Click & Collect and External Orders) / # Punched All Staff (incl. Rider, Onboarding, Picker, WH Ops, Rider Captain, Ops Associate, Shift Lead, and Ops Associate +) Hours"
    sql: ${orders_with_ops_metrics.sum_orders} / nullif(${number_of_worked_hours_rider}+${number_of_worked_hours_shift_lead}+${number_of_worked_hours_ops_associate}+${number_of_worked_hours_ops_associate_plus}+${number_of_worked_hours_onboarding}, 0);;
    value_format_name: decimal_2
    group_label: "> All Staff Measures"
  }

  measure: logistics_index {
    label: "Logistics Index"
    description: "AVG Fulfillment Time / Rider UTR"
    type: number
    sql: ${orders_with_ops_metrics.avg_fulfillment_time}/nullif(${utr_rider},0) ;;
    value_format_name: decimal_2
  }

  measure: utr_hub_staff {
    group_label: "> Hub Staff Measures"
    label: "Hub Staff UTR"
    description: "Hub Staff UTR (# Orders (incl. Click & Collect and External Orders) /Hub Staff Hours (Picker, WH, Rider Captain, Ops Associate, Shift Lead))"
    type: number
    sql: ${orders_with_ops_metrics.sum_orders}/ nullif(${number_of_worked_hours_hub_staff}, 0) ;;
    value_format_name: decimal_2
  }

  measure: utr_ops_associate {
    alias: [utr_ops_staff]
    group_label: "> Ops Associate Measures"
    label: "Ops Associate UTR"
    description: "Ops Associate UTR (# Orders (incl. Click & Collect and External Orders) /# Punched Ops Associate(Picker, WH, Rider Captain, Ops Associate) Hours)"
    type: number
    sql: ${orders_with_ops_metrics.sum_orders}/ nullif(${number_of_worked_hours_ops_associate}, 0) ;;
    value_format_name: decimal_2
  }

  measure: hub_staff_utr_all_items {
    group_label: "> Hub Staff Measures"
    label: "Hub Staff UTR (All Items)"
    description: "Hub Staff UTR (# All inventory Changes/Hub Staff Hours (Picker, WH, Rider Captain, Ops Associate, Shift Lead))"
    type: number
    sql: abs(${inventory_changes_daily.sum_quantity_change})/nullif(${number_of_worked_hours_hub_staff},0) ;;
    value_format_name: decimal_2
  }

  measure: hub_staff_utr_inbounded_handling_units {
    group_label: "> Hub Staff Measures"
    label: "Hub Staff UTR (Inbounded Handling Units)"
    description: "Hub Staff UTR (# All inventory Changes/Hub Staff Hours (Picker, WH, Rider Captain, Ops Associate, Shift Lead))"
    type: number
    sql: abs(${inventory_changes_daily.sum_inbound_inventory_handling_units})/nullif(${number_of_worked_hours_hub_staff},0) ;;
    value_format_name: decimal_2
  }

  measure: hub_staff_utr_picked_items {
    group_label: "> Hub Staff Measures"
    label: "Hub Staff UTR (Ordered Items)"
    description: "Hub Staff UTR (# Ordered Items/Hub Staff Hours (Picker, WH, Rider Captain, Ops Associate, Shift Lead))"
    type: number
    sql: abs(${inventory_changes_daily.sum_outbound_orders})/nullif(${number_of_worked_hours_hub_staff},0) ;;
    value_format_name: decimal_2
  }

  measure: hub_staff_utr_outbounded_items {
    group_label: "> Hub Staff Measures"
    label: "Hub Staff UTR (Outbounded Items)"
    description: "Hub Staff UTR (# Outbounded Items (Waste, Orders, Too good to go,Wrong delivery)/Hub Staff Hours (Picker, WH, Rider Captain, Ops Associate, Shift Lead))"
    type: number
    sql: abs(${inventory_changes_daily.sum_outbound_too_good_to_go}+${inventory_changes_daily.sum_outbound_waste}+${inventory_changes_daily.sum_outbound_wrong_delivery}+${inventory_changes_daily.sum_outbound_orders})
      /nullif(${number_of_worked_hours_hub_staff},0) ;;
    value_format_name: decimal_2
  }

  # =========  Dynamic Measures   =========

  dimension: number_of_no_show_hours_by_position_dimension {
    type: number
    label: "# No Show Hours - Dimension"
    description: "Sum of shift hours when an employee has a scheduled shift but does not show up to it without leave reason including deleted shift hours when deletion date is on or after shift date. includes (Excused No show Hours, Unexcused No show Hours, Excused Deleted No show Hours)"
    value_format_name: decimal_1
    group_label: "> Dynamic Measures"
    sql:
        case
          when {% parameter position_parameter %} = 'Rider' THEN ${number_of_no_show_minutes_rider}/60
          else null
        end ;;
    hidden: yes
  }

  measure: number_of_planned_hours_by_position {
    type: number
    label: "# Filled Hours without Refilled Hours & with EC Shift"
    description: "# Shift Hours Assigned to an Employee"
    value_format_name: decimal_1
    group_label: "> Dynamic Measures"
    sql:
        case
          when {% parameter position_parameter %} = 'Rider' THEN ${number_of_planned_hours_rider}
          when {% parameter position_parameter %} = 'Shift Lead' THEN ${number_of_planned_hours_shift_lead}
          when {% parameter position_parameter %} = 'Ops Associate +' THEN ${number_of_planned_hours_ops_associate_plus}
          when {% parameter position_parameter %} = 'Hub Staff' THEN ${number_of_planned_hours_hub_staff}
          when {% parameter position_parameter %} = 'Ops Associate' THEN ${number_of_planned_hours_ops_associate}
          else null
        end ;;
  }

  measure: number_of_planned_hours_excl_no_show_by_position {
    type: number
    label: "# Filled Hours (with EC Shift and without No Show & Refilled Hours)"
    description: "# Shift Hours Assigned to an Employee including EC Shifts and excluding No Show"
    value_format_name: decimal_1
    group_label: "> Dynamic Measures"
    sql:  ${number_of_planned_hours_by_position}-${number_of_no_show_hours_by_position_incl_ec_shift};;
  }

  measure: number_of_planned_hours_ec_shift_by_position {
    type: number
    label: "# EC Filled Hours"
    description: "# Shift Hours Assigned to an Employee from shifts with project code: EC shifts"
    value_format_name: decimal_1
    group_label: "> Dynamic Measures"
    sql:
        case
          when {% parameter position_parameter %} = 'Rider' THEN ${number_of_planned_hours_rider_ec_shift}
          when {% parameter position_parameter %} = 'Shift Lead' THEN ${number_of_planned_hours_shift_lead_ec_shift}
          when {% parameter position_parameter %} = 'Ops Associate +' THEN ${number_of_planned_hours_ops_associate_plus_ec_shift}
          when {% parameter position_parameter %} = 'Hub Staff' THEN ${number_of_planned_hours_hub_staff_ec_shift}
          when {% parameter position_parameter %} = 'Ops Associate' THEN ${number_of_planned_hours_ops_associate_ec_shift}
          else null
        end ;;
  }

  measure: number_of_excused_no_show_hours_by_position {
    type: number
    label: "# Excused No Show Hours (without EC Shift)"
    description: "Sum of shift hours when an employee has a scheduled shift but does not show up to it with leave reason"
    value_format_name: decimal_1
    group_label: "> Dynamic Measures"
    sql:
        case
          when {% parameter position_parameter %} = 'Rider' THEN ${number_of_excused_no_show_hours_rider}
          when {% parameter position_parameter %} = 'Shift Lead' THEN ${number_of_excused_no_show_hours_shift_lead}
          when {% parameter position_parameter %} = 'Ops Associate +' THEN ${number_of_excused_no_show_hours_ops_associate_plus}
          when {% parameter position_parameter %} = 'Hub Staff' THEN ${number_of_excused_no_show_hours_hub_staff}
          when {% parameter position_parameter %} = 'Ops Associate' THEN ${number_of_excused_no_show_hours_ops_associate}
          else null
        end ;;
  }

  measure: number_of_unexcused_no_show_hours_by_position {
    type: number
    label: "# Unexcused No Show Hours (without EC Shift)"
    description: "Sum of shift hours when an employee has a scheduled shift but does not show up to it without leave reason"
    value_format_name: decimal_1
    group_label: "> Dynamic Measures"
    sql:
        case
          when {% parameter position_parameter %} = 'Rider' THEN ${number_of_unexcused_no_show_hours_rider}
          when {% parameter position_parameter %} = 'Shift Lead' THEN ${number_of_unexcused_no_show_hours_shift_lead}
          when {% parameter position_parameter %} = 'Ops Associate +' THEN ${number_of_unexcused_no_show_hours_ops_associate_plus}
          when {% parameter position_parameter %} = 'Hub Staff' THEN ${number_of_unexcused_no_show_hours_hub_staff}
          when {% parameter position_parameter %} = 'Ops Associate' THEN ${number_of_unexcused_no_show_hours_ops_associate}
          else null
        end ;;
  }


  measure: number_of_deleted_excused_no_show_hours_by_position {
    type: number
    label: "# Deleted Excused No Show Hours (without EC Shift)"
    description: "Sum of deleted shift hours when an employee has a scheduled shift but does not show up to it with leave reason and shift deletion date is on/after shift date (shift date <= deletion date)"
    value_format_name: decimal_1
    group_label: "> Dynamic Measures"
    sql:
        case
          when {% parameter position_parameter %} = 'Rider' THEN ${number_of_deleted_excused_no_show_hours_rider}
          when {% parameter position_parameter %} = 'Shift Lead' THEN ${number_of_deleted_excused_no_show_hours_shift_lead}
          when {% parameter position_parameter %} = 'Ops Associate +' THEN ${number_of_deleted_excused_no_show_hours_ops_associate_plus}
          when {% parameter position_parameter %} = 'Ops Associate' THEN ${number_of_deleted_excused_no_show_hours_ops_associate}
          when {% parameter position_parameter %} = 'Hub Staff' THEN ${number_of_deleted_excused_no_show_hours_hub_staff}
          else null
        end ;;
  }

  measure: number_of_deleted_unexcused_no_show_hours_by_position {
    type: number
    label: "# Deleted Unexcused No Show Hours (Excluded in No Show metric and without EC Shift)"
    description: "Sum of deleted shift hours when an employee has a scheduled shift but does not show up to it without leave reason and shift deletion date is on/after shift date (shift date <= deletion date)"
    value_format_name: decimal_1
    group_label: "> Dynamic Measures"
    sql:
        case
          when {% parameter position_parameter %} = 'Rider' THEN ${number_of_deleted_unexcused_no_show_hours_rider}
          when {% parameter position_parameter %} = 'Shift Lead' THEN ${number_of_deleted_unexcused_no_show_hours_shift_lead}
          when {% parameter position_parameter %} = 'Ops Associate +' THEN ${number_of_deleted_unexcused_no_show_hours_ops_associate_plus}
          when {% parameter position_parameter %} = 'Ops Associate' THEN ${number_of_deleted_unexcused_no_show_hours_ops_associate}
          when {% parameter position_parameter %} = 'Hub Staff' THEN ${number_of_deleted_unexcused_no_show_hours_hub_staff}
          else null
        end ;;
  }

  measure: pct_fill_rate {
    type: number
    label: "% Fill Rate (with EC Shift & without Refilled Hours )"
    description: "# Filled Hours (Assigned to an Employee) / # Scheduled Hours (Total Scheduled Shift Hours = Assigned Hours + Open Hours)"
    value_format_name: percent_2
    group_label: "> Dynamic Measures"
    sql: ${number_of_planned_hours_by_position}/nullif(${number_of_scheduled_hours_by_position},0);;
  }

  measure: pct_fill_rate_rider_ns_shift {
    group_label: "> Rider Measures"
    label: "% Fill Rate NS+ Rider Hours"
    description: "% Filled Hours (Assigned to an Employee) from shifts with project code = 'NS+ shift' / # Scheduled Hours (Assigned Hours + Open Hours) from shifts with project code = 'NS+ shift'"
    type: number
    sql: ${number_of_planned_hours_rider_ns_shift}/nullif(${number_of_scheduled_hours_rider_ns_shift},0);;
    value_format_name: percent_2
  }

  measure: pct_fill_rate_ops_associate_ns_shift {
    group_label: "> Ops Associate Measures"
    label: "% Fill Rate NS+ Ops Associate Hours"
    description: "% Filled Hours (Assigned to an Employee) from shifts with project code = 'NS+ shift' / # Scheduled Hours (Assigned Hours + Open Hours) from shifts with project code = 'NS+ shift'"
    type: number
    sql: ${number_of_planned_hours_ops_associate_ns_shift}/nullif(${number_of_scheduled_hours_ops_associate_ns_shift},0);;
    value_format_name: percent_2
  }

  measure: pct_unassignment_rate {
    type: number
    label: "% Unassignment Rate (with EC Shift)"
    description: "1 - Fill Rate"
    value_format_name: percent_2
    group_label: "> Dynamic Measures"
    sql: 1 - ${pct_fill_rate};;
  }

  measure: pct_fill_rate_internal_rider {
    type: number
    label: "% Fill Rate (with EC Shift) Internal Rider"
    description: "# Filled Hours (Assigned to an Employee) Internal Rider / # Scheduled Hours (Total Scheduled Shift Hours = Assigned Hours + Open Hours) Internal Rider"
    value_format_name: percent_2
    group_label: "> Rider Measures"
    sql: ${number_of_planned_hours_internal_rider}/nullif(${number_of_scheduled_hours_internal_rider},0);;
  }

  measure: pct_unassignment_rate_internal_riders {
    type: number
    label: "% Unassignment Rate (with EC Shift & without Refilled Hours) Internal Rider "
    description: "1 - Fill Rate Internal Rider Excl. hours from shifts with project code = 'Refilled shift'"
    value_format_name: percent_2
    group_label: "> Rider Measures"
    sql: 1 - ${pct_fill_rate_internal_rider};;
  }

  measure: pct_fill_rate_external_rider {
    type: number
    label: "% Fill Rate (with EC Shift & without Refilled Hours) External Rider"
    description: "# Filled Hours (Assigned to an Employee) External Rider / # Scheduled Hours (Total Scheduled Shift Hours = Assigned Hours + Open Hours) External Rider Excl. hours from shifts with project code = 'Refilled shift'"
    value_format_name: percent_2
    group_label: "> Rider Measures"
    sql: ${number_of_planned_hours_external_rider}/nullif(${number_of_scheduled_hours_external_rider},0);;
  }

  measure: pct_unassignment_rate_external_riders {
    type: number
    label: "% Unassignment Rate (with EC Shift & without Refilled Hours) External Rider"
    description: "1 - Fill Rate External Rider Excl. hours from shifts with project code = 'Refilled shift'"
    value_format_name: percent_2
    group_label: "> Rider Measures"
    sql: 1 - ${pct_fill_rate_external_rider};;
  }

  measure: pct_fill_rate_internal_ops_associate {
    type: number
    label: "% Fill Rate (with EC Shift & without Refilled Hours) Internal Ops Associate"
    description: "# Filled Hours (Assigned to an Employee) Internal Ops Associate / # Scheduled Hours (Total Scheduled Shift Hours = Assigned Hours + Open Hours) Internal Ops Associate Excl. hours from shifts with project code = 'Refilled shift'"
    value_format_name: percent_2
    group_label: "> Ops Associate Measures"
    sql: ${number_of_planned_hours_internal_ops_associate}/nullif(${number_of_scheduled_hours_internal_ops_associate},0);;
  }

  measure: pct_unassignment_rate_internal_ops_associate {
    type: number
    label: "% Unassignment Rate (with EC Shift & without Refilled Hours) Internal Ops Associate"
    description: "1 - Fill Rate Internal Ops Associate Excl. hours from shifts with project code = 'Refilled shift'"
    value_format_name: percent_2
    group_label: "> Ops Associate Measures"
    sql: 1 - ${pct_fill_rate_internal_ops_associate};;
  }

  measure: pct_fill_rate_external_ops_associate {
    type: number
    label: "% Fill Rate (with EC Shift & without Refilled Hours) External Ops Associate"
    description: "# Filled Hours (Assigned to an Employee) External Ops Associate / # Scheduled Hours (Total Scheduled Shift Hours = Assigned Hours + Open Hours) External Ops Associate Excl. hours from shifts with project code = 'Refilled shift'"
    value_format_name: percent_2
    group_label: "> Ops Associate Measures"
    sql: ${number_of_planned_hours_external_ops_associate}/nullif(${number_of_scheduled_hours_external_ops_associate},0);;
  }

  measure: pct_unassignment_rate_external_ops_associate {
    type: number
    label: "% Unassignment Rate (with EC Shift & without Refilled Hours) External Ops Associate"
    description: "1 - Fill Rate External Ops Associate Excl. hours from shifts with project code = 'Refilled shift'"
    value_format_name: percent_2
    group_label: "> Ops Associate Measures"
    sql: 1 - ${pct_fill_rate_external_ops_associate};;
  }

  measure: pct_unexcused_absence {
    type: number
    label: "% Unexcused Absence (without EC Shift & Refilled Hours)"
    description: "# Unexcused No Show Hours / # Filled Hours (Assigned to an Employee) Excl. hours from shifts with project code = 'Refilled shift'"
    value_format_name: percent_2
    group_label: "> Dynamic Measures"
    sql: (${number_of_unexcused_no_show_hours_by_position})/nullif(${number_of_planned_hours_by_position}-${number_of_planned_hours_ec_shift_by_position},0);;
  }

  measure: pct_excused_absence {
    type: number
    label: "% Excused Absence (without EC Shift & Refilled Hours)"
    description: "# Excused No Show Hours / # Filled Hours (Assigned to an Employee) Excl. hours from shifts with project code = 'Refilled shift'"
    value_format_name: percent_2
    group_label: "> Dynamic Measures"
    sql: (${number_of_deleted_excused_no_show_hours_by_position}+${number_of_excused_no_show_hours_by_position})/nullif(${number_of_planned_hours_by_position}-${number_of_planned_hours_ec_shift_by_position},0);;
  }

  measure: number_of_unassigned_hours_by_position {
    type: number
    label: "# Open Hours (with EC Shift & without Refilled Hours)"
    description: "# Open Shift Hours (Not assigned to an Employee) Excl. hours from shifts with project code = 'Refilled shift'"
    value_format_name: decimal_1
    group_label: "> Dynamic Measures"
    sql:
        case
          when {% parameter position_parameter %} = 'Rider' THEN ${number_of_unassigned_hours_rider}
          when {% parameter position_parameter %} = 'Shift Lead' THEN ${number_of_unassigned_hours_shift_lead}
          when {% parameter position_parameter %} = 'Ops Associate +' THEN ${number_of_unassigned_hours_ops_associate_plus}
          when {% parameter position_parameter %} = 'Hub Staff' THEN ${number_of_unassigned_hours_hub_staff}
          when {% parameter position_parameter %} = 'Ops Associate' THEN ${number_of_unassigned_hours_ops_associate}
          else null
      end ;;
  }

  measure: number_of_scheduled_hours_by_position {
    type: number
    label: "# Scheduled Hours (with Deleted Excused No Show and EC Shift without Refilled Hours)"
    description: "Sum of Assigned and Unassigned (Open) Shift Hours (Incl. Deleted Excused No Show) Excl. hours from shifts with project code = 'Refilled shift'"
    value_format_name: decimal_1
    group_label: "> Dynamic Measures"
    sql:
        case
          when {% parameter position_parameter %} = 'Rider' THEN ${number_of_scheduled_hours_rider}
          when {% parameter position_parameter %} = 'Shift Lead' THEN ${number_of_scheduled_hours_shift_lead}
          when {% parameter position_parameter %} = 'Ops Associate +' THEN ${number_of_scheduled_hours_ops_associate_plus}
          when {% parameter position_parameter %} = 'Hub Staff' THEN ${number_of_scheduled_hours_hub_staff}
          when {% parameter position_parameter %} = 'Ops Associate' THEN ${number_of_scheduled_hours_ops_associate}
          else null
        end ;;
  }

  measure: number_of_scheduled_hours_by_position_ec_shift {
    type: number
    label: "# EC Scheduled Hours (Incl. Deleted Excused No Show)"
    description: "Sum of Assigned and Unassigned (Open) Shift Hours from EC shifts (Incl. Deleted Excused No Show)"
    value_format_name: decimal_1
    group_label: "> Dynamic Measures"
    sql:
        case
          when {% parameter position_parameter %} = 'Rider' THEN ${number_of_scheduled_hours_rider_ec_shift}
          when {% parameter position_parameter %} = 'Ops Associate' THEN ${number_of_scheduled_hours_ops_associate_ec_shift}
          else null
        end ;;
  }

  measure: number_of_scheduled_hours_by_position_wfs_shift {
    type: number
    label: "# WFS Scheduled Hours (Incl. Deleted Excused No Show)"
    description: "Sum of Assigned and Unassigned (Open) Shift Hours from WFS shifts (Incl. Deleted Excused No Show)"
    value_format_name: decimal_1
    group_label: "> Dynamic Measures"
    sql:
        case
          when {% parameter position_parameter %} = 'Rider' THEN ${number_of_scheduled_hours_rider_wfs_shift}
          when {% parameter position_parameter %} = 'Ops Associate' THEN ${number_of_scheduled_hours_ops_associate_wfs_shift}
          else null
        end ;;
  }

  measure: number_of_scheduled_hours_by_position_wfs_shift_extended {
    type: number
    label: "# Extended WFS Scheduled Hours (Incl. Deleted Excused No Show)"
    description: "Sum of Extended Assigned and Unassigned (Open) Shift Hours from WFS shifts (Incl. Deleted Excused No Show)"
    value_format_name: decimal_1
    group_label: "> Dynamic Measures"
    sql:
        case
          when {% parameter position_parameter %} = 'Rider' THEN ${number_of_scheduled_hours_rider_wfs_shift_extended}
          when {% parameter position_parameter %} = 'Ops Associate' THEN ${number_of_scheduled_hours_ops_associate_wfs_shift_extended}
          else null
        end ;;
  }

  measure: number_of_scheduled_hours_by_position_ns_shift {
    type: number
    label: "# NS+ Scheduled Hours (Incl. Deleted Excused No Show)"
    description: "Sum of Assigned and Unassigned (Open) Shift Hours from NS+ shifts (Incl. Deleted Excused No Show)"
    value_format_name: decimal_1
    group_label: "> Dynamic Measures"
    sql:
        case
          when {% parameter position_parameter %} = 'Rider' THEN ${number_of_scheduled_hours_rider_ns_shift}
          when {% parameter position_parameter %} = 'Ops Associate' THEN ${number_of_scheduled_hours_ops_associate_ns_shift}
          else null
        end ;;
  }

  measure: number_of_scheduled_hours_by_position_refilled_shift {
    type: number
    label: "# Refilled Scheduled Hours (Incl. Deleted Excused No Show)"
    description: "Sum of Assigned and Unassigned (Open) shifts with project code = 'Refilled shift' (Incl. Deleted Excused No Show)"
    value_format_name: decimal_1
    group_label: "> Dynamic Measures"
    sql:
        case
          when {% parameter position_parameter %} = 'Rider' THEN ${number_of_scheduled_hours_rider_refilled_shift}
          when {% parameter position_parameter %} = 'Ops Associate' THEN ${number_of_scheduled_hours_ops_associate_refilled_shift}
          else null
        end ;;
  }

  measure: number_of_scheduled_hours_by_position_extra {
    type: number
    label: "# Extra Scheduled Hours (EC, NS+. WFS, Refilled Shifts) (Incl. Deleted Excused No Show)"
    description: "Sum of Assigned and Unassigned (Open) EC, NS+, WFS and Refilled shift hours (Incl. Deleted Excused No Show)"
    value_format_name: decimal_1
    group_label: "> Dynamic Measures"
    sql:
        case
          when {% parameter position_parameter %} = 'Rider' THEN ${number_of_scheduled_hours_rider_extra}
          when {% parameter position_parameter %} = 'Ops Associate' THEN ${number_of_scheduled_hours_ops_associate_extra}
          else null
        end ;;
  }

  measure: pct_extra_scheduled_hours_by_position {
    type: number
    label: "% Extra Scheduled Hours (EC, NS+, WFS, Refilled Shifts) (Incl. Deleted Excused No Show)"
    description: "Share of Assigned and Unassigned (Open) EC, NS+, WFS and Refilled shift hours (Incl. Deleted Excused No Show) over all Assigned and Unassigned (Open) shift hours"
    value_format_name: decimal_1
    group_label: "> Dynamic Measures"
    sql: ${number_of_scheduled_hours_by_position_extra}/${number_of_scheduled_hours_by_position} ;;
  }

  measure: number_of_worked_hours_by_position_extra {
    type: number
    label: "# Extra Punched Hours (EC, NS+, WFS, Refilled Shifts)"
    description: "Sum of Worked Hours from shifts with project code NS+. WFS, EC and Refilled shifts"
    value_format_name: decimal_1
    group_label: "> Dynamic Measures"
    sql:
        case
          when {% parameter position_parameter %} = 'Rider' then ${number_of_worked_hours_rider_extra}
          when {% parameter position_parameter %} = 'Ops Associate' then ${number_of_worked_hours_ops_associate_extra}
          else null
        end ;;
  }

  measure: number_of_worked_hours_by_position_ec_shift {
    type: number
    label: "# EC Punched Hours"
    description: "Sum of Worked Hours from shifts with project code EC"
    value_format_name: decimal_1
    group_label: "> Dynamic Measures"
    sql:
        case
          when {% parameter position_parameter %} = 'Rider' then ${number_of_worked_hours_rider_ec_shift}
          when {% parameter position_parameter %} = 'Ops Associate' then ${number_of_worked_hours_ops_associate_ec_shift}
          else null
        end ;;
  }

  measure: pct_extra_worked_hours_by_position {
    type: number
    label: "% Extra Punched Hours (EC, NS+, WFS, Refilled Shifts)"
    description: "Share of Worked Hours from shifts with project code NS+. WFS, EC and Refilled shifts over all Worked hours"
    value_format_name: decimal_1
    group_label: "> Dynamic Measures"
    sql: ${number_of_worked_hours_by_position_extra}/${number_of_worked_hours_by_position} ;;

  }

  measure: pct_scheduled_hours_by_position {
    type: number
    label: "% External Scheduled Hours (with EC Shift)"
    description: "Sum External Scheduled Hours (Assigned + Unassigned) / Sum Scheduled Hours (Assigned + Open Hours)"
    value_format_name: percent_1
    group_label: "> Dynamic Measures"
    sql:
        case
          when {% parameter position_parameter %} = 'Rider' THEN ${number_of_scheduled_hours_external_rider}/nullif(${number_of_scheduled_hours_rider},0)
          when {% parameter position_parameter %} = 'Shift Lead' THEN ${number_of_scheduled_hours_external_shift_lead}/nullif(${number_of_scheduled_hours_shift_lead},0)
          when {% parameter position_parameter %} = 'Ops Associate +' THEN ${number_of_scheduled_hours_external_ops_associate_plus}/nullif(${number_of_scheduled_hours_ops_associate_plus},0)
          when {% parameter position_parameter %} = 'Hub Staff' THEN ${number_of_scheduled_hours_external_hub_staff}/nullif(${number_of_scheduled_hours_hub_staff},0)
          when {% parameter position_parameter %} = 'Ops Associate' THEN ${number_of_scheduled_hours_external_ops_associate}/nullif(${number_of_scheduled_hours_ops_associate},0)
          else null
        end ;;
  }

  dimension: number_of_scheduled_hours_by_position_dimension {
    type: number
    label: "# Scheduled Hours (Incl. Deleted Excused No Show) - Dimension"
    description: "Sum of Assigned and Unassigned Shift Hours (Incl. Deleted Excused No Show)"
    value_format_name: decimal_1
    group_label: "> Dynamic Measures"
    sql:
        case
          when {% parameter position_parameter %} = 'Rider' THEN ${number_of_scheduled_hours_rider_dimension}
          else null
        end ;;
    hidden: yes
  }

  dimension: number_of_worked_hours_by_position_dimension {
    type: number
    label: "# Worked Hours - Dimension"

    value_format_name: decimal_1
    group_label: "> Dynamic Measures"
    sql:
        case
          when {% parameter position_parameter %} = 'Rider' THEN ${number_of_worked_minutes_rider}/60
          when {% parameter position_parameter %} = 'Shift Lead' THEN ${number_of_worked_minutes_shift_lead}/60
          when {% parameter position_parameter %} = 'Ops Associate' THEN ${TABLE}.number_of_worked_minutes_ops_associate/60
          else null
        end ;;
    hidden: yes
  }

  measure: number_of_scheduled_hours_excluding_deleted_shifts_by_position {
    type: number
    label: "# Scheduled Hours (without Deleted Excused No Show and with EC Shift)"
    description: "Sum of Assigned and Unassigned Shift Hours (Excl. Deleted Excused No Show)"
    value_format_name: decimal_1
    group_label: "> Dynamic Measures"
    sql:
      case
        when {% parameter position_parameter %} = 'Rider' THEN ${number_of_scheduled_hours_rider} - ${number_of_deleted_excused_no_show_hours_rider}
        when {% parameter position_parameter %} = 'Shift Lead' THEN ${number_of_scheduled_hours_shift_lead} - ${number_of_deleted_excused_no_show_hours_shift_lead}
        when {% parameter position_parameter %} = 'Ops Associate +' THEN ${number_of_scheduled_hours_ops_associate_plus} - ${number_of_deleted_excused_no_show_hours_ops_associate_plus}
        when {% parameter position_parameter %} = 'Ops Associate' THEN ${number_of_scheduled_hours_ops_associate} - ${number_of_deleted_excused_no_show_hours_ops_associate}
        when {% parameter position_parameter %} = 'Hub Staff' THEN ${number_of_scheduled_hours_hub_staff} - ${number_of_deleted_excused_no_show_hours_hub_staff}
        else null
      end ;;
  }



  measure: number_of_worked_hours_by_position {
    type: number
    label: "# Punched Hours (with EC Shift)"
    description: "# Hours Worked by an Employee"
    value_format_name: decimal_1
    group_label: "> Dynamic Measures"
    sql:
        case
          when {% parameter position_parameter %} = 'Rider' then ${number_of_worked_hours_rider}
          when {% parameter position_parameter %} = 'Shift Lead' then ${number_of_worked_hours_shift_lead}
          when {% parameter position_parameter %} = 'Ops Associate +' then ${number_of_worked_hours_ops_associate_plus}
          when {% parameter position_parameter %} = 'Hub Staff' then ${number_of_worked_hours_hub_staff}
          when {% parameter position_parameter %} = 'Ops Associate' then ${number_of_worked_hours_ops_associate}
          else null
        end ;;
  }

  measure: number_of_no_show_hours_by_position {
    type: number
    label: "# No Show Hours (without Refilled Hours & EC Shift)"
    description: "Sum of shift hours (Excl. Refilled Hours & EC Shifts) when an employee has a scheduled shift but does not show up to it without leave reason including deleted shift hours when deletion date is on or after shift date. includes (Excused No show Hours, Unexcused No show Hours, Excused Deleted No show Hours)"
    value_format_name: decimal_1
    group_label: "> Dynamic Measures"
    sql:
        case
          when {% parameter position_parameter %} = 'Rider' THEN ${number_of_no_show_hours_rider}
          when {% parameter position_parameter %} = 'Ops Associate +' THEN ${number_of_no_show_hours_ops_associate_plus}
          when {% parameter position_parameter %} = 'Shift Lead' THEN ${number_of_no_show_hours_shift_lead}
          when {% parameter position_parameter %} = 'Hub Staff' THEN ${number_of_no_show_hours_hub_staff}
          when {% parameter position_parameter %} = 'Ops Associate' THEN ${number_of_no_show_hours_ops_associate}
          else null
        end ;;
  }

  measure: number_of_no_show_hours_by_position_ec_shift {
    type: number
    label: "# EC No Show Hours"
    description: "Sum of EC Shift hours when an employee has a scheduled shift but does not show up to it without leave reason including deleted shift hours when deletion date is on or after shift date. includes (Excused No show Hours, Unexcused No show Hours, Excused Deleted No show Hours)"
    value_format_name: decimal_1
    group_label: "> Dynamic Measures"
    sql:
        case
          when {% parameter position_parameter %} = 'Rider' THEN ${number_of_no_show_hours_rider_ec_shift}
          when {% parameter position_parameter %} = 'Ops Associate' THEN ${number_of_no_show_hours_ops_associate_ec_shift}
          else null
        end ;;
  }

  measure: number_of_no_show_hours_by_position_incl_ec_shift {
    type: number
    label: "# No Show Hours (with EC Shift & without Refilled Hours)"
    description: "Sum of hours (Incl. EC Shifts & Excl. Refilled Hours) when an employee has a scheduled shift but does not show up to it without leave reason including deleted shift hours when deletion date is on or after shift date. includes (Excused No show Hours, Unexcused No show Hours, Excused Deleted No show Hours)"
    value_format_name: decimal_1
    group_label: "> Dynamic Measures"
    sql:
        case
          when {% parameter position_parameter %} = 'Rider' THEN ${number_of_no_show_hours_rider_incl_ec_shift}
          when {% parameter position_parameter %} = 'Ops Associate' THEN ${number_of_no_show_hours_ops_associate_incl_ec_shift}
          else null
        end ;;
  }

  measure: pct_external_worked_hours_by_position {
    type: number
    label: "% External Punched Hours (with EC Shift)"
    description: "Sum External Punched Hours / Sum Punched Hours"
    value_format_name: percent_1
    group_label: "> Dynamic Measures"
    sql:
        case
          when {% parameter position_parameter %} = 'Rider' THEN ${number_of_worked_hours_external_rider}/nullif(${number_of_worked_hours_rider},0)
          when {% parameter position_parameter %} = 'Shift Lead' THEN ${number_of_worked_hours_external_shift_lead}/nullif(${number_of_worked_hours_shift_lead},0)
          when {% parameter position_parameter %} = 'Ops Associate +' THEN ${number_of_worked_hours_external_ops_associate_plus}/nullif(${number_of_worked_hours_ops_associate_plus},0)
          when {% parameter position_parameter %} = 'Hub Staff' THEN ${number_of_worked_hours_external_hub_staff}/nullif(${number_of_worked_hours_hub_staff},0)
          when {% parameter position_parameter %} = 'Ops Associate' THEN ${number_of_worked_hours_external_ops_associate}/nullif(${number_of_worked_hours_ops_associate},0)
          else null
        end ;;
  }

  measure: pct_no_show_hours_by_position {
    type: number
    label: "% No Show Hours (without EC Shift & Refilled Hours)"
    description: "% shift hours (Excl. EC Shift) when an employee has a scheduled shift but does not show up to it without leave reason including deleted shift hours when deletion date is on or after shift date.
    It includes Excused No Show Hours, Unexcused No Show Hours, Excused Deleted No Show Hours. Formula: # No Show Hours / (# Planned Hours - # Planned EC Hours + # Open NS+ Hours)"
    value_format_name: percent_1
    group_label: "> Dynamic Measures"
    sql:
        case
          when {% parameter position_parameter %} = 'Rider' THEN ${pct_no_show_hours_rider}
          when {% parameter position_parameter %} = 'Shift Lead' THEN ${pct_no_show_hours_shift_lead}
          when {% parameter position_parameter %} = 'Ops Associate +' THEN ${pct_no_show_hours_ops_associate_plus}
          when {% parameter position_parameter %} = 'Hub Staff' THEN ${pct_no_show_hours_hub_staff}
          when {% parameter position_parameter %} = 'Ops Associate' THEN ${pct_no_show_hours_ops_associate}
          else null
        end ;;
  }

  measure: pct_no_show_hours_by_position_ec_shifts {
    type: number
    label: "% EC No Show Hours"
    description: "% shift hours when an EC employee has a scheduled shift but does not show up to it without leave reason including deleted shift hours when deletion date is on or after shift date.
    It includes Excused No Show Hours, Unexcused No Show Hours, Excused Deleted No Show Hours. Formula: # EC No Show Hours / # Planned EC Hours"
    value_format_name: percent_1
    group_label: "> Dynamic Measures"
    sql:
        case
          when {% parameter position_parameter %} = 'Rider' THEN ${pct_no_show_hours_rider_ec_shift}
          when {% parameter position_parameter %} = 'Ops Associate' THEN ${pct_no_show_hours_ops_associate_ec_shift}
          else null
        end ;;
  }

  measure: pct_no_show_hours_by_position_incl_ec_shifts {
    type: number
    label: "% No Show Hours (without Refilled Hours & with EC Shift)"
    description: "% shift hours when an employee (Incl. EC Shifts) has a scheduled shift but does not show up to it without leave reason including deleted shift hours when deletion date is on or after shift date.
    It includes Excused No Show Hours, Unexcused No Show Hours, Excused Deleted No Show Hours. Formula: (# No Show Hours + # EC No Show Hours) / (# Planned Hours + # Open NS+ Hours)"
    value_format_name: percent_1
    group_label: "> Dynamic Measures"
    sql:
        case
          when {% parameter position_parameter %} = 'Rider' THEN ${pct_no_show_hours_rider_incl_ec_shift}
          when {% parameter position_parameter %} = 'Ops Associate' THEN ${pct_no_show_hours_ops_associate_incl_ec_shift}
          else null
        end ;;
  }

  measure: utr_by_position {
    type: number
    label: "UTR"
    description: "# Orders (Excl. Cancellations) (Excl. Click & Collect and External Orders for rider position) / # Punched Hours"
    value_format_name: decimal_2
    group_label: "> Dynamic Measures"
    sql:
        case
          when {% parameter position_parameter %} = 'Rider' THEN ${utr_rider}
          when {% parameter position_parameter %} = 'Ops Associate' THEN ${utr_ops_associate}
          when {% parameter position_parameter %} = 'Hub Staff' THEN ${utr_hub_staff}
          else null
        end ;;
  }

  measure: number_of_overpunched_hours_by_position {
    type: number
    label: "# Overpunched Hours (with EC Shift)"
    description: "When # Worked Hours > # Assigned Hours then # Worked Hours - # Assigned Hours"
    value_format_name: decimal_1
    group_label: "> Dynamic Measures"
    sql:
        case
          when {% parameter position_parameter %} = 'Rider' THEN ${number_of_overpunched_hours_rider}
          when {% parameter position_parameter %} = 'Shift Lead' THEN ${number_of_overpunched_hours_shift_lead}
          when {% parameter position_parameter %} = 'Ops Associate +' THEN ${number_of_overpunched_hours_ops_associate_plus}
          when {% parameter position_parameter %} = 'Hub Staff' THEN ${number_of_overpunched_hours_hub_staff}
          when {% parameter position_parameter %} = 'Ops Associate' THEN ${number_of_overpunched_hours_ops_associate}
          else null
        end ;;
  }

  measure: pct_overpunched_hours_by_position {
    type: number
    label: "% Overpunched Hours (with EC Shift)"
    description: "Share of Overpunched hours over Punched hours."
    value_format_name: percent_2
    group_label: "> Dynamic Measures"
    sql: ${number_of_overpunched_hours_by_position}/${number_of_worked_hours_by_position} ;;
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Parameters     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  parameter: position_parameter {
    type: string
    allowed_value: { value: "Rider" }
    allowed_value: { value: "Shift Lead" }
    allowed_value: { value: "Ops Associate +" }
    allowed_value: { value: "Ops Associate" }
    allowed_value: { value: "Hub Staff" }
  }
}
