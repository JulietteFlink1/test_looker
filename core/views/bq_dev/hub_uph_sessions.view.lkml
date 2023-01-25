view: hub_uph_sessions {
  sql_table_name: `flink-data-dev.dbt_jgrammatikas_reporting.hub_uph_sessions`
    ;;

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: flow {
    type: string
    sql: ${TABLE}.flow ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: is_activity_switch {
    type: yesno
    sql: ${TABLE}.is_activity_switch ;;
  }

  dimension: number_of_checks {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_checks ;;
  }

  dimension: number_of_counted_items {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_counted_items ;;
  }

  dimension: number_of_dropped_items {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_dropped_items ;;
  }

  dimension: number_of_events {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_events ;;
  }

  dimension: number_of_picked_items {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_picked_items ;;
  }

  dimension: number_of_picked_or_dropped_or_counted_items {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_picked_or_dropped_or_counted_items ;;
  }

  dimension: number_of_picked_orders {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_picked_orders ;;
  }

  dimension: position_name {
    type: string
    sql: ${TABLE}.position_name ;;
  }

  dimension: pure_idle_seconds {
    type: number
    hidden: yes
    sql: ${TABLE}.pure_idle_seconds ;;
  }

  dimension: quinyx_badge_number {
    type: string
    sql: ${TABLE}.quinyx_badge_number ;;
  }

  dimension: session_duration_hours {
    type: number
    hidden: yes
    sql: ${TABLE}.session_duration_hours ;;
  }

  dimension: session_duration_minutes {
    type: number
    hidden: yes
    sql: ${TABLE}.session_duration_minutes ;;
  }

  dimension: session_duration_seconds {
    type: number
    hidden: yes
    sql: ${TABLE}.session_duration_seconds ;;
  }

  dimension_group: session_ends_at_timestamp {
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
    sql: ${TABLE}.session_ends_at_timestamp ;;
  }

  dimension_group: session_starts_at_timestamp {
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
    sql: ${TABLE}.session_starts_at_timestamp ;;
  }

  dimension: session_type {
    type: string
    sql: ${TABLE}.session_type ;;
  }

  dimension: session_uuid {
    type: string
    hidden: yes
    sql: ${TABLE}.session_uuid ;;
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

  dimension: shift_id {
    type: number
    sql: ${TABLE}.shift_id ;;
  }

  dimension: sub_flow {
    type: string
    sql: ${TABLE}.sub_flow ;;
  }

  measure: count {
    type: count
    drill_fields: [position_name]
  }

  measure: sum_number_of_events {
    group_label: "> Quantities"
    label: "# Events"
    description: "Total number of Events included in a given session"
    type: sum
    sql: ${number_of_events} ;;
  }

  measure: avg_number_of_events {
    group_label: "> Quantities"
    label: "AVG # Events"
    description: "AVG Number of Events included in a given session"
    type: average
    sql: ${number_of_events} ;;
  }

  measure: sum_number_of_checks {
    group_label: "> Quantities"
    label: "# Checks"
    type: sum
    sql: ${number_of_checks} ;;
  }

  measure: sum_number_of_picked_items {
    group_label: "> Quantities"
    label: "# Picked Items"
    type: sum
    sql: ${number_of_picked_items} ;;
  }

  measure: sum_number_of_dropped_items {
    group_label: "> Quantities"
    label: "# Dropped Items"
    type: sum
    sql: ${number_of_dropped_items} ;;
  }

  measure: sum_number_of_picked_orders{
    group_label: "> Quantities"
    label: "# Picked Orders"
    type: sum
    sql: ${number_of_picked_orders} ;;
  }

  measure: sum_session_duration_minutes {
    group_label: "> Durations"
    label: "SUM Session Duration Minutes"
    type: sum
    sql: ${session_duration_minutes} ;;
    value_format_name: decimal_3
  }

  measure: sum_session_duration_seconds {
    group_label: "> Durations"
    label: "SUM Session Duration Seconds"
    type: sum
    sql: ${session_duration_seconds} ;;
    value_format_name: decimal_3
  }

  measure: sum_session_duration_hours {
    group_label: "> Durations"
    label: "SUM Session Duration Hours"
    type: sum
    sql: ${session_duration_hours} ;;
    value_format_name: decimal_3
  }

  measure: sum_direct_session_order_preparation_duration_hours {
    group_label: "> Durations"
    label: "SUM Direct Session Order Preparation Duration Hours"
    description: "Number of hours spent on the direct order preparation process. Filtered for flow order_preparation and sessio type direct"
    type: sum
    sql: ${session_duration_hours} ;;
    filters: [flow: "order_preparation",session_type: "direct"]
    value_format_name: decimal_3
  }

  measure: sum_direct_session_inbounding_duration_hours {
    group_label: "> Durations"
    label: "SUM Direct Session Inbounding Duration Hours"
    description: "Number of hours spent on the direct inbounding process. Filtered for flow inbounding and sessio type direct"
    type: sum
    sql: ${session_duration_hours} ;;
    filters: [flow: "inbounding",session_type: "direct"]
    value_format_name: decimal_3
  }

  measure: sum_direct_session_inventory_check_duration_hours {
    group_label: "> Durations"
    label: "SUM Direct Session Inventory Check Duration Hours"
    description: "Number of hours spent on the direct inventory check process. Filtered for flow inventory check and sessio type direct"
    type: sum
    sql: ${session_duration_hours} ;;
    filters: [flow: "inventory_check",session_type: "direct"]
    value_format_name: decimal_3
  }

  measure: avg_session_duration_minutes {
    group_label: "> Durations"
    label: "AVG Session Duration Minutes"
    type: average
    sql: ${session_duration_minutes} ;;
    value_format_name: decimal_3
  }


  measure: avg_session_duration_seconds {
    group_label: "> Durations"
    label: "AVG Session Duration Seconds"
    type: average
    sql: ${session_duration_seconds} ;;
    value_format_name: decimal_3
  }

  measure: avg_session_duration_hours {
    group_label: "> Durations"
    label: "AVG Session Duration Hours"
    type: average
    sql: ${session_duration_hours} ;;
    value_format_name: decimal_3
  }

  measure: uph_picking {
    group_label: "> UPH"
    type: number
    label: "UPH Picking"
    sql: ${sum_number_of_picked_items}/${sum_direct_session_order_preparation_duration_hours} ;;
  }

  measure: uph_inbounding {
    group_label: "> UPH"
    type: number
    label: "UPH Inbounding"
    sql: ${sum_number_of_dropped_items}/${sum_direct_session_inbounding_duration_hours} ;;
  }

  measure: uph_inventory_check {
    group_label: "> UPH"
    type: number
    label: "UPH Inventory Check"
    sql: ${sum_number_of_dropped_items}/${sum_direct_session_inbounding_duration_hours} ;;
  }

}
