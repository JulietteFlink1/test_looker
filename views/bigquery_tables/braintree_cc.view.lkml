view: braintree_cc {
  sql_table_name: `flink-backend.sandbox_justine.braintree_cc`
    ;;

  dimension: amount_authorized {
    type: number
    sql: ${TABLE}.amount_authorized ;;
  }

  dimension: amount_submitted_for_settlement {
    type: number
    sql: ${TABLE}.amount_submitted_for_settlement ;;
  }

  dimension: card_type {
    type: string
    sql: ${TABLE}.card_type ;;
  }

  dimension: cc_card_brand {
    type: string
    sql: ${TABLE}.cc_card_brand ;;
  }

  dimension: cc_interchange_amount {
    type: number
    sql: ${TABLE}.cc_interchange_amount ;;
  }

  dimension: cc_settlement_amount {
    type: number
    sql: ${TABLE}.cc_settlement_amount ;;
  }

  dimension_group: settlement {
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
    sql: ${TABLE}.settlement_date ;;
  }

  dimension: cc_total_fee_amount {
    type: number
    sql: ${TABLE}.cc_total_fee_amount ;;
  }

  dimension: cc_transaction_amount {
    type: number
    sql: ${TABLE}.cc_transaction_amount ;;
  }

  dimension_group: created_datetime {
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
    sql: ${TABLE}.created_datetime ;;
  }

  dimension: customer_email {
    type: string
    sql: ${TABLE}.customer_email ;;
  }

  dimension: payment_instrument_type {
    type: string
    sql: ${TABLE}.payment_instrument_type ;;
  }

  dimension: paypal_refund_from_transaction_fee_amount {
    type: number
    sql: ${TABLE}.paypal_refund_from_transaction_fee_amount ;;
  }

  dimension: paypal_transaction_fee_amount {
    type: number
    sql: ${TABLE}.paypal_transaction_fee_amount ;;
  }

  dimension: refunded_transaction_id {
    type: string
    sql: ${TABLE}.refunded_transaction_id ;;
  }

  dimension: transaction_id {
    type: string
    primary_key:  yes
    sql: ${TABLE}.transaction_id ;;
  }

  dimension: transaction_status {
    type: string
    sql: ${TABLE}.transaction_status ;;
  }

  dimension: transaction_type {
    type: string
    sql: ${TABLE}.transaction_type ;;
  }


  measure: sum_amount_authorized {
    group_label: "* Monetary Values *"
    label: "SUM Amount Authorized"
    description: "Sum of Amount Authorized"
    hidden:  no
    type: sum
    sql: ${amount_authorized};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_amount_submitted_for_settlement {
    group_label: "* Monetary Values *"
    label: "SUM Amount Submitted for Settlement"
    description: "Sum of Amount Submitted for Settlement"
    hidden:  no
    type: sum
    sql: ${amount_submitted_for_settlement};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_cc_transaction_amount {
    group_label: "* Monetary Values *"
    label: "SUM Transaction Amount"
    description: "Sum of Transaction Amount (Credit Card)"
    hidden:  no
    type: sum
    sql: ${cc_transaction_amount};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_cc_interchange_amount {
    group_label: "* Monetary Values *"
    label: "SUM Interchange Amount"
    description: "Sum of Interchange Amount (Credit Card)"
    hidden:  no
    type: sum
    sql: ${cc_interchange_amount};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_total_fee_amount {
    group_label: "* Monetary Values *"
    label: "SUM Total Fee Amount"
    description: "Sum of Total Fee Amount (Credit Card)"
    hidden:  no
    type: sum
    sql: ${cc_total_fee_amount};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_paypal_transaction_fee_amount {
    group_label: "* Monetary Values *"
    label: "SUM Paypal Transaction Fee Amount"
    description: "Sum of Paypal Transaction Fee Amount"
    hidden:  no
    type: sum
    sql: ${paypal_transaction_fee_amount};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_paypal_refund_from_transaction_fee_amount {
    group_label: "* Monetary Values *"
    label: "SUM Paypal Refund from Transaction Fee Amount"
    description: "Sum of Paypal Refund from Transaction Fee Amount"
    hidden:  no
    type: sum
    sql: ${paypal_refund_from_transaction_fee_amount};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_settlement_amount {
    group_label: "* Monetary Values *"
    label: "SUM Settlement Amount"
    description: "Sum of Settlement Amount (Credit Card)"
    hidden:  no
    type: sum
    sql: ${cc_settlement_amount};;
    value_format_name: euro_accounting_2_precision
  }

}
