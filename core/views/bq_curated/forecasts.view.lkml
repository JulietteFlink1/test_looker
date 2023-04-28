# Owner:   Nazrin Guliyeva
# Created: 2022-05-17

# This view contains forecast data from multiple forecast tables on timeslot, hub, and job date level.

view: forecasts {
  # Where statement filters job_date to Monday
  sql_table_name: (select * from `flink-data-prod.curated.forecasts` where job_date = date_trunc(date(start_timestamp, 'Europe/Berlin'), week(monday)) - 7) ;;

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # =========  __main__   =========

  dimension: forecast_uuid {
    label: "Forecast UUID"
    type: string
    sql: ${TABLE}.forecast_uuid ;;
    hidden: yes
    primary_key: yes
  }

  dimension: hub_code {
    label: "Hub Code"
    type: string
    sql: ${TABLE}.hub_code ;;
    hidden: yes
  }

  dimension: is_hub_open {
    label: "Is Hub Open"
    description: "1, if hub was open in the given 30 min interval. Based on the regular opening hours."
    type: number
    sql: ${TABLE}.is_hub_open;;
    hidden: no
  }

  dimension: quinyx_pipeline_status_rider {
    label: "Quinyx Pipeline Status - Rider"
    description: "Status of the Quinyx pipeline for rider headcount (whether it is sent or not to Quinyx)."
    type: string
    sql: coalesce(${TABLE}.quinyx_pipeline_status_rider, "n/a") ;;
  }

  dimension: quinyx_pipeline_status_picker {
    label: "Quinyx Pipeline Status - Picker"
    description: "Status of the Quinyx pipeline for picker headcount (whether it is sent or not to Quinyx)."
    type: string
    sql: coalesce(${TABLE}.quinyx_pipeline_status_picker, "n/a") ;;
  }

  dimension: is_forecast_hub {
    label: "Is forecast hub?"
    description: "Yes, if the hub has forecast for the given job date"
    type: yesno
    sql: ${TABLE}.is_forecasted;;
    hidden: no
  }

  # =========  Dimensions to be used in metrics   =========

  dimension: number_of_last_mile_missed_orders {
    hidden: yes
    type: number
    sql: ${TABLE}.number_of_last_mile_missed_orders ;;
  }

  dimension: number_of_last_mile_missed_orders_planned_closure {
    hidden: yes
    type: number
    sql: ${TABLE}.number_of_last_mile_missed_orders_planned_closure ;;
  }

  dimension: number_of_last_mile_missed_orders_forced_closure {
    hidden: yes
    type: number
    sql: ${TABLE}.number_of_last_mile_missed_orders_forced_closure ;;
  }

  dimension: number_of_last_mile_missed_orders_pdt_forced_closure {
    hidden: yes
    type: number
    sql: ${TABLE}.number_of_last_mile_missed_orders_pdt_forced_closure ;;
  }

  dimension: number_of_last_mile_missed_orders_pdt {
    hidden: yes
    type: number
    sql: ${TABLE}.number_of_last_mile_missed_orders_pdt ;;
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
    type: average
    sql: ${TABLE}.stacking_effect_multiplier ;;
    hidden: yes
    value_format_name: decimal_1
  }

  measure: number_of_forecasted_stacked_orders {
    group_label: "> Order Measures"
    label: "# Forecasted Stacked Orders"
    type: sum
    value_format_name: decimal_1
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
    type: sum
    sql: ${TABLE}.number_of_forecasted_no_show_minutes_rider ;;
    hidden: yes
  }

  measure: number_of_forecasted_no_show_minutes_rider_adjusted {
    group_label: "> Rider Measures"
    label: "# Adjusted Forecasted No Show Minutes Rider"
    type: sum
    sql: ${TABLE}.number_of_forecasted_no_show_minutes_rider_adjusted ;;
    hidden: yes
  }

  # =========  Idleness minutes   =========

  measure: number_of_forecasted_idleness_minutes_picker {
    group_label: "> Picker Measures"
    label: "# Forecasted Idle Picker Minutes"
    type: sum
    sql: ${TABLE}.number_of_forecasted_idleness_minutes_picker ;;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: number_of_forecasted_idleness_minutes_rider {
    group_label: "> Rider Measures"
    label: "# Forecasted Idle Rider Minutes"
    type: sum
    sql: ${TABLE}.number_of_forecasted_idleness_minutes_rider ;;
    value_format_name: decimal_1
    hidden: yes
  }

  measure: number_of_forecasted_idleness_minutes_rider_adjusted {
    group_label: "> Rider Measures"
    label: "# Adjusted Forecasted Idle Rider Minutes"
    type: sum
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
    type: average
    sql: ${TABLE}.number_of_target_orders_per_picker ;;
    hidden: yes
  }

  measure: number_of_target_orders_per_rider {
    group_label: "> Rider Measures"
    label: "Base UTR Rider"
    description: "Calculated UTR based on formula - (power(60,2) * (1- idle_pct) / handling_duration) * stacking_multiplier"
    value_format_name: decimal_2
    type: average
    sql: ${TABLE}.number_of_target_orders_per_rider ;;
    hidden: yes
  }

  measure: number_of_target_orders_per_rider_adjusted {
    group_label: "> Rider Measures"
    label: "Adjusted Base UTR Rider"
    description: "Adjusted calculated UTR based on formula (Incl. Airtable Adjustments) - (power(60,2) * (1- idle_pct) / handling_duration) * stacking_multiplier"
    value_format_name: decimal_2
    type: average
    sql: ${TABLE}.number_of_target_orders_per_rider_adjusted ;;
    hidden: yes
  }

  measure: final_utr_picker {
    group_label: "> Picker Measures"
    label: "Forecasted UTR Picker (Incl. No Show)"
    description: "Forecasted Orders / Forecasted Picker Hours (Incl. No Show)"
    value_format_name: decimal_2
    sql: ${number_of_forecasted_orders}/nullif(${number_of_forecasted_hours_picker},0) ;;
  }

  measure: final_utr_picker_adjusted {
    group_label: "> Picker Measures"
    label: "Adjusted Forecasted UTR Picker (Incl. No Show)"
    description: "Adjusted Forecasted Orders / Adjusted Forecasted Picker Hours (Incl. No Show)"
    value_format_name: decimal_2
    sql: ${number_of_forecasted_orders_adjusted}/nullif(${number_of_forecasted_hours_picker_adjusted},0) ;;
  }

  measure: final_utr_rider {
    group_label: "> Rider Measures"
    label: "Forecasted UTR Rider (Incl. No Show)"
    description: "Forecasted Orders / Forecasted Rider Hours (Incl. No Show)"
    value_format_name: decimal_2
    sql: ${number_of_forecasted_orders}/nullif(${number_of_forecasted_hours_rider},0) ;;
  }

  measure: final_utr_rider_adjusted {
    group_label: "> Rider Measures"
    label: "Adjusted Forecasted UTR Rider (Incl. No Show)"
    description: "Adjusted Forecasted Orders / Adjusted Forecasted Rider Hours (Incl. No Show)"
    value_format_name: decimal_2
    sql: ${number_of_forecasted_orders_adjusted}/nullif(${number_of_forecasted_hours_rider_adjusted},0) ;;
  }

  # =========  Forecasted Employees   =========

  measure: number_of_forecasted_pickers {
    group_label: "> Picker Measures"
    label: "# Forecasted Pickers"
    description: "# Forecasted Pickers Needed"
    type: sum
    sql: ${TABLE}.number_of_forecasted_pickers ;;
    hidden: yes
  }

  measure: number_of_forecasted_riders {
    group_label: "> Rider Measures"
    label: "# Forecasted Riders"
    description: "# Forecasted Riders Needed"
    type: sum
    sql: ${TABLE}.number_of_forecasted_riders ;;
    hidden: yes
  }

  # =========  Forecasted orders   =========

  measure: number_of_forecasted_orders {
    group_label: "> Order Measures"
    label: "# Forecasted Orders"
    type: sum
    sql: ${TABLE}.number_of_forecasted_orders ;;
    value_format_name: decimal_0
  }

  measure: delta_forecast_vs_delivered{
    group_label: "> Order Measures"
    label: "Delta Forecasted vs Last Mile Orders"
    description: "The difference between the number of Flink Delivered orders and Adjusted Forecasted orders."
    type: number
    sql: ${orders_with_ops_metrics.number_of_unique_flink_delivered_orders}-${number_of_forecasted_orders_adjusted} ;;
    value_format_name: decimal_0
  }

  measure: number_of_missed_orders {
    group_label: "> Order Measures"
    label: "# Missed Orders"
    description: "# Missed orders due to planned or forced closures."
    type: sum
    sql: ${TABLE}.number_of_missed_orders ;;
    value_format_name: decimal_0
  }

  measure: sum_number_of_last_mile_missed_orders {
    group_label: "> Order Measures"
    label: "# Last Mile Missed Orders"
    description: "# Last Mile Missed orders due to planned or forced closures."
    type: sum
    sql: ${number_of_last_mile_missed_orders};;
    value_format_name: decimal_0
  }

  measure: pct_cancelled_orders{
    group_label: "> Order Measures"
    label: "% Cancelled Orders"
    description: "Cancelled orders (cancelled due to operational reasons only) divided by Flink Delivered orders, percentage."
    type: number
    sql: ${number_of_cancelled_orders}/nullif(${orders_with_ops_metrics.number_of_unique_flink_delivered_orders},0) ;;
    value_format_name: percent_2
  }

  measure: pct_missed_orders{
    group_label: "> Order Measures"
    label: "% Missed Orders"
    description: "Missed orders divided by Flink Delivered orders, percentage."
    type: number
    sql: ${number_of_missed_orders}/nullif(${orders_with_ops_metrics.number_of_unique_flink_delivered_orders},0) ;;
    value_format_name: percent_2
  }

  measure: pct_last_mile_missed_orders{
    group_label: "> Order Measures"
    label: "% Last Mile Missed Orders"
    description: "Last Mile Missed orders divided by Flink Delivered orders, percentage."
    type: number
    sql: ${sum_number_of_last_mile_missed_orders}/nullif(${orders_with_ops_metrics.number_of_unique_flink_delivered_orders},0) ;;
    value_format_name: percent_2
  }

  measure: number_of_missed_orders_forced_closure {
    group_label: "> Order Measures"
    label: "# Missed Orders - Forced Closure"
    description: "# Missed orders due to forced closure."
    type: sum
    sql: ${TABLE}.number_of_missed_orders_forced_closure ;;
    value_format_name: decimal_0
  }

  measure: sum_number_of_last_mile_missed_orders_forced_closure {
    group_label: "> Order Measures"
    label: "# Last Mile Missed Orders - Forced Closure"
    description: "# Last Mile Missed orders due to forced closure."
    type: sum
    sql: ${number_of_last_mile_missed_orders_forced_closure} ;;
    value_format_name: decimal_0
  }

  measure: sum_number_of_last_mile_missed_orders_pdt_forced_closure {
    group_label: "> Order Measures"
    label: "# Last Mile Missed Orders - PDT or Forced Closure"
    description: "# Last Mile Missed orders due to high PDT and Forced closure. High PDT are PDT>30min and in the 20% highest values for the day. Doesn't necessarily mean that the hub was closed."
    type: sum
    sql: ${number_of_last_mile_missed_orders_pdt_forced_closure} ;;
    value_format_name: decimal_0
  }

  measure: sum_number_of_last_mile_missed_orders_pdt {
    group_label: "> Order Measures"
    label: "# Last Mile Missed Orders - PDT"
    description: "# Last Mile Missed orders during periods of high PDT. High PDT are PDT>30min and in the 20% highest values for the day. Doesn't necessarily mean that the hub was closed.  Include all missed orders during periods when PDT was high, therefore can also include forced closures missed orders."
    type: sum
    sql: ${number_of_last_mile_missed_orders_pdt} ;;
    value_format_name: decimal_0
  }

  measure: pct_missed_orders_forced_closure{
    group_label: "> Order Measures"
    label: "% Missed Orders - Forced Closure"
    description: "Missed orders (forced closure) divided by Flink Delivered orders, percentage."
    type: number
    sql: ${number_of_missed_orders_forced_closure}/nullif(${orders_with_ops_metrics.number_of_unique_flink_delivered_orders},0) ;;
    value_format_name: percent_2
  }

  measure: pct_last_mile_missed_orders_forced_closure{
    group_label: "> Order Measures"
    label: "% Last Mile Missed Orders - Forced Closure"
    description: "Last Mile Missed orders (forced closure) divided by Flink Delivered orders, percentage."
    type: number
    sql: ${sum_number_of_last_mile_missed_orders_forced_closure}/nullif(${orders_with_ops_metrics.number_of_unique_flink_delivered_orders},0) ;;
    value_format_name: percent_2
  }

  measure: pct_last_mile_missed_orders_pdt_forced_closure{
    group_label: "> Order Measures"
    label: "% Last Mile Missed Orders - PDT or Forced Closure"
    description: "Last Mile Missed orders (due to high PDT or to forced closure) divided by Flink Delivered orders, percentage."
    type: number
    sql: ${sum_number_of_last_mile_missed_orders_pdt_forced_closure}/nullif(${orders_with_ops_metrics.number_of_unique_flink_delivered_orders},0) ;;
    value_format_name: percent_2
  }

  measure: pct_last_mile_missed_orders_pdt{
    group_label: "> Order Measures"
    label: "% Last Mile Missed Orders - PDT"
    description: "Last Mile Missed orders (due to high PDT) divided by Flink Delivered orders, percentage."
    type: number
    sql: ${sum_number_of_last_mile_missed_orders_pdt}/nullif(${orders_with_ops_metrics.number_of_unique_flink_delivered_orders},0) ;;
    value_format_name: percent_2
  }

  measure: number_of_missed_orders_planned_closure {
    group_label: "> Order Measures"
    label: "# Missed Orders - Planned Closure"
    description: "# Missed orders due to planned closure."
    type: sum
    sql: ${TABLE}.number_of_missed_orders_planned_closure ;;
    value_format_name: decimal_0
  }

  measure: sum_number_of_last_mile_missed_orders_planned_closure {
    group_label: "> Order Measures"
    label: "# Last Mile Missed Orders - Planned Closure"
    description: "# Last Mile Missed orders due to planned closure."
    type: sum
    sql: ${number_of_last_mile_missed_orders_planned_closure} ;;
    value_format_name: decimal_0
  }

  measure: pct_missed_orders_planned_closure{
    group_label: "> Order Measures"
    label: "% Missed Orders - Planned Closure"
    description: "Missed orders (planned closure) divided by Flink Delivered orders, percentage."
    type: number
    sql: ${number_of_missed_orders_planned_closure}/nullif(${orders_with_ops_metrics.number_of_unique_flink_delivered_orders},0) ;;
    value_format_name: percent_2
  }

  measure: pct_last_mile_missed_orders_planned_closure{
    group_label: "> Order Measures"
    label: "% Last Mile Missed Orders - Planned Closure"
    description: "Last Mile Missed orders (planned closure) divided by Flink Delivered orders, percentage."
    type: number
    sql: ${sum_number_of_last_mile_missed_orders_planned_closure}/nullif(${orders_with_ops_metrics.number_of_unique_flink_delivered_orders},0) ;;
    value_format_name: percent_2
  }

  measure: number_of_forecasted_orders_adjusted {
    alias: [number_of_adjusted_forecasted_orders]
    group_label: "> Order Measures"
    label: "# Adjusted Forecasted Orders"
    type: sum
    sql: ${TABLE}.number_of_forecasted_orders_adjusted ;;
    value_format_name: decimal_0
  }

  measure: number_of_actual_orders {
    group_label: "> Order Measures"
    label: "# Actual Orders (Forecast-Related)"
    description: "# Actual orders related to forecast: Excl. click & collect and external orders; Including Cancelled orders with operations-related cancellation reasons and Last Mile Missed orders (due to forced closures). Including DaaS orders."
    type: sum
    sql: ${TABLE}.number_of_actual_orders;;
    value_format_name: decimal_0
  }

  measure: number_of_cancelled_orders {
    group_label: "> Order Measures"
    label: "# Cancelled Orders (Forecast-Related)"
    description: "# Cancelled orders that are relevant for the forecast: Excl. click & collect and external orders; Including only operations-related cancellation reasons. Including DaaS orders."
    type: sum
    sql: ${number_of_cancelled_orders_dimension} ;;
    value_format_name: decimal_0
  }

  measure: number_of_cancelled_and_missed_orders {
    group_label: "> Order Measures"
    label: "# Cancelled and Last Mile Missed Orders (Forecast-Related)"
    description: "# Cancelled and Last Mile Missed orders that are relevant for the forecast: Excl. click & collect and external orders; Including only operations-related cancellation reasons and last mile orders missed due to forced closures. Including DaaS orders."
    type: number
    sql: ${number_of_cancelled_orders} + ${sum_number_of_last_mile_missed_orders_forced_closure} ;;
    value_format_name: decimal_0
  }

  measure: number_of_cancelled_and_missed_orders_pdt_forced_closure {
    group_label: "> Order Measures"
    label: "# Cancelled and Last Mile Missed Orders (Forecast-Related) - PDT or Forced Closure"
    description: "# Cancelled and Last Mile Missed orders that are relevant for the forecast: Excl. click & collect and external orders; Including only operations-related cancellation reasons and last mile orders missed due to high PDT or forced closures. Including DaaS orders."
    type: number
    sql: ${number_of_cancelled_orders} + ${sum_number_of_last_mile_missed_orders_pdt_forced_closure} ;;
    value_format_name: decimal_0
  }

  measure: number_of_cancelled_and_missed_orders_pdt {
    group_label: "> Order Measures"
    label: "# Cancelled and Last Mile Missed Orders (Forecast-Related) - PDT"
    description: "# Cancelled and Last Mile Missed orders that are relevant for the forecast: Excl. click & collect and external orders; Including only operations-related cancellation reasons and last mile orders missed due to high PDT. Including DaaS orders."
    type: number
    sql: ${number_of_cancelled_orders} + ${sum_number_of_last_mile_missed_orders_pdt} ;;
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
    description: "The degree of how far Forecasted UTR (# Forecasted Orders / # Forecasted Hours (Incl. No Show)) is from Actual UTR in the given period. Formula:  (Actual UTR / Forecasted UTR (Incl. No Show)) - 1"
    type: number
    sql: (${ops.utr_by_position}/nullif(${final_utr_by_position},0)) - 1 ;;
    value_format_name: percent_1
  }

  measure: pct_forecasted_utr_deviation_adjusted {
    group_label: "> Dynamic Measures"
    label: "% Adjusted Forecasted UTR Deviation"
    description: "The degree of how far Adjusted Forecasted UTR (# Adjusted Forecasted Orders / # Adjusted Forecasted Hours) is from Actual UTR in the given period. Formula:  (Actual UTR / Adjusted Forecasted UTR (Incl. No Show)) - 1"
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
    label: "% No Show Hours Deviation (Excl. EC Shift)"
    description: "The degree of how far # Forecasted No Show Hours is from # Actual No Show Hours in the given period. Formula:  (# Actual No Show Hours / # Forecasted No Show Hours) - 1"
    type: number
    sql: (${ops.number_of_no_show_hours_by_position}/nullif(${number_of_no_show_hours_by_position},0)) - 1 ;;
    value_format_name: percent_1
  }

  measure: pct_forecast_deviation_no_show_adjusted {
    group_label: "> Dynamic Measures"
    label: "% Adjusted No Show Hours Deviation (Excl. EC Shift)"
    description: "The degree of how far # Adjusted Forecasted No Show Hours (Incl. Airtable Adjustments) is from # Actual No Show Hours in the given period. Formula:  (# Actual No Show Hours / # Forecasted No Show Hours) - 1"
    type: number
    sql: (${ops.number_of_no_show_hours_by_position}/nullif(${number_of_no_show_hours_by_position_adjusted},0)) - 1 ;;
    value_format_name: percent_1
  }

  measure: pct_forecast_deviation {
    group_label: "> Order Measures"
    label: "% Order Forecast Deviation"
    description: "The degree of how far # Forecasted orders is from # Actual orders (Forecast-related) in the given period. Formula: (# Actual Orders (Forecast-related) / # Forecasted Orders) - 1"
    type: number
    sql: (${number_of_actual_orders}/nullif(${number_of_forecasted_orders},0))-1 ;;
    value_format_name: percent_1
  }

  measure: pct_order_forecast_deviation_from_actual_successful_flink_delivered_orders {
    group_label: "> Order Measures"
    label: "% Successful Flink Delivered Order Deviation"
    description: "The degree of how far # Forecasted orders is from # Successful Flink Delivered orders in the given period. Formula: (# Successful Last mile Orders / # Forecasted Orders) - 1"
    type: number
    sql: (${orders_with_ops_metrics.number_of_unique_flink_delivered_orders}/nullif(${number_of_forecasted_orders},0))-1 ;;
    value_format_name: percent_1
  }

  measure: pct_forecast_deviation_adjusted {
    alias: [pct_adjusted_forecast_deviation]
    group_label: "> Order Measures"
    label: "% Adjusted Order Forecast Deviation"
    description: "The degree of how far # Forecasted orders (Incl. Airtable Adjustments) is from # Actual Orders in the given period. Formula: (# Actual Orders / # Forecasted Orders (Incl. Adjustments)) - 1"
    type: number
    sql: (${number_of_actual_orders}/nullif(${number_of_forecasted_orders_adjusted},0))-1 ;;
    value_format_name: percent_1
  }

  measure: pct_order_forecast_deviation_from_actual_successful_flink_delivered_orders_adjusted {
    group_label: "> Order Measures"
    label: "% Adjusted Order Forecast Deviation (Successful Flink Delivered Orders)"
    description: "The degree of how far # Forecasted orders (Incl. Airtable Adjustments) is from # Successful Flink Delivered orders in the given period. Formula: (# Successful Last MileOrders / # Forecasted Orders (Incl. Adjustments)) - 1"
    type: number
    sql: (${orders_with_ops_metrics.number_of_unique_flink_delivered_orders}/nullif(${number_of_forecasted_orders_adjusted},0))-1 ;;
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
    label: "% Scheduled Hours Forecast Deviation (Incl. EC Shift)"
    description: "The degree of how far # Forecasted Hours is from # Scheduled Hours in the given period. Formula: (# Scheduled Hours / # Forecasted Hours) - 1"
    type: number
    sql: (${ops.number_of_scheduled_hours_by_position}/nullif(${number_of_forecasted_hours_by_position},0)) - 1 ;;
    value_format_name: percent_1
  }

  measure: pct_forecast_deviation_hours_adjusted {
    group_label: "> Dynamic Measures"
    label: "% Adjusted Scheduled Hours Forecast Deviation (Incl. EC Shift)"
    description: "The degree of how far # Forecasted Hours (Incl. Airtable Adjustments) is from # Scheduled Hours in the given period. Formula: (# Scheduled Hours / # Forecasted Hours) - 1"
    type: number
    sql: (${ops.number_of_scheduled_hours_by_position}/nullif(${number_of_forecasted_hours_by_position_adjusted},0)) - 1 ;;
    value_format_name: percent_1
  }

  measure: pct_forecasted_hours_deviation_from_punched_hours_adjusted {
    group_label: "> Dynamic Measures"
    label: "% Adjusted Punched Hours Deviation"
    description: "The degree of how far # Forecasted Hours (Incl. Airtable Adjustments) is from # Punched Hours in the given period. Formula: (# Punched Hours / # Forecasted Hours) - 1"
    type: number
    sql: (${ops.number_of_worked_hours_by_position}/nullif(${number_of_forecasted_hours_by_position_adjusted},0)) - 1 ;;
    value_format_name: percent_1
  }

  measure: pct_forecasted_hours_deviation_from_ec_scheduled_hours_adjusted {
    group_label: "> Dynamic Measures"
    label: "% Adjusted EC Scheduled Hours Deviation"
    description: "The degree of how far # Forecasted Hours (Incl. Airtable Adjustments) is from # Scheduled EC Hours in the given period. Formula: (# Scheduled EC Hours / # Forecasted Hours) - 1"
    type: number
    sql: (${ops.number_of_scheduled_hours_by_position_ec_shift}/nullif(${number_of_forecasted_hours_by_position_adjusted},0)) - 1 ;;
    value_format_name: percent_1
  }

  measure: pct_forecasted_hours_deviation_from_wfs_scheduled_hours_adjusted {
    group_label: "> Dynamic Measures"
    label: "% Adjusted WFS Scheduled Hours Deviation"
    description: "The degree of how far # Forecasted Hours (Incl. Airtable Adjustments) is from # Scheduled WFS Hours in the given period. Formula: (# Scheduled WFS Hours / # Forecasted Hours) - 1"
    type: number
    sql: (${ops.number_of_scheduled_hours_by_position_wfs_shift}/nullif(${number_of_forecasted_hours_by_position_adjusted},0)) - 1 ;;
    value_format_name: percent_1
  }

  measure: pct_forecasted_hours_deviation_from_ns_scheduled_hours_adjusted {
    group_label: "> Dynamic Measures"
    label: "% Adjusted NS+ Scheduled Hours Deviation"
    description: "The degree of how far # Forecasted Hours (Incl. Airtable Adjustments) is from # Scheduled NS+ Hours in the given period. Formula: (# Scheduled NS+ Hours / # Forecasted Hours) - 1"
    type: number
    sql: (${ops.number_of_scheduled_hours_by_position_ns_shift}/nullif(${number_of_forecasted_hours_by_position_adjusted},0)) - 1 ;;
    value_format_name: percent_1
  }

  measure: pct_forecasted_hours_deviation_from_extra_scheduled_hours_adjusted {
    group_label: "> Dynamic Measures"
    label: "% Adjusted Extra Scheduled Hours Deviation"
    description: "The degree of how far # Forecasted Hours (Incl. Airtable Adjustments) is from # Scheduled Extra Hours (WFS, EC, NS+) in the given period. Formula: (# Scheduled Extra Hours / # Forecasted Hours) - 1"
    type: number
    sql: (${ops.number_of_scheduled_hours_by_position_extra}/nullif(${number_of_forecasted_hours_by_position_adjusted},0)) - 1 ;;
    value_format_name: percent_1
  }

  measure: pct_forecasted_hours_deviation_from_unknown_scheduled_hours_adjusted {
    group_label: "> Dynamic Measures"
    label: "% Adjusted Unknown Scheduled Hours Deviation"
    description: "The degree of how far # Forecasted Hours (Incl. Airtable Adjustments) is from # Unknown Scheduled Hours (# Scheduled Hours - # Scheduled Extra Hours) in the given period. Formula: ((# Scheduled Hours - # Scheduled Extra Hours) / # Forecasted Hours) - 1"
    type: number
    sql: (${number_of_scheduled_hours_by_position_unknown}/nullif(${number_of_forecasted_hours_by_position_adjusted},0)) - 1 ;;
    value_format_name: percent_1
  }

  measure: pct_forecast_deviation_hours_adjusted_excl_ec {
    group_label: "> Dynamic Measures"
    label: "% Adjusted Scheduled Hours Forecast Deviation (Excl. EC Shifts Hours)"
    description: "The degree of how far # Forecasted Hours (Incl. Airtable Adjustments) is from # Scheduled Hours (Excl. EC shift hours ) in the given period. Formula: ((# Scheduled Hours - # Scheduled EC Shift Hours) / # Forecasted Hours) - 1"
    type: number
    sql: ((${ops.number_of_scheduled_hours_by_position}-${ops.number_of_scheduled_hours_by_position_ec_shift})/nullif(${number_of_forecasted_hours_by_position_adjusted},0)) - 1 ;;
    value_format_name: percent_1
  }

  measure: forecasted_avg_rider_handling_duration_seconds {
    alias: [forecasted_avg_order_handling_duration_seconds]
    group_label: "> Order Measures"
    label: "Forecasted AVG Rider Handling Time (Seconds)"
    description: "Forecasted AVG Total Rider Handling Time: Riding to Customer + At customer + Riding to Hub"
    type: average
    sql: ${TABLE}.forecasted_avg_rider_handling_duration_seconds ;;
    value_format_name: decimal_1
    filters: [is_hub_open: "1"]
  }

  measure: forecasted_avg_rider_handling_duration_minutes {
    alias: [forecasted_avg_order_handling_duration_minutes]
    group_label: "> Order Measures"
    label: "Forecasted AVG Rider Handling Time (Minutes)"
    description: "Forecasted AVG Total Rider Handling Time: Riding to Customer + At customer + Riding to Hub"
    type: average
    sql: ${TABLE}.forecasted_avg_rider_handling_duration_minutes ;;
    value_format_name: decimal_1
    filters: [is_hub_open: "1"]
  }

  measure: forecasted_avg_rider_handling_duration_seconds_adjusted {
    alias: [forecasted_avg_order_handling_duration_seconds_adjusted]
    group_label: "> Order Measures"
    label: "Adjusted Forecasted AVG Rider Handling Time (Seconds)"
    description: "Forecasted AVG Total Rider Handling Time: Riding to Customer + At customer + Riding to Hub (Incl. Airtable Adjustments)"
    type: average
    sql: ${TABLE}.forecasted_avg_rider_handling_duration_seconds_adjusted ;;
    value_format_name: decimal_1
    filters: [is_hub_open: "1"]
  }

  measure: forecasted_avg_rider_handling_duration_minutes_adjusted {
    alias: [forecasted_avg_order_handling_duration_minutes_adjusted]
    group_label: "> Order Measures"
    label: "Adjusted Forecasted AVG Rider Handling Time (Minutes)"
    description: "Forecasted AVG Total Rider Handling Time: Riding to Customer + At customer + Riding to Hub (Incl. Airtable Adjustments)"
    type: average
    sql: ${TABLE}.forecasted_avg_rider_handling_duration_minutes_adjusted ;;
    value_format_name: decimal_1
    filters: [is_hub_open: "1"]
  }

  ##### Forecasted Hours

  # =========  Forecasted minutes   =========

  measure: number_of_forecasted_minutes_picker {
    label: "# Forecasted Picker Minutes"
    type: sum
    sql: ${TABLE}.number_of_forecasted_minutes_picker ;;
    hidden: yes
  }

  measure: number_of_forecasted_minutes_picker_adjusted {
    alias: [number_of_adjusted_forecasted_minutes_picker]
    label: "# Adjusted Forecasted Picker Minutes"
    type: sum
    sql: ${TABLE}.number_of_forecasted_minutes_picker_adjusted ;;
    hidden: yes
  }

  measure: number_of_forecasted_minutes_rider {
    label: "# Forecasted Rider Minutes"
    type: sum
    sql: ${TABLE}.number_of_forecasted_minutes_rider ;;
    hidden: yes
  }

  measure: number_of_forecasted_minutes_rider_unrounded {
    label: "# Unrounded Forecasted Rider Minutes"
    type: sum
    sql: ${TABLE}.number_of_forecasted_minutes_rider_unrounded ;;
    hidden: yes
  }

  measure: number_of_forecasted_minutes_rider_unrounded_adjusted{
    label: "# Unrounded Adjusted Forecasted Rider Minutes"
    type: sum
    sql: ${TABLE}.number_of_forecasted_minutes_rider_unrounded_adjusted ;;
    hidden: yes
  }

  measure: number_of_forecasted_minutes_excl_no_show_rider {
    label: "# Forecasted Rider Minutes - Data Science (Excl. No Show)"
    type: sum
    sql: ${TABLE}.number_of_forecasted_minutes_excl_no_show_rider ;;
    hidden: yes
  }

  measure: number_of_forecasted_minutes_excl_no_show_rider_adjusted {
    label: "# Adjusted Forecasted Rider Minutes - Data Science (Excl. No Show)"
    type: sum
    sql: ${TABLE}.number_of_forecasted_minutes_excl_no_show_rider_adjusted ;;
    hidden: yes
  }

  measure: number_of_forecasted_minutes_excl_no_show_rider_unrounded {
    label: "# Unrounded Forecasted Rider Minutes - Data Science (Excl. No Show)"
    type: sum
    sql: ${TABLE}.number_of_forecasted_minutes_excl_no_show_rider_unrounded ;;
    hidden: yes
  }

  measure: number_of_forecasted_minutes_excl_no_show_rider_unrounded_adjusted {
    label: "# Unrounded Adjusted Forecasted Rider Minutes - Data Science (Excl. No Show)"
    type: sum
    sql: ${TABLE}.number_of_forecasted_minutes_excl_no_show_rider_unrounded_adjusted ;;
    hidden: yes
  }

  measure: number_of_forecasted_minutes_rider_adjusted {
    alias: [number_of_adjusted_forecasted_minutes_rider]
    label: "# Adjusted Forecasted Rider Minutes"
    type: sum
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

  measure: number_of_forecasted_hours_rider_unrounded {
    group_label: "> Rider Measures"
    label: "# Unrounded Forecasted Rider Hours"
    description: "# Forecasted Hours Needed for Riders without applying rounding logic."
    type: number
    sql: ${number_of_forecasted_minutes_rider_unrounded}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_hours_added_riders {
    group_label: "> Rider Measures"
    label: "# Forecasted Rider Hours Added (Due to Rounding)"
    description: "# Forecasted Hours added for Riders due to rounding logic. Formula: # Forecasted Rider Hours - # Unrounded Forecasted Rider Hours"
    type: number
    sql: (${number_of_forecasted_minutes_rider}-${number_of_forecasted_minutes_rider_unrounded})/60;;
    value_format_name: decimal_2
  }

  measure: number_of_hours_added_riders_adjusted {
    group_label: "> Rider Measures"
    label: "# Forecasted Rider Hours Added (Due to Rounding)"
    description: "# Forecasted Hours added for Riders due to rounding logic including Airtable adjustments. Formula: # Adjusted Forecasted Rider Hours - # Unrounded Adjusted Forecasted Rider Hours"
    type: number
    sql: (${number_of_forecasted_minutes_rider_adjusted}-${number_of_forecasted_minutes_rider_unrounded_adjusted})/60;;
    value_format_name: decimal_2
  }

  measure: number_of_forecasted_hours_rider_unrounded_adjusted {
    group_label: "> Rider Measures"
    label: "# Unrounded Adjusted Forecasted Rider Hours"
    description: "# Forecasted Hours Needed for Riders without applying rounding logic and including Airtable Adjustments."
    type: number
    sql: ${number_of_forecasted_minutes_rider_unrounded_adjusted}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_forecasted_hours_excl_no_show_rider_unrounded {
    group_label: "> Rider Measures"
    label: "# Unrounded Forecasted Rider Hours - Data Science (Excl. No Show)"
    description: "# Forecasted Hours Needed for Riders excluding No Show (it is the output from Data Science calculation) without applying rounding logic."
    type: number
    sql: ${number_of_forecasted_minutes_excl_no_show_rider_unrounded}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_forecasted_hours_excl_no_show_rider_unrounded_adjusted {
    group_label: "> Rider Measures"
    label: "# Unrounded Adjusted Forecasted Rider Hours - Data Science (Excl. No Show)"
    description: "# Forecasted Hours Needed for Riders excluding No Show (it is the output from Data Science calculation) without applying rounding logic and including adjustments made by the Rider Ops team using Airtable."
    type: number
    sql: ${number_of_forecasted_minutes_excl_no_show_rider_unrounded_adjusted}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_forecasted_hours_excl_no_show_rider {
    group_label: "> Rider Measures"
    label: "# Forecasted Rider Hours - Data Science (Excl. No Show)"
    description: "# Forecasted Hours Needed for Riders excluding No Show. It is the output from Data Science calculation."
    type: number
    sql: ${number_of_forecasted_minutes_excl_no_show_rider}/60;;
    value_format_name: decimal_1
  }

  measure: number_of_forecasted_hours_excl_no_show_rider_adjusted {
    group_label: "> Rider Measures"
    label: "# Adjusted Forecasted Rider Hours - Data Science (Excl. No Show)"
    description: "# Forecasted Hours Needed for Riders excluding No Show and including Airtable Adjustments. It is the output from Data Science calculation."
    type: number
    sql: ${number_of_forecasted_minutes_excl_no_show_rider_adjusted}/60;;
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
    description: "Summed Absolute Difference of orders per hub per 30 min timeslot/ # Actual Orders."
    type: number
    sql: ${summed_absolute_error}/nullif(${number_of_actual_orders},0);;
    value_format_name: percent_2
  }

  measure: summed_absolute_error {
    type: sum
    hidden: yes
    sql: ABS(${number_of_forecasted_orders_dimension} - ${number_of_actual_orders_dimension});;
  }

  measure: summed_absolute_error_adjusted {
    type: sum
    hidden: yes
    sql: ABS(${number_of_forecasted_orders_adjusted_dimension} - ${number_of_actual_orders_dimension});;
  }

  measure: wmape_orders_adjusted {
    group_label: "> Forecasting error"
    label: "wMAPE - Adjusted Orders"
    description: "Summed Absolute Difference of orders per hub per 30 min timeslot/ # Actual Orders."
    type: number
    sql: ${summed_absolute_error_adjusted}/nullif(${number_of_actual_orders},0);;
    value_format_name: percent_2
  }

  measure: wmape_hours {
    group_label: "> Forecasting error"
    label: "wMAPE - Scheduled Hours"
    description: "Summed Absolute Difference of Scheduled Hours per Hub per 30 min timeslot (# Forecasted Hours - # Scheduled Hours)/ # Scheduled Hours"
    type: number
    sql: ${summed_absolute_error_hours}/nullif(${ops.number_of_scheduled_hours_by_position},0);;
    value_format_name: percent_2
  }

  measure: summed_absolute_error_hours {
    type: sum
    hidden: yes
    sql: ABS(${number_of_forecasted_hours_by_position_dimension} - ${ops.number_of_scheduled_hours_by_position_dimension});;
  }

  measure: summed_absolute_error_hours_adjusted {
    type: sum
    hidden: yes
    sql: ABS(${number_of_forecasted_hours_by_position_adjusted_dimension} - ${ops.number_of_scheduled_hours_by_position_dimension});;
  }


  measure: wmape_hours_adjusted {
    group_label: "> Forecasting error"
    label: "wMAPE - Adjusted Scheduled Hours"
    description: "Summed Absolute Difference of Scheduled Hours per Hub per 30 min timeslot (# Adjusted Forecasted Hours (Incl. Airtable Adjustments) - # Scheduled Hours)/ # Scheduled Hours"
    type: number
    sql: ${summed_absolute_error_hours_adjusted}/nullif(${ops.number_of_scheduled_hours_by_position},0);;
    value_format_name: percent_2
  }

  measure: summed_absolute_error_worked_hours_adjusted {
    type: sum
    hidden: yes
    sql: ABS(${number_of_forecasted_hours_by_position_adjusted_dimension} - ${ops.number_of_worked_hours_by_position_dimension});;
  }

  measure: wmape_worked_hours_adjusted {
    group_label: "> Forecasting error"
    label: "wMAPE - Worked (Punched) Hours"
    description: "Summed Absolute Difference of Worked (Punched) Hours per Hub per 30 min timeslot (# Adjusted Forecasted Hours (Incl. Airtable Adjustments) - # Worked (Punched) Hours)/ # Worked (Punched) Hours"
    type: number
    sql: ${summed_absolute_error_worked_hours_adjusted}/nullif(${ops.number_of_worked_hours_by_position},0);;
    value_format_name: percent_2
  }

  measure: wmape_no_show_hours {
    group_label: "> Forecasting error"
    label: "wMAPE - No Show Hours"
    description: "Summed Absolute Difference of Actual No Show Hours per Hub per 30 min timeslot (# Forecasted No Show Hours - # Actual No Show Hours)/ # Actual No Show Hours"
    type: number
    hidden: no
    sql: ${summed_absolute_error_no_show_hours}/nullif(${ops.number_of_no_show_hours_by_position},0);;
    value_format_name: percent_2
  }

  measure: summed_absolute_error_no_show_hours {
    type: sum
    hidden: yes
    sql: ABS(${number_of_no_show_hours_by_position_dimension} - ${ops.number_of_no_show_hours_by_position_dimension});;
  }

  measure: summed_absolute_error_no_show_hours_adjusted {
    type: sum
    hidden: yes
    sql: ABS(${number_of_no_show_hours_by_position_adjusted_dimension} - ${ops.number_of_no_show_hours_by_position_dimension});;
  }

  measure: wmape_no_show_hours_adjusted {
    group_label: "> Forecasting error"
    label: "wMAPE - Adjusted No Show Hours"
    description: "Summed Absolute Difference of Actual No Show Hours per Hub per 30 min timeslot (# Adsjuted Forecasted No Show Hours (Incl. Airtable Adjustments) - # Actual No Show Hours)/ # Actual No Show Hours"
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
    type: sum
    hidden: no
    sql: ${backlog_bias_numerator};;
  }

  measure: sum_backlog_bias_denominator {
    group_label: "> Forecasting error"
    label: "Backlog Bias Denominator - Orders"
    description: "Reflects the order forecast backlog bias multiplied by the actual number of orders."
    type: sum
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

  measure: number_of_scheduled_hours_by_position_unknown {
    type: number
    label: "# Unknown Scheduled Hours (Incl. Deleted Excused No Show)"
    description: "# Total Scheduled Hours - # Extra Scheduled Hours (NS+, WFS, EC) - # Adjusted Forecasted Hours"
    value_format_name: decimal_1
    group_label: "> Dynamic Measures"
    sql: ${ops.number_of_scheduled_hours_by_position}-${ops.number_of_scheduled_hours_by_position_extra}-${number_of_forecasted_hours_by_position_adjusted} ;;
  }

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
    description: "# Adjusted Forecasted Hours (Incl. Airtable Adjustments) - No Show Forecasts included in Total Forecasted Hours."
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
    description: "# Forecasted Hours Needed - No Show Forecasts included in Total Forecasted Hours."
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
    description: "# Forecasted Hours Needed (Incl. Airtable Adjustments) - No Show Forecasts included in Total Forecasted Hours."
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

  measure: number_of_forecasted_hours_excl_no_show_ds_by_position{
    type: number
    label: "# Forecasted Hours - Data Science (Excl. No Show)"
    description: "# Forecasted Hours excluding No Show. It is the output from Data Science calculation."
    value_format_name: decimal_2
    group_label: "> Dynamic Measures"
    sql:
        case
          when {% parameter ops.position_parameter %} = 'Rider'
            then ${number_of_forecasted_hours_excl_no_show_rider}
          else null
        end ;;
  }

  measure: number_of_forecasted_hours_excl_no_show_adjusted_ds_by_position{
    type: number
    label: "# Adjusted Forecasted Hours - Data Science (Excl. No Show)"
    description: "# Forecasted Hours excluding No Show and including Airtable Adjustments. It is the output from Data Science calculation."
    value_format_name: decimal_2
    group_label: "> Dynamic Measures"
    sql:
        case
          when {% parameter ops.position_parameter %} = 'Rider'
            then ${number_of_forecasted_hours_excl_no_show_rider_adjusted}
          else null
        end ;;
  }

  measure: number_of_forecasted_hours_excl_no_show_unrounded_ds_by_position{
    type: number
    label: "# Unrounded Forecasted Hours - Data Science (Excl. No Show)"
    description: "# Forecasted Hours Needed for Riders excluding No Show without applying rounding logic. It is the output from Data Science calculation."
    value_format_name: decimal_2
    group_label: "> Dynamic Measures"
    sql:
        case
          when {% parameter ops.position_parameter %} = 'Rider'
            then ${number_of_forecasted_hours_excl_no_show_rider_unrounded}
          else null
        end ;;
  }

  measure: number_of_forecasted_hours_excl_no_show_unrounded_adjusted_ds_by_position{
    type: number
    label: "# Unrounded Adjusted Forecasted Hours - Data Science (Excl. No Show)"
    description: "# Forecasted Hours excluding No Show without applying rounding logic and including Airtable Adjustments. It is the output from Data Science calculation."
    value_format_name: decimal_2
    group_label: "> Dynamic Measures"
    sql:
        case
          when {% parameter ops.position_parameter %} = 'Rider'
            then ${number_of_forecasted_hours_excl_no_show_rider_unrounded_adjusted}
          else null
        end ;;
  }

  measure: number_of_forecasted_hours_unrounded_by_position{
    type: number
    label: "# Unrounded Forecasted Hours (Incl. No Show)"
    description: "# Forecasted Hours without applying rounding logic."
    value_format_name: decimal_2
    group_label: "> Dynamic Measures"
    sql:
        case
          when {% parameter ops.position_parameter %} = 'Rider'
            then ${number_of_forecasted_hours_rider_unrounded}
          else null
        end ;;
  }

  measure: number_of_forecasted_hours_unrounded_adjusted_by_position{
    type: number
    label: "# Unrounded Adjusted Forecasted Hours (Incl. No Show)"
    description: "# Forecasted Hours without applying rounding logic and including Airtable Adjustments."
    value_format_name: decimal_2
    group_label: "> Dynamic Measures"
    sql:
        case
          when {% parameter ops.position_parameter %} = 'Rider'
            then ${number_of_forecasted_hours_rider_unrounded_adjusted}
          else null
        end ;;
  }

  measure: number_of_hours_added_by_position{
    type: number
    label: "# Forecasted Hours Added (Due to Rounding)"
    description: "# Forecasted Hours added due to rounding logic. Formula: # Forecasted Rider Hours - # Unrounded Forecasted Rider Hours"
    value_format_name: decimal_2
    group_label: "> Dynamic Measures"
    sql:
        case
          when {% parameter ops.position_parameter %} = 'Rider'
            then ${number_of_hours_added_riders}
          else null
        end ;;
  }

  measure: number_of_hours_added_adjusted_by_position{
    type: number
    label: "# Adjsuted Forecasted Hours Added (Due to Rounding)"
    description: "# Forecasted Hours added due to rounding logic including Airtable adjustments. Formula: # Adjusted Forecasted Rider Hours - # Unrounded Adjusted Forecasted Rider Hours"
    value_format_name: decimal_2
    group_label: "> Dynamic Measures"
    sql:
        case
          when {% parameter ops.position_parameter %} = 'Rider'
            then ${number_of_hours_added_riders_adjusted}
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
    hidden: yes
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
    hidden: yes
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
    label: "Forecasted UTR (Incl. No Show)"
    description: "Forecasted Orders/Forecasted Hours (Incl. No Show)"
    value_format_name: decimal_2
    group_label: "> Dynamic Measures"
    sql: ${number_of_forecasted_orders}/nullif(${number_of_forecasted_hours_by_position},0);;
  }

  measure: final_utr_by_position_adjusted {
    type: number
    label: "Adjusted Forecasted UTR (Incl. No Show)"
    description: "Adjusted Forecasted Orders (Incl. Airtable Adjustments) / Adjusted Forecasted Hours (Incl. Airtable Adjustments)"
    value_format_name: decimal_2
    group_label: "> Dynamic Measures"
    sql: ${number_of_forecasted_orders_adjusted}/nullif(${number_of_forecasted_hours_by_position_adjusted},0);;
  }

  measure: forecasted_utr_excl_no_show_by_position {
    type: number
    label: "Target UTR (Excl. No Show)"
    description: "Forecasted Orders / Forecasted Hours (Excl. No Show)"
    value_format_name: decimal_2
    group_label: "> Dynamic Measures"
    sql: ${number_of_forecasted_orders}/nullif(${number_of_forecasted_hours_excl_no_show_by_position},0);;
  }

  measure: forecasted_utr_excl_no_show_by_position_adjusted {
    type: number
    label: "Adjusted Target UTR (Excl. No Show)"
    description: "Adjusted Forecasted Orders (Incl. Airtable Adjustments)/Adjusted Forecasted Hours (Incl. Airtable Adjustments and Excl. No Show)"
    value_format_name: decimal_2
    group_label: "> Dynamic Measures"
    sql: ${number_of_forecasted_orders_adjusted}/nullif(${number_of_forecasted_hours_excl_no_show_by_position_adjusted},0);;
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
    description: "# Hours needed based on # Actual Orders (Forecast-related) / Target UTR (Excl. No Show). For pickers it is calculated based on # Actual Orders."
    value_format_name: decimal_1
    sql:
        case
          when {% parameter ops.position_parameter %} = 'Rider'
            then nullif(${number_of_actual_orders},0)/nullif(${forecasted_utr_excl_no_show_by_position},0)
          when {% parameter ops.position_parameter %} = 'Picker'
            then nullif(${orders_with_ops_metrics.sum_orders},0)/nullif(${forecasted_utr_excl_no_show_by_position},0)
          else null
        end ;;
  }

  measure: fixed_actual_needed_hours_by_position_adjusted {
    type: number
    group_label: "> Dynamic Measures"
    label: "# Adjusted Actually Needed Hours"
    description: "# Hours needed based on # Actual Orders (Forecast-related) / Adjusted Target UTR (Excl. No Show). For pickers it is calculated based on # Actual Orders."
    value_format_name: decimal_1
    sql:
        case
          when {% parameter ops.position_parameter %} = 'Rider'
            then nullif(${number_of_actual_orders},0)/nullif(${forecasted_utr_excl_no_show_by_position_adjusted},0)
          when {% parameter ops.position_parameter %} = 'Picker'
            then nullif(${orders_with_ops_metrics.sum_orders},0)/nullif(${forecasted_utr_excl_no_show_by_position_adjusted},0)
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
    type: sum
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
    type: sum
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
    sql:  ${summed_overstaffing_error_adjusted} / nullif(${number_of_forecasted_hours_by_position_adjusted},0) ;;
    value_format_name: percent_1
    hidden: no
  }

  measure: summed_understaffing_error {
    group_label: "> Dynamic Measures"
    label: "Summed Understaffing Error"
    type: sum
    description: "How much understaffed we are compared to what was forecasted in cases of understaffing. when Forecasted Hours > Scheduled Hours: (Forecasted Hours - Scheduled Hours) / Forecasted Hours"
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
    label: "Adjusted Summed Understaffing Error"
    type: sum
    description: "How much understaffed we are compared to what was forecasted (Incl. Airtable Adjustments) in cases of understaffing. when Forecasted Hours > Scheduled Hours: (Forecasted Hours - Scheduled Hours) / Forecasted Hours"
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
    sql:  ${summed_understaffing_error_adjusted} / nullif(${number_of_forecasted_hours_by_position_adjusted},0) ;;
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

  parameter: date_granularity {
    label: "Date Granularity"
    type: unquoted
    allowed_value: { value: "Day" }
    allowed_value: { value: "Week" }
    allowed_value: { value: "Month" }
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
     {% elsif date_granularity._parameter_value == 'Month' %}
      ${start_timestamp_month}
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
            {% elsif date_granularity._parameter_value == 'Month' %}
              "Month"
            {% endif %};;
  }

}
