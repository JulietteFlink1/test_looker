view: micro_no_show_forecast_vs_actuals {
  sql_table_name: `flink-data-dev.worker_no_show.micro_no_show_forecast_vs_actuals`
    ;;

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Dimensions     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension_group: block_starts_at_timestamp {
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
    sql: ${TABLE}.block_starts_at_timestamp ;;
  }

  dimension: is_hub_open {
    type: number
    sql: ${TABLE}.is_hub_open ;;
  }

  dimension_group: job {
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

  dimension_group: local_shift {
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
    sql: ${TABLE}.local_shift_date ;;
  }

  dimension_group: local_start_at_timestamp {
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
    datatype: datetime
    sql: ${TABLE}.local_start_at_timestamp ;;
  }

  dimension: timezone {
    type: string
    sql: ${TABLE}.timezone ;;
  }

  dimension: forecast_horizon {
    label: "Forecast horizon - days"
    type:  number
    sql:  DATE_DIFF(${local_shift_date}, ${job_date}, DAY) ;;
  }

  dimension: prediction {
    label: "predicted no-show minutes"
    hidden: yes
    type: number
    sql: ${TABLE}.predicted_no_show_minutes;;
  }

  dimension: actual {
    label: "actual no-show minutes"
    hidden: yes
    type: number
    sql: ${TABLE}.actual_no_show_minutes;;
  }
  dimension: number_of_planned_minutes {
    label: "number of planned minutes"
    hidden: yes
    type: number
    sql: ${TABLE}.number_of_planned_minutes ;;
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures     ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  measure: 1d_forecasted_no_show_hours {
    label: "# Forecasted No-show hours (D-1)"
    type:  sum
    sql: CASE
          WHEN DATE_DIFF(${local_shift_date}, ${job_date}, DAY)=1 THEN ${prediction}/60
          END ;;
    value_format_name: decimal_1
  }

  measure: 7d_forecasted_no_show_hours {
    label: "# Forecasted No-show hours (D-7)"
    type:  sum
    sql: CASE
          WHEN DATE_DIFF(${local_shift_date}, ${job_date}, DAY)=7 THEN ${prediction}/60
          END ;;
    value_format_name: decimal_1
  }

  measure: 14d_forecasted_no_show_hours {
    label: "# Forecasted No-show hours (D-14)"
    type:  sum
    sql: CASE
          WHEN DATE_DIFF(${local_shift_date}, ${job_date}, DAY)=14 THEN ${prediction}/60
          END ;;
    value_format_name: decimal_1
  }

  measure: 21d_forecasted_no_show_hours {
    label: "# Forecasted No-show hours (D-21)"
    type:  sum
    sql: CASE
          WHEN DATE_DIFF(${local_shift_date}, ${job_date}, DAY)=21 THEN ${prediction}/60
          END ;;
    value_format_name: decimal_1
  }

  measure: sum_predicted_no_show_hours {
    group_label: " * No-show * "
    label: "# Forecasted no-show hours"
    sql: ${prediction}/60 ;;
    type: sum
    value_format_name: decimal_1
  }

  measure: sum_actual_no_show_hours {
    group_label: " * No-show * "
    label: "# Actual no-show hours"
    sql: ${actual}/60 ;;
    type: sum
    value_format_name: decimal_1
  }

  measure: sum_planned_hours{
    type: sum
    label:"# Scheduled Hours"
    description: "Number of Scheduled Hours"
    sql:${number_of_planned_minutes}/60;;
    value_format_name: decimal_1
  }

  measure: summed_absolute_actuals {
    group_label: " * Actuals * "
    type: sum
    hidden: yes
    sql: ABS(${actual});;
  }

  measure: summed_absolute_error {
    group_label: " * Absolute Error * "
    type: sum
    hidden: yes
    sql: ABS(${prediction} - ${actual});;
  }

  measure: weighted_mean_absolute_percentage_error {
    group_label: " * No-show forecasting error * "
    label: "wMAPE"
    type: number
    sql: ${summed_absolute_error}/nullif(${summed_absolute_actuals},0);;
    value_format_name: percent_0
  }

  measure: actual_pct_no_show{
    label:"% Actual no Show Hours"
    type: number
    description: "Actual pct of No Show "
    sql:(${sum_actual_no_show_hours})/nullif(${sum_planned_hours},0) ;;
    value_format_name: percent_1
  }

  measure: predicted_pct_no_show{
    label:"% predicted no Show Hours"
    type: number
    description: "Predicted pct of No Show "
    sql:(${sum_predicted_no_show_hours})/nullif(${sum_planned_hours},0) ;;
    value_format_name: percent_1
  }

  measure: count_values {
    type: count
  }

}
