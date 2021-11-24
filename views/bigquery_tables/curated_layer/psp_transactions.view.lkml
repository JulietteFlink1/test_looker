view: psp_transactions {
  sql_table_name: `flink-data-dev.curated.psp_transactions`
    ;;

  dimension: authorised_pc {
    type: number
    sql: ${TABLE}.authorised_pc ;;
  }

  dimension: psp_transaction_uuid {
    type: string
    sql: concat(order_uuid,record_type,cast(booking_timestamp as string),merchant_account,payment_id) ;;
    primary_key: yes
  }

  dimension_group: booking {
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
    sql: ${TABLE}.booking_date ;;
  }

  dimension_group: booking_timestamp {
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
    sql: ${TABLE}.booking_timestamp ;;
  }

  dimension: captured_pc {
    type: number
    sql: ${TABLE}.captured_pc ;;
  }

  dimension: commission_sc {
    type: number
    sql: ${TABLE}.commission_sc ;;
  }

  dimension: interchange_sc {
    type: number
    sql: ${TABLE}.interchange_sc ;;
  }

  dimension: main_amount {
    type: number
    sql: ${TABLE}.main_amount ;;
  }

  dimension: main_currency {
    type: string
    sql: ${TABLE}.main_currency ;;
  }

  dimension: markup_sc {
    type: number
    sql: ${TABLE}.markup_sc ;;
  }

  dimension: merchant_account {
    type: string
    sql: ${TABLE}.merchant_account ;;
  }

  dimension: modification_merchant_reference {
    type: string
    sql: ${TABLE}.modification_merchant_reference ;;
  }

  dimension: order_uuid {
    type: string
    sql: ${TABLE}.order_uuid ;;
  }

  dimension: payable_sc {
    type: number
    sql: ${TABLE}.payable_sc ;;
  }

  dimension: payment_currency {
    type: string
    sql: ${TABLE}.payment_currency ;;
  }

  dimension: payment_id {
    type: string
    sql: ${TABLE}.payment_id ;;
  }

  dimension: payment_method {
    type: string
    sql: ${TABLE}.payment_method ;;
  }

  dimension: processing_fee_fc {
    type: number
    sql: ${TABLE}.processing_fee_fc ;;
  }

  dimension: psp_reference {
    type: string
    sql: ${TABLE}.psp_reference ;;
  }

  dimension: received_pc {
    type: number
    sql: ${TABLE}.received_pc ;;
  }

  dimension: record_type {
    type: string
    sql: ${TABLE}.record_type ;;
  }

  dimension: scheme_fees_sc {
    type: number
    sql: ${TABLE}.scheme_fees_sc ;;
  }

  dimension: timezone {
    type: string
    sql: ${TABLE}.timezone ;;
  }

  dimension: user_name {
    type: string
    sql: ${TABLE}.user_name ;;
  }

##################    MEASURES  ###################

  measure: sum_main_amount {
    type: sum
    sql: ${main_amount} ;;
    value_format: "0.00€"
  }

  measure: sum_authorised_pc {
    type: sum
    sql: ${authorised_pc} ;;
    value_format: "0.00€"
  }

  measure: sum_scheme_fees_sc {
    type: sum
    sql: ${scheme_fees_sc} ;;
    value_format: "0.00€"
  }

  measure: sum_processing_fee_fc {
    type: sum
    sql: ${processing_fee_fc} ;;
    value_format: "0.00€"
  }

  measure: sum_received_pc {
    type: sum
    sql: ${received_pc} ;;
    value_format: "0.00€"
  }

  measure: sum_interchange_sc {
    type: sum
    sql: ${interchange_sc} ;;
    value_format: "0.00€"
    hidden: no
  }

  measure: sum_commission_sc {
    type: sum
    sql: ${commission_sc} ;;
    value_format: "0.00€"
  }

  measure: sum_payable_sc {
    type: sum
    sql: ${payable_sc} ;;
    value_format: "0.00€"
  }

  measure: sum_captured_pc {
    type: sum
    sql: ${captured_pc} ;;
    value_format: "0.00€"
  }


  measure: count {
    type: count
    drill_fields: [user_name]
  }
}
