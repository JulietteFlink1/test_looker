## Owner: Justine Grammatikas
## This model provides information on a session/employee granularity, and contains hubs productivity and time metrics.
## Confluence doc: https://goflink.atlassian.net/wiki/spaces/DATA/pages/505643011/UPH+Metrics


view: hub_uph_sessions {
  sql_table_name: `flink-data-prod.reporting.hub_uph_sessions`
    ;;

  dimension: country_iso {
    type: string
    hidden: yes
    group_label: "> Geographic Dimensions"
    sql: ${TABLE}.country_iso ;;
  }

  dimension: session_uuid {
    type: string
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.session_uuid ;;
  }

  dimension: hub_code {
    hidden: yes
    group_label: "> Geographic Dimensions"
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: is_activity_switch {
    description: "Yes if the next direct session is of a different flow. False if the session is of type idle or right before an end idle."
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

  dimension: pure_idle_seconds {
    type: number
    hidden: yes
    sql: ${TABLE}.pure_idle_seconds ;;
  }

  dimension: position_name {
    hidden: yes
    description: "Position Assigned in Quinyx for the shift."
    type: string
    sql: ${TABLE}.position_name ;;
  }

  dimension: quinyx_badge_number {
    required_access_grants: [can_access_pii_hub_employees]
    hidden: yes
    description: "Unique employee identifier in Quinyx."
    type: string
    sql: ${TABLE}.quinyx_badge_number ;;
  }

  dimension: session_duration_hours {
    group_label: "> Duration Dimensions"
    label: "Session Duration (Hours)"
    description: "Difference between session ends at timestamp and session starts at timestamp. In hours."
    type: number
    sql: ${TABLE}.session_duration_hours ;;
  }

  dimension: session_duration_minutes {
    group_label: "> Duration Dimensions"
    label: "Session Duration (Minutes)"
    description: "Difference between session ends at timestamp and session starts at timestamp. In minutes."
    type: number
    sql: ${TABLE}.session_duration_minutes ;;
  }

  dimension: session_duration_seconds {
    group_label: "> Duration Dimensions"
    label: "Session Duration (Seconds)"
    description: "Difference between session ends at timestamp and session starts at timestamp. In seconds."
    type: number
    sql: ${TABLE}.session_duration_seconds ;;
  }

  dimension_group: session_ends {
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

  dimension: flow {
    description: "Flow of the session. Possible values: inbounding, order_preparation, inventory_check for direct session. Hub for idle sessions."
    type: string
    sql: ${TABLE}.flow ;;
  }

  dimension: prev_flow {
    hidden: yes
    description: "Flow of the previous session (partitioned by shift_id, quinyx_badge_number, hub_code, ordered by session start timestamp).
    Possible values: inbounding, order_preparation, inventory_check for direct session. Hub for idle sessions."
    type: string
    sql: ${TABLE}.prev_flow ;;
  }

  dimension: next_flow {
    hidden: yes
    description: "Flow of the following session (partitioned by shift_id, quinyx_badge_number, hub_code, ordered by session start timestamp).
    Possible values: inbounding, order_preparation, inventory_check for direct session. Hub for idle sessions."
    type: string
    sql: ${TABLE}.next_flow ;;
  }

  dimension: session_type {
    description: "Type of the session. Sessions can be of type direct (group of events happening one after the other below a certain threshold). Or idle (flow, transition or limit idle). Current threshold: 120seconds for all flows."
    type: string
    sql: ${TABLE}.session_type ;;
  }

  dimension_group: shift {
    group_label: "> Dates & Timestamps"
    description: "Date of the shift."
    type: time
    timeframes: [
      date,
      day_of_week,
      week,
      month,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.shift_date ;;
  }

  dimension: shift_id {
    hidden: yes
    description: "Unique ID generated by Quinyx for each shift."
    type: number
    sql: ${TABLE}.shift_id ;;
  }

  dimension: sub_flow {
    description: "Sub flow of the session. For instance inventory_check flow has 2 sub-flows: list_preparation and list_dropping."
    type: string
    sql: ${TABLE}.sub_flow ;;
  }

  dimension: is_idle_session_more_than_2_hours {
    type: yesno
    description: "Yes if the session type is idle (transition, limit or flow) and the session duration is > 2 hours."
    sql: case when ${session_type} like '%idle%' and  ${session_duration_hours}>2 then true else false end  ;;
  }

  ####### Measures used to include transition + limit idle into UPHs calculations ########

  measure: sum_of_transition_idle_session_duration_hours_leaving_inbounding {
    group_label: "> Durations"
    label: "SUM Transition Idle Hours - Inbounding"
    description: "Number of hours spent on transition idle after inbounding."
    type: sum
    sql: ${session_duration_hours} ;;
    filters: [session_type: "transition_idle", flow: "inbounding"]
    value_format_name: decimal_2
  }

  measure: sum_of_transition_idle_session_duration_hours_leaving_inventory_check {
    group_label: "> Durations"
    label: "SUM Transition Idle Hours - Inventory Checks"
    description: "Number of hours spent on transition idle after inventory checks."
    type: sum
    sql: ${session_duration_hours} ;;
    filters: [session_type: "transition_idle", flow: "inventory_check"]
    value_format_name: decimal_2
  }

  measure: sum_of_transition_idle_session_duration_hours_leaving_order_preparation {
    group_label: "> Durations"
    label: "SUM Transition Idle Hours - Order Preparation"
    description: "Number of hours spent on transition idle after order preparation."
    type: sum
    sql: ${session_duration_hours} ;;
    filters: [session_type: "transition_idle", flow: "order_preparation"]
    value_format_name: decimal_2
  }

  measure: sum_of_limit_idle_session_duration_hours_inbounding {
    group_label: "> Durations"
    label: "SUM Limit Idle Hours - Inbounding"
    description: "Number of hours spent on limit idle before/after inbounding."
    type: sum
    sql: ${session_duration_hours} ;;
    filters: [flow: "inbounding", session_type: "limit_idle"]
    value_format_name: decimal_2
  }

  measure: sum_of_limit_idle_session_duration_hours_inventory_check {
    group_label: "> Durations"
    label: "SUM Limit Idle Hours - Inventory Check"
    description: "Number of hours spent on limit idle before/after inventory check."
    type: sum
    sql: ${session_duration_hours} ;;
    filters: [flow: "inventory_check", session_type: "limit_idle"]
    value_format_name: decimal_2
  }

  measure: sum_of_limit_idle_session_duration_hours_order_preparation {
    group_label: "> Durations"
    label: "SUM Limit Idle Hours - Order Preparation"
    description: "Number of hours spent on limit idle before/after order preparation."
    type: sum
    sql: ${session_duration_hours} ;;
    filters: [flow: "order_preparation", session_type: "limit_idle"]
    value_format_name: decimal_2
  }

  ####### End ########


  measure: number_of_unique_sessions {
    group_label: "> Quantities"
    label: "# Sessions"
    description: "Number of Sessions."
    type: count_distinct
    sql: ${session_uuid};;
  }

  measure: sum_of_number_of_events {
    group_label: "> Quantities"
    label: "# Events"
    description: "Total number of Events included in a given session. Based on Hub One data."
    type: sum
    sql: ${number_of_events} ;;
  }

  measure: avg_number_of_events {
    group_label: "> Quantities"
    label: "AVG # Events"
    description: "AVG Number of Events included in a given session. Based on Hub One data."
    type: average
    sql: ${number_of_events} ;;
  }

  measure: sum_of_number_of_checks {
    group_label: "> Quantities"
    label: "# Checks"
    description: "Number of Checks finished. 1 check = 1 SKU. Based on Hub One data."
    type: sum
    sql: ${number_of_checks} ;;
  }

  measure: sum_of_number_of_picked_items {
    group_label: "> Quantities"
    label: "# Picked Items"
    description: "Number of Items scanned during the picking process. Action can be item picked, skipped, reset or refunded. Based on Hub One data."
    type: sum
    sql: ${number_of_picked_items} ;;
  }

  measure: sum_of_number_of_dropped_items {
    group_label: "> Quantities"
    label: "# Dropped Items"
    description: "Number of dropped items during the inbounding process. Based on Hub One data."
    type: sum
    sql: ${number_of_dropped_items} ;;
  }

  measure: sum_of_number_of_picked_orders{
    group_label: "> Quantities"
    label: "# Picked Orders"
    description: "Number of picked orders. Based on Hub One data."
    type: sum
    sql: ${number_of_picked_orders} ;;
  }

  measure: sum_of_session_duration_minutes {
    group_label: "> Durations"
    label: "SUM Session Duration Minutes"
    description: "SUM of all session durations. In minutes."
    type: sum
    sql: ${session_duration_minutes} ;;
    value_format_name: decimal_2
  }

  measure: sum_of_session_duration_seconds {
    group_label: "> Durations"
    label: "SUM Session Duration Seconds"
    description: "SUM of all session durations. In seconds."
    type: sum
    sql: ${session_duration_seconds} ;;
    value_format_name: decimal_2
  }

  measure: sum_of_session_duration_hours {
    group_label: "> Durations"
    label: "SUM Session Duration Hours"
    description: "Sum of all session durations. In hours."
    type: sum
    sql: ${session_duration_hours} ;;
    value_format_name: decimal_2
  }

  measure: sum_of_direct_session_order_preparation_duration_hours {
    group_label: "> Durations"
    label: "SUM Direct Hours - Order Preparation"
    description: "Number of hours spent on the direct order preparation process. Filtered for flow order_preparation and session type direct"
    type: sum
    sql: ${session_duration_hours} ;;
    filters: [flow: "order_preparation",session_type: "direct"]
    value_format_name: decimal_2
  }

  measure: sum_of_direct_session_inbounding_duration_hours {
    group_label: "> Durations"
    label: "SUM Direct Hours - Inbounding"
    description: "Number of hours spent on the direct inbounding process. Filtered for flow inbounding and session type direct"
    type: sum
    sql: ${session_duration_hours} ;;
    filters: [flow: "inbounding",session_type: "direct"]
    value_format_name: decimal_2
  }

  measure: sum_of_direct_session_inventory_check_duration_hours {
    group_label: "> Durations"
    label: "SUM Direct Hours - Inventory Check"
    description: "Number of hours spent on the direct inventory check process. Filtered for flow inventory check and session type direct"
    type: sum
    sql: ${session_duration_hours} ;;
    filters: [flow: "inventory_check",session_type: "direct"]
    value_format_name: decimal_2
  }

  measure: sum_of_internal_idle_session_order_preparation_duration_hours {
    group_label: "> Durations"
    label: "SUM Flow Idle Hours - Order Preparation"
    description: "Number of hours spent on the flow idle order preparation process. Filtered for flow order_preparation and session type flow idle"
    type: sum
    sql: ${session_duration_hours} ;;
    filters: [flow: "order_preparation",session_type: "flow_idle"]
    value_format_name: decimal_2
  }

  measure: sum_of_internal_idle_session_inbounding_duration_hours {
    group_label: "> Durations"
    label: "SUM Flow Idle Hours - Inbounding"
    description: "Number of hours spent on the indirect idle inbounding process. Filtered for flow inbounding and session type indirect idle"
    type: sum
    sql: ${session_duration_hours} ;;
    filters: [flow: "inbounding",session_type: "flow_idle"]
    value_format_name: decimal_2
  }

  measure: sum_of_internal_idle_session_inventory_check_duration_hours {
    group_label: "> Durations"
    label: "SUM Flow Idle Hours - Inventory Check"
    description: "Number of hours spent on the indirect idle inventory check process. Filtered for flow inventory check and session type indirect idle"
    type: sum
    sql: ${session_duration_hours} ;;
    filters: [flow: "inventory_check",session_type: "flow_idle"]
    value_format_name: decimal_2
  }

  measure: sum_of_direct_session_duration_hours {
    group_label: "> Durations"
    label: "SUM Direct Hours"
    description: "Number of hours spent on any direct process."
    type: sum
    sql: ${session_duration_hours} ;;
    filters: [session_type: "direct"]
    value_format_name: decimal_2
  }

  measure: sum_of_internal_idle_session_duration_hours {
    group_label: "> Durations"
    label: "SUM Flow Idle Hours"
    description: "Number of hours spent on flow idle. Including all flows"
    type: sum
    sql: ${session_duration_hours} ;;
    filters: [session_type: "flow_idle"]
    value_format_name: decimal_2
  }

  measure: sum_of_transition_idle_session_duration_hours {
    group_label: "> Durations"
    label: "SUM Transition Idle Hours"
    description: "Number of hours spent on transition idle. Including all flows"
    type: sum
    sql: ${session_duration_hours} ;;
    filters: [session_type: "transition_idle"]
    value_format_name: decimal_2
  }

  measure: sum_of_limit_idle_session_duration_hours {
    group_label: "> Durations"
    label: "SUM Limit Idle Hours"
    description: "Number of hours spent on limit idle. Including all flows"
    type: sum
    sql: ${session_duration_hours} ;;
    filters: [session_type: "limit_idle"]
    value_format_name: decimal_2
  }

  measure: avg_limit_idle_session_duration_hours {
    group_label: "> Durations"
    label: "AVG Limit Idle Hours"
    description: "AVG Number of hours spent on limit idle. Including all flows"
    type: average
    sql: ${session_duration_hours} ;;
    filters: [session_type: "limit_idle"]
    value_format_name: decimal_2
  }

  measure: avg_transition_idle_session_duration_hours {
    group_label: "> Durations"
    label: "AVG Transition Idle Hours"
    description: "AVG Number of hours spent on transition idle. Including all flows"
    type: average
    sql: ${session_duration_hours} ;;
    filters: [session_type: "transition_idle"]
    value_format_name: decimal_2
  }

  measure: avg_internal_idle_session_duration_hours {
    group_label: "> Durations"
    label: "AVG Flow Idle Hours"
    description: "AVG Number of hours spent on flow idle. Including all flows"
    type: average
    sql: ${session_duration_hours} ;;
    filters: [session_type: "flow_idle"]
    value_format_name: decimal_2
  }

  measure: share_of_direct_session_duration_hours_over_all_hours {
    group_label: "> Durations"
    label: "% Direct Hours"
    description: "Number of hours spent on any direct process divided by all worked hours."
    type: number
    sql: safe_divide(${sum_of_direct_session_duration_hours},${sum_of_session_duration_hours}) ;;
    value_format_name: percent_1
  }

  measure: share_of_internal_idle_session_duration_hours_over_all_hours {
    group_label: "> Durations"
    label: "% Flow Idle Hours"
    description: "Number of hours spent on flow idle divided by all worked hours."
    type: number
    sql: safe_divide(${sum_of_internal_idle_session_duration_hours},${sum_of_session_duration_hours}) ;;
    value_format_name: percent_1
  }

  measure: share_of_transition_idle_session_duration_hoursover_all_hours {
    group_label: "> Durations"
    label: "% Transition Idle Hours"
    description: "Number of hours spent on transition idle divided by all worked hours."
    type: number
    sql: safe_divide(${sum_of_transition_idle_session_duration_hours},${sum_of_session_duration_hours}) ;;
    value_format_name: percent_1
  }

  measure: share_of_limit_idle_session_duration_hours_over_all_hours {
    group_label: "> Durations"
    label: "% Limit Idle Hours"
    description: "Number of hours spent on limit idle divided by all worked hours."
    type: number
    sql: safe_divide(${sum_of_limit_idle_session_duration_hours},${sum_of_session_duration_hours}) ;;
    value_format_name: percent_1
  }

  measure: avg_session_duration_minutes {
    group_label: "> Durations"
    label: "AVG Session Duration Minutes"
    description: "Average difference between session ends at timestamp and session starts at timestamp. In minutes."
    type: average
    sql: ${session_duration_minutes} ;;
    value_format_name: decimal_2
  }

  measure: avg_session_duration_seconds {
    group_label: "> Durations"
    label: "AVG Session Duration Seconds"
    description: "Average difference between session ends at timestamp and session starts at timestamp. In seconds."
    type: average
    sql: ${session_duration_seconds} ;;
    value_format_name: decimal_0
  }

  measure: avg_session_duration_hours {
    group_label: "> Durations"
    label: "AVG Session Duration Hours"
    description: "Average difference between session ends at timestamp and session starts at timestamp. In hours."
    type: average
    sql: ${session_duration_hours} ;;
    value_format_name: decimal_2
  }

  measure: avg_pure_idle_seconds {
    group_label: "> Durations"
    label: "AVG Pure Idle Seconds"
    description: "Average number of seconds between the last event of the current session and the first event of the next session. Total session duration for idle sessions."
    type: average
    sql: ${pure_idle_seconds} ;;
    value_format_name: decimal_2
  }

  measure: avg_pure_idle_minutes {
    group_label: "> Durations"
    label: "AVG Pure Idle Minutes"
    description: "Average number of minutes between the last event of the current session and the first event of the next session. Total session duration for idle sessions."
    type: average
    sql: ${pure_idle_seconds}/60 ;;
    value_format_name: decimal_2
  }

  measure: sum_of_pure_idle_seconds {
    group_label: "> Durations"
    label: "SUM Pure Idle Seconds"
    description: "Sum of the number of seconds between the last event of the current session and the first event of the next session. Total session duration for idle sessions."
    type: sum
    sql: ${pure_idle_seconds} ;;
    value_format_name: decimal_0
  }

  measure: sum_of_pure_idle_minutes {
    group_label: "> Durations"
    label: "SUM Pure Idle Minutes"
    description: "Sum of the number of minutes between the last event of the current session and the first event of the next session. Total session duration for idle sessions."
    type: sum
    sql: ${pure_idle_seconds}/60 ;;
    value_format_name: decimal_1
  }

  measure: uph_picking {
    group_label: "> Productivity Metrics"
    type: number
    label: "UPH Order Preparation"
    description: "Units picked per Hour. Formula: # Picked Items /
    ( # Direct Order Preparation Hours
    + # Flow Order Preparation Hours
    + # Transition Idle Order Preparation Hours
    + # Limit Idle Order Preparation Hours)"
    value_format_name: decimal_0
    sql: safe_divide(${sum_of_number_of_picked_items},
      (${sum_of_direct_session_order_preparation_duration_hours}
      +${sum_of_internal_idle_session_order_preparation_duration_hours}
      + ${sum_of_transition_idle_session_duration_hours_leaving_order_preparation}
      + ${sum_of_limit_idle_session_duration_hours_order_preparation})) ;;
  }

  measure: oph_picking {
    group_label: "> Productivity Metrics"
    type: number
    description: "Orders picked per Hour. Formula: # Picked Orders /
    ( # Direct Order Preparation Hours
    + # Flow Order Preparation Hours
    + # Transition Idle Order Preparation Hours
    + # Limit Idle Order Preparation Hours)"
    label: "OPH"
    value_format_name: decimal_1
    sql: safe_divide(${sum_of_number_of_picked_orders},
      (${sum_of_direct_session_order_preparation_duration_hours}
      +${sum_of_internal_idle_session_order_preparation_duration_hours}
      + ${sum_of_transition_idle_session_duration_hours_leaving_order_preparation}
      + ${sum_of_limit_idle_session_duration_hours_order_preparation})) ;;
  }

  measure: uph_inbounding {
    group_label: "> Productivity Metrics"
    type: number
    label: "UPH Inbounding"
    description: "Units dropped per Hour. Formula:  # Dropped Items /
    ( # Direct Inbounding Hours
    + # Flow Inbounding Hours
    + # Transition Idle Inbounding Hours
    + # Limit Idle Inbounding Hours)"
    value_format_name: decimal_0
    sql: safe_divide(${sum_of_number_of_dropped_items},
      (${sum_of_direct_session_inbounding_duration_hours}
      +${sum_of_internal_idle_session_inbounding_duration_hours}
      + ${sum_of_transition_idle_session_duration_hours_leaving_inbounding}
      + ${sum_of_limit_idle_session_duration_hours_inbounding})) ;;
  }

  measure: uph_inventory_check {
    group_label: "> Productivity Metrics"
    type: number
    description: "Checks per Hour. Formula: # Checks /
    ( # Direct Inventory Hours
    + # Flow Inventory Hours
    + # Transition Idle Inventory Hours
    + # Limit Idle Inventory Hours )"
    label: "UPH Inventory Check"
    value_format_name: decimal_0
    sql: safe_divide(${sum_of_number_of_checks},
      (${sum_of_direct_session_inventory_check_duration_hours}
      +${sum_of_internal_idle_session_inventory_check_duration_hours}
      + ${sum_of_transition_idle_session_duration_hours_leaving_inventory_check}
      + ${sum_of_limit_idle_session_duration_hours_inventory_check}));;
  }

  measure: number_of_unique_activity_switch {
    type: count_distinct
    group_label: "> Quantities"
    label: "# Switchs"
    description: "Number of sessions where there is an activity switch."
    sql: ${session_uuid} ;;
    filters: [is_activity_switch: "yes"]
  }

  measure: number_of_unique_shifts {
    type: count_distinct
    group_label: "> Quantities"
    label: "# Shifts"
    description: "Number of unique shifts."
    sql: ${shift_id} ;;
  }

  measure: avg_number_of_activity_switch_per_shift {
    type: number
    group_label: "> Quantities"
    label: "AVG # Switchs per Shift"
    description: "Number of activity switchs divided by number of shifts."
    sql: ${number_of_unique_activity_switch}/${number_of_unique_shifts}  ;;
    value_format_name: decimal_0
  }


  measure: share_of_idle_session_duration_hours_over_all_hours {
    group_label: "> Durations"
    label: "% Idle Hours"
    description: "Number of hours spent on any idle (flow, transition, limit) divided by all worked hours."
    type: number
    sql: safe_divide( ${sum_of_internal_idle_session_duration_hours} +
                      ${sum_of_limit_idle_session_duration_hours}   +
                      ${sum_of_transition_idle_session_duration_hours},
                          ${sum_of_session_duration_hours}) ;;
    value_format_name: percent_1
  }

  ######## PARAMETERS

  parameter: date_granularity {
    group_label:  "> Dates & Timestamps"
    label: "Date Granularity"
    type: unquoted
    allowed_value: { value: "Day" }
    allowed_value: { value: "Week" }
    allowed_value: { value: "Month" }
    default_value: "Day"
  }

  parameter: dynamic_kpi_parameter {
    group_label: "> Dynamic KPIs"
    label: "OKR Level 1 KPIs (Dynamic)"
    type: unquoted
    allowed_value: {label: "% Idle Hours"           value: "hub_staff_idle" }
    allowed_value: {label: "UPH Order Preparation"  value: "uph_picking" }
    allowed_value: {label: "UPH Inbounding"         value: "uph_inbounding" }
    allowed_value: {label: "UPH Inventory Check"    value: "uph_inventory_check" }

    default_value: "hub_staff_idle"
  }

  ######## DYNAMIC DIMENSIONS

  dimension: date {
    group_label:  "> Dates & Timestamps"
    label: "Shift Date (Dynamic)"
    label_from_parameter: date_granularity
    sql:
    {% if date_granularity._parameter_value == 'Day' %}
      ${shift_date}
    {% elsif date_granularity._parameter_value == 'Week' %}
      ${shift_week}
    {% elsif date_granularity._parameter_value == 'Month' %}
      ${shift_month}
    {% endif %};;
  }

  measure: dynamic_kpi {
    type: number
    group_label: "> Dynamic KPIs"
    label: "OKR Level 1 KPIs (Dynamic)"
    description: "Make use of this dynamic KPI to switch between multiple measures that are considered to be OKR Level 1 by Ops."
    label_from_parameter: dynamic_kpi_parameter
    sql:
    {% if dynamic_kpi_parameter._parameter_value == 'hub_staff_idle' %}
      ${share_of_idle_session_duration_hours_over_all_hours}
    {% elsif dynamic_kpi_parameter._parameter_value == 'uph_picking' %}
      ${uph_picking}
    {% elsif dynamic_kpi_parameter._parameter_value == 'uph_inbounding' %}
      ${uph_inbounding}
    {% elsif dynamic_kpi_parameter._parameter_value == 'uph_inventory_check' %}
      ${uph_inventory_check}
    {% endif %}
    ;;

    html:
    {% if dynamic_kpi_parameter._parameter_value ==  'hub_staff_idle' %}
      {{share_of_idle_session_duration_hours_over_all_hours._rendered_value }}
    {% elsif dynamic_kpi_parameter._parameter_value == 'uph_picking' %}
      {{uph_picking._rendered_value }}
    {% elsif dynamic_kpi_parameter._parameter_value == 'uph_inbounding' %}
      {{uph_inbounding._rendered_value }}
    {% elsif dynamic_kpi_parameter._parameter_value == 'uph_inventory_check' %}
      {{uph_inventory_check._rendered_value }}
    {% endif %}
    ;;
  }

}
