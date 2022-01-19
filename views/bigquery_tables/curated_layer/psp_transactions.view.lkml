view: psp_transactions {
  sql_table_name: `flink-data-prod.curated.psp_transactions`
    ;;

  dimension: authorised_pc {
    type: number
    hidden: yes
    sql: ${TABLE}.authorised_pc ;;
  }

  dimension: psp_transaction_uuid {
    type: string
    sql:${TABLE}.psp_transaction_uuid ;;
    primary_key: yes
  }

  dimension: country_iso {
    type: string
    sql:${TABLE}.country_iso ;;
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
    hidden:  yes
    sql: ${TABLE}.captured_pc ;;
  }

  dimension: commission_sc {
    type: number
    hidden: yes
    sql: ${TABLE}.commission_sc ;;
  }

  dimension: interchange_sc {
    type: number
    hidden: yes
    sql: ${TABLE}.interchange_sc ;;
  }

  dimension: main_amount {
    type: number
    hidden: yes
    sql: ${TABLE}.main_amount ;;
  }

  dimension: main_currency {
    type: string
    sql: ${TABLE}.main_currency ;;
  }

  dimension: markup_sc {
    type: number
    hidden: yes
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
    hidden: yes
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

  dimension: payment_method_grouped {
    type: string
    sql:case when ${payment_method} like 'mc%' then 'mc'
             when ${payment_method} like 'visa%' then 'visa'
             when ${payment_method} like 'ideal%' then 'ideal'
        else ${payment_method}
        end ;;
  }

  dimension: processing_fee_fc {
    type: number
    hidden: yes
    sql: ${TABLE}.processing_fee_fc ;;
  }

  dimension: psp_reference {
    type: string
    sql: ${TABLE}.psp_reference ;;
  }

  dimension: received_pc {
    type: number
    hidden: yes
    sql: ${TABLE}.received_pc ;;
  }

  dimension: record_type {
    type: string
    sql: ${TABLE}.record_type ;;
  }

  dimension: scheme_fees_sc {
    type: number
    hidden: yes
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
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_main_amount_chargebacks {
    type: sum
    sql: ${main_amount} ;;
    value_format_name: euro_accounting_2_precision
    filters: [record_type: "Chargeback"]
  }

  measure: sum_main_amount_settled {
    type: sum
    sql: ${main_amount} ;;
    value_format_name: euro_accounting_2_precision
    filters: [record_type: "Settled"]
  }

  measure: sum_main_amount_authorised {
    type: sum
    sql: ${main_amount} ;;
    value_format_name: euro_accounting_2_precision
    filters: [record_type: "Authorised"]
  }

  measure: sum_authorised_pc {
    type: sum
    sql: ${authorised_pc} ;;
    value_format_name: euro_accounting_2_precision  }

  measure: sum_scheme_fees_sc {
    type: sum
    sql: ${scheme_fees_sc} ;;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_markup_sc {
    type: sum
    sql: ${markup_sc} ;;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_processing_fee_fc {
    type: sum
    sql: ${processing_fee_fc} ;;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_received_pc {
    type: sum
    sql: ${received_pc} ;;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_interchange_sc {
    type: sum
    sql: ${interchange_sc} ;;
    value_format_name: euro_accounting_2_precision    hidden: no
  }

  measure: sum_commission_sc {
    type: sum
    sql: ${commission_sc} ;;
    value_format_name: euro_accounting_2_precision
    }

  measure: sum_payable_sc {
    type: sum
    sql: ${payable_sc} ;;
    value_format_name: euro_accounting_2_precision
    }

  measure: sum_captured_pc {
    type: sum
    sql: ${captured_pc} ;;
    value_format_name: euro_accounting_2_precision
    }

  dimension: diff_adyen_ct {
    type: number
    sql:  ${orders.total_gross_amount} - ${main_amount}  ;;
    value_format_name: euro_accounting_2_precision
    description: "CT Orders Revenue Gross - Adyen Main Amount"
  }

  measure: cnt_chargebacks_transactions {
    label: "# Chargebacks"
    type: count_distinct
    sql: ${psp_transaction_uuid} ;;
    filters: [record_type: "Chargeback"]
  }

  measure: cnt_cancelled_transactions {
    label: "# Cancelled"
    type: count_distinct
    sql: ${psp_transaction_uuid} ;;
    filters: [record_type: "Cancelled"]
  }

  measure: cnt_refused_transactions {
    label: "# Refused"
    type: count_distinct
    sql: ${psp_transaction_uuid} ;;
    filters: [record_type: "Refused"]
  }

  measure: cnt_authorised_transactions {
    label: "# Authorised"
    type: count_distinct
    sql: ${psp_transaction_uuid} ;;
    filters: [record_type: "Authorised"]
  }

  measure: cnt_refund_transactions {
    label: "# Refunded"
    description: "# Transaction with Record Type = Refunded or RefundedExternally"
    type: count_distinct
    sql: ${psp_transaction_uuid} ;;
    filters: [record_type: "Refunded,RefundedExternally"]
  }

  measure: cnt_settled_transactions {
    label: "# Settled"
    type: count_distinct
    sql: ${psp_transaction_uuid} ;;
    filters: [record_type: "Settled"]
  }

  measure: sum_empty_order_uuid_authorised {
    label: "Sum Empty Orders"
    type: sum
    sql: CASE WHEN ${order_uuid} IS NULL THEN 1 ELSE 0 END;;
    filters: [record_type: "Authorised"]
  }

  measure: sum_empty_order_uuid_refunded {
    label: "Sum Empty Orders Refunded"
    type: sum
    sql: CASE WHEN ${order_uuid} IS NULL THEN 1 ELSE 0 END;;
    filters: [record_type: "Refunded, RefundedExternally"]
  }

  measure: sum_empty_order_uuid_chargeback {
    label: "Sum Empty Orders Chargeback"
    type: sum
    sql: CASE WHEN ${order_uuid} IS NULL THEN 1 ELSE 0 END;;
    filters: [record_type: "Chargeback"]
  }

  measure: percentage_trx_without_orders_authorised {
    label: "% Missing Orders Authorised"
    type: number
    sql: ${sum_empty_order_uuid_authorised}/${cnt_authorised_transactions};;
    value_format_name: percent_3
  }

  measure: percentage_trx_without_orders_refunded {
    label: "% Missing Orders Refunded"
    type: number
    sql: ${sum_empty_order_uuid_refunded}/${cnt_refund_transactions};;
    value_format_name: percent_3
  }

  measure: percentage_trx_without_orders_chargeback {
    label: "% Missing Orders Chargeback"
    type: number
    sql: ${sum_empty_order_uuid_chargeback}/${cnt_chargebacks_transactions};;
    value_format_name: percent_2
  }

  measure: percentage_transactions_refunded {
    label: "% Orders Refunded"
    type: number
    sql: ${cnt_refund_transactions}/${cnt_authorised_transactions};;
    value_format_name: percent_2
  }

  measure: percentage_transactions_chargeback {
    label: "% Orders Chargeback"
    type: number
    sql: ${cnt_chargebacks_transactions}/${cnt_authorised_transactions};;
    value_format_name: percent_2
  }

  measure: count {
    type: count
    drill_fields: [user_name]
  }

  dimension: captured_refunded_pc {
    label: "Refunded Transactions Amount"
    hidden: yes
    sql: case when record_type in ("Refunded","RefundedExternally") then ${captured_pc} end ;;
    value_format_name: euro_accounting_2_precision
  }


  dimension: authorised_authorised_pc {
    label:  "Authorised Transactions Amount"
    hidden: yes
    sql: case when record_type in ("Authorised") then ${authorised_pc} end ;;
    value_format_name: euro_accounting_2_precision
  }



 measure: diff_authorised_refunded {
 type: sum
  sql: ${authorised_authorised_pc} - ${captured_refunded_pc}  ;;
}

}
