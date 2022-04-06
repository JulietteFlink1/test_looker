view: braintree_data_202203 {
  sql_table_name: `flink-data-dev.sandbox_justine.braintree_clean`
    ;;

  dimension: amt_authorised {
    type: number
    hidden: yes
    sql: ${TABLE}.Amount_Authorized  ;;
  }

  dimension: amt_submitted_for_settlement {
    hidden: yes
    type: number
    sql: ${TABLE}.Amount_Submitted_For_Settlement ;;
  }

  dimension: billing_country {
    type: string
    label: "Country"
    sql: ${TABLE}.Braintree_Billing_Country ;;
  }

  dimension: customer_email {
    type: string
    sql: ${TABLE}.customer_email ;;
  }

  dimension: merchant_account {
    type: string
    sql: ${TABLE}.merchant_account ;;
  }

  dimension: sale_id {
    type: string
    sql: ${TABLE}.sale_id ;;
  }

  dimension: transaction_id {
    type: string
    primary_key: yes
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

  dimension: date {
    type: date
    sql: ${TABLE}.date ;;
  }

  dimension: time {
    type: string
    sql: ${TABLE}.time ;;
  }

  dimension: month {
    type: number
    sql: ${TABLE}.month ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }

  measure: sum_amt_authorised {
    type: sum
    label: "Amt Authorised"
    sql: ${amt_authorised} ;;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_amt_submitted_for_settlement {
    type: sum
    label: "Amt Submitted for Settlement"
    sql: ${amt_submitted_for_settlement} ;;
    value_format_name: euro_accounting_2_precision
  }
}
