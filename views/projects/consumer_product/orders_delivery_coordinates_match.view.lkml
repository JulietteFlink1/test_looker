view: orders_delivery_coordinates_match {
  derived_table: {
    sql: WITH order_tracking_viewed AS (
          SELECT
          order_number,
          order_id,
          timestamp,
          delivery_eta,
          anonymous_id,
          id,
          delivery_lat,
          delivery_lng,
          hub_city,
          hub_slug,
          context_device_type AS platform_type,
          ROW_NUMBER() OVER(PARTITION BY order_number ORDER BY timestamp) as row_number
          FROM `flink-data-prod.flink_android_production.order_tracking_viewed`
          WHERE _PARTITIONTIME > "2021-10-10"

          UNION ALL

          SELECT
          order_number,
          order_id,
          timestamp,
          delivery_eta,
          anonymous_id,
          id,
          delivery_lat,
          delivery_lng,
          hub_city,
          hub_slug,
          context_device_type AS platform_type,
          ROW_NUMBER() OVER(PARTITION BY order_number ORDER BY timestamp) as row_number
          FROM `flink-data-prod.flink_ios_production.order_tracking_viewed`
          WHERE _PARTITIONTIME > "2021-10-10"
      ),

      frontend_tracking AS (
      SELECT * EXCEPT(row_number)
      , ST_GEOGPOINT(delivery_lng, delivery_lat) AS client_customer_location
      FROM order_tracking_viewed
      WHERE row_number=1
      ),

      backend_orders AS(
      SELECT
          o.country_iso,
          o.order_number,
          o.order_timestamp,
          o.hub_code,
          o.delivery_id,
          ST_GEOGPOINT(o.customer_longitude, o.customer_latitude) AS backend_customer_location,
          from `flink-data-prod.curated.orders` o
          where date(o.order_timestamp) BETWEEN '2021-10-10' AND '2021-10-25'
      )

      SELECT
      bo.*,
      ft.order_id,
      ft.timestamp,
      ft.delivery_eta,
      ft.anonymous_id,
      ft.delivery_lat,
      ft.delivery_lng,
      ft.hub_city,
      ft.hub_slug,
      ft.platform_type,
      ft.client_customer_location ,
      ST_DISTANCE(backend_customer_location , client_customer_location ) AS client_backend_location_distance
      FROM backend_orders bo
      LEFT JOIN frontend_tracking ft
      ON bo.order_number=ft.order_number
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: order_number {
    type: string
    sql: ${TABLE}.order_number ;;
  }

  dimension_group: order_timestamp {
    type: time
    sql: ${TABLE}.order_timestamp ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: delivery_id {
    type: string
    sql: ${TABLE}.delivery_id ;;
  }

  dimension: backend_customer_location {
    type: string
    sql: ${TABLE}.backend_customer_location ;;
  }

  dimension: order_id {
    type: string
    sql: ${TABLE}.order_id ;;
  }

  dimension_group: timestamp {
    type: time
    sql: ${TABLE}.timestamp ;;
  }

  dimension: delivery_eta {
    type: number
    sql: ${TABLE}.delivery_eta ;;
  }

  dimension: anonymous_id {
    type: string
    sql: ${TABLE}.anonymous_id ;;
  }

  dimension: delivery_lat {
    type: number
    sql: ${TABLE}.delivery_lat ;;
  }

  dimension: delivery_lng {
    type: number
    sql: ${TABLE}.delivery_lng ;;
  }

  dimension: hub_city {
    type: string
    sql: ${TABLE}.hub_city ;;
  }

  dimension: hub_slug {
    type: string
    sql: ${TABLE}.hub_slug ;;
  }

  dimension: platform_type {
    type: string
    sql: ${TABLE}.platform_type ;;
  }

  dimension: client_customer_location {
    type: string
    sql: ${TABLE}.client_customer_location ;;
  }

  dimension: client_backend_location_distance {
    type: number
    sql: ${TABLE}.client_backend_location_distance ;;
  }

  set: detail {
    fields: [
      country_iso,
      order_number,
      order_timestamp_time,
      hub_code,
      delivery_id,
      backend_customer_location,
      order_id,
      timestamp_time,
      delivery_eta,
      anonymous_id,
      delivery_lat,
      delivery_lng,
      hub_city,
      hub_slug,
      platform_type,
      client_customer_location,
      client_backend_location_distance
    ]
  }
}
