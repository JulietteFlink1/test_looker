view: marketingbanners_mobile_events {
  derived_table: {
    sql: SELECT
        anonymous_id,
        banner_id,
        banner_position,
        banner_title,
        context_app_build,
        context_app_name,
        context_app_namespace,
        context_app_version,
        context_device_ad_tracking_enabled,
        context_device_advertising_id,
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
        context_screen_density,
        context_screen_height,
        context_screen_width,
        context_timezone,
        context_traits_anonymous_id,
        context_user_agent,
        event,
        event_text,
        id,
        image_url,
        loaded_at,
        original_timestamp,
        received_at,
        sent_at,
        timestamp,
        uuid_ts,
      FROM
        `flink-backend.flink_android_production.marketing_banner_viewed_view`
      UNION ALL
      SELECT
        anonymous_id,
        banner_id,
        banner_position,
        banner_title,
        context_app_build,
        context_app_name,
        context_app_namespace,
        context_app_version,
        CAST(NULL AS BOOL) AS context_device_ad_tracking_enabled,
        NULL AS context_device_advertising_id,
        context_device_id,
        context_device_manufacturer,
        context_device_model,
        context_device_name,
        context_device_type,
        context_ip,
        context_library_name,
        context_library_version,
        context_locale,
        NULL AS context_network_bluetooth,
        context_network_carrier,
        context_network_cellular,
        context_network_wifi,
        context_os_name,
        context_os_version,
        context_protocols_source_id,
        NULL AS context_screen_density,
        context_screen_height,
        context_screen_width,
        context_timezone,
        NULL AS context_traits_anonymous_id,
        NULL AS context_user_agent,
        event,
        event_text,
        id,
        image_url,
        loaded_at,
        original_timestamp,
        received_at,
        sent_at,
        timestamp,
        uuid_ts
      FROM
        `flink-backend.flink_ios_production.marketing_banner_viewed_view`
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: count_unique_users {
    type:  count_distinct
    sql: ${anonymous_id} ;;
  }

  dimension: event_id {
    type: string
    sql: ${anonymous_id} || '-' || row_number() over(partition by ${anonymous_id} order by ${timestamp_raw}) ;;
    primary_key: yes
  }

  dimension: anonymous_id {
    type: string
    sql: ${TABLE}.anonymous_id ;;
  }

  dimension: banner_id {
    type: string
    sql: ${TABLE}.banner_id ;;
  }

  dimension: banner_position {
    type: number
    sql: ${TABLE}.banner_position ;;
  }

  dimension: banner_title {
    type: string
    sql: ${TABLE}.banner_title ;;
  }

  dimension: context_app_build {
    type: string
    sql: ${TABLE}.context_app_build ;;
  }

  dimension: context_app_name {
    type: string
    sql: ${TABLE}.context_app_name ;;
  }

  dimension: context_app_namespace {
    type: string
    sql: ${TABLE}.context_app_namespace ;;
  }

  dimension: context_app_version {
    type: string
    sql: ${TABLE}.context_app_version ;;
  }

  dimension: context_device_ad_tracking_enabled {
    type: string
    sql: ${TABLE}.context_device_ad_tracking_enabled ;;
  }

  dimension: context_device_advertising_id {
    type: string
    sql: ${TABLE}.context_device_advertising_id ;;
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

  dimension: context_screen_density {
    type: number
    sql: ${TABLE}.context_screen_density ;;
  }

  dimension: context_screen_height {
    type: number
    sql: ${TABLE}.context_screen_height ;;
  }

  dimension: context_screen_width {
    type: number
    sql: ${TABLE}.context_screen_width ;;
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

  dimension: image_url {
    type: string
    sql: ${TABLE}.image_url ;;
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
      anonymous_id,
      banner_id,
      banner_position,
      banner_title,
      context_app_build,
      context_app_name,
      context_app_namespace,
      context_app_version,
      context_device_ad_tracking_enabled,
      context_device_advertising_id,
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
      context_screen_density,
      context_screen_height,
      context_screen_width,
      context_timezone,
      context_traits_anonymous_id,
      context_user_agent,
      event,
      event_text,
      id,
      image_url,
      loaded_at_time,
      original_timestamp_time,
      received_at_time,
      sent_at_time,
      timestamp_time,
      uuid_ts_time
    ]
  }
}
