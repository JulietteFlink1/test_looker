view: events_orders_monitoring {
  derived_table: {
    sql: WITH apps AS
        (
          SELECT DATE(t.timestamp) AS event_date,
                 t.id,
                 t.anonymous_id,
                 t.event,
                 LOWER(t.context_device_type) AS os,
                 t.context_os_version AS os_version,
                 t.context_app_version AS app_version,
                 t.timestamp,
                 COALESCE(a.hub_city, o.hub_city) AS hub_city,
                 h.country_iso,
                 o.order_id,
                 CAST(o.order_number AS STRING) as order_number,
                 o.payment_method
          FROM `flink-backend.flink_android_production.tracks_view` t
          LEFT JOIN `flink-backend.flink_android_production.address_confirmed_view` a ON a.id = t.id
          LEFT JOIN `flink-backend.flink_android_production.order_placed_view` o ON o.id = t.id
          LEFT JOIN `flink-backend.gsheet_store_metadata.hubs` h ON h.city = COALESCE(a.hub_city, o.hub_city)
          WHERE {% condition event_date %} date(t.timestamp) {% endcondition %}

          UNION ALL

          SELECT DATE(t.timestamp) AS event_date,
                 t.id,
                 t.anonymous_id,
                 t.event,
                 LOWER(t.context_device_type) AS os,
                 t.context_os_version AS os_version,
                 t.context_app_version AS app_version,
                 t.timestamp,
                 COALESCE(a.hub_city, o.hub_city) AS hub_city,
                 h.country_iso,
                 o.order_id,
                 CAST(o.order_number AS STRING) as order_number,
                 o.payment_method
          FROM `flink-backend.flink_ios_production.tracks_view` t
          LEFT JOIN `flink-backend.flink_ios_production.address_confirmed_view` a ON a.id = t.id
          LEFT JOIN `flink-backend.flink_ios_production.order_placed_view` o ON o.id = t.id
          LEFT JOIN `flink-backend.gsheet_store_metadata.hubs` h ON h.city = COALESCE(a.hub_city, o.hub_city)
          WHERE {% condition event_date %} date(t.timestamp) {% endcondition %}
        ),
        saleor AS (
        SELECT created, tracking_client_id, country_iso, CAST(id AS STRING) AS id, status
        FROM `flink-backend.saleor_db_global.order_order`
        WHERE {% condition event_date %} DATE(created) {% endcondition %}
        )

          SELECT COALESCE(event_date, DATE(sg.created)) AS event_date,
                 COALESCE(anonymous_id, sg.tracking_client_id) AS anonymous_id,
                 os,
                 os_version,
                 app_version,
                 COALESCE(apps.country_iso, sg.country_iso) AS iso_country,
                 hub_city,
                 event,
                 order_id,
                 COALESCE(sg.id, apps.order_number) AS order_number,
                 payment_method,
                 status
          FROM apps
          FULL OUTER JOIN saleor sg ON sg.id = apps.order_number AND sg.country_iso = apps.country_iso
         -- WHERE {% condition event_date %} COALESCE(event_date, DATE(sg.created)) {% endcondition %}
          GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12
          ORDER BY 1, 2, order_number
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

  measure: client_orders {
    group_label: "Orders"
    type: count_distinct
    sql:  ${order_id} ;;
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
    sql: ${TABLE}.event_date ;;
    datatype: date
  }

  dimension: anonymous_id {
    type: string
    sql: ${TABLE}.anonymous_id ;;
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

  dimension: iso_country {
    type: string
    sql: ${TABLE}.iso_country ;;
  }

  dimension: hub_city {
    type: string
    sql: ${TABLE}.hub_city ;;
  }

  dimension: event_name {
    type: string
    sql: ${TABLE}.event ;;
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


  dimension: country_yes_no {
    type: string
    sql: CASE
          WHEN ${TABLE}.iso_country IS NULL THEN 'undefined'
          ELSE 'defined'
          END ;;
  }


  set: detail {
    fields: [
      event_date,
      anonymous_id,
      os,
      os_version,
      app_version,
      iso_country,
      hub_city,
      event_name,
      order_id,
      order_number,
      payment_method,
      status,
      country_yes_no
    ]
  }
}
