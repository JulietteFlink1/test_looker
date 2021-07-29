view: order_placed_view {
  derived_table: {
    sql: SELECT
        tracks.order_token,
        tracks.order_id,
        tracks.order_number,
        tracks.anonymous_id,
        tracks.context_app_build,
        tracks.context_app_version,
        CAST(NULL AS BOOL) AS context_device_ad_tracking_enabled,
        tracks.context_device_id,
        tracks.context_device_manufacturer,
        tracks.context_device_model,
        tracks.context_device_name,
        tracks.context_device_type,
        tracks.context_ip,
        tracks.context_library_name,
        tracks.context_library_version,
        tracks.context_locale,
        CAST(NULL AS BOOL) AS context_network_bluetooth,
        tracks.context_network_carrier,
        tracks.context_network_cellular,
        tracks.context_network_wifi,
        tracks.context_os_name,
        tracks.context_os_version,
        tracks.context_protocols_source_id,
        tracks.context_timezone,
        CAST(NULL AS STRING) AS context_traits_anonymous_id,
        CAST(NULL AS STRING) AS context_user_agent,
        tracks.event,
        tracks.event_text,
        tracks.id,
        tracks.loaded_at,
        tracks.original_timestamp,
        tracks.received_at,
        tracks.sent_at,
        tracks.timestamp,
        tracks.uuid_ts,
        tracks.delivery_fee,
        CAST(tracks.delivery_eta AS INTEGER) AS delivery_eta,
        tracks.delivery_postcode,
        tracks.hub_city,
        tracks.hub_code,
        tracks.hub_slug,
        tracks.payment_method,
        tracks.products,
        tracks.revenue,
        tracks.voucher_code,
        tracks.voucher_value,
        tracks.currency
      FROM
        `flink-backend.flink_ios_production.order_placed_view` tracks
      UNION ALL
      SELECT
        tracks.order_token,
        tracks.order_id,
        tracks.order_number,
        tracks.anonymous_id,
        tracks.context_app_build,
        tracks.context_app_version,
        tracks.context_device_ad_tracking_enabled,
        tracks.context_device_id,
        tracks.context_device_manufacturer,
        tracks.context_device_model,
        tracks.context_device_name,
        tracks.context_device_type,
        tracks.context_ip,
        tracks.context_library_name,
        tracks.context_library_version,
        tracks.context_locale,
        tracks.context_network_bluetooth,
        tracks.context_network_carrier,
        tracks.context_network_cellular,
        tracks.context_network_wifi,
        tracks.context_os_name,
        tracks.context_os_version,
        tracks.context_protocols_source_id,
        tracks.context_timezone,
        tracks.context_traits_anonymous_id,
        tracks.context_user_agent,
        tracks.event,
        tracks.event_text,
        tracks.id,
        tracks.loaded_at,
        tracks.original_timestamp,
        tracks.received_at,
        tracks.sent_at,
        tracks.timestamp,
        tracks.uuid_ts,
        tracks.delivery_fee,
        tracks.delivery_eta,
        tracks.delivery_postcode,
        tracks.hub_city,
        tracks.hub_code,
        NULL AS hub_slug,
        tracks.payment_method,
        tracks.products,
        tracks.revenue,
        tracks.voucher_code,
        tracks.voucher_value,
        tracks.currency
      FROM
        `flink-backend.flink_android_production.order_placed_view` tracks
 ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: number_of_distinct_orders {
    type: count_distinct
    sql: ${TABLE}.order_id ;;
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

  dimension: delivery_fee {
    type: number
    sql: ${TABLE}.delivery_fee ;;
  }

  dimension: delivery_eta {
    type: number
    sql: ${TABLE}.delivery_eta ;;
  }

  dimension: delivery_postcode {
    type: string
    sql: ${TABLE}.delivery_postcode ;;
  }

  dimension: hub_city {
    type: string
    sql: ${TABLE}.hub_city ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: hub_slug {
    type: string
    sql: ${TABLE}.hub_slug ;;
  }

  dimension: order_number_1 {
    type: string
    sql: ${TABLE}.order_number_1 ;;
  }

  dimension: order_id_1 {
    type: string
    sql: ${TABLE}.order_id_1 ;;
  }

  dimension: order_token_1 {
    type: string
    sql: ${TABLE}.order_token_1 ;;
  }

  dimension: payment_method {
    type: string
    sql: ${TABLE}.payment_method ;;
  }

  dimension: products {
    type: string
    sql: ${TABLE}.products ;;
  }

  dimension: revenue {
    type: number
    sql: ${TABLE}.revenue ;;
  }

  dimension: voucher_code {
    type: string
    sql: ${TABLE}.voucher_code ;;
  }

  dimension: voucher_value {
    type: number
    sql: ${TABLE}.voucher_value ;;
  }

  dimension: currency {
    type: string
    sql: ${TABLE}.currency ;;
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
      uuid_ts_time,
      delivery_fee,
      delivery_eta,
      delivery_postcode,
      hub_city,
      hub_code,
      hub_slug,
      order_number_1,
      order_id_1,
      order_token_1,
      payment_method,
      products,
      revenue,
      voucher_code,
      voucher_value,
      currency
    ]
  }
}
