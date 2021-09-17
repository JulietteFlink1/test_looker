view: productsearch_mobile_events {
  derived_table: {
    persist_for: "24 hours"
    sql: WITH
    joined_table AS (
    SELECT
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
    event.hub_city,
    event.hub_code AS hub_encoded,
    event.delivery_lat,
    event.delivery_lng,
    event.delivery_postcode,
    event.user_area_available,
    SPLIT(SAFE_CONVERT_BYTES_TO_STRING(FROM_BASE64(regexp_extract(hub_code, "^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/][AQgw]==|[A-Za-z0-9+/]{2}[AEIMQUYcgkosw048]=)?$"))),':')[
      OFFSET
      (1)] AS hub_id
    FROM
    `flink-data-prod.flink_android_production.tracks_view` tracks
    LEFT JOIN
    `flink-data-prod.flink_android_production.address_confirmed_view` event
    ON
    tracks.id=event.id
    WHERE
      tracks.event NOT LIKE "%api%"
      AND tracks.event NOT LIKE "%adjust%"
      AND tracks.event NOT LIKE "%install_attributed%"
      AND tracks.event NOT LIKE "%deep_link%"
      AND NOT (LOWER(tracks.context_app_version) LIKE "%app-rating%"
           OR LOWER(tracks.context_app_version) LIKE "%debug%")
      AND NOT (LOWER(tracks.context_app_name) = "flink-staging"
           OR LOWER(tracks.context_app_name) = "flink-debug")
      AND (LOWER(tracks.context_traits_email) != "qa@goflink.com"
           OR tracks.context_traits_email is null)
      AND (tracks.context_traits_hub_slug NOT IN('erp_spitzbergen', 'fr_hub_test', 'nl_hub_test')
           OR tracks.context_traits_hub_slug is null)

    UNION ALL

    SELECT
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
    NULL AS context_network_bluetooth,
    tracks.context_network_carrier,
    tracks.context_network_cellular,
    tracks.context_network_wifi,
    tracks.context_os_name,
    tracks.context_os_version,
    tracks.context_protocols_source_id,
    tracks.context_timezone,
    NULL AS context_traits_anonymous_id,
    NULL AS context_user_agent,
    tracks.event,
    tracks.event_text,
    tracks.id,
    tracks.loaded_at,
    tracks.original_timestamp,
    tracks.received_at,
    tracks.sent_at,
    tracks.timestamp,
    tracks.uuid_ts,
    event.hub_city,
    event.hub_code AS hub_encoded,
    event.delivery_lat,
    event.delivery_lng,
    event.delivery_postcode,
    event.user_area_available,
    SPLIT(SAFE_CONVERT_BYTES_TO_STRING(FROM_BASE64(regexp_extract(hub_code, "^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/][AQgw]==|[A-Za-z0-9+/]{2}[AEIMQUYcgkosw048]=)?$"))),':')[
      OFFSET
      (1)] AS hub_id
    FROM
    `flink-data-prod.flink_ios_production.tracks_view` tracks
    LEFT JOIN
    `flink-data-prod.flink_ios_production.address_confirmed_view` event
    ON
    tracks.id=event.id
    WHERE
      tracks.event NOT LIKE "%api%"
      AND tracks.event NOT LIKE "%adjust%"
      AND tracks.event NOT LIKE "%install_attributed%"
      AND tracks.event NOT LIKE "%deep_link%"
      AND NOT (LOWER(tracks.context_app_version) LIKE "%app-rating%"
           OR LOWER(tracks.context_app_version) LIKE "%debug%")
      AND NOT (LOWER(tracks.context_app_name) = "flink-staging"
           OR LOWER(tracks.context_app_name) = "flink-debug")
      AND (LOWER(tracks.context_traits_email) != "qa@goflink.com"
           OR tracks.context_traits_email is null)
      AND (tracks.context_traits_hub_slug NOT IN('erp_spitzbergen', 'fr_hub_test', 'nl_hub_test')
           OR tracks.context_traits_hub_slug is null)
    ),

    country_lookup AS (
    SELECT
    hub_code,
    country_iso,
    city
    FROM
    `flink-data-prod.google_sheets.hub_metadata` ),

    help_table AS (
    SELECT
    joined_table.*,
    country_lookup.country_iso, country_lookup.city, country_lookup.hub_code,
    -- divide events into blocks, belonging to the last seen "addressConfirmed" event
    SUM(CASE
    WHEN hub_city IS NULL THEN 0
    ELSE
    1
    END
    ) OVER(PARTITION BY anonymous_id ORDER BY timestamp) AS block,
    -- translate the hub-id into hub-code
    hub.slug AS hub_code_lower
    FROM
    joined_table
    LEFT JOIN
    `flink-data-prod.saleor_prod_global.warehouse_warehouse` AS hub
    ON
    joined_table.hub_id = hub.id
    LEFT JOIN
      country_lookup
    ON
      country_lookup.hub_code = UPPER(hub.slug)
    ORDER BY
    anonymous_id,
    timestamp ),

    tracks_data AS (
    SELECT
    help_table.*,
    CASE
    WHEN FIRST_VALUE(help_table.hub_code) OVER (PARTITION BY help_table.anonymous_id, block ORDER BY help_table.timestamp) IS NOT NULL THEN FIRST_VALUE(help_table.country_iso) OVER (PARTITION BY help_table.anonymous_id, block ORDER BY help_table.timestamp)
    WHEN FIRST_VALUE(help_table.city) OVER (PARTITION BY help_table.anonymous_id, block ORDER BY help_table.timestamp) IS NOT NULL THEN FIRST_VALUE(help_table.country_iso) OVER (PARTITION BY help_table.anonymous_id, block ORDER BY help_table.timestamp)
    ELSE
    SUBSTRING(help_table.context_locale,
    4,
    2)
    END
    AS derived_country_iso,
    (FIRST_VALUE(city) OVER (PARTITION BY help_table.anonymous_id, block ORDER BY help_table.timestamp) IS NOT NULL
    AND FIRST_VALUE(help_table.hub_code) OVER (PARTITION BY help_table.anonymous_id, block ORDER BY help_table.timestamp) IS NULL) AS country_derived_from_city,
    (FIRST_VALUE(city) OVER (PARTITION BY help_table.anonymous_id, block ORDER BY help_table.timestamp) IS NULL
    AND FIRST_VALUE(help_table.hub_code) OVER (PARTITION BY help_table.anonymous_id, block ORDER BY help_table.timestamp) IS NULL) AS country_derived_from_locale,
    FIRST_VALUE(help_table.city) OVER (PARTITION BY help_table.anonymous_id, block ORDER BY help_table.timestamp) AS derived_city,
    FIRST_VALUE(help_table.hub_code) OVER (PARTITION BY help_table.anonymous_id, block ORDER BY help_table.timestamp) AS derived_hub,
    FROM
    help_table
    ORDER BY
    anonymous_id,
    timestamp),

    search_data AS (
    SELECT
    id,
    search_query,
    INITCAP(TRIM(search_query)) AS search_query_clean,
    search_results_total_count,
    search_results_available_count,
    search_results_unavailable_count,
    product_ids
    FROM
    `flink-data-prod.flink_android_production.product_search_executed_view`
    UNION ALL
    SELECT
    id,
    search_query,
    INITCAP(TRIM(search_query)) AS search_query_clean,
    search_results_total_count,
    search_results_available_count,
    search_results_unavailable_count,
    product_ids
    FROM
    `flink-data-prod.flink_ios_production.product_search_executed_view` ),

    product_search_combined_data AS (
    SELECT
    tracks_data.*,
    search_data.search_query,
    search_data.search_query_clean,
    search_data.search_results_total_count,
    search_data.search_results_available_count,
    search_data.search_results_unavailable_count,
    search_data.product_ids
    FROM
    tracks_data
    LEFT JOIN
    search_data
    ON
    tracks_data.id=search_data.id ),

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
    SELECT
    *,
    LEAD(labeled_data.event) OVER(PARTITION BY labeled_data.anonymous_id ORDER BY labeled_data.timestamp ASC) AS next_event
    FROM
    labeled_data )
    SELECT
    *
    FROM
    filtered_tracking_data
    WHERE
    is_not_subquery IS NOT FALSE
    ORDER BY
    filtered_tracking_data.anonymous_id,
    filtered_tracking_data.timestamp ASC
    ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
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
    hidden: yes
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

  dimension: search_query_clean {
    type: string
    sql: ${TABLE}.search_query_clean ;;
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
    type: yesno
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

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: hub_city {
    type: string
    sql: ${TABLE}.hub_city ;;
  }

  dimension: hub_encoded {
    type: string
    sql: ${TABLE}.hub_encoded ;;
  }

  dimension: delivery_lat {
    type: number
    sql: ${TABLE}.delivery_lat ;;
  }

  dimension: delivery_lng {
    type: number
    sql: ${TABLE}.delivery_lng ;;
  }

  dimension: delivery_postcode {
    type: string
    sql: ${TABLE}.delivery_postcode ;;
  }

  dimension: user_area_available {
    type: yesno
    sql: ${TABLE}.user_area_available ;;
  }

  dimension: hub_id {
    type: string
    sql: ${TABLE}.hub_id ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: block {
    type: number
    sql: ${TABLE}.block ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: derived_country_iso {
    type: string
    sql: ${TABLE}.derived_country_iso ;;
  }

  dimension: country_derived_from_city {
    type: yesno
    sql: ${TABLE}.country_derived_from_city ;;
  }

  dimension: country_derived_from_locale {
    type: yesno
    sql: ${TABLE}.country_derived_from_locale ;;
  }

  dimension: derived_city {
    type: string
    sql: ${TABLE}.derived_city ;;
  }

  dimension: derived_hub {
    type: string
    sql: ${TABLE}.derived_hub ;;
  }

  ### custom dimensions
  dimension: country_clean {
    type: string
    case: {
      when: {
        sql: ${TABLE}.derived_country_iso = "DE" ;;
        label: "Germany"
      }
      when: {
        sql: ${TABLE}.derived_country_iso = "FR" ;;
        label: "France"
      }
      when: {
        sql: ${TABLE}.derived_country_iso = "NL" ;;
        label: "Netherlands"
      }
      else: "- Other / Unknown"
    }
  }

  dimension: city_clean {
    type: string
    sql:
      CASE
        WHEN ${TABLE}.derived_country_iso IN ("DE", "FR", "NL") AND NOT ${TABLE}.country_derived_from_locale THEN ${TABLE}.derived_city
        ELSE "- Other/ Unknown"
      END;;
  }

### Custom measures

  measure: successful_searches {
    type: sum
    label: "Sum of successful searches"
    description: "Sum of searches that were followed by productAddedToCart or productDetailsViewed"
    sql:
      CASE
        WHEN ${next_event}="product_added_to_cart" OR ${next_event}="product_details_viewed"
    THEN 1
    ELSE 0
    END;;
  }

  measure: cnt_unique_anonymousid {
    label: "# Unique Users"
    description: "Number of Unique Users identified via Anonymous ID from Segment"
    hidden:  no
    type: count_distinct
    sql: ${anonymous_id};;
    value_format_name: decimal_0
  }

  measure: cnt_nonzero_total_results {
    label: "Count of nonzero results"
    description: "Number of searches that returned at least one product"
    type: sum
    sql: if(${search_results_total_count}>0,1,0) ;;
  }

  measure: cnt_zero_total_results {
    label: "Count of zero results"
    description: "Number of searches that returned zero products"
    type: sum
    sql: if(${search_results_total_count}=0,1,0) ;;
  }

  measure: cnt_nonzero_available_results {
    label: "Count of nonzero available results"
    description: "Number of searches that returned at least one available product"
    type: sum
    sql: if(${search_results_available_count}>0,1,0) ;;
  }

  measure: cnt_zero_available_results {
    label: "Count of zero available results"
    description: "Number of searches that returned no available products"
    type: sum
    sql: if(${search_results_available_count}=0,1,0) ;;
  }

  measure: cnt_nonzero_only_unavailable_results {
    label: "Count of only unavailable results"
    description: "Number of searches that returned only unavailable (out of stock) products"
    type: sum
    sql: if(${search_results_available_count}=0 AND ${search_results_total_count}>0,1,0) ;;
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
      city,
      hub_city,
      hub_encoded,
      delivery_lat,
      delivery_lng,
      delivery_postcode,
      user_area_available,
      hub_id,
      country_clean,
      city_clean,
      country_iso,
      block,
      hub_code,
      derived_country_iso,
      country_derived_from_city,
      country_derived_from_locale,
      derived_city,
      derived_hub,
      search_query,
      search_query_clean,
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
