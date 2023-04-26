## Owner: Victor Breda
## This model provides information on a day/employee level about the compliance -> it is
## used to compare the number of events that occured within and outside the shifts
view: hub_uph_compliance {
  sql_table_name: `flink-data-dev.dbt_vbreda_reporting.hub_uph_compliance` ;;

  dimension: table_uuid {
    type: string
    primary_key: yes
    hidden: yes
    description: "Generic identifier of a table in BigQuery that represent 1 unique row of this table."
    sql: ${TABLE}.table_uuid ;;
  }

  dimension: country_iso {
    hidden: yes
    type: string
    description: "Country ISO based on 'hub_code'."
    sql: ${TABLE}.country_iso ;;
  }

  dimension: hub_code {
    hidden: yes
    type: string
    description: "Code of a hub identical to back-end source tables."
    sql: ${TABLE}.hub_code ;;
  }

  dimension: quinyx_badge_number {
    type: string
    description: "Employee ID generated by HR systems (badgeNo in Quinyx)."
    sql: ${TABLE}.quinyx_badge_number ;;
  }

  dimension: shift_id {
    type: number
    description: "Unique ID generated by Quinyx for each shift."
    sql: ${TABLE}.shift_id ;;
  }

  dimension: is_punched_shift {
    type: yesno
    description: "True if the shift has punch in/out events, false otherwise."
    sql: ${TABLE}.is_punched_shift ;;
  }

  dimension: position_name {
    description: "Position Assigned in Quinyx for the shift."
    type: string
    sql: ${TABLE}.position_name ;;
  }

  dimension: has_shift {
    type: yesno
    description: "True if there is a shift on that date for this employee, false otherwise."
    sql: ${shift_id} is not null ;;
  }

  dimension_group: event {
    group_label: "> Dates & Timestamps"
    type: time
    description: "Date on which the event occurred. In case the event occurred before 3am UTC, it is attributed to the previous day."
    timeframes: [
      date,
      week,
      month
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.event_date ;;
  }

  dimension_group: evaluation_ends {
    group_label: "> Dates & Timestamps"
    type: time
    description: "Timestamp at which an employee punched out. In case it is not available, the shift end timestamp is used."
    timeframes: [
      time
    ]
    sql: ${TABLE}.evaluation_ends_timestamp ;;
  }

  dimension_group: evaluation_starts {
    group_label: "> Dates & Timestamps"
    type: time
    description: "Timestamp at which an employee punched in. In case it is not available, the shift start timestamp is used."
    timeframes: [
      time
    ]
    sql: ${TABLE}.evaluation_starts_timestamp ;;
  }

  dimension_group: first_event_hub_one {
    group_label: "> Dates & Timestamps"
    type: time
    description: "Timestamp at which the first Hub One event occurred on the event_date."
    timeframes: [
      time
    ]
    sql: ${TABLE}.first_event_hub_one_timestamp ;;
  }

  dimension_group: last_event_hub_one {
    group_label: "> Dates & Timestamps"
    type: time
    description: "Timestamp at which the last Hub One event occurred on the event_date."
    timeframes: [
      time
    ]
    sql: ${TABLE}.last_event_hub_one_timestamp ;;
  }

  dimension_group: first_event_within_shift {
    group_label: "> Dates & Timestamps"
    type: time
    description: "Timestamp at which the first Hub One event occurred after the employee punched in. In case punch is not available, the planned start of the shift is used."
    timeframes: [
      time
    ]
    sql: ${TABLE}.first_event_within_shift_timestamp ;;
  }

  dimension_group: last_event_within_shift {
    group_label: "> Dates & Timestamps"
    type: time
    description: "Timestamp at which the last Hub One event occurred before the employee punched out. In case punch is not available, the planned end of the shift is used."
    timeframes: [
      time
    ]
    sql: ${TABLE}.last_event_within_shift_timestamp ;;
  }

  dimension: number_of_events_hub_one {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_events_hub_one ;;
  }

  dimension: number_of_events_within_shift {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_events_within_shift ;;
  }

  dimension: number_of_picked_or_dropped_or_counted_items_hub_one {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_picked_or_dropped_or_counted_items_hub_one ;;
  }

  dimension: number_of_picked_or_dropped_or_counted_items_within_shift {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_picked_or_dropped_or_counted_items_within_shift ;;
  }

  dimension: number_of_checks_hub_one {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_checks_hub_one ;;
  }

  dimension: number_of_checks_within_shift {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_checks_within_shift ;;
  }

  dimension: number_of_counted_items_hub_one {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_counted_items_hub_one ;;
  }

  dimension: number_of_counted_items_within_shift {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_counted_items_within_shift ;;
  }

  dimension: number_of_dropped_items_hub_one {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_dropped_items_hub_one ;;
  }

  dimension: number_of_dropped_items_within_shift {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_dropped_items_within_shift ;;
  }

  dimension: number_of_picked_items_hub_one {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_picked_items_hub_one ;;
  }

  dimension: number_of_picked_items_within_shift {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_picked_items_within_shift ;;
  }

  dimension: number_of_picked_orders_hub_one {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_picked_orders_hub_one ;;
  }

  dimension: number_of_picked_orders_within_shift {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_picked_orders_within_shift ;;
  }

  dimension: are_all_events_within_shift {
    type: yesno
    label: "All Events Within Shift"
    description: "Yes if all events occurred within the shift, No otherwise or if no events were recorded."
    sql: ${number_of_events_hub_one} = ${number_of_events_within_shift}
    and ${number_of_events_hub_one} != 0
    ;;
  }

  dimension: are_not_all_events_within_shift {
    type: yesno
    label: "Not All Events Within Shift"
    description: "Yes if only some events occurred within the shift, No otherwise."
    sql: ${number_of_events_hub_one} != ${number_of_events_within_shift}
          and ${number_of_events_hub_one} != 0
          and ${number_of_events_within_shift} != 0
          ;;
  }

  dimension: hub_one_data_but_no_shift {
    type: yesno
    label: "Hub One Data - No Shift"
    description: "Yes if Hub One events ocurred for the employee for that date and no shift was planned, No otherwise."
    sql: ${number_of_events_hub_one} > 0
          and ${shift_id} is null
          ;;
  }

  dimension: shift_but_no_hub_one_data {
    type: yesno
    label: "Shift - No Hub One Data"
    description: "Yes if there is a punched shift during which no Hub One events occurred, No otherwise."
    sql:${is_punched_shift}
          and ${number_of_events_within_shift} = 0
          ;;
  }

 ########## MEASURES ###########

## We use sql_distinct_key to not count hub one events nultiple times in case of multiple shifts per day-employee
  measure: sum_number_of_events_hub_one {
    label: "# Events"
    group_label: "Hub One"
    type: sum_distinct
    sql_distinct_key: concat(${event_date}, ${quinyx_badge_number});;
    description: "Number of Hub One events. Lowest granularity available: Day - Quinyx Badge Number."
    sql: ${number_of_events_hub_one} ;;
  }

  measure: avg_number_of_events_hub_one {
    label: "AVG # Events"
    group_label: "Hub One"
    type: average_distinct
    sql_distinct_key: concat(${event_date}, ${quinyx_badge_number});;
    description: "Average number of Hub One events."
    sql: ${number_of_events_hub_one} ;;
  }

  measure: sum_number_of_events_within_shift {
    label: "# Events - Within Shift"
    group_label: "Within Shift"
    type: sum
    description: "Number of Hub One events recorded during the shift."
    sql: ${number_of_events_within_shift} ;;
  }

  measure: avg_number_of_events_within_shift {
    label: "AVG # Events -  Within Shift"
    group_label: "Within Shift"
    type: average
    description: "Average number of Hub One events recorded during the shift."
    sql: ${number_of_events_within_shift} ;;
  }

  measure: sum_number_of_picked_or_dropped_or_counted_items_hub_one {
    label: "# Picked/Dropped/Counted Items"
    group_label: "Hub One"
    description: "Number of Picked/Dropped/Counted items. Based on Hub One app tracking data."
    type: sum_distinct
    sql_distinct_key: concat(${event_date}, ${quinyx_badge_number});;
    sql: ${number_of_picked_or_dropped_or_counted_items_hub_one} ;;
  }

  measure: sum_number_of_picked_or_dropped_or_counted_items_within_shift {
    label: "# Picked/Dropped/Counted Items - Within Shift"
    group_label: "Within Shift"
    type: sum
    description: "Number of Picked/Dropped/Counted items during the shift. Based on Hub One app tracking data."
    sql: ${number_of_picked_or_dropped_or_counted_items_within_shift} ;;
  }

  measure: sum_number_of_checks_hub_one {
    label: "# Checks"
    group_label: "Hub One"
    description: "Number of checks. Based on Hub One app tracking data."
    type: sum_distinct
    sql_distinct_key: concat(${event_date}, ${quinyx_badge_number});;
    sql: ${number_of_checks_hub_one} ;;
  }

  measure: sum_number_of_checks_within_shift {
    label: "# Checks - Within Shift"
    group_label: "Within Shift"
    type: sum
    description: "Number of checks performed during the shift. Based on Hub One app tracking data."
    sql: ${number_of_checks_within_shift} ;;
  }

  measure: sum_number_of_counted_items_hub_one {
    label: "# Counted Items"
    group_label: "Hub One"
    description: "Number of counted items. Based on Hub One app tracking data."
    type: sum_distinct
    sql_distinct_key: concat(${event_date}, ${quinyx_badge_number});;
    sql: ${number_of_counted_items_hub_one} ;;
  }

  measure: sum_number_of_counted_items_within_shift {
    label: "# Counted Items - Within Shift"
    group_label: "Within Shift"
    type: sum
    description: "Number of counted items during the shift. Based on Hub One app tracking data."
    sql: ${number_of_counted_items_within_shift} ;;
  }

  measure: sum_number_of_dropped_items_hub_one {
    label: "# Dropped Items"
    group_label: "Hub One"
    description: "Number of items dropped during the inbounding process. Based on Hub One app tracking data."
    type: sum_distinct
    sql_distinct_key: concat(${event_date}, ${quinyx_badge_number});;
    sql: ${number_of_dropped_items_hub_one} ;;
  }

  measure: sum_number_of_dropped_items_within_shift {
    label: "# Dropped Items - Within Shift"
    group_label: "Within Shift"
    type: sum
    description: "Number of items dropped during the inbounding process during the shift. Based on Hub One app tracking data."
    sql: ${number_of_dropped_items_within_shift} ;;
  }

  measure: sum_number_of_picked_items_hub_one {
    label: "# Picked Items"
    group_label: "Hub One"
    description: "Number of picked items. Based on Hub One app tracking app."
    type: sum_distinct
    sql_distinct_key: concat(${event_date}, ${quinyx_badge_number});;
    sql: ${number_of_picked_items_hub_one} ;;
  }

  measure: sum_number_of_picked_items_within_shift {
    label: "# Picked Items - Within Shift"
    group_label: "Within Shift"
    type: sum
    description: "Number of picked items during the shift. Based on Hub One app tracking app."
    sql: ${number_of_picked_items_within_shift} ;;
  }

  measure: sum_number_of_picked_orders_hub_one {
    label: "# Picked Orders"
    group_label: "Hub One"
    description: "Number of picked orders. Based on Hub One app tracking data."
    type: sum_distinct
    sql_distinct_key: concat(${event_date}, ${quinyx_badge_number});;
    sql: ${number_of_picked_orders_hub_one} ;;
  }

  measure: sum_number_of_picked_orders_within_shift {
    label: "# Picked Orders - Within Shift"
    group_label: "Within Shift"
    type: sum
    description: "Number of picked orders during the shift. Based on Hub One app tracking data."
    sql: ${number_of_picked_orders_within_shift} ;;
  }

  ### Process Compliance metrics - Counts

  measure: count_shift_all_events_within_shift {
    type: count
    label: "# Process Compliant Shifts"
    description: "Number of shifts where all events occured within the shift.
    If the shift is not punched, we consider the planned start and end of the shift as boundaries."
    filters: [are_all_events_within_shift: "yes"]
  }

  measure: count_shifts_not_all_events_within_shift{
    type: count
    label: "# Shifts - Not All Events Wihtin Shift"
    description: "Number of shifts where not all events occured within the shift.
    If the shift is not punched, we consider the planned start and end of the shift as boundaries."
    filters: [are_not_all_events_within_shift: "yes"]
  }

  measure: count_shifts_hub_one_data_but_no_shift{
    type: count
    label: "# Shifts - Hub One Events but no Shift"
    description: "Number of date-employee combination for which there are Hub One events, but no shift was planned."
    filters: [hub_one_data_but_no_shift: "yes"]
  }

  measure: count_shift_but_no_hub_one_data{
    type: count
    label: "# Shifts - No Hub One Events"
    description: "Number of punched shifts for which there are no Hub One events within it."
    filters: [shift_but_no_hub_one_data: "yes"]
  }

  measure: count_shifts {
    label: "# Shifts"
    description: "Number of shifts.
    In case there is a date-employee combination for which there are Hub One events while no shift was planned, we count it as a shift in this metric."
    type: count
  }

    ### Process Compliance metrics - Shares

  measure: share_of_shifts_having_all_events_within_shift{
    label: "% Process Compliant Shifts"
    description: "Share of Shifts where all events occured within the shift. If the shift is not punched, we consider the planned start and end of the shift as boundaries."
    type: number
    sql: safe_divide(${count_shift_all_events_within_shift},${count_shifts}) ;;
    value_format_name: percent_1
  }

  measure: share_of_shifts_having_not_all_events_within_shift{
    label: "% Shifts - Not All Events Wihtin Shift"
    description: "Share of Shifts where not all events occured within the shift. If the shift is not punched, we consider the planned start and end of the shift as boundaries."
    type: number
    sql: safe_divide(${count_shifts_not_all_events_within_shift},${count_shifts}) ;;
    value_format_name: percent_1
  }

  measure: share_of_shifts_hub_one_data_but_no_shift{
    label: "% Shifts - Hub One Data but no Shift"
    description: "Share of date-employee combinations for which there are Hub One events, but no shift was planned."
    type: number
    sql: safe_divide(${count_shifts_hub_one_data_but_no_shift},${count_shifts}) ;;
    value_format_name: percent_1
  }

  measure: share_of_shifts_no_hub_one_data{
    label: "% Shifts - No Hub One Events"
    description: "Share of punched shifts for which there are no Hub One events within it."
    type: number
    sql: safe_divide(${count_shift_but_no_hub_one_data},${count_shifts}) ;;
    value_format_name: percent_1
  }



}
