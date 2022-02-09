view: ctr_chargeback_orders {
  sql_table_name: `flink-data-dev.reporting.ctr_chargeback_orders`
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

  measure: total_chargebacks_transactions {
    type: sum
    sql: ${TABLE}.total_chargebacks_transactions ;;
    value_format_name: decimal_0
  }

  measure: total_main_amount_chargeback {
    type: sum
    sql: ${TABLE}.total_main_amount_chargeback ;;
    value_format_name: eur
  }

  measure: total_main_amount_settled {
    type: sum
    sql: ${TABLE}.total_main_amount_settled ;;
    value_format_name:  eur
  }

  measure: total_settled_transactions {
    type: sum
    sql: ${TABLE}.total_settled_transactions ;;
    value_format_name: decimal_0
  }

  measure: total_main_amount_authorised {
    type: sum
    sql: ${TABLE}.total_main_amount_authorised ;;
    value_format_name: eur
  }

  measure: total_authorised_transactions {
    type: sum
    sql: ${TABLE}.total_authorised_transactions ;;
    value_format_name: decimal_0
  }

  measure: total_main_amount_chargeback_previous_month {
    type: sum
    sql: ${TABLE}.total_main_amount_chargeback_previous_month ;;
    value_format_name: eur
  }

  measure: total_main_amount_settled_previous_month {
    type: sum
    sql: ${TABLE}.total_main_amount_settled_previous_month ;;
    value_format_name: eur
  }

  measure: total_chargebacks_transactions_previous_month {
    type: sum
    sql: ${TABLE}.total_chargebacks_transactions_previous_month ;;
    value_format_name: decimal_0
  }

  measure: total_settled_transactions_previous_month {
    type: sum
    sql: ${TABLE}.total_settled_transactions_previous_month ;;
    value_format_name: decimal_0
  }

  measure: total_main_amount_chargeback_previous2_month {
    type: sum
    sql: ${TABLE}.total_main_amount_chargeback_previous2_month ;;
    value_format_name: eur
  }

  measure: total_main_amount_authorised_previous2_month {
    type: sum
    sql: ${TABLE}.total_main_amount_authorised_previous2_month ;;
    value_format_name: eur
  }

  measure: total_chargebacks_transactions_previous2_month {
    type: sum
    sql: ${TABLE}.total_chargebacks_transactions_previous2_month ;;
    value_format_name: decimal_0
  }

  measure: total_authorised_transactions_previous2_month {
    type: sum
    sql: ${TABLE}.total_authorised_transactions_previous2_month ;;
    value_format_name: decimal_0
  }

  measure: percentage_ctr_mc_trx {
    type: number
    sql: ${total_chargebacks_transactions_previous_month} / ${total_settled_transactions_previous_month} ;;
    value_format_name: percent_2
  }

  measure: percentage_ctr_visa_trx {
    type: number
    sql: ${total_chargebacks_transactions} / ${total_settled_transactions} ;;
    value_format_name: percent_2
  }

  measure: percentage_ctr_cbc_trx {
    type: number
    sql: ${total_chargebacks_transactions_previous2_month} / ${total_authorised_transactions_previous2_month} ;;
    value_format_name: percent_2
  }

  measure: percentage_ctr_mc_amount {
    type: number
    sql: ${total_main_amount_chargeback_previous_month} / ${total_main_amount_settled_previous_month} ;;
    value_format_name: percent_2
  }

  measure: percentage_ctr_visa_amount {
    type: number
    sql: ${total_main_amount_chargeback} / ${total_main_amount_settled} ;;
    value_format_name: percent_2
  }

  measure: percentage_ctr_cbc_amount {
    type: number
    sql: ${total_main_amount_chargeback_previous2_month} / ${total_main_amount_authorised_previous2_month} ;;
    value_format_name: percent_2
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
