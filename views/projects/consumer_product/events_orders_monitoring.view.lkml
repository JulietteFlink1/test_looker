view: events_orders_monitoring {
  derived_table: {
    sql: WITH base AS (

      # ANDROID
          SELECT DATE(t.timestamp) AS event_date,
                 t.id,
                 t.anonymous_id,
                 t.event,
                 "app" as platform,
                 LOWER(t.context_device_type) AS os,
                 t.context_os_version AS os_version,
                 t.context_app_version AS app_version,
                 t.timestamp,
                 COALESCE(a.hub_city, o.hub_city) AS hub_city,
                 h.country_iso,
                 h.country_iso || o.order_id as order_uuid,
                 o.order_id,
                 CAST(o.order_number AS STRING) as order_number,
                 o.payment_method,
                 false as is_backend
          FROM `flink-data-prod.flink_android_production.tracks_view` t
          LEFT JOIN `flink-data-prod.flink_android_production.address_confirmed_view` a ON a.id = t.id
          LEFT JOIN `flink-data-prod.flink_android_production.order_placed_view` o ON o.id = t.id
          LEFT JOIN `flink-data-prod.google_sheets.hub_metadata` h ON h.city = COALESCE(a.hub_city, o.hub_city)
          # WHERE {% condition event_date %} t.timestamp {% endcondition %}

          UNION ALL

      # iOS
          SELECT DATE(t.timestamp) AS event_date,
                 t.id,
                 t.anonymous_id,
                 t.event,
                 "app" as platform,
                 LOWER(t.context_device_type) AS os,
                 t.context_os_version AS os_version,
                 t.context_app_version AS app_version,
                 t.timestamp,
                 COALESCE(a.hub_city, o.hub_city) AS hub_city,
                 h.country_iso,
                 h.country_iso || o.order_id as order_uuid,
                 o.order_id,
                 CAST(o.order_number AS STRING) as order_number,
                 o.payment_method,
                 false as is_backend
          FROM `flink-data-prod.flink_ios_production.tracks_view` t
          LEFT JOIN `flink-data-prod.flink_ios_production.address_confirmed_view` a ON a.id = t.id
          LEFT JOIN `flink-data-prod.flink_ios_production.order_placed_view` o ON o.id = t.id
          LEFT JOIN `flink-data-prod.google_sheets.hub_metadata` h ON h.city = COALESCE(a.hub_city, o.hub_city)

          UNION ALL

      # WEB
          SELECT DATE(t.timestamp) AS event_date,
                 t.id,
                 t.anonymous_id,
                 t.event,
                 "web" as platform,
                 "web" AS os,
                 null AS os_version,
                 null AS app_version,
                 t.timestamp,
                 COALESCE(a.hub_city, o.hub_city) AS hub_city,
                 h.country_iso,
                 h.country_iso || o.order_id as order_uuid,
                 o.order_id,
                 CAST(o.order_number AS STRING) as order_number,
                 null as payment_method,
                 false as is_backend
          FROM `flink-data-prod.flink_website_production.tracks_view` t
          LEFT JOIN `flink-data-prod.flink_website_production.address_confirmed_view` a ON a.id = t.id
          LEFT JOIN `flink-data-prod.flink_website_production.order_completed_view` o ON o.id = t.id
          LEFT JOIN `flink-data-prod.google_sheets.hub_metadata` h ON h.city = COALESCE(a.hub_city, o.hub_city)

           UNION ALL

      # BACKEND
        SELECT   DATE(order_timestamp) AS event_date,
                 null as id,
                 anonymous_id,
                 "backend_order" as event,
                 "backend" as platform,
                 lower(platform) AS os,
                 null AS os_version,
                 null AS app_version,
                 order_timestamp as timestamp,
                 regexp_extract(substr(hub_name, 6), '[a-zA-Z0-9]+') AS hub_city,
                 country_iso,
                 order_uuid as order_uuid,
                 order_uuid as order_id,
                 order_number as order_number,
                 payment_method,
                 true as is_backend
        FROM `flink-data-prod.curated.orders`
        # WHERE DATE(order_timestamp) = date_sub(current_date(), interval 60 day)  -- equivalent to the _view

      )
        SELECT *
              # case when platform = 'backend' then true else false end as is_backend
          FROM base
       ;;
  }

# MEASURES

  measure: count_all {
    type: count
    drill_fields: [detail*]
  }

  measure: unique_users {
    type: count_distinct
    sql: ${anonymous_id} ;;
    value_format_name: decimal_0
  }

  measure: avg_events_per_user {
    type: number
    sql: ${count_all} / ${unique_users} ;;
    value_format_name: decimal_2
  }

  measure: all_orders {
    group_label: "Orders"
    type: count_distinct
    sql: ${order_number} ;;
  }

  measure: backend_orders {
    group_label: "Orders"
    type: count_distinct
    sql:  ${order_uuid} ;;
    filters: [is_backend: "yes"]
  }

  measure: client_orders {
    group_label: "Orders"
    type: count_distinct
    sql:  ${order_uuid} ;;
    filters:[is_backend: "no"]
  }

# DIMENSIONS

  dimension_group: event {
    label: "Event"
    group_label: "* Dates and Timestamps *"
    description: "Acqusition Date"
    type: time
    timeframes: [
      date,
      day_of_week,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.timestamp ;;
    datatype: timestamp
  }

  dimension: anonymous_id {
    type: string
    sql: ${TABLE}.anonymous_id ;;
  }

  dimension: platform {
    type: string
    sql: ${TABLE}.platform ;;
  }

  dimension: os {
    type: string
    sql: ${TABLE}.os ;;
  }

  dimension: os_version {
    type: string
    sql: ${TABLE}.os_version ;;
  }

  dimension: app_version {
    type: string
    sql: ${TABLE}.app_version ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: hub_city {
    type: string
    sql: ${TABLE}.hub_city ;;
  }

  dimension: event_name {
    type: string
    sql: ${TABLE}.event ;;
  }

  dimension: order_uuid {
    type: string
    sql: ${TABLE}.order_uuid ;;
  }

  dimension: order_id {
    type: string
    sql: ${TABLE}.order_id ;;
  }

  dimension: order_number {
    type: number
    sql: ${TABLE}.order_number ;;
  }

  dimension: payment_method {
    type: string
    sql: ${TABLE}.payment_method ;;
  }

  dimension: status {
    type: number
    sql: ${TABLE}.status ;;
  }

  dimension: is_backend {
    type: yesno
    sql: ${TABLE}.is_backend ;;
  }

  dimension: country_yes_no {
    type: string
    sql: CASE
          WHEN ${TABLE}.country_iso IS NULL THEN 'undefined'
          ELSE 'defined'
          END ;;
  }


  set: detail {
    fields: [
      event_date,
      anonymous_id,
      platform,
      os,
      os_version,
      app_version,
      country_iso,
      hub_city,
      event_name,
      order_uuid,
      order_id,
      order_number,
      payment_method,
      status,
      country_yes_no
    ]
  }
}
