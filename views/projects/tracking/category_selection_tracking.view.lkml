view: category_selection_tracking {
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
          `flink-backend.flink_android_production.tracks_view` tracks
          WHERE
            tracks.event NOT LIKE "%api%"
            AND tracks.event NOT LIKE "%deep_link%"
            AND tracks.event NOT LIKE "%adjust%"
            AND tracks.event NOT LIKE "%install_attributed%"
            AND NOT (tracks.context_app_version LIKE "%APP-RATING%" OR tracks.context_app_version LIKE "%DEBUG%")
            AND NOT (tracks.context_app_name = "Flink-Staging" OR tracks.context_app_name="Flink-Debug")

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
          `flink-backend.flink_ios_production.tracks_view` tracks
          WHERE
            tracks.event NOT LIKE "%api%"
            AND tracks.event NOT LIKE "%deep_link%"
            AND tracks.event NOT LIKE "%adjust%"
            AND tracks.event NOT LIKE "%install_attributed%"
            AND NOT (tracks.context_app_version LIKE "%APP-RATING%" OR tracks.context_app_version LIKE "%DEBUG%")
            AND NOT (tracks.context_app_name = "Flink-Staging" OR tracks.context_app_name="Flink-Debug")
      ),
      previousevents_tb AS (
      SELECT *, LAG(joined_table.event) OVER(PARTITION BY joined_table.anonymous_id ORDER BY joined_table.timestamp ASC) AS previous_event
      FROM joined_table )
      SELECT * FROM previousevents_tb
       ;;
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

  dimension: context_locale {
    type: string
    sql: ${TABLE}.context_locale ;;
  }

  dimension: context_timezone {
    type: string
    sql: ${TABLE}.context_timezone ;;
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

  dimension_group: timestamp {
    type: time
    sql: ${TABLE}.timestamp ;;
  }

  dimension: previous_event {
    type: string
    sql: ${TABLE}.previous_event ;;
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
      event,
      event_text,
      id,
      timestamp_time,
      previous_event
    ]
  }
}
