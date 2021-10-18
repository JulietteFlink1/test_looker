view: app_session_events {
  sql_table_name: `flink-data-prod.curated.app_session_events`
    ;;

  view_label: "* App Events per Session *"
  drill_fields: [core_dimensions*]

  set: core_dimensions {
    fields: [
      event_name,
      device_type
    ]
  }

  ## IDs

  dimension: event_uuid {
    type: string
    sql: ${TABLE}.event_uuid ;;
    hidden: yes
  }
  dimension: session_id {
    type: string
    sql: ${TABLE}.session_id ;;
    hidden: yes
  }
  dimension: user_id  {
    type: string
    sql: ${TABLE}.user_id  ;;
    hidden: yes
  }
  dimension: anonymous_id {
    type: string
    sql: ${TABLE}.anonymous_id ;;
  }

  ## Device attributes

  dimension: device_type {
    type: string
    sql: ${TABLE}.device_type ;;
  }
  dimension: event_name {
    type: string
    sql: ${TABLE}.event_name ;;
  }
  # dimension: event_name_before {
  #   type: string
  #   sql: (LAG(${event_name}) OVER (PARTITION BY ${session_id} ORDER BY ${event_start_at_minute} ASC ));;

  # }
  # dimension: event_name_after {
  #   type: string
  #   sql: (LEAD(${event_name}) OVER (PARTITION BY ${session_id} ORDER BY ${event_start_at_minute} ASC ));;
  # }
  ## Dates / Timestamp

  dimension_group: event_start_at {
    type: time
    datatype: timestamp
    timeframes: [
      minute,
      hour,
      date,
      day_of_week,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.event_timestamp ;;
  }


## Measures

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: cnt_unique_anonymousid {
    label: "# Unique Users"
    description: "Number of Unique Users identified via Anonymous ID from Segment"
    hidden:  no
    type: count_distinct
    sql: ${anonymous_id};;
    value_format_name: decimal_0
  }

  measure: cnt_unique_userid {
    label: "# Unique Users"
    description: "Number of Unique Users identified via User ID from Segment"
    hidden:  yes
    type: count_distinct
    sql: ${user_id};;
    value_format_name: decimal_0
  }

  set: detail {
    fields: [
      event_uuid,
      session_id,
      user_id,
      anonymous_id,
      device_type,
      event_name,
      event_start_at_minute
    ]
  }
}
