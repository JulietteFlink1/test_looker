view: payment_transactions {
  sql_table_name: `flink-data-prod.curated.payment_transactions`
    ;;

  dimension: backend_source {
    type: string
    sql: ${TABLE}.backend_source ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: interaction_id {
    type: string
    sql: ${TABLE}.interaction_id ;;
  }

  dimension: order_uuid {
    hidden: yes
    primary_key: yes
    type: string
    sql: ${TABLE}.order_uuid ;;
  }

  dimension: payment_id {
    type: string
    sql: ${TABLE}.payment_id ;;
  }

  dimension: psp_reference {
    type: string
    hidden: yes
    sql: ${TABLE}.psp_reference ;;
  }

  dimension: timezone {
    type: string
    sql: ${TABLE}.timezone ;;
  }

  dimension: transaction_amount {
    type: number
    sql: ${TABLE}.transaction_amount ;;
  }

  dimension: transaction_id {
    type: string
    sql: ${TABLE}.transaction_id ;;
  }

  dimension: transaction_interface {
    type: string
    sql: ${TABLE}.transaction_interface ;;
  }

  dimension: transaction_method {
    type: string
    sql: ${TABLE}.transaction_method ;;
  }

  dimension: transaction_payment_company {
    type: string
    sql: ${TABLE}.transaction_payment_company ;;
  }

  dimension: transaction_payment_type {
    type: string
    sql: ${TABLE}.transaction_payment_type ;;
  }

  dimension: transaction_state {
    type: string
    sql: ${TABLE}.transaction_state ;;
  }

  dimension_group: transaction_timestamp {
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
    sql: ${TABLE}.transaction_timestamp ;;
  }

  dimension: transaction_type {
    type: string
    sql: ${TABLE}.transaction_type ;;
  }

  dimension: transaction_uuid {
    type: string
    sql: ${TABLE}.transaction_uuid ;;
  }

  measure: sum_transaction_amount {
    type: sum
    sql: ${transaction_amount} ;;
    value_format: "0.00€"
  }

  # dimension: diff_transaction_amount {
  #   description: "Transaction Amount - Order Gross Revenue"
  #   label: "Payment Difference (Adyen vs CT)"
  #   type: number
  #   sql: ${orders_cl.total_gross_amount} - ${transaction_amount} ;;
  #   value_format: "0.00€"
  # }

  measure: count {
    type: count
    drill_fields: []
  }
}
