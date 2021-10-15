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
       , TIMESTAMP_DIFF(last_timestamp, first_timestamp, SECOND) AS time_diff_seconds
       , TIMESTAMP_DIFF(last_timestamp, first_timestamp, MINUTE) AS time_diff_minutes
       , TIMESTAMP_DIFF(last_timestamp, first_timestamp, HOUR) AS time_diff_hour
       , TIMESTAMP_DIFF(c.last_timestamp_category, c.first_timestamp_category, SECOND) AS time_diff_category_seconds
       , TIMESTAMP_DIFF(c.last_timestamp_category, c.first_timestamp_category, MINUTE) AS time_diff_category_minutes
       , TIMESTAMP_DIFF(c.last_timestamp_category, c.first_timestamp_category, HOUR) AS time_diff_category_hour
FROM events e
LEFT JOIN category c ON c.event_uuid = e.event_uuid
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

    dimension_group: first_timestamp {
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
    dimension_group: last_timestamp {
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

   dimension: time_diff_seconds {
      type: number
      sql: ${TABLE}.time_diff_seconds ;;
  }
  dimension: time_diff_category_seconds {
    type: number
    sql: ${TABLE}.time_diff_category_seconds ;;
  }

  dimension: time_diff_minutes {
    type: number
    sql: ${TABLE}.time_diff_minutes ;;
  }

   dimension: time_diff_category_minutes {
       type: number
      sql: ${TABLE}.time_diff_category_minutes ;;
  }

  dimension: time_diff_hour {
    type: number
    sql: ${TABLE}.time_diff_hour ;;
  }
  dimension: time_diff_category_hour {
    type: number
    sql: ${TABLE}.time_diff_category_hour ;;
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
        event_name,
        event_name_before,
        event_name_after,
        device_type,
        origin_screen,
        category_name,
        sub_category_name,
        first_timestamp_minute,
        first_timestamp_second,
        last_timestamp_minute,
        last_timestamp_second
      ]
    }
}
