view: shyftplan_riders_pickers_hours_clean {
  sql_table_name: `flink-data-prod.reporting.daily_hub_staffing`
    ;;

  dimension: id {
    type: string
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.daily_staffing_uuid ;;
  }


  dimension: number_of_orders {
    hidden: yes
    type: number
    sql: ${TABLE}.number_of_orders ;;
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

  dimension: number_of_worked_minutes {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_worked_minutes ;;
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

  dimension: number_of_no_show_minutes_external {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_no_show_minutes_external ;;
  }

  dimension: number_of_planned_employees {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_planned_employees ;;
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
    hidden: yes
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
    hidden: no
    datatype: date
    sql: ${TABLE}.shift_date ;;
  }


  measure: sum_orders{
    type: sum
    label:"# Orders"
    hidden: yes
    description: "Number of Orders from hubs that have worked hours"
    sql:${number_of_orders};;
    filters:[position_name: "picker"]
    value_format_name: decimal_0
  }


  dimension: date {
    label: "Shift starts at"
    type: date
    datatype: date
    sql: ${TABLE}.shift_date ;;
  }

  dimension: hub_name {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  #dimension: rider_hours {
  #  type: number
  #  sql: ${TABLE}.rider_hours ;;
  #}

  #dimension: riders {
  #  type: number
  #  sql: ${TABLE}.riders ;;
  #}

  #dimension: picker_hours {
  #  type: number
  #  sql: ${TABLE}.picker_hours ;;
  #}

  #dimension: pickers {
  #  type: number
  #  sql: ${TABLE}.pickers ;;
  #}

  ######## Measures

  measure: count {
    type: count
    drill_fields: [detail*]
    hidden: yes
  }

  measure: rider_hours {
    label: "Sum of Rider Hours"
    type: sum
    sql:${number_of_worked_minutes}/60;;
    filters: [position_name: "rider"]
    value_format_name: decimal_1
    group_label: "Working Hours"
  }

  measure: rider_captain {
    label: "# Rider Captain"
    type: sum
    sql:${number_of_worked_employees};;
    filters: [position_name: "rider captain"]
    group_label: "Counts"
  }


  measure: rider_captain_hours {
    label: "Sum of Rider Captain Hours"
    type: sum
    sql:${number_of_worked_minutes}/60;;
    filters: [position_name: "rider captain"]
    value_format_name: decimal_1
    group_label: "Working Hours"
  }

  measure: riders {
    label: "# Riders"
    type: sum
    sql:${number_of_worked_employees};;
    filters: [position_name: "rider"]
    group_label: "Counts"
  }

  measure: ops_associates {
    label: "# Ops Associates"
    type: sum
    sql:${number_of_worked_employees};;
    filters: [position_name: "ops associate"]
    group_label: "Counts"
  }

  measure: ops_associates_external {
    label: "# Ops Associates"
    type: sum
    sql:${number_of_worked_employees_external};;
    filters: [position_name: "ops associate"]
    group_label: "Counts"
  }

  measure: riders_external {
    label: "# Ext Riders"
    type: sum
    sql:${number_of_worked_employees_external};;
    filters: [position_name: "rider"]
    group_label: "Counts"
  }

  measure: picker_hours {
    label: "Sum of Picker Hours"
    type: sum
    sql:${number_of_worked_minutes}/60;;
    filters: [position_name: "picker"]
    value_format_name: decimal_1
    group_label: "Working Hours"
  }

  measure: wh_ops_hours {
    label: "Sum of Inventory Associate Hours (Warehouse Ops)"
    type: sum
    sql:${number_of_worked_minutes}/60;;
    filters: [position_name: "wh, wh operations, inventory"]
    value_format_name: decimal_1
    group_label: "Working Hours"
  }

  measure: hub_staff_hours {
    label: "Sum of Hub Staff Hours (Inventory Associate, Picker, Rider Captains, Ops Associate and shift Lead)"
    type: number
    sql: ${ops_associate_hours}+${shift_lead_hours};;
    value_format_name: decimal_1
    group_label: "Working Hours"
  }

  measure: ops_associate_hours {
    alias: [ops_staff_hours]
    label: "Sum of Ops Associate Hours (Inventory Associate, Picker, Ops Associate and  Rider Captain)"
    type: sum
    sql:${number_of_worked_minutes}/60;;
    filters: [position_name: "ops associate"]
    value_format_name: decimal_1
    group_label: "Working Hours"
  }

  measure: picker_hours_external {
    label: "Sum of Picker Ext Hours"
    type: sum
    sql:${number_of_worked_minutes_external}/60;;
    filters: [position_name: "picker"]
    value_format_name: decimal_1
    group_label: "Working Hours"
  }

  measure: rider_hours_external {
    label: "Sum of Rider Ext Hours"
    type: sum
    sql:${number_of_worked_minutes_external}/60;;
    filters: [position_name: "rider"]
    value_format_name: decimal_1
    group_label: "Working Hours"
  }

  measure: pickers {
    label: "# Pickers"
    type: sum
    sql:${number_of_worked_employees};;
    filters: [position_name: "picker"]
    group_label: "Counts"
  }

  measure: pickers_external {
    label: "# Ext Pickers"
    type: sum
    sql:${number_of_worked_employees_external};;
    filters: [position_name: "picker"]
    group_label: "Counts"
  }

  measure: shift_orders {
    type: sum
    sql: ${number_of_orders} ;;
    hidden: yes
  }

  # Excluding Click & Collect and Ubereats orders
  measure: adjusted_orders_riders {
    type: sum
    sql:${number_of_orders};;
    filters:[position_name: "rider"]
    hidden: yes
  }

  # Including Click & Collect and Ubereats orders
  measure: adjusted_orders_pickers {
    type: sum
    sql:${number_of_orders};;
    filters:[position_name: "picker"]
    hidden: yes
  }

  measure: sum_unassigned_riders{
    type: sum
    label:"# Unassigned Riders"
    description: "Number of Unassigned Riders"
    filters:[position_name: "rider"]
    sql:${number_of_unassigned_employees_internal}+${number_of_unassigned_employees_external};;
    value_format_name: decimal_1
    group_label: "Unassigned Hours"
  }

  measure: sum_unassigned_ops_associates{
    type: sum
    label:"# Unassigned Ops Associates"
    description: "Number of Unassigned Ops Associates"
    filters:[position_name: "ops associate"]
    sql:${number_of_unassigned_employees_internal}+${number_of_unassigned_employees_external};;
    value_format_name: decimal_1
    group_label: "Unassigned Hours"
  }

  measure: sum_unassigned_rider_external{
    type: sum
    label:"# Unassigned Ext Riders"
    description: "Number of Unassigned Ext Riders"
    filters:[position_name: "rider"]
    sql:${number_of_unassigned_employees_external};;
    value_format_name: decimal_1
    group_label: "Counts"
  }

  measure: sum_unassigned_ops_associates_external{
    type: sum
    label:"# Unassigned Ext Ops Associates"
    description: "Number of Unassigned Ops Associates"
    filters:[position_name: "ops associate"]
    sql: ${number_of_unassigned_employees_external};;
    value_format_name: decimal_1
    group_label: "Counts"
  }

  measure: sum_unassigned_pickers{
    type: sum
    label:"# Unassigned Pickers"
    # hidden: yes
    description: "Number of Unassigned Pickers"
    filters:[position_name: "pickers"]
    sql:${number_of_unassigned_employees_internal}+${number_of_unassigned_employees_external};;
    value_format_name: decimal_1
    group_label: "Counts"
  }

  measure: sum_unassigned_pickers_external{
    type: sum
    label:"# Unassigned Ext Pickers"
    # hidden: yes
    description: "Number of Unassigned Ext Pickers"
    filters:[position_name: "pickers"]
    sql:${number_of_unassigned_employees_external};;
    value_format_name: decimal_1
    group_label: "Counts"
  }

  measure: number_of_unassigned_rider_hours{
    type: sum
    label:"# Unassigned Rider Hours"
    description: "Number of Unassigned(Open) Rider Hours"
    filters:[position_name: "rider"]
    sql:(${number_of_unassigned_minutes_internal}+${number_of_unassigned_minutes_external})/60;;
    value_format_name: decimal_1
    group_label: "Unassigned Hours"
  }

  measure: number_of_unassigned_ops_associate_hours{
    type: sum
    label:"# Unassigned Ops Associate Hours"
    description: "Number of Unassigned(Open) Ops Associate Hours"
    filters:[position_name: "ops associate"]
    sql:(${number_of_unassigned_minutes_internal}+${number_of_unassigned_minutes_external})/60;;
    value_format_name: decimal_1
    group_label: "Unassigned Hours"
  }

  measure: number_of_unassigned_hours_rider_external{
    type: sum
    hidden: yes
    label:"# Unassigned Ext Rider Hours"
    description: "Number of Unassigned(Open) Rider Ext Hours"
    filters:[position_name: "rider"]
    sql:${number_of_unassigned_minutes_external}/60;;
    value_format_name: decimal_1
    group_label: "Unassigned Hours"
  }

  measure: number_of_unassigned_hours_ops_associate_external{
    type: sum
    hidden: yes
    label:"# Unassigned Ext Ops Associate Hours"
    description: "Number of Unassigned(Open) Ops Associate Ext Hours"
    filters:[position_name: "ops associate"]
    sql:${number_of_unassigned_minutes_external}/60;;
    value_format_name: decimal_1
    group_label: "Unassigned Hours"
  }

  measure: number_of_unassigned_hours_ops_associate{
    type: sum
    hidden: yes
    label:"# Unassigned Ops Associate Hours"
    description: "Number of Unassigned(Open) Ops Associate Hours"
    filters:[position_name: "ops associate"]
    sql:(${number_of_unassigned_minutes_internal}+${number_of_unassigned_minutes_external})/60;;
    value_format_name: decimal_1
    group_label: "Unassigned Hours"
  }

  measure: number_of_unassigned_picker_hours{
    type: sum
    label:"# Unassigned Picker Hours"
    description: "Number of Unassigned(Open) Picker Hours"
    filters:[position_name: "picker"]
    sql:(${number_of_unassigned_minutes_internal}+${number_of_unassigned_minutes_external})/60;;
    value_format_name: decimal_1
    group_label: "Unassigned Hours"
  }

  measure: number_of_unassigned_hours_picker_external{
    type: sum
    hidden: yes
    label:"# Unassigned Ext Picker Hours"
    description: "Number of Unassigned(Open) Picker Ext Hours"
    filters:[position_name: "picker"]
    sql:${number_of_unassigned_minutes_external}/60;;
    value_format_name: decimal_1
    group_label: "Unassigned Hours"
  }


  measure: sum_assigned_rider_hours{
    type: sum
    label:"# Scheduled Rider Hours"
    description: "Number of Scheduled Rider Hours"
    sql:${number_of_planned_minutes}/60;;
    filters:[position_name: "rider"]
    value_format_name: decimal_1
    group_label: "Assigned Hours"
  }

  measure: sum_assigned_ops_associate_hours{
    type: sum
    label:"# Scheduled Ops Associate Hours"
    description: "Number of Scheduled Ops Associate Hours"
    sql:${number_of_planned_minutes}/60;;
    filters:[position_name: "ops associate"]
    value_format_name: decimal_1
    group_label: "Assigned Hours"
  }

  measure: sum_assigned_picker_hours{
    type: sum
    label:"# Scheduled Picker Hours"
    description: "Number of Scheduled Picker Hours"
    sql:${number_of_planned_minutes}/60;;
    filters:[position_name: "picker"]
    value_format_name: decimal_1
    group_label: "Assigned Hours"
  }


  measure: rider_utr {
    label: "AVG Rider UTR"
    type: number
    description: "# Orders from opened hub / # Worked Rider Hours"
    sql: ${adjusted_orders_riders} / NULLIF(${rider_hours}, 0);;
    value_format_name: decimal_2
    group_label: "UTR"
  }

  measure: rider_rider_cap_utr {
    label: "AVG Rider UTR (incl. Rider Captains)"
    type: number
    description: "# Orders from opened hub / # Worked Rider Hours (incl. Rider Captains)"
    sql: ${adjusted_orders_riders} / NULLIF(${rider_hours}+${rider_captain_hours}, 0);;
    value_format_name: decimal_2
    group_label: "UTR"
  }

  measure: picker_utr {
    label: "AVG Picker UTR"
    type: number
    description: "# Orders from opened hub / # Worked Picker Hours"
    sql: ${adjusted_orders_pickers} / NULLIF(${picker_hours}, 0);;
    value_format_name: decimal_2
    group_label: "UTR"
  }

  measure: hub_staff_utr {
    label: "AVG Hub Staff UTR"
    type: number
    description: "# Orders from opened hub / # Worked Hub (Inventory Associate, Picker, Rider Captains and shift Lead) Hours"
    sql: ${adjusted_orders_pickers} / NULLIF(${hub_staff_hours}, 0);;
    value_format_name: decimal_2
    group_label: "UTR"
  }

  measure: ops_associate_utr {
    alias: [ops_staff_utr]
    label: "AVG Ops Associate UTR"
    type: number
    description: "# Orders from opened hub / # Worked Ops Staff (Inventory Associate, Picker, Ops Associate and Rider Captains) Hours"
    sql: ${adjusted_orders_pickers} / NULLIF(${ops_associate_hours}, 0);;
    value_format_name: decimal_2
    group_label: "UTR"
  }

  measure: wh_ops_utr {
    label: "AVG Inventory Associate UTR"
    type: number
    description: "# Orders from opened hub / # Worked Warehouse Ops Hours"
    sql: ${adjusted_orders_pickers} / NULLIF(${wh_ops_hours}, 0);;
    value_format_name: decimal_2
    group_label: "UTR"
  }

  measure: rider_captain_utr {
    label: "AVG Rider Captain UTR"
    type: number
    description: "# Orders from opened hub / # Worked Rider Captain Hours"
    sql: ${adjusted_orders_riders} / NULLIF(${rider_captain_hours}, 0);;
    value_format_name: decimal_2
    group_label: "UTR"
  }

  set: detail {
    fields: [
      date,
      hub_name
    ]
  }

  measure: sum_planned_hours{
    type: sum
    label: "# Scheduled Hours Rider"
    description: "Number of Scheduled Hours Rider"
    sql: ${number_of_planned_minutes} / 60 ;;
    filters: [position_name: "rider"]
    value_format_name: decimal_1
    hidden: yes
  }

  measure: shift_lead_hours {
    label: "Sum of Shift Lead Hours"
    type: sum
    description: "Number of shift lead Wroked Hours (note: shift lead dont punch in/out and they get paid on monthly basis, therefore we need to consider worked hours = planned hours)"
    sql:${number_of_planned_minutes}/60;;
    filters: [position_name: "shift lead"]
    value_format_name: decimal_1
    group_label: "Working Hours"
  }

  measure: number_of_planned_hours_rider_picker{
    type: sum
    label: "# Scheduled Hours Rider+Picker"
    description: "Number of Scheduled Hours Rider+Picker"
    sql: ${number_of_planned_minutes} / 60 ;;
    filters: [position_name: "rider, picker"]
    value_format_name: decimal_1
    hidden: yes
  }

  measure: number_of_planned_hours_hub_employees{
    type: sum
    label: "# Scheduled Hours Rider + Picker + WH + Rider Captain + Ops Associate"
    description: "Number of Scheduled Hours Rider + Picker + WH + Rider Captain + Ops Associate"
    sql: ${number_of_planned_minutes} / 60 ;;
    filters: [position_name: "rider, picker,wh, rider captain, 'ops associate"]
    value_format_name: decimal_1
    hidden: no
    group_label: "Assigned Hours"
  }

  measure: number_of_planned_hours_ops_associate{
    type: sum
    label: "# Scheduled Hours Picker + WH + Rider Captain + Ops Associate"
    description: "Number of Scheduled Hours Picker + WH + Rider Captain + Ops Associate"
    sql: ${number_of_planned_minutes} / 60 ;;
    filters: [position_name: "picker,wh, rider captain, 'ops associate"]
    value_format_name: decimal_1
    hidden: no
    group_label: "Assigned Hours"
  }

  measure: all_staff_utr {
    label: "AVG All Staff UTR"
    type: number
    description: "# Orders from opened hub / # Worked All Staff (incl. Rider,Picker,WH Ops, Rider Captain, Ops Associate and Shift Lead) Hours"
    sql: ${adjusted_orders_pickers} / NULLIF(${rider_hours}+${picker_hours}+${wh_ops_hours}+${shift_lead_hours}+${rider_captain_hours}+${ops_associate_hours}, 0);;
    value_format_name: decimal_2
    group_label: "UTR"
  }

  measure: number_of_unassigned_hours_rider_picker{
    type: number
    label: "# Unassigned Hours Rider+Picker"
    description: "Number of Unassigned Hours Rider+Picker"
    sql: ${number_of_unassigned_rider_hours}+${number_of_unassigned_picker_hours} ;;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: pct_unassigned_hours{
    label:"% Unassigned Shift Hours (Riders & Pickers)"
    alias: [pct_unaasigned_hours]
    type: number
    description: "% Unassigned Shift Hours (Riders & Pickers)"
    sql:(${number_of_unassigned_hours_rider_picker})
      /nullif(${number_of_unassigned_hours_rider_picker}+${number_of_planned_hours_rider_picker},0) ;;
    group_label: "Unassigned Hours"
    value_format_name: percent_1
  }

  measure: pct_unassigned_rider_hours{
    label:"% Unassigned Rider Hours"
    type: number
    description: "Share of Unassigned rider hours from total Scheduled hours - Unassigned Rider Hours / (Assigned Rider Hours + Unassigned Rider Hours)"
    sql:(${number_of_unassigned_rider_hours})
      /nullif(${number_of_unassigned_rider_hours}+${sum_assigned_rider_hours},0) ;;
    group_label: "Unassigned Hours"
    value_format_name: percent_1
  }

  measure: pct_assigned_rider_hours{
    label:"% Assigned Rider Hours"
    type: number
    description: "Share of Assigned rider hours from total Scheduled hours - Assigned Rider Hours / (Assigned Rider Hours + Unassigned Rider Hours)"
    sql:(${sum_assigned_rider_hours})
      /nullif(${number_of_unassigned_rider_hours}+${sum_assigned_rider_hours},0) ;;
    group_label: "Assigned Hours"
    value_format_name: percent_1
  }

  measure: pct_unassigned_picker_hours{
    label:"% Unassigned Picker Hours"
    type: number
    description: "Share of Unassigned picker hours from total Scheduled hours - Unassigned Picker Hours / (Assigned Picker Hours + Unassigned Picker Hours)"
    sql:(${number_of_unassigned_picker_hours})
      /nullif(${number_of_unassigned_picker_hours}+${sum_assigned_picker_hours},0) ;;
    group_label: "Unassigned Hours"
    value_format_name: percent_1
  }

  measure: pct_assigned_picker_hours{
    label:"% Assigned Picker Hours"
    type: number
    description: "Share of Assigned picker hours from total Scheduled hours - Assigned Picker Hours / (Assigned Picker Hours + Unassigned Picker Hours)"
    sql:(${sum_assigned_picker_hours})
      /nullif(${number_of_unassigned_picker_hours}+${sum_assigned_picker_hours},0) ;;
    group_label: "Assigned Hours"
    value_format_name: percent_1
  }

  measure: pct_unaasigned_hours_ops_associate{
    label:"% Unassigned Shift Hours (Ops Associate)"
    type: number
    description: "% Unassigned Shift Hours (Ops Associate)"
    sql:(${number_of_unassigned_hours_ops_associate})
      /nullif(${number_of_planned_hours_ops_associate},0) ;;
    group_label: "Unassigned Hours"
    value_format_name: percent_1
  }

  measure: sum_no_show_hours{
    label:"Sum Rider Actual No Show Hours"
    type: sum
    description: "Sum Rider Actual No Show Hours"
    sql:${number_of_no_show_minutes}/60;;
    filters: [position_name: "rider"]
    group_label: "No Show"
    value_format_name: decimal_1
  }

  measure: number_of_no_show_hours_rider_picker{
    label:"Sum Rider+Picker No Show Hours"
    type: sum
    description: "Sum Rider+Picker No Show Hours"
    sql:${number_of_no_show_minutes}/60;;
    filters: [position_name: "rider, picker"]
    group_label: "No Show"
    value_format_name: decimal_1
  }


  measure: number_of_no_show_hours_hub_employees{
    label:"Sum Rider + Picker + WH + Rider Captain + Ops Associate No Show Hours"
    type: sum
    description: "Sum Rider + Picker + WH + Rider Captain + Ops Associate No Show Hours"
    sql:${number_of_no_show_minutes}/60;;
    filters: [position_name: "rider, picker,wh, rider captain, ops associate"]
    group_label: "No Show"
    value_format_name: decimal_1
  }

  measure: number_of_no_show_hours_ops_associate{
    label:"Sum Picker + WH + Rider Captain + Ops Associate No Show Hours"
    type: sum
    description: "Sum Picker + WH + Rider Captain + Ops Associate No Show Hours"
    sql:${number_of_no_show_minutes}/60;;
    filters: [position_name: "rider, picker,wh, rider captain, ops associate"]
    group_label: "No Show"
    value_format_name: decimal_1
  }

  measure: pct_no_show_employees{
    label:"% Actual No Show Rider Hours"
    type: number
    description: "% Actual No Show Rider Hours"
    sql:(${sum_no_show_hours})/nullif(${sum_planned_hours},0) ;;
    group_label: "No Show"
    value_format_name: percent_1
  }

  measure: pct_no_show_hours_rider_picker{
    label:"% Actual No Show Rider+Picker Hours"
    type: number
    description: "% Actual No Show Rider + Picker Hours"
    sql:(${number_of_no_show_hours_rider_picker})/nullif(${number_of_planned_hours_rider_picker},0) ;;
    group_label: "No Show"
    value_format_name: percent_1
  }

  measure: pct_no_show_hours_hub_employees{
    label:"% Actual No Show Rider + Picker + WH +Rider Captain + Ops Associate Hours"
    type: number
    description: "% Actual No Show Rider + Picker + WH +Rider Captain + Ops Associate Hours"
    sql:(${number_of_no_show_hours_hub_employees})/nullif(${number_of_planned_hours_hub_employees},0) ;;
    group_label: "No Show"
    value_format_name: percent_1
  }

  measure: pct_no_show_hours_ops_associate{
    label:"% Actual No Show Picker + WH + Rider Captain + Ops Associate Hours"
    type: number
    description: "% Actual No Show Picker + WH +Rider Captain + Ops Associate Hours"
    sql:(${number_of_no_show_hours_ops_associate})/nullif(${number_of_planned_hours_hub_employees},0) ;;
    group_label: "No Show"
    value_format_name: percent_1
  }

  measure: pct_external_hours_rider_picker{
    label:"% External Hours Rider+Picker"
    type: number
    description: "% Hours Worked by External Rides + Pickers"
    sql:(${picker_hours_external}+${rider_hours_external})/nullif((${rider_hours}+${picker_hours}),0) ;;
    group_label: "Working Hours"
    value_format_name: percent_1
  }

  measure: pct_rider_idle_time {
    group_label: "Rider Performance"
    label: "% Worked Time Spent Idle (Riders)"
    description: "% of worked time (min) not spent handling an order - compares the difference between worked time (min) and rider handling time (min) with total worked time (min)"
    hidden:  no
    type: number
    sql: ${employee_level_kpis.pct_rider_idle_time};;
    value_format: "0%"
  }

  measure: rider_utr_cleaned {
    label: "AVG Rider UTR (Orders Delivered by Riders)"
    type: number
    description: "# Orders Delivered by Riders/# Worked Rider Hours"
    sql: ${employee_level_kpis.number_of_delivered_orders_by_riders}/nullif(${rider_hours},0) ;;
    value_format_name: decimal_2
    group_label: "UTR"
  }

}
