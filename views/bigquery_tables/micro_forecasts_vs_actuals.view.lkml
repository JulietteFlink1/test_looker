view: micro_forecasts_vs_actuals {
  sql_table_name: `flink-data-prod.order_forecast.micro_forecasts_vs_actuals`
    ;;

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

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
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: is_open {
    type: number
    sql: ${TABLE}.is_open ;;
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

  dimension: live_model {
    type: yesno
    sql: ${TABLE}.live_model ;;
  }

  dimension_group: local {
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
    sql: ${TABLE}.local_date ;;
  }

  dimension: local_start_time {
    type: string
    sql: ${TABLE}.local_start_time ;;
  }

  dimension: model_name {
    type: string
    sql: ${TABLE}.model_name ;;
  }



  dimension_group: start_timestamp {
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
    sql: ${TABLE}.start_timestamp ;;
  }

  dimension: timezone {
    type: string
    sql: ${TABLE}.timezone ;;
  }



  dimension_group: utc {
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
    sql: ${TABLE}.utc_date ;;
  }





  dimension: ok_orders {
    label: "Ok_orders"
    hidden: yes
    type: number
    sql: ${TABLE}.ok_orders;;
    value_format_name: decimal_0
  }


  dimension: prediction {
    label: "prediction"
    hidden: no
    type: number
    sql: ${TABLE}.prediction;;
    value_format_name: decimal_0
  }

  dimension: prediction_lower_bound {
    label: "prediction_lower_bound"
    hidden: yes
    type: number
    sql: ${TABLE}.prediction_lower_bound;;
    value_format_name: decimal_0
  }


  dimension: prediction_upper_bound {
    label: "prediction_upper_bound"
    hidden: yes
    type: number
    sql: ${TABLE}.prediction_upper_bound;;
    value_format_name: decimal_0
  }

  dimension: public_holiday_left_shoulder_width {
    label: "public_holiday_left_shoulder_width"
    hidden: yes
    type: number
    sql: ${TABLE}.public_holiday_left_shoulder_width;;
    value_format_name: decimal_0
  }

  dimension: public_holiday_right_shoulder_width {
    label: "public_holiday_right_shoulder_width"
    hidden: yes
    type: number
    sql: ${TABLE}.public_holiday_right_shoulder_width;;
    value_format_name: decimal_0
  }


  dimension: closure_missed_orders {
    label: "closure_missed_orders"
    hidden: yes
    type: number
    sql: ${TABLE}.closure_missed_orders;;
    value_format_name: decimal_0
  }


  dimension: observed_orders_total {
    label: "Total observed orders"
    hidden: no
    type: number
    sql: ${TABLE}.observed_orders_total;;
    value_format_name: decimal_0
  }

  dimension: forecast_horizon {
    label: "Forecast horizon - days"
    type:  number
    sql:  DATE_DIFF(${local_date}, ${job_date}, DAY) ;;
  }

  measure: count_values {
    type: count
  }


  measure: absolute_percentage_error {
    group_label: " * Forecasting error * "
    type: sum
    hidden: yes
    sql: ABS(${prediction} - ${observed_orders_total})/(GREATEST(1, ${observed_orders_total})) ;;
  }

  measure: bias {
    group_label: " * Forecasting error * "
    label: "Bias"
    type: sum
    sql: ${prediction} - ${observed_orders_total};;
  }

  measure: mean_absolute_percentage_error {
    group_label: " * Forecasting error * "
    label: "MAPE"
    type: number
    sql: ${absolute_percentage_error}/ NULLIF(${count_values}, 0);;
    value_format_name: percent_0
  }

  measure: weighted_mean_absolute_percentage_error {
    group_label: " * Forecasting error * "
    label: "wMAPE"
    type: number
    sql: ${summed_absolute_error}/${summed_absolute_actuals};;
    value_format_name: percent_0
  }

  measure: summed_absolute_error {
    group_label: " * Orders * "
    type: sum
    hidden: yes
    sql: ABS(${prediction} - ${observed_orders_total});;
  }

  measure: summed_absolute_actuals {
    group_label: " * Orders * "
    type: sum
    hidden: yes
    sql: ABS(${observed_orders_total});;
  }

  measure: sum_orders {
    group_label: " * Orders * "
    label: "# Total observed orders"
    sql: ${observed_orders_total} ;;
    type: sum
  }

  measure: sum_predicted_orders {
    group_label: " * Orders * "
    label: "# Forecasted orders"
    sql: ${prediction} ;;
    type: sum
  }
}
