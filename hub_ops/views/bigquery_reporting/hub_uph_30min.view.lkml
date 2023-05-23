## Owner: Victor Breda
# This view provides information about the activity in the hubs based on Hub One and Quinyx data.
# It is based on the hub_uph_sessions, and breaks down sessions into 30min blocks, such that productivity metrics can be investigated at a half hour granularity.
## Confluence doc: https://goflink.atlassian.net/wiki/spaces/DATA/pages/505643011/UPH+Metrics

view: hub_uph_30min {
  sql_table_name: `flink-data-prod.reporting.hub_uph_30min`;;

###### DIMENSIONS ######

  dimension: session_30min_uuid {
    type: string
    primary_key: yes
    hidden: yes
    description: "Generic identifier of a table in BigQuery that represent 1 unique row of this table."
    sql: ${TABLE}.session_30min_uuid ;;
  }

  dimension: country_iso {
    type: string
    hidden: yes
    group_label: "> Geographic Dimensions"
    sql: ${TABLE}.country_iso ;;
  }

  dimension: hub_code {
    hidden: yes
    group_label: "> Geographic Dimensions"
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: position_name {
    description: "Position Assigned in Quinyx for the shift."
    type: string
    hidden: yes
    sql: ${TABLE}.position_name ;;
  }

  dimension: flow {
    hidden: yes
    description: "Flow of the session. Possible values: inbounding, order_preparation, inventory_check for direct session. Hub for idle sessions."
    type: string
    sql: ${TABLE}.flow ;;
  }

  dimension: session_type {
    hidden: yes
    description: "Type of the session. Sessions can be of type direct (group of events happening one after the other below a certain threshold). Or idle (internal, transition or limit idle). Current threshold: 120seconds for all flows."
    type: string
    sql: ${TABLE}.session_type ;;
  }

  dimension: sub_flow {
    hidden: yes
    description: "Sub flow of the session. For instance inventory_check flow has 2 sub-flows: list_preparation and list_dropping."
    type: string
    sql: ${TABLE}.sub_flow ;;
  }
  dimension: session_duration_hours {
    hidden: yes
    group_label: "> Duration Dimensions"
    label: "Session Duration (Hours)"
    description: "Difference between session ends at timestamp and session starts at timestamp. In hours."
    type: number
    sql: ${TABLE}.session_duration_hours ;;
  }

  dimension: session_duration_minutes {
    hidden: yes
    group_label: "> Duration Dimensions"
    label: "Session Duration (Minutes)"
    description: "Difference between session ends at timestamp and session starts at timestamp. In minutes."
    type: number
    sql: ${TABLE}.session_duration_minutes ;;
  }

  dimension: session_duration_seconds {
    hidden: yes
    group_label: "> Duration Dimensions"
    label: "Session Duration (Seconds)"
    description: "Difference between session ends at timestamp and session starts at timestamp. In seconds."
    type: number
    sql: ${TABLE}.session_duration_seconds ;;
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

  dimension_group: session_ends {
    hidden: yes
    group_label: "> Dates & Timestamps"
    description: "Timestamp at which the session ended."
    label: "Session Ends"
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      day_of_week,
      month,
      minute30,
      hour_of_day
    ]
    sql: ${TABLE}.session_ends_at_timestamp ;;
  }

  dimension_group: session_starts {
    hidden: yes
    group_label: "> Dates & Timestamps"
    label: "Session Starts"
    description: "Timestamp at which the session started."
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      day_of_week,
      month,
      minute30,
      hour_of_day
    ]
    sql: ${TABLE}.session_starts_at_timestamp ;;
  }

  dimension_group: block_ends_at {
    hidden: yes
    type: time
    description: "Timestamp at which the 30min block ends."
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

  dimension_group: block_starts_at {
    hidden: yes
    type: time
    description: "Timestamp at which the 30min block starts."
    timeframes: [
      raw,
      time,
      minute30,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.block_starts_at_timestamp ;;
  }

# Kept for debugging purposes
  dimension: shift_id {
    hidden: yes
    description: "Unique ID generated by Quinyx for each shift."
    type: number
    sql: ${TABLE}.shift_id ;;
  }

  dimension: session_uuid {
    hidden: yes
    description: "Unique ID generated by Quinyx for each shift."
    type: number
    sql: ${TABLE}.session_uuid ;;
  }

  dimension: quinyx_badge_number {
    description: "Unique employee identifier in Quinyx."
    hidden: yes
    type: string
    sql: ${TABLE}.quinyx_badge_number ;;
  }

###### MEASURES ######

  measure: sum_number_of_events {
    group_label: "> Quantities"
    label: "# Events"
    description: "Total number of Events included in a given session. Based on Hub One data."
    type: sum
    sql: ${number_of_events} ;;
  }

  measure: sum_number_of_checks {
    group_label: "> Quantities"
    label: "# Checks"
    description: "Number of Checks finished. 1 check = 1 SKU. Based on Hub One data."
    type: sum
    sql: ${number_of_checks} ;;
  }

  measure: sum_number_of_picked_items {
    group_label: "> Quantities"
    label: "# Picked Items"
    description: "Number of Items scanned during the picking process. Action can be item picked, skipped, reset or refunded. Based on Hub One data."
    type: sum
    sql: ${number_of_picked_items} ;;
  }

  measure: sum_number_of_dropped_items {
    group_label: "> Quantities"
    label: "# Dropped Items"
    description: "Number of dropped items during the inbounding process. Based on Hub One data."
    type: sum
    sql: ${number_of_dropped_items} ;;
  }

  measure: sum_number_of_picked_orders{
    group_label: "> Quantities"
    label: "# Picked Orders"
    description: "Number of picked orders. Based on Hub One data."
    type: sum
    sql: ${number_of_picked_orders} ;;
  }

  measure: sum_session_duration_minutes {
    group_label: "> Durations All Positions"
    label: "SUM Session Duration Minutes"
    description: "SUM of all session durations. In minutes."
    type: sum
    sql: ${session_duration_minutes} ;;
    value_format_name: decimal_2
  }

  measure: sum_session_duration_seconds {
    group_label: "> Durations All Positions"
    label: "SUM Session Duration Seconds"
    description: "SUM of all session durations. In seconds."
    type: sum
    sql: ${session_duration_seconds} ;;
    value_format_name: decimal_2
  }

  measure: sum_session_duration_hours {
    group_label: "> Durations All Positions"
    label: "SUM Session Duration Hours"
    description: "Sum of all session durations. In hours."
    type: sum
    sql: ${session_duration_hours} ;;
    value_format_name: decimal_2
  }

  measure: sum_direct_session_order_preparation_duration_hours {
    group_label: "> Durations All Positions"
    label: "SUM Direct Hours - Order Preparation"
    description: "Number of hours spent on the direct order preparation process. Filtered for flow order_preparation and session type direct"
    type: sum
    sql: ${session_duration_hours} ;;
    filters: [flow: "order_preparation",session_type: "direct"]
    value_format_name: decimal_2
  }

  measure: sum_direct_session_inbounding_duration_hours {
    group_label: "> Durations All Positions"
    label: "SUM Direct Hours - Inbounding"
    description: "Number of hours spent on the direct inbounding process. Filtered for flow inbounding and session type direct"
    type: sum
    sql: ${session_duration_hours} ;;
    filters: [flow: "inbounding",session_type: "direct"]
    value_format_name: decimal_2
  }

  measure: sum_direct_session_inventory_check_duration_hours {
    group_label: "> Durations All Positions"
    label: "SUM Direct Hours - Inventory Check"
    description: "Number of hours spent on the direct inventory check process. Filtered for flow inventory check and session type direct"
    type: sum
    sql: ${session_duration_hours} ;;
    filters: [flow: "inventory_check",session_type: "direct"]
    value_format_name: decimal_2
  }

  measure: sum_internal_idle_session_order_preparation_duration_hours {
    group_label: "> Durations All Positions"
    label: "SUM Internal Idle Hours - Order Preparation"
    description: "Number of hours spent on the internal idle order preparation process. Filtered for flow order_preparation and session type internal idle"
    type: sum
    sql: ${session_duration_hours} ;;
    filters: [flow: "order_preparation",session_type: "internal_idle"]
    value_format_name: decimal_2
  }

  measure: sum_internal_idle_session_inbounding_duration_hours {
    group_label: "> Durations All Positions"
    label: "SUM Internal Idle Hours - Inbounding"
    description: "Number of hours spent on the indirect idle inbounding process. Filtered for flow inbounding and session type indirect idle"
    type: sum
    sql: ${session_duration_hours} ;;
    filters: [flow: "inbounding",session_type: "internal_idle"]
    value_format_name: decimal_2
  }

  measure: sum_internal_idle_session_inventory_check_duration_hours {
    group_label: "> Durations All Positions"
    label: "SUM Internal Idle Hours - Inventory Check"
    description: "Number of hours spent on the indirect idle inventory check process. Filtered for flow inventory check and session type indirect idle"
    type: sum
    sql: ${session_duration_hours} ;;
    filters: [flow: "inventory_check",session_type: "internal_idle"]
    value_format_name: decimal_2
  }

  measure: sum_direct_session_duration_hours {
    group_label: "> Durations All Positions"
    label: "SUM Direct Hours"
    description: "Number of hours spent on any direct process."
    type: sum
    sql: ${session_duration_hours} ;;
    filters: [session_type: "direct"]
    value_format_name: decimal_2
  }

  measure: sum_internal_idle_session_duration_hours {
    group_label: "> Durations All Positions"
    label: "SUM Internal Idle Hours"
    description: "Number of hours spent on internal idle. Including all flows"
    type: sum
    sql: ${session_duration_hours} ;;
    filters: [session_type: "internal_idle"]
    value_format_name: decimal_2
  }

  measure: sum_transition_idle_session_duration_hours {
    group_label: "> Durations All Positions"
    label: "SUM Transition Idle Hours"
    description: "Number of hours spent on transition idle. Including all flows"
    type: sum
    sql: ${session_duration_hours} ;;
    filters: [session_type: "transition_idle"]
    value_format_name: decimal_2
  }

  measure: sum_limit_idle_session_duration_hours {
    group_label: "> Durations All Positions"
    label: "SUM Limit Idle Hours"
    description: "Number of hours spent on limit idle. Including all flows"
    type: sum
    sql: ${session_duration_hours} ;;
    filters: [session_type: "limit_idle"]
    value_format_name: decimal_2
  }

  measure: share_of_direct_session_duration_hours_over_all_hours {
    group_label: "> Durations All Positions"
    label: "% Direct Hours"
    description: "Number of hours spent on any direct process divided by all worked hours."
    type: number
    sql: safe_divide(${sum_direct_session_duration_hours},${sum_session_duration_hours}) ;;
    value_format_name: percent_1
  }

  measure: share_of_internal_idle_session_duration_hours_over_all_hours {
    group_label: "> Durations All Positions"
    label: "% Internal Idle Hours"
    description: "Number of hours spent on internal idle divided by all worked hours."
    type: number
    sql: safe_divide(${sum_internal_idle_session_duration_hours},${sum_session_duration_hours}) ;;
    value_format_name: percent_1
  }

  measure: share_of_transition_idle_session_duration_hoursover_all_hours {
    group_label: "> Durations All Positions"
    label: "% Transition Idle Hours"
    description: "Number of hours spent on transition idle divided by all worked hours."
    type: number
    sql: safe_divide(${sum_transition_idle_session_duration_hours},${sum_session_duration_hours}) ;;
    value_format_name: percent_1
  }

  measure: share_of_limit_idle_session_duration_hours_over_all_hours {
    group_label: "> Durations All Positions"
    label: "% Limit Idle Hours"
    description: "Number of hours spent on limit idle divided by all worked hours."
    type: number
    sql: safe_divide(${sum_limit_idle_session_duration_hours},${sum_session_duration_hours}) ;;
    value_format_name: percent_1
  }

  measure: uph_picking {
    group_label: "> Productivity Metrics"
    type: number
    label: "UPH Order Preparation"
    description: "Units picked per Hour. Formula: # Picked Items / ( # Direct Order Preparation Hours + # Internal Order Preparation Hours )"
    value_format_name: decimal_0
    sql: safe_divide(${sum_number_of_picked_items},(${sum_direct_session_order_preparation_duration_hours}+${sum_internal_idle_session_order_preparation_duration_hours})) ;;
  }

  measure: oph_picking {
    group_label: "> Productivity Metrics"
    type: number
    description: "Orders picked per Hour. Formula: # Picked Orders / ( # Direct Order Preparation Hours + # Internal Order Preparation Hours )"
    label: "OPH"
    value_format_name: decimal_1
    sql: safe_divide(${sum_number_of_picked_orders},(${sum_direct_session_order_preparation_duration_hours}+${sum_internal_idle_session_order_preparation_duration_hours})) ;;
  }

  measure: uph_inbounding {
    group_label: "> Productivity Metrics"
    type: number
    label: "UPH Inbounding"
    description: "Units dropped per Hour. Formula:  # Dropped Items / ( # Direct Inbounding Hours + # Internal Inbounding Hours )"
    value_format_name: decimal_0
    sql: safe_divide(${sum_number_of_dropped_items},(${sum_direct_session_inbounding_duration_hours}+${sum_internal_idle_session_inbounding_duration_hours})) ;;
  }

  measure: uph_inventory_check {
    group_label: "> Productivity Metrics"
    type: number
    description: "Checks per Hour. Formula: # Checks / ( # Direct Inventory Hours + # Internal Inventory Hours )"
    label: "UPH Inventory Check"
    value_format_name: decimal_0
    sql: safe_divide(${sum_number_of_checks},(${sum_direct_session_inventory_check_duration_hours} +${sum_internal_idle_session_inventory_check_duration_hours}));;
  }

  measure: number_of_unique_shifts {
    type: count_distinct
    group_label: "> Quantities"
    label: "# Shifts"
    description: "Number of unique shifts."
    sql: ${shift_id} ;;
  }

  measure: share_of_idle_session_duration_hours_over_all_hours {
    group_label: "> Durations All Positions"
    label: "% Idle Hours"
    description: "Number of hours spent on any idle (internal, transition, limit) divided by all worked hours."
    type: number
    sql: safe_divide( ${sum_internal_idle_session_duration_hours} +
                      ${sum_limit_idle_session_duration_hours}   +
                      ${sum_transition_idle_session_duration_hours},
                          ${sum_session_duration_hours}) ;;
    value_format_name: percent_1
  }

  ############ > Rider metrics

  measure: sum_direct_session_order_preparation_duration_hours_rider {
    group_label: "> Durations Rider"
    label: "SUM Direct Hours Rider - Order Preparation"
    description: "Number of hours spent by riders on the direct order preparation process. Filtered for flow order_preparation and session type direct"
    type: sum
    sql: ${session_duration_hours} ;;
    filters: [flow: "order_preparation",session_type: "direct", position_name: "rider"]
    value_format_name: decimal_2
  }

  measure: sum_direct_session_inbounding_duration_hours_rider {
    group_label: "> Durations Rider"
    label: "SUM Direct Hours Rider - Inbounding"
    description: "Number of hours spent by riders on the direct inbounding process. Filtered for flow inbounding and session type direct"
    type: sum
    sql: ${session_duration_hours} ;;
    filters: [flow: "inbounding",session_type: "direct",position_name: "rider"]
    value_format_name: decimal_2
  }

  measure: sum_direct_session_inventory_check_duration_hours_rider {
    group_label: "> Durations Rider"
    label: "SUM Direct Hours Rider - Inventory Check"
    description: "Number of hours spent on the direct inventory check process. Filtered for flow inventory check and session type direct"
    type: sum
    sql: ${session_duration_hours} ;;
    filters: [flow: "inventory_check",session_type: "direct", position_name: "rider"]
    value_format_name: decimal_2
  }

  measure: sum_internal_idle_session_order_preparation_duration_hours_rider {
    group_label: "> Durations Rider"
    label: "SUM Internal Idle Hours Rider - Order Preparation"
    description: "Number of hours spent on the internal idle order preparation process. Filtered for flow order_preparation and session type internal idle"
    type: sum
    sql: ${session_duration_hours} ;;
    filters: [flow: "order_preparation",session_type: "internal_idle", position_name: "rider"]
    value_format_name: decimal_2
  }

  measure: sum_internal_idle_session_inbounding_duration_hours_rider {
    group_label: "> Durations Rider"
    label: "SUM Internal Idle Hours Rider - Inbounding"
    description: "Number of hours spent by riders on the indirect idle inbounding process. Filtered for flow inbounding and session type indirect idle"
    type: sum
    sql: ${session_duration_hours} ;;
    filters: [flow: "inbounding",session_type: "internal_idle", position_name: "rider"]
    value_format_name: decimal_2
  }

  measure: sum_internal_idle_session_inventory_check_duration_hours_rider {
    group_label: "> Durations Rider"
    label: "SUM Internal Idle Hours Rider - Inventory Check"
    description: "Number of hours spent by riders on the indirect idle inventory check process. Filtered for flow inventory check and session type indirect idle"
    type: sum
    sql: ${session_duration_hours} ;;
    filters: [flow: "inventory_check",session_type: "internal_idle", position_name: "rider"]
    value_format_name: decimal_2
  }

  measure: sum_transition_idle_session_duration_hours_rider {
    group_label: "> Durations Rider"
    label: "SUM Transition Idle Hours Rider"
    description: "Number of hours spent by riders on transition idle. Including all flows"
    type: sum
    sql: ${session_duration_hours} ;;
    filters: [session_type: "transition_idle", position_name: "rider"]
    value_format_name: decimal_2
  }

  measure: sum_limit_idle_session_duration_hours_rider {
    group_label: "> Durations Rider"
    label: "SUM Limit Idle Hours Rider"
    description: "Number of hours spent by riders on limit idle. Including all flows"
    type: sum
    sql: ${session_duration_hours} ;;
    filters: [session_type: "limit_idle", position_name: "rider"]
    value_format_name: decimal_2
  }

  ################ Ops Associate metrics

  measure: sum_direct_session_order_preparation_duration_hours_oa {
    group_label: "> Durations Ops Associate"
    label: "SUM Direct Hours Ops Associate - Order Preparation"
    description: "Number of hours spent by ops associates on the direct order preparation process. Filtered for flow order_preparation and session type direct"
    type: sum
    sql: ${session_duration_hours} ;;
    filters: [flow: "order_preparation",session_type: "direct", position_name: "ops associate"]
    value_format_name: decimal_2
  }

  measure: sum_direct_session_inbounding_duration_hours_oa {
    group_label: "> Durations Ops Associate"
    label: "SUM Direct Hours Ops Associate - Inbounding"
    description: "Number of hours spent by ops associates on the direct inbounding process. Filtered for flow inbounding and session type direct"
    type: sum
    sql: ${session_duration_hours} ;;
    filters: [flow: "inbounding",session_type: "direct",position_name: "ops associate"]
    value_format_name: decimal_2
  }

  measure: sum_direct_session_inventory_check_duration_hours_oa {
    group_label: "> Durations Ops Associate"
    label: "SUM Direct Hours Ops Associate - Inventory Check"
    description: "Number of hours spent on the direct inventory check process. Filtered for flow inventory check and session type direct"
    type: sum
    sql: ${session_duration_hours} ;;
    filters: [flow: "inventory_check",session_type: "direct",  position_name: "ops associate"]
    value_format_name: decimal_2
  }

  measure: sum_internal_idle_session_order_preparation_duration_hours_oa {
    group_label: "> Durations Ops Associate"
    label: "SUM Internal Idle Hours Ops Associate - Order Preparation"
    description: "Number of hours spent on the internal idle order preparation process. Filtered for flow order_preparation and session type internal idle"
    type: sum
    sql: ${session_duration_hours} ;;
    filters: [flow: "order_preparation",session_type: "internal_idle", position_name: "ops associate"]
    value_format_name: decimal_2
  }

  measure: sum_internal_idle_session_inbounding_duration_hours_oa {
    group_label: "> Durations Ops Associate"
    label: "SUM Internal Idle Hours Ops Associate - Inbounding"
    description: "Number of hours spent by ops associates on the indirect idle inbounding process. Filtered for flow inbounding and session type indirect idle"
    type: sum
    sql: ${session_duration_hours} ;;
    filters: [flow: "inbounding",session_type: "internal_idle",  position_name: "ops associate"]
    value_format_name: decimal_2
  }

  measure: sum_internal_idle_session_inventory_check_duration_hours_oa {
    group_label: "> Durations Ops Associate"
    label: "SUM Internal Idle Hours Ops Associate - Inventory Check"
    description: "Number of hours spent by ops associates on the indirect idle inventory check process. Filtered for flow inventory check and session type indirect idle"
    type: sum
    sql: ${session_duration_hours} ;;
    filters: [flow: "inventory_check",session_type: "internal_idle", position_name: "ops associate"]
    value_format_name: decimal_2
  }

  measure: sum_transition_idle_session_duration_hours_oa {
    group_label: "> Durations Ops Associate"
    label: "SUM Transition Idle Hours Ops Associate"
    description: "Number of hours spent by ops associates on transition idle. Including all flows"
    type: sum
    sql: ${session_duration_hours} ;;
    filters: [session_type: "transition_idle", position_name: "ops associate"]
    value_format_name: decimal_2
  }

  measure: sum_limit_idle_session_duration_hours_oa {
    group_label: "> Durations Ops Associate"
    label: "SUM Limit Idle Hours Ops Associate"
    description: "Number of hours spent by ops associates on limit idle. Including all flows"
    type: sum
    sql: ${session_duration_hours} ;;
    filters: [session_type: "limit_idle", position_name: "ops associate"]
    value_format_name: decimal_2
  }


  ########### Hub Staff metrics


  measure: sum_direct_session_order_preparation_duration_hours_hub_staff {
    group_label: "> Durations Hub Staff"
    label: "SUM Direct Hours Hub Staff - Order Preparation"
    description: "Number of hours spent by hub staff (includes shift lead, ops associates and ops associate +) on the direct order preparation process. Filtered for flow order_preparation and session type direct"
    type: sum
    sql: ${session_duration_hours} ;;
    filters: [flow: "order_preparation",session_type: "direct", position_name: "ops associate, ops associate +, shift lead"]
    value_format_name: decimal_2
  }

  measure: sum_direct_session_inbounding_duration_hours_hub_staff {
    group_label: "> Durations Hub Staff"
    label: "SUM Direct Hours Hub Staff - Inbounding"
    description: "Number of hours spent by hub staff (includes shift lead, ops associates and ops associate +) on the direct inbounding process. Filtered for flow inbounding and session type direct"
    type: sum
    sql: ${session_duration_hours} ;;
    filters: [flow: "inbounding",session_type: "direct",position_name: "ops associate, ops associate +, shift lead"]
    value_format_name: decimal_2
  }

  measure: sum_direct_session_inventory_check_duration_hours_hub_staff {
    group_label: "> Durations Hub Staff"
    label: "SUM Direct Hours Hub Staff - Inventory Check"
    description: "Number of hours spent on the direct inventory check process. Filtered for flow inventory check and session type direct"
    type: sum
    sql: ${session_duration_hours} ;;
    filters: [flow: "inventory_check",session_type: "direct",  position_name: "ops associate, ops associate +, shift lead"]
    value_format_name: decimal_2
  }

  measure: sum_internal_idle_sessio_hub_staffrder_preparation_duration_hours_hub_staff {
    group_label: "> Durations Hub Staff"
    label: "SUM Internal Idle Hours Hub Staff - Order Preparation"
    description: "Number of hours spent on the internal idle order preparation process. Filtered for flow order_preparation and session type internal idle"
    type: sum
    sql: ${session_duration_hours} ;;
    filters: [flow: "order_preparation",session_type: "internal_idle", position_name: "ops associate, ops associate +, shift lead"]
    value_format_name: decimal_2
  }

  measure: sum_internal_idl_hub_staffession_inbounding_duration_hours_hub_staff {
    group_label: "> Durations Hub Staff"
    label: "SUM Internal Idle Hours Hub Staff - Inbounding"
    description: "Number of hours spent by hub staff (includes shift lead, ops associates and ops associate +) on the indirect idle inbounding process. Filtered for flow inbounding and session type indirect idle"
    type: sum
    sql: ${session_duration_hours} ;;
    filters: [flow: "inbounding",session_type: "internal_idle",  position_name: "ops associate, ops associate +, shift lead"]
    value_format_name: decimal_2
  }

  measure: sum_internal_idle_session_inventory_check_duration_hours_hub_staff {
    group_label: "> Durations Hub Staff"
    label: "SUM Internal Idle Hours Hub Staff - Inventory Check"
    description: "Number of hours spent by hub staff (includes shift lead, ops associates and ops associate +) on the indirect idle inventory check process. Filtered for flow inventory check and session type indirect idle"
    type: sum
    sql: ${session_duration_hours} ;;
    filters: [flow: "inventory_check",session_type: "internal_idle", position_name: "ops associate, ops associate +, shift lead"]
    value_format_name: decimal_2
  }

  measure: sum_transition_idle_session_duration_hours_hub_staff {
    group_label: "> Durations Hub Staff"
    label: "SUM Transition Idle Hours Hub Staff"
    description: "Number of hours spent by hub staff (includes shift lead, ops associates and ops associate +) on transition idle. Including all flows"
    type: sum
    sql: ${session_duration_hours} ;;
    filters: [session_type: "transition_idle", position_name: "ops associate, ops associate +, shift lead"]
    value_format_name: decimal_2
  }

  measure: sum_limit_idle_session_duration_hours_hub_staff {
    group_label: "> Durations Hub Staff"
    label: "SUM Limit Idle Hours Hub Staff"
    description: "Number of hours spent by hub staff (includes shift lead, ops associates and ops associate +) on limit idle. Including all flows"
    type: sum
    sql: ${session_duration_hours} ;;
    filters: [session_type: "limit_idle", position_name: "ops associate, ops associate +, shift lead"]
    value_format_name: decimal_2
  }


}
