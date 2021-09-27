view: postorder_tracking {
  derived_table: {
    persist_for: "1 hour"
    sql: WITH
    -- combine order_placed for ios and android for the relevant fields
    -- some orders receive events twice, so need to make sure they're unique
    order_placed_tb AS (
      SELECT *
      FROM (
        SELECT
          ios_order.order_id,
          ios_order.order_number,
          ios_order.context_device_type,
          ios_order.context_app_version,
          ios_order.context_app_name,
          ios_order.context_traits_email,
          ios_order.context_traits_hub_slug,
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
      AND NOT (LOWER(context_app_version) LIKE "%app-rating%"
           OR LOWER(context_app_version) LIKE "%debug%")
          AND NOT (LOWER(context_app_name) = "flink-staging"
           OR LOWER(context_app_name) = "flink-debug")
          AND (LOWER(context_traits_email) != "qa@goflink.com"
           OR context_traits_email is null)
          AND (context_traits_hub_slug NOT IN('erp_spitzbergen', 'fr_hub_test', 'nl_hub_test')
           OR context_traits_hub_slug is null)
      UNION ALL
      SELECT *
      FROM (
        SELECT
          android_order.order_id,
          android_order.order_number,
          android_order.context_device_type,
          android_order.context_app_version,
          android_order.context_app_name,
          android_order.context_traits_email,
          android_order.context_traits_hub_slug,
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
      AND NOT (LOWER(context_app_version) LIKE "%app-rating%"
           OR LOWER(context_app_version) LIKE "%debug%")
          AND NOT (LOWER(context_app_name) = "flink-staging"
           OR LOWER(context_app_name) = "flink-debug")
          AND (LOWER(context_traits_email) != "qa@goflink.com"
           OR context_traits_email is null)
          AND (context_traits_hub_slug NOT IN('erp_spitzbergen', 'fr_hub_test', 'nl_hub_test')
           OR context_traits_hub_slug is null)
    ),

     -- combine order_tracking_viewed for ios and android for the relevant fields
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
        ios_order.id,
        ios_order.timestamp
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
        android_order.timestamp
      FROM
        `flink-data-prod.flink_android_production.order_tracking_viewed_view` android_order
      WHERE android_order.origin_screen!="payment"
        ),

    -- combine first_order_placed for ios and android for the relevant fields
    first_order_placed_tb AS (
      SELECT *
       FROM (
           SELECT
           ios_order.order_id
           , ROW_NUMBER() OVER(PARTITION BY order_number ORDER BY timestamp ASC) AS row_id
           FROM `flink-data-prod.flink_ios_production.first_order_placed_view` ios_order
        )
        WHERE row_id=1

      UNION ALL
      SELECT *
       FROM (
           SELECT
            android_order.order_id
            , ROW_NUMBER() OVER(PARTITION BY order_number ORDER BY timestamp ASC) AS row_id
            FROM `flink-data-prod.flink_android_production.first_order_placed_view` android_order
        )
        WHERE row_id=1
    ),

      -- combine customer_service_intent for ios and android for relevant fields
      customer_service_intent_tb AS (
      SELECT
        android_csi.order_id,
        android_csi.order_number,
        android_csi.hub_slug,
        android_csi.country_iso,
        android_csi.order_status,
        android_csi.delivery_eta,
        android_csi.id,
        android_csi.timestamp
      FROM
        `flink-data-prod.flink_android_production.contact_customer_service_selected_view` android_csi
      UNION ALL
      SELECT
        ios_csi.order_id,
        ios_csi.order_number,
        ios_csi.hub_slug,
        ios_csi.country_iso,
        ios_csi.status AS order_status,
        ios_csi.delivery_eta,
        ios_csi.id,
        ios_csi.timestamp
      FROM
        `flink-data-prod.flink_ios_production.contact_customer_service_selected_view` ios_csi
      ),

      -- group order_tracking_viewed data into one row per order id, so we have sums of how often this occurs per order and what is the first and last timestamp, and can join this on order_placed by order id
      order_tracking_viewed_agg AS (
          SELECT order_id
          , MAX(hub_slug) AS hub_slug
          , MAX(country_iso) AS country_iso
          , MAX(delivery_eta) AS delivery_eta
          , MAX(delayed_component) AS delayed_component
          , MAX(fulfillment_time) AS fulfillment_time
          , COUNT(*) AS sum_order_tracking_viewed
          , MIN(timestamp) AS timestamp_first_order_tracking_viewed
          , MAX(timestamp) AS timestamp_last_order_tracking_viewed
          FROM order_tracking_tb
          GROUP BY 1
      ),

      -- group contact_customer_service_selected data into one row per order id, so we have sums of how often this occurs per order and what is the first and last timestamp, and can join this on order_placed by order id
      contact_customer_service_agg AS (
          SELECT order_id
          , MAX(hub_slug) AS hub_slug
          , MAX(country_iso) AS country_iso
          , MAX(delivery_eta) AS delivery_eta
          , COUNT(*) AS sum_cs_intent
          , MIN(timestamp) AS timestamp_first_cs_intent
          , MAX(timestamp) AS timestamp_last_cs_intent
          FROM customer_service_intent_tb
          GROUP BY 1
      )

      -- with order_placed table as a base, join the order_tracking_viewed and contact_customer_service_selected tables for their respective information.
      -- for common fields, always take from order_placed first if available, then contact_customer_service_selected, then order_tracking_viewed, except for delivery_eta (because this will be dynamic soon, need to take it from order_tracking_viewed).
      , joined_tb AS (
      SELECT
      op.order_id
      , op.context_app_version AS app_version
      , op.context_device_type AS platform
      , op.order_number
      , COALESCE(op.hub_slug, csi.hub_slug, ot.hub_slug) AS hub_slug
      , COALESCE(csi.country_iso, ot.country_iso) AS country_iso_tmp
      , op.delivery_eta AS order_delivery_pdt
      , ot.delayed_component
      , ot.fulfillment_time
      , op.revenue
      , op.voucher_value
      , op.timestamp AS timestamp_order_placed
      , TRUE AS has_order_placed -- this flag is not useful atm, was useful when we were considering orderTrackingViewed and contactCustomerServiceSelected orders that were not present in orderPlaced. Adjust in LookML and remove here
      , IF(ot.sum_order_tracking_viewed IS NULL, 0, ot.sum_order_tracking_viewed) AS sum_order_tracking_viewed -- count returns null rather than 0 if the event didn't occur, but 0 makes more sense for sum
      , ot.timestamp_first_order_tracking_viewed
      , ot.timestamp_last_order_tracking_viewed
      , IF(csi.sum_cs_intent IS NULL, 0, csi.sum_cs_intent) AS sum_cs_intent -- count returns null rather than 0 if the event didn't occur, but 0 makes more sense for sum
      , csi.timestamp_first_cs_intent
      , csi.timestamp_last_cs_intent
      FROM order_placed_tb op
      LEFT JOIN order_tracking_viewed_agg ot
      ON op.order_id=ot.order_id
      LEFT JOIN contact_customer_service_agg csi
      ON op.order_id=csi.order_id
      )

      -- add fields for filters
      SELECT joined_tb.* EXCEPT(country_iso_tmp)
    --   , COALESCE(timestamp_order_placed, timestamp_first_order_tracking_viewed, timestamp_first_cs_intent) AS first_interaction_timestamp -- this should always be order_placed timestamp. If looking at a limited date set, that might not be the case because the order could've been placed before the date we start looking
      , IF(first_order_placed_tb.order_id IS NULL, FALSE, TRUE) AS is_first_order
      , IF(sum_cs_intent>0, TRUE, FALSE) AS has_cs_intent
      , IF(sum_order_tracking_viewed>0, TRUE, FALSE) AS has_order_tracking_viewed
      , IF(country_iso_tmp IS NULL, IF(SAFE_CAST(joined_tb.order_number AS INT64) IS NULL, UPPER(SPLIT(joined_tb.order_number,"-")[safe_offset(0)]), NULL), country_iso_tmp) AS country_iso
      FROM joined_tb
      LEFT JOIN first_order_placed_tb
      ON first_order_placed_tb.order_id=joined_tb.order_id
 ;;
  }

######## Custom dimensions and measures

  dimension: full_app_version {
    type: string
    sql: ${platform} || '-' || ${app_version} ;;
  }

  dimension: returning_customer {
    type: yesno
    sql: NOT(${is_first_order}) ;;
  }

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

  # Note: to combine CCS intent and order tracking view into one time-scale, it can't be defined using this table as it's on order level and that only works on event level (see order_tracking_raw view)
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

  ###################################

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: order_number {
    type: string
    sql: ${TABLE}.order_number ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
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

  dimension: is_first_order {
    hidden: yes
    type: yesno
    sql: ${TABLE}.is_first_order ;;
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
    type: yesno
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
      country_iso,
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
