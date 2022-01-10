view: tmp_rider_distances {
  derived_table: {
    sql: WITH tmp AS (
      SELECT *
      , ST_DISTANCE(customer_coor, rider_coor) AS bqdist
      FROM (
          SELECT
          o.country_iso,
          o.order_number,
          o.order_timestamp,
          o.hub_code,
          o.delivery_id,
          o.picking_completed_timestamp,
          o.rider_claimed_timestamp,
          o.rider_on_route_timestamp,
          o.rider_arrived_at_customer_timestamp,
          o.rider_completed_delivery_timestamp,
          ST_GEOGPOINT(o.customer_longitude, o.customer_latitude) AS customer_coor,
          ST_GEOGPOINT(e.lng, e.lat) AS rider_coor,
          e.ts AS rider_loc_timestamp,
          e.booking_id

          from `flink-data-prod.curated.orders` o
          left join `flink-data-prod.m_tribes_v1.rider_location_events` e ON o.delivery_id=e.booking_id

          where date(o.order_timestamp) >= '2021-10-01'
      ))

      SELECT *,
      FROM tmp
      WHERE TRUE
      QUALIFY DENSE_RANK() OVER (PARTITION BY booking_id ORDER BY bqdist ASC) = 1
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

  dimension: city {
    type: string
    sql: substring(${TABLE}.hub_code, 4,3) ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: delivery_id {
    type: string
    sql: ${TABLE}.delivery_id ;;
  }

  dimension_group: picking_completed_timestamp {
    type: time
    sql: ${TABLE}.picking_completed_timestamp ;;
  }

  dimension_group: rider_claimed_timestamp {
    type: time
    sql: ${TABLE}.rider_claimed_timestamp ;;
  }

  dimension_group: rider_on_route_timestamp {
    type: time
    sql: ${TABLE}.rider_on_route_timestamp ;;
  }

  dimension_group: rider_arrived_at_customer_timestamp {
    type: time
    sql: ${TABLE}.rider_arrived_at_customer_timestamp ;;
  }

  dimension_group: rider_completed_delivery_timestamp {
    type: time
    sql: ${TABLE}.rider_completed_delivery_timestamp ;;
  }

  dimension: customer_coor {
    type: string
    sql: ${TABLE}.customer_coor ;;
  }

  dimension: rider_coor {
    type: string
    sql: ${TABLE}.rider_coor ;;
  }

  dimension_group: rider_loc_timestamp {
    type: time
    sql: ${TABLE}.rider_loc_timestamp ;;
  }

  dimension: booking_id {
    type: string
    sql: ${TABLE}.booking_id ;;
  }

  dimension: bqdist {
    type: number
    sql: ${TABLE}.bqdist ;;
  }

  dimension: distance_tiers {
    label: "Min Rider Distance to Customer (m)"
    description: "Tiers of Min. Rider Distance"
    type: tier
    tiers: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 20, 25, 30, 40, 50, 75, 100, 200, 500]
    style: interval
    sql: ${bqdist} ;;
  }

  dimension: diff_order_delivery_duration {
    description: "difference (seconds) between the timestamp where rider is the closest to the customer and the rider_completed_delivery timestamp"
    type: duration_second
    sql_start: ${rider_completed_delivery_timestamp_raw} ;;
    sql_end: ${rider_loc_timestamp_raw} ;;
    }

  dimension: diff_order_delivery_duration_tiers {
    label: "Delivery Timestamp Diff (sec) Tiers"
    description: "Tiers of timestamp diff between shortest distance to customer and rider_completed_delivery"
    type: tier
    tiers: [-1800, -1500, -1200, -900, -600, -540, -480, -420, -360, -300, -270, -240, -210, -180, -150, -120, -90, -60, -45, -30, -15, 0, 15, 30, 45, 60, 90, 120, 150, 180, 210, 240, 270, 300, 360, 420, 480, 540, 600, 900, 1200, 1500, 1800, 3600]
    style: interval
    sql: ${diff_order_delivery_duration} ;;
  }

  set: detail {
    fields: [
      country_iso,
      order_number,
      order_timestamp_time,
      city,
      hub_code,
      delivery_id,
      picking_completed_timestamp_time,
      rider_claimed_timestamp_time,
      rider_on_route_timestamp_time,
      rider_arrived_at_customer_timestamp_time,
      rider_completed_delivery_timestamp_time,
      customer_coor,
      rider_coor,
      rider_loc_timestamp_time,
      booking_id,
      bqdist
    ]
  }
}
