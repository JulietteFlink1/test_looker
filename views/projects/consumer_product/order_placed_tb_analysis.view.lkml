view: order_placed_tb_analysis {
  derived_table: {
    sql: SELECT
          "order_placed" AS tb_name
          , id AS event_id
          , context_device_type AS platform
          , context_app_version
          , timestamp AS event_timestamp
          , BYTE_LENGTH(TO_JSON_STRING(t)) AS estimated_event_size_bytes
          FROM `flink-data-prod.flink_android_production.order_placed_view` t

          UNION ALL

          SELECT
          "order_placed" AS tb_name
          , id AS event_id
          , context_device_type AS platform
          , context_app_version
          , timestamp AS event_timestamp
          , BYTE_LENGTH(TO_JSON_STRING(t)) AS estimated_event_size_bytes
          FROM `flink-data-prod.flink_ios_production.order_placed_view` t
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: size_q1 {
    type: percentile
    percentile: 25
    sql: ${estimated_event_size_bytes};;
  }

  measure: size_q2 {
    type: percentile
    percentile: 50
    sql: ${estimated_event_size_bytes};;
  }

  measure: size_q3 {
    type: percentile
    percentile: 75
    sql: ${estimated_event_size_bytes};;
  }

  measure: size_min {
    type: min
    sql: ${estimated_event_size_bytes} ;;
  }

  measure: size_max {
    type: max
    sql: ${estimated_event_size_bytes} ;;
  }

  dimension: full_app_version {
    type: string
    sql: ${platform} || '-' || ${context_app_version} ;;
  }

  dimension: estimated_event_size_bytes_tier {
    type: tier
    style: integer
    tiers: [0,500,1000,1500,2000,2500,3000,3500,4000,4500,5000,5500,6000,6500,7000,7500,8000,8500,9000,9500,10000]
    sql: ${estimated_event_size_bytes} ;;
  }
#############
  dimension: tb_name {
    type: string
    sql: ${TABLE}.tb_name ;;
  }

  dimension: platform {
    type: string
    sql: ${TABLE}.platform ;;
  }

  dimension: event_id {
    type: string
    sql: ${TABLE}.event_id ;;
  }

  dimension: context_app_version {
    type: string
    hidden: yes
    sql: ${TABLE}.context_app_version ;;
  }

  dimension_group: event_timestamp {
    type: time
    sql: ${TABLE}.event_timestamp ;;
  }

  dimension: estimated_event_size_bytes {
    type: number
    sql: ${TABLE}.estimated_event_size_bytes ;;
  }

  set: detail {
    fields: [tb_name, event_timestamp_time, estimated_event_size_bytes]
  }
}
