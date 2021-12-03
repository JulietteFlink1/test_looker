view: productsearch_mobile_events {
  derived_table: {
    persist_for: "24 hours"
    sql: WITH
          joined_table AS (
          SELECT
          tracks.anonymous_id,
          tracks.context_app_version,
          tracks.context_device_type,
          tracks.context_locale,
          tracks.event,
          tracks.id,
          tracks.timestamp,
          event.hub_city,
          event.hub_code AS hub_encoded,
          event.delivery_lat,
          event.delivery_lng,
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
          tracks.context_app_version,
          tracks.context_device_type,
          tracks.context_locale,
          tracks.event,
          tracks.id,
          tracks.timestamp,
          event.hub_city,
          event.hub_code AS hub_encoded,
          event.delivery_lat,
          event.delivery_lng,
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
          FROM filtered_tracking_data
          WHERE is_not_subquery IS NOT FALSE
          AND search_query_clean IS NOT NULL
          ;;
  }

  ######### IDs ##########

  dimension: anonymous_id {
    group_label: "IDs"
    description: "Anonymous ID generated by Segment as user identifier"
    type: string
    sql: ${TABLE}.anonymous_id ;;
  }

  dimension: id {
    group_label: "IDs"
    label: "Event ID"
    description: "Event ID generated by Segment, unique for every tracked event"
    type: string
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.id ;;
  }


  ########## Device attributes #########

  dimension: context_app_version {
    group_label: "Device Dimensions"
    label: "App version"
    description: "App version used in the session"
    type: string
    sql: ${TABLE}.context_app_version ;;
  }

  dimension: context_device_type {
    group_label: "Device Dimensions"
    label: "Device Type"
    description: "iOS or Android"
    type: string
    sql: ${TABLE}.context_device_type ;;
  }

  dimension: full_app_version {
    group_label: "Device Dimensions"
    description: "Device type and app version combined in one dimension"
    type: string
    sql: ${context_device_type} || '-' || ${context_app_version} ;;
  }

  ########## Location attributes #########
  dimension: derived_hub {
    group_label: "Location Dimensions"
    label: "Hub code"
    description: "Hub associated with the last address the user selected"
    type: string
    sql: ${TABLE}.derived_hub ;;
  }

  dimension: delivery_lat {
    group_label: "Location Dimensions"
    description: "Latitude of user's selected address"
    type: number
    sql: ${TABLE}.delivery_lat ;;
  }

  dimension: delivery_lng {
    group_label: "Location Dimensions"
    description: "Longitude of user's selected address"
    type: number
    sql: ${TABLE}.delivery_lng ;;
  }

  dimension: derived_country_iso {
    hidden: yes
    type: string
    sql: ${TABLE}.derived_country_iso ;;
  }

  dimension: country_derived_from_city {
    hidden: yes
    type: yesno
    sql: ${TABLE}.country_derived_from_city ;;
  }

  dimension: country_derived_from_locale {
    hidden: yes
    type: yesno
    sql: ${TABLE}.country_derived_from_locale ;;
  }

  dimension: derived_city {
    hidden: yes
    type: string
    sql: ${TABLE}.derived_city ;;
  }

  dimension: hub_code {
    hidden: yes
    description: "Hub code associated with the last address the user selected"
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: country_clean {
    group_label: "Location Dimensions"
    label: "Country ISO"
    description: "Country associated with the user's selected address or device locale"
    type: string
    case: {
      when: {
        sql: ${derived_country_iso} = "DE" ;;
        label: "Germany"
      }
      when: {
        sql: ${derived_country_iso} = "FR" ;;
        label: "France"
      }
      when: {
        sql: ${derived_country_iso} = "NL" ;;
        label: "Netherlands"
      }
      when: {
        sql: ${derived_country_iso} = "AT" ;;
        label: "Austria"
      }
      else: "Other / Unknown"
    }
  }

  dimension: city_clean {
    group_label: "Location Dimensions"
    label: "City"
    description: "City associated with the last address the user selected"
    type: string
    sql:
      CASE
        WHEN ${derived_country_iso} IN ("DE", "FR", "NL") AND NOT ${country_derived_from_locale} THEN ${derived_city}
        ELSE "- Other/ Unknown"
      END;;
  }

  ########## Search dimensions #########
  dimension: search_query {
    group_label: "Search Dimensions"
    hidden: yes
    type: string
    sql: ${TABLE}.search_query ;;
  }

  dimension: search_query_clean {
    group_label: "Search Dimensions"
    description: "String that was searched for (cast to Capitalized form)"
    type: string
    sql: ${TABLE}.search_query_clean ;;
  }

  dimension: search_results_total_count {
    group_label: "Search Dimensions"
    description: "# total products returned from search"
    type: number
    sql: ${TABLE}.search_results_total_count ;;
  }

  dimension: search_results_available_count {
    group_label: "Search Dimensions"
    description: "# products in stock returned from search"
    type: number
    sql: ${TABLE}.search_results_available_count ;;
  }

  dimension: search_results_unavailable_count {
    group_label: "Search Dimensions"
    description: "# products out of stock returned from search"
    type: number
    sql: ${TABLE}.search_results_unavailable_count ;;
  }

  dimension: has_search_and_consecutive_add_to_cart_or_view_item {
    group_label: "Search Dimensions"
    description: "Whether the search was followed by an Add To Cart of View Item Details event"
    type: string
    sql: ${TABLE}.has_search_and_consecutive_add_to_cart_or_view_item ;;
  }

  dimension: product_ids {
    group_label: "Search Dimensions"
    description: "Product IDs returned by the search"
    type: string
    sql: ${TABLE}.product_ids ;;
  }

  dimension: is_not_subquery {
    type: yesno
    hidden: yes
    sql: ${TABLE}.is_not_subquery ;;
  }


  ########## Event Dimensions #########

  dimension: event {
    group_label: "Event Dimensions"
    description: "Tracking event triggered by user"
    type: string
    sql: ${TABLE}.event ;;
  }

  dimension_group: timestamp {
    group_label: "Event Dimensions"
    description: "Time at which event was triggered"
    type: time
    sql: ${TABLE}.timestamp ;;
  }

  dimension: next_event {
    group_label: "Event Dimensions"
    description: "Given a certain event, what is the next event triggered by the user"
    type: string
    sql: ${TABLE}.next_event ;;
  }

  measure: count {
    description: "Counts the number of occurrences of the selected dimension(s)"
    type: count
    drill_fields: [detail*]
  }


  ########## Search Measures #########

  measure: successful_searches {
    group_label: "Search Measures"
    type: sum
    label: "Cnt Successful Searches"
    description: "# of searches that were followed by productAddedToCart or productDetailsViewed"
    sql:
      CASE
        WHEN ${next_event}="product_added_to_cart" OR ${next_event}="product_details_viewed"
    THEN 1
    ELSE 0
    END;;
  }

  measure: cnt_unique_anonymousid {
    group_label: "Search Measures"
    label: "# Users"
    description: "# Unique Users as identified via Anonymous ID from Segment"
    type: count_distinct
    sql: ${anonymous_id};;
    value_format_name: decimal_0
  }

  measure: cnt_nonzero_total_results {
    group_label: "Search Measures"
    label: "# Searches With Nonzero Results"
    description: "# searches that returned at least one product"
    type: sum
    sql: if(${search_results_total_count}>0,1,0) ;;
  }

  measure: cnt_zero_total_results {
    group_label: "Search Measures"
    label: "# Searches With Zero Results"
    description: "# searches that returned zero products"
    type: sum
    sql: if(${search_results_total_count}=0,1,0) ;;
  }

  measure: cnt_nonzero_available_results {
    group_label: "Search Measures"
    label: "# Searches With Nonzero In-Stock Results"
    description: "# searches that returned at least one available product"
    type: sum
    sql: if(${search_results_available_count}>0,1,0) ;;
  }

  measure: cnt_zero_available_results {
    group_label: "Search Measures"
    label: "# Searches With Zero In-Stock Results"
    description: "# searches that returned no available products"
    type: sum
    sql: if(${search_results_available_count}=0,1,0) ;;
  }

  measure: cnt_nonzero_only_unavailable_results {
    group_label: "Search Measures"
    label: "# Searches With Only OOS Results"
    description: "# searches that returned products, but all products were unavailable (OOS)"
    type: sum
    sql: if(${search_results_available_count}=0 AND ${search_results_total_count}>0,1,0) ;;
  }

  set: detail {
    fields: [
      anonymous_id,
      context_app_version,
      context_device_type,
      country_clean,
      city_clean,
      hub_code,
      search_query_clean,
      search_results_total_count,
      search_results_available_count,
      search_results_unavailable_count,
      product_ids,
      has_search_and_consecutive_add_to_cart_or_view_item,
      next_event
    ]
  }
}
