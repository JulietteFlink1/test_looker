# Owner:   Nazrin Guliyeva
# Created: 2022-05-17

# This view contains forecast data from multiple forecast tables on timeslot, hub, and job date level.

view: forecasts {
  sql_table_name: `flink-data-prod.curated.forecasts`;;

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # =========  __main__   =========

  dimension: forecast_uuid {
    label: "Forecast UUID"
    type: string
    sql: ${TABLE}.forecast_uuid ;;
    hidden: yes
  }

  dimension: hub_code {
    label: "Hub Code"
    type: string
    sql: ${TABLE}.hub_code ;;
    hidden: yes
  }

  dimension: is_hub_open {
    label: "Is Hub Open"
    type: yesno
    sql: ${TABLE}.is_hub_open ;;
  }

  dimension: quinyx_pipeline_status {
    label: "Quinyx Pipeline Status"
    type: string
    sql: ${TABLE}.quinyx_pipeline_status ;;
  }

  # =========  Dates   =========

  dimension_group: end_timestamp {
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
    convert_tz: yes
    sql: ${TABLE}.start_timestamp ;;
    hidden: no
  }

  dimension_group: job {
    label: "Job"
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
    sql: ${TABLE}.job_date ;;
  }

  measure: count {
    type: count
    drill_fields: []
    hidden: yes
  }

  # =========  Forecasted minutes   =========

  dimension: number_of_forecasted_minutes_picker {
    label: "# Forecasted Picker Minutes"
    type: number
    sql: ${TABLE}.number_of_forecasted_minutes_picker ;;
    hidden: yes
  }

  dimension: number_of_forecasted_minutes_rider {
    label: "# Forecasted Rider Minutes"
    type: number
    sql: ${TABLE}.number_of_forecasted_minutes_rider ;;
    hidden: yes
  }

  # =========  Forecasted orders   =========

  dimension: number_of_forecasted_orders_lower_bound {
    label: "# Forecasted Orders - Lower Bound"
    type: number
    sql: ${TABLE}.number_of_forecasted_orders_lower_bound ;;
    hidden: yes
  }

  dimension: number_of_forecasted_orders_upper_bound {
    label: "# Forecasted Orders - Upper Bound"
    type: number
    sql: ${TABLE}.number_of_forecasted_orders_upper_bound ;;
    hidden: yes
  }

  # =========  Missed orders   =========

  dimension: number_of_missed_orders_forced_closure {
    label: "# Missed Orders - Forced Closure"
    type: number
    sql: ${TABLE}.number_of_missed_orders_forced_closure ;;
    hidden: yes
  }

  dimension: number_of_missed_orders_planned_closure {
    label: "# Missed Orders - Planned Closure"
    type: number
    sql: ${TABLE}.number_of_missed_orders_planned_closure ;;
    hidden: yes
  }

  # =========  No show  =========


  dimension: pct_forecasted_no_show_rider {
    group_label: ">> Rider Dimensions"
    label: "% No Show Rider"
    type: number
    value_format_name: percent_1
    sql: ${TABLE}.pct_forecasted_no_show_rider ;;
  }

  # =========  Idleness   =========

  dimension: pct_idleness_target_rider {
    group_label: ">> Rider Dimensions"
    label: "% Idleness Assumption Rider"
    type: number
    value_format_name: percent_1
    sql: ${TABLE}.pct_idleness_target_rider ;;
  }

  dimension: pct_idleness_target_picker {
    group_label: ">> Picker Dimensions"
    label: "% Idleness Assumption Picker"
    type: number
    value_format_name: percent_1
    sql: ${TABLE}.pct_idleness_target_picker ;;
  }

  dimension: forecast_horizon {
    label: "Forecast Horizon - Days"
    type: number
    value_format_name: percent_1
    sql:  date_diff(${start_timestamp_date}, ${job_date}, day) ;;
    }

  # =========  Stacking   =========

  # This metric has a value of 0 or default %. Therefore, while aggregating, we can use the max value to
  # avoid 0s
  dimension: pct_stacking_assumption {
    group_label: ">> Order Dimensions"
    label: "% Stacking Assumption"
    type: number
    value_format_name: percent_1
    sql: ${TABLE}.pct_stacking_assumption ;;
  }

  # This metric has multiple values throughout the day. While aggregating we should take the
  dimension: stacking_effect_multiplier {
    group_label: ">> Order Dimensions"
    label: "Stacking Effect Multiplier"
    type: number
    sql: ${TABLE}.stacking_effect_multiplier ;;
    hidden: no
    value_format_name: decimal_1
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~      Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # =========  UTR   =========

  measure: number_of_target_orders_per_picker {
    group_label: ">> Picker KPIs"
    label: "Base UTR Picker"
    description: "# Target Orders per Hour per Picker (Target UTR)"
    value_format_name: decimal_1
    type: average_distinct
    sql_distinct_key: concat(${job_date},${start_timestamp_raw},${hub_code}) ;;
    sql: ${TABLE}.number_of_target_orders_per_picker ;;
  }

  measure: number_of_target_orders_per_rider {
    group_label: ">> Rider KPIs"
    label: "Base UTR Rider"
    description: "# Target Orders per Hour per Rider (Target UTR)"
    value_format_name: decimal_1
    type: average_distinct
    sql_distinct_key: concat(${job_date},${start_timestamp_raw},${hub_code}) ;;
    sql: ${TABLE}.number_of_target_orders_per_rider ;;
  }

  measure: forecasted_base_utr_incl_stacking_picker {
    group_label: ">> Picker KPIs"
    label: "Base UTR Picker (Incl. Stacking)"
    description: "Base UTR Picker (Incl. Stacking) - Target UTR * Stacking Effect Multiplier"
    value_format_name: decimal_1
    type: average_distinct
    sql_distinct_key: concat(${job_date},${start_timestamp_raw},${hub_code}) ;;
    sql: ${TABLE}.forecasted_base_utr_incl_stacking_picker ;;
  }

  measure: forecasted_base_utr_incl_stacking_rider {
    group_label: ">> Rider KPIs"
    label: "Base UTR Rider (Incl. Stacking)"
    description: "Base UTR Rider (Incl. Stacking) - Target UTR * Stacking Effect Multiplier"
    value_format_name: decimal_1
    type: average_distinct
    sql_distinct_key: concat(${job_date},${start_timestamp_raw},${hub_code}) ;;
    sql: ${TABLE}.forecasted_base_utr_incl_stacking_rider ;;
  }

  measure: final_utr_picker {
    group_label: ">> Picker KPIs"
    label: "Final UTR Picker"
    description: "Final UTR - Forecasted Orders / Forecasted Hours"
    value_format_name: decimal_1
    sql: ${number_of_forecasted_orders}/nullif(${number_of_forecasted_hours_picker},0) ;;
  }

  measure: final_utr_rider {
    group_label: ">> Rider KPIs"
    label: "Final UTR Rider"
    description: "Final UTR - Forecasted Orders / Forecasted Hours"
    value_format_name: decimal_1
    sql: ${number_of_forecasted_orders}/nullif(${number_of_forecasted_hours_rider},0) ;;

  }

  # =========  Forecasted Employees   =========

  measure: number_of_forecasted_pickers {
    group_label: ">> Picker KPIs"
    label: "# Forecasted Pickers"
    type: sum_distinct
    sql_distinct_key: ${forecast_uuid} ;;
    sql: ${TABLE}.number_of_forecasted_pickers ;;
    hidden: yes
  }

  measure: number_of_forecasted_riders {
    group_label: ">> Rider KPIs"
    label: "# Forecasted Riders"
    type: sum_distinct
    sql_distinct_key: ${forecast_uuid} ;;
    sql: ${TABLE}.number_of_forecasted_riders ;;
  }

  # =========  No show   =========

  measure: number_of_forecasted_no_show_minutes_rider {
    group_label: ">> Rider KPIs"
    label: "# Forecasted No Show Minutes Rider"
    type: sum_distinct
    sql_distinct_key: ${forecast_uuid} ;;
    sql: ${TABLE}.number_of_forecasted_no_show_minutes_rider ;;
  }

  # =========  Forecasted orders   =========

  measure: number_of_forecasted_orders {
    group_label: ">> Order KPIs"
    label: "# Forecasted Orders"
    type: sum_distinct
    sql_distinct_key: concat(${job_date},${start_timestamp_raw},${hub_code}) ;;
    sql: ${TABLE}.number_of_forecasted_orders ;;
  }

  measure: forecasted_avg_order_handling_duration_seconds {
    group_label: ">> Order KPIs"
    label: "Forecasted Orders Handling Duration (Seconds)"
    type: average_distinct
    sql_distinct_key: concat(${job_date},${start_timestamp_raw},${hub_code}) ;;
    sql: ${TABLE}.forecasted_avg_order_handling_duration_seconds ;;
    value_format_name: decimal_1
  }

  measure: forecasted_avg_order_handling_duration_minutes {
    group_label: ">> Order KPIs"
    label: "Forecasted Orders Handling Duration (Minutes)"
    type: average_distinct
    sql_distinct_key: concat(${job_date},${start_timestamp_raw},${hub_code}) ;;
    sql: ${TABLE}.forecasted_avg_order_handling_duration_minutes ;;
    value_format_name: decimal_1
  }

  measure: number_of_missed_orders {
    group_label: ">> Order KPIs"
    label: "# Missed Orders"
    type: sum_distinct
    sql_distinct_key: concat(${job_date},${start_timestamp_raw},${hub_code}) ;;
    sql: ${TABLE}.number_of_missed_orders ;;
  }

##### Forecasted Hours
  measure: number_of_forecasted_hours_rider {
    group_label: ">> Rider KPIs"
    label: "# Forecasted Rider Hours"
    type: sum_distinct
    sql_distinct_key: ${forecast_uuid} ;;
    sql: ${number_of_forecasted_minutes_rider}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_forecasted_hours_picker {
    group_label: ">> Picker KPIs"
    label: "# Forecasted Picker Hours"
    type: sum_distinct
    sql_distinct_key: ${forecast_uuid} ;;
    sql: ${number_of_forecasted_minutes_picker}/60;;
    value_format_name: decimal_1
  }

  # =========  Dynamic values   =========

  measure: number_of_forecasted_employees_by_position {
    type: number
    label: "# Forecasted Employees"
    value_format_name: decimal_1
    group_label: ">> Dynamic KPIs"
    sql:
        CASE
          WHEN {% parameter ops.position_parameter %} = 'Rider' THEN ${number_of_forecasted_riders}
          WHEN {% parameter ops.position_parameter %} = 'Picker' THEN ${number_of_forecasted_pickers}
      ELSE NULL
      END ;;
    hidden: yes
  }

  measure: number_of_forecasted_hours_by_position {
    type: number
    label: "# Forecasted Hours (Incl. No Show)"
    value_format_name: decimal_1
    group_label: ">> Dynamic KPIs"
    sql:
        CASE
          WHEN {% parameter ops.position_parameter %} = 'Rider' THEN ${number_of_forecasted_hours_rider}
          WHEN {% parameter ops.position_parameter %} = 'Picker' THEN ${number_of_forecasted_hours_picker}
      ELSE NULL
      END ;;
  }

  measure: pct_no_show_by_position {
    type: number
    label: "% Forecasted No Show Hours"
    value_format_name: percent_1
    group_label: ">> Dynamic KPIs"
    sql:
        CASE
          WHEN {% parameter ops.position_parameter %} = 'Rider' THEN ${pct_forecasted_no_show_rider}
      ELSE NULL
      END ;;
      hidden: yes
  }

  measure: number_of_no_show_hours_by_position {
    type: number
    label: "# Forecasted No Show Hours"
    value_format_name: decimal_1
    group_label: ">> Dynamic KPIs"
    sql:
        CASE
          WHEN {% parameter ops.position_parameter %} = 'Rider' THEN ${number_of_forecasted_no_show_minutes_rider}/60
      ELSE NULL
      END ;;
  }

  measure: number_of_forecasted_hours_excl_no_show_by_position {
    type: number
    label: "# Forecasted Hours (Excl. No Show)"
    value_format_name: decimal_1
    group_label: ">> Dynamic KPIs"
    sql: ${number_of_forecasted_hours_by_position}-${number_of_no_show_hours_by_position} ;;
  }

  measure: number_of_target_orders_by_position {
    type: number
    label: "Base UTR"
    description: "# Target Orders per hour per Position"
    value_format_name: decimal_1
    group_label: ">> Dynamic KPIs"
    sql:
        CASE
          WHEN {% parameter ops.position_parameter %} = 'Rider' THEN ${number_of_target_orders_per_rider}
          WHEN {% parameter ops.position_parameter %} = 'Picker' THEN ${number_of_target_orders_per_picker}
      ELSE NULL
      END ;;
  }

  measure: base_utr_incl_stacking_by_position {
    type: number
    label: "Base UTR (Incl. Stacking)"
    description: "Base UTR * Stacking Effect Multiplier"
    value_format_name: decimal_1
    group_label: ">> Dynamic KPIs"
    sql:
        CASE
          WHEN {% parameter ops.position_parameter %} = 'Rider' THEN ${forecasted_base_utr_incl_stacking_rider}
          WHEN {% parameter ops.position_parameter %} = 'Picker' THEN ${forecasted_base_utr_incl_stacking_picker}
      ELSE NULL
      END ;;
  }

  measure: idleness_assumption_by_position {
    type: average
    label: "% Idleness Assumption"
    value_format_name: decimal_1
    group_label: ">> Dynamic KPIs"
    sql:
        CASE
          WHEN {% parameter ops.position_parameter %} = 'Rider' THEN ${pct_idleness_target_rider}
          WHEN {% parameter ops.position_parameter %} = 'Picker' THEN ${pct_idleness_target_picker}
      ELSE NULL
      END ;;
  }

  measure: final_utr_by_position {
    type: number
    label: "Final UTR"
    description: "Forecasted Orders/Forecasted Hours"
    value_format_name: decimal_1
    group_label: ">> Dynamic KPIs"
    sql: ${number_of_forecasted_orders}/nullif(${number_of_forecasted_hours_by_position},0);;
  }

  measure: actual_needed_hours_by_position {
    type: number
    label: "# Actually Needed Hours"
    description: "# Hours needed based on # Orders and forecasted UTR - # Orders/Base UTR (Target UTR)"
    value_format_name: decimal_1
    group_label: ">> Dynamic KPIs"
    sql: ${orders_cl.cnt_successful_orders}/nullif(${number_of_target_orders_by_position},0);;
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Parameters     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  parameter: position_parameter {
    type: string
    allowed_value: { value: "Rider" }
    allowed_value: { value: "Picker" }
  }

}
