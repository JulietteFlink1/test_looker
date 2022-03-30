view: braintree_data_202203 {
  sql_table_name: `flink-data-dev.sandbox_justine.202203_braintree_data`
    ;;

  dimension: amt_authorised {
    type: number
    sql: ${TABLE}.amt_authorised ;;
  }

  dimension: amt_submitted_for_settlement {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_submitted_for_settlement ;;
  }

  dimension: billing_country {
    type: string
    label: "Country"
    sql: ${TABLE}.billing_country ;;
  }

  dimension_group: created_timestamp {
    label: "Created"
    type: time
    timeframes: [

      date,
      week,
      month,

    ]
    sql: ${TABLE}.created_timestamp ;;
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

  dimension_group: settlement {
    type: time
    timeframes: [
      date,
      week,
      month
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.settlement_date ;;
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

  measure: count {
    type: count
    drill_fields: []
  }

  measure: sum_amt_authorised {
    type: sum
    sql: ${amt_authorised} ;;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_amt_submitted_for_settlement {
    type: sum
    sql: ${amt_submitted_for_settlement} ;;
    value_format_name: euro_accounting_2_precision
  }
}
