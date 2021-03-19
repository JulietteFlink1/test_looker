view: cs_issues_post_delivery {
  sql_table_name: `flink-backend.gsheet_cs_issues.CS_issues_post_delivery`
    ;;

  dimension: __sdc_row {
    type: number
    sql: ${TABLE}.__sdc_row ;;
  }

  dimension: __sdc_sheet_id {
    type: number
    sql: ${TABLE}.__sdc_sheet_id ;;
  }

  dimension: __sdc_spreadsheet_id {
    type: string
    sql: ${TABLE}.__sdc_spreadsheet_id ;;
  }

  dimension: compound_primary_key {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT( ${TABLE}.conversation_id, ' ', ${TABLE}.order_nr__, ' ', ${TABLE}.date ) ;;
  }

  dimension_group: _sdc_batched {
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
    sql: ${TABLE}._sdc_batched_at ;;
  }

  dimension_group: _sdc_extracted {
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
    sql: ${TABLE}._sdc_extracted_at ;;
  }

  dimension_group: _sdc_received {
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
    sql: ${TABLE}._sdc_received_at ;;
  }

  dimension: _sdc_sequence {
    type: number
    sql: ${TABLE}._sdc_sequence ;;
  }

  dimension: _sdc_table_version {
    type: number
    sql: ${TABLE}._sdc_table_version ;;
  }

  dimension: comment {
    type: string
    sql: ${TABLE}.comment ;;
  }

  dimension: conversation_id {
    type: string
    sql: ${TABLE}.conversation_id ;;
  }

  dimension: cw {
    type: number
    sql: ${TABLE}.cw ;;
  }

  dimension: date {
    type: string
    sql: ${TABLE}.date ;;
  }

  dimension: ticket_date {
    type: date
    datatype: date
    sql: date(${TABLE}.date) ;;
  }

  dimension: delivered_product {
    type: string
    sql: ${TABLE}.delivered_product ;;
  }

  dimension: hub {
    type: string
    sql: ${TABLE}.hub ;;
  }

  dimension: order_nr__ {
    type: number
    sql: ${TABLE}.order_nr__ ;;
  }

  dimension: ordered_product {
    type: string
    sql: ${TABLE}.ordered_product ;;
  }

  dimension: problem_group {
    type: string
    sql: ${TABLE}.problem_group ;;
  }

  dimension: solution {
    type: string
    sql: ${TABLE}.solution ;;
  }

  measure: cnt_issues {
    label: "# Post Delivery Issues"
    type: count
    drill_fields: []
  }

  measure: cnt_issues_wrong_product {
    label: "# Post Delivery Issues (Wrong Product)"
    type: count
    filters: [problem_group: "Wrong Product"]
  }

  measure: cnt_issues_missing_product {
    label: "# Post Delivery Issues (Missing Product)"
    type: count
    filters: [problem_group: "Missing Product"]
  }

  measure: cnt_issues_perished_product {
    label: "# Post Delivery Issues (Perished Product)"
    type: count
    filters: [problem_group: "Perished Product"]
  }

  measure: cnt_issues_wrong_order {
    label: "# Post Delivery Issues (Wrong Order)"
    type: count
    filters: [problem_group: "Wrong Order"]
  }


  measure: cnt_unique_orders {
    label: "# Unique Orders"
    description: "Count of Unique Orders which had a Contact"
    hidden:  no
    type: count_distinct
    sql: ${order_nr__};;
    value_format: "0"
  }

  measure: pct_contact_rate {
    label: "% Contact Rate"
    description: "# Post Delivery Issues divided by # Total Orders"
    hidden:  no
    type: number
    sql: ${cnt_issues} / NULLIF(${order_order.cnt_orders}, 0);;
    value_format: "0.0%"
  }

}
