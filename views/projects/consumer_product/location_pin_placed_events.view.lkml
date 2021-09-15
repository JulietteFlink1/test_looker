view: location_pin_placed_events {
  derived_table: {
    sql: WITH events_tb AS (
      SELECT
                  tracks.anonymous_id
                , tracks.context_app_version
                , tracks.context_device_type
                , tracks.context_locale
                , tracks.event
                , tracks.event_text
                , tracks.id
                , tracks.delivery_lat
                , tracks.delivery_lng
                , tracks.user_area_available
                , tracks.timestamp
                , SPLIT(SAFE_CONVERT_BYTES_TO_STRING(FROM_BASE64(regexp_extract(hub_code, "^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/][AQgw]==|[A-Za-z0-9+/]{2}[AEIMQUYcgkosw048]=)?$"))),':')[
              OFFSET
                (1)] AS hub_id
              FROM
                `flink-data-prod.flink_ios_production.location_pin_placed_view` tracks
              WHERE
                tracks.event NOT LIKE "%api%"
                AND tracks.event NOT LIKE "%adjust%"
                AND tracks.event NOT LIKE "%install_attributed%"
                AND NOT (tracks.context_app_version LIKE "%APP-RATING%" OR tracks.context_app_version LIKE "%DEBUG%")
                AND NOT (tracks.context_app_name = "Flink-Staging" OR tracks.context_app_name="Flink-Debug")
          UNION ALL
              SELECT -- android all events
                  tracks.anonymous_id
                , tracks.context_app_version
                , tracks.context_device_type
                , tracks.context_locale
                , tracks.event
                , tracks.event_text
                , tracks.id
                , tracks.delivery_lat
                , tracks.delivery_lng
                , tracks.user_area_available
                , tracks.timestamp
                , SPLIT(SAFE_CONVERT_BYTES_TO_STRING(FROM_BASE64(regexp_extract(hub_code, "^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/][AQgw]==|[A-Za-z0-9+/]{2}[AEIMQUYcgkosw048]=)?$"))),':')[
              OFFSET
                (1)] AS hub_id
                FROM `flink-data-prod.flink_android_production.location_pin_placed_view` tracks
              WHERE
                tracks.event NOT LIKE "%api%"
                AND tracks.event NOT LIKE "%adjust%"
                AND tracks.event NOT LIKE "%install_attributed%"
                AND NOT (tracks.context_app_version LIKE "%APP-RATING%" OR tracks.context_app_version LIKE "%DEBUG%")
                AND NOT (tracks.context_app_name = "Flink-Staging" OR tracks.context_app_name="Flink-Debug")
      )

              SELECT
                events_tb.*
                -- translate the hub-id into hub-code
                , hub.slug AS hub_code
              FROM
                events_tb
              LEFT JOIN
                `flink-data-prod.saleor_prod_global.warehouse_warehouse` AS hub
              ON
                events_tb.hub_id = hub.id
 ;;
  }

  dimension: full_app_version {
    type: string
    sql: ${context_device_type} || '-' || ${context_app_version} ;;
  }

  dimension: full_coordinates {
    type: string
    sql: ${delivery_lat} || '-' || ${delivery_lng} ;;
  }

  measure: cnt_unavailable_area {
    label: "User Area Available False count"
    description: "Number of Location Pin Placed where user_area_available is False"
    type: count
    filters: [user_area_available: "no"]
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: location_coordinates {
    type: location
    sql_latitude:${delivery_lat} ;;
    sql_longitude:${delivery_lng} ;;
  }


  dimension: anonymous_id {
    type: string
    sql: ${TABLE}.anonymous_id ;;
  }

  dimension: context_app_version {
    type: string
    sql: ${TABLE}.context_app_version ;;
  }

  dimension: context_device_type {
    type: string
    sql: ${TABLE}.context_device_type ;;
  }

  dimension: context_locale {
    type: string
    sql: ${TABLE}.context_locale ;;
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
    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}.id ;;
  }

  dimension: delivery_lat {
    type: number
    sql: ${TABLE}.delivery_lat ;;
  }

  dimension: delivery_lng {
    type: number
    sql: ${TABLE}.delivery_lng ;;
  }

  dimension: user_area_available {
    type: yesno
    sql: ${TABLE}.user_area_available ;;
  }

  dimension_group: timestamp {
    type: time
    sql: ${TABLE}.timestamp ;;
  }

  dimension: hub_id {
    type: string
    sql: ${TABLE}.hub_id ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  set: detail {
    fields: [
      anonymous_id,
      context_app_version,
      context_device_type,
      context_locale,
      event,
      event_text,
      id,
      delivery_lat,
      delivery_lng,
      user_area_available,
      timestamp_time,
      hub_id,
      hub_code
    ]
  }
}
