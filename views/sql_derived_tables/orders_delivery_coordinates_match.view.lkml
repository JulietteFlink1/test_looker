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
          where date(o.order_timestamp) >= '2021-10-18'
      ),

      -- keep track whether / when the delivery area became obsolete. Assumes that delivery_area is_live_coordinates is true from update_timestamp onwards and stops being true upon the next update
      delivery_areas AS (
          SELECT *,
          LEAD(update_timestamp) OVER (PARTITION BY hub_code ORDER BY update_timestamp ASC) AS next_update
          FROM `flink-data-prod.curated.hub_delivery_areas`
          WHERE hub_delivery_area IS NOT NULL
      ),

joined_tb AS (
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
      ST_DISTANCE(backend_customer_location , client_customer_location ) AS client_backend_location_distance,
      hda.hub_delivery_area,
      hda.hub_delivery_area_geojson,
      ST_Y(hda.hub_point) AS hub_latitude,
      ST_X(hda.hub_point) AS hub_longitude,
      hda.update_timestamp,
      ST_COVERS(ST_GEOGFROMGEOJSON(hub_delivery_area_geojson),ST_GEOGPOINT(customer_longitude, customer_latitude)) AS backend_covered_by_hub_area,
      ST_COVERS(ST_GEOGFROMGEOJSON(hub_delivery_area_geojson),ST_GEOGPOINT(ft.delivery_lng , ft.delivery_lat)) AS client_covered_by_hub_area,
      bo.order_timestamp >= hda.update_timestamp AND (bo.order_timestamp < hda.next_update OR hda.next_update IS NULL) AS is_current_hub_area
      FROM backend_orders bo
      LEFT JOIN frontend_tracking ft
      ON bo.order_number=ft.order_number
      -- note that hub_slug is the hub from frontend and hub_code is the hub from backend. Frontend misses around ~4% of orders so for those hub_slug would not be populated
      LEFT JOIN delivery_areas hda
      ON bo.hub_code=hda.hub_code
),

tag_tb AS (
SELECT *,
MAX(backend_covered_by_hub_area) OVER (PARTITION BY order_number) AS backend_ever_covered,
MAX(client_covered_by_hub_area) OVER (PARTITION BY order_number) AS client_ever_covered
FROM joined_tb
)

