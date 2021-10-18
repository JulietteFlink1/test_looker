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
WHERE DATE(e.event_timestamp) >= "2021-10-01"
)

, category AS (
    SELECT  e.event_uuid
          , e.session_id
          , e.event_timestamp
          , LEAD(e.event_timestamp) OVER (PARTITION BY e.session_id ORDER BY e.event_timestamp ASC)          as event_timestamp_after
          , first_value (e.event_timestamp ) over (partition by session_id order by e.event_timestamp asc
                 ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)                                   as first_timestamp_category
          , last_value (e.event_timestamp ) over (partition by session_id order by e.event_timestamp asc
                 ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)                                   as last_timestamp_category
    FROM events e
    WHERE e.event_name = 'category_selected'
)

SELECT   e.event_uuid
       , e.session_id
       , e.anonymous_id
       , s.country_iso
       , e.event_name
       , e.event_name_before
       , e.event_name_after
       , e.device_type
       , e.event_timestamp
       , e.category_name
       , e.sub_category_name
       , e.origin_screen
       , e.first_timestamp
       , c.first_timestamp_category
       , e.last_timestamp
       , c.last_timestamp_category
       , TIMESTAMP_DIFF(c.event_timestamp_after, e.event_timestamp, SECOND) AS category_timestamp_diff_seconds
       , TIMESTAMP_DIFF(last_timestamp, first_timestamp, SECOND) AS session_duration_seconds
       , TIMESTAMP_DIFF(last_timestamp, first_timestamp, MINUTE) AS session_duration_minutes
       , TIMESTAMP_DIFF(last_timestamp, first_timestamp, HOUR) AS session_duration_hour
       , TIMESTAMP_DIFF(c.last_timestamp_category, c.first_timestamp_category, SECOND) AS category_session_duration_seconds
       , TIMESTAMP_DIFF(c.last_timestamp_category, c.first_timestamp_category, MINUTE) AS category_session_duration_minutes
       , TIMESTAMP_DIFF(c.last_timestamp_category, c.first_timestamp_category, HOUR) AS category_session_duration_hour
FROM events e
LEFT JOIN category c ON c.event_uuid = e.event_uuid
LEFT JOIN `flink-data-prod.curated.app_sessions` s ON s.session_uuid = e.session_id
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
    dimension: country_iso {
      type: string
      sql: ${TABLE}.country_iso ;;
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

    dimension_group: session_start_at {
     type: time
     datatype: timestamp
     timeframes: [
       second,
       minute,
       hour
     ]
     sql: ${TABLE}.first_timestamp ;;
  }
  dimension_group: first_timestamp_category {
    type: time
    datatype: timestamp
    timeframes: [
      second,
      minute,
      hour
    ]
    sql: ${TABLE}.first_timestamp_category ;;
  }
    dimension_group: session_end_at {
      type: time
      datatype: timestamp
      timeframes: [
        second,
        minute,
        hour
      ]
     sql: ${TABLE}.last_timestamp ;;
  }
  dimension_group: last_timestamp_category {
    type: time
    datatype: timestamp
    timeframes: [
      second,
      minute,
      hour
    ]
    sql: ${TABLE}.last_timestamp_category ;;
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

  dimension: session_duration_seconds {
    type: number
    sql: ${TABLE}.session_duration_seconds ;;
  }
  dimension: category_session_duration_seconds {
    type: number
    sql: ${TABLE}.category_session_duration_seconds ;;
  }
  dimension: session_duration_minutes {
    type: number
    sql: ${TABLE}.session_duration_minutes ;;
  }
  dimension: category_session_duration_minutes {
    type: number
    sql: ${TABLE}.category_session_duration_minutes ;;
  }
  dimension: session_duration_hour {
    type: number
    sql: ${TABLE}.session_duration_hour ;;
  }
  dimension: category_session_duration_hour {
    type: number
    sql: ${TABLE}.category_session_duration_hour ;;
  }
  dimension: category_timestamp_diff_seconds {
    type: number
    sql: ${TABLE}.category_timestamp_diff_seconds ;;
  }


  ### MEASURES

    measure: count {
      type: count
      label: "# Events"
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

  measure: cnt_unique_sessionid {
    label: "# Unique Sessions"
    description: "Number of Unique Sessions"
    hidden:  no
    type: count_distinct
    sql: ${session_id};;
    value_format_name: decimal_0
  }


    set: detail {
      fields: [
        event_uuid,
        session_id,
        anonymous_id,
        country_iso,
        event_name,
        event_name_before,
        event_name_after,
        device_type,
        origin_screen,
        category_name,
        sub_category_name,
        session_start_at_second,
        session_end_at_second,
        event_timestamp_hour
      ]
    }
}
