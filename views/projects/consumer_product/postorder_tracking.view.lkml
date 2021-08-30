view: postorder_tracking {
  derived_table: {
    sql:
      WITH tracks_tb AS (
        SELECT tracks.anonymous_id,
        tracks.timestamp,
        IF(tracks.event="purchase_confirmed", "payment_started", tracks.event) AS event,
        tracks.id,
        tracks.context_app_version,
        tracks.context_device_type,
        tracks.context_os_version
        FROM `flink-backend.flink_android_production.tracks_view` tracks
        WHERE tracks.event NOT LIKE "api%" AND tracks.event NOT LIKE "deep_link%"

        UNION ALL

        SELECT tracks.anonymous_id,
        tracks.timestamp,
        IF(tracks.event="purchase_confirmed", "payment_started", tracks.event) AS event,
        tracks.id,
        tracks.context_app_version,
        tracks.context_device_type,
        tracks.context_os_version
        FROM `flink-backend.flink_ios_production.tracks_view` tracks
        WHERE tracks.event NOT LIKE "api%" AND tracks.event NOT LIKE "deep_link%"
      ),

      order_tracking_tb AS (
      SELECT
        ios_order.order_token,
        ios_order.order_id,
        ios_order.order_number,
        ios_order.hub_slug
        ios_order.id,
      FROM
        `flink-backend.flink_ios_production.order_tracking_viewed_view` ios_order
      UNION ALL
      SELECT
        android_order.order_token,
        android_order.order_id,
        android_order.order_number,
        android_order.hub_slug
        android_order.id,
      FROM
        `flink-backend.flink_android_production.order_tracking_viewed_view` android_order
        ),

      joined_tb AS (
        SELECT tracks_tb.*,
        order_tracking_tb.*,
        FROM tracks_tb
        LEFT JOIN order_tracking_tb
        ON tracks_tb.id=order_tracking_tb.id
        ),

       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: order_token {
    type: string
    sql: ${TABLE}.order_token ;;
  }

  dimension: order_id {
    type: string
    sql: ${TABLE}.order_id ;;
  }

  dimension: order_number {
    type: string
    sql: ${TABLE}.order_number ;;
  }

  dimension: anonymous_id {
    type: string
    sql: ${TABLE}.anonymous_id ;;
  }

  dimension: context_app_build {
    type: string
    sql: ${TABLE}.context_app_build ;;
  }

  dimension: context_app_version {
    type: string
    sql: ${TABLE}.context_app_version ;;
  }

  dimension: context_device_ad_tracking_enabled {
    type: string
    sql: ${TABLE}.context_device_ad_tracking_enabled ;;
  }

  dimension: context_device_id {
    type: string
    sql: ${TABLE}.context_device_id ;;
  }

  dimension: context_device_manufacturer {
    type: string
    sql: ${TABLE}.context_device_manufacturer ;;
  }

  dimension: context_device_model {
    type: string
    sql: ${TABLE}.context_device_model ;;
  }

  dimension: context_device_name {
    type: string
    sql: ${TABLE}.context_device_name ;;
  }

  dimension: context_device_type {
    type: string
    sql: ${TABLE}.context_device_type ;;
  }

  dimension: context_ip {
    type: string
    sql: ${TABLE}.context_ip ;;
  }

  dimension: context_library_name {
    type: string
    sql: ${TABLE}.context_library_name ;;
  }

  dimension: context_library_version {
    type: string
    sql: ${TABLE}.context_library_version ;;
  }

  dimension: context_locale {
    type: string
    sql: ${TABLE}.context_locale ;;
  }

  dimension: context_network_bluetooth {
    type: string
    sql: ${TABLE}.context_network_bluetooth ;;
  }

  dimension: context_network_carrier {
    type: string
    sql: ${TABLE}.context_network_carrier ;;
  }

  dimension: context_network_cellular {
    type: string
    sql: ${TABLE}.context_network_cellular ;;
  }

  dimension: context_network_wifi {
    type: string
    sql: ${TABLE}.context_network_wifi ;;
  }

  dimension: context_os_name {
    type: string
    sql: ${TABLE}.context_os_name ;;
  }

  dimension: context_os_version {
    type: string
    sql: ${TABLE}.context_os_version ;;
  }

  dimension: context_protocols_source_id {
    type: string
    sql: ${TABLE}.context_protocols_source_id ;;
  }

  dimension: context_timezone {
    type: string
    sql: ${TABLE}.context_timezone ;;
  }

  dimension: context_traits_anonymous_id {
    type: string
    sql: ${TABLE}.context_traits_anonymous_id ;;
  }

  dimension: context_user_agent {
    type: string
    sql: ${TABLE}.context_user_agent ;;
  }

  dimension: event {
    type: string
    sql: ${TABLE}.event ;;
  }

  dimension: event_text {
    type: string
    sql: ${TABLE}.event_text ;;
  }

  dimension: id {
    type: string
    sql: ${TABLE}.id ;;
  }

  dimension_group: loaded_at {
    type: time
    sql: ${TABLE}.loaded_at ;;
  }

  dimension_group: original_timestamp {
    type: time
    sql: ${TABLE}.original_timestamp ;;
  }

  dimension_group: received_at {
    type: time
    sql: ${TABLE}.received_at ;;
  }

  dimension_group: sent_at {
    type: time
    sql: ${TABLE}.sent_at ;;
  }

  dimension_group: timestamp {
    type: time
    sql: ${TABLE}.timestamp ;;
  }

  dimension_group: uuid_ts {
    type: time
    sql: ${TABLE}.uuid_ts ;;
  }

  set: detail {
    fields: [
      order_token,
      order_id,
      order_number,
      anonymous_id,
      context_app_build,
      context_app_version,
      context_device_ad_tracking_enabled,
      context_device_id,
      context_device_manufacturer,
      context_device_model,
      context_device_name,
      context_device_type,
      context_ip,
      context_library_name,
      context_library_version,
      context_locale,
      context_network_bluetooth,
      context_network_carrier,
      context_network_cellular,
      context_network_wifi,
      context_os_name,
      context_os_version,
      context_protocols_source_id,
      context_timezone,
      context_traits_anonymous_id,
      context_user_agent,
      event,
      event_text,
      id,
      loaded_at_time,
      original_timestamp_time,
      received_at_time,
      sent_at_time,
      timestamp_time,
      uuid_ts_time
    ]
  }
}
