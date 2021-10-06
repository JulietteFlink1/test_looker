view: tracking_events_analysis {
  derived_table: {
    persist_for: "24 hour"
    sql: SELECT * FROM `flink-data-dev.sandbox.zhou_event_sizes`
      ;;
  }

  ### Custom measures and dimensions

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
    sql: ${platform} || '-' || ${app_version} ;;
  }

  dimension: estimated_event_size_bytes_tier {
    type: tier
    style: integer
    tiers: [0,500,1000,1500,2000,2500,3000,3500,4000,4500,5000,5500,6000,6500,7000,7500,8000,8500,9000,9500,10000]
    sql: ${estimated_event_size_bytes} ;;
  }

  #################

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: tablename {
    type: string
    sql: ${TABLE}.tablename ;;
  }

  dimension: event_id {
    type: string
    sql: ${TABLE}.event_id ;;
  }

  dimension: platform {
    type: string
    sql: ${TABLE}.platform ;;
  }

  dimension: app_version {
    type: string
    sql: ${TABLE}.app_version ;;
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
    fields: [
      tablename,
      event_id,
      platform,
      app_version,
      event_timestamp_time,
      estimated_event_size_bytes
    ]
  }
}
