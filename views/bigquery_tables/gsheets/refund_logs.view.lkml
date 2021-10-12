view: refund_logs {
  sql_table_name: `flink-data-prod.google_sheets.refund_logs`
    ;;

  dimension: country_code {
    type: string
    sql: ${TABLE}.country_code ;;
  }

  dimension_group: created {
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
    sql: ${TABLE}.created_at ;;
  }

  dimension: currency {
    type: string
    sql: ${TABLE}.currency ;;
  }

  dimension: merchant_account {
    type: string
    sql: ${TABLE}.merchant_account ;;
  }

  dimension: modification {
    type: string
    sql: ${TABLE}.modification ;;
  }

  dimension: order_number {
    type: string
    sql: ${TABLE}.order_number ;;
    primary_key: yes
  }

  dimension: psp_reference {
    type: number
    sql: ${TABLE}.psp_reference ;;
  }

  dimension: reference {
    type: string
    sql: ${TABLE}.reference ;;
  }

  dimension: amount {
    type: number
    sql: ${TABLE}.amount ;;
    value_format_name: eur
  }

  measure: sum_amount {
    label: "SUM Refund Value (from Picker Refund Logs)"
    type: sum
    sql: ${amount} ;;
    value_format_name: eur

  }

  measure: cnt_refunds {
    label: "# Refunds (from Picker Refund Logs)"
    type: count_distinct
    sql: ${order_number} ;;
    drill_fields: []
  }
}
