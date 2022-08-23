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
    type: number
    sql: ${TABLE}.is_hub_open ;;
  }

  dimension: quinyx_pipeline_status {
    label: "Quinyx Pipeline Status"
    type: string
    sql: coalesce(${TABLE}.quinyx_pipeline_status, "N/A") ;;
  }

  dimension: forecast_horizon {
    label: "Forecast Horizon (Days)"
    type: number
    sql: date_diff(${start_timestamp_date}, ${job_date}, day) ;;
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
    hidden: yes
  }

  dimension: job_date {
    label: "Job Date"
    description: "Date when forecast ran"
    convert_tz: no
    datatype: date
    type: date
    sql: ${TABLE}.job_date ;;
  }

  dimension: job_date_2 {
    label: "Job Date - Day of the week"
    description: "This filter could be used to see respective day of the last week as a job date for each order date."
    convert_tz: no
    datatype: date
    type:  date
    sql:
      CASE
        WHEN {% parameter forecasts.dow_parameter %} = 'Monday' THEN date_trunc(${start_timestamp_date}, week(monday))-7
        WHEN {% parameter forecasts.dow_parameter %} = 'Tuesday' THEN date_trunc(${start_timestamp_date}, week(tuesday))-7
        WHEN {% parameter forecasts.dow_parameter %} = 'Wednesday' THEN date_trunc(${start_timestamp_date}, week(wednesday))-7
        WHEN {% parameter forecasts.dow_parameter %} = 'Thursday' THEN date_trunc(${start_timestamp_date}, week(thursday))-7
        WHEN {% parameter forecasts.dow_parameter %} = 'Friday' THEN date_trunc(${start_timestamp_date}, week(friday))-7
        WHEN {% parameter forecasts.dow_parameter %} = 'Saturday' THEN date_trunc(${start_timestamp_date}, week(saturday))-7
        WHEN {% parameter forecasts.dow_parameter %} = 'Sunday' THEN date_trunc(${start_timestamp_date}, week(sunday))-7
        ELSE NULL
      END ;;
    hidden: yes
  }

  measure: count {
    type: count
    drill_fields: []
    hidden: yes
  }

  # =========  Dimensions    =========

  dimension: number_of_adjusted_forecasted_hours_rider_dimension {
    label: "# Forecasted Rider Hours - Dimension"
    sql: ${TABLE}.number_of_adjusted_forecasted_minutes_rider/60 ;;
    hidden: yes
  }

  dimension: number_of_adjusted_forecasted_hours_picker_dimension {
    label: "# Forecasted Picker Hours - Dimension"
    sql: ${TABLE}.number_of_adjusted_forecasted_minutes_picker/60 ;;
    hidden: yes
  }

  # =========  Model names   =========
  dimension: model_name_historical_forecasts {
    group_label: "> Model Names"
    label: "Model Name: Order Forecast"
    type: string
    sql: ${TABLE}.model_name_historical_forecasts ;;
    hidden: no
  }

  dimension: model_name_headcount_riders_forecasts {
    alias: [model_name_headcount_forecasts]
    group_label: "> Model Names"
    label: "Model Name: Headcount Forecast (Riders)"
    type: string
    sql: ${TABLE}.model_name_headcount_riders_forecasts ;;
    hidden: no
  }

  dimension: model_name_headcount_pickers_forecasts {
    group_label: "> Model Names"
    label: "Model Name: Headcount Forecast (Pickers)"
    type: string
    sql: ${TABLE}.model_name_headcount_pickers_forecasts ;;
    hidden: no
  }

  dimension: model_name_riders_needed {
    group_label: "> Model Names"
    label: "Model Name: Riders Needed"
    type: string
    sql: ${TABLE}.model_name_riders_needed ;;
    hidden: no
  }

  dimension: model_name_pickers_needed {
    group_label: "> Model Names"
    label: "Model Name: Pickers Needed"
    type: string
    sql: ${TABLE}.model_name_pickers_needed ;;
    hidden: no
  }

  dimension: model_name_rider_idleness {
    group_label: "> Model Names"
    label: "Model Name: Rider Idleness"
    type: string
    sql: ${TABLE}.model_name_rider_idleness ;;
    hidden: no
  }

  dimension: model_name_picker_idleness {
    group_label: "> Model Names"
    label: "Model Name: Picker Idleness"
    type: string
    sql: ${TABLE}.model_name_picker_idleness ;;
    hidden: no
  }

  dimension: model_name_order_handling_duration {
    group_label: "> Model Names"
    label: "Model Name: Order Handling Duration"
    type: string
    sql: ${TABLE}.model_name_order_handling_duration ;;
    hidden: no
  }

  # =========  Forecasted orders   =========

  dimension: number_of_forecasted_orders_dimension {
    label: "# Forecasted Orders - Dimension"
    type: number
    sql: ${TABLE}.number_of_forecasted_orders;;
    hidden: yes
  }

  dimension: number_of_actual_orders_dimension {
    label: "# Actual Orders - Dimension"
    type: number
    sql: ${TABLE}.number_of_actual_orders;;
    hidden: yes
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~      Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # =========  Stacking   =========

  measure: stacking_effect_multiplier {
    group_label: "> Order Measures"
    label: "Stacking Effect Multiplier"
    type: average_distinct
    sql_distinct_key: concat(${job_date},${start_timestamp_raw},${hub_code}) ;;
    sql: ${TABLE}.stacking_effect_multiplier ;;
    hidden: yes
    value_format_name: decimal_1
  }

  measure: number_of_forecasted_stacked_orders {
    group_label: "> Order Measures"
    label: "# Forecasted Stacked Orders"
    type: sum_distinct
    value_format_name: decimal_1
    sql_distinct_key: concat(${job_date},${start_timestamp_raw},${hub_code}) ;;
    sql: ${TABLE}.number_of_forecasted_stacked_orders ;;
  }

  measure: pct_stacking_assumption {
    group_label: "> Order Measures"
    label: "% Stacking Assumption"
    description: "% Stacked Orders - Assumption"
    type: number
    value_format_name: percent_1
    sql: ${number_of_forecasted_stacked_orders}/nullif(${number_of_forecasted_orders},0) ;;
  }
  # =========  No show  =========


  measure: pct_forecasted_no_show_rider {
    group_label: "> Rider Measures"
    label: "% No Show Riders"
    type: number
    value_format_name: percent_1
    sql: ${TABLE}.pct_forecasted_no_show_rider ;;
    hidden: yes
  }

  measure: number_of_forecasted_no_show_minutes_rider {
    group_label: "> Rider Measures"
    label: "# Forecasted No Show Minutes Rider"
    type: sum_distinct
    sql_distinct_key: ${forecast_uuid} ;;
    sql: ${TABLE}.number_of_forecasted_no_show_minutes_rider ;;
    hidden: yes
  }


  # =========  Idleness minutes   =========

  measure: number_of_forecasted_idleness_minutes_picker {
    group_label: "> Picker Measures"
    label: "# Forecasted Idle Picker Minutes"
    type: sum_distinct
    sql_distinct_key: concat(${job_date},${start_timestamp_raw},${hub_code}) ;;
    sql: ${TABLE}.number_of_forecasted_idleness_minutes_picker ;;
    hidden: yes
  }

  measure: number_of_forecasted_idleness_minutes_rider {
    group_label: "> Rider Measures"
    label: "# Forecasted Idle Rider Minutes"
    type: sum_distinct
    sql_distinct_key: concat(${job_date},${start_timestamp_raw},${hub_code}) ;;
    sql: ${TABLE}.number_of_forecasted_idleness_minutes_rider ;;
    hidden: yes
  }

  measure: pct_idleness_target_rider {
    group_label: "> Rider Measures"
    label: "% Idleness Assumption Rider"
    description: "% Time Rider is Idle"
    type: number
    value_format_name: percent_1
    sql: ${number_of_forecasted_idleness_minutes_rider}/nullif(${number_of_forecasted_minutes_rider},0) ;;
  }

  measure: pct_idleness_target_picker {
    group_label: "> Picker Measures"
    label: "% Idleness Assumption Picker"
    description: "% Time Picker is Idle"
    type: number
    value_format_name: percent_1
    sql: ${number_of_forecasted_idleness_minutes_picker}/nullif(${number_of_forecasted_minutes_picker},0) ;;
  }

  # =========  UTR   =========

  measure: number_of_target_orders_per_picker {
    group_label: "> Picker Measures"
    label: "Base UTR Picker"
    description: "# Target Orders per Hour per Picker (Target UTR)"
    value_format_name: decimal_1
    type: average_distinct
    sql_distinct_key: concat(${job_date},${start_timestamp_raw},${hub_code}) ;;
    sql: ${TABLE}.number_of_target_orders_per_picker ;;
  }

  measure: number_of_target_orders_per_rider {
    group_label: "> Rider Measures"
    label: "Base UTR Rider"
    description: "# Target Orders per Hour per Rider (Target UTR)"
    value_format_name: decimal_1
    type: average_distinct
    sql_distinct_key: concat(${job_date},${start_timestamp_raw},${hub_code}) ;;
    sql: ${TABLE}.number_of_target_orders_per_rider ;;
  }

  measure: forecasted_base_utr_incl_stacking_picker {
    group_label: "> Picker Measures"
    label: "Base UTR Picker (Incl. Stacking)"
    description: "Base UTR Picker (Incl. Stacking) - Target UTR * Stacking Effect Multiplier"
    type: number
    value_format_name: decimal_1
    sql: ${number_of_target_orders_per_picker}*${stacking_effect_multiplier} ;;
  }

  measure: forecasted_base_utr_incl_stacking_rider {
    group_label: "> Rider Measures"
    label: "Base UTR Rider (Incl. Stacking)"
    description: "Base UTR Rider (Incl. Stacking) - Target UTR * Stacking Effect Multiplier"
    type:  number
    value_format_name: decimal_1
    sql: ${number_of_target_orders_per_rider}*${stacking_effect_multiplier} ;;
  }

  measure: final_utr_picker {
    group_label: "> Picker Measures"
    label: "Forecasted UTR Picker"
    description: "Forecasted Orders / Forecasted Picker Hours"
    value_format_name: decimal_1
    sql: ${number_of_forecasted_orders}/nullif(${number_of_forecasted_hours_picker},0) ;;
  }

  measure: final_utr_rider {
    group_label: "> Rider Measures"
    label: "Forecasted UTR Rider"
    description: "Forecasted Orders / Forecasted Rider Hours"
    value_format_name: decimal_1
    sql: ${number_of_forecasted_orders}/nullif(${number_of_forecasted_hours_rider},0) ;;

  }

  # =========  Forecasted Employees   =========

  measure: number_of_forecasted_pickers {
    group_label: "> Picker Measures"
    label: "# Forecasted Pickers"
    description: "# Forecasted Pickers Needed"
    type: sum_distinct
    sql_distinct_key: ${forecast_uuid} ;;
    sql: ${TABLE}.number_of_forecasted_pickers ;;
    hidden: no
  }

  measure: number_of_forecasted_riders {
    group_label: "> Rider Measures"
    label: "# Forecasted Riders"
    description: "# Forecasted Riders Needed"
    type: sum_distinct
    sql_distinct_key: ${forecast_uuid} ;;
    sql: ${TABLE}.number_of_forecasted_riders ;;
    hidden: no
  }

  # =========  Forecasted orders   =========

  measure: number_of_forecasted_orders {
    group_label: "> Order Measures"
    label: "# Forecasted Orders"
    type: sum_distinct
    sql_distinct_key: concat(${job_date},${start_timestamp_raw},${hub_code}) ;;
    sql: ${TABLE}.number_of_forecasted_orders ;;
    value_format_name: decimal_0
  }

  measure: number_of_actual_orders {
    group_label: "> Order Measures"
    label: "# Actual Orders (Forecast-related)"
    description: "# Actual Orders - Excl. Click&Collect and External Orders. Including Cancelled Orders"
    type: sum_distinct
    sql_distinct_key: concat(${job_date},${start_timestamp_raw},${hub_code}) ;;
    sql: ${TABLE}.number_of_actual_orders ;;
    value_format_name: decimal_0
  }

  measure: pct_forecast_deviation {
    group_label: "> Order Measures"
    label: "% Order Forecast Deviation"
    description: "(# Actual Orders / # Forecasted Orders) -1"
    type: number
    sql: abs((${number_of_actual_orders}/nullif(${number_of_forecasted_orders},0))-1) ;;
    value_format_name: percent_1
  }

  measure: pct_forecast_deviation_handling_duration {
    group_label: "> Order Measures"
    label: "% Rider Handling Duration Forecast Deviation"
    description: "(AVG Rider Handling Duration (Minutes) / Forecasted AVG Rider Handling Duration) -1"
    type: number
    sql: abs((${orders_with_ops_metrics.avg_rider_handling_time}/nullif(${forecasted_avg_order_handling_duration_minutes},0))-1) ;;
    value_format_name: percent_1
  }

  measure: pct_forecast_deviation_hours {
    group_label: "> Dynamic Measures"
    label: "% Scheduled Hours Forecast Deviation"
    description: "(# Scheduled Hours / # Forecasted Hours) -1"
    type: number
    sql: abs((${ops.number_of_scheduled_hours_by_position}/nullif(${number_of_adjusted_forecasted_hours_by_position},0))-1) ;;
    value_format_name: percent_1
  }

  measure: forecasted_avg_order_handling_duration_seconds {
    group_label: "> Order Measures"
    label: "Forecasted AVG Rider Handling Time (Seconds)"
    description: "Forecasted AVG Total Rider Handling Time: Riding to Customer + At customer + Riding to Hub"
    type: average_distinct
    sql_distinct_key: concat(${job_date},${start_timestamp_raw},${hub_code}) ;;
    sql: ${TABLE}.forecasted_avg_order_handling_duration_seconds ;;
    value_format_name: decimal_1
  }

  measure: forecasted_avg_order_handling_duration_minutes {
    group_label: "> Order Measures"
    label: "Forecasted AVG Rider Handling Time (Minutes)"
    description: "Forecasted AVG Total Rider Handling Time: Riding to Customer + At customer + Riding to Hub"
    type: average_distinct
    sql_distinct_key: concat(${job_date},${start_timestamp_raw},${hub_code}) ;;
    sql: ${TABLE}.forecasted_avg_order_handling_duration_minutes ;;
    value_format_name: decimal_1
  }

  ##### Forecasted Hours

  # =========  Forecasted minutes   =========

  measure: number_of_forecasted_minutes_picker {
    label: "# Forecasted Picker Minutes"
    type: sum_distinct
    sql_distinct_key: ${forecast_uuid} ;;
    sql: ${TABLE}.number_of_forecasted_minutes_picker ;;
    hidden: yes
  }

  measure: number_of_forecasted_minutes_rider {
    label: "# Forecasted Rider Minutes"
    type: sum_distinct
    sql_distinct_key: ${forecast_uuid} ;;
    sql: ${TABLE}.number_of_forecasted_minutes_rider ;;
    hidden: yes
  }

  measure: number_of_adjusted_forecasted_minutes_picker {
    label: "# Forecasted Picker Minutes - Post Adjustments"
    type: sum_distinct
    sql_distinct_key: ${forecast_uuid} ;;
    sql: ${TABLE}.number_of_adjusted_forecasted_minutes_picker ;;
    hidden: yes
  }

  measure: number_of_adjusted_forecasted_minutes_rider {
    label: "# Forecasted Rider Minutes - Post Adjustments"
    type: sum_distinct
    sql_distinct_key: ${forecast_uuid} ;;
    sql: ${TABLE}.number_of_adjusted_forecasted_minutes_rider ;;
    hidden: yes
  }

  measure: number_of_forecasted_hours_rider {
    group_label: "> Rider Measures"
    label: "# Forecasted Rider Hours"
    description: "# Forecasted Hours Needed for Riders (Excl. Airtable Adjustments)"
    type: number
    sql: ${number_of_forecasted_minutes_rider}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_forecasted_hours_picker {
    group_label: "> Picker Measures"
    label: "# Forecasted Picker Hours"
    description: "# Forecasted Hours Needed for Pickers (Excl. Airtable Adjustments)"
    type: number
    sql: ${number_of_forecasted_minutes_picker}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_adjusted_forecasted_hours_rider {
    group_label: "> Rider Measures"
    label: "# Forecasted Rider Hours - Post Adjustments (Incl. Airtable Adjustments)"
    type: number
    sql: ${number_of_adjusted_forecasted_minutes_rider}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_forecasted_adjusted_hours_picker {
    group_label: "> Picker Measures"
    label: "# Forecasted Picker Hours - Post Adjustments (Incl. Airtable Adjustments)"
    type: number
    sql: ${number_of_adjusted_forecasted_minutes_picker}/60;;
    value_format_name: decimal_1
  }
  ##### Forecast errors

  measure: wmape_orders {
    group_label: "> Forecasting error"
    label: "wMAPE - Order"
    description: "Summed Absolute Difference of Orders per Hub in 30 min/ # Actual Orders"
    type: number
    sql: ${summed_absolute_error}/nullif(${number_of_actual_orders},0);;
    value_format_name: percent_2
  }

  measure: summed_absolute_error {
    type: sum_distinct
    sql_distinct_key: concat(${job_date},${start_timestamp_raw},${hub_code}) ;;
    hidden: yes
    sql: ABS(${number_of_forecasted_orders_dimension} - ${number_of_actual_orders_dimension});;
  }

  measure: wmape_hours {
    group_label: "> Forecasting error"
    label: "wMAPE - Scheduled Hours"
    description: "Summed Absolute Difference of Scheduled Hours per Hub in 30 min (# Forecasted Hours (Incl. Airtable Adjustments)- # Scheduled Hours)/ # Scheduled Hours"
    type: number
    sql: ${summed_absolute_error_hours}/nullif(${ops.number_of_scheduled_hours_by_position},0);;
    value_format_name: percent_2
  }

  measure: summed_absolute_error_hours {
    type: sum_distinct
    sql_distinct_key: concat(${job_date},${start_timestamp_raw},${hub_code}) ;;
    hidden: yes
    sql: ABS(${number_of_adjusted_forecasted_hours_by_position_dimension} - ${ops.number_of_scheduled_hours_by_position_dimension});;
  }

  # =========  Dynamic values   =========

  measure: number_of_forecasted_employees_by_position {
    type: number
    label: "# Forecasted Employees"
    description: "# Forecasted Employees Needed (Excl. Airtable Adjustments)"
    value_format_name: decimal_1
    group_label: "> Dynamic Measures"
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
    description: "# Forecasted Hours Needed (Excl. Airtable Adjustments) - No Show Forecasts included in Total Forecasted Hours"
    value_format_name: decimal_1
    group_label: "> Dynamic Measures"
    sql:
        CASE
          WHEN {% parameter ops.position_parameter %} = 'Rider' THEN ${number_of_forecasted_hours_rider}
          WHEN {% parameter ops.position_parameter %} = 'Picker' THEN ${number_of_forecasted_hours_picker}
      ELSE NULL
      END ;;
  }

  dimension: number_of_adjusted_forecasted_hours_by_position_dimension {
    type: number
    label: "# Forecasted Hours - Post Adjustment (Incl. No Show) - Dimension"
    description: "# Forecasted Hours Needed (Incl. Airtable Adjustments) - No Show Forecasts included in Total Forecasted Hours and not added here explicitly"
    value_format_name: decimal_1
    group_label: "> Dynamic Measures"
    sql:
        CASE
          WHEN {% parameter ops.position_parameter %} = 'Rider' THEN ${number_of_adjusted_forecasted_hours_rider_dimension}
          WHEN {% parameter ops.position_parameter %} = 'Picker' THEN ${number_of_adjusted_forecasted_hours_picker_dimension}
      ELSE NULL
      END ;;
  }


  measure: number_of_adjusted_forecasted_hours_by_position {
    type: number
    label: "# Forecasted Hours - Post Adjustment (Incl. No Show)"
    description: "# Forecasted Hours Needed (Incl. Airtable Adjustments) - No Show Forecasts included in Total Forecasted Hours and not added here explicitly"
    value_format_name: decimal_1
    group_label: "> Dynamic Measures"
    sql:
        CASE
          WHEN {% parameter ops.position_parameter %} = 'Rider' THEN ${number_of_adjusted_forecasted_hours_rider}
          WHEN {% parameter ops.position_parameter %} = 'Picker' THEN ${number_of_forecasted_adjusted_hours_picker}
      ELSE NULL
      END ;;
  }

  measure: number_of_no_show_hours_by_position {
    type: number
    label: "# Forecasted No Show Hours"
    description: "# Forecasted No Show Hours (Based on Forecasted Hours (Excl. Airtable Adjustments))"
    value_format_name: decimal_1
    group_label: "> Dynamic Measures"
    sql:
        CASE
          WHEN {% parameter ops.position_parameter %} = 'Rider' THEN ${number_of_forecasted_no_show_minutes_rider}/60
      ELSE NULL
      END ;;
  }

  measure: pct_no_show_by_position {
    type: number
    label: "% Forecasted No Show Hours"
    description: "# Forecasted No Show Hours / # Forecasted Hours (Incl. Airtable Adjustments)"
    value_format_name: percent_1
    group_label: "> Dynamic Measures"
    sql:
        CASE
          WHEN {% parameter ops.position_parameter %} = 'Rider' THEN ${number_of_no_show_hours_by_position}/nullif(${number_of_adjusted_forecasted_hours_by_position},0)
      ELSE NULL
      END ;;
  }

  measure: number_of_forecasted_hours_excl_no_show_by_position {
    type: number
    label: "# Forecasted Hours (Excl. No Show)"
    description: "# Forecasted Hours Needed (Excl. Airtable Adjustments) - No Show Forecasts excluded in Total Forecasted Hours (# Forecasted Hours Needed - # Forecasted No Show Hours)"
    value_format_name: decimal_1
    group_label: "> Dynamic Measures"
    sql: ${number_of_forecasted_hours_by_position}-${number_of_no_show_hours_by_position} ;;
  }

  measure: number_of_adjusted_forecasted_hours_excl_no_show_by_position {
    type: number
    label: "# Forecasted Hours - Post Adjustment (Excl. No Show)"
    description: "# Forecasted Hours Needed (Incl. Airtable Adjustments) - No Show Forecasts excluded in Total Forecasted Hours (# Forecasted Hours Needed - # Forecasted No Show Hours)"
    value_format_name: decimal_1
    group_label: "> Dynamic Measures"
    sql: ${number_of_adjusted_forecasted_hours_by_position}-${number_of_no_show_hours_by_position} ;;
  }

  measure: number_of_target_orders_by_position {
    type: number
    label: "Base UTR"
    description: "# Target Orders per Hour per Position"
    value_format_name: decimal_1
    group_label: "> Dynamic Measures"
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
    description: "Base UTR by considering Stacking (Base UTR * Stacking Effect Multiplier)"
    value_format_name: decimal_1
    group_label: "> Dynamic Measures"
    sql:
        CASE
          WHEN {% parameter ops.position_parameter %} = 'Rider' THEN ${forecasted_base_utr_incl_stacking_rider}
          WHEN {% parameter ops.position_parameter %} = 'Picker' THEN ${forecasted_base_utr_incl_stacking_picker}
      ELSE NULL
      END ;;
  }

  measure: idleness_assumption_by_position {
    label: "% Idleness Assumption"
    description: "% Time an employee is idle"
    value_format_name: percent_1
    group_label: "> Dynamic Measures"
    sql:
        CASE
          WHEN {% parameter ops.position_parameter %} = 'Rider' THEN ${pct_idleness_target_rider}
          WHEN {% parameter ops.position_parameter %} = 'Picker' THEN ${pct_idleness_target_picker}
      ELSE NULL
      END ;;
  }

  measure: final_utr_by_position {
    type: number
    label: "Forecasted UTR"
    description: "Forecasted Orders/Forecasted Hours (Incl. Airtable Adjustments)"
    value_format_name: decimal_1
    group_label: "> Dynamic Measures"
    sql: ${number_of_forecasted_orders}/nullif(${number_of_adjusted_forecasted_hours_by_position},0);;
  }

  parameter: dynamic_text_utr {
    label: "Define Target UTR"
    description: "Use this field to calculate Actually Needed Hours"
    type: number
    #required_fields: [dynamic_text_utr]
  }

  measure: actual_needed_hours_by_position {
    type: number
    label: "# Actually Needed Hours (Dynamic)"
    description: "# Hours needed based on # Orders and User-defined UTR - # Orders/Defined UTR"
    value_format_name: decimal_1
    group_label: "> Dynamic Measures"
    sql: nullif(${orders_with_ops_metrics.sum_orders},0)/nullif({% parameter dynamic_text_utr %},0);;
  }

  measure: fixed_actual_needed_hours_by_position {
    type: number
    label: "# Actually Needed Hours"
    description: "# Hours needed based on # Actual Orders / Forecasted UTR"
    value_format_name: decimal_1
    group_label: "> Dynamic Measures"
    sql: nullif(${orders_with_ops_metrics.sum_orders},0)/nullif(${final_utr_by_position},0);;
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Parameters     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  parameter: position_parameter {
    type: string
    allowed_value: { value: "Rider" }
    allowed_value: { value: "Picker" }
    hidden: yes
  }

  parameter: dow_parameter {
    label: "Job day of the week (Last week)"
    type: string
    allowed_value: { value: "Monday" }
    allowed_value: { value: "Tuesday" }
    allowed_value: { value: "Wednesday" }
    allowed_value: { value: "Thursday" }
    allowed_value: { value: "Friday" }
    allowed_value: { value: "Saturday" }
    allowed_value: { value: "Sunday" }
    hidden: no
  }

}
