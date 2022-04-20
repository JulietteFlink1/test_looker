view: shyftplan_riders_pickers_hours_clean {
  sql_table_name: `flink-data-prod.reporting.hub_staffing`
    ;;

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # Some of these dimensions are auto-generated by Looker but still being used as dimension.


  dimension: id {
    type: string
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.staffing_uuid ;;
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

  dimension_group: block_starts_at_timestamp {
    type: time
    timeframes: [
      raw,
      time,
      hour_of_day,
      time_of_day,
      minute30,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: yes
    #hidden: yes
    datatype: datetime
    sql: ${TABLE}.block_starts_at_timestamp ;;
  }

  dimension: date {
    label: "Shift starts at"
    type: date
    datatype: date
    sql: ${block_starts_at_timestamp_date} ;;
  }

  dimension: hub_name {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~      Measures      ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  measure: sum_orders{
    type: sum
    label:"# Orders"
    hidden: yes
    description: "Number of Orders from hubs that have worked hours"
    sql:${number_of_orders};;
    filters:[position_name: "rider"]
    value_format_name: decimal_0
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

  measure: count {
    type: count
    drill_fields: [detail*]
    hidden: yes
  }

  ##### Scheduled Hours

  measure: number_of_scheduled_rider_hours {
    label: "# Scheduled Rider Hours"
    description: "# Scheduled Rider Hours (Assigned + Unassigned)"
    group_label: ">> Rider KPIs"
    type: number
    sql: ${number_of_unassigned_rider_hours}+${sum_planned_hours};;
    value_format_name: decimal_1
    #group_label: "Working Hours"
  }

  measure: number_of_scheduled_picker_hours {
    label: "# Scheduled Picker Hours"
    description: "# Scheduled Picker Hours (Assigned + Unassigned)"
    group_label: ">> Picker KPIs"
    type: number
    sql: ${number_of_unassigned_picker_hours}+${sum_planned_picker_hours};;
    value_format_name: decimal_1
    #group_label: "Working Hours"
  }

  measure: number_of_scheduled_shift_lead_hours {
    label: "# Scheduled Shift Lead Hours"
    description: "# Scheduled Shift Lead Hours (Assigned + Unassigned)"
    group_label: ">> Shift Lead KPIs"
    type: number
    sql: ${number_of_unassigned_shift_lead_hours}+${sum_planned_shift_lead_hours};;
    value_format_name: decimal_1
    #group_label: "Working Hours"
  }

  measure: number_of_scheduled_rider_captain_hours {
    label: "# Scheduled Rider Captain Hours"
    description: "# Scheduled Rider Captain Hours (Assigned + Unassigned)"
    group_label: ">> Rider Captain KPIs"
    type: number
    sql: ${number_of_unassigned_rider_captain_hours}+${sum_planned_rider_captain_hours};;
    value_format_name: decimal_1
    #group_label: "Working Hours"
  }

  measure: number_of_scheduled_wh_hours {
    label: "# Scheduled WH Hours"
    description: "# Scheduled WH Hours (Assigned + Unassigned)"
    group_label: ">> WH KPIs"
    type: number
    sql: ${number_of_unassigned_wh_hours}+${sum_planned_wh_hours};;
    value_format_name: decimal_1
    #group_label: "Working Hours"
  }

  ##### % No Show
  measure: pct_no_show_rider{
    label:"% No Show Rider Hours"
    group_label: ">> Rider KPIs"
    type: number
    description: "% No Show Rider Hours"
    sql:(${sum_rider_no_show_hours})/nullif(${sum_planned_hours},0) ;;
    value_format_name: percent_1
  }

  measure: pct_no_show_picker{
    label:"% No Show Picker Hours"
    group_label: ">> Picker KPIs"
    type: number
    description: "% No Show Picker Hours"
    sql:(${sum_picker_no_show_hours})/nullif(${sum_planned_picker_hours},0) ;;
    value_format_name: percent_1
  }

  measure: pct_no_show_shift_lead{
    label:"% No Show Shift Lead Hours"
    group_label: ">> Shift Lead KPIs"
    type: number
    description: "% No Show Shift Lead Hours"
    sql:(${sum_shift_lead_no_show_hours})/nullif(${sum_planned_shift_lead_hours},0) ;;
    value_format_name: percent_1
  }

  measure: pct_no_show_rider_captain{
    label:"% No Show Rider Captain Hours"
    group_label: ">> Rider Captain KPIs"
    type: number
    description: "% No Show Rider Captain Hours"
    sql:(${sum_rider_captain_no_show_hours})/nullif(${sum_planned_rider_captain_hours},0) ;;
    value_format_name: percent_1
  }

  measure: pct_no_show_wh{
    label:"% No Show WH Hours"
    group_label: ">> WH KPIs"
    type: number
    description: "% No Show WH Hours"
    sql:(${sum_wh_no_show_hours})/nullif(${sum_planned_wh_hours},0) ;;
    value_format_name: percent_1
  }

  ##### Worked Hours
  measure: rider_hours {
    label: "# Worked Rider Hours"
    type: sum
    sql:${number_of_worked_minutes}/60;;
    filters: [position_name: "rider"]
    value_format_name: decimal_1
    group_label: ">> Rider KPIs"
    }

  measure: rider_hours_external {
    label: "# Worked Rider Ext Hours"
    type: sum
    sql:${number_of_worked_minutes_external}/60;;
    filters: [position_name: "rider"]
    value_format_name: decimal_1
    group_label: ">> Rider KPIs"
    }

  measure: picker_hours {
    label: "# Worked Picker Hours"
    type: sum
    sql:${number_of_worked_minutes}/60;;
    filters: [position_name: "picker"]
    value_format_name: decimal_1
    group_label: ">> Picker KPIs"
    }

  measure: picker_hours_external {
    label: "# Worked Picker Ext Hours"
    type: sum
    sql:${number_of_worked_minutes_external}/60;;
    filters: [position_name: "picker"]
    value_format_name: decimal_1
    group_label: ">> Picker KPIs"
    }

  measure: shift_lead_hours {
    label: "# Worked Shift Lead Hours"
    type: sum
    sql:${number_of_worked_minutes}/60;;
    filters: [position_name: "shift lead"]
    value_format_name: decimal_1
    group_label: ">> Shift Lead KPIs"

  }

  measure: rider_captain_hours {
    label: "# Worked Rider Captain Hours"
    type: sum
    sql:${number_of_worked_minutes}/60;;
    filters: [position_name: "rider captain"]
    value_format_name: decimal_1
    group_label: ">> Rider Captain KPIs"
    }

  measure: wh_ops_hours {
    label: "# Worked Inventory Associate Hours (Warehouse Ops)"
    type: sum
    sql:${number_of_worked_minutes}/60;;
    filters: [position_name: "wh, wh operations, inventory"]
    value_format_name: decimal_1
    group_label: ">> WH KPIs"
    }

  measure: hub_staff_hours {
    label: "# Worked Hub Staff Hours (Inventory Associate and Picker)"
    type: number
    sql:${picker_hours}+${wh_ops_hours};;
    value_format_name: decimal_1
    group_label: ">> Hub Staff KPIs (Inventory Associate and Picker)"
    }

  ##### No Show Hours
  measure: sum_rider_no_show_hours{
    label:"# No Show Rider Hours"
    group_label: ">> Rider KPIs"
    type: sum
    description: "Sum of No Show Rider Hours"
    sql:${number_of_no_show_minutes}/60;;
    filters: [position_name: "rider"]
    value_format_name: decimal_1
  }

  measure: sum_picker_no_show_hours{
    label:"# No Show Picker Hours"
    group_label: ">> Picker KPIs"
    type: sum
    description: "Sum of No Show Picker Hours"
    sql:${number_of_no_show_minutes}/60;;
    filters: [position_name: "picker"]
    value_format_name: decimal_1
  }

  measure: sum_shift_lead_no_show_hours{
    label:"# No Show Shift Lead Hours"
    group_label: ">> Shift Lead KPIs"
    type: sum
    description: "Sum of No Show Shift Lead Hours"
    sql:${number_of_no_show_minutes}/60;;
    filters: [position_name: "shift lead"]
    value_format_name: decimal_1
  }

  measure: sum_rider_captain_no_show_hours{
    label:"# No Show Rider Captain Hours"
    group_label: ">> Rider Captain KPIs"
    type: sum
    description: "Sum of No Show Rider Captain Hours"
    sql:${number_of_no_show_minutes}/60;;
    filters: [position_name: "rider captain"]
    value_format_name: decimal_1
  }

  measure: sum_wh_no_show_hours{
    label:"# No Show WH Hours"
    type: sum
    group_label: ">> WH KPIs"
    description: "Sum of No Show WH Hours"
    sql:${number_of_no_show_minutes}/60;;
    filters: [position_name: "wh, wh operations, inventory"]
    value_format_name: decimal_1
  }


  ##### Number of Employees

  measure: rider_captain {
    label: "# Rider Captain"
    type: sum
    sql:${number_of_worked_employees};;
    filters: [position_name: "rider captain"]
    group_label: ">> Rider Captain KPIs"
    }


  measure: riders {
    label: "# Riders"
    type: sum
    sql:${number_of_worked_employees};;
    filters: [position_name: "rider"]
    group_label: ">> Rider KPIs"
    }

  measure: riders_external {
    label: "# Ext Riders"
    type: sum
    sql:${number_of_worked_employees_external};;
    filters: [position_name: "rider"]
    group_label: ">> Rider KPIs"
    }

  measure: pickers {
    label: "# Pickers"
    type: sum
    sql:${number_of_worked_employees};;
    filters: [position_name: "picker"]
    group_label: ">> Picker KPIs"
    }

  measure: pickers_external {
    label: "# Ext Pickers"
    type: sum
    sql:${number_of_worked_employees_external};;
    filters: [position_name: "picker"]
    group_label: ">> Picker KPIs"
    }


  measure: shift_orders {
    type: sum
    sql: ${number_of_orders} ;;
    hidden: yes
  }

  measure: adjusted_orders_riders {
    type: sum
    sql:${number_of_orders};;
    filters:[position_name: "rider"]
    hidden: yes
  }

  measure: adjusted_orders_pickers {
    type: sum
    sql:${number_of_orders};;
    filters:[position_name: "picker"]
    hidden: yes
  }

  ##### Unassigned Employees

  measure: sum_unassigned_riders{
    type: sum
    label:"# Unassigned Riders"
    description: "Number of Unassigned Riders"
    filters:[position_name: "rider"]
    sql:${number_of_unassigned_employees_internal}+${number_of_unassigned_employees_external};;
    value_format_name: decimal_1
    group_label: ">> Rider KPIs"
    }

  measure: sum_unassigned_rider_external{
    type: sum
    label:"# Unassigned Ext Riders"
    description: "Number of Unassigned Ext Riders"
    filters:[position_name: "rider"]
    sql:${number_of_unassigned_employees_external};;
    value_format_name: decimal_1
    group_label: ">> Rider KPIs"
    }

  measure: sum_unassigned_pickers{
    type: sum
    label:"# Unassigned Pickers"
    # hidden: yes
    description: "Number of Unassigned Pickers"
    filters:[position_name: "pickers"]
    sql:${number_of_unassigned_employees_internal}+${number_of_unassigned_employees_external};;
    value_format_name: decimal_1
    group_label: ">> Picker KPIs"
    }

  measure: sum_unassigned_pickers_external{
    type: sum
    label:"# Unassigned Ext Pickers"
    # hidden: yes
    description: "Number of Unassigned Ext Pickers"
    filters:[position_name: "pickers"]
    sql:${number_of_unassigned_employees_external};;
    value_format_name: decimal_1
    group_label: ">> Picker KPIs"
    }

  ##### Unassigned Hours

  measure: number_of_unassigned_rider_hours{
    type: sum
    hidden: no
    label:"# Unassigned Rider Hours"
    description: "Number of Unassigned(Open) Rider Hours"
    filters:[position_name: "rider"]
    sql:(${number_of_unassigned_minutes_internal}+${number_of_unassigned_minutes_external})/60;;
    value_format_name: decimal_1
    group_label: ">> Rider KPIs"
    }

  measure: number_of_unassigned_hours_rider_external{
    type: sum
    hidden: yes
    label:"# Unassigned Ext Rider Hours"
    description: "Number of Unassigned(Open) Rider Ext Hours"
    filters:[position_name: "rider"]
    sql:${number_of_unassigned_minutes_external}/60;;
    value_format_name: decimal_1
    group_label: ">> Rider KPIs"
    }


  measure: number_of_unassigned_picker_hours{
    type: sum
    hidden: yes
    label:"# Unassigned Picker Hours"
    description: "Number of Unassigned(Open) Picker Hours"
    filters:[position_name: "picker"]
    sql:(${number_of_unassigned_minutes_internal}+${number_of_unassigned_minutes_external})/60;;
    value_format_name: decimal_1
    group_label: ">> Picker KPIs"
    }

  measure: number_of_unassigned_hours_picker_external{
    type: sum
    hidden: yes
    label:"# Unassigned Ext Picker Hours"
    description: "Number of Unassigned(Open) Picker Ext Hours"
    filters:[position_name: "picker"]
    sql:${number_of_unassigned_minutes_external}/60;;
    value_format_name: decimal_1
    group_label: ">> Picker KPIs"
    }

  measure: number_of_unassigned_shift_lead_hours{
    type: sum
    hidden: no
    label:"# Unassigned Shift Lead Hours"
    group_label: ">> Shift Lead KPIs"
    description: "Number of Unassigned(Open) Shift Lead Hours"
    filters: [position_name: "shift lead"]
    sql:(${number_of_unassigned_minutes_internal}+${number_of_unassigned_minutes_external})/60;;
    value_format_name: decimal_1
  }

  measure: number_of_unassigned_hours_shift_lead_external{
    type: sum
    hidden: yes
    label:"# Unassigned Ext Shift Lead Hours"
    description: "Number of Unassigned(Open) Shift Lead Ext Hours"
    filters:[position_name: "shift lead"]
    sql:${number_of_unassigned_minutes_external}/60;;
    value_format_name: decimal_1
    group_label: ">> Shift Lead KPIs"
    }

  measure: number_of_unassigned_rider_captain_hours{
    type: sum
    hidden: no
    label:"# Unassigned Rider Captain Hours"
    group_label: ">> Rider Captain KPIs"
    description: "Number of Unassigned(Open) Rider Captain Hours"
    filters: [position_name: "rider captain"]
    sql:(${number_of_unassigned_minutes_internal}+${number_of_unassigned_minutes_external})/60;;
    value_format_name: decimal_1
  }

  measure: number_of_unassigned_hours_rider_captain_external{
    type: sum
    hidden: yes
    label:"# Unassigned Ext Rider Captain Hours"
    description: "Number of Unassigned(Open) Rider Captain Ext Hours"
    filters:[position_name: "rider captain"]
    sql:${number_of_unassigned_minutes_external}/60;;
    value_format_name: decimal_1
    group_label: ">> Rider Captain KPIs"

  }

  measure: number_of_unassigned_wh_hours{
    type: sum
    hidden: no
    label:"# Unassigned WH Hours"
    group_label: ">> WH KPIs"
    description: "Number of Unassigned(Open) WH Hours"
    filters: [position_name: "wh, wh operations, inventory"]
    sql:(${number_of_unassigned_minutes_internal}+${number_of_unassigned_minutes_external})/60;;
    value_format_name: decimal_1
  }

  measure: number_of_unassigned_hours_wh_external{
    type: sum
    hidden: yes
    label:"# Unassigned Ext WH Hours"
    description: "Number of Unassigned(Open) WH Ext Hours"
    filters: [position_name: "wh, wh operations, inventory"]
    sql:${number_of_unassigned_minutes_external}/60;;
    value_format_name: decimal_1
    #group_label: "Unassigned Hours"
  }

  ##### UTRs

  measure: rider_utr {
    label: "AVG Rider UTR"
    type: number
    description: "# Orders from opened hub / # Worked Rider Hours"
    sql: ${adjusted_orders_riders} / NULLIF(${rider_hours}, 0);;
    value_format_name: decimal_2
    group_label: ">> Rider KPIs"
    }

  measure: picker_utr {
    label: "AVG Picker UTR"
    type: number
    description: "# Orders from opened hub / # Worked Picker Hours"
    sql: ${adjusted_orders_pickers} / NULLIF(${picker_hours}, 0);;
    value_format_name: decimal_2
    group_label: ">> Picker KPIs"
    }

  measure: hub_staff_utr {
    label: "AVG Hub Staff UTR"
    type: number
    description: "# Orders from opened hub / # Worked Hub Staff (Inventory Associate and Picker) Hours"
    sql: ${adjusted_orders_riders} / NULLIF(${hub_staff_hours}, 0);;
    value_format_name: decimal_2
    group_label: ">> Hub Staff KPIs (Inventory Associate and Picker)"
    }

  measure: wh_ops_utr {
    label: "AVG Inventory Associate UTR"
    type: number
    description: "# Orders from opened hub / # Worked Warehouse Ops Hours"
    sql: ${adjusted_orders_riders} / NULLIF(${wh_ops_hours}, 0);;
    value_format_name: decimal_2
    group_label: ">> WH KPIs"
    }

  set: detail {
    fields: [
      date,
      hub_name
    ]
  }

  measure: number_of_dynamic_target_utr{
    type: min
    label: "Dynamic UTR Target"
    group_label: ">> Rider KPIs"
    description: "Target UTR used in Forecasting Rider Hours"
    sql: ${TABLE}.number_of_target_orders_per_employee ;;
    filters: [position_name: "rider"]
    value_format_name: decimal_2
  }

  measure: sum_forecasted_riders_needed{
    type: sum
    label: "# Forecasted Rider Hours"
    description: "Number of Needed Rider Hours Based on Forecasted Order Demand"
    sql: NULLIF(${TABLE}.number_of_forecasted_employees_needed,0) * 0.5 ;;
    filters: [position_name: "rider"]
    value_format_name: decimal_1
    hidden: yes
    group_label: ">> Rider KPIs"
  }

  measure: sum_forecasted_picker_hours_needed{
    type: sum
    label: "# Forecasted Picker Hours"
    group_label: ">> Picker KPIs"
    description: "Number of Needed Picker Hours Based on Forecasted Order Demand"
    sql: NULLIF(${TABLE}.number_of_forecasted_employees_needed,0) * 0.5 ;;
    filters: [position_name: "picker"]
    value_format_name: decimal_1
    hidden: no
  }

  measure: sum_forecasted_shift_lead_hours_needed{
    type: sum
    label: "# Forecasted Shift Lead Hours"
    group_label: ">> Shift Lead KPIs"
    description: "Number of Needed Shift Lead Hours Based on Forecasted Order Demand"
    sql: NULLIF(${TABLE}.number_of_forecasted_employees_needed,0) * 0.5 ;;
    filters: [position_name: "shift lead"]
    value_format_name: decimal_1
    hidden: no
  }

  measure: sum_forecasted_rider_captain_hours_needed{
    type: sum
    label: "# Forecasted Rider Captain Hours"
    group_label: ">> Rider Captain KPIs"
    description: "Number of Needed Rider Captain Hours Based on Forecasted Order Demand"
    sql: NULLIF(${TABLE}.number_of_forecasted_employees_needed,0) * 0.5 ;;
    filters: [position_name: "rider captain"]
    value_format_name: decimal_1
    hidden: no
  }

  measure: sum_forecasted_wh_hours_needed{
    type: sum
    label: "# Forecasted WH Hours"
    group_label: ">> WH KPIs"
    description: "Number of Needed WH Hours Based on Forecasted Order Demand"
    sql: NULLIF(${TABLE}.number_of_forecasted_employees_needed,0) * 0.5 ;;
    filters: [position_name: "wh, wh operations, inventory"]
    value_format_name: decimal_1
    hidden: no
  }

  measure: sum_rider_hours_needed {
    type: number
    label:"# Actual Needed Rider Hours"
    group_label: ">> Rider KPIs"
    description: "Number of needed hours based on actual order demand"
    sql:ceiling(NULLIF(${sum_orders},0) / nullif(${number_of_dynamic_target_utr},0));;
    value_format_name: decimal_1
  }

  ##### Planned Hours
  measure: sum_planned_hours{
    type: sum
    group_label: ">> Rider KPIs"
    label: "# Assigned Rider Hours"
    description: "Number of Assigned Rider Hours"
    sql: ${number_of_planned_minutes} / 60 ;;
    filters: [position_name: "rider"]
    value_format_name: decimal_1
    hidden: no
  }

  measure: sum_planned_picker_hours{
    type: sum
    label: "# Assigned Picker Hours"
    group_label: ">> Picker KPIs"
    description: "Number of Assigned Picker Hours"
    sql: ${number_of_planned_minutes} / 60 ;;
    filters: [position_name: "picker"]
    value_format_name: decimal_1
    hidden: no
  }

  measure: sum_planned_shift_lead_hours{
    type: sum
    label: "# Assigned Shift Lead Hours"
    group_label: ">> Shift Lead KPIs"
    description: "Number of Assigned Shift Lead Hours"
    sql: ${number_of_planned_minutes} / 60 ;;
    filters: [position_name: "shift lead"]
    value_format_name: decimal_1
    hidden: no
  }

  measure: sum_planned_rider_captain_hours{
    type: sum
    label: "# Assigned Rider Captain Hours"
    group_label: ">> Rider Captain KPIs"
    description: "Number of Assigned Rider Captain Hours"
    sql: ${number_of_planned_minutes} / 60 ;;
    filters: [position_name: "rider captain"]
    value_format_name: decimal_1
    hidden: no
  }

  measure: sum_planned_wh_hours{
    type: sum
    label: "# Assigned WH Hours"
    group_label: ">> WH KPIs"
    description: "Number of Assigned WH Hours"
    sql: ${number_of_planned_minutes} / 60 ;;
    filters: [position_name: "wh"]
    value_format_name: decimal_1
    hidden: no
  }

  ##### Percents

  measure: pct_overstaffing {
    type: number
    group_label: ">> Rider KPIs"
    label:"% Rider Overstaffing"
    description: "When Forecasted Hours < Scheduled Hours: (Forecasted Hours - Scheduled Hours) / Forecasted Hours"
    sql: case
          when ${sum_forecasted_riders_needed} < ${sum_planned_hours}
            then (${sum_forecasted_riders_needed} - ${sum_planned_hours}) / nullif(${sum_forecasted_riders_needed},0)
          else 0 end  ;;
    value_format_name: percent_0
  }

  measure: pct_understaffing {
    type: number
    group_label: ">> Rider KPIs"
    label: "% Rider Understaffing"
    description: "When Forecasted Hours > Scheduled Hours: (Scheduled Hours - Forecasted Hours) / Forecasted Hours"
    sql: case
          when ${sum_forecasted_riders_needed} > ${sum_planned_hours}
            then (${sum_planned_hours} - ${sum_forecasted_riders_needed}) / nullif(${sum_forecasted_riders_needed},0)
          else 0 end  ;;
    value_format_name: percent_0
  }

  measure: pct_picker_understaffing {
    type: number
    group_label: ">> Picker KPIs"
    label: "% Picker Understaffing"
    description: "When Forecasted Hours > Scheduled Hours: (Scheduled Hours - Forecasted Hours) / Forecasted Hours"
    sql: case
          when ${sum_forecasted_picker_hours_needed} > ${sum_planned_picker_hours}
            then (${sum_planned_picker_hours} - ${sum_forecasted_picker_hours_needed}) / nullif(${sum_forecasted_picker_hours_needed},0)
          else 0 end  ;;
    value_format_name: percent_0
  }

  measure: pct_picker_overstaffing {
    type: number
    group_label: ">> Picker KPIs"
    label: "% Picker Overstaffing"
    description: "When Forecasted Hours < Scheduled Hours: (Scheduled Hours - Forecasted Hours) / Forecasted Hours"
    sql: case
          when ${sum_forecasted_picker_hours_needed} < ${sum_planned_picker_hours}
            then (${sum_planned_picker_hours} - ${sum_forecasted_picker_hours_needed}) / nullif(${sum_forecasted_picker_hours_needed},0)
          else 0 end  ;;
    value_format_name: percent_0
  }

  measure: pct_forecast_deviation {
    type: number
    group_label: ">> Rider KPIs"
    label: "% Forecast Deviation "
    description: "Actual Orders - Forecasted Orders / Actual Orders"
    sql: abs((${adjusted_orders_riders}-${sum_predicted_orders}) / nullif(${adjusted_orders_riders},0)) ;;
    value_format_name: percent_0
  }

  measure: pct_staffing_efficiency {
    type: number
    group_label: ">> Rider KPIs"
    label: "% Staffing Efficiency (Post Adjustments) "
    description: "ABS(Planned_Hours - Forecasted_Hours)/Total Forecasted Hours"
    sql: abs((${assigned_hours_by_position}-${forecasted_hours_by_position}) / nullif(${forecasted_hours_by_position},0)) ;;
    value_format_name: percent_0
  }

  measure: pct_picker_forecast_deviation {
    type: number
    group_label: ">> Picker KPIs"
    label: "% Forecast Deviation "
    description: "absolute (Forecasted Orders / Actual Orders)"
    sql: abs((${adjusted_orders_pickers}-${sum_predicted_picker_orders}) / nullif(${adjusted_orders_pickers},0)) ;;
    value_format_name: percent_0
  }

  ##### Predicted Orders

  measure: sum_predicted_orders{
    type: sum
    label: "# Forecasted Orders"
    group_label: ">> Rider KPIs"
    description: "Number of Forecasted Orders"
    sql: ${TABLE}.number_of_predicted_orders ;;
    value_format_name: decimal_0
    filters: [position_name: "rider"]
    hidden: no
  }

  measure: sum_predicted_picker_orders{
    type: sum
    label: "# Forecasted Orders"
    group_label: ">> Picker KPIs"
    description: "Number of Forecasted Orders"
    sql: ${TABLE}.number_of_predicted_orders ;;
    value_format_name: decimal_0
    filters: [position_name: "picker"]
    hidden: no
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

  }

  measure: forecasted_hours_by_position {
    type: number
    label: "# Forecasted Hours"
    group_label: ">> Dynamic Values"
    value_format_name: decimal_1
    sql:
        CASE
          WHEN {% parameter position_parameter %} = 'Rider' THEN ${sum_forecasted_riders_needed}
          WHEN {% parameter position_parameter %} = 'Picker' THEN ${sum_forecasted_picker_hours_needed}
          WHEN {% parameter position_parameter %} = 'Shift Lead' THEN ${sum_forecasted_shift_lead_hours_needed}
          WHEN {% parameter position_parameter %} = 'Rider Captain' THEN ${sum_forecasted_rider_captain_hours_needed}
          WHEN {% parameter position_parameter %} = 'WH' THEN ${sum_forecasted_wh_hours_needed}
          ELSE NULL
        END ;;
  }

  measure: assigned_hours_by_position {
    type: number
    label: "# Assigned Hours"
    value_format_name: decimal_1
    group_label: ">> Dynamic Values"
    sql:
        CASE
          WHEN {% parameter position_parameter %} = 'Rider' THEN ${sum_planned_hours}
          WHEN {% parameter position_parameter %} = 'Picker' THEN ${sum_planned_picker_hours}
          WHEN {% parameter position_parameter %} = 'Shift Lead' THEN ${sum_planned_shift_lead_hours}
          WHEN {% parameter position_parameter %} = 'Rider Captain' THEN ${sum_planned_rider_captain_hours}
          WHEN {% parameter position_parameter %} = 'WH' THEN ${sum_planned_wh_hours}
          ELSE NULL
        END ;;
  }

  measure: unassigned_hours_by_position {
    type: number
    label: "# Unassigned Hours"
    value_format_name: decimal_1
    group_label: ">> Dynamic Values"
    sql:
        CASE
          WHEN {% parameter position_parameter %} = 'Rider' THEN ${number_of_unassigned_rider_hours}
          WHEN {% parameter position_parameter %} = 'Picker' THEN ${number_of_unassigned_picker_hours}
          WHEN {% parameter position_parameter %} = 'Shift Lead' THEN ${number_of_unassigned_shift_lead_hours}
          WHEN {% parameter position_parameter %} = 'Rider Captain' THEN ${number_of_unassigned_rider_captain_hours}
          WHEN {% parameter position_parameter %} = 'WH' THEN ${number_of_unassigned_wh_hours}
          ELSE NULL
        END ;;
  }

  measure: worked_hours_by_position {
    type: number
    label: "# Worked Hours"
    value_format_name: decimal_1
    group_label: ">> Dynamic Values"
    sql:
        CASE
          WHEN {% parameter position_parameter %} = 'Rider' THEN ${rider_hours}
          WHEN {% parameter position_parameter %} = 'Picker' THEN ${picker_hours}
          WHEN {% parameter position_parameter %} = 'Shift Lead' THEN ${shift_lead_hours}
          WHEN {% parameter position_parameter %} = 'Rider Captain' THEN ${rider_captain_hours}
          WHEN {% parameter position_parameter %} = 'WH' THEN ${wh_ops_hours}
          ELSE NULL
        END ;;
  }

  measure: pct_no_show_by_position {
    type: number
    label: "% No Show"
    value_format_name: percent_1
    group_label: ">> Dynamic Values"
    sql:
        CASE
          WHEN {% parameter position_parameter %} = 'Rider' THEN ${pct_no_show_rider}
          WHEN {% parameter position_parameter %} = 'Picker' THEN ${pct_no_show_picker}
          WHEN {% parameter position_parameter %} = 'Shift Lead' THEN ${pct_no_show_shift_lead}
          WHEN {% parameter position_parameter %} = 'Rider Captain' THEN ${pct_no_show_rider_captain}
          WHEN {% parameter position_parameter %} = 'WH' THEN ${pct_no_show_wh}
          ELSE NULL
        END ;;
  }

  measure: scheduled_hours_by_position {
    type: number
    label: "# Scheduled Hours"
    value_format_name: decimal_1
    group_label: ">> Dynamic Values"
    sql:
        CASE
          WHEN {% parameter position_parameter %} = 'Rider' THEN ${number_of_scheduled_rider_hours}
          WHEN {% parameter position_parameter %} = 'Picker' THEN ${number_of_scheduled_picker_hours}
          WHEN {% parameter position_parameter %} = 'Shift Lead' THEN ${number_of_scheduled_shift_lead_hours}
          WHEN {% parameter position_parameter %} = 'Rider Captain' THEN ${number_of_scheduled_rider_captain_hours}
          WHEN {% parameter position_parameter %} = 'WH' THEN ${number_of_scheduled_wh_hours}
          ELSE NULL
        END ;;
  }

  measure: utr_by_position {
    type: number
    label: "UTR"
    value_format_name: decimal_2
    group_label: ">> Dynamic Values"
    sql:
        CASE
          WHEN {% parameter position_parameter %} = 'Rider' THEN ${rider_utr}
          WHEN {% parameter position_parameter %} = 'Picker' THEN ${picker_utr}
          ELSE NULL
        END ;;
  }

  measure: forecasted_orders_by_position {
    type: number
    label: "# Forecasted Orders"
    value_format_name: decimal_2
    group_label: ">> Dynamic Values"
    sql:
        CASE
          WHEN {% parameter position_parameter %} = 'Rider' THEN ${sum_predicted_orders}
          WHEN {% parameter position_parameter %} = 'Picker' THEN ${sum_predicted_picker_orders}
          ELSE NULL
        END ;;
  }

  measure: forecast_deviation_by_position {
    type: number
    label: "% Forecast Deviation"
    value_format_name: percent_1
    group_label: ">> Dynamic Values"
    sql:
        CASE
          WHEN {% parameter position_parameter %} = 'Rider' THEN ${pct_forecast_deviation}
          WHEN {% parameter position_parameter %} = 'Picker' THEN  ${pct_picker_forecast_deviation}
          ELSE NULL
        END ;;
  }

  measure: understaffing_by_position {
    type: number
    label: "% Understaffing"
    value_format_name: percent_1
    group_label: ">> Dynamic Values"
    sql:
        CASE
          WHEN {% parameter position_parameter %} = 'Rider' THEN ${pct_understaffing}
          WHEN {% parameter position_parameter %} = 'Picker' THEN  ${pct_picker_understaffing}
        END ;;
  }

  measure: needed_hours_by_position {
    type: number
    label: "# Actually Needed Hours"
    value_format_name: decimal_1
    group_label: ">> Dynamic Values"
    sql:
        CASE
          WHEN {% parameter position_parameter %} = 'Rider' THEN ${sum_rider_hours_needed}
        END ;;
  }

  measure: overstaffing_by_position {
    type: number
    label: "% Overstaffing"
    value_format_name: percent_1
    group_label: ">> Dynamic Values"
    sql:
        CASE
          WHEN {% parameter position_parameter %} = 'Rider' THEN ${pct_overstaffing}
          WHEN {% parameter position_parameter %} = 'Picker' THEN  ${pct_picker_overstaffing}
        END ;;
  }

}
