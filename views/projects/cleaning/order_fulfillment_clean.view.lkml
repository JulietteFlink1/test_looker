view: order_fulfillment_clean {
  sql_table_name: `flink-backend.saleor_db_global.order_fulfillment`
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: no
    hidden: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: country_iso {
    type: string
    hidden: yes
    sql: ${TABLE}.country_iso ;;
  }

  dimension: unique_id {
    primary_key: yes
    hidden: yes
    type: string
    sql: concat(${country_iso}, ${id}) ;;
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
    sql: ${TABLE}.created ;;
  }

  dimension: fulfillment_order {
    type: number
    sql: ${TABLE}.fulfillment_order ;;
  }

  dimension: metadata {
    type: string
    sql: ${TABLE}.metadata ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension: private_metadata {
    type: string
    hidden: yes
    sql: ${TABLE}.private_metadata ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: tracking_number {
    type: string
    hidden: yes
    sql: ${TABLE}.tracking_number ;;
  }

  ############## Cross Referenced Dimensions

  dimension: reaction_time {
    group_label: "* Operations / Logistics *"
    type: number
    hidden: yes
    sql: TIMESTAMP_DIFF(${created_raw},${base_orders.created_raw}, SECOND) / 60 ;;
  }

  dimension: acceptance_time {
    group_label: "* Operations / Logistics *"
    type: number
    hidden: yes
    sql: TIMESTAMP_DIFF(TIMESTAMP(JSON_EXTRACT_SCALAR(${base_orders.metadata}, '$.trackingTimestamp')),${created_raw}, SECOND) / 60 ;;
  }

  dimension: is_acceptance_less_than_0_minute {
    hidden: yes
    group_label: "* Operations / Logistics *"
    type: yesno
    sql: ${acceptance_time} < 0 ;;
  }

  dimension: is_acceptance_more_than_30_minute {
    hidden: yes
    group_label: "* Operations / Logistics *"
    type: yesno
    sql: ${acceptance_time} > 30 ;;
  }

  dimension: is_reaction_less_than_0_minute {
    hidden: yes
    group_label: "* Operations / Logistics *"
    type: yesno
    sql: ${reaction_time} < 0 ;;
  }

  dimension: is_reaction_more_than_30_minute {
    hidden: yes
    group_label: "* Operations / Logistics *"
    type: yesno
    sql: ${reaction_time} > 30 ;;
  }


  measure: number_of_fulfillments {
    type: count
    drill_fields: [id]
  }
}
