# Owner:   Nazrin Guliyeva
# Created: 2022-05-17

# This view contains forecast data from multiple forecast tables on time slot, hub, and job date level.

view: forecasts {
  sql_table_name: `flink-data-prod.curated.forecasts`
    ;;

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
    label: "Is Hub Open ?"
    type: number
    sql: ${TABLE}.is_hub_open ;;
  }

  dimension: headcount_pipeline_status {
    label: "Headcount Pipeline Status"
    type: string
    sql: ${TABLE}.headcount_pipeline_status ;;
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
    label: "Time slot"
    type: time
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
    convert_tz: yes
    sql: ${TABLE}.start_timestamp ;;
  }

  dimension_group: order {
    type: time
    timeframes: [
      raw,
      date
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.order_date ;;
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
    group_label: ">> Rider KPIs"
    label: "% No Show Rider"
    type: number
    sql: ${TABLE}.pct_forecasted_no_show_rider ;;
  }

  # =========  Idleness   =========

  dimension: pct_idleness_target_rider {
    group_label: ">> Rider KPIs"
    label: "% Idleness Rider"
    type: number
    value_format_name: percent_1
    sql: ${TABLE}.pct_idleness_target_rider ;;
  }

  dimension: pct_idleness_target_picker {
    group_label: ">> Picker KPIs"
    label: "% Idleness Picker"
    type: number
    value_format_name: percent_1
    sql: ${TABLE}.pct_idleness_target_picker ;;
  }

  # =========  Stacking   =========

  dimension: pct_stacking_assumption {
    group_label: ">> Order KPIs"
    label: "% Stacking Assumption"
    type: number
    sql: ${TABLE}.pct_stacking_assumption ;;
  }

  dimension: stacking_effect_multiplier {
    label: "Stacking Effect mULTIPLIER"
    type: number
    sql: ${TABLE}.stacking_effect_multiplier ;;
    hidden: yes
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~      Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  # =========  UTR   =========

  measure: number_of_target_orders_per_picker {
    group_label: ">> Picker KPIs"
    label: "Base UTR Picker"
    description: "# Target Orders per Hour per Picker (Target UTR)"
    type: average_distinct
    sql_distinct_key: ${forecast_uuid} ;;
    sql: ${TABLE}.number_of_target_orders_per_picker ;;
  }

  measure: number_of_target_orders_per_rider {
    group_label: ">> Rider KPIs"
    label: "Base UTR Rider"
    description: "# Target Orders per Hour per Rider (Target UTR)"
    type: average_distinct
    sql_distinct_key: ${forecast_uuid} ;;
    sql: ${TABLE}.number_of_target_orders_per_rider ;;
  }

  measure: forecasted_base_utr_incl_stacking_picker {
    group_label: ">> Picker KPIs"
    label: "Base UTR Picker (Incl. Stacking)"
    description: "Base UTR Picker (Incl. Stacking) - Target UTR * Stacking Effect Multiplier"
    type: average_distinct
    sql_distinct_key: ${forecast_uuid} ;;
    sql: ${TABLE}.forecasted_base_utr_incl_stacking_picker ;;
  }

  measure: forecasted_base_utr_incl_stacking_rider {
    group_label: ">> Rider KPIs"
    label: "Base UTR Rider (Incl. Stacking)"
    description: "Base UTR Rider (Incl. Stacking) - Target UTR * Stacking Effect Multiplier"
    type: average_distinct
    sql_distinct_key: ${forecast_uuid} ;;
    sql: ${TABLE}.forecasted_base_utr_incl_stacking_rider ;;
  }

  measure: final_utr_picker {
    group_label: ">> Picker KPIs"
    label: "Final UTR Picker"
    description: "Final UTR - Forecasted Orders / Forecasted Hours"
    sql: ${number_of_forecasted_orders}/${number_of_forecasted_hours_picker} ;;
  }

  measure: final_utr_rider {
    group_label: ">> Rider KPIs"
    label: "Final UTR Rider"
    description: "Final UTR - Forecasted Orders / Forecasted Hours"
    sql: ${number_of_forecasted_orders}/${number_of_forecasted_hours_rider} ;;

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
    sql_distinct_key: ${forecast_uuid} ;;
    sql: ${TABLE}.number_of_forecasted_orders ;;
  }

  measure: forecasted_avg_order_handling_duration_seconds {
    group_label: ">> Order KPIs"
    label: "Forecasted Order Handling Duration (Seconds)"
    type: average_distinct
    sql_distinct_key: ${forecast_uuid} ;;
    sql: ${TABLE}.forecasted_avg_order_handling_duration_seconds ;;
  }

  measure: forecasted_avg_order_handling_duration_minutes {
    group_label: ">> Order KPIs"
    label: "Forecasted Order Handling Duration (Minutes)"
    type: average_distinct
    sql_distinct_key: ${forecast_uuid} ;;
    sql: ${TABLE}.forecasted_avg_order_handling_duration_minutes ;;
  }

  measure: number_of_missed_orders {
    group_label: ">> Order KPIs"
    label: "# Missed Orders"
    type: sum_distinct
    sql_distinct_key: ${forecast_uuid} ;;
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
    group_label: ">> Dynamic Values"
    sql:
        CASE
          WHEN {% parameter position_parameter %} = 'Rider' THEN ${number_of_forecasted_riders}
          WHEN {% parameter position_parameter %} = 'Picker' THEN ${number_of_forecasted_pickers}
      ELSE NULL
      END ;;
  }

  measure: number_of_forecasted_hours_by_position {
    type: number
    label: "# Forecasted Hours (Incl. No Show)"
    value_format_name: decimal_1
    group_label: ">> Dynamic Values"
    sql:
        CASE
          WHEN {% parameter position_parameter %} = 'Rider' THEN ${number_of_forecasted_hours_rider}
          WHEN {% parameter position_parameter %} = 'Picker' THEN ${number_of_forecasted_hours_picker}
      ELSE NULL
      END ;;
  }

  measure: pct_no_show_by_position {
    type: number
    label: "% Forecasted No Show Hours"
    value_format_name: decimal_1
    group_label: ">> Dynamic Values"
    sql:
        CASE
          WHEN {% parameter position_parameter %} = 'Rider' THEN ${pct_forecasted_no_show_rider}
      ELSE NULL
      END ;;
      hidden: yes
  }

  measure: number_of_no_show_hours_by_position {
    type: number
    label: "# Forecasted No Show Hours"
    value_format_name: decimal_1
    group_label: ">> Dynamic Values"
    sql:
        CASE
          WHEN {% parameter position_parameter %} = 'Rider' THEN ${number_of_forecasted_no_show_minutes_rider}/60
      ELSE NULL
      END ;;
  }

  measure: number_of_forecasted_hours_excl_no_show_by_position {
    type: number
    label: "# Forecasted Hours (Excl. No Show)"
    value_format_name: decimal_1
    group_label: ">> Dynamic Values"
    sql: ${number_of_forecasted_hours_by_position}-${number_of_no_show_hours_by_position} ;;
  }

  dimension: number_of_idleness_target_by_position {
    type: number
    label: "# Idleness Target"
    value_format_name: decimal_1
    group_label: ">> Dynamic Values"
    sql:
        CASE
          WHEN {% parameter position_parameter %} = 'Rider' THEN ${pct_idleness_target_rider}
          WHEN {% parameter position_parameter %} = 'Picker' THEN ${pct_idleness_target_picker}
      ELSE NULL
      END ;;
    hidden: yes
  }

  measure: number_of_target_orders_by_position {
    type: number
    label: "Base UTR"
    description: "# Target Orders per hour per Position"
    value_format_name: decimal_1
    group_label: ">> Dynamic Values"
    sql:
        CASE
          WHEN {% parameter position_parameter %} = 'Rider' THEN ${number_of_target_orders_per_rider}
          WHEN {% parameter position_parameter %} = 'Picker' THEN ${number_of_target_orders_per_picker}
      ELSE NULL
      END ;;
  }

  measure: base_utr_incl_stacking_by_position {
    type: number
    label: "Base UTR (Incl. Stacking)"
    description: "Base UTR * Stacking Effect Multiplier"
    value_format_name: decimal_1
    group_label: ">> Dynamic Values"
    sql:
        CASE
          WHEN {% parameter position_parameter %} = 'Rider' THEN ${forecasted_base_utr_incl_stacking_rider}
          WHEN {% parameter position_parameter %} = 'Picker' THEN ${forecasted_base_utr_incl_stacking_picker}
      ELSE NULL
      END ;;
  }

  measure: final_utr_by_position {
    type: number
    label: "Final UTR"
    description: "Forecasted Orders/Forecasted Hours"
    value_format_name: decimal_1
    group_label: ">> Dynamic Values"
    sql: ${number_of_forecasted_orders}/${number_of_forecasted_hours_by_position};;
  }

  measure: actual_needed_hours_by_position {
    type: number
    label: "# Actually Needed Hours"
    value_format_name: decimal_1
    group_label: ">> Dynamic Values"
    sql: ${orders_cl.cnt_successful_orders}/${number_of_target_orders_by_position};;
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