SELECT * FROM tag_tb
WHERE is_current_hub_area IS TRUE
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

  dimension: backend_covered_by_hub_area {
    hidden: yes
    type: yesno
    label: "Covered By Hub Area (Backend)"
    sql: ${TABLE}.backend_covered_by_hub_area;;
  }

  dimension: client_covered_by_hub_area {
    hidden: yes
    type: yesno
    label: "Covered By Hub Area (Client)"
    sql: ${TABLE}.client_covered_by_hub_area;;
  }

  dimension: backend_ever_covered {
    hidden: yes
    type: yesno
    label: "Covered In Non-current Hub Version Only (Backend)"
    sql: ${TABLE}.backend_ever_covered;;
  }

  dimension: client_ever_covered {
    hidden: yes
    type: yesno
    label: "Covered In Non-current Hub Version Only (Client)"
    sql: ${TABLE}.client_ever_covered;;
  }

  # dimension: backend_inside_hub_area {
  #   hidden: yes
  #   type: yesno
  #   label: "Covered By Hub Area (Backend)"
  #   sql: ST_CONTAINS(ST_GEOGFROMGEOJSON(${hub_delivery_area_geojson}),ST_GEOGPOINT(${customer_longitude}, ${customer_latitude})) ;;
  # }

  # dimension: client_inside_hub_area {
  #   hidden: yes
  #   type: yesno
  #   label: "Covered By Hub Area (Client)"
  #   sql: ST_CONTAINS(ST_GEOGFROMGEOJSON(${hub_delivery_area_geojson}),ST_GEOGPOINT(${delivery_lng}, ${delivery_lat})) ;;
  # }

  dimension: covered_by_hub_area {
    type: string
    sql: CASE
          WHEN (${client_covered_by_hub_area} OR ${backend_covered_by_hub_area}) THEN "Within Assigned Hub Area"
          WHEN (${client_ever_covered} OR ${backend_ever_covered}) THEN "Within Non-Current Assigned Hub Area"
          ELSE "Not Within Assigned Hub Area"
        END;;
  }

  # dimension: inside_hub_area {
  #   type: string
  #   sql: CASE
  #         WHEN ${client_inside_hub_area} AND ${backend_inside_hub_area} THEN "Inside (Client & Backend)"
  #         WHEN ${client_inside_hub_area} THEN "Inside (Client only)"
  #         WHEN ${backend_inside_hub_area} THEN "Inside (Backend only)"
  #         ELSE "Not Inside"
  #       END;;
  # }

  measure: cnt_not_covered_by_hub_area {
    description: "count number of orders where the discrepancy between backend and client location is larger than 20m"
    type: count
    filters: [covered_by_hub_area: "Not Within Assigned Hub Area"]
  }

  measure: perc_not_covered_by_hub_area {
    description: "% of orders where the discrepancy between backend and client location is larger than 20m"
    type: number
    sql: ${cnt_not_covered_by_hub_area}/${count} ;;
    value_format_name: percent_2
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
    group_label: "> Backend Data"
  }

  dimension: order_number {
    type: string
    sql: ${TABLE}.order_number ;;
  }

  dimension_group: order_timestamp {
    type: time
    sql: ${TABLE}.order_timestamp ;;
    group_label: "> Backend Data"
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
    group_label: "> Backend Data"
  }

  dimension: hub_latitude {
    type: number
    sql: ${TABLE}.hub_latitude ;;
    group_label: "> Hub Area"
  }

  dimension: hub_longitude {
    type: number
    sql: ${TABLE}.hub_longitude ;;
    group_label: "> Hub Area"
  }

  dimension: hub_location {
    type: location
    sql_latitude: ${hub_latitude} ;;
    sql_longitude: ${hub_longitude} ;;
    group_label: "> Hub Area"
  }

  dimension: hub_to_customer_distance {
    type: distance
    start_location_field: backend_customer_location
    end_location_field: hub_location
    label: "Customer To Hub Distance In Meters (Backend)"
    units: kilometers
  }

  dimension: delivery_id {
    type: string
    sql: ${TABLE}.delivery_id ;;
    group_label: "> Backend Data"
  }

  dimension: backend_customer_location {
    type: location
    sql_latitude: ${customer_latitude} ;;
    sql_longitude: ${customer_longitude} ;;
    group_label: "> Backend Data"
  }

  dimension: order_id {
    type: string
    sql: ${TABLE}.order_id ;;
    group_label: "> Client Data"
  }

  dimension_group: timestamp {
    type: time
    sql: ${TABLE}.timestamp ;;
    group_label: "> Client Data"
  }

  dimension: delivery_eta {
    type: number
    sql: ${TABLE}.delivery_eta ;;
    group_label: "> Client Data"
  }

  dimension: anonymous_id {
    type: string
    sql: ${TABLE}.anonymous_id ;;
    group_label: "> Client Data"
  }

  dimension: delivery_lat {
    type: number
    label: "Delivery Lat (Client)"
    sql: ${TABLE}.delivery_lat ;;
    group_label: "> Client Data"
  }

  dimension: delivery_lng {
    type: number
    label: "Delivery Lng (Client)"
    sql: ${TABLE}.delivery_lng ;;
    group_label: "> Client Data"
  }

  dimension: customer_latitude {
    type: number
    label: "Delivery Lat (Backend)"
    sql: ${TABLE}.customer_latitude ;;
    group_label: "> Backend Data"
  }

  dimension: customer_longitude {
    type: number
    label: "Delivery Lng (Backend)"
    sql: ${TABLE}.customer_longitude ;;
    group_label: "> Backend Data"
  }

  dimension: hub_city {
    type: string
    sql: ${TABLE}.hub_city ;;
    group_label: "> Client Data"
  }

  dimension: hub_slug {
    type: string
    sql: ${TABLE}.hub_slug ;;
    group_label: "> Client Data"
  }

  dimension: platform_type {
    type: string
    sql: ${TABLE}.platform_type ;;
    group_label: "> Client Data"
  }

  dimension: client_customer_location {
    type: location
    sql_latitude: ${delivery_lat} ;;
    sql_longitude: ${delivery_lng} ;;
    group_label: "> Client Data"
  }

  dimension: client_backend_location_distance {
    type: number
    sql: ${TABLE}.client_backend_location_distance ;;
    group_label: "> Backend Data"
  }

  dimension: hub_delivery_area {
    type: string
    sql: ${TABLE}.hub_delivery_area ;;
    group_label: "> Hub Area"
  }

  dimension: hub_delivery_area_geojson {
    type: string
    sql: ${TABLE}.hub_delivery_area_geojson ;;
    group_label: "> Hub Area"
  }

  dimension_group: update_timestamp {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.update_timestamp ;;
    group_label: "> Hub Area"
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
      client_backend_location_distance,
      hub_delivery_area,
      hub_delivery_area_geojson
    ]
  }
}
