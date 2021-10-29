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
          WHERE _PARTITIONTIME > "2021-08-01"

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
          WHERE _PARTITIONTIME > "2021-08-01"
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
          o.customer_longitude,
          o.customer_latitude,
          ST_GEOGPOINT(o.customer_longitude, o.customer_latitude) AS backend_customer_location,
          from `flink-data-prod.curated.orders` o
          where date(o.order_timestamp) > '2021-08-01'
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

  ##### custom dimensions and measures

  dimension: location_diff_tiers {
    type: tier
    tiers: [0, 20, 50, 100, 500, 1000, 5000]
    style: integer
    sql: ${client_backend_location_distance} ;;
  }

  dimension: client_backend_location_distance_int {
    type: number
    label: "Client - Backend Discrepancy (Meters)"
    sql: ROUND(${TABLE}.client_backend_location_distance,0) ;;
  }

  measure: cnt_distance_greater_than_20 {
    description: "count number of orders where the discrepancy between backend and client location is larger than 20m"
    type: count
    filters: [client_backend_location_distance: ">20"]
  }

  measure: perc_distance_greater_than_20 {
    description: "% of orders where the discrepancy between backend and client location is larger than 20m"
    type: number
    sql: ${cnt_distance_greater_than_20}/${count} ;;
    value_format_name: percent_2
  }

  #####

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
    hidden: yes
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
    label: "Delivery Lat (Client)"
    sql: ${TABLE}.delivery_lat ;;
  }

  dimension: delivery_lng {
    type: number
    label: "Delivery Lng (Client)"
    sql: ${TABLE}.delivery_lng ;;
  }

  dimension: customer_latitude {
    type: number
    label: "Delivery Lat (Backend)"
    sql: ${TABLE}.customer_latitude ;;
  }

  dimension: customer_longitude {
    type: number
    label: "Delivery Lng (Backend)"
    sql: ${TABLE}.customer_longitude ;;
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
    hidden: yes
    sql: ${TABLE}.client_customer_location ;;
  }

  dimension: client_backend_location_distance {
    type: number
    hidden: yes
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
