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





  measure: ok_orders {
    label: "Ok_orders"
    type: sum
    sql: ${TABLE}.ok_orders;;
    value_format_name: decimal_0
  }


  measure: prediction {
    label: "prediction"
    type: sum
    sql: ${TABLE}.prediction;;
    value_format_name: decimal_0
  }

  measure: prediction_lower_bound {
    label: "prediction_lower_bound"
    type: sum
    sql: ${TABLE}.prediction_lower_bound;;
    value_format_name: decimal_0
  }


  measure: prediction_upper_bound {
    label: "prediction_upper_bound"
    type: sum
    sql: ${TABLE}.prediction_upper_bound;;
    value_format_name: decimal_0
  }

  measure: public_holiday_left_shoulder_width {
    label: "public_holiday_left_shoulder_width"
    type: sum
    sql: ${TABLE}.public_holiday_left_shoulder_width;;
    value_format_name: decimal_0
  }

  measure: public_holiday_right_shoulder_width {
    label: "public_holiday_right_shoulder_width"
    type: sum
    sql: ${TABLE}.public_holiday_right_shoulder_width;;
    value_format_name: decimal_0
  }


  measure: closure_missed_orders {
    label: "closure_missed_orders"
    type: sum
    sql: ${TABLE}.closure_missed_orders;;
    value_format_name: decimal_0
  }


  measure: total_orders {
    label: "total_orders"
    type: sum
    sql: ${TABLE}.total_orders;;
    value_format_name: decimal_0
  }

}
