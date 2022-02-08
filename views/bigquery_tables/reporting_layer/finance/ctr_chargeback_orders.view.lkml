view: ctr_chargeback_orders {
  sql_table_name: `flink-data-prod.reporting.ctr_chargeback_orders`
    ;;

  dimension: booking_month {
    type: string
    sql: ${TABLE}.booking_month ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: ctr_month_payment_method_uuid {
    type: string
    sql: ${TABLE}.ctr_month_payment_method_uuid ;;
  }

  dimension: merchant_account {
    type: string
    sql: ${TABLE}.merchant_account ;;
  }

  dimension: payment_method_grouped {
    type: string
    sql: ${TABLE}.payment_method_grouped ;;
    primary_key: yes
  }

  measure: percentage_amount_ctr_cbc {
    type: number
    sql: ${TABLE}.percentage_amount_ctr_cbc ;;
    value_format_name: percent_2
  }

  measure: percentage_amount_ctr_mc {
    type: number
    sql: ${TABLE}.percentage_amount_ctr_mc ;;
    value_format_name: percent_2
  }

  measure: percentage_amount_ctr_visa {
    type: number
    sql: ${TABLE}.percentage_amount_ctr_visa ;;
    value_format_name: percent_2
  }

  measure: percentage_trx_ctr_cbc {
    type: number
    sql: ${TABLE}.percentage_trx_ctr_cbc ;;
    value_format_name: percent_2
  }

  measure: percentage_trx_ctr_mc {
    type: number
    sql: ${TABLE}.percentage_trx_ctr_mc ;;
    value_format_name: percent_2
  }

  measure: percentage_trx_ctr_visa {
    type: number
    sql: ${TABLE}.percentage_trx_ctr_visa ;;
    value_format_name: percent_2
  }

  measure: total_chargebacks_transactions {
    type: number
    sql: ${TABLE}.total_chargebacks_transactions ;;
    value_format_name: decimal_0
  }

  measure: total_main_amount_chargeback {
    type: number
    sql: ${TABLE}.total_main_amount_chargeback ;;
    value_format_name: eur
  }

  measure: total_main_amount_settled {
    type: number
    sql: ${TABLE}.total_main_amount_settled ;;
    value_format_name: eur
  }

  measure: total_main_amount_authorised {
    type: number
    sql: ${TABLE}.total_main_amount_authorised ;;
    value_format_name: eur
  }

  measure: total_authorised_transactions {
    type: number
    sql: ${TABLE}.total_authorised_transactions ;;
    value_format_name: decimal_0
  }

  measure: total_settled_transactions {
    type: number
    sql: ${TABLE}.total_settled_transactions ;;
    value_format_name: decimal_0
  }

  measure: count {
    type: count
    drill_fields: [booking_month]
  }
}
