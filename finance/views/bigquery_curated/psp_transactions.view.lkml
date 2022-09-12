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
    hidden: yes
    sql:${TABLE}.psp_transaction_uuid ;;
    primary_key: yes
  }

  dimension: country_iso {
    group_label: "> Geographic Dimensions"
    type: string
    sql:${TABLE}.country_iso ;;
  }

  dimension_group: booking_date {
    type: time
    hidden: yes
    timeframes: [
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

  dimension_group: booking {
    group_label: "> Dates & Timestamps"
    alias: [booking_timestamp]
    type: time
    timeframes: [
      raw,
      date,
      week,
      month
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
    group_label: "> Transaction Properties"
    type: string
    sql: ${TABLE}.main_currency ;;
  }

  dimension: markup_sc {
    type: number
    hidden: yes
    sql: ${TABLE}.markup_sc ;;
  }

  dimension: merchant_account {
    group_label: "> Geographic Dimensions"
    type: string
    sql: ${TABLE}.merchant_account ;;
  }

  dimension: modification_merchant_reference {
    group_label: "> IDs and References"
    type: string
    sql: ${TABLE}.modification_merchant_reference ;;
  }

  dimension: order_uuid {
    group_label: "> IDs and References"
    type: string
    sql: ${TABLE}.order_uuid ;;
  }

  dimension: payable_sc {
    type: number
    hidden: yes
    sql: ${TABLE}.payable_sc ;;
  }

  dimension: payment_currency {
    group_label: "> Payment Methods"
    type: string
    sql: ${TABLE}.payment_currency ;;
  }

  dimension: payment_id {
    group_label: "> IDs and References"
    type: string
    sql: ${TABLE}.payment_id ;;
  }

  dimension: payment_method {
    group_label: "> Payment Methods"
    type: string
    sql: ${TABLE}.payment_method ;;
  }

  dimension: payment_method_grouped_product {
    group_label: "> Payment Methods"
    type: string
    sql:case when ${payment_method} like '%applepay' then 'ApplePay'
             when ${payment_method} like 'mc%' then 'MC'
             when ${payment_method} like 'directEbank%' THEN 'Sofort'
             when ${payment_method} like 'carteban%' THEN 'CarteBanCaire'
             when ${payment_method} like 'paypa%' THEN 'PayPal'
             when ${payment_method} like 'visa%' OR ${payment_method} like 'electro%' then 'Visa'
             when ${payment_method} like 'ideal%' then 'Ideal'
             when ${payment_method} like 'cup%' then 'Cup'
        else 'other'
        end ;;
  }

  dimension: payment_method_grouped_fraud {
    group_label: "> Payment Methods"
    type: string
    sql:case when ${payment_method} like 'amex%' then 'amex'
             when ${payment_method} like 'mc%' then 'mc'
             when ${payment_method} like 'visa%' OR ${payment_method} like 'electro%' then 'visa'
             when ${payment_method} like 'maestr%' then 'maestro'
             when ${payment_method} like 'ideal%' then 'ideal'
             when ${payment_method} like 'cup%' then 'cup'
             when ${payment_method} like 'jcb%' then 'jcb'
        else ${payment_method}
        end ;;
  }

  dimension: processing_fee_fc {
    type: number
    hidden: yes
    sql: ${TABLE}.processing_fee_fc ;;
  }

  dimension: psp_reference {
    group_label: "> IDs and References"
    type: string
    sql: ${TABLE}.psp_reference ;;
  }

  dimension: received_pc {
    type: number
    hidden: yes
    sql: ${TABLE}.received_pc ;;
  }

  dimension: record_type {
    group_label: "> Transaction Properties"
    label: "Transaction Type"
    description: "Record Type in Ayen. e.g. Authorised, Refunded, Chargeback"
    type: string
    sql: ${TABLE}.record_type ;;
  }

  dimension: scheme_fees_sc {
    type: number
    hidden: yes
    sql: ${TABLE}.scheme_fees_sc ;;
  }

  dimension: timezone {
    hidden: yes
    type: string
    sql: ${TABLE}.timezone ;;
  }

  dimension: user_name {
    group_label: "> Transaction Properties"
    type: string
    sql: ${TABLE}.user_name ;;
  }

##################    MEASURES  ###################

  measure: sum_main_amount {
    group_label: "> Amounts Captured"
    type: sum
    sql: ${main_amount} ;;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_main_amount_chargebacks {
    group_label: "> Amounts Captured"
    type: sum
    sql: ${main_amount} ;;
    value_format_name: euro_accounting_2_precision
    filters: [record_type: "Chargeback"]
  }

  measure: sum_main_amount_refunded {
    group_label: "> Amounts Captured"
    type: sum
    sql: ${main_amount} ;;
    value_format_name: euro_accounting_2_precision
    filters: [record_type: "Refunded, RefundedExternally"]
  }

  measure: sum_captured_pc_refunded {
    group_label: "> Amounts Captured"
    description: "Sum Main Amount for Refunded/RefundedExternally Record Type"
    type: sum
    sql: ${captured_pc} ;;
    value_format_name: euro_accounting_2_precision
    filters: [record_type: "Refunded, RefundedExternally"]
  }

  measure: sum_main_amount_settled {
    group_label: "> Amounts Captured"
    type: sum
    description: "Sum Main Amount for Settled Record Type"
    sql: ${main_amount} ;;
    value_format_name: euro_accounting_2_precision
    filters: [record_type: "Settled"]
  }

  measure: sum_main_amount_sent_for_settle {
    group_label: "> Amounts Captured"
    type: sum
    description: "Sum Main Amount for Sent for Settle Record Type"
    sql: ${main_amount} ;;
    value_format_name: euro_accounting_2_precision
    filters: [record_type: "SentForSettle"]
  }

  measure: sum_main_amount_sent_for_refund {
    group_label: "> Amounts Captured"
    type: sum
    description: "Sum Main Amount for Sent for Refund Record Type"
    sql: ${main_amount} ;;
    value_format_name: euro_accounting_2_precision
    filters: [record_type: "SentForRefund"]
  }

  measure: sum_main_amount_authorised {
    group_label: "> Amounts Captured"
    type: sum
    description: "Sum Main Amount for Authorised Record Type"
    sql: ${main_amount} ;;
    value_format_name: euro_accounting_2_precision
    filters: [record_type: "Authorised"]
  }

  measure: percentage_amount_refunded_settled {
    group_label: "> Refunds & Fraud Metrics"
    label: "%  Total Amount Refunded (Settled)"
    type: number
    sql: NULLIF(${sum_main_amount_refunded},0)/NULLIF(${sum_main_amount_settled},0);;
    value_format_name: percent_2
  }

  measure: percentage_amount_refunded_authorised {
    group_label: "> Refunds & Fraud Metrics"
    label: "%  Total Amount Refunded (Authorised)"
    type: number
    sql: NULLIF(${sum_main_amount_refunded},0)/NULLIF(${sum_main_amount_authorised},0);;
    value_format_name: percent_2
  }

  measure: percentage_amount_chargeback_settled {
    group_label: "> Refunds & Fraud Metrics"
    label: "%  Total Amount Refunded (Settled)"
    type: number
    sql: NULLIF(${sum_main_amount_chargebacks},0)/NULLIF(${sum_main_amount_settled},0);;
    value_format_name: percent_2
  }

  measure: percentage_amount_chargeback_authorised {
    group_label: "> Refunds & Fraud Metrics"
    label: "%  Total Amount Refunded (Authorised)"
    type: number
    sql: NULLIF(${sum_main_amount_chargebacks},0)/NULLIF(${sum_main_amount_authorised},0);;
    value_format_name: percent_2
  }

  measure: sum_authorised_pc {
    group_label: "> Amounts Captured"
    type: sum
    sql: ${authorised_pc} ;;
    value_format_name: euro_accounting_2_precision  }

  measure: sum_scheme_fees_sc {
    group_label: "> Fee Amounts"
    type: sum
    sql: ${scheme_fees_sc} ;;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_markup_sc {
    group_label: "> Fee Amounts"
    type: sum
    sql: ${markup_sc} ;;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_processing_fee_fc {
    group_label: "> Fee Amounts"
    type: sum
    sql: ${processing_fee_fc} ;;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_received_pc {
    group_label: "> Fee Amounts"
    type: sum
    sql: ${received_pc} ;;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_interchange_sc {
    group_label: "> Fee Amounts"
    type: sum
    sql: ${interchange_sc} ;;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_commission_sc {
    group_label: "> Fee Amounts"
    type: sum
    sql: ${commission_sc} ;;
    value_format_name: euro_accounting_2_precision
    }

  measure: sum_payable_sc {
    group_label: "> Amounts Captured"
    type: sum
    sql: ${payable_sc} ;;
    value_format_name: euro_accounting_2_precision
    }

  measure: sum_captured_pc {
    group_label: "> Amounts Captured"
    type: sum
    sql: ${captured_pc} ;;
    value_format_name: euro_accounting_2_precision
    }

  measure: sum_total_chargeback_fixed_fees {
    group_label: "> Fee Amounts"
    type: sum
    sql: ${markup_sc} + ${scheme_fees_sc};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_total_trx_fees {
    group_label: "> Fee Amounts"
    type: number
    sql: SUM(${commission_sc}) + SUM(${interchange_sc}) + SUM(${markup_sc}) + SUM(${processing_fee_fc}) + SUM(${scheme_fees_sc});;
    value_format_name: euro_accounting_2_precision
  }

  measure: total_trx_fees_percentage_of_gmv {
    group_label: "> Fee Amounts"
    type: number
    sql: NULLIF(${sum_total_trx_fees},0) / NULLIF(${orders.sum_gmv_gross},0);;
    value_format_name: percent_2
    description: "payments processing fees as % of GMV (gross)"
  }

  measure: diff_adyen_ct_filter {
    group_label: "PSP <> CT Comparison"
    type: sum
    hidden: yes
    sql:  (${orders.gmv_gross}-${orders.discount_amount}) - ${main_amount}  ;;
    value_format_name: euro_accounting_2_precision
    description: "CT <> Adyen Filter"
  }

  measure: diff_adyen_ct {
    group_label: "PSP <> CT Comparison"
    type: sum
    hidden: yes
    sql:  ${orders.gmv_gross} - ${main_amount}  ;;
    value_format_name: euro_accounting_2_precision
    description: "CT Orders GMV Gross - Adyen Main Amount"
  }

  measure: cnt_chargebacks_transactions {
    group_label: "> Transaction Totals"
    label: "# Chargebacks"
    type: count_distinct
    sql: ${psp_transaction_uuid} ;;
    filters: [record_type: "Chargeback"]
  }

  measure: cnt_received_transactions {
    group_label: "> Transaction Totals"
    label: "# Received"
    type: count_distinct
    sql: ${psp_transaction_uuid} ;;
    filters: [record_type: "Received"]
  }

  measure: cnt_refused_transactions {
    group_label: "> Transaction Totals"
    label: "# Refused"
    type: count_distinct
    sql: ${psp_transaction_uuid} ;;
    filters: [record_type: "Refused"]
  }

  measure: cnt_cancelled_transactions {
    group_label: "> Transaction Totals"
    label: "# Cancelled"
    type: count_distinct
    sql: ${psp_transaction_uuid} ;;
    filters: [record_type: "Cancelled"]
  }

  measure: cnt_error_transactions {
    group_label: "> Transaction Totals"
    label: "# Error"
    type: count_distinct
    sql: ${psp_transaction_uuid} ;;
    filters: [record_type: "Error"]
  }

  measure: payment_auth_rate {
    group_label: "> Payment Metrics"
    label: "Auth Rate"
    type: number
    sql: nullif(${cnt_authorised_transactions},0) / nullif(${cnt_received_transactions},0) ;;
    value_format_name: percent_2
  }

  measure: payment_settled_auth_rate {
    group_label: "> Payment Metrics"
    label: "Settled-Auth Rate"
    type: number
    sql: nullif(${cnt_settled_transactions},0) / nullif(${cnt_authorised_transactions},0) ;;
    value_format_name: percent_2
  }

  measure: payment_settled_rate {
    group_label: "> Payment Metrics"
    label: "Settled-Received Rate"
    type: number
    sql: nullif(${cnt_settled_transactions},0) / nullif(${cnt_received_transactions},0) ;;
    value_format_name: percent_2
  }

  measure: payment_failure_rate {
    group_label: "> Payment Metrics"
    label: "Failure Rate"
    type: number
    sql: nullif(${cnt_refused_transactions},0) / nullif(${cnt_received_transactions},0) ;;
    value_format_name: percent_2
  }

  measure: payment_cancelled_rate {
    group_label: "> Payment Metrics"
    label: "Cancelled Rate"
    type: number
    sql: nullif(${cnt_cancelled_transactions},0) / nullif(${cnt_received_transactions},0) ;;
    value_format_name: percent_2
  }

  measure: cnt_authorised_transactions {
    group_label: "> Transaction Totals"
    label: "# Authorised"
    type: count_distinct
    sql: ${psp_transaction_uuid} ;;
    filters: [record_type: "Authorised"]
  }

  measure: cnt_distinct_orders {
    group_label: "> Transaction Totals"
    label: "# Orders"
    type: count_distinct
    sql: ${order_uuid} ;;
  }

  measure: order_completion_rate {
    group_label: "> Payment Metrics"
    label: "Order Completion Rate"
    type: number
    sql: ${cnt_distinct_orders}/${cnt_authorised_transactions} ;;
    value_format_name: percent_2
  }

  measure: cnt_refund_transactions {
    group_label: "> Transaction Totals"
    label: "# Refunded"
    description: "# Transaction with Record Type = Refunded or RefundedExternally"
    type: count_distinct
    sql: ${psp_transaction_uuid} ;;
    filters: [record_type: "Refunded,RefundedExternally"]
  }

  measure: cnt_settled_transactions {
    group_label: "> Transaction Totals"
    label: "# Settled"
    type: count_distinct
    sql: ${psp_transaction_uuid} ;;
    filters: [record_type: "Settled"]
  }

  measure: sum_empty_order_uuid_settled {
    group_label: "> Orphaned Payments"
    label: "Total # Empty Orders Settled"
    type: sum
    sql: CASE WHEN ${order_uuid} IS NULL THEN 1 ELSE 0 END;;
    filters: [record_type: "Settled"]
  }

  measure: sum_empty_order_uuid_authorised {
    group_label: "> Orphaned Payments"
    label: "Total # Empty Orders Authorised"
    type: sum
    sql: CASE WHEN ${order_uuid} IS NULL THEN 1 ELSE 0 END;;
    filters: [record_type: "Authorised"]
  }

  measure: sum_empty_order_uuid_refunded {
    group_label: "> Transaction Totals"
    label: "Total # Empty Orders Refunded"
    type: sum
    sql: CASE WHEN ${order_uuid} IS NULL THEN 1 ELSE 0 END;;
    filters: [record_type: "Refunded, RefundedExternally"]
  }

  measure: sum_empty_order_uuid_chargeback {
    group_label: "> Orphaned Payments"
    label: "Total # Empty Orders Chargeback"
    type: sum
    sql: CASE WHEN ${order_uuid} IS NULL THEN 1 ELSE 0 END;;
    filters: [record_type: "Chargeback"]
  }

  measure: sum_empty_order_trx_fees_refunds {
    group_label: "> Orphaned Payments"
    label: "Total Costs Empty Orders - Refunds"
    type: sum
    sql: CASE WHEN ${payment_method} LIKE 'payp%' THEN ${processing_fee_fc}
    else (coalesce(${commission_sc},0) + coalesce(${processing_fee_fc},0)) end ;;
    filters: [record_type: "Refunded, SentForRefund"]
    value_format_name: eur
  }

  measure: sum_empty_order_amount_authorised {
    group_label: "> Orphaned Payments"
    label: "Total Amount Empty Orders Authorised"
    type: sum
    sql: case when ${order_uuid} IS NULL THEN ${main_amount} else 0 end;;
    filters: [record_type: "Authorised"]
    value_format_name: eur
  }

  measure: percentage_trx_without_orders_authorised {
    group_label: "> Orphaned Payments"
    label: "% Missing Orders Authorised"
    type: number
    sql: NULLIF(${sum_empty_order_uuid_authorised},0)/NULLIF(${cnt_authorised_transactions},0);;
    value_format_name: percent_3
  }

  measure: percentage_trx_without_orders_settled {
    group_label: "> Orphaned Payments"
    label: "% Missing Orders Settled"
    type: number
    sql: NULLIF(${sum_empty_order_uuid_settled},0)/NULLIF(${cnt_settled_transactions},0);;
    value_format_name: percent_3
  }

  measure: percentage_trx_without_orders_refunded {
    group_label: "> Orphaned Payments"
    label: "% Missing Orders Refunded"
    type: number
    sql: NULLIF(${sum_empty_order_uuid_refunded},0)/NULLIF(${cnt_refund_transactions},0);;
    value_format_name: percent_2
  }

  measure: percentage_trx_without_orders_chargeback {
    group_label: "> Orphaned Payments"
    label: "% Missing Orders Chargeback"
    type: number
    sql: NULLIF(${sum_empty_order_uuid_chargeback},0)/NULLIF(${cnt_chargebacks_transactions},0);;
    value_format_name: percent_2
  }

  measure: percentage_transactions_refunded_auth {
    group_label: "> Refunds & Fraud Metrics"
    label: "% Orders Refunded (Authorised)"
    type: number
    sql: NULLIF(${cnt_refund_transactions},0)/NULLIF(${cnt_authorised_transactions},0);;
    value_format_name: percent_2
  }

  measure: percentage_transactions_refunded_set {
    group_label: "> Refunds & Fraud Metrics"
    label: "% Orders Refunded (Settled)"
    type: number
    sql: NULLIF(${cnt_refund_transactions},0)/NULLIF(${cnt_settled_transactions},0);;
    value_format_name: percent_2
  }

  measure: percentage_transactions_chargeback_auth {
    group_label: "> Refunds & Fraud Metrics"
    label: "% Orders Chargeback (Authorised)"
    type: number
    sql: NULLIF(${cnt_chargebacks_transactions},0)/NULLIF(${cnt_authorised_transactions},0);;
    value_format_name: percent_2
  }

  measure: percentage_transactions_chargeback_set {
    group_label: "> Refunds & Fraud Metrics"
    label: "% Orders Chargeback (Settled)"
    type: number
    sql: NULLIF(${cnt_chargebacks_transactions},0)/NULLIF(${cnt_settled_transactions},0);;
    value_format_name: percent_2
  }

  measure: count {
    group_label: "> Transaction Totals"
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
    group_label: "> Refunds & Fraud Metrics"
    type: sum
    sql: ${authorised_authorised_pc} - ${captured_refunded_pc}  ;;
    value_format_name: euro_accounting_2_precision
  }

}
