view: events_monitoring {
  derived_table: {
    sql: SELECT event_date, os, os_version, app_version, event_name, COUNT(distinct anonymous_id) AS unique_users, COUNT(*) AS all_events
      FROM (
      SELECT id, anonymous_id, context_device_id AS device_id, context_os_name AS os, context_os_version AS os_version, context_app_version AS app_version, event AS event_name, DATE(timestamp) AS event_date, timestamp
      FROM `flink-backend.flink_ios_production.tracks` WHERE DATE(_PARTITIONTIME) = "2021-06-28"

      UNION ALL
      SELECT id, anonymous_id, context_device_id AS device_id, context_os_name AS os, context_os_version AS os_version, context_app_version AS app_version, event AS event_name, DATE(timestamp) AS event_date, timestamp
      FROM `flink-backend.flink_android_production.tracks` WHERE DATE(_PARTITIONTIME) = "2021-06-28"
      )
      GROUP BY 1,2,3,4,5
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: event_date {
    type: date
    datatype: date
    sql: ${TABLE}.event_date ;;
  }

  dimension: os {
    type: string
    sql: ${TABLE}.os ;;
  }

  dimension: os_version {
    type: string
    sql: ${TABLE}.os_version ;;
  }

  dimension: app_version {
    type: string
    sql: ${TABLE}.app_version ;;
  }

  dimension: event_name {
    type: string
    sql: ${TABLE}.event_name ;;
  }

  dimension: unique_users {
    type: number
    sql: ${TABLE}.unique_users ;;
  }

  dimension: all_events {
    type: number
    sql: ${TABLE}.all_events ;;
  }

  set: detail {
    fields: [
      event_date,
      os,
      os_version,
      app_version,
      event_name,
      unique_users,
      all_events
    ]
  }
}
