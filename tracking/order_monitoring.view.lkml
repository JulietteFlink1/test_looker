view: order_monitoring {
  derived_table: {
    sql: WITH app_data AS (
      SELECT context_app_version, context_device_type, hub_city, country_iso, order_id, order_number
      FROM `flink-backend.flink_android_production.order_placed_view` a
      LEFT JOIN `flink-backend.gsheet_store_metadata.hubs` h ON h.city = a.hub_city

      UNION ALL
      SELECT context_app_version, context_device_type, hub_city, country_iso, order_id, order_number
      FROM `flink-backend.flink_ios_production.order_placed_view` i
      LEFT JOIN `flink-backend.gsheet_store_metadata.hubs`h ON h.city = i.hub_city
      )

      SELECT DATE(s.created) AS date, s.country_iso, a.hub_city, a.context_app_version AS app_version, a.context_device_type AS os, COUNT(*) AS backend_orders, COUNT(order_number) AS in_app_orders
      FROM  `flink-backend.saleor_db_global.order_order` s
      LEFT JOIN app_data a ON s.id = CAST(a.order_number AS INT64)
           AND s.country_iso = a.country_iso
      WHERE DATE(s.created) > '2021-06-16'
      GROUP BY 1,2,3,4,5
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: date {
    type: date
    datatype: date
    sql: ${TABLE}.date ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: hub_city {
    type: string
    sql: ${TABLE}.hub_city ;;
  }

  dimension: app_version {
    type: string
    sql: ${TABLE}.app_version ;;
  }

  dimension: os {
    type: string
    sql: ${TABLE}.os ;;
  }

  dimension: backend_orders {
    type: number
    sql: ${TABLE}.backend_orders ;;
  }

  dimension: in_app_orders {
    type: number
    sql: ${TABLE}.in_app_orders ;;
  }

  set: detail {
    fields: [
      date,
      country_iso,
      hub_city,
      app_version,
      os,
      backend_orders,
      in_app_orders
    ]
  }
}
