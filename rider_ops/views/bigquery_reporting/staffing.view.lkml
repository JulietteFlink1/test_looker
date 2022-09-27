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
  dimension: number_of_scheduled_hours_rider_dimension {
    label: "# Scheduled Rider Hours (Incl. Deleted Excused No Show) - Dimension"
    type: number
    sql: (${TABLE}.number_of_planned_minutes_rider + ${TABLE}.number_of_unassigned_minutes_external_rider+${TABLE}.number_of_unassigned_minutes_internal_rider)/60 ;;
    hidden: yes
  }

  dimension: number_of_no_show_minutes_rider {
    label: "# No Show Rider Minutes"
    type: number
    sql: ${TABLE}.number_of_no_show_minutes_rider ;;
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
  dimension: number_of_leave_minutes_rider {
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

  dimension: number_of_unassigned_minutes_internal_rider {
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

  ###### Pickers

  dimension: number_of_scheduled_hours_picker_dimension {
    label: "# Scheduled Picker Hours (Incl. Deleted Excused No Show) - Dimension"
    type: number
    sql: (${TABLE}.number_of_planned_minutes_picker + ${TABLE}.number_of_unassigned_minutes_external_picker+${TABLE}.number_of_unassigned_minutes_internal_picker)/60 ;;
    hidden: yes
  }


  dimension: number_of_worked_employees_picker {
    label: "# Worked Pickers"
    type: number
    sql: ${TABLE}.number_of_worked_employees_picker ;;
    hidden: yes

  }

  dimension: number_of_excused_no_show_minutes_external_picker {
    label: "# Excused External No Show Picker Minutes"
    type: number
    sql: ${TABLE}.number_of_excused_no_show_minutes_external_picker ;;
    hidden: yes

  }
  dimension: number_of_excused_no_show_minutes_internal_picker {
    label: "# Excused Internal No Show Picker Minutes"
    type: number
    sql: ${TABLE}.number_of_excused_no_show_minutes_internal_picker ;;
    hidden: yes

  }
  dimension: number_of_excused_no_show_minutes_picker {
    label: "# Excused No Show Picker Minutes"
    type: number
    sql: ${TABLE}.number_of_excused_no_show_minutes_picker ;;
    hidden: yes

  }
  dimension: number_of_leave_minutes_external_picker {
    label: "# Leave External Picker Minutes"
    type: number
    sql: ${TABLE}.number_of_leave_minutes_external_picker ;;
    hidden: yes

  }
  dimension: number_of_leave_minutes_internal_picker {
    label: "# Leave Internal Picker Minutes"
    type: number
    sql: ${TABLE}.number_of_leave_minutes_internal_picker ;;
    hidden: yes

  }
  dimension: number_of_leave_minutes_picker {
    label: "# Leave Picker Minutes"
    type: number
    sql: ${TABLE}.number_of_leave_minutes_picker ;;
    hidden: yes

  }

  dimension: number_of_worked_minutes_picker {
    label: "# Worked Picker Minutes"
    type: number
    sql: ${TABLE}.number_of_worked_minutes_picker ;;
    hidden: yes

  }
  dimension: number_of_worked_minutes_internal_picker {
    label: "# Worked Internal Picker Minutes"
    type: number
    sql: ${TABLE}.number_of_worked_minutes_internal_picker ;;
    hidden: yes
  }
  dimension: number_of_worked_minutes_external_picker {
    label: "# Worked External Picker Minutes"
    type: number
    sql: ${TABLE}.number_of_worked_minutes_external_picker ;;
    hidden: yes
  }
  dimension: number_of_worked_employees_internal_picker {
    label: "# Worked Internal Pickers"
    type: number
    sql: ${TABLE}.number_of_worked_employees_internal_picker ;;
    hidden: yes
  }
  dimension: number_of_worked_employees_external_picker {
    label: "# Worked External Pickers"
    type: number
    sql: ${TABLE}.number_of_worked_employees_external_picker ;;
    hidden: yes
  }
  dimension: number_of_unassigned_minutes_internal_picker {
    label: "# Unassigned Internal Picker Minutes"
    type: number
    sql: ${TABLE}.number_of_unassigned_minutes_internal_picker ;;
    hidden: yes

  }
  dimension: number_of_unassigned_minutes_external_picker {
    label: "# Unassigned External Picker Minutes"
    type: number
    sql: ${TABLE}.number_of_unassigned_minutes_external_picker ;;
    hidden: yes

  }
  dimension: number_of_unassigned_employees_internal_picker {
    label: "# Unassigned Internal Pickers"
    type: number
    sql: ${TABLE}.number_of_unassigned_employees_internal_picker ;;
    hidden: yes
  }
  dimension: number_of_unassigned_employees_external_picker {
    label: "# Unassigned External Pickers"
    type: number
    sql: ${TABLE}.number_of_unassigned_employees_external_picker ;;
    hidden: yes
  }
  dimension: number_of_planned_minutes_picker {
    label: "# Planned (Filled) Picker Minutes"
    type: number
    sql: ${TABLE}.number_of_planned_minutes_picker ;;
    hidden: yes
  }
  dimension: number_of_planned_employees_picker {
    label: "# Planned (Filled) Pickers"
    type: number
    sql: ${TABLE}.number_of_planned_employees_picker ;;
    hidden: yes
  }
  dimension: number_of_no_show_minutes_external_picker {
    label: "# No Show External Picker Minutes"
    type: number
    sql: ${TABLE}.number_of_no_show_minutes_external_picker ;;
    hidden: yes
  }
  dimension: number_of_no_show_minutes_internal_picker {
    label: "# No Show Internal Picker Minutes"
    type: number
    sql: ${TABLE}.number_of_no_show_minutes_internal_picker ;;
    hidden: yes
  }
  dimension: number_of_planned_employees_internal_picker {
    label: "# Planned (Filled) Internal Pickers"
    type: number
    sql: ${TABLE}.number_of_planned_employees_internal_picker ;;
    hidden: yes
  }
  dimension: number_of_no_show_minutes_picker {
    label: "# No Show Picker Minutes"
    type: number
    sql: ${TABLE}.number_of_no_show_minutes_picker ;;
    hidden: yes
  }
  dimension: number_of_planned_employees_external_picker {
    label: "# Planned (Filled) External Pickers"
    type: number
    sql: ${TABLE}.number_of_planned_employees_external_picker ;;
    hidden: yes

  }
  dimension: number_of_planned_minutes_internal_picker {
    label: "# Planned (Filled) Internal Picker Minutes"
    type: number
    sql: ${TABLE}.number_of_planned_minutes_internal_picker ;;
    hidden: yes

  }
  ##### WH

  dimension: number_of_leave_minutes_wh {
    label: "# Leave WH Minutes"
    type: number
    sql: ${TABLE}.number_of_leave_minutes_wh ;;
    hidden: yes

  }
  dimension: number_of_leave_minutes_internal_wh {
    label: "# Leave Internal WH Minutes"
    type: number
    sql: ${TABLE}.number_of_leave_minutes_internal_wh ;;
    hidden: yes

  }
  dimension: number_of_leave_minutes_external_wh {
    label: "# Leave External WH Minutes"
    type: number
    sql: ${TABLE}.number_of_leave_minutes_external_wh ;;
    hidden: yes

  }
  dimension: number_of_excused_no_show_minutes_wh {
    label: "# Excused No Show WH Employee Minutes"
    type: number
    sql: ${TABLE}.number_of_excused_no_show_minutes_wh ;;
    hidden: yes

  }
  dimension: number_of_excused_no_show_minutes_internal_wh {
    label: "# Excused No Show Internal WH Employee Minutes"
    type: number
    sql: ${TABLE}.number_of_excused_no_show_minutes_internal_wh ;;
    hidden: yes

  }
  dimension: number_of_excused_no_show_minutes_external_wh {
    label: "# Excused No Show External WH Employee Minutes"
    type: number
    sql: ${TABLE}.number_of_excused_no_show_minutes_external_wh ;;
    hidden: yes

  }
  dimension: number_of_no_show_minutes_external_wh {
    label: "# No Show External WH Employee Minutes"
    type: number
    sql: ${TABLE}.number_of_no_show_minutes_external_wh ;;
    hidden: yes

  }
  dimension: number_of_no_show_minutes_internal_wh {
    label: "# No Show Internal WH Employee Minutes"
    type: number
    sql: ${TABLE}.number_of_no_show_minutes_internal_wh ;;
    hidden: yes

  }
  dimension: number_of_no_show_minutes_wh {
    label: "# No Show WH Employee Minutes"
    type: number
    sql: ${TABLE}.number_of_no_show_minutes_wh ;;
    hidden: yes

  }
  dimension: number_of_planned_employees_external_wh {
    label: "# Planned (Filled) External WH Employees"
    type: number
    sql: ${TABLE}.number_of_planned_employees_external_wh ;;
    hidden: yes

  }
  dimension: number_of_planned_employees_internal_wh {
    label: "# Planned (Filled) Internal WH Employees"
    type: number
    sql: ${TABLE}.number_of_planned_employees_internal_wh ;;
    hidden: yes

  }
  dimension: number_of_planned_employees_wh {
    label: "# Planned (Filled) WH Employees"
    type: number
    sql: ${TABLE}.number_of_planned_employees_wh ;;
    hidden: yes

  }
  dimension: number_of_planned_minutes_external_wh {
    label: "# Planned (Filled) External WH Employee Minutes"
    type: number
    sql: ${TABLE}.number_of_planned_minutes_external_wh ;;
    hidden: yes

  }
  dimension: number_of_planned_minutes_internal_wh {
    label: "# Planned (Filled) Internal WH Employee Minutes"
    type: number
    sql: ${TABLE}.number_of_planned_minutes_internal_wh ;;
    hidden: yes

  }
  dimension: number_of_planned_minutes_wh {
    label: "# Planned (Filled) WH Employee Minutes"
    type: number
    sql: ${TABLE}.number_of_planned_minutes_wh ;;
    hidden: yes

  }
  dimension: number_of_unassigned_employees_external_wh {
    label: "# Unassigned External WH Employees"
    type: number
    sql: ${TABLE}.number_of_unassigned_employees_external_wh ;;
    hidden: yes

  }
  dimension: number_of_unassigned_employees_internal_wh {
    label: "# Unassigned Internal WH Employees"
    type: number
    sql: ${TABLE}.number_of_unassigned_employees_internal_wh ;;
    hidden: yes

  }
  dimension: number_of_unassigned_minutes_external_wh {
    label: "# Unassigned External WH Employee Minutes"
    type: number
    sql: ${TABLE}.number_of_unassigned_minutes_external_wh ;;
    hidden: yes

  }
  dimension: number_of_unassigned_minutes_internal_wh {
    label: "# Unassigned Internal WH Employee Minutes"
    type: number
    sql: ${TABLE}.number_of_unassigned_minutes_internal_wh ;;
    hidden: yes

  }
  dimension: number_of_worked_employees_external_wh {
    label: "# Worked External WH Employees"
    type: number
    sql: ${TABLE}.number_of_worked_employees_external_wh ;;
    hidden: yes

  }
  dimension: number_of_worked_minutes_external_wh {
    label: "# Worked External WH Employee Minutes"
    type: number
    sql: ${TABLE}.number_of_worked_minutes_external_wh ;;
    hidden: yes

  }
  dimension: number_of_worked_employees_internal_wh {
    label: "# Worked Internal WH Employees"
    type: number
    sql: ${TABLE}.number_of_worked_employees_internal_wh ;;
    hidden: yes

  }
  dimension: number_of_worked_employees_wh {
    label: "# Worked WH Employees"
    type: number
    sql: ${TABLE}.number_of_worked_employees_wh ;;
    hidden: yes

  }
  dimension: number_of_worked_minutes_internal_wh {
    label: "# Worked Internal WH Employee Minutes"
    type: number
    sql: ${TABLE}.number_of_worked_minutes_internal_wh ;;
    hidden: yes

  }
  dimension: number_of_worked_minutes_wh {
    label: "# Worked WH Employee Minutes"
    type: number
    sql: ${TABLE}.number_of_worked_minutes_wh ;;
    hidden: yes

  }

  ##### CC
  dimension: number_of_excused_no_show_minutes_external_cc_agent {
    label: "# Excused No Show External CC Agent Minutes"
    type: number
    sql: ${TABLE}.number_of_excused_no_show_minutes_external_cc_agent ;;
    hidden: yes

  }
  dimension: number_of_excused_no_show_minutes_cc_agent {
    label: "# Excused No Show CC Agent Minutes"
    type: number
    sql: ${TABLE}.number_of_excused_no_show_minutes_cc_agent ;;
    hidden: yes

  }
  dimension: number_of_excused_no_show_minutes_internal_cc_agent {
    label: "# Excused No Show Internal CC Agent Minutes"
    type: number
    sql: ${TABLE}.number_of_excused_no_show_minutes_internal_cc_agent ;;
    hidden: yes

  }
  dimension: number_of_no_show_minutes_cc_agent {
    label: "# No Show CC Agent Minutes"
    type: number
    sql: ${TABLE}.number_of_no_show_minutes_cc_agent ;;
    hidden: yes

  }
  dimension: number_of_no_show_minutes_external_cc_agent {
    label: "# No Show External CC Agent Minutes"
    type: number
    sql: ${TABLE}.number_of_no_show_minutes_external_cc_agent ;;
    hidden: yes

  }
  dimension: number_of_no_show_minutes_internal_cc_agent {
    label: "# No Show Internal CC Agent Minutes"
    type: number
    sql: ${TABLE}.number_of_no_show_minutes_internal_cc_agent ;;
    hidden: yes

  }
  dimension: number_of_planned_employees_cc_agent {
    label: "# Planned CC Agents"
    type: number
    sql: ${TABLE}.number_of_planned_employees_cc_agent ;;
    hidden: yes

  }
  dimension: number_of_planned_employees_external_cc_agent {
    label: "# Planned External CC Agents"
    type: number
    sql: ${TABLE}.number_of_planned_employees_external_cc_agent ;;
    hidden: yes

  }
  dimension: number_of_planned_employees_internal_cc_agent {
    label: "# Planned Internal CC Agents"
    type: number
    sql: ${TABLE}.number_of_planned_employees_internal_cc_agent ;;
    hidden: yes

  }
  dimension: number_of_planned_minutes_cc_agent {
    label: "# Planned CC Agent Minutes"
    type: number
    sql: ${TABLE}.number_of_planned_minutes_cc_agent ;;
    hidden: yes

  }
  dimension: number_of_planned_minutes_external_cc_agent {
    label: "# Planned External CC Agent Minutes"
    type: number
    sql: ${TABLE}.number_of_planned_minutes_external_cc_agent ;;
    hidden: yes

  }
  dimension: number_of_planned_minutes_internal_cc_agent {
    label: "# Planned Internal CC Agent Minutes"
    type: number
    sql: ${TABLE}.number_of_planned_minutes_internal_cc_agent ;;
    hidden: yes

  }
  dimension: number_of_unassigned_employees_external_cc_agent {
    label: "# Unassigned External CC Agents"
    type: number
    sql: ${TABLE}.number_of_unassigned_employees_external_cc_agent ;;
    hidden: yes

  }
  dimension: number_of_unassigned_employees_internal_cc_agent {
    label: "# Unassigned Internal CC Agents"
    type: number
    sql: ${TABLE}.number_of_unassigned_employees_internal_cc_agent ;;
    hidden: yes

  }
  dimension: number_of_unassigned_minutes_external_cc_agent {
    label: "# Unassigned External CC Agent Minutes"
    type: number
    sql: ${TABLE}.number_of_unassigned_minutes_external_cc_agent ;;
    hidden: yes

  }
  dimension: number_of_unassigned_minutes_internal_cc_agent {
    label: "# Unassigned Internal CC Agent Minutes"
    type: number
    sql: ${TABLE}.number_of_unassigned_minutes_internal_cc_agent ;;
    hidden: yes

  }
  dimension: number_of_worked_employees_cc_agent {
    label: "# Worked CC Agents"
    type: number
    sql: ${TABLE}.number_of_worked_employees_cc_agent ;;
    hidden: yes

  }
  dimension: number_of_worked_employees_external_cc_agent {
    label: "# Worked External CC Agents"
    type: number
    sql: ${TABLE}.number_of_worked_employees_external_cc_agent ;;
    hidden: yes

  }
  dimension: number_of_worked_employees_internal_cc_agent {
    label: "# Worked Internal CC Agents"
    type: number
    sql: ${TABLE}.number_of_worked_employees_internal_cc_agent ;;
    hidden: yes

  }

  dimension: number_of_worked_minutes_external_cc_agent {
    label: "# Worked External CC Agent Minutes"
    type: number
    sql: ${TABLE}.number_of_worked_minutes_external_cc_agent ;;
    hidden: yes

  }
  dimension: number_of_worked_minutes_internal_cc_agent {
    label: "# Worked Internal CC Agent Minutes"
    type: number
    sql: ${TABLE}.number_of_worked_minutes_internal_cc_agent ;;
    hidden: yes

  }
  dimension: number_of_worked_minutes_cc_agent {
    label: "# Worked CC Agent Minutes"
    type: number
    sql: ${TABLE}.number_of_worked_minutes_cc_agent ;;
    hidden: yes

  }
  ##### Co Ops

  dimension: number_of_excused_no_show_minutes_internal_co_ops {
    label: "# Excused No Show Internal Co Ops Employee Minutes"
    type: number
    sql: ${TABLE}.number_of_excused_no_show_minutes_internal_co_ops ;;
    hidden: yes

  }

  dimension: number_of_excused_no_show_minutes_co_ops {
    label: "# Excused No Show Co Ops Employee Minutes"
    type: number
    sql: ${TABLE}.number_of_excused_no_show_minutes_co_ops ;;
    hidden: yes

  }

  dimension: number_of_excused_no_show_minutes_external_co_ops {
    label: "# Excused No Show External Co Ops Employee Minutes"
    type: number
    sql: ${TABLE}.number_of_excused_no_show_minutes_external_co_ops ;;
    hidden: yes

  }

  dimension: number_of_unassigned_employees_external_co_ops {
    type: number
    sql: ${TABLE}.number_of_unassigned_employees_external_co_ops ;;
    hidden: yes

  }
  dimension: number_of_unassigned_minutes_external_co_ops {
    type: number
    sql: ${TABLE}.number_of_unassigned_minutes_external_co_ops ;;
    hidden: yes

  }
  dimension: number_of_worked_minutes_internal_co_ops {
    label: "# Worked Internal Co Ops Minutes"
    type: number
    sql: ${TABLE}.number_of_worked_minutes_internal_co_ops ;;
    hidden: yes

  }
  dimension: number_of_worked_minutes_external_co_ops {
    label: "# Worked External Co Ops Minutes"
    type: number
    sql: ${TABLE}.number_of_worked_minutes_external_co_ops ;;
    hidden: yes

  }
  dimension: number_of_worked_employees_co_ops {
    label: "# Worked Co Ops Employees"
    type: number
    sql: ${TABLE}.number_of_worked_employees_co_ops ;;
    hidden: yes

  }
  dimension: number_of_worked_employees_external_co_ops {
    label: "# Worked External Co Ops Employees"
    type: number
    sql: ${TABLE}.number_of_worked_employees_external_co_ops ;;
    hidden: yes

  }
  dimension: number_of_unassigned_minutes_internal_co_ops {
    label: "# Unassigned Internal Co Ops Employee Minutes"
    type: number
    sql: ${TABLE}.number_of_unassigned_minutes_internal_co_ops ;;
    hidden: yes

  }
  dimension: number_of_planned_minutes_internal_co_ops {
    label: "# Planned Internal Co Ops Employee Minutes"
    type: number
    sql: ${TABLE}.number_of_planned_minutes_internal_co_ops ;;
    hidden: yes

  }
  dimension: number_of_no_show_minutes_co_ops {
    label: "# No Show Co Ops Employee Minutes"
    type: number
    sql: ${TABLE}.number_of_no_show_minutes_co_ops ;;
    hidden: yes

  }
  dimension: number_of_no_show_minutes_internal_co_ops {
    label: "# No Show Internal Co Ops Employee Minutes"
    type: number
    sql: ${TABLE}.number_of_no_show_minutes_internal_co_ops ;;
    hidden: yes

  }

  dimension: number_of_no_show_minutes_external_co_ops {
    label: "# No Show External Co Ops Employee Minutes"
    type: number
    sql: ${TABLE}.number_of_no_show_minutes_external_co_ops ;;
    hidden: yes

  }
  dimension: number_of_planned_employees_co_ops {
    label: "# Planned Co Ops Employees"
    type: number
    sql: ${TABLE}.number_of_planned_employees_co_ops ;;
    hidden: yes

  }
  dimension: number_of_planned_employees_external_co_ops {
    label: "# Planned External Co Ops Employees"
    type: number
    sql: ${TABLE}.number_of_planned_employees_external_co_ops ;;
    hidden: yes

  }
  dimension: number_of_planned_employees_internal_co_ops {
    label: "# Planned Internal Co Ops Employees"
    type: number
    sql: ${TABLE}.number_of_planned_employees_internal_co_ops ;;
    hidden: yes

  }
  dimension: number_of_planned_minutes_co_ops {
    label: "# Planned Co Ops Employee Minutes"
    type: number
    sql: ${TABLE}.number_of_planned_minutes_co_ops ;;
    hidden: yes

  }
  dimension: number_of_planned_minutes_external_co_ops {
    label: "# Planned External Co Ops Employee Minutes"
    type: number
    sql: ${TABLE}.number_of_planned_minutes_external_co_ops ;;
    hidden: yes

  }
  dimension: number_of_unassigned_employees_internal_co_ops {
    label: "# Unassigned Internal Co Ops Employees"
    type: number
    sql: ${TABLE}.number_of_unassigned_employees_internal_co_ops ;;
    hidden: yes

  }
  dimension: number_of_worked_minutes_external_rider_captain {
    label: "# Worked External Rider Captain Minutes"
    type: number
    sql: ${TABLE}.number_of_worked_minutes_external_rider_captain ;;
    hidden: yes

  }
  dimension: number_of_worked_employees_internal_co_ops {
    label: "# Worked Internal Co Ops emPLOYEES"
    type: number
    sql: ${TABLE}.number_of_worked_employees_internal_co_ops ;;
    hidden: yes

  }
  dimension: number_of_worked_minutes_co_ops {
    label: "# Worked Co Ops Employee Minutes"
    type: number
    sql: ${TABLE}.number_of_worked_minutes_co_ops ;;
    hidden: yes

  }

  ###### Rider Captain

  dimension: number_of_planned_minutes_internal_rider_captain {
    label: "# Planned Internal Rider Captain Minutes"
    type: number
    sql: ${TABLE}.number_of_planned_minutes_internal_rider_captain ;;
    hidden: yes

  }
  dimension: number_of_planned_minutes_external_rider_captain {
    label: "# Planned External Rider Captain minutes"
    type: number
    sql: ${TABLE}.number_of_planned_minutes_external_rider_captain ;;
    hidden: yes

  }
  dimension: number_of_planned_employees_internal_rider_captain {
    label: "# Planned Internal Rider Captains"
    type: number
    sql: ${TABLE}.number_of_planned_employees_internal_rider_captain ;;
    hidden: yes

  }
  dimension: number_of_planned_employees_external_rider_captain {
    label: "# Planned External Rider Captains"
    type: number
    sql: ${TABLE}.number_of_planned_employees_external_rider_captain ;;
    hidden: yes

  }
  dimension: number_of_no_show_minutes_rider_captain {
    label: "# No Show Rider Captain Minutes"
    type: number
    sql: ${TABLE}.number_of_no_show_minutes_rider_captain ;;
    hidden: yes

  }
  dimension: number_of_no_show_minutes_internal_rider_captain {
    label: "# No Show Internal Rider Captain Minutes"
    type: number
    sql: ${TABLE}.number_of_no_show_minutes_internal_rider_captain ;;
    hidden: yes

  }
  dimension: number_of_no_show_minutes_external_rider_captain {
    label: "# No Show External Rider Captain Minutes"
    type: number
    sql: ${TABLE}.number_of_no_show_minutes_external_rider_captain ;;
    hidden: yes

  }

  dimension: number_of_leave_minutes_rider_captain {
    label: "# Leave Rider Captain Minutes"
    type: number
    sql: ${TABLE}.number_of_leave_minutes_rider_captain ;;
    hidden: yes

  }
  dimension: number_of_leave_minutes_internal_rider_captain {
    label: "# Leave Internal Rider Captain Minutes"
    type: number
    sql: ${TABLE}.number_of_leave_minutes_internal_rider_captain ;;
    hidden: yes

  }
  dimension: number_of_leave_minutes_external_rider_captain {
    label: "# Leave External Rider Captain Minutes"
    type: number
    sql: ${TABLE}.number_of_leave_minutes_external_rider_captain ;;
    hidden: yes

  }
  dimension: number_of_excused_no_show_minutes_rider_captain {
    label: "# Excused No Show Rider Captain minutes"
    type: number
    sql: ${TABLE}.number_of_excused_no_show_minutes_rider_captain ;;
    hidden: yes

  }
  dimension: number_of_unexcused_no_show_minutes_rider {
    label: "# Unexcused No Show Rider minutes"
    type: number
    sql: ${TABLE}.number_of_unexcused_no_show_minutes_rider ;;
    hidden: yes

  }
  dimension: number_of_unexcused_no_show_minutes_rider_captain {
    label: "# Unexcused No Show Rider Captain minutes"
    type: number
    sql: ${TABLE}.number_of_unexcused_no_show_minutes_rider_captain ;;
    hidden: yes

  }
  dimension: number_of_unexcused_no_show_minutes_picker {
    label: "# Unexcused No Show Picker minutes"
    type: number
    sql: ${TABLE}.number_of_unexcused_no_show_minutes_picker ;;
    hidden: yes

  }
  dimension: number_of_unexcused_no_show_minutes_wh {
    label: "# Unexcused No Show WH minutes"
    type: number
    sql: ${TABLE}.number_of_unexcused_no_show_minutes_wh ;;
    hidden: yes

  }
  dimension: number_of_unexcused_no_show_minutes_shift_lead {
    label: "# Unexcused No Show Shift Lead minutes"
    type: number
    sql: ${TABLE}.number_of_unexcused_no_show_minutes_shift_lead ;;
    hidden: yes

  }
  dimension: number_of_worked_minutes_internal_rider {
    label: "# Worked Internal Rider Minutes"
    type: number
    sql: ${TABLE}.number_of_worked_minutes_internal_rider ;;
    hidden: yes

  }

  dimension: number_of_worked_minutes_internal_rider_captain {
    label: "# Worked Internal Rider Captain Minutes"
    type: number
    sql: ${TABLE}.number_of_worked_minutes_internal_rider_captain ;;
    hidden: yes

  }
  dimension: number_of_worked_employees_rider_captain {
    label: "# Worked Rider Captains"
    type: number
    sql: ${TABLE}.number_of_worked_employees_rider_captain ;;
    hidden: yes

  }
  dimension: number_of_planned_employees_rider_captain {
    label: "# Planned Rider Captains"
    type: number
    sql: ${TABLE}.number_of_planned_employees_rider_captain ;;
    hidden: yes

  }
  dimension: number_of_planned_minutes_rider_captain {
    label: "# Planned Rider Captain Minutes"
    type: number
    sql: ${TABLE}.number_of_planned_minutes_rider_captain ;;
    hidden: yes

  }
  dimension: number_of_unassigned_employees_external_rider_captain {
    label: "# Unassigned External Rider Captains"
    type: number
    sql: ${TABLE}.number_of_unassigned_employees_external_rider_captain ;;
    hidden: yes

  }
  dimension: number_of_unassigned_employees_internal_rider_captain {
    label: "# Unassigned Internal Rider Captains"
    type: number
    sql: ${TABLE}.number_of_unassigned_employees_internal_rider_captain ;;
    hidden: yes

  }
  dimension: number_of_unassigned_minutes_external_rider_captain {
    label: "# Unassigned External Rider Captain Minutes"
    type: number
    sql: ${TABLE}.number_of_unassigned_minutes_external_rider_captain ;;
    hidden: yes

  }
  dimension: number_of_unassigned_minutes_internal_rider_captain {
    label: "# Unassigned Internal Rider Captain Minutes"
    type: number
    sql: ${TABLE}.number_of_unassigned_minutes_internal_rider_captain ;;
    hidden: yes

  }
  dimension: number_of_planned_minutes_external_picker {
    label: "# Planned External Rider Captain Minutes"
    type: number
    sql: ${TABLE}.number_of_planned_minutes_external_picker ;;
    hidden: yes

  }
  dimension: number_of_worked_employees_external_rider_captain {
    label: "# Worked External Rider Captains"
    type: number
    sql: ${TABLE}.number_of_worked_employees_external_rider_captain ;;
    hidden: yes

  }
  dimension: number_of_worked_employees_internal_rider_captain {
    label: "# Worked Internal Rider Captains"
    type: number
    sql: ${TABLE}.number_of_worked_employees_internal_rider_captain ;;
    hidden: yes

  }
  dimension: number_of_worked_minutes_rider_captain {
    label: "# Worked Rider Captain Minutes"
    type: number
    sql: ${TABLE}.number_of_worked_minutes_rider_captain ;;
    hidden: yes

  }
  ##### Shift Lead

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
  dimension: number_of_deleted_excused_no_show_minutes_rider {
    label: "# Deleted Excused Rider No Show Hours (included in No show metric)"
    type: number
    sql: ${TABLE}.number_of_deleted_excused_no_show_minutes_rider ;;
    hidden: yes
  }
  dimension: number_of_deleted_excused_no_show_minutes_picker {
    label: "# Deleted Excused Picker No Show Hours (included in No show metric)"
    type: number
    sql: ${TABLE}.number_of_deleted_excused_no_show_minutes_picker ;;
    hidden: yes
  }
  dimension: number_of_deleted_excused_no_show_minutes_wh {
    label: "# Deleted Excused WH No Show Hours (included in No show metric)"
    type: number
    sql: ${TABLE}.number_of_deleted_excused_no_show_minutes_wh ;;
    hidden: yes
  }
  dimension: number_of_deleted_excused_no_show_minutes_shift_lead {
    label: "# Deleted Excused Shift Lead No Show Hours (included in No show metric)"
    type: number
    sql: ${TABLE}.number_of_deleted_excused_no_show_minutes_shift_lead ;;
    hidden: yes
  }
  dimension: number_of_deleted_excused_no_show_minutes_rider_captain {
    label: "# Deleted Excused Rider Captain No Show Hours (included in No show metric)"
    type: number
    sql: ${TABLE}.number_of_deleted_excused_no_show_minutes_rider_captain;;
    hidden: yes
  }
  dimension: number_of_deleted_unexcused_no_show_minutes_rider {
    label: "# Deleted Unexcused Rider No Show Hours (included in No show metric)"
    type: number
    sql: ${TABLE}.number_of_deleted_unexcused_no_show_minutes_rider ;;
    hidden: yes
  }
  dimension: number_of_deleted_unexcused_no_show_minutes_picker {
    label: "# Deleted Unexcused Picker No Show Hours (included in No show metric)"
    type: number
    sql: ${TABLE}.number_of_deleted_unexcused_no_show_minutes_picker ;;
    hidden: yes
  }
  dimension: number_of_deleted_unexcused_no_show_minutes_wh {
    label: "# Deleted Unexcused WH No Show Hours (included in No show metric)"
    type: number
    sql: ${TABLE}.number_of_deleted_unexcused_no_show_minutes_wh ;;
    hidden: yes
  }
  dimension: number_of_deleted_unexcused_no_show_minutes_shift_lead {
    label: "# Deleted Unexcused Shift Lead No Show Hours (included in No show metric)"
    type: number
    sql: ${TABLE}.number_of_deleted_unexcused_no_show_minutes_shift_lead ;;
    hidden: yes
  }
  dimension: number_of_deleted_unexcused_no_show_minutes_rider_captain {
    label: "# Deleted Unexcused Rider Captain No Show Hours (included in No show metric)"
    type: number
    sql: ${TABLE}.number_of_deleted_unexcused_no_show_minutes_rider_captain;;
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

  measure: count {
    type: count
    drill_fields: []
    hidden: yes
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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

  # =========  Hours   =========

  ##### All
  measure: number_of_worked_hours_rider {
    group_label: "> Rider Measures"
    label: "# Punched Rider Hours"
    type: sum
    sql: ${number_of_worked_minutes_rider}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_worked_hours_picker {
    group_label: "> Picker Measures"
    label: "# Punched Picker Hours"
    type: sum
    sql: ${number_of_worked_minutes_picker}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_worked_hours_shift_lead {
    group_label: "> Shift Lead Measures"
    label: "# Punched Shift Lead Hours"
    type: sum
    sql: ${number_of_worked_minutes_shift_lead}/60;;
    value_format_name: decimal_1
  }
  measure: number_of_worked_hours_rider_captain {
    group_label: "> Rider Captain Measures"
    label: "# Punched Rider Captain Hours"
    type: sum
    sql: ${number_of_worked_minutes_rider_captain}/60;;
    value_format_name: decimal_1
  }
  measure: number_of_worked_hours_co_ops {
    group_label: "> Co Ops Measures"
    label: "# Punched Co Ops Hours"
    type: sum
    sql: ${number_of_worked_minutes_co_ops}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_worked_hours_wh {
    group_label: "> WH Measures"
    label: "# Punched WH Hours"
    type: sum
    sql: ${number_of_worked_minutes_wh}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_worked_hours_ops_associate {
    alias: [number_of_worked_hours_ops_staff]
    group_label: "> Ops Associate Measures"
    label: "# Punched Ops Associate Hours"
    type: number
    sql: ${number_of_worked_minutes_ops_associate}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_worked_hours_cc_agent {
    group_label: "> CC Agent Measures"
    label: "# Punched CC Agent Hours"
    type: sum
    sql: ${number_of_worked_minutes_wh}/60;;
    value_format_name: decimal_1
  }

# since shift lead do not consistently punch in/out then we need to consider worked hours = planned hours
  measure: number_of_worked_hours_hub_staff {
    group_label: "> Hub Staff Measures"
    label: "# Punched Hub Staff Hours"
    type: number
    sql: ${number_of_worked_hours_ops_associate}+${number_of_planned_hours_shift_lead};;
    value_format_name: decimal_1
  }

  ##### External
  measure: number_of_worked_hours_external_rider {
    group_label: "> Rider Measures"
    label: "# Punched External Rider Hours"
    type: sum
    sql: ${number_of_worked_minutes_external_rider}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_worked_hours_external_picker {
    group_label: "> Picker Measures"
    label: "# Punched External Picker Hours"
    type: sum
    sql: ${number_of_worked_minutes_external_picker}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_worked_hours_external_shift_lead {
    group_label: "> Shift Lead Measures"
    label: "# Punched External Shift Lead Hours"
    type: sum
    sql: ${number_of_worked_minutes_external_shift_lead}/60;;
    value_format_name: decimal_1
  }
  measure: number_of_worked_hours_external_rider_captain {
    group_label: "> Rider Captain Measures"
    label: "# Punched External Rider Captain Hours"
    type: sum
    sql: ${number_of_worked_minutes_external_rider_captain}/60;;
    value_format_name: decimal_1
  }
  measure: number_of_worked_hours_external_co_ops {
    group_label: "> Co Ops Measures"
    label: "# Punched External Co Ops Hours"
    type: sum
    sql: ${number_of_worked_minutes_external_co_ops}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_worked_hours_external_wh {
    group_label: "> WH Measures"
    label: "# Punched External WH Hours"
    type: sum
    sql: ${number_of_worked_minutes_external_wh}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_worked_hours_external_cc_agent {
    group_label: "> CC Agent Measures"
    label: "# Punched External CC Agent Hours"
    type: sum
    sql: ${number_of_worked_minutes_external_wh}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_worked_hours_external_hub_staff {
    group_label: "> Hub Staff Measures"
    label: "# Punched External Hub Staff Hours"
    description: "Sum of Punched External Ops Associate(Picker, WH, Ops Associate and Rider Captain) hours and Planned External Shift Lead hours"
    type: number
    sql: (${number_of_worked_minutes_external_ops_associate}+sum(${number_of_planned_minutes_external_shift_lead}))/60;;
    value_format_name: decimal_1
  }

  measure: number_of_worked_hours_external_ops_associate {
    alias: [number_of_worked_hours_external_ops_staff]
    group_label: "> Ops Associate Measures"
    label: "# Punched External Ops Associate Hours"
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

  measure: sum_of_worked_employees_picker {
    group_label: "> Picker Measures"
    label: "# Punched Pickers"
    type: sum
    sql: ${number_of_worked_employees_picker};;
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
  measure: sum_of_worked_employees_rider_captain {
    group_label: "> Rider Captain Measures"
    label: "# Punched Rider Captains"
    type: sum
    sql: ${number_of_worked_employees_rider_captain};;
    value_format_name: decimal_1
    hidden: yes
  }
  measure: sum_of_worked_employees_co_ops {
    group_label: "> Co Ops Measures"
    label: "# Punched Co Ops Employees"
    type: sum
    sql: ${number_of_worked_employees_co_ops};;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: sum_of_worked_employees_wh {
    group_label: "> WH Measures"
    label: "# Punched WH Employees"
    type: sum
    sql: ${number_of_worked_employees_wh};;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: sum_of_worked_employees_cc_agent {
    group_label: "> CC Agent Measures"
    label: "# Punched CC Agents"
    type: sum
    sql: ${number_of_worked_employees_cc_agent};;
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

  measure: sum_of_worked_employees_external_pickers {
    group_label: "> Picker Measures"
    label: "# Punched External Pickers"
    type: sum
    sql: ${number_of_worked_employees_external_picker};;
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
  measure: sum_of_worked_employees_external_rider_captain {
    group_label: "> Rider Captain Measures"
    label: "# Punched External Rider Captains"
    type: sum
    sql: ${number_of_worked_employees_external_rider_captain};;
    value_format_name: decimal_1
    hidden: yes
  }
  measure: sum_of_worked_employees_external_co_ops {
    group_label: "> Co Ops Measures"
    label: "# Punched External Co Ops Employees"
    type: sum
    sql: ${number_of_worked_employees_external_co_ops};;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: sum_of_worked_employees_external_wh {
    group_label: "> WH Measures"
    label: "# Punched External WH Employees"
    type: sum
    sql: ${number_of_worked_employees_external_wh};;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: sum_of_worked_employees_external_cc_agent {
    group_label: "> CC Agent Measures"
    label: "# Punched External CC Agents"
    type: sum
    sql: ${number_of_worked_employees_external_cc_agent};;
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

  measure: sum_of_worked_employees_internal_pickers {
    group_label: "> Picker Measures"
    label: "# Punched Internal Pickers"
    type: sum
    sql: ${number_of_worked_employees_internal_picker};;
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
  measure: sum_of_worked_employees_internal_rider_captain {
    group_label: "> Rider Captain Measures"
    label: "# Punched Internal Rider Captains"
    type: sum
    sql: ${number_of_worked_employees_internal_rider_captain};;
    value_format_name: decimal_1
    hidden: yes
  }
  measure: sum_of_worked_employees_internal_co_ops {
    group_label: "> Co Ops Measures"
    label: "# Punched Internal Co Ops Employees"
    type: sum
    sql: ${number_of_worked_employees_internal_co_ops};;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: sum_of_worked_employees_internal_wh {
    group_label: "> WH Measures"
    label: "# Punched Internal WH Employees"
    type: sum
    sql: ${number_of_worked_employees_internal_wh};;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: sum_of_worked_employees_internal_cc_agent {
    group_label: "> CC Agent Measures"
    label: "# Punched Internal CC Agents"
    type: sum
    sql: ${number_of_worked_employees_internal_cc_agent};;
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

  measure: sum_of_unassigned_employees_pickers {
    group_label: "> Picker Measures"
    label: "# Unassigned Pickers"
    type: sum
    sql: ${number_of_unassigned_employees_external_picker}+${number_of_unassigned_employees_internal_picker};;
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
  measure: sum_of_unassigned_employees_rider_captain {
    group_label: "> Rider Captain Measures"
    label: "# Unassigned Rider Captains"
    type: sum
    sql: ${number_of_unassigned_employees_external_rider_captain}+${number_of_unassigned_employees_internal_rider_captain};;
    value_format_name: decimal_1
    hidden: yes
  }
  measure: sum_of_unassigned_employees_co_ops {
    group_label: "> Co Ops Measures"
    label: "# Unassigned Co Ops Employees"
    type: sum
    sql: ${number_of_unassigned_employees_external_co_ops}+${number_of_unassigned_employees_internal_co_ops};;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: sum_of_unassigned_employees_wh {
    group_label: "> WH Measures"
    label: "# Unassigned WH Employees"
    type: sum
    sql: ${number_of_unassigned_employees_external_wh}+${number_of_unassigned_employees_internal_wh};;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: sum_of_unassigned_employees_cc_agent {
    group_label: "> CC Agent Measures"
    label: "# Unassigned CC Agents"
    type: sum
    sql: ${number_of_unassigned_employees_external_cc_agent}+${number_of_unassigned_employees_internal_cc_agent};;
    value_format_name: decimal_1
    hidden: yes
  }

  # =========  Open Hours   =========

  measure: number_of_unassigned_minutes_internal_ops_associate {
    group_label: "> Ops Associate Measures"
    label: "# Unassigned (Open) Internal Ops Associate Minutes"
    type: sum
    sql: ${TABLE}.number_of_unassigned_minutes_internal_ops_associate;;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: number_of_unassigned_minutes_external_ops_associate {
    group_label: "> Ops Associate Measures"
    label: "# Unassigned External Ops Associate Minutes"
    type: sum
    sql: ${TABLE}.number_of_unassigned_minutes_external_ops_associate;;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: number_of_unassigned_hours_ops_associate {
    alias: [number_of_unassigned_hours_ops_staff]
    group_label: "> Ops Associate Measures"
    label: "# Open Ops Associate Hours"
    type: number
    sql: (${number_of_unassigned_minutes_internal_ops_associate}+${number_of_unassigned_minutes_external_ops_associate})/60;;
    value_format_name: decimal_1
  }

  measure: number_of_unassigned_hours_rider {
    group_label: "> Rider Measures"
    label: "# Open Rider Hours"
    type: sum
    sql: (${number_of_unassigned_minutes_external_rider}+${number_of_unassigned_minutes_internal_rider})/60;;
    value_format_name: decimal_1
  }

  measure: number_of_unassigned_hours_picker {
    group_label: "> Picker Measures"
    label: "# Open Picker Hours"
    type: sum
    sql: (${number_of_unassigned_minutes_external_picker}+${number_of_unassigned_minutes_internal_picker})/60;;
    value_format_name: decimal_1
  }

  measure: number_of_unassigned_hours_shift_lead {
    group_label: "> Shift Lead Measures"
    label: "# Open Shift Lead Hours"
    type: sum
    sql: (${number_of_unassigned_minutes_external_shift_lead}+${number_of_unassigned_minutes_internal_shift_lead})/60;;
    value_format_name: decimal_1
  }
  measure: number_of_unassigned_hours_rider_captain {
    group_label: "> Rider Captain Measures"
    label: "# Open Rider Captain Hours"
    type: sum
    sql: (${number_of_unassigned_minutes_external_rider_captain}+${number_of_unassigned_minutes_internal_rider_captain})/60;;
    value_format_name: decimal_1
  }
  measure: number_of_unassigned_hours_co_ops {
    group_label: "> Co Ops Measures"
    label: "# Open Co Ops Employee Hours"
    type: sum
    sql: (${number_of_unassigned_minutes_external_co_ops}+${number_of_unassigned_minutes_internal_co_ops})/60;;
    value_format_name: decimal_1
  }

  measure: number_of_unassigned_hours_wh {
    group_label: "> WH Measures"
    label: "# Open WH Employee Hours"
    type: sum
    sql: (${number_of_unassigned_minutes_external_wh}+${number_of_unassigned_minutes_internal_wh})/60;;
    value_format_name: decimal_1
  }

  measure: number_of_unassigned_hours_cc_agent {
    group_label: "> CC Agent Measures"
    label: "# Open CC Agent Hours"
    type: sum
    sql: (${number_of_unassigned_minutes_external_cc_agent}+${number_of_unassigned_minutes_internal_cc_agent})/60;;
    value_format_name: decimal_1
  }
  measure: number_of_unassigned_hours_hub_staff {
    group_label: "> Hub Staff Measures"
    label: "# Open Hub Staff Hours"
    type: number
    sql: ${number_of_unassigned_hours_ops_associate}+${number_of_unassigned_hours_shift_lead};;
    value_format_name: decimal_1
  }

  ##### Planned (filled)

  measure: number_of_planned_minutes_ops_associate {
    group_label: "> Ops Associate Measures"
    label: "# Planned (Filled) Ops Associate Minutes"
    type: sum
    sql: ${TABLE}.number_of_planned_minutes_ops_associate ;;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: number_of_planned_hours_ops_associate {
    alias: [number_of_planned_hours_ops_staff]
    group_label: "> Ops Associate Measures"
    label: "# Planned Ops Associate Hours"
    type: number
    sql: ${number_of_planned_minutes_ops_associate}/60 ;;
    value_format_name: decimal_1
  }

  measure: number_of_planned_minutes_internal_ops_associate {
    group_label: "> Ops Associate Measures"
    label: "# Planned (Filled) Internal Ops Associate Minutes"
    type: sum
    sql: ${TABLE}.number_of_planned_minutes_internal_ops_associate ;;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: number_of_planned_minutes_external_ops_associate {
    group_label: "> Ops Associate Measures"
    label: "# Planned (Filled) External Ops Associate Minutes"
    type: sum
    sql: ${TABLE}.number_of_planned_minutes_external_ops_associate ;;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: number_of_planned_hours_rider {
    group_label: "> Rider Measures"
    label: "# Planned Rider Hours"
    type: sum
    sql: ${number_of_planned_minutes_rider}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_planned_hours_picker {
    group_label: "> Picker Measures"
    label: "# Planned Picker Hours"
    type: sum
    sql: ${number_of_planned_minutes_picker}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_planned_hours_shift_lead {
    group_label: "> Shift Lead Measures"
    label: "# Planned Shift Lead Hours"
    type: sum
    sql: ${number_of_planned_minutes_shift_lead}/60;;
    value_format_name: decimal_1
  }
  measure: number_of_planned_hours_rider_captain {
    group_label: "> Rider Captain Measures"
    label: "# Planned Rider Captain Hours"
    type: sum
    sql: ${number_of_planned_minutes_rider_captain}/60;;
    value_format_name: decimal_1
  }
  measure: number_of_planned_hours_co_ops {
    group_label: "> Co Ops Measures"
    label: "# Planned Co Ops Hours"
    type: sum
    sql: ${number_of_planned_minutes_co_ops}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_planned_hours_wh {
    group_label: "> WH Measures"
    label: "# Planned WH Hours"
    type: sum
    sql: ${number_of_planned_minutes_wh}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_planned_hours_cc_agent {
    group_label: "> CC Agent Measures"
    label: "# Planned CC Agent Hours"
    type: sum
    sql: ${number_of_planned_minutes_wh}/60;;
    value_format_name: decimal_1
  }
  measure: number_of_planned_hours_hub_staff {
    group_label: "> Hub Staff Measures"
    label: "# Planned Hub Staff Hours"
    type: number
    sql: ${number_of_planned_hours_ops_associate}+${number_of_planned_hours_shift_lead};;
    value_format_name: decimal_1
  }

  # =========  Scheduled Hours (Post-adjustments)   =========
  ##### All
  measure: number_of_scheduled_hours_rider {
    group_label: "> Rider Measures"
    label: "# Scheduled Rider Hours"
    type: number
    sql: ${number_of_unassigned_hours_rider}+${number_of_planned_hours_rider};;
    value_format_name: decimal_1
  }

  measure: number_of_scheduled_hours_picker {
    group_label: "> Picker Measures"
    label: "# Scheduled Picker Hours"
    type: number
    # sql_distinct_key: ${staffing_uuid} ;;
    sql: ${number_of_unassigned_hours_picker}+${number_of_planned_hours_picker};;
    value_format_name: decimal_1
  }

  measure: number_of_scheduled_hours_shift_lead {
    group_label: "> Shift Lead Measures"
    label: "# Scheduled Shift Lead Hours"
    type: number
    sql: ${number_of_unassigned_hours_shift_lead}+${number_of_planned_hours_shift_lead};;
    value_format_name: decimal_1
  }
  measure: number_of_scheduled_hours_rider_captain {
    group_label: "> Rider Captain Measures"
    label: "# Scheduled Rider Captain Hours"
    type: number
    sql: ${number_of_unassigned_hours_rider_captain}+${number_of_planned_hours_rider_captain};;
    value_format_name: decimal_1
  }
  measure: number_of_scheduled_hours_co_ops {
    group_label: "> Co Ops Measures"
    label: "# Scheduled Co Ops Employee Hours"
    type: number
    sql: ${number_of_unassigned_hours_co_ops}+${number_of_planned_hours_co_ops};;
    value_format_name: decimal_1
  }

  measure: number_of_scheduled_hours_wh {
    group_label: "> WH Measures"
    label: "# Scheduled WH Employee Hours"
    type: number
    # sql_distinct_key: ${staffing_uuid} ;;
    sql: ${number_of_unassigned_hours_wh}+${number_of_planned_hours_wh};;
    value_format_name: decimal_1
  }

  measure: number_of_scheduled_hours_cc_agent {
    group_label: "> CC Agent Measures"
    label: "# Scheduled CC Agent Hours"
    type: number
    sql: ${number_of_unassigned_hours_cc_agent}+${number_of_planned_hours_cc_agent};;
    value_format_name: decimal_1
  }
  measure: number_of_scheduled_hours_hub_staff {
    group_label: "> Hub Staff Measures"
    label: "# Scheduled Hub Staff Hours"
    type: number
    sql: ${number_of_scheduled_hours_ops_associate}+${number_of_scheduled_hours_rider_captain};;
    value_format_name: decimal_1
  }
  measure: number_of_scheduled_hours_ops_associate {
    alias: [number_of_scheduled_hours_ops_staff]
    group_label: "> Ops Associate Measures"
    label: "# Scheduled Ops Associate Hours"
    type: number
    sql: ${number_of_unassigned_hours_ops_associate}+${number_of_planned_hours_ops_associate};;
    value_format_name: decimal_1
  }
  ##### External

  measure: number_of_scheduled_hours_external_rider {
    group_label: "> Rider Measures"
    label: "# External Scheduled Rider Hours"
    description: "# External Scheduled Rider Hours (Post-Adjustments) (Assigned + Open)"
    type: sum
    sql: (${number_of_unassigned_minutes_external_rider}+${number_of_planned_minutes_external_rider})/60;;
    value_format_name: decimal_1
  }

  measure: number_of_scheduled_hours_external_ops_associate {
    alias: [number_of_scheduled_hours_external_ops_staff]
    group_label: "> Ops Associate Measures"
    label: "# External Scheduled Ops Associate Hours"
    description: "# External Scheduled Ops Associate Hours (Post-Adjustments) (Assigned + Open)"
    type: number
    sql: (${number_of_unassigned_minutes_external_ops_associate}+${number_of_planned_minutes_external_ops_associate})/60;;
    value_format_name: decimal_1
  }

  measure: number_of_scheduled_hours_external_picker {
    group_label: "> Picker Measures"
    label: "# External Scheduled Picker Hours"
    description: "# External Scheduled Picker Hours (Post-Adjustments) (Assigned + Open)"
    type: sum
    sql: (${number_of_unassigned_minutes_external_picker}+${number_of_planned_minutes_external_picker})/60;;
    value_format_name: decimal_1
  }

  measure: number_of_scheduled_hours_external_shift_lead {
    group_label: "> Shift Lead Measures"
    label: "# External Scheduled Shift Lead Hours"
    description: "# External Scheduled Shift Lead Hours (Post-Adjustments) (Assigned + Open)"
    type: sum
    sql: (${number_of_unassigned_minutes_external_shift_lead}+${number_of_planned_minutes_external_shift_lead})/60;;
    value_format_name: decimal_1
  }
  measure: number_of_scheduled_hours_external_rider_captain {
    group_label: "> Rider Captain Measures"
    label: "# External Scheduled Rider Captain Hours"
    description: "# External Scheduled Rider Captain Hours (Post-Adjustments) (Assigned + Open)"
    type: sum
    sql: (${number_of_unassigned_minutes_external_rider_captain}+${number_of_planned_minutes_external_rider_captain})/60;;
    value_format_name: decimal_1
  }
  measure: number_of_scheduled_hours_external_co_ops {
    group_label: "> Co Ops Measures"
    label: "# External Scheduled Co Ops Employee Hours"
    description: "# External Scheduled Co Ops Employee Hours (Post-Adjustments) (Assigned + Open)"
    type: sum
    sql: (${number_of_unassigned_minutes_external_co_ops}+${number_of_planned_minutes_external_co_ops})/60;;
    value_format_name: decimal_1
  }

  measure: number_of_scheduled_hours_external_wh {
    group_label: "> WH Measures"
    label: "# External Scheduled WH Employee Hours"
    description: "# External Scheduled WH Employee Hours (Post-Adjustments) (Assigned + Open)"
    type: sum
    sql: (${number_of_unassigned_minutes_external_wh}+${number_of_planned_minutes_external_wh})/60;;
    value_format_name: decimal_1
  }

  measure: number_of_scheduled_hours_external_cc_agent {
    group_label: "> CC Agent Measures"
    label: "# External Scheduled CC Agent Hours"
    description: "# External Scheduled CC Agent Hours (Post-Adjustments) (Assigned + Open)"
    type: sum
    sql: (${number_of_unassigned_minutes_external_cc_agent}+${number_of_planned_minutes_external_cc_agent})/60;;
    value_format_name: decimal_1
  }
  measure: number_of_scheduled_hours_external_hub_staff {
    group_label: "> Hub Staff Measures"
    label: "# External Scheduled Hub Staff Hours"
    description: "# External Scheduled Hub Staff Hours (Post-Adjustments) (Assigned + Open)"
    type: number
    sql: (${number_of_scheduled_hours_external_ops_associate}+${number_of_scheduled_hours_external_shift_lead})/60;;
    value_format_name: decimal_1
  }

  # =========  No Show Hours   =========
  ##### All

  measure: number_of_no_show_hours_ops_associate {
    alias: [number_of_no_show_hours_ops_staff]
    group_label: "> Ops Associate Measures"
    label: "# No Show Ops Associate Hours"
    type: number
    sql: ${number_of_no_show_minutes_ops_associate}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_no_show_hours_rider {
    group_label: "> Rider Measures"
    label: "# No Show Rider Hours"
    type: sum
    sql: ${number_of_no_show_minutes_rider}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_no_show_hours_picker {
    group_label: "> Picker Measures"
    label: "# No Show Picker Hours"
    type: sum
    sql: ${number_of_no_show_minutes_picker}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_no_show_hours_shift_lead {
    group_label: "> Shift Lead Measures"
    label: "# No Show Shift Lead Hours"
    type: sum
    sql: ${number_of_no_show_minutes_shift_lead}/60;;
    value_format_name: decimal_1
  }
  measure: number_of_no_show_hours_rider_captain {
    group_label: "> Rider Captain Measures"
    label: "# No Show Rider Captain Hours"
    type: sum
    sql: ${number_of_no_show_minutes_rider_captain}/60;;
    value_format_name: decimal_1
  }
  measure: number_of_no_show_hours_co_ops {
    group_label: "> Co Ops Measures"
    label: "# No Show Co Ops Hours"
    type: sum
    sql: ${number_of_no_show_minutes_co_ops}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_no_show_hours_wh {
    group_label: "> WH Measures"
    label: "# No Show WH Hours"
    type: sum
    sql: ${number_of_no_show_minutes_wh}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_no_show_hours_cc_agent {
    group_label: "> CC Agent Measures"
    label: "# No Show CC Agent Hours"
    type: sum
    sql: ${number_of_no_show_minutes_wh}/60;;
    value_format_name: decimal_1
  }
  measure: number_of_no_show_hours_hub_staff {
    group_label: "> Hub Staff Measures"
    label: "# No Show Hub Staff Hours"
    type: number
    sql: ${number_of_no_show_hours_ops_associate}+${number_of_no_show_hours_shift_lead};;
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
    type: number
    sql: ${number_of_no_show_minutes_external_ops_associate}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_no_show_hours_external_picker {
    group_label: "> Picker Measures"
    label: "# External No Show Picker Hours"
    type: sum
    sql: ${number_of_no_show_minutes_external_picker}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_no_show_hours_external_shift_lead {
    group_label: "> Shift Lead Measures"
    label: "# External No Show Shift Lead Hours"
    type: sum
    sql: ${number_of_no_show_minutes_external_shift_lead}/60;;
    value_format_name: decimal_1
  }
  measure: number_of_no_show_hours_external_rider_captain {
    group_label: "> Rider Captain Measures"
    label: "# External No Show Rider Captain Hours"
    type: sum
    sql: ${number_of_no_show_minutes_external_rider_captain}/60;;
    value_format_name: decimal_1
  }
  measure: number_of_no_show_hours_external_co_ops {
    group_label: "> Co Ops Measures"
    label: "# External No Show Co Ops Hours"
    type: sum
    sql: ${number_of_no_show_minutes_external_co_ops}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_no_show_hours_external_wh {
    group_label: "> WH Measures"
    label: "# External No Show WH Hours"
    type: sum
    sql: ${number_of_no_show_minutes_external_wh}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_no_show_hours_external_cc_agent {
    group_label: "> CC Agent Measures"
    label: "# External No Show CC Agent Hours"
    type: sum
    sql: ${number_of_no_show_minutes_external_wh}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_no_show_hours_external_hub_staff {
    group_label: "> Hub Staff Measures"
    label: "# External No Show Hub Staff Hours"
    type: number
    sql: ${number_of_no_show_hours_external_ops_associate}+${number_of_no_show_hours_external_shift_lead};;
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

  measure: number_of_excused_no_show_hours_rider_captain {
    group_label: "> Rider Captain Measures"
    label: "# Excused No Show Rider Captain Hours"
    type: sum
    sql: ${number_of_excused_no_show_minutes_rider_captain}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_excused_no_show_hours_shift_lead {
    group_label: "> Shift Lead Measures"
    label: "# Excused No Show Shift Lead Hours"
    type: sum
    sql: ${number_of_excused_no_show_minutes_shift_lead}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_excused_no_show_hours_picker {
    group_label: "> Picker Measures"
    label: "# Excused No Show Picker Hours"
    type: sum
    sql: ${number_of_excused_no_show_minutes_picker}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_excused_no_show_hours_wh {
    group_label: "> WH Measures"
    label: "# Excused No Show WH Hours"
    type: sum
    sql: ${number_of_excused_no_show_minutes_wh}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_excused_no_show_hours_cc {
    group_label: "> CC Agent Measures"
    label: "# Excused No Show CC Agent Hours"
    type: sum
    sql: ${number_of_excused_no_show_minutes_cc_agent}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_excused_no_show_hours_hub_staff {
    group_label: "> Hub Staff Measures"
    label: "# Excused No Show Hub Staff Hours"
    type: number
    sql: (${number_of_excused_no_show_minutes_ops_associate}+sum(${number_of_excused_no_show_minutes_shift_lead}))/60;;
    value_format_name: decimal_1
  }

  measure: number_of_excused_no_show_hours_ops_associate {
    alias: [number_of_excused_no_show_hours_ops_staff]
    group_label: "> Ops Associate Measures"
    label: "# Excused No Show Ops Associate Hours"
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

  measure: number_of_unexcused_no_show_hours_rider_captain {
    group_label: "> Rider Captain Measures"
    label: "# Unexcused No Show Rider Captain Hours"
    type: sum
    sql: ${number_of_unexcused_no_show_minutes_rider_captain}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_unexcused_no_show_hours_shift_lead {
    group_label: "> Shift Lead Measures"
    label: "# Unexcused No Show Shift Lead Hours"
    type: sum
    sql: ${number_of_unexcused_no_show_minutes_shift_lead}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_unexcused_no_show_hours_picker {
    group_label: "> Picker Measures"
    label: "# Unexcused No Show Picker Hours"
    type: sum
    sql: ${number_of_unexcused_no_show_minutes_picker}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_unexcused_no_show_hours_wh {
    group_label: "> WH Measures"
    label: "# Unexcused No Show WH Hours"
    type: sum
    sql: ${number_of_unexcused_no_show_minutes_wh}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_unexcused_no_show_hours_hub_staff {
    group_label: "> Hub Staff Measures"
    label: "# Unexcused No Show Hub Staff Hours"
    type: number
    sql: (${number_of_unexcused_no_show_minutes_ops_associate}+sum(${number_of_unexcused_no_show_minutes_shift_lead}))/60;;
    value_format_name: decimal_1
  }

  measure: number_of_unexcused_no_show_hours_ops_associate {
    alias: [number_of_unexcused_no_show_hours_ops_staff]
    group_label: "> Ops Associate Measures"
    label: "# Unexcused No Show Ops Associate Hours"
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

  measure: number_of_deleted_excused_no_show_hours_picker {
    group_label: "> Picker Measures"
    label: "# Deleted Excused No Show Picker Hours"
    type: sum
    sql: ${number_of_deleted_excused_no_show_minutes_picker}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_deleted_excused_no_show_hours_wh {
    group_label: "> WH Measures"
    label: "# Deleted Excused No Show WH Hours"
    type: sum
    sql: ${number_of_deleted_excused_no_show_minutes_wh}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_deleted_excused_no_show_hours_rider_captain {
    group_label: "> Rider Captain Measures"
    label: "# Deleted Excused No Show Rider Captain Hours"
    type: sum
    sql: ${number_of_deleted_excused_no_show_minutes_rider_captain}/60;;
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
    type: number
    sql: ${number_of_deleted_excused_no_show_minutes_ops_associate}/60;;
    value_format_name: decimal_1
  }

  ##### Deleted Unexcused

  measure: number_of_deleted_unexcused_no_show_hours_rider {
    group_label: "> Rider Measures"
    label: "# Deleted Unexcused No Show Rider Hours"
    type: sum
    sql: ${number_of_deleted_unexcused_no_show_minutes_rider}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_deleted_unexcused_no_show_hours_picker {
    group_label: "> Picker Measures"
    label: "# Deleted Unexcused No Show Picker Hours"
    type: sum
    sql: ${number_of_deleted_unexcused_no_show_minutes_picker}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_deleted_unexcused_no_show_hours_wh {
    group_label: "> WH Measures"
    label: "# Deleted Unexcused No Show WH Hours"
    type: sum
    sql: ${number_of_deleted_unexcused_no_show_minutes_wh}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_deleted_unexcused_no_show_hours_rider_captain {
    group_label: "> Rider Captain Measures"
    label: "# Deleted Unexcused No Show Rider Captain Hours"
    type: sum
    sql: ${number_of_deleted_unexcused_no_show_minutes_rider_captain}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_deleted_unexcused_no_show_hours_shift_lead {
    group_label: "> Shift Lead Measures"
    label: "# Deleted Unexcused No Show Shift Lead Hours"
    type: sum
    sql: ${number_of_deleted_unexcused_no_show_minutes_shift_lead}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_deleted_unexcused_no_show_hours_ops_associate {
    alias: [number_of_deleted_unexcused_no_show_hours_ops_staff]
    group_label: "> Ops Associate Measures"
    label: "# Deleted Unexcused No Show Ops Associate Hours"
    type: number
    sql: ${number_of_deleted_unexcused_no_show_minutes_ops_associate}/60;;
    value_format_name: decimal_1
  }

  # =========  No Show %   =========
  measure: pct_no_show_hours_rider {
    group_label: "> Rider Measures"
    label: "% No Show Rider Hours"
    type: number
    sql:(${number_of_no_show_hours_rider})/nullif(${number_of_planned_hours_rider},0) ;;
    value_format_name: percent_1
  }

  measure: pct_no_show_hours_picker {
    group_label: "> Picker Measures"
    label: "% No Show Picker Hours"
    sql:(${number_of_no_show_hours_picker})/nullif(${number_of_planned_hours_picker},0) ;;
    value_format_name: percent_1
  }

  measure: pct_no_show_hours_shift_lead {
    group_label: "> Shift Lead Measures"
    label: "% No Show Shift Lead Hours"
    type: number
    sql:(${number_of_no_show_hours_shift_lead})/nullif(${number_of_planned_hours_shift_lead},0) ;;
    value_format_name: percent_1
  }
  measure: pct_no_show_hours_rider_captain {
    group_label: "> Rider Captain Measures"
    label: "% No Show Rider Captain Hours"
    type: number
    sql:(${number_of_no_show_hours_rider_captain})/nullif(${number_of_planned_hours_rider_captain},0) ;;
    value_format_name: percent_1
  }
  measure: pct_no_show_hours_co_ops {
    group_label: "> Co Ops Measures"
    label: "% No Show Co Ops Hours"
    type: number
    sql:(${number_of_no_show_hours_co_ops})/nullif(${number_of_planned_hours_co_ops},0) ;;
    value_format_name: percent_1
  }

  measure: pct_no_show_hours_wh {
    group_label: "> WH Measures"
    label: "% No Show WH Hours"
    sql:(${number_of_no_show_hours_wh})/nullif(${number_of_planned_hours_wh},0) ;;
    value_format_name: percent_1
  }

  measure: pct_no_show_hours_cc_agent {
    group_label: "> CC Agent Measures"
    label: "% No Show CC Agent Hours"
    type: number
    sql:(${number_of_no_show_hours_cc_agent})/nullif(${number_of_planned_hours_cc_agent},0) ;;
    value_format_name: percent_1
  }
  measure: pct_no_show_hours_hub_staff {
    group_label: "> Hub Staff Measures"
    label: "% No Show Hub Staff Hours"
    type: number
    sql:(${number_of_no_show_hours_hub_staff})/nullif(${number_of_planned_hours_hub_staff},0) ;;
    value_format_name: percent_1
  }
  measure: pct_no_show_hours_ops_associate {
    alias: [pct_no_show_hours_ops_staff]
    group_label: "> Ops Associate Measures"
    label: "% No Show Ops Associate Hours"
    type: number
    sql:(${number_of_no_show_hours_ops_associate})/nullif(${number_of_planned_hours_ops_associate},0) ;;
    value_format_name: percent_1
  }


  # =========  UTR   =========

  measure: utr_rider {
    group_label: "> Rider Measures"
    label: "Rider UTR"
    type: number
    sql: ${orders_with_ops_metrics.cnt_rider_orders}/ NULLIF(${number_of_worked_hours_rider}, 0) ;;
    value_format_name: decimal_1
  }

  measure: logistics_index {
    label: "Logistics Index"
    description: "AVG Fulfillment Time / Rider UTR"
    type: number
    sql: ${orders_with_ops_metrics.avg_fulfillment_time}/${utr_rider} ;;
    value_format_name: decimal_1
  }

  measure: utr_picker {
    group_label: "> Picker Measures"
    label: "Picker UTR"
    type: number
    sql: ${orders_with_ops_metrics.sum_orders}/ NULLIF(${number_of_worked_hours_picker}, 0) ;;
    value_format_name: decimal_1
  }

  measure: utr_hub_staff {
    group_label: "> Hub Staff Measures"
    label: "Hub Staff UTR"
    description: "Hub Staff UTR (# Orders/Hub Hours)"
    type: number
    sql: ${orders_with_ops_metrics.sum_orders}/ NULLIF(${number_of_worked_hours_hub_staff}, 0) ;;
    value_format_name: decimal_1
  }

  measure: utr_ops_associate {
    alias: [utr_ops_staff]
    group_label: "> Ops Associate Measures"
    label: "Ops Associate UTR"
    description: "Ops Associate UTR (# Orders/# Punched Ops Associate Hours)"
    type: number
    sql: ${orders_with_ops_metrics.sum_orders}/ NULLIF(${number_of_worked_hours_ops_associate}, 0) ;;
    value_format_name: decimal_1
  }

  measure: hub_staff_utr_all_items {
    group_label: "> Hub Staff Measures"
    label: "Hub Staff UTR (All Items)"
    description: "Hub Staff UTR (# All inventory Changes/Hub Staff Hours)"
    type: number
    sql: abs(${inventory_changes_daily.sum_quantity_change})/nullif(${number_of_worked_hours_hub_staff},0) ;;
    value_format_name: decimal_2
  }

  measure: hub_staff_utr_inbounded_handling_units {
    group_label: "> Hub Staff Measures"
    label: "Hub Staff UTR (Inbounded Handling Units)"
    description: "Hub Staff UTR (# All inventory Changes/Hub Staff Hours)"
    type: number
    sql: abs(${inventory_changes_daily.sum_inbound_inventory_handling_units})/nullif(${number_of_worked_hours_hub_staff},0) ;;
    value_format_name: decimal_2
  }

  measure: hub_staff_utr_picked_items {
    group_label: "> Hub Staff Measures"
    label: "Hub Staff UTR (Ordered Items)"
    description: "Hub Staff UTR (# Ordered Items/Hub Staff Hours)"
    type: number
    sql: abs(${inventory_changes_daily.sum_outbound_orders})/nullif(${number_of_worked_hours_hub_staff},0) ;;
    value_format_name: decimal_2
  }

  measure: hub_staff_utr_outbounded_items {
    group_label: "> Hub Staff Measures"
    label: "Hub Staff UTR (Outbounded Items)"
    description: "Hub Staff UTR (# Outbounded Items (Waste, Orders, Too good to go,Wrong delivery)/Hub Staff Hours)"
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
        CASE
          WHEN {% parameter position_parameter %} = 'Rider' THEN ${number_of_no_show_minutes_rider}/60
      ELSE NULL
      END ;;
    hidden: yes
  }

  measure: number_of_planned_hours_by_position {
    type: number
    label: "# Filled Hours"
    description: "# Shift Hours Assigned to an Employee"
    value_format_name: decimal_1
    group_label: "> Dynamic Measures"
    sql:
        CASE
          WHEN {% parameter position_parameter %} = 'Rider' THEN ${number_of_planned_hours_rider}
          WHEN {% parameter position_parameter %} = 'Picker' THEN ${number_of_planned_hours_picker}
          WHEN {% parameter position_parameter %} = 'Shift Lead' THEN ${number_of_planned_hours_shift_lead}
          WHEN {% parameter position_parameter %} = 'Rider Captain' THEN ${number_of_planned_hours_rider_captain}
          WHEN {% parameter position_parameter %} = 'WH' THEN ${number_of_planned_hours_wh}
          WHEN {% parameter position_parameter %} = 'Hub Staff' THEN ${number_of_planned_hours_hub_staff}
          WHEN {% parameter position_parameter %} = 'Ops Associate' THEN ${number_of_planned_hours_ops_associate}
          ELSE NULL
        END ;;
  }

  measure: number_of_excused_no_show_hours_by_position {
    type: number
    label: "# Excused No Show Hours"
    description: "Sum of shift hours when an employee has a scheduled shift but does not show up to it with leave reason"
    value_format_name: decimal_1
    group_label: "> Dynamic Measures"
    sql:
        CASE
          WHEN {% parameter position_parameter %} = 'Rider' THEN ${number_of_excused_no_show_hours_rider}
          WHEN {% parameter position_parameter %} = 'Picker' THEN ${number_of_excused_no_show_hours_picker}
          WHEN {% parameter position_parameter %} = 'Shift Lead' THEN ${number_of_excused_no_show_hours_shift_lead}
          WHEN {% parameter position_parameter %} = 'Rider Captain' THEN ${number_of_excused_no_show_hours_rider_captain}
          WHEN {% parameter position_parameter %} = 'WH' THEN ${number_of_excused_no_show_hours_wh}
          WHEN {% parameter position_parameter %} = 'Hub Staff' THEN ${number_of_excused_no_show_hours_hub_staff}
          WHEN {% parameter position_parameter %} = 'Ops Associate' THEN ${number_of_excused_no_show_hours_ops_associate}
          ELSE NULL
        END ;;
  }

  measure: number_of_deleted_excused_no_show_hours_by_position {
    type: number
    label: "# Deleted Excused No Show Hours"
    description: "Sum of deleted shift hours when an employee has a scheduled shift but does not show up to it with leave reason and shift deletion date is on/after shift date (shift date <= deletion date)"
    value_format_name: decimal_1
    group_label: "> Dynamic Measures"
    sql:
        CASE
          WHEN {% parameter position_parameter %} = 'Rider' THEN ${number_of_deleted_excused_no_show_hours_rider}
          WHEN {% parameter position_parameter %} = 'Picker' THEN ${number_of_deleted_excused_no_show_hours_picker}
          WHEN {% parameter position_parameter %} = 'Shift Lead' THEN ${number_of_deleted_excused_no_show_hours_shift_lead}
          WHEN {% parameter position_parameter %} = 'Rider Captain' THEN ${number_of_deleted_excused_no_show_hours_rider_captain}
          WHEN {% parameter position_parameter %} = 'WH' THEN ${number_of_deleted_excused_no_show_hours_wh}
          WHEN {% parameter position_parameter %} = 'Ops Associate' THEN ${number_of_deleted_excused_no_show_hours_ops_associate}
          ELSE NULL
        END ;;
  }

  measure: number_of_unexcused_no_show_hours_by_position {
    type: number
    label: "# Unexcused No Show Hours"
    description: "Sum of shift hours when an employee has a scheduled shift but does not show up to it without leave reason"
    value_format_name: decimal_1
    group_label: "> Dynamic Measures"
    sql:
        CASE
          WHEN {% parameter position_parameter %} = 'Rider' THEN ${number_of_unexcused_no_show_hours_rider}
          WHEN {% parameter position_parameter %} = 'Picker' THEN ${number_of_unexcused_no_show_hours_picker}
          WHEN {% parameter position_parameter %} = 'Shift Lead' THEN ${number_of_unexcused_no_show_hours_shift_lead}
          WHEN {% parameter position_parameter %} = 'Rider Captain' THEN ${number_of_unexcused_no_show_hours_rider_captain}
          WHEN {% parameter position_parameter %} = 'WH' THEN ${number_of_unexcused_no_show_hours_wh}
          WHEN {% parameter position_parameter %} = 'Hub Staff' THEN ${number_of_unexcused_no_show_hours_hub_staff}
          WHEN {% parameter position_parameter %} = 'Ops Associate' THEN ${number_of_unexcused_no_show_hours_ops_associate}
          ELSE NULL
        END ;;
  }

  measure: pct_fill_rate {
    type: number
    label: "% Fill Rate"
    description: "# Filled Hours (Assigned to an Employee) / # Scheduled Hours (Total Scheduled Shift Hours - Assigned + Open)"
    value_format_name: percent_1
    group_label: "> Dynamic Measures"
    sql: ${number_of_planned_hours_by_position}/nullif(${number_of_scheduled_hours_by_position},0);;
  }

  measure: pct_unexcused_absence {
    type: number
    label: "% Unexcused Absence"
    description: "# Unexcused No Show Hours / # Filled Hours (Assigned to an Employee)"
    value_format_name: percent_1
    group_label: "> Dynamic Measures"
    sql: (${number_of_unexcused_no_show_hours_by_position})/nullif(${number_of_planned_hours_by_position},0);;
  }

  measure: pct_excused_absence {
    type: number
    label: "% Excused Absence"
    description: "# Excused No Show Hours / # Filled Hours (Assigned to an Employee)"
    value_format_name: percent_1
    group_label: "> Dynamic Measures"
    sql: (${number_of_deleted_excused_no_show_hours_by_position}+${number_of_excused_no_show_hours_by_position})/nullif(${number_of_planned_hours_by_position},0);;
  }

  measure: number_of_unassigned_hours_by_position {
    type: number
    label: "# Open Hours"
    description: "# Open Shift Hours (Not assigned to an Employee)"
    value_format_name: decimal_1
    group_label: "> Dynamic Measures"
    sql:
        CASE
          WHEN {% parameter position_parameter %} = 'Rider' THEN ${number_of_unassigned_hours_rider}
          WHEN {% parameter position_parameter %} = 'Picker' THEN ${number_of_unassigned_hours_picker}
          WHEN {% parameter position_parameter %} = 'Shift Lead' THEN ${number_of_unassigned_hours_shift_lead}
          WHEN {% parameter position_parameter %} = 'Rider Captain' THEN ${number_of_unassigned_hours_rider_captain}
          WHEN {% parameter position_parameter %} = 'WH' THEN ${number_of_unassigned_hours_wh}
          WHEN {% parameter position_parameter %} = 'Hub Staff' THEN ${number_of_unassigned_hours_hub_staff}
          WHEN {% parameter position_parameter %} = 'Ops Associate' THEN ${number_of_unassigned_hours_ops_associate}
      ELSE NULL
      END ;;
  }

  measure: number_of_scheduled_hours_by_position {
    type: number
    label: "# Scheduled Hours (Incl. Deleted Excused No Show)"
    description: "Sum of Assigned and Unassigned Shift Hours (Incl. Deleted Excused No Show)"
    value_format_name: decimal_1
    group_label: "> Dynamic Measures"
    sql:
        CASE
          WHEN {% parameter position_parameter %} = 'Rider' THEN ${number_of_scheduled_hours_rider}
          WHEN {% parameter position_parameter %} = 'Picker' THEN ${number_of_scheduled_hours_picker}
          WHEN {% parameter position_parameter %} = 'Shift Lead' THEN ${number_of_scheduled_hours_shift_lead}
          WHEN {% parameter position_parameter %} = 'Rider Captain' THEN ${number_of_scheduled_hours_rider_captain}
          WHEN {% parameter position_parameter %} = 'WH' THEN ${number_of_scheduled_hours_wh}
          WHEN {% parameter position_parameter %} = 'Hub Staff' THEN ${number_of_scheduled_hours_hub_staff}
          WHEN {% parameter position_parameter %} = 'Ops Associate' THEN ${number_of_scheduled_hours_ops_associate}
      ELSE NULL
      END ;;
  }

  measure: pct_scheduled_hours_by_position {
    type: number
    label: "% External Scheduled Hours"
    description: "Sum External Scheduled Hours (Assigned + Unassigned) / Sum Scheduled Hours (Assigned + Unassigned)"
    value_format_name: decimal_1
    group_label: "> Dynamic Measures"
    sql:
        CASE
          WHEN {% parameter position_parameter %} = 'Rider' THEN ${number_of_scheduled_hours_external_rider}/nullif(${number_of_scheduled_hours_rider},0)
          WHEN {% parameter position_parameter %} = 'Picker' THEN ${number_of_scheduled_hours_external_picker}/nullif(${number_of_scheduled_hours_picker},0)
          WHEN {% parameter position_parameter %} = 'Shift Lead' THEN ${number_of_scheduled_hours_external_shift_lead}/nullif(${number_of_scheduled_hours_shift_lead},0)
          WHEN {% parameter position_parameter %} = 'Rider Captain' THEN ${number_of_scheduled_hours_external_rider_captain}/nullif(${number_of_scheduled_hours_rider_captain},0)
          WHEN {% parameter position_parameter %} = 'WH' THEN ${number_of_scheduled_hours_external_wh}/nullif(${number_of_scheduled_hours_wh},0)
          WHEN {% parameter position_parameter %} = 'Hub Staff' THEN ${number_of_scheduled_hours_external_hub_staff}/nullif(${number_of_scheduled_hours_hub_staff},0)
          WHEN {% parameter position_parameter %} = 'Ops Associate' THEN ${number_of_scheduled_hours_external_ops_associate}/nullif(${number_of_scheduled_hours_ops_associate},0)
      ELSE NULL
      END ;;
  }

  dimension: number_of_scheduled_hours_by_position_dimension {
    type: number
    label: "# Scheduled Hours (Incl. Deleted Excused No Show) - Dimension"
    description: "Sum of Assigned and Unassigned Shift Hours (Incl. Deleted Excused No Show)"
    value_format_name: decimal_1
    group_label: "> Dynamic Measures"
    sql:
        CASE
          WHEN {% parameter position_parameter %} = 'Rider' THEN ${number_of_scheduled_hours_rider_dimension}
          WHEN {% parameter position_parameter %} = 'Picker' THEN ${number_of_scheduled_hours_picker_dimension}
      ELSE NULL
      END ;;
    hidden: yes
  }

  measure: number_of_scheduled_hours_excluding_deleted_shifts_by_position {
    type: number
    label: "# Scheduled Hours (Excl. Deleted Excused No Show)"
    description: "Sum of Assigned and Unassigned Shift Hours (Excl. Deleted Excused No Show)"
    value_format_name: decimal_1
    group_label: "> Dynamic Measures"
    sql:
      CASE
        WHEN {% parameter position_parameter %} = 'Rider' THEN ${number_of_scheduled_hours_rider} - ${number_of_deleted_excused_no_show_hours_rider}
        WHEN {% parameter position_parameter %} = 'Picker' THEN ${number_of_scheduled_hours_picker} - ${number_of_deleted_excused_no_show_hours_picker}
        WHEN {% parameter position_parameter %} = 'Shift Lead' THEN ${number_of_scheduled_hours_shift_lead} - ${number_of_deleted_excused_no_show_hours_shift_lead}
        WHEN {% parameter position_parameter %} = 'Rider Captain' THEN ${number_of_scheduled_hours_rider_captain} - ${number_of_deleted_excused_no_show_hours_rider_captain}
        WHEN {% parameter position_parameter %} = 'WH' THEN ${number_of_scheduled_hours_wh} - ${number_of_deleted_excused_no_show_hours_wh}
        WHEN {% parameter position_parameter %} = 'Ops Associate' THEN ${number_of_scheduled_hours_ops_associate} - ${number_of_deleted_excused_no_show_hours_ops_associate}
    ELSE NULL
    END ;;
  }



  measure: number_of_worked_hours_by_position {
    type: number
    label: "# Punched Hours"
    description: "# Hours Worked by an Employee"
    value_format_name: decimal_1
    group_label: "> Dynamic Measures"
    sql:
        CASE
          WHEN {% parameter position_parameter %} = 'Rider' THEN ${number_of_worked_hours_rider}
          WHEN {% parameter position_parameter %} = 'Picker' THEN ${number_of_worked_hours_picker}
          WHEN {% parameter position_parameter %} = 'Shift Lead' THEN ${number_of_worked_hours_shift_lead}
          WHEN {% parameter position_parameter %} = 'Rider Captain' THEN ${number_of_worked_hours_rider_captain}
          WHEN {% parameter position_parameter %} = 'WH' THEN ${number_of_worked_hours_wh}
          WHEN {% parameter position_parameter %} = 'Hub Staff' THEN ${number_of_worked_hours_hub_staff}
          WHEN {% parameter position_parameter %} = 'Ops Associate' THEN ${number_of_worked_hours_ops_associate}
      ELSE NULL
      END ;;
  }

  measure: number_of_no_show_hours_by_position {
    type: number
    label: "# No Show Hours"
    description: "Sum of shift hours when an employee has a scheduled shift but does not show up to it without leave reason including deleted shift hours when deletion date is on or after shift date. includes (Excused No show Hours, Unexcused No show Hours, Excused Deleted No show Hours)"
    value_format_name: decimal_1
    group_label: "> Dynamic Measures"
    sql:
        CASE
          WHEN {% parameter position_parameter %} = 'Rider' THEN ${number_of_no_show_hours_rider}
          WHEN {% parameter position_parameter %} = 'Picker' THEN ${number_of_no_show_hours_picker}
          WHEN {% parameter position_parameter %} = 'Shift Lead' THEN ${number_of_no_show_hours_shift_lead}
          WHEN {% parameter position_parameter %} = 'Rider Captain' THEN ${number_of_no_show_hours_rider_captain}
          WHEN {% parameter position_parameter %} = 'WH' THEN ${number_of_no_show_hours_wh}
          WHEN {% parameter position_parameter %} = 'Hub Staff' THEN ${number_of_no_show_hours_hub_staff}
          WHEN {% parameter position_parameter %} = 'Ops Associate' THEN ${number_of_no_show_hours_ops_associate}
      ELSE NULL
      END ;;
  }

  measure: pct_external_worked_hours_by_position {
    type: number
    label: "% External Punched Hours"
    description: "Sum External Punched Hours / Sum Punched Hours"
    value_format_name: percent_1
    group_label: "> Dynamic Measures"
    sql:
        CASE
          WHEN {% parameter position_parameter %} = 'Rider' THEN ${number_of_worked_hours_external_rider}/nullif(${number_of_worked_hours_rider},0)
          WHEN {% parameter position_parameter %} = 'Picker' THEN ${number_of_worked_hours_external_picker}/nullif(${number_of_worked_hours_picker},0)
          WHEN {% parameter position_parameter %} = 'Shift Lead' THEN ${number_of_worked_hours_external_shift_lead}/nullif(${number_of_worked_hours_shift_lead},0)
          WHEN {% parameter position_parameter %} = 'Rider Captain' THEN ${number_of_worked_hours_external_rider_captain}/nullif(${number_of_worked_hours_rider_captain},0)
          WHEN {% parameter position_parameter %} = 'WH' THEN ${number_of_worked_hours_external_wh}/nullif(${number_of_worked_hours_wh},0)
          WHEN {% parameter position_parameter %} = 'Hub Staff' THEN ${number_of_worked_hours_external_hub_staff}/nullif(${number_of_worked_hours_hub_staff},0)
          WHEN {% parameter position_parameter %} = 'Ops Associate' THEN ${number_of_worked_hours_external_ops_associate}/nullif(${number_of_worked_hours_ops_associate},0)
      ELSE NULL
      END ;;
  }

  measure: pct_no_show_hours_by_position {
    type: number
    label: "% No Show Hours"
    description: "% shift hours when an employee has a scheduled shift but does not show up to it without leave reason including deleted shift hours when deletion date is on or after shift date. includes (Excused No show Hours, Unexcused No show Hours, Excused Deleted No show Hours)"
    value_format_name: percent_1
    group_label: "> Dynamic Measures"
    sql:
        CASE
          WHEN {% parameter position_parameter %} = 'Rider' THEN ${pct_no_show_hours_rider}
          WHEN {% parameter position_parameter %} = 'Picker' THEN ${pct_no_show_hours_picker}
          WHEN {% parameter position_parameter %} = 'Shift Lead' THEN ${pct_no_show_hours_shift_lead}
          WHEN {% parameter position_parameter %} = 'Rider Captain' THEN ${pct_no_show_hours_rider_captain}
          WHEN {% parameter position_parameter %} = 'WH' THEN ${pct_no_show_hours_wh}
          WHEN {% parameter position_parameter %} = 'Hub Staff' THEN ${pct_no_show_hours_hub_staff}
          WHEN {% parameter position_parameter %} = 'Ops Associate' THEN ${pct_no_show_hours_ops_associate}
      ELSE NULL
      END ;;
  }

  measure: utr_by_position {
    type: number
    label: "UTR"
    description: "# Orders (Excl. Cancellations) / # Punched Hours"
    value_format_name: decimal_2
    group_label: "> Dynamic Measures"
    sql:
        CASE
          WHEN {% parameter position_parameter %} = 'Rider' THEN ${utr_rider}
          WHEN {% parameter position_parameter %} = 'Picker' THEN ${utr_picker}
          WHEN {% parameter position_parameter %} = 'Ops Associate' THEN ${utr_ops_associate}

      ELSE NULL
      END ;;
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Parameters     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  parameter: position_parameter {
    type: string
    allowed_value: { value: "Rider" }
    allowed_value: { value: "Picker" }
    allowed_value: { value: "Shift Lead" }
    allowed_value: { value: "WH" }
    allowed_value: { value: "Rider Captain" }
    allowed_value: { value: "Ops Associate" }
    allowed_value: { value: "Hub Staff" }
  }
}
