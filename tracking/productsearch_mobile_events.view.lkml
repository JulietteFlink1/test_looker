view: productsearch_mobile_events {
  derived_table: {
    sql: WITH
        tracks_data AS (
        SELECT
          anonymous_id, context_app_build, context_app_version, context_device_ad_tracking_enabled, context_device_id, context_device_manufacturer, context_device_model, context_device_name, context_device_type, context_ip, context_library_name, context_library_version, context_locale, context_network_bluetooth, context_network_carrier, context_network_cellular, context_network_wifi, context_os_name, context_os_version, context_protocols_source_id, context_timezone, context_traits_anonymous_id, context_user_agent, event, event_text, id, loaded_at, original_timestamp, received_at, sent_at, timestamp, uuid_ts
        FROM
          `flink-backend.flink_android_production.tracks_view`
        UNION ALL
        SELECT
          anonymous_id, context_app_build, context_app_version, CAST(NULL AS BOOL) AS context_device_ad_tracking_enabled, context_device_id, context_device_manufacturer, context_device_model, context_device_name, context_device_type, context_ip, context_library_name, context_library_version, context_locale, NULL AS context_network_bluetooth, context_network_carrier, context_network_cellular, context_network_wifi, context_os_name, context_os_version, context_protocols_source_id, context_timezone, NULL AS context_traits_anonymous_id, NULL AS context_user_agent, event, event_text, id, loaded_at, original_timestamp, received_at, sent_at, timestamp, uuid_ts
        FROM
          `flink-backend.flink_ios_production.tracks_view`
        ),

        search_data AS (
        SELECT
          id, search_query, INITCAP(search_query) AS search_query_initcap, search_results_total_count, search_results_available_count, search_results_unavailable_count, product_ids
        FROM
          `flink-backend.flink_android_production.product_search_executed_view`
        UNION ALL
        SELECT
          id, search_query, INITCAP(search_query) AS search_query_initcap, search_results_total_count, search_results_available_count, search_results_unavailable_count, product_ids
        FROM
          `flink-backend.flink_ios_production.product_search_executed_view`
        ),

        product_search_combined_data AS (
        SELECT tracks_data.*,search_data.search_query,
          search_data.search_query_initcap,
          search_data.search_results_total_count,
          search_data.search_results_available_count,
          search_data.search_results_unavailable_count,
          search_data.product_ids
        FROM tracks_data
        LEFT JOIN search_data ON tracks_data.id=search_data.id
        ),

        labeled_data AS(
        SELECT
          *,
          LEAD(product_search_combined_data.search_query) OVER(PARTITION BY product_search_combined_data.anonymous_id ORDER BY product_search_combined_data.timestamp ASC) NOT LIKE CONCAT('%', product_search_combined_data.search_query,'%') AS is_not_subquery,
          CASE
            WHEN product_search_combined_data.event = 'product_search_executed' AND LEAD(product_search_combined_data.event) OVER(PARTITION BY product_search_combined_data.anonymous_id ORDER BY product_search_combined_data.timestamp ASC) IN('product_added_to_cart', 'product_details_viewed') THEN TRUE
          ELSE
          FALSE
        END
          AS has_search_and_consecutive_add_to_cart_or_view_item,
        FROM
          product_search_combined_data),

        filtered_tracking_data AS (
        SELECT *,
        LEAD(labeled_data.event) OVER(PARTITION BY labeled_data.anonymous_id ORDER BY labeled_data.timestamp ASC) AS next_event
        FROM labeled_data
        )
      SELECT
        *
      FROM
        filtered_tracking_data
      WHERE is_not_subquery IS NOT FALSE
      ORDER BY
        filtered_tracking_data.anonymous_id,
        filtered_tracking_data.timestamp ASC
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: cnt_unique_anonymousid {
    label: "# Unique Users"
    description: "Count of Unique Users identified via Anonymous ID from Segment"
    hidden:  no
    type: count_distinct
    sql: ${anonymous_id};;
    value_format: "0"
  }

  measure: cnt_nonzero_total_results {
    label: "Count of nonzero results"
    description: "Count of total results where total results > 0"
    type: sum
    sql: if(${search_results_total_count}>0,1,0) ;;
  }

  measure: cnt_zero_total_results {
    label: "Count of zero results"
    description: "Count of total results where total results = 0"
    type: sum
    sql: if(${search_results_total_count}=0,1,0) ;;
  }

  measure: cnt_nonzero_available_results {
    label: "Count of nonzero available results"
    description: "Count of available product results where available products > 0"
    type: sum
    sql: if(${search_results_available_count}>0,1,0) ;;
  }

  measure: cnt_zero_available_results {
    label: "Count of zero available results"
    description: "Count of available product results where available products = 0"
    type: sum
    sql: if(${search_results_available_count}=0,1,0) ;;
  }

  measure: cnt_nonzero_only_unavailable_results {
    label: "Count of only unavailable results"
    description: "Count of searches that resulted in total results > 0, but available results = 0 (only unavailable products)"
    type: sum
    sql: if(${search_results_available_count}=0 AND ${search_results_total_count}>0,1,0) ;;
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
    primary_key: yes
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

  dimension: search_query {
    type: string
    sql: ${TABLE}.search_query ;;
  }

  dimension: search_query_initcap {
    type: string
    sql: ${TABLE}.search_query_initcap ;;
  }

  dimension: search_results_total_count {
    type: number
    sql: ${TABLE}.search_results_total_count ;;
  }

  dimension: search_results_available_count {
    type: number
    sql: ${TABLE}.search_results_available_count ;;
  }

  dimension: search_results_unavailable_count {
    type: number
    sql: ${TABLE}.search_results_unavailable_count ;;
  }

  dimension: product_ids {
    type: string
    sql: ${TABLE}.product_ids ;;
  }

  dimension: is_not_subquery {
    type: string
    sql: ${TABLE}.is_not_subquery ;;
  }

  dimension: has_search_and_consecutive_add_to_cart_or_view_item {
    type: string
    sql: ${TABLE}.has_search_and_consecutive_add_to_cart_or_view_item ;;
  }

  dimension: next_event {
    type: string
    sql: ${TABLE}.next_event ;;
  }

  set: detail {
    fields: [
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
      search_query,
      search_query_initcap,
      search_results_total_count,
      search_results_available_count,
      search_results_unavailable_count,
      product_ids,
      is_not_subquery,
      has_search_and_consecutive_add_to_cart_or_view_item,
      next_event
    ]
  }
}
