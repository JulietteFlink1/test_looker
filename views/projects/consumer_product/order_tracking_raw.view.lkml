view: order_tracking_raw {
  derived_table: {
    sql: WITH pretracks_tb AS (
        SELECT tracks.anonymous_id,
        tracks.timestamp,
        IF(tracks.event="purchase_confirmed", "payment_started", tracks.event) AS event,
        tracks.id,
        tracks.context_app_version,
        tracks.context_device_type,
        tracks.context_os_version
        FROM `flink-data-prod.flink_android_production.tracks` tracks
        WHERE tracks.event NOT LIKE "api%" AND tracks.event NOT LIKE "deep_link%"
        AND event IN ("contact_customer_service_selected", "order_tracking_viewed")
        AND _PARTITIONTIME="2021-09-09"
        UNION ALL

        SELECT tracks.anonymous_id,
        tracks.timestamp,
        IF(tracks.event="purchase_confirmed", "payment_started", tracks.event) AS event,
        tracks.id,
        tracks.context_app_version,
        tracks.context_device_type,
        tracks.context_os_version
        FROM `flink-data-prod.flink_ios_production.tracks` tracks
        WHERE tracks.event NOT LIKE "api%" AND tracks.event NOT LIKE "deep_link%"
        AND event IN ("contact_customer_service_selected", "order_tracking_viewed")
        AND _PARTITIONTIME="2021-09-09"
      ),

      -- identify which "automatic" events for order_tracking_viewed to exclude
      -- TODO currently can only do this for android, need this for iOS (also for automatically triggered later ones in ios)
        exclude_from_tracks AS (
        SELECT id
        FROM `flink-data-prod.flink_android_production.order_tracking_viewed_view`
        WHERE origin_screen="payment"
      ),

      tracks_tb AS (
        SELECT pretracks_tb.*
        FROM pretracks_tb
        LEFT JOIN exclude_from_tracks
        ON pretracks_tb.id=exclude_from_tracks.id
        WHERE exclude_from_tracks.id IS NULL
      ),

      -- combine order_tracking_viewed for ios and android for the relevant fields
      order_tracking_tb AS (
      SELECT
        ios_order.order_id,
        ios_order.order_number,
        ios_order.hub_slug,
        CAST(NULL AS STRING) AS country_iso,
        CAST(NULL AS STRING) AS order_status,
        CAST(NULL AS INT64) AS fulfillment_time,
        CAST(NULL AS STRING) AS delayed_component,
        ios_order.delivery_eta,
        ios_order.id
      FROM
        `flink-data-prod.flink_ios_production.order_tracking_viewed_view` ios_order
      UNION ALL
      SELECT
        android_order.order_id,
        android_order.order_number,
        android_order.hub_slug,
        android_order.country_iso,
        android_order.order_status,
        android_order.fulfillment_time,
        android_order.delayed_component,
        android_order.delivery_eta,
        android_order.id,
        FROM
            `flink-data-prod.flink_android_production.order_tracking_viewed_view` android_order
        ),

    -- combine order_placed for ios and android for the relevant fields
    -- some orders receive events twice, so need to make sure they're unique
    order_placed_tb AS (
    SELECT *
    FROM (
      SELECT
        ios_order.order_id,
        ios_order.order_number,
        SAFE_CAST(ios_order.delivery_eta AS INT64) AS delivery_eta,
        ios_order.hub_slug,
        ios_order.revenue,
        ios_order.voucher_value,
        ios_order.id,
        timestamp,
        ROW_NUMBER() OVER(PARTITION BY order_number ORDER BY timestamp ASC) AS row_id
      FROM
        `flink-data-prod.flink_ios_production.order_placed_view` ios_order
    )
    WHERE row_id=1
      UNION ALL
    SELECT *
    FROM (
      SELECT
        android_order.order_id,
        android_order.order_number,
        android_order.delivery_eta,
        android_order.hub_slug,
        android_order.revenue,
        android_order.voucher_value,
        android_order.id,
        timestamp,
        ROW_NUMBER() OVER(PARTITION BY order_number ORDER BY timestamp ASC) AS row_id
      FROM
        `flink-data-prod.flink_android_production.order_placed_view` android_order
    )
    WHERE row_id=1
    ),

    -- combine first_order_placed for ios and android for the relevant fields
    first_order_placed_tb AS (
      SELECT
        ios_order.order_number
      FROM
        `flink-data-prod.flink_ios_production.first_order_placed_view` ios_order
      UNION ALL
      SELECT
        android_order.order_number
      FROM
        `flink-data-prod.flink_android_production.first_order_placed_view` android_order
        ),

      -- TODO currently only available on android but will be there for ios soon (combine here when it's available)
      customer_service_intent_tb AS (
      SELECT
        android_csi.order_id,
        android_csi.order_number,
        android_csi.hub_slug,
        android_csi.country_iso,
        android_csi.order_status,
        android_csi.delivery_eta,
        android_csi.id
      FROM
        `flink-data-prod.flink_android_production.contact_customer_service_selected_view` android_csi
      ),

    -- with tracks table as a base, join the order_tracking_viewed, order_placed and contact_customer_service_selected tables for their respective information.
      -- for common fields, always take from order_placed first if available, then contact_customer_service_selected, then order_tracking_viewed, except for delivery_eta (because this will be dynamic soon, need to take it from order_tracking_viewed).
      joined_tb AS (
      SELECT
      tracks_tb.*
      , COALESCE(csi.order_id, ot.order_id) AS order_id
      , COALESCE(csi.order_number, ot.order_number) AS order_number
      , COALESCE(csi.hub_slug, ot.hub_slug) AS hub_slug
      , COALESCE(csi.country_iso, ot.country_iso) AS country_iso
      , COALESCE(csi.order_status, ot.order_status) AS order_status
      , COALESCE(csi.delivery_eta, ot.delivery_eta) AS delivery_eta
      , ot.delayed_component
      , ot.fulfillment_time
      FROM tracks_tb
      LEFT JOIN order_tracking_tb ot
      ON tracks_tb.id=ot.id
      LEFT JOIN customer_service_intent_tb csi
      ON tracks_tb.id=csi.id
      )

      SELECT
        joined_tb.*
        ,IF(joined_tb.order_number IN (SELECT first_order_placed_tb.order_number FROM first_order_placed_tb), TRUE, FALSE) AS is_first_order
        , order_placed_tb.delivery_eta AS order_placed_delivery_eta
        , order_placed_tb.timestamp AS order_placed_timestamp
      FROM joined_tb
      LEFT JOIN order_placed_tb
      -- there would be many row where this would match and in each row it should add the order_placed original info
      ON order_placed_tb.order_number=joined_tb.order_number
      ORDER BY timestamp DESC
 ;;
  }

  ### Custom measures
  measure: cnt_order_tracking_viewed {
    label: "# Order Tracking Viewed"
    description: "Number of Order Tracking Viewed"
    type: count
    filters: [event: "order_tracking_viewed"]
  }

  measure: cnt_help_intent {
    label: "# CCS Intent"
    description: "Number of times there was an intent to contact customer service"
    type: count
    filters: [event: "contact_customer_service_selected"]
  }

  dimension: time_since_order_duration{
    type: duration_minute
    sql_start: ${order_placed_timestamp_raw} ;;
    sql_end: ${timestamp_raw};;
  }

  dimension: timesdiff_to_pdt{
    type: number
    sql: ${time_since_order_duration}-${order_placed_delivery_eta};;
  }

  dimension: time_since_order_tiers {
    type: tier
    tiers: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 20, 25, 30, 45, 60]
    style: interval
    sql: ${time_since_order_duration} ;;
  }

  dimension: timesdiff_to_pdt_tiers {
    type: tier
    tiers: [-20,-16,-14,-12,-10,-8,-6,-4,-2, 0, 2, 4,6,8,10,12,14,16,20,24,30,45,60]
    style: interval
    sql: ${timesdiff_to_pdt} ;;
  }

  dimension: returning_customer {
    type: yesno
    sql: NOT(${is_first_order}) ;;
  }
  ###

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: anonymous_id {
    type: string
    sql: ${TABLE}.anonymous_id ;;
  }

  dimension_group: timestamp {
    type: time
    sql: ${TABLE}.timestamp ;;
  }

  dimension: event {
    type: string
    sql: ${TABLE}.event ;;
  }

  dimension: id {
    hidden: yes
    type: string
    sql: ${TABLE}.id ;;
  }

  dimension: context_app_version {
    type: string
    sql: ${TABLE}.context_app_version ;;
  }

  dimension: context_device_type {
    type: string
    sql: ${TABLE}.context_device_type ;;
  }

  dimension: context_os_version {
    type: string
    sql: ${TABLE}.context_os_version ;;
  }

  dimension: order_id {
    type: string
    sql: ${TABLE}.order_id ;;
  }

  dimension: order_number {
    type: string
    sql: ${TABLE}.order_number ;;
  }

  dimension: hub_slug {
    type: string
    sql: ${TABLE}.hub_slug ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: order_status {
    type: string
    sql: ${TABLE}.order_status ;;
  }

  dimension: delivery_eta {
    type: number
    sql: ${TABLE}.delivery_eta ;;
  }

  dimension: delayed_component {
    type: string
    sql: ${TABLE}.delayed_component ;;
  }

  dimension: fulfillment_time {
    type: number
    sql: ${TABLE}.fulfillment_time ;;
  }

  dimension: is_first_order {
    type: string
    sql: ${TABLE}.is_first_order ;;
  }

  dimension: order_placed_delivery_eta {
    type: number
    sql: ${TABLE}.order_placed_delivery_eta ;;
  }

  dimension_group: order_placed_timestamp {
    type: time
    sql: ${TABLE}.order_placed_timestamp ;;
  }

  set: detail {
    fields: [
      anonymous_id,
      timestamp_time,
      event,
      id,
      context_app_version,
      context_device_type,
      context_os_version,
      order_id,
      order_number,
      hub_slug,
      country_iso,
      order_status,
      delivery_eta,
      delayed_component,
      fulfillment_time,
      is_first_order,
      order_placed_delivery_eta,
      order_placed_timestamp_time
    ]
  }
}
