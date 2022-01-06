view: dynamic_delivery_eta_analysis {
  derived_table: {
    sql:
    WITH tracking_viewed_tb AS (
        SELECT
            anonymous_id,
            order_number,
            order_id,
            timestamp,
            delivery_eta,
            country_iso,
            hub_slug,
            hub_city,
            order_status,
            id AS event_id,
            IF(delivery_eta=0, timestamp, NULL) AS timestamp_soon
        FROM `flink-data-prod.flink_android_production.order_tracking_viewed`
        WHERE TRUE
        QUALIFY ROW_NUMBER() OVER (PARTITION BY event_id ORDER BY timestamp)=1
    )

    , timestamps_tb AS (
        SELECT *,
            FIRST_VALUE(timestamp_soon IGNORE NULLS) OVER (PARTITION BY order_number ORDER BY timestamp ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS first_timestamp_soon,
            FIRST_VALUE(timestamp_soon IGNORE NULLS) OVER (PARTITION BY order_number ORDER BY timestamp DESC ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS last_timestamp_soon
        FROM tracking_viewed_tb
    )

    SELECT
        *,
        TIMESTAMP_DIFF(last_timestamp_soon, first_timestamp_soon, SECOND)+15 AS duration_soon
    FROM timestamps_tb
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: cnt_delivery_eta_zero {
    type: count
    label: "# Delivery ETA = Soon"
    filters: [delivery_eta: "0"]
  }

  measure: cnt_unique_delivery_eta_zero {
    type: count_distinct
    label: "# Unique Delivery ETA = Soon"
    sql: ${order_number} ;;
    filters: [delivery_eta: "0"]
  }

  measure: cnt_unique_orders {
    type: count_distinct
    label: "# Orders"
    sql: ${order_number} ;;
  }

  measure: avg_soon_time {
    type: average_distinct
    sql_distinct_key: ${order_number} ;;
    sql: ${duration_soon} ;;
    filters: [order_status: "-DELIVERED", duration_soon: "<120"]
    value_format_name: decimal_0
  }

  measure: median_soon_time {
    type: median_distinct
    sql_distinct_key: ${order_number} ;;
    sql: ${duration_soon} ;;
    filters: [order_status: "-DELIVERED"]
  }

  measure: 75_soon_time {
    type: percentile_distinct
    percentile: 75
    sql_distinct_key: ${order_number} ;;
    sql: ${duration_soon} ;;
    filters: [order_status: "-DELIVERED"]
  }

  measure: 25_soon_time {
    type: percentile_distinct
    percentile: 25
    sql_distinct_key: ${order_number} ;;
    sql: ${duration_soon} ;;
    filters: [order_status: "-DELIVERED"]
  }

  measure: min_soon_time {
    type: min
    sql: ${duration_soon} ;;
    filters: [order_status: "-DELIVERED"]
  }

  measure: max_soon_time {
    type: max
    sql: ${duration_soon} ;;
    filters: [order_status: "-DELIVERED"]
  }

  dimension: duration_soon {
    label: "OrderTrackingViewed on 'soon' time (minutes)"
    type: number
    sql: ${TABLE}.duration_soon ;;
  }

  dimension: anonymous_id {
    type: string
    sql: ${TABLE}.anonymous_id ;;
  }

  dimension: order_number {
    type: string
    sql: ${TABLE}.order_number ;;
  }

  dimension: order_id {
    type: string
    sql: ${TABLE}.order_id ;;
  }

  dimension_group: timestamp {
    type: time
    sql: ${TABLE}.timestamp ;;
  }

  dimension: delivery_eta {
    type: number
    sql: ${TABLE}.delivery_eta ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: hub_slug {
    type: string
    sql: ${TABLE}.hub_slug ;;
  }

  dimension: hub_city {
    type: string
    sql: ${TABLE}.hub_city ;;
  }

  dimension: order_status {
    type: string
    sql: ${TABLE}.order_status ;;
  }

  dimension: event_id {
    type: string
    sql: ${TABLE}.event_id ;;
  }

  set: detail {
    fields: [
      anonymous_id,
      order_number,
      order_id,
      timestamp_time,
      delivery_eta,
      country_iso,
      hub_slug,
      hub_city,
      order_status,
      event_id,
      duration_soon
    ]
  }
}
