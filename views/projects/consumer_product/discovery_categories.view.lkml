view: discovery_categories {
  derived_table: {
    sql: WITH
    events AS(
    SELECT  e.event_uuid
          , e.session_id
          , e.anonymous_id
          , e.event_name
          , e.device_type
          , e.event_timestamp
          , COALESCE(ca.category_name, ci.category_name)                                                     as category_name
          , ca.sub_category_name                                                                             as sub_category_name
          , ca.origin_screen                                                                                 as origin_screen
          , LAG(e.event_name) OVER (PARTITION BY e.session_id ORDER BY e.event_timestamp ASC)                as event_name_before
          , LEAD(e.event_name) OVER (PARTITION BY e.session_id ORDER BY e.event_timestamp ASC)               as event_name_after
          , first_value (e.event_timestamp ) over (partition by session_id order by e.event_timestamp asc
                 ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)                                   as first_timestamp
          , last_value (e.event_timestamp ) over (partition by session_id order by e.event_timestamp asc
                 ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)                                   as last_timestamp

FROM `flink-data-prod.curated.app_session_events` e
LEFT JOIN `flink-data-prod.flink_android_production.category_selected` ca ON ca.id = e.event_uuid
LEFT JOIN `flink-data-prod.flink_ios_production.category_selected` ci ON ci.id = e.event_uuid
)
SELECT *
       , TIMESTAMP_DIFF(first_timestamp, last_timestamp, MILLISECOND) AS time_difference
       , TIMESTAMP_DIFF(first_timestamp, last_timestamp, SECOND) AS time_difference_seconds
       , TIMESTAMP_DIFF(first_timestamp, last_timestamp, MINUTE) AS time_difference_minutes
FROM events
  ;;
  }

    dimension: event_uuid {
      type: string
      sql: ${TABLE}.event_uuid ;;
    }
    dimension: session_id {
      type: string
      sql: ${TABLE}.session_id ;;
    }
    dimension: anonymous_id {
      type: string
      sql: ${TABLE}.anonymous_id ;;
    }
    dimension: device_type {
      type: string
      sql: ${TABLE}.device_type ;;
    }
    dimension: event_name {
      type: string
      sql: ${TABLE}.event_name ;;
    }
    dimension: event_name_before {
      type: string
      sql: ${TABLE}.event_name_before ;;
    }
    dimension: event_name_after {
      type: string
      sql: ${TABLE}.event_name_after ;;
    }
    dimension: category_name {
      type: string
      sql: ${TABLE}.category_name ;;
    }
    dimension: sub_category_name {
      type: string
      sql: ${TABLE}.sub_category_name ;;
    }
    dimension: origin_screen {
      type: string
      sql: ${TABLE}.origin_screen ;;
    }
    dimension: first_timestamp {
      type: date_time
      sql: ${TABLE}.first_timestamp ;;
    }
    dimension: last_timestamp {
      type: date_time
      sql: ${TABLE}.last_timestamp ;;
    }
    dimension_group: event_timestamp {
      type: time
      datatype: timestamp
      timeframes: [
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

    dimension_group: time_difference {
      type: time
      datatype: timestamp
      timeframes: [
        millisecond,
        second,
        minute,
        hour
      ]
      sql: ${TABLE}.time_difference ;;
    }

   dimension: time_difference_seconds {
      type: date_second
      sql: ${TABLE}.time_difference_seconds ;;
  }

   dimension: time_difference_minutes {
       type: date_minute
      sql: ${TABLE}.time_difference_minutes ;;
  }

    measure: count {
      type: count
      drill_fields: [detail*]
    }

    set: detail {
      fields: [
        event_uuid,
        session_id,
        anonymous_id,
        event_name,
        event_name_before,
        event_name_after,
        device_type,
        origin_screen,
        category_name,
        sub_category_name,
        first_timestamp,
        last_timestamp
      ]
    }
}
