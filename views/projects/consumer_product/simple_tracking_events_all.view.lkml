view: simple_tracking_events_all {
  derived_table: {
    sql: WITH joined_table AS
      (SELECT
          tracks.anonymous_id,
          tracks.context_app_build,
          tracks.context_app_version,
          tracks.context_device_ad_tracking_enabled,
          tracks.context_device_model,
          tracks.context_device_name,
          tracks.context_device_type,
          tracks.context_locale,
          tracks.context_timezone,
          tracks.event,
          tracks.event_text,
          tracks.id,
          tracks.timestamp
          FROM
          `flink-data-prod.flink_android_production.tracks` tracks
          WHERE DATE(tracks._partitiontime) > "2021-08-01"
          AND tracks.event NOT LIKE "%api%"
          AND tracks.event NOT LIKE "%adjust%"
          AND tracks.event NOT LIKE "%install_attributed%"
          AND tracks.event != "app_opened"
          AND tracks.event != "application_updated"
          AND tracks.event != "application_opened"
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
          tracks.context_device_model,
          tracks.context_device_name,
          tracks.context_device_type,
          tracks.context_locale,
          tracks.context_timezone,
          tracks.event,
          tracks.event_text,
          tracks.id,
          tracks.timestamp
          FROM
          `flink-data-prod.flink_ios_production.tracks` tracks
          WHERE DATE(tracks._partitiontime) > "2021-08-01"
          AND tracks.event NOT LIKE "%api%"
          AND tracks.event NOT LIKE "%adjust%"
          AND tracks.event NOT LIKE "%install_attributed%"
          AND tracks.event != "app_opened"
          AND tracks.event != "application_updated"
          AND tracks.event != "application_opened"
          AND NOT (LOWER(tracks.context_app_version) LIKE "%app-rating%"
           OR LOWER(tracks.context_app_version) LIKE "%debug%")
          AND NOT (LOWER(tracks.context_app_name) = "flink-staging"
           OR LOWER(tracks.context_app_name) = "flink-debug")
          AND (LOWER(tracks.context_traits_email) != "qa@goflink.com"
           OR tracks.context_traits_email is null)
          AND (tracks.context_traits_hub_slug NOT IN('erp_spitzbergen', 'fr_hub_test', 'nl_hub_test')
           OR tracks.context_traits_hub_slug is null)
      )
      SELECT *,
       case when split(context_locale,"-")[safe_offset(0)] = 'de' THEN 'Germany'
            when split(context_locale,"-")[safe_offset(0)] = 'nl' THEN 'Netherlands'
            when split(context_locale,"-")[safe_offset(0)] = 'fr' THEN 'France'
            else (
                    case when split(context_timezone,"/")[safe_offset(1)] = 'Berlin' THEN 'Germany'
                         when split(context_timezone,"/")[safe_offset(1)] = 'Amsterdam' THEN 'Netherlands'
                         when split(context_timezone,"/")[safe_offset(1)] = 'Paris' THEN 'France'
                         else 'unknown' end
                    ) end as country_iso,
      LAG(joined_table.event) OVER(PARTITION BY joined_table.anonymous_id ORDER BY joined_table.timestamp ASC) AS previous_event,
      LEAD(joined_table.event) OVER(PARTITION BY joined_table.anonymous_id ORDER BY joined_table.timestamp ASC) AS next_event
      FROM joined_table
       ;;
  }

  ### Custom measures and dimensions

  measure: cnt_unique_anonymousid {
    label: "# Unique Users"
    description: "Number of Unique Users identified via Anonymous ID from Segment"
    hidden:  no
    type: count_distinct
    sql: ${anonymous_id};;
    value_format_name: decimal_0
  }

  measure: count_addtocart_from_home {
    label: "count addtocart from home"
    description: "Count number of events where productAddedToCart was preceded by homeViewed"
    type: count
    filters: [event: "product_added_to_cart", previous_event: "home_viewed"]
  }

  measure: count_productsearchviewed_from_home {
    label: "count productsearchviewed from home"
    description: "Count number of events where productSearchViewed was preceded by homeViewed"
    type: count
    filters: [event: "product_search_viewed", previous_event: "home_viewed"]
  }

  measure: count_categoryselection_from_home {
    label: "count categoryselection from home"
    description: "Count number of events where categorySelected was preceded by homeViewed"
    type: count
    filters: [event: "category_selected", previous_event: "home_viewed"]
  }

  measure: count_categoryselection_from_grid {
    label: "count categoryselection from grid"
    description: "Count number of events where categorySelected was preceded by categoriesGridViewed"
    type: count
    filters: [event: "category_selected", previous_event: "categories_grid_viewed"]
  }

  measure: count_showmore_categories {
    label: "count show more categories"
    description: "Count number of times show more was tapped on the home screen to show more categories"
    type: count
    filters: [event: "categories_show_more_selected"]
  }

  measure: count_home_viewed {
    label: "count home viewed"
    description: "Count number of times home screen was viewed"
    type: count
    filters: [event: "home_viewed"]
  }

  measure: count_voucher_attempts {
    label: "count voucher attempts"
    description: "Count number of times voucher attempts appeared"
    type: count
    filters: [event: "voucher_redemption_attempted"]
  }

  ###################

  measure: count {
    type: count
    description: "Counts the number of events"
    drill_fields: [detail*]
  }

  dimension: anonymous_id {
    type: string
    description: "ID generated by Segment - proxy for user id. Is reset if user uninstalls."
    sql: ${TABLE}.anonymous_id ;;
  }

  dimension: context_app_build {
    type: string
    description: "Build of the app that generated the event. Together with app_version and device_type, uniquely identifies the app build that was used"
    sql: ${TABLE}.context_app_build ;;
  }

  dimension: context_app_version {
    type: string
    description: "Which version of the app sent the event"
    sql: ${TABLE}.context_app_version ;;
  }

  dimension: context_device_ad_tracking_enabled {
    type: yesno
    hidden: yes
    sql: ${TABLE}.context_device_ad_tracking_enabled ;;
  }

  dimension: context_device_model {
    type: string
    description: "Device model (e.g. x86_64)"
    sql: ${TABLE}.context_device_model ;;
  }

  dimension: context_device_name {
    type: string
    description: "Device name (e.g. iPhone)"
    sql: ${TABLE}.context_device_name ;;
  }

  dimension: context_device_type {
    type: string
    description: "Device name (e.g. ios)"
    sql: ${TABLE}.context_device_type ;;
  }

  dimension: context_locale {
    type: string
    description: "Language and location string from device (e.g. de-US)"
    sql: ${TABLE}.context_locale ;;
  }

  dimension: country_iso {
    type: string
    description: "Country of device (derived from locale)"
    sql: ${TABLE}.country_iso ;;
  }


  dimension: context_timezone {
    type: string
    description: "Timezone of user (e.g. Europe/Berlin)"
    sql: ${TABLE}.context_timezone ;;
  }

  dimension: event {
    type: string
    description: "tracking event that occurred in snake_case"
    sql: ${TABLE}.event ;;
  }

  dimension: event_text {
    type: string
    description: "tracking event that occurred with original naming. For our tracking events, that's camelCase"
    sql: ${TABLE}.event_text ;;
  }

  dimension: id {
    type: string
    hidden:  yes
    primary_key: yes
    sql: ${TABLE}.id ;;
  }

  dimension_group: timestamp {
    type: time
    description: "Datetime at which the event occurred"
    sql: ${TABLE}.timestamp ;;
  }

  dimension: previous_event {
    type: string
    description: "Tracking event that happened before the current event for this user (by anonymous ID). Null if it's the first event of the user"
    sql: ${TABLE}.previous_event ;;
  }

  dimension: next_event {
    type: string
    description: "Tracking event that happened after the current event for this user (by anonymous ID). Null if it's the last event of the user"
    sql: ${TABLE}.next_event ;;
  }

  set: detail {
    fields: [
      anonymous_id,
      context_app_build,
      context_app_version,
      context_device_ad_tracking_enabled,
      context_device_model,
      context_device_name,
      context_device_type,
      context_locale,
      context_timezone,
      country_iso,
      event,
      event_text,
      id,
      timestamp_time,
      previous_event,
      next_event
    ]
  }
}
