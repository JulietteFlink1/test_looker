view: braintree_bq {
  sql_table_name: `flink-data-dev.sandbox_justine.braintree_bq`
    ;;

  dimension: adyen_id {
    type: string
    sql: ${TABLE}.Adyen_ID ;;
  }

  dimension: adyen_revenue {
    type: string
    sql: ${TABLE}.Adyen_revenue ;;
  }

  dimension: adyen_status {
    type: string
    sql: ${TABLE}.Adyen_Status ;;
  }

  dimension: adyen_vs_bq {
    type: string
    sql: ${TABLE}.Adyen_vs_BQ ;;
  }

  dimension: bq_revenue {
    type: number
    sql: ${TABLE}.BQ_revenue ;;
  }

  dimension: braintree_id {
    type: string
    sql: ${TABLE}.braintree_ID ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: customer_email {
    type: string
    sql: ${TABLE}.customer_email ;;
  }

  dimension: date {
    type: string
    group_label: "Date"
    sql: ${TABLE}.Date ;;
  }

  dimension: difference_bq_adyen {
    type: string
    sql: ${TABLE}.Difference_BQ_Adyen ;;
  }

  dimension: month {
    group_label: "Date"
    type: number
    sql: ${TABLE}.Month ;;
  }

  dimension: order_uuid {
    type: string
    primary_key:  yes
    sql: ${TABLE}.order_uuid ;;
  }

  dimension: revenue_type_ {
    type: string
    sql: ${TABLE}.Revenue_type_ ;;
  }

  dimension: source {
    type: string
    sql: ${TABLE}.Source ;;
  }

  dimension: time {
    group_label: "Date"
    type: string
    sql: ${TABLE}.Time ;;
  }

  dimension: transaction_status {
    type: string
    sql: ${TABLE}.Transaction_status ;;
  }

  dimension: transaction_type {
    type: string
    sql: ${TABLE}.Transaction_type ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }

  measure: sum_bq_revenue {
    type: sum
    sql: ${bq_revenue};;
    value_format_name: euro_accounting_2_precision
  }


}
