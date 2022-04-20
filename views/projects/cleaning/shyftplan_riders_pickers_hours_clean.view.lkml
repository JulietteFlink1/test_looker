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
    hidden: yes
    datatype: date
    sql: ${TABLE}.shift_date ;;
  }


  measure: sum_orders{
    type: sum
    label:"# Orders"
    hidden: yes
    description: "Number of Orders from hubs that have worked hours"
    sql:${number_of_orders};;
    filters:[position_name: "rider"]
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
    label: "Sum of Hub Staff Hours (Inventory Associate and Picker)"
    type: number
    sql:${picker_hours}+${wh_ops_hours};;
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

  measure: sum_unassigned_riders{
    type: sum
    label:"# Unassigned Riders"
    description: "Number of Unassigned Riders"
    filters:[position_name: "rider"]
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
    hidden: yes
    label:"# Unassigned Rider Hours"
    description: "Number of Unassigned(Open) Rider Hours"
    filters:[position_name: "rider"]
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


  measure: number_of_unassigned_picker_hours{
    type: sum
    hidden: yes
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


  measure: rider_utr {
    label: "AVG Rider UTR"
    type: number
    description: "# Orders from opened hub / # Worked Rider Hours"
    sql: ${adjusted_orders_riders} / NULLIF(${rider_hours}, 0);;
    value_format_name: decimal_2
    group_label: "UTR"
  }

  measure: picker_utr {
    label: "AVG Picker UTR"
    type: number
    description: "# Orders from opened hub / # Worked Picker Hours"
    sql: ${adjusted_orders_riders} / NULLIF(${picker_hours}, 0);;
    value_format_name: decimal_2
    group_label: "UTR"
  }

  measure: hub_staff_utr {
    label: "AVG Hub Staff UTR"
    type: number
    description: "# Orders from opened hub / # Worked Hub Staff (Inventory Associate and Picker) Hours"
    sql: ${adjusted_orders_riders} / NULLIF(${hub_staff_hours}, 0);;
    value_format_name: decimal_2
    group_label: "UTR"
  }

  measure: wh_ops_utr {
    label: "AVG Inventory Associate UTR"
    type: number
    description: "# Orders from opened hub / # Worked Warehouse Ops Hours"
    sql: ${adjusted_orders_riders} / NULLIF(${wh_ops_hours}, 0);;
    value_format_name: decimal_2
    group_label: "UTR"
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
    description: "Target UTR used in Forecasting Rider Hours"
    sql: ${TABLE}.number_of_target_orders_per_employee ;;
    filters: [position_name: "rider"]
    value_format_name: decimal_2
  }

  measure: sum_forecasted_riders_needed{
    type: sum
    label: "# Forecasted Hours"
    description: "Number of Needed Employee Hours Based on Forecasted Order Demand"
    sql: NULLIF(${TABLE}.number_of_forecasted_employees_needed,0) * 0.5 ;;
    filters: [position_name: "rider"]
    value_format_name: decimal_1
    hidden: yes
  }

  measure: sum_planned_hours{
    type: sum
    label: "# Scheduled Hours"
    description: "Number of Scheduled Hours"
    sql: ${number_of_planned_minutes} / 60 ;;
    filters: [position_name: "rider"]
    value_format_name: decimal_1
    hidden: yes
  }

  measure: pct_overstaffing {
    type: number
    label:"% Overstaffing"
    description: "When Forecasted Hours < Scheduled Hours: (Forecasted Hours - Scheduled Hours) / Forecasted Hours"
    sql: case
          when ${sum_forecasted_riders_needed} < ${sum_planned_hours}
            then (${sum_forecasted_riders_needed} - ${sum_planned_hours}) / nullif(${sum_forecasted_riders_needed},0)
          else 0 end  ;;
    value_format_name: percent_0
  }

  measure: pct_understaffing {
    type: number
    label: "% Understaffing"
    description: "When Forecasted Hours > Scheduled Hours: (Scheduled Hours - Forecasted Hours) / Forecasted Hours"
    sql: case
          when ${sum_forecasted_riders_needed} > ${sum_planned_hours}
            then (${sum_planned_hours} - ${sum_forecasted_riders_needed}) / nullif(${sum_forecasted_riders_needed},0)
          else 0 end  ;;
    value_format_name: percent_0
  }


  measure: sum_predicted_orders{
    type: sum
    label: "# Forecasted Orders"
    description: "Number of Forecasted Orders"
    sql: ${TABLE}.number_of_predicted_orders ;;
    value_format_name: decimal_0
    filters: [position_name: "rider"]
    hidden: yes
  }

  measure: pct_forecast_deviation {
    type: number
    label: "% Forecast Deviation "
    description: "absolute (Forecasted Orders / Actual Orders)"
    sql: abs(${sum_predicted_orders} / nullif(${adjusted_orders_riders},0)) ;;
    value_format_name: percent_0
  }

}
