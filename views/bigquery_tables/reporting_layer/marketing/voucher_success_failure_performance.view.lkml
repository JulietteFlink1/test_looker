view: voucher_success_failure_performance {
  sql_table_name: `flink-data-prod.reporting.voucher_success_failure_performance`
    ;;

  dimension: voucher_success_failure_event_uuid {
    type: string
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.voucher_success_failure_event_uuid ;;
  }

  dimension: event_date {
    type: date
    hidden: no
    sql:  ${TABLE}.event_date;;
  }

  dimension: voucher_code {
    type: string
    sql: ${TABLE}.voucher_code ;;
  }

  dimension: device_type {
    type: string
    sql: ${TABLE}.device_type ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: city_name {
    type: string
    sql: ${TABLE}.city_name ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: is_new_customer {
    type: yesno
    sql: ${TABLE}.is_new_customer ;;
  }

  dimension: voucher_event_name {
    type: string
    sql: ${TABLE}.voucher_event_name ;;
  }

  dimension: voucher_attempted_error_message {
    type: string
    sql: ${TABLE}.voucher_attempted_error_message ;;
  }

  dimension: dim_number_of_events {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_events ;;
  }

  ######## Measures

  measure: number_of_events {
    type: sum
    sql: ${dim_number_of_events} ;;
  }

  measure:  number_of_successes{
    type: sum
    sql:${dim_number_of_events}  ;;
    filters: [voucher_event_name: "voucher_applied_succeeded"]
  }

  measure:  number_of_failures{
    type: sum
    sql:${dim_number_of_events}  ;;
    filters: [voucher_event_name: "voucher_applied_failed"]
  }

  measure: failure_rate {
    type: number
    sql: (${number_of_failures}/${number_of_events})*100 ;;
    value_format: "0.0\%"
  }

  measure: success_rate {
    type: number
    sql: (${number_of_successes}/${number_of_events})*100 ;;
    value_format: "0.0\%"
  }
  set: detail {
    fields: [
      event_date,
      voucher_code,
      device_type,
      country_iso,
      city_name,
      hub_code,
      is_new_customer,
      voucher_event_name,
      voucher_attempted_error_message,
      number_of_events,
      number_of_successes,
      number_of_failures,
      failure_rate,
      success_rate
    ]
  }
}
