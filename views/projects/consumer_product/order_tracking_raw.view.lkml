view: order_tracking_raw {
  derived_table: {
    persist_for: "1 hour"
    sql: WITH
    -- combine order_placed for ios and android for the relevant fields
    -- some orders receive events twice, so need to make sure they're unique
    order_placed_tb AS (
      SELECT *
      FROM (
        SELECT
          anonymous_id,
          ios_order.order_id,
          ios_order.context_app_version,
          ios_order.context_app_name,
          ios_order.context_traits_email,
          ios_order.context_traits_hub_slug,
          SAFE_CAST(ios_order.delivery_eta AS INT64) AS delivery_eta,
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
          anonymous_id,
          android_order.order_id,
          android_order.context_app_version,
          android_order.context_app_name,
          android_order.context_traits_email,
          android_order.context_traits_hub_slug,
          android_order.delivery_eta,
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
     -- this is a long section because A) android and ios have different trigger behahaviour and B) android needs apiXXX events to determine whether user stayed on the page
     android_order_tracking_tb AS (
      SELECT
        anonymous_id,
        event,
        context_device_type,
        context_app_version,
        android_order.order_id,
        android_order.order_number,
        android_order.hub_slug,
        android_order.country_iso,
        android_order.order_status,
        android_order.fulfillment_time,
        android_order.delayed_component,
        android_order.delivery_eta,
        android_order.id,
        android_order.origin_screen,
        android_order.timestamp,
      FROM
        `flink-data-prod.flink_android_production.order_tracking_viewed` android_order
    --   WHERE android_order.origin_screen!="payment"
      WHERE _PARTITIONTIME="2021-09-23"

      UNION ALL

      SELECT anonymous_id
        , event
        , context_device_type
        , context_app_version
        , CAST(NULL AS STRING) AS a
        , CAST(NULL AS STRING) AS b
        , CAST(NULL AS STRING) AS c
        , CAST(NULL AS STRING) AS d
        , CAST(NULL AS STRING) AS e
        , CAST(NULL AS INT64) AS f
        , CAST(NULL AS STRING) AS g
        , CAST(NULL AS INT64) AS h
        , CAST(NULL AS STRING) AS i
        , CAST(NULL AS STRING) AS j
        , timestamp
        FROM `flink-data-prod.flink_android_production.api_order_get_succeeded_view`
        UNION ALL
        SELECT anonymous_id
        , event
        , context_device_type
        , context_app_version
        , CAST(NULL AS STRING) AS a
        , CAST(NULL AS STRING) AS b
        , CAST(NULL AS STRING) AS c
        , CAST(NULL AS STRING) AS d
        , CAST(NULL AS STRING) AS e
        , CAST(NULL AS INT64) AS f
        , CAST(NULL AS STRING) AS g
        , CAST(NULL AS INT64) AS h
        , CAST(NULL AS STRING) AS i
        , CAST(NULL AS STRING) AS j
        , timestamp
        FROM `flink-data-prod.flink_android_production.api_order_get_failed_view`
      )

    , android_tracking_help_tb AS (
        SELECT *
        , TIMESTAMP_DIFF(timestamp, LAG(timestamp) OVER (PARTITION BY anonymous_id ORDER BY timestamp ASC), SECOND) AS sec_since_prev
        -- , TIMESTAMP_DIFF(LEAD(timestamp) OVER (PARTITION BY anonymous_id ORDER BY timestamp ASC), timestamp, SECOND) AS sec_until_next
        -- , LAG(event) OVER (PARTITION BY anonymous_id ORDER BY timestamp ASC) AS prev_event
        FROM android_order_tracking_tb
    )

    , android_order_tracking_clean_tb AS (
        SELECT *
        , SUM(CASE WHEN sec_since_prev >16 OR event="order_tracking_viewed" THEN 1 ELSE 0 END) OVER (PARTITION BY anonymous_id ORDER BY timestamp ASC) AS view_counter
        FROM android_tracking_help_tb
        WHERE NOT(sec_since_prev=0 AND event LIKE "api_order_get%") --sometimes the order get event fires at almost the same time as order_tracking_viewed; that doesn't tell us whether the user stayed on the screen
    )

    , android_order_tracking_duration_tb AS (
        SELECT *
        , LAST_VALUE(timestamp) OVER (PARTITION BY anonymous_id, view_counter ORDER BY timestamp ASC
                                        RANGE BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS viewed_until
        FROM android_order_tracking_clean_tb
    )

    , ios_order_tracking_tb AS (
      SELECT
        anonymous_id,
        event,
        context_device_type,
        context_app_version,
        ios_order.order_id,
        ios_order.order_number,
        ios_order.hub_slug,
        ios_order.country_iso,
        CAST(NULL AS STRING) AS order_status,
        NULL AS fulfillment_time,
        CAST(NULL AS STRING) AS delayed_component,
        ios_order.delivery_eta,
        ios_order.id,
        CAST(NULL AS STRING) AS origin_screen,
        ios_order.timestamp,
        TIMESTAMP_DIFF(timestamp, LAG(timestamp) OVER (PARTITION BY anonymous_id ORDER BY timestamp ASC), SECOND) AS sec_since_prev
      FROM
        `flink-data-prod.flink_ios_production.order_tracking_viewed` ios_order
      WHERE _PARTITIONTIME="2021-09-23"
    )

    , ios_order_tracking_clean_tb AS (
        SELECT *
        , SUM(CASE WHEN sec_since_prev <14 OR sec_since_prev >16 THEN 1 ELSE 0 END) OVER (PARTITION BY anonymous_id ORDER BY timestamp ASC) AS view_counter
        FROM ios_order_tracking_tb
    )

    , ios_order_tracking_duration_tb AS (
        SELECT *
        , LAST_VALUE(timestamp) OVER (PARTITION BY anonymous_id, view_counter ORDER BY timestamp ASC
                                        RANGE BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS viewed_until
        , ROW_NUMBER() OVER (PARTITION BY anonymous_id, view_counter ORDER BY timestamp) AS row_per_counter
        FROM ios_order_tracking_clean_tb
    )

    , ios_order_tracking_final_tb AS (
        SELECT * EXCEPT(view_counter)
        FROM ios_order_tracking_duration_tb
        WHERE row_per_counter=1
    )

    , order_tracking_tb AS (
        SELECT * EXCEPT (view_counter)
        FROM android_order_tracking_duration_tb
        -- every tap to see the order tracking page should trigger order_tracking_viewed. Unfortunately it does Not trigger if the app is backgrounded and brought back to the page.
        -- we can't use api_order_getXXX to estimate that because these events are also triggered prior to orderTrackingViewed. We could also disregard orderTrackingViewed and simply count based on api_order_getXXX events, but I think their timing might be too unpredictable for that.
        WHERE event="order_tracking_viewed" AND NOT (origin_screen="payment" AND viewed_until=timestamp)
        UNION ALL
        SELECT * EXCEPT(row_per_counter) FROM ios_order_tracking_final_tb
        ORDER BY anonymous_id, timestamp
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
          anonymous_id,
          android_csi.context_device_type,
        android_csi.context_app_version,
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
          anonymous_id,
          ios_csi.context_device_type,
        ios_csi.context_app_version,
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

    -- union ot and cs tables
    joined_tb AS (
      SELECT
        anonymous_id
        , timestamp
        , "order_tracking_viewed" AS event
        , context_app_version
        , context_device_type
        , order_id
        , order_number
        , hub_slug
        , country_iso AS country_iso_tmp
        , order_status
        , delivery_eta
        , delayed_component
        , fulfillment_time
      FROM order_tracking_tb ot
      UNION ALL
      SELECT
        anonymous_id
        , timestamp
        , "contact_customer_service_selected" AS event
        , context_app_version
        , context_device_type
        , order_id
        , order_number
        , hub_slug
        , country_iso AS country_iso_tmp
        , order_status
        , delivery_eta
        , NULL AS delayed_component
        , NULL AS fulfillment_time
      FROM customer_service_intent_tb csi
      )

      SELECT
        joined_tb.* EXCEPT(country_iso_tmp)
        , IF(joined_tb.order_id IN (SELECT first_order_placed_tb.order_id FROM first_order_placed_tb), TRUE, FALSE) AS is_first_order
        , IF(country_iso_tmp IS NULL, IF(SAFE_CAST(joined_tb.order_number AS INT64) IS NULL, UPPER(SPLIT(joined_tb.order_number,"-")[safe_offset(0)]), NULL), country_iso_tmp) AS country_iso
        , order_placed_tb.delivery_eta AS order_placed_delivery_eta
        , order_placed_tb.timestamp AS order_placed_timestamp
      FROM joined_tb
      LEFT JOIN order_placed_tb
      -- there would be many row where this would match and in each row it should add the order_placed original info
      ON order_placed_tb.order_id=joined_tb.order_id
 ;;
  }

  ### Custom dimensions and measures
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
