view: postorder_tracking {
  derived_table: {
    sql: WITH tracks_tb AS (
        SELECT tracks.anonymous_id,
        tracks.timestamp,
        IF(tracks.event="purchase_confirmed", "payment_started", tracks.event) AS event,
        tracks.id,
        tracks.context_app_version,
        tracks.context_device_type,
        tracks.context_os_version
        FROM `flink-data-prod.flink_android_production.tracks` tracks
        WHERE tracks.event NOT LIKE "api%" AND tracks.event NOT LIKE "deep_link%"
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
      ),

      order_tracking_tb AS (
      SELECT
        ios_order.order_id,
        ios_order.order_number,
        ios_order.hub_slug,
        NULL AS country_iso,
        NULL AS order_status,
        NULL AS fulfillment_time,
        NULL AS delayed_component,
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
        android_order.id
      FROM
        `flink-data-prod.flink_android_production.order_tracking_viewed_view` android_order
        ),

    order_placed_tb AS (
      SELECT
        ios_order.order_id,
        ios_order.order_number,
        SAFE_CAST(ios_order.delivery_eta AS INT64) AS delivery_eta,
        ios_order.hub_slug,
        ios_order.revenue,
        ios_order.voucher_value,
        ios_order.id
      FROM
        `flink-data-prod.flink_ios_production.order_placed_view` ios_order
      UNION ALL
      SELECT
        android_order.order_id,
        android_order.order_number,
        android_order.delivery_eta,
        android_order.hub_slug,
        android_order.revenue,
        android_order.voucher_value,
        android_order.id
      FROM
        `flink-data-prod.flink_android_production.order_placed_view` android_order
        ),

      -- currently only available on android but will be there for ios soon
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

      joined_tb AS (
      SELECT
      tracks_tb.*
      , COALESCE(ot.order_id, csi.order_id, op.order_id) AS order_id
      , COALESCE(ot.order_number, csi.order_number, op.order_number) AS order_number
      , COALESCE(ot.hub_slug, csi.hub_slug, op.hub_slug) AS hub_slug
      , COALESCE(ot.country_iso, csi.country_iso) AS country_iso
      , COALESCE(ot.order_status, csi.order_status) AS order_status
      , COALESCE(ot.delivery_eta, csi.delivery_eta, op.delivery_eta) AS delivery_eta
      , ot.delayed_component
      , ot.fulfillment_time
      , op.revenue
      , op.voucher_value
      FROM tracks_tb
      LEFT JOIN order_tracking_tb ot
      ON tracks_tb.id=ot.id
      LEFT JOIN customer_service_intent_tb csi
      ON tracks_tb.id=csi.id
      LEFT JOIN order_placed_tb op
      ON tracks_tb.id=op.id
      ),

      merged_tb AS (
      SELECT order_number
          , MAX(joined_tb.delivery_eta) AS order_delivery_pdt
          , MIN(joined_tb.context_app_version) AS app_version
          , MIN(joined_tb.context_device_type) AS platform
          , MIN(CASE WHEN event="order_placed" THEN timestamp END) AS timestamp_order_placed -- since grouped by order number, there should only be 1
          , MAX(CASE WHEN event="order_placed" THEN TRUE ELSE FALSE END) AS has_order_placed
          , MAX(CASE WHEN event="order_tracking_viewed" THEN TRUE ELSE FALSE END) AS has_order_tracking_viewed
          , SUM(CASE WHEN event="order_tracking_viewed" THEN 1 ELSE 0 END) AS sum_order_tracking_viewed
          , MIN(CASE WHEN event="order_tracking_viewed" THEN timestamp END) AS timestamp_first_order_tracking_viewed
          , MAX(CASE WHEN event="order_tracking_viewed" THEN timestamp END) AS timestamp_last_order_tracking_viewed
          , MAX(CASE WHEN event='contact_customer_service_selected' THEN TRUE ELSE FALSE END) AS has_cs_intent
          , SUM(CASE WHEN event='contact_customer_service_selected' THEN 1 ELSE 0 END) AS sum_cs_intent
          , MIN(CASE WHEN event="contact_customer_service_selected" THEN timestamp END) AS timestamp_first_cs_intent
          , MAX(CASE WHEN event="contact_customer_service_selected" THEN timestamp END) AS timestamp_last_cs_intent
      FROM joined_tb
      GROUP BY 1
      )

      SELECT *
      , COALESCE(timestamp_order_placed, timestamp_first_order_tracking_viewed, timestamp_first_cs_intent) AS first_interaction_timestamp
      FROM merged_tb
 ;;
  }

#################

  dimension: is_ct_order {
    ## Can know whether is CT order by checking whether order_number is a number (Saleor: 11111) or a string (CT: de_muc_zue7y)
    type: yesno
    sql: (
          -- if safe_cast fails, returns null meaning order_number was not a number, meaning it was a CT order. Also ruling out NULL because with yesno, null turns into NO (FALSE).
          IF(SAFE_CAST(${order_number} AS INT64) is NULL,TRUE,FALSE) AND ${order_number} IS NOT NULL
          );;
  }

  # dimension: order_uuid {
  #   ## This uuid is designed to follow the same format as order_uuid inside of orders.view (curated_layer).
  #   ## For saleor orders, it looks like this: DE_11111 (order_id is based on order_number)
  #   ## For CT orders, it looks like this: DE_c139c9c1-36b5-423b-97b2-79a94d116aea (order_id is based on order_token)
  #   ## The way we can know from the client side whether order_number or order_token should be used, is by checking whether order_number is a number (Saleor: 11111) or a string (CT: de_muc_zue7y)
  #   type: string
  #   sql: (
  #     IF(${is_ct_order}, ${country_iso}|| '_' ||${order_id}, ${country_iso}|| '_' ||${order_number})
  #   );;
  #   hidden: yes
  # }

  measure: cnt_orders_placed {
    label: "# Orders Placed"
    description: "Number of Orders Placed"
    type: count_distinct
    sql: ${order_number};;
    filters: [has_order_placed: "yes"]
  }

  measure: cnt_order_tracking_viewed {
    label: "# Orders With Order Tracking Viewed"
    description: "Number of Orders With Order Tracking Viewed"
    type: count_distinct
    sql: ${order_number};;
    filters: [has_order_tracking_viewed: "yes"]
  }

  measure: cnt_orders_with_help_intent {
    label: "# Orders With CCS Intent"
    description: "Number of orders based (on order number) that have an intent to contact customer service"
    type: count_distinct
    sql: ${order_number};;
    filters: [has_cs_intent: "yes"]
  }

  measure: sum_sum_order_tracking_viewed {
    label: "Sum of total # order tracking viewed"
    description: "Sum of total # order tracking viewed"
    type: sum
    sql: ${sum_order_tracking_viewed};;
  }

  dimension: CCSintent_time_since_order_duration{
    type: duration_minute
    sql_start: ${timestamp_order_placed_raw} ;;
    sql_end: ${timestamp_first_cs_intent_raw};;
  }

  dimension: CCSintent_timesdiff_to_pdt{
    type: number
    sql: ${CCSintent_time_since_order_duration}-${order_delivery_pdt};;
  }

  dimension: CCSintent_time_since_order_tiers {
    type: tier
    tiers: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 20, 25, 30, 45, 60]
    style: interval
    sql: ${CCSintent_time_since_order_duration} ;;
  }

  dimension: CCSintent_timesdiff_to_pdt_tiers {
    type: tier
    tiers: [-20,-16,-14,-12,-10,-8,-6,-4,-2, 0, 2, 4,6,8,10,12,14,16,20,24,30,45,60]
    style: interval
    sql: ${CCSintent_timesdiff_to_pdt} ;;
  }

  #################

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: order_number {
    type: string
    sql: ${TABLE}.order_number ;;
  }

  dimension: order_delivery_pdt {
    type: string
    sql: ${TABLE}.order_delivery_pdt ;;
  }

  dimension: app_version {
    type: string
    sql: ${TABLE}.app_version ;;
  }

  dimension: platform {
    type: string
    sql: ${TABLE}.platform ;;
  }

  dimension_group: timestamp_first_interaction {
    type: time
    sql: ${TABLE}.first_interaction_timestamp ;;
  }

  dimension_group: timestamp_order_placed {
    type: time
    sql: ${TABLE}.timestamp_order_placed ;;
  }

  dimension: has_order_placed {
    type: yesno
    sql: ${TABLE}.has_order_placed ;;
  }

  dimension: has_order_tracking_viewed {
    type: string
    sql: ${TABLE}.has_order_tracking_viewed ;;
  }

  dimension: sum_order_tracking_viewed {
    type: number
    sql: ${TABLE}.sum_order_tracking_viewed ;;
  }

  dimension_group: timestamp_first_order_tracking_viewed {
    type: time
    sql: ${TABLE}.timestamp_first_order_tracking_viewed ;;
  }

  dimension_group: timestamp_last_order_tracking_viewed {
    type: time
    sql: ${TABLE}.timestamp_last_order_tracking_viewed ;;
  }

  dimension: has_cs_intent {
    type: yesno
    sql: ${TABLE}.has_cs_intent ;;
  }

  dimension: sum_cs_intent {
    type: number
    sql: ${TABLE}.sum_cs_intent ;;
  }

  dimension_group: timestamp_first_cs_intent {
    type: time
    sql: ${TABLE}.timestamp_first_cs_intent ;;
  }

  dimension_group: timestamp_last_cs_intent {
    type: time
    sql: ${TABLE}.timestamp_last_cs_intent ;;
  }

  set: detail {
    fields: [
      order_number,
      timestamp_first_interaction_time,
      timestamp_order_placed_time,
      has_order_placed,
      has_order_tracking_viewed,
      sum_order_tracking_viewed,
      timestamp_first_order_tracking_viewed_time,
      timestamp_last_order_tracking_viewed_time,
      has_cs_intent,
      sum_cs_intent,
      timestamp_first_cs_intent_time,
      timestamp_last_cs_intent_time
    ]
  }
}
