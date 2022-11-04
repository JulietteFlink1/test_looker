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
    hidden: yes
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

  dimension: is_forecast_hub {
    label: "Is forecast hub?"
    description: "Yes, if the hub has forecast for the given job date"
    type: yesno
    sql: ${TABLE}.is_forecasted;;
    hidden: no
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
    description: "Fetching respective weekdays based on timeslot date"
    convert_tz: no
    datatype: date
    type:  date
    sql:
      case
        when {% parameter forecasts.dow_parameter %} = 'Monday' then date_trunc(${start_timestamp_date}, week(monday)) - 7
        when {% parameter forecasts.dow_parameter %} = 'Tuesday' then date_trunc(${start_timestamp_date}, week(monday)) - 6
        when {% parameter forecasts.dow_parameter %} = 'Wednesday' then date_trunc(${start_timestamp_date}, week(monday)) - 5
        when {% parameter forecasts.dow_parameter %} = 'Thursday' then date_trunc(${start_timestamp_date}, week(monday)) - 4
        when {% parameter forecasts.dow_parameter %} = 'Friday' then date_trunc(${start_timestamp_date}, week(monday)) - 3
        when {% parameter forecasts.dow_parameter %} = 'Saturday' then date_trunc(${start_timestamp_date}, week(monday)) - 2
        when {% parameter forecasts.dow_parameter %} = 'Sunday' then date_trunc(${start_timestamp_date}, week(monday)) - 1
        else null
      end ;;
    hidden: yes
  }

  measure: count {
    type: count
    drill_fields: []
    hidden: yes
  }


  # =========  Model names   =========

  dimension: model_name_riders_needed {
    group_label: "> Model Names"
    label: "Model Name: Riders Needed"
    type: string
    sql: ${TABLE}.model_name_riders_needed ;;
    hidden: no
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~     Dimensions from Measures     ~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # =========  Forecasted Orders   =========

  dimension: number_of_forecasted_orders_dimension {
    label: "# Forecasted Orders - Dimension"
    type: number
    sql: ${TABLE}.number_of_forecasted_orders;;
    hidden: yes
  }

  dimension: number_of_forecasted_orders_adjusted_dimension {
    alias: [number_of_adjusted_forecasted_orders_dimension]
    label: "# Adjusted Forecasted Orders - Dimension"
    type:  number
    sql: ${TABLE}.number_of_forecasted_orders_adjusted;;
    hidden:  yes
  }

  dimension: number_of_actual_orders_dimension {
    label: "# Actual Orders (Forecast-Related) - Dimension"
    type: number
    sql: ${TABLE}.number_of_actual_orders;;
    hidden: yes
  }

  dimension: number_of_cancelled_orders_dimension {
    label: "# Cancelled Orders - Dimension"
    type: number
    sql: ${TABLE}.number_of_cancelled_orders;;
    hidden: yes
  }

  # =========  Forecasted Hours   =========

  dimension: number_of_forecasted_hours_rider_adjusted_dimension {
    alias: [number_of_adjusted_forecasted_hours_rider_dimension]
    label: "# Adjusted Forecasted Rider Hours - Dimension"
    sql: ${TABLE}.number_of_forecasted_minutes_rider_adjusted/60 ;;
    hidden: yes
  }

  dimension: number_of_forecasted_hours_rider_dimension {
    label: "# Forecasted Rider Hours - Dimension"
    sql: ${TABLE}.number_of_forecasted_minutes_rider/60 ;;
    hidden: yes
  }

  dimension: number_of_forecasted_hours_picker_adjusted_dimension {
    alias: [number_of_adjusted_forecasted_hours_picker_dimension]
    label: "# Adjusted Forecasted Picker Hours - Dimension"
    sql: ${TABLE}.number_of_forecasted_minutes_picker_adjusted/60 ;;
    hidden: yes
  }

  dimension: number_of_forecasted_hours_picker_dimension {
    label: "# Forecasted Picker Hours - Dimension"
    sql: ${TABLE}.number_of_forecasted_minutes_picker/60 ;;
    hidden: yes
  }

  # =========  Forecasted No Show Hours   =========


  dimension: number_of_forecasted_no_show_hours_rider_dimension {
    group_label: "> Rider Measures"
    label: "# Forecasted No Show Minutes Rider"
    sql: ${TABLE}.number_of_forecasted_no_show_minutes_rider/60 ;;
    hidden: yes
  }

  dimension: number_of_forecasted_no_show_hours_rider_adjusted_dimension {
    group_label: "> Rider Measures"
    label: "# Adjusted Forecasted No Show Minutes Rider"
    sql: ${TABLE}.number_of_forecasted_no_show_minutes_rider_adjusted/60 ;;
    hidden: yes
  }

  measure: number_of_max_forecasted_rider {
    type: max
    label: "# Max Forecasted Rider"
    description: "The number of maximum forecasted riders per 30 minutes block. (Incl. Airtable Adjustments)"
    sql: ${TABLE}.number_of_forecasted_minutes_rider_adjusted/30 ;;
  }

  # =========  Backlog bias   =========

  dimension: backlog_bias_numerator {
    group_label: "> Forecasting error"
    label: "Order forecast bias indicator that takes into account the amount of under-forecasting that has accumulated since the beginning of the day."
    sql: ${TABLE}.backlog_bias ;;
    hidden: yes
  }

  dimension: backlog_bias_denominator {
    group_label: "> Forecasting error"
    label: "Reflects the order forecast backlog bias multiplied by the actual number of orders."
    sql: ${TABLE}.backlog_bias_denominator ;;
    hidden: yes
  }

  dimension: pct_backlog_bias_dimension {
    group_label: "> Forecasting error"
    label: "Percentage of backlog bias (orders) over backlog bias denominator."
    sql: ${TABLE}.pct_backlog_bias ;;
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

  # =========  No show  =========


  measure: pct_forecasted_no_show_rider {
    group_label: "> Rider Measures"
    label: "% No Show Riders"
    type: number
    value_format_name: percent_1
    sql: ${TABLE}.pct_forecasted_no_show_rider ;;
    hidden: yes
  }

  measure: pct_forecasted_no_show_rider_adjusted {
    group_label: "> Rider Measures"
    label: "% Adjusted No Show Riders"
    type: number
    value_format_name: percent_1
    sql: ${TABLE}.pct_forecasted_no_show_rider_adjusted ;;
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

  measure: number_of_forecasted_no_show_minutes_rider_adjusted {
    group_label: "> Rider Measures"
    label: "# Adjusted Forecasted No Show Minutes Rider"
    type: sum_distinct
    sql_distinct_key: ${forecast_uuid} ;;
    sql: ${TABLE}.number_of_forecasted_no_show_minutes_rider_adjusted ;;
    hidden: yes
  }

  # =========  Idleness minutes   =========

  measure: number_of_forecasted_idleness_minutes_picker {
    group_label: "> Picker Measures"
    label: "# Forecasted Idle Picker Minutes"
    type: sum_distinct
    sql_distinct_key: concat(${job_date},${start_timestamp_raw},${hub_code}) ;;
    sql: ${TABLE}.number_of_forecasted_idleness_minutes_picker ;;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: number_of_forecasted_idleness_minutes_rider {
    group_label: "> Rider Measures"
    label: "# Forecasted Idle Rider Minutes"
    type: sum_distinct
    sql_distinct_key: concat(${job_date},${start_timestamp_raw},${hub_code}) ;;
    sql: ${TABLE}.number_of_forecasted_idleness_minutes_rider ;;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: number_of_forecasted_idleness_minutes_rider_adjusted {
    group_label: "> Rider Measures"
    label: "# Adjusted Forecasted Idle Rider Minutes"
    type: sum_distinct
    sql_distinct_key: concat(${job_date},${start_timestamp_raw},${hub_code}) ;;
    sql: ${TABLE}.number_of_forecasted_idleness_minutes_rider_adjusted ;;
    value_format_name: decimal_1
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

  measure: pct_idleness_target_rider_adjusted {
    group_label: "> Rider Measures"
    label: "% Adjusted Idleness Assumption Rider"
    description: "% Time Rider is Idle (Incl. Airtable Adjustments)"
    type: number
    value_format_name: percent_1
    sql: ${number_of_forecasted_idleness_minutes_rider_adjusted}/nullif(${number_of_forecasted_minutes_rider_adjusted},0) ;;
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
    description: "Calculated UTR based on formula - (power(60,2) * (1- idle_pct) / handling_duration) * stacking_multiplier"
    value_format_name: decimal_2
    type: average_distinct
    sql_distinct_key: concat(${job_date},${start_timestamp_raw},${hub_code}) ;;
    sql: ${TABLE}.number_of_target_orders_per_picker ;;
  }

  measure: number_of_target_orders_per_rider {
    group_label: "> Rider Measures"
    label: "Base UTR Rider"
    description: "Calculated UTR based on formula - (power(60,2) * (1- idle_pct) / handling_duration) * stacking_multiplier"
    value_format_name: decimal_2
    type: average_distinct
    sql_distinct_key: concat(${job_date},${start_timestamp_raw},${hub_code}) ;;
    sql: ${TABLE}.number_of_target_orders_per_rider ;;
  }

  measure: number_of_target_orders_per_rider_adjusted {
    group_label: "> Rider Measures"
    label: "Adjusted Base UTR Rider"
    description: "Adjusted calculated UTR based on formula (Incl. Airtable Adjustments) - (power(60,2) * (1- idle_pct) / handling_duration) * stacking_multiplier"
    value_format_name: decimal_2
    type: average_distinct
    sql_distinct_key: concat(${job_date},${start_timestamp_raw},${hub_code}) ;;
    sql: ${TABLE}.number_of_target_orders_per_rider_adjusted ;;
  }

  measure: final_utr_picker {
    group_label: "> Picker Measures"
    label: "Forecasted UTR Picker"
    description: "Forecasted Orders / Forecasted Picker Hours"
    value_format_name: decimal_2
    sql: ${number_of_forecasted_orders}/nullif(${number_of_forecasted_hours_picker},0) ;;
  }

  measure: final_utr_picker_adjusted {
    group_label: "> Picker Measures"
    label: "Adjusted Forecasted UTR Picker"
    description: "Adjusted Forecasted Orders / Adjusted Forecasted Picker Hours"
    value_format_name: decimal_2
    sql: ${number_of_forecasted_orders_adjusted}/nullif(${number_of_forecasted_hours_picker_adjusted},0) ;;
  }

  measure: final_utr_rider {
    group_label: "> Rider Measures"
    label: "Forecasted UTR Rider"
    description: "Forecasted Orders / Forecasted Rider Hours"
    value_format_name: decimal_2
    sql: ${number_of_forecasted_orders}/nullif(${number_of_forecasted_hours_rider},0) ;;
  }

  measure: final_utr_rider_adjusted {
    group_label: "> Rider Measures"
    label: "Adjusted Forecasted UTR Rider"
    description: "Adjusted Forecasted Orders / Adjusted Forecasted Rider Hours"
    value_format_name: decimal_2
    sql: ${number_of_forecasted_orders_adjusted}/nullif(${number_of_forecasted_hours_rider_adjusted},0) ;;
  }

  # =========  Forecasted Employees   =========

  measure: number_of_forecasted_pickers {
    group_label: "> Picker Measures"
    label: "# Forecasted Pickers"
    description: "# Forecasted Pickers Needed"
    type: sum_distinct
    sql_distinct_key: ${forecast_uuid} ;;
    sql: ${TABLE}.number_of_forecasted_pickers ;;
    hidden: yes
  }

  measure: number_of_forecasted_riders {
    group_label: "> Rider Measures"
    label: "# Forecasted Riders"
    description: "# Forecasted Riders Needed"
    type: sum_distinct
    sql_distinct_key: ${forecast_uuid} ;;
    sql: ${TABLE}.number_of_forecasted_riders ;;
    hidden: yes
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

  measure: number_of_missed_orders {
    group_label: "> Order Measures"
    label: "# Missed Orders"
    description: "# Missed orders due to planned or forced closures."
    type: sum_distinct
    sql_distinct_key: concat(${job_date},${start_timestamp_raw},${hub_code}) ;;
    sql: ${TABLE}.number_of_missed_orders ;;
    value_format_name: decimal_0
  }

  measure: number_of_missed_orders_forced_closure {
    group_label: "> Order Measures"
    label: "# Missed Orders - Forced Closure"
    description: "# Missed orders due to forced closure."
    type: sum_distinct
    sql_distinct_key: concat(${job_date},${start_timestamp_raw},${hub_code}) ;;
    sql: ${TABLE}.number_of_missed_orders_forced_closure ;;
    value_format_name: decimal_0
  }

  measure: number_of_missed_orders_planned_closure {
    group_label: "> Order Measures"
    label: "# Missed Orders - Planned Closure"
    description: "# Missed orders due to planned closure."
    type: sum_distinct
    sql_distinct_key: concat(${job_date},${start_timestamp_raw},${hub_code}) ;;
    sql: ${TABLE}.number_of_missed_orders_planned_closure ;;
    value_format_name: decimal_0
  }

  measure: number_of_forecasted_orders_adjusted {
    alias: [number_of_adjusted_forecasted_orders]
    group_label: "> Order Measures"
    label: "# Adjusted Forecasted Orders"
    type: sum_distinct
    sql_distinct_key: concat(${job_date},${start_timestamp_raw},${hub_code}) ;;
    sql: ${TABLE}.number_of_forecasted_orders_adjusted ;;
    value_format_name: decimal_0
  }

  measure: number_of_actual_orders {
    group_label: "> Order Measures"
    label: "# Actual Orders (Forecast-Related)"
    description: "# Actual orders related to forecast: Excl. click & collect and external orders; Including cancelled orders with operations-related cancellation reasons and missed orders (due to forced closures)."
    type: sum_distinct
    sql_distinct_key: concat(${job_date},${start_timestamp_raw},${hub_code}) ;;
    sql: ${TABLE}.number_of_actual_orders;;
    value_format_name: decimal_0
  }

  measure: number_of_cancelled_orders {
    group_label: "> Order Measures"
    label: "# Cancelled Orders (Forecast-Related)"
    description: "# Cancelled orders that are relevant for the forecast: Excl. click & collect and external orders; Including only operations-related cancellation reasons."
    type: sum_distinct
    sql_distinct_key: concat(${job_date},${start_timestamp_raw},${hub_code}) ;;
    sql: ${number_of_cancelled_orders_dimension} ;;
    value_format_name: decimal_0
  }

  measure: number_of_cancelled_and_missed_orders {
    group_label: "> Order Measures"
    label: "# Cancelled and Missed Orders (Forecast-Related)"
    description: "# Cancelled and missed orders that are relevant for the forecast: Excl. click & collect and external orders; Including only operations-related cancellation reasons and orders missed due to forced closures."
    type: number
    sql: ${number_of_cancelled_orders} + ${number_of_missed_orders_forced_closure} ;;
    value_format_name: decimal_0
  }

  measure: pct_actually_needed_hours_deviation {
    group_label: "> Dynamic Measures"
    label: "% Actually Needed Hours Deviation"
    description: "The degree of how far # Actually Needed Hours is from # Punched Hours in the given period. Formula:  (# Punched Hours / # Actually Needed Hours) - 1"
    type: number
    sql: (${ops.number_of_worked_hours_by_position}/nullif(${fixed_actual_needed_hours_by_position},0)) - 1 ;;
    value_format_name: percent_1
  }

  measure: hub_filter {
    label: "Are metrics available?"
    description: "This filter allows user to filter out hubs where there is no any scheduled hours or forecasted orders."
    sql:
        case
          when (${ops.number_of_scheduled_hours_by_position}+${number_of_forecasted_orders}+${orders_with_ops_metrics.sum_orders})<>0
            then true
          else false
        end;;
    type: yesno
  }

  measure: pct_forecasted_utr_deviation {
    group_label: "> Dynamic Measures"
    label: "% Forecasted UTR Deviation"
    description: "The degree of how far Forecasted UTR (# Forecasted Orders / # Forecasted Hours) is from Actual UTR in the given period. Formula:  (Forecasted UTR / Actual UTR) - 1"
    type: number
    sql: (${ops.utr_by_position}/nullif(${final_utr_by_position},0)) - 1 ;;
    value_format_name: percent_1
  }

  measure: pct_forecasted_utr_deviation_adjusted {
    group_label: "> Dynamic Measures"
    label: "% Adjusted Forecasted UTR Deviation"
    description: "The degree of how far Adjusted Forecasted UTR (# Adjusted Forecasted Orders / # Adjusted Forecasted Hours) is from Actual UTR in the given period. Formula:  (Adjusted Forecasted UTR / Actual UTR) - 1"
    type: number
    sql: (${ops.utr_by_position}/nullif(${final_utr_by_position_adjusted},0)) - 1 ;;
    value_format_name: percent_1
  }


  measure: pct_actually_needed_hours_deviation_adjusted {
    group_label: "> Dynamic Measures"
    label: "% Adjusted Actually Needed Hours Deviation"
    description: "The degree of how far # Actually Needed Hours (Incl. Airtable Adjustments) is from # Punched Hours in the given period. Formula:  (# Punched Hours / # Actually Needed Hours) - 1"
    type: number
    sql: (${ops.number_of_worked_hours_by_position}/nullif(${fixed_actual_needed_hours_by_position_adjusted},0)) - 1 ;;
    value_format_name: percent_1
  }

  measure: pct_forecast_deviation_no_show {
    group_label: "> Dynamic Measures"
    label: "% No Show Hours Deviation"
    description: "The degree of how far # Forecasted No Show Hours is from # Actual No Show Hours in the given period. Formula:  (# Actual No Show Hours / # Forecasted No Show Hours) - 1"
    type: number
    sql: (${ops.number_of_no_show_hours_by_position}/nullif(${number_of_no_show_hours_by_position},0)) - 1 ;;
    value_format_name: percent_1
  }

  measure: pct_forecast_deviation_no_show_adjusted {
    group_label: "> Dynamic Measures"
    label: "% Adjusted No Show Hours Deviation"
    description: "The degree of how far # Adjusted Forecasted No Show Hours (Incl. Airtable Adjustments) is from # Actual No Show Hours in the given period. Formula:  (# Actual No Show Hours / # Forecasted No Show Hours) - 1"
    type: number
    sql: (${ops.number_of_no_show_hours_by_position}/nullif(${number_of_no_show_hours_by_position_adjusted},0)) - 1 ;;
    value_format_name: percent_1
  }

  measure: pct_forecast_deviation {
    group_label: "> Order Measures"
    label: "% Order Forecast Deviation"
    description: "The degree of how far # Forecasted Orders is from # Actual Orders in the given period. Formula: (# Actual Orders / # Forecasted Orders) -1"
    type: number
    sql: (${number_of_actual_orders}/nullif(${number_of_forecasted_orders},0))-1 ;;
    value_format_name: percent_1
  }

  measure: pct_forecast_deviation_adjusted {
    alias: [pct_adjusted_forecast_deviation]
    group_label: "> Order Measures"
    label: "% Adjusted Order Forecast Deviation"
    description: "The degree of how far # Forecasted Orders (Incl. Airtable Adjustments) is from # Actual Orders in the given period. Formula: (# Actual Orders / # Forecasted Orders (Incl. Adjustments)) -1"
    type: number
    sql: (${number_of_actual_orders}/nullif(${number_of_forecasted_orders_adjusted},0))-1 ;;
    value_format_name: percent_1
  }

  measure: pct_forecast_deviation_handling_duration {
    group_label: "> Order Measures"
    label: "% Rider Handling Duration Forecast Deviation"
    description: "The degree of how far AVG Forecasted Rider Handling Duration is from AVG Actual Rider Handling Duration in the given period. Formula: (AVG Rider Handling Duration (Minutes) / Forecasted AVG Rider Handling Duration) - 1"
    type: number
    sql: (${orders_with_ops_metrics.avg_rider_handling_time}/nullif(${forecasted_avg_rider_handling_duration_minutes},0)) - 1 ;;
    value_format_name: percent_1
  }

  measure: pct_forecast_deviation_handling_duration_adjusted {
    group_label: "> Order Measures"
    label: "% Adjusted Rider Handling Duration Forecast Deviation"
    description: "The degree of how far Adjusted AVG Forecasted Rider Handling Duration is from AVG Actual Rider Handling Duration in the given period (Incl. Airtable Adjustments). Formula: (Adjusted AVG Rider Handling Duration (Minutes) / Adjusted Forecasted AVG Rider Handling Duration) - 1"
    type: number
    sql: (${orders_with_ops_metrics.avg_rider_handling_time}/nullif(${forecasted_avg_rider_handling_duration_minutes_adjusted},0)) - 1 ;;
    value_format_name: percent_1
  }

  measure: pct_forecast_deviation_hours {
    group_label: "> Dynamic Measures"
    label: "% Scheduled Hours Forecast Deviation"
    description: "The degree of how far # Forecasted Hours is from # Scheduled Hours in the given period. Formula: (# Scheduled Hours / # Forecasted Hours) - 1"
    type: number
    sql: (${ops.number_of_scheduled_hours_by_position}/nullif(${number_of_forecasted_hours_by_position},0)) - 1 ;;
    value_format_name: percent_1
  }

  measure: pct_forecast_deviation_hours_adjusted {
    group_label: "> Dynamic Measures"
    label: "% Adjusted Scheduled Hours Forecast Deviation"
    description: "The degree of how far # Forecasted Hours (Incl. Airtable Adjustments) is from # Scheduled Hours in the given period. Formula: (# Scheduled Hours / # Forecasted Hours) - 1"
    type: number
    sql: (${ops.number_of_scheduled_hours_by_position}/nullif(${number_of_forecasted_hours_by_position_adjusted},0)) - 1 ;;
    value_format_name: percent_1
  }

  measure: forecasted_avg_rider_handling_duration_seconds {
    alias: [forecasted_avg_order_handling_duration_seconds]
    group_label: "> Order Measures"
    label: "Forecasted AVG Rider Handling Time (Seconds)"
    description: "Forecasted AVG Total Rider Handling Time: Riding to Customer + At customer + Riding to Hub"
    type: average_distinct
    sql_distinct_key: concat(${job_date},${start_timestamp_raw},${hub_code}) ;;
    sql: ${TABLE}.forecasted_avg_rider_handling_duration_seconds ;;
    value_format_name: decimal_1
    filters: [is_hub_open: "1"]
  }

  measure: forecasted_avg_rider_handling_duration_minutes {
    alias: [forecasted_avg_order_handling_duration_minutes]
    group_label: "> Order Measures"
    label: "Forecasted AVG Rider Handling Time (Minutes)"
    description: "Forecasted AVG Total Rider Handling Time: Riding to Customer + At customer + Riding to Hub"
    type: average_distinct
    sql_distinct_key: concat(${job_date},${start_timestamp_raw},${hub_code}) ;;
    sql: ${TABLE}.forecasted_avg_rider_handling_duration_minutes ;;
    value_format_name: decimal_1
    filters: [is_hub_open: "1"]
  }

  measure: forecasted_avg_rider_handling_duration_seconds_adjusted {
    alias: [forecasted_avg_order_handling_duration_seconds_adjusted]
    group_label: "> Order Measures"
    label: "Adjusted Forecasted AVG Rider Handling Time (Seconds)"
    description: "Forecasted AVG Total Rider Handling Time: Riding to Customer + At customer + Riding to Hub (Incl. Airtable Adjustments)"
    type: average_distinct
    sql_distinct_key: concat(${job_date},${start_timestamp_raw},${hub_code}) ;;
    sql: ${TABLE}.forecasted_avg_rider_handling_duration_seconds_adjusted ;;
    value_format_name: decimal_1
    filters: [is_hub_open: "1"]
  }

  measure: forecasted_avg_rider_handling_duration_minutes_adjusted {
    alias: [forecasted_avg_order_handling_duration_minutes_adjusted]
    group_label: "> Order Measures"
    label: "Adjusted Forecasted AVG Rider Handling Time (Minutes)"
    description: "Forecasted AVG Total Rider Handling Time: Riding to Customer + At customer + Riding to Hub (Incl. Airtable Adjustments)"
    type: average_distinct
    sql_distinct_key: concat(${job_date},${start_timestamp_raw},${hub_code}) ;;
    sql: ${TABLE}.forecasted_avg_rider_handling_duration_minutes_adjusted ;;
    value_format_name: decimal_1
    filters: [is_hub_open: "1"]
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

  measure: number_of_forecasted_minutes_picker_adjusted {
    alias: [number_of_adjusted_forecasted_minutes_picker]
    label: "# Adjusted Forecasted Picker Minutes"
    type: sum_distinct
    sql_distinct_key: ${forecast_uuid} ;;
    sql: ${TABLE}.number_of_forecasted_minutes_picker_adjusted ;;
    hidden: yes
  }

  measure: number_of_forecasted_minutes_rider {
    label: "# Forecasted Rider Minutes"
    type: sum_distinct
    sql_distinct_key: ${forecast_uuid} ;;
    sql: ${TABLE}.number_of_forecasted_minutes_rider ;;
    hidden: yes
  }

  measure: number_of_forecasted_minutes_rider_adjusted {
    alias: [number_of_adjusted_forecasted_minutes_rider]
    label: "# Adjusted Forecasted Rider Minutes"
    type: sum_distinct
    sql_distinct_key: ${forecast_uuid} ;;
    sql: ${TABLE}.number_of_forecasted_minutes_rider_adjusted ;;
    hidden: yes
  }

  measure: number_of_forecasted_hours_rider {
    group_label: "> Rider Measures"
    label: "# Forecasted Rider Hours"
    description: "# Forecasted Hours Needed for Riders"
    type: number
    sql: ${number_of_forecasted_minutes_rider}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_forecasted_hours_rider_adjusted {
    alias: [number_of_adjusted_forecasted_hours_rider]
    group_label: "> Rider Measures"
    label: "# Adjusted Forecasted Rider Hours"
    type: number
    sql: ${number_of_forecasted_minutes_rider_adjusted}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_forecasted_hours_picker {
    group_label: "> Picker Measures"
    label: "# Forecasted Picker Hours"
    description: "# Forecasted Hours Needed for Pickers"
    type: number
    sql: ${number_of_forecasted_minutes_picker}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_forecasted_hours_picker_adjusted {
    alias: [number_of_forecasted_adjusted_hours_picker]
    group_label: "> Picker Measures"
    label: "# Adjusted Forecasted Picker Hours"
    type: number
    sql: ${number_of_forecasted_minutes_picker_adjusted}/60;;
    value_format_name: decimal_1
  }
  ##### Forecast errors

  measure: wmape_orders {
    group_label: "> Forecasting error"
    label: "wMAPE - Orders"
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

  measure: summed_absolute_error_adjusted {
    type: sum_distinct
    sql_distinct_key: concat(${job_date},${start_timestamp_raw},${hub_code}) ;;
    hidden: yes
    sql: ABS(${number_of_forecasted_orders_adjusted_dimension} - ${number_of_actual_orders_dimension});;
  }

  measure: wmape_orders_adjusted {
    group_label: "> Forecasting error"
    label: "wMAPE - Adjusted Orders"
    description: "Summed Absolute Difference of Orders per Hub in 30 min/ # Actual Orders"
    type: number
    sql: ${summed_absolute_error_adjusted}/nullif(${number_of_actual_orders},0);;
    value_format_name: percent_2
  }

  measure: wmape_hours {
    group_label: "> Forecasting error"
    label: "wMAPE - Scheduled Hours"
    description: "Summed Absolute Difference of Scheduled Hours per Hub in 30 min (# Forecasted Hours - # Scheduled Hours)/ # Scheduled Hours"
    type: number
    sql: ${summed_absolute_error_hours}/nullif(${ops.number_of_scheduled_hours_by_position},0);;
    value_format_name: percent_2
  }

  measure: summed_absolute_error_hours {
    type: sum_distinct
    sql_distinct_key: ${forecast_uuid} ;;
    hidden: yes
    sql: ABS(${number_of_forecasted_hours_by_position_dimension} - ${ops.number_of_scheduled_hours_by_position_dimension});;
  }

  measure: summed_absolute_error_hours_adjusted {
    type: sum_distinct
    sql_distinct_key: ${forecast_uuid} ;;
    hidden: yes
    sql: ABS(${number_of_forecasted_hours_by_position_adjusted_dimension} - ${ops.number_of_scheduled_hours_by_position_dimension});;
  }

  measure: wmape_hours_adjusted {
    group_label: "> Forecasting error"
    label: "wMAPE - Adjusted Scheduled Hours"
    description: "Summed Absolute Difference of Scheduled Hours per Hub in 30 min (# Adjusted Forecasted Hours (Incl. Airtable Adjustments) - # Scheduled Hours)/ # Scheduled Hours"
    type: number
    sql: ${summed_absolute_error_hours_adjusted}/nullif(${ops.number_of_scheduled_hours_by_position},0);;
    value_format_name: percent_2
  }

  measure: wmape_no_show_hours {
    group_label: "> Forecasting error"
    label: "wMAPE - No Show Hours"
    description: "Summed Absolute Difference of Actual No Show Hours per Hub in 30 min (# Forecasted No Show Hours - # Actual No Show Hours)/ # Actual No Show Hours"
    type: number
    hidden: no
    sql: ${summed_absolute_error_no_show_hours}/nullif(${ops.number_of_no_show_hours_by_position},0);;
    value_format_name: percent_2
  }

  measure: summed_absolute_error_no_show_hours {
    type: sum_distinct
    sql_distinct_key: ${forecast_uuid} ;;
    hidden: yes
    sql: ABS(${number_of_no_show_hours_by_position_dimension} - ${ops.number_of_no_show_hours_by_position_dimension});;
  }

  measure: summed_absolute_error_no_show_hours_adjusted {
    type: sum_distinct
    sql_distinct_key: ${forecast_uuid} ;;
    hidden: yes
    sql: ABS(${number_of_no_show_hours_by_position_adjusted_dimension} - ${ops.number_of_no_show_hours_by_position_dimension});;
  }

  measure: wmape_no_show_hours_adjusted {
    group_label: "> Forecasting error"
    label: "wMAPE - Adjusted No Show Hours"
    description: "Summed Absolute Difference of Actual No Show Hours per Hub in 30 min (# Adsjuted Forecasted No Show Hours (Incl. Airtable Adjustments) - # Actual No Show Hours)/ # Actual No Show Hours"
    type: number
    hidden: no
    sql: ${summed_absolute_error_no_show_hours_adjusted}/nullif(${ops.number_of_no_show_hours_by_position},0);;
    value_format_name: percent_2
  }

  # =========  Backlog bias   =========

  measure: sum_backlog_bias_numerator {
    group_label: "> Forecasting error"
    label: "Backlog Bias Numerator - Orders"
    description: "Order forecast bias indicator that takes into account the amount of under-forecasting that has accumulated since the beginning of the day."
    type: sum_distinct
    sql_distinct_key: ${forecast_uuid} ;;
    hidden: no
    sql: ${backlog_bias_numerator};;
  }

  measure: sum_backlog_bias_denominator {
    group_label: "> Forecasting error"
    label: "Backlog Bias Denominator - Orders"
    description: "Reflects the order forecast backlog bias multiplied by the actual number of orders."
    type: sum_distinct
    sql_distinct_key: ${forecast_uuid} ;;
    hidden: no
    sql: ${backlog_bias_denominator};;
  }

  measure: pct_backlog_bias {
    group_label: "> Forecasting error"
    label: "% Backlog Bias - Orders"
    description: "Backlog bias metric calculated by Data Science. Reflects forecast accuracy."
    link: {
      label: "Documentation"
      url: "https://goflink.atlassian.net/wiki/spaces/DATA/pages/406684088/DATA+RFC+020+Updating+Order+Forecast+Performance+Measurement#Solution-4%3A-Percent-Backlog-Bias"
    }
    type: number
    hidden: no
    sql: (${sum_backlog_bias_numerator})/nullif(${sum_backlog_bias_denominator},0);;
    value_format_name: percent_2
  }

  # =========  Dynamic values   =========

  dimension: number_of_no_show_hours_by_position_dimension {
    type: number
    label: "# Forecasted No Show Hours - Dimension"
    description: "# Forecasted No Show Hours (Based on Forecasted Hours)"
    value_format_name: decimal_1
    group_label: "> Dynamic Measures"
    sql:
        case
          when {% parameter ops.position_parameter %} = 'Rider'
            then ${number_of_forecasted_no_show_hours_rider_dimension}
          else null
        end ;;
    hidden: yes
  }

  dimension: number_of_no_show_hours_by_position_adjusted_dimension {
    type: number
    label: "# Adjusted Forecasted No Show Hours - Dimension"
    description: "# Adjusted Forecasted No Show Hours (Based on Adjusted Forecasted Hours (Incl. Airtable Adjustments))"
    value_format_name: decimal_1
    group_label: "> Dynamic Measures"
    sql:
        case
          when {% parameter ops.position_parameter %} = 'Rider'
            then ${number_of_forecasted_no_show_hours_rider_adjusted_dimension}
          else null
        end ;;
    hidden: yes
  }

  measure: number_of_forecasted_employees_by_position {
    type: number
    label: "# Forecasted Employees"
    description: "# Forecasted Employees Needed"
    value_format_name: decimal_1
    group_label: "> Dynamic Measures"
    sql:
        case
          when {% parameter ops.position_parameter %} = 'Rider'
            then ${number_of_forecasted_riders}
          when {% parameter ops.position_parameter %} = 'Picker'
            then ${number_of_forecasted_pickers}
          else null
        end ;;
    hidden: yes
  }

  measure: number_of_forecasted_hours_by_position {
    type: number
    label: "# Forecasted Hours (Incl. No Show)"
    description: "# Forecasted Hours Needed - No Show Forecasts included in Total Forecasted Hours"
    value_format_name: decimal_1
    group_label: "> Dynamic Measures"
    sql:
        case
          when {% parameter ops.position_parameter %} = 'Rider'
            then ${number_of_forecasted_hours_rider}
          when {% parameter ops.position_parameter %} = 'Picker'
            then ${number_of_forecasted_hours_picker}
          else null
        end ;;
  }

  measure: number_of_forecasted_hours_by_position_adjusted {
    alias: [number_of_adjusted_forecasted_hours_by_position]
    type: number
    label: "# Adjusted Forecasted Hours (Incl. No Show)"
    description: "# Adjusted Forecasted Hours (Incl. Airtable Adjustments) - No Show Forecasts included in Total Forecasted Hours and not added here explicitly"
    value_format_name: decimal_1
    group_label: "> Dynamic Measures"
    sql:
        case
          when {% parameter ops.position_parameter %} = 'Rider'
            then ${number_of_forecasted_hours_rider_adjusted}
          when {% parameter ops.position_parameter %} = 'Picker'
            then ${number_of_forecasted_hours_picker_adjusted}
          else null
        end ;;
  }

  dimension: number_of_forecasted_hours_by_position_dimension {
    type: number
    label: "# Forecasted Hours (Incl. No Show) - Dimension"
    description: "# Forecasted Hours Needed - No Show Forecasts included in Total Forecasted Hours and not added here explicitly"
    value_format_name: decimal_1
    group_label: "> Dynamic Measures"
    sql:
        case
          when {% parameter ops.position_parameter %} = 'Rider'
            then ${number_of_forecasted_hours_rider_dimension}
          when {% parameter ops.position_parameter %} = 'Picker'
            then ${number_of_forecasted_hours_picker_dimension}
          else null
        end ;;
    hidden: yes
  }


  dimension: number_of_forecasted_hours_by_position_adjusted_dimension {
    alias: [number_of_adjusted_forecasted_hours_by_position_dimension]
    type: number
    label: "# Adjusted Forecasted Hours (Incl. No Show) - Dimension"
    description: "# Forecasted Hours Needed (Incl. Airtable Adjustments) - No Show Forecasts included in Total Forecasted Hours and not added here explicitly"
    value_format_name: decimal_1
    group_label: "> Dynamic Measures"
    sql:
        case
          when {% parameter ops.position_parameter %} = 'Rider'
            then ${number_of_forecasted_hours_rider_adjusted_dimension}
          when {% parameter ops.position_parameter %} = 'Picker'
            then ${number_of_forecasted_hours_picker_adjusted_dimension}
          else null
        end ;;
    hidden: yes
  }

  measure: number_of_no_show_hours_by_position {
    type: number
    label: "# Forecasted No Show Hours"
    description: "# Forecasted No Show Hours"
    value_format_name: decimal_1
    group_label: "> Dynamic Measures"
    sql:
        case
          when {% parameter ops.position_parameter %} = 'Rider'
            then ${number_of_forecasted_no_show_minutes_rider}/60
          else null
        end ;;
  }

  measure: number_of_no_show_hours_by_position_adjusted {
    type: number
    label: "# Adjusted Forecasted No Show Hours"
    description: "# Adjusted Forecasted No Show Hours (Based on Adjusted Forecasted Hours (Incl. Airtable Adjustments))"
    value_format_name: decimal_1
    group_label: "> Dynamic Measures"
    sql:
        case
          when {% parameter ops.position_parameter %} = 'Rider'
            then ${number_of_forecasted_no_show_minutes_rider_adjusted}/60
          else null
        end ;;
  }

  measure: pct_no_show_by_position {
    type: number
    label: "% Forecasted No Show Hours"
    description: "# Forecasted No Show Hours / # Forecasted Hours (Excl. Airtable Adjustments)"
    value_format_name: percent_1
    group_label: "> Dynamic Measures"
    sql:
        case
          when {% parameter ops.position_parameter %} = 'Rider'
            then ${number_of_no_show_hours_by_position}/nullif(${number_of_forecasted_hours_by_position},0)
          else null
        end ;;
  }

  measure: pct_no_show_by_position_adjusted {
    type: number
    label: "% Adjusted Forecasted No Show Hours"
    description: "# Adjusted Forecasted No Show Hours (Incl. Airtable Adjustments) / # Adjusted Forecasted Hours (Incl. Airtable Adjustments)"
    value_format_name: percent_1
    group_label: "> Dynamic Measures"
    sql:
        case
          when {% parameter ops.position_parameter %} = 'Rider'
            then ${number_of_no_show_hours_by_position_adjusted}/nullif(${number_of_forecasted_hours_by_position_adjusted},0)
          else null
        end ;;
  }

  measure: number_of_forecasted_hours_excl_no_show_by_position {
    type: number
    label: "# Forecasted Hours (Excl. No Show)"
    description: "# Forecasted Hours Needed - No Show Forecasts excluded in Total Forecasted Hours (# Forecasted Hours Needed - # Forecasted No Show Hours)"
    value_format_name: decimal_1
    group_label: "> Dynamic Measures"
    sql: ${number_of_forecasted_hours_by_position}-${number_of_no_show_hours_by_position} ;;
  }

  measure: number_of_forecasted_hours_excl_no_show_by_position_adjusted {
    alias: [number_of_adjusted_forecasted_hours_excl_no_show_by_position]
    type: number
    label: "# Adjusted Forecasted Hours (Excl. No Show)"
    description: "# Adjusted Forecasted Hours (Incl. Airtable Adjustments) - Adjusted No Show Forecasts excluded in Total Forecasted Hours (# Adjusted Forecasted Hours Needed - # Adjusted Forecasted No Show Hours)"
    value_format_name: decimal_1
    group_label: "> Dynamic Measures"
    sql: ${number_of_forecasted_hours_by_position_adjusted}-${number_of_no_show_hours_by_position_adjusted} ;;
  }

  measure: number_of_target_orders_by_position {
    type: number
    label: "Base UTR"
    description: "Calculated UTR based on formula - (power(60,2) * (1- idle_pct) / handling_duration) * stacking_multiplier"
    value_format_name: decimal_2
    group_label: "> Dynamic Measures"
    sql:
        case
          when {% parameter ops.position_parameter %} = 'Rider'
            then ${number_of_target_orders_per_rider}
          when {% parameter ops.position_parameter %} = 'Picker'
            then ${number_of_target_orders_per_picker}
          else null
        end ;;
  }

  measure: number_of_target_orders_by_position_adjusted {
    type: number
    label: "Adjusted Base UTR"
    description: "Adjusted Calculated UTR based on formula (Incl. Airtable Adjustments) - (power(60,2) * (1- idle_pct) / handling_duration) * stacking_multiplier"
    value_format_name: decimal_2
    group_label: "> Dynamic Measures"
    sql:
        case
          when {% parameter ops.position_parameter %} = 'Rider'
            then ${number_of_target_orders_per_rider_adjusted}
          else null
        end ;;
  }

  measure: idleness_assumption_by_position {
    label: "% Idleness Assumption"
    description: "% Time an employee is idle"
    type: number
    value_format_name: percent_1
    group_label: "> Dynamic Measures"
    sql:
        case
          when {% parameter ops.position_parameter %} = 'Rider'
            then ${pct_idleness_target_rider}
          when {% parameter ops.position_parameter %} = 'Picker'
            then ${pct_idleness_target_picker}
          else null
        end ;;
  }

  measure: idleness_assumption_by_position_adjusted {
    label: "% Adjusted Idleness Assumption"
    description: "% Adjusted Time an employee is idle (Incl. Airtable Adjustments)"
    type: number
    value_format_name: percent_1
    group_label: "> Dynamic Measures"
    sql:
        case
          when {% parameter ops.position_parameter %} = 'Rider'
            then ${pct_idleness_target_rider_adjusted}
          else null
        end ;;
  }

  measure: final_utr_by_position {
    type: number
    label: "Forecasted UTR"
    description: "Forecasted Orders/Forecasted Hours"
    value_format_name: decimal_2
    group_label: "> Dynamic Measures"
    sql: ${number_of_forecasted_orders}/nullif(${number_of_forecasted_hours_by_position},0);;
  }

  measure: final_utr_by_position_adjusted {
    type: number
    label: "Adjusted Forecasted UTR"
    description: "Adjusted Forecasted Orders (Incl. Airtable Adjustments)/Adjusted Forecasted Hours (Incl. Airtable Adjustments)"
    value_format_name: decimal_2
    group_label: "> Dynamic Measures"
    sql: ${number_of_forecasted_orders_adjusted}/nullif(${number_of_forecasted_hours_by_position_adjusted},0);;
  }

  parameter: dynamic_text_utr {
    label: "Define Target UTR"
    description: "Use this field to calculate Actually Needed Hours"
    type: number
    #required_fields: [dynamic_text_utr]
    hidden: yes
  }

  measure: actual_needed_hours_by_position {
    type: number
    label: "# Actually Needed Hours (Dynamic)"
    description: "# Hours needed based on # Orders and User-defined UTR - # Orders/Defined UTR"
    value_format_name: decimal_1
    group_label: "> Dynamic Measures"
    sql: nullif(${orders_with_ops_metrics.sum_orders},0)/nullif({% parameter dynamic_text_utr %},0);;
    hidden: yes
  }

  measure: fixed_actual_needed_hours_by_position {
    type: number
    group_label: "> Dynamic Measures"
    label: "# Actually Needed Hours"
    description: "# Hours needed based on # Actual Orders (Forecast-related) / Base UTR. For pickers it is calculated based on # Actual Orders."
    value_format_name: decimal_1
    sql:
        case
          when {% parameter ops.position_parameter %} = 'Rider'
            then nullif(${number_of_actual_orders},0)/nullif(${number_of_target_orders_by_position},0)
          when {% parameter ops.position_parameter %} = 'Picker'
            then nullif(${orders_with_ops_metrics.sum_orders},0)/nullif(${number_of_target_orders_by_position},0)
          else null
        end ;;
  }

  measure: fixed_actual_needed_hours_by_position_adjusted {
    type: number
    group_label: "> Dynamic Measures"
    label: "# Adjusted Actually Needed Hours"
    description: "# Hours needed based on # Actual Orders (Forecast-related) / Base UTR. For pickers it is calculated based on # Actual Orders."
    value_format_name: decimal_1
    sql:
        case
          when {% parameter ops.position_parameter %} = 'Rider'
            then nullif(${number_of_actual_orders},0)/nullif(${number_of_target_orders_by_position_adjusted},0)
          when {% parameter ops.position_parameter %} = 'Picker'
            then nullif(${orders_with_ops_metrics.sum_orders},0)/nullif(${number_of_target_orders_by_position_adjusted},0)
          else null
        end ;;
  }

  measure: wmape_by_parameter {
    type: number
    label: "wMape"
    description: "wMape based on chosen metric"
    value_format_name: percent_1
    group_label: "> Forecasting error"
    sql:
        case
          when {% parameter wmape_parameter %} = 'Orders' then ${wmape_orders}
          when {% parameter wmape_parameter %} = 'Scheduled Hours' then ${wmape_hours}
          when {% parameter wmape_parameter %} = 'No Show Hours' then ${wmape_no_show_hours}
          else null
        end ;;
    hidden: yes
  }

  measure: forecasts {
    type: number
    label: "Forecasts"
    description: "Forecasted Value based on Chosen wMape metric"
    value_format_name: decimal_0
    group_label: "> Dynamic Values"
    sql:
        case
          when {% parameter wmape_parameter %} = 'Orders'
            then ${number_of_forecasted_orders}
          when {% parameter wmape_parameter %} = 'Scheduled Hours'
            then ${number_of_forecasted_hours_by_position}
          when {% parameter wmape_parameter %} = 'No Show Hours'
            then ${number_of_no_show_hours_by_position}
          else null
        end ;;
    hidden: yes
  }

  measure: actuals {
    type: number
    label: "Actuals"
    description: "Actual Value based on Chosen wMape metric"
    value_format_name: decimal_0
    group_label: "> Dynamic Values"
    sql:
        case
          when {% parameter wmape_parameter %} = 'Orders'
            then ${number_of_actual_orders}
          when {% parameter wmape_parameter %} = 'Scheduled Hours'
            then ${ops.number_of_scheduled_hours_by_position}
          when {% parameter wmape_parameter %} = 'No Show Hours'
            then ${ops.number_of_no_show_hours_by_position}
          else null
        end ;;
    hidden: yes
  }


  ##### Overstaffing and Understaffing

  measure: summed_overstaffing_error {
    group_label: "> Dynamic Measures"
    label: "Summed Overstaffing Error"
    type: sum_distinct
    sql_distinct_key: ${forecast_uuid} ;;
    description: "How much overstaffed we are compared to what was forecasted in cases of overstaffing. when Forecasted Hours < Scheduled Hours: (Forecasted Hours - Scheduled Hours) / Forecasted Hours"
    sql:
        case
          when ${number_of_forecasted_hours_by_position_dimension} < ${ops.number_of_scheduled_hours_by_position_dimension}
            then abs(${number_of_forecasted_hours_by_position_dimension} - ${ops.number_of_scheduled_hours_by_position_dimension})
          else null
        end  ;;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: summed_overstaffing_error_adjusted {
    group_label: "> Dynamic Measures"
    label: "Adjusted Summed Overstaffing Error"
    type: sum_distinct
    sql_distinct_key: ${forecast_uuid} ;;
    description: "How much overstaffed we are compared to what was forecasted (Incl. Airtable Adjustments) in cases of overstaffing. when Forecasted Hours < Scheduled Hours: (Forecasted Hours - Scheduled Hours) / Forecasted Hours"
    sql:
        case
          when ${number_of_forecasted_hours_by_position_adjusted_dimension} < ${ops.number_of_scheduled_hours_by_position_dimension}
            then abs(${number_of_forecasted_hours_by_position_adjusted_dimension} - ${ops.number_of_scheduled_hours_by_position_dimension})
          else null
        end  ;;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: pct_overstaffing {
    type: number
    group_label: "> Dynamic Measures"
    label: "% Overstaffing"
    description: "How much overstaffed we are compared to what was forecasted in cases of overstaffing. when Forecasted Hours < Scheduled Hours: (Forecasted Hours - Scheduled Hours) / Forecasted Hours"
    sql:  ${summed_overstaffing_error} / nullif(${number_of_forecasted_hours_by_position},0) ;;
    value_format_name: percent_1
    hidden: no
  }

  measure: pct_overstaffing_adjusted {
    type: number
    group_label: "> Dynamic Measures"
    label: "% Adjusted Overstaffing"
    description: "How much overstaffed we are compared to what was forecasted (Incl. Airtable Adjustments in cases of overstaffing. when Adjusted Forecasted Hours < Scheduled Hours: (Adjusted Forecasted Hours - Scheduled Hours) / Adjusted Forecasted Hours"
    sql:  ${summed_overstaffing_error} / nullif(${number_of_forecasted_hours_by_position_adjusted},0) ;;
    value_format_name: percent_1
    hidden: no
  }

  measure: summed_understaffing_error {
    group_label: "> Dynamic Measures"
    label: "Summed Overstaffing Error"
    type: sum_distinct
    sql_distinct_key: ${forecast_uuid} ;;
    description: "How much overstaffed we are compared to what was forecasted in cases of overstaffing. when Forecasted Hours < Scheduled Hours: (Forecasted Hours - Scheduled Hours) / Forecasted Hours"
    sql:
        case
          when ${number_of_forecasted_hours_by_position_dimension} > ${ops.number_of_scheduled_hours_by_position_dimension}
            then abs(${number_of_forecasted_hours_by_position_dimension} - ${ops.number_of_scheduled_hours_by_position_dimension})
          else null
        end  ;;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: summed_understaffing_error_adjusted {
    group_label: "> Dynamic Measures"
    label: "Adjusted Summed Overstaffing Error"
    type: sum_distinct
    sql_distinct_key: ${forecast_uuid} ;;
    description: "How much overstaffed we are compared to what was forecasted (Incl. Airtable Adjustments) in cases of overstaffing. when Forecasted Hours < Scheduled Hours: (Forecasted Hours - Scheduled Hours) / Forecasted Hours"
    sql:
        case
          when ${number_of_forecasted_hours_by_position_adjusted_dimension} > ${ops.number_of_scheduled_hours_by_position_dimension}
            then abs(${number_of_forecasted_hours_by_position_adjusted_dimension} - ${ops.number_of_scheduled_hours_by_position_dimension})
          else null
        end  ;;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: pct_understaffing {
    type: number
    group_label: "> Dynamic Measures"
    label: "% Understaffing"
    description: "How much understaffed we are compared to what was forecasted in cases of understaffing. when Forecasted Hours > Scheduled Hours: (Forecasted Hours - Scheduled Hours) / Forecasted Hours"
    sql:  ${summed_understaffing_error} / nullif(${number_of_forecasted_hours_by_position},0) ;;
    value_format_name: percent_1
    hidden: no
  }

  measure: pct_understaffing_adjusted {
    type: number
    group_label: "> Dynamic Measures"
    label: "% Adjusted Understaffing"
    description: "How much understaffed we are compared to what was forecasted (Incl. Airtable Adjustments) in cases of understaffing. when Adjusted Forecasted Hours > Scheduled Hours: (Adjusted Forecasted Hours - Scheduled Hours) / Adjusted Forecasted Hours"
    sql:  ${summed_understaffing_error} / nullif(${number_of_forecasted_hours_by_position_adjusted},0) ;;
    value_format_name: percent_1
    hidden: no
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
    description: "This filter could be used to see respective day of the last week as a job date for each order date"
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

  parameter: date_granularity {
    label: "Date Granularity"
    type: unquoted
    allowed_value: { value: "Day" }
    allowed_value: { value: "Week" }
    default_value: "Day"
  }

  parameter: wmape_parameter {
    label: "wMape Metric"
    description: "This filter could be used to see wMape Error based on the chosen metric"
    type: string
    allowed_value: { value: "Orders" }
    allowed_value: { value: "Scheduled Hours" }
    allowed_value: { value: "No Show Hours" }
    hidden: yes
  }

  dimension: date {
    label: "Date (Dynamic)"
    description: "Dynamic date based on chosen granularity"
    label_from_parameter: date_granularity
    sql:
    {% if date_granularity._parameter_value == 'Day' %}
      ${start_timestamp_date}
    {% elsif date_granularity._parameter_value == 'Week' %}
      ${start_timestamp_week}
    {% endif %};;
  }

  dimension: date_granularity_pass_through {
    description: "To use the parameter value in a table calculation (e.g WoW, % Growth) we need to materialize it into a dimension "
    type: string
    hidden: no # yes
    sql:
            {% if date_granularity._parameter_value == 'Day' %}
              "Day"
            {% elsif date_granularity._parameter_value == 'Week' %}
              "Week"
            {% endif %};;
  }

}
