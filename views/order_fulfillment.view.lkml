view: order_fulfillment {
  sql_table_name: `flink-backend.saleor_db.order_fulfillment`
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  # dimension_group: _sdc_batched {
  #   type: time
  #   timeframes: [
  #     raw,
  #     time,
  #     date,
  #     week,
  #     month,
  #     quarter,
  #     year
  #   ]
  #   sql: ${TABLE}._sdc_batched_at ;;
  # }

  # dimension_group: _sdc_extracted {
  #   type: time
  #   timeframes: [
  #     raw,
  #     time,
  #     date,
  #     week,
  #     month,
  #     quarter,
  #     year
  #   ]
  #   sql: ${TABLE}._sdc_extracted_at ;;
  # }

  # dimension_group: _sdc_received {
  #   type: time
  #   timeframes: [
  #     raw,
  #     time,
  #     date,
  #     week,
  #     month,
  #     quarter,
  #     year
  #   ]
  #   sql: ${TABLE}._sdc_received_at ;;
  # }

  # dimension: _sdc_sequence {
  #   type: number
  #   sql: ${TABLE}._sdc_sequence ;;
  # }

  # dimension: _sdc_table_version {
  #   type: number
  #   sql: ${TABLE}._sdc_table_version ;;
  # }

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
    sql: ${TABLE}.private_metadata ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: tracking_number {
    type: string
    sql: ${TABLE}.tracking_number ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }
}
