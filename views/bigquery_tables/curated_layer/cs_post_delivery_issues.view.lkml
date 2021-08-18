view: cs_post_delivery_issues {
  sql_table_name: `flink-data-prod.curated.cs_post_delivery_issues`
    ;;

  dimension: comment {
    type: string
    sql: ${TABLE}.comment ;;
  }

  dimension: conversation_id {
    type: string
    primary_key: yes
    sql: ${TABLE}.conversation_id ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: delivered_product {
    type: string
    sql: ${TABLE}.delivered_product ;;
  }

  dimension: hub {
    type: string
    sql: ${TABLE}.hub ;;
  }

  dimension: ticket_date {
    type: date
    datatype: date
    sql: date(${TABLE}.issue_date) ;;
  }

  dimension: order_nr_ {
    type: string
    sql: ${TABLE}.order_nr_ ;;
  }

  dimension: ordered_product {
    type: string
    sql: ${TABLE}.ordered_product ;;
  }

  dimension: post_delivery_issues_uuid {
    type: number
    value_format_name: id
    sql: ${TABLE}.post_delivery_issues_uuid ;;
  }

  dimension: problem_group {
    type: string
    sql: ${TABLE}.problem_group ;;
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

  measure: cnt_issues_damaged {
    label: "# Post Delivery Issues (Damaged)"
    type: count
    filters: [problem_group: "Damaged"]
  }

  measure: cnt_unique_orders {
    label: "# Unique Orders"
    description: "Count of Unique Orders which had a Contact"
    hidden:  no
    type: count_distinct
    sql: ${order_nr_};;
    value_format: "0"
  }

  measure: pct_contact_rate {
    label: "% Contact Rate"
    description: "# Post Delivery Issues divided by # Total Orders"
    hidden:  no
    type: number
    sql: ${cnt_issues} / NULLIF(${orders_cl.cnt_orders}, 0);;
    value_format: "0.0%"
  }


}
