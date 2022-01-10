view: voucher_failure_traits {

  sql_table_name: `flink-data-dev.reporting.voucher_failure_session_traits`
    ;;

  dimension: voucher_failure_session_traits_uuid {
    type: string
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.voucher_failure_session_traits_uuid ;;
  }

  dimension_group: event_date {
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
    sql: ${TABLE}.event_date ;;
  }

  dimension: device_type {
    type: string
    sql: ${TABLE}.device_type ;;
  }


  ######## Measures

  measure: number_of_sessions {
    type: count_distinct
    sql: ${TABLE}.session_id;;
  }



  measure:  number_of_failures_not_valid_yet{
    type: sum
    sql:${TABLE}.number_of_fails_not_valid_yet ;;
  }

  measure: failure_rate_not_valid_yet {
    type: number
    sql: (${number_of_failures_not_valid_yet}/${number_of_sessions})*100 ;;
    value_format: "0.0\%"
  }




  measure:  number_of_failures_min_spent_unreached{
    type: sum
    sql:${TABLE}.number_of_fails_min_spent_unreached ;;
  }

  measure: failure_rate_min_spent_unreached {
    type: number
    sql: (${number_of_failures_min_spent_unreached}/${number_of_sessions})*100 ;;
    value_format: "0.0\%"
  }




  measure:  number_of_fails_already_used{
    type: sum
    sql:${TABLE}.number_of_fails_already_used ;;
  }

  measure: failure_rate_fails_already_use {
    type: number
    sql: (${number_of_fails_already_used}/${number_of_sessions})*100 ;;
    value_format: "0.0\%"
  }


  measure:  number_of_fails_unknown_error{
    type: sum
    sql:${TABLE}.number_of_fails_unknown_error ;;
  }

  measure: failure_rate_unknown_error {
    type: number
    sql: (${number_of_fails_unknown_error}/${number_of_sessions})*100 ;;
    value_format: "0.0\%"
  }


  measure:  number_of_fails_connection_refused{
    type: sum
    sql:${TABLE}.number_of_fails_connection_refused ;;
  }

  measure: failure_rate_connection_refused {
    type: number
    sql: (${number_of_fails_connection_refused}/${number_of_sessions})*100 ;;
    value_format: "0.0\%"
  }



  measure:  number_of_fails_not_found{
    type: sum
    sql:${TABLE}.number_of_fails_not_found ;;
  }

  measure: failure_rate_not_found {
    type: number
    sql: (${number_of_fails_not_found}/${number_of_sessions})*100 ;;
    value_format: "0.0\%"
  }

  measure:  number_of_error_happened{
    type: sum
    sql:${TABLE}.error_happened ;;
  }


  measure:  number_of_error_happened_ios{
    type: sum
    sql:${TABLE}.error_happened ;;
    filters: [device_type: "ios"]
  }

  measure:  number_of_error_happened_android{
    type: sum
    sql:${TABLE}.error_happened ;;
    filters: [device_type: "android"]
  }

  measure: failure_rate {
    type: number
    sql: (${number_of_error_happened}/${number_of_sessions})*100 ;;
    value_format: "0.0\%"
  }


  measure: failure_rate_ios {
    type: number
    sql: (${number_of_error_happened_ios}/${number_of_sessions})*100 ;;
    value_format: "0.0\%"
  }

  measure: failure_rate_android {
    type: number
    sql: (${number_of_error_happened_android}/${number_of_sessions})*100 ;;
    value_format: "0.0\%"
  }




  set: detail {
    fields: [
      device_type,
      number_of_sessions,
      number_of_failures_not_valid_yet,
      failure_rate_not_valid_yet,
      number_of_failures_min_spent_unreached,
      failure_rate_min_spent_unreached,
      number_of_fails_already_used,
      failure_rate_fails_already_use,
      number_of_fails_unknown_error,
      failure_rate_unknown_error,
      number_of_fails_connection_refused,
      failure_rate_connection_refused,
      number_of_fails_not_found,
      failure_rate_not_found,
      number_of_error_happened_ios,
      number_of_error_happened_android,
      failure_rate_ios,
      failure_rate_android,
      failure_rate,
      number_of_error_happened
    ]
  }
}
