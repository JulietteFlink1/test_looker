view: postorder_events {
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
                ios_order.context_device_type,
                ios_order.order_number,
                ios_order.hub_slug,
                CAST(NULL AS STRING) AS country_iso,
                "STATE_CREATED" AS order_status,
                ios_order.id,
                ios_order.context_app_version,
                ios_order.context_app_name,
                ios_order.context_traits_email,
                ios_order.context_traits_hub_slug,
                SAFE_CAST(ios_order.delivery_eta AS INT64) AS delivery_eta,
                timestamp,
                ROW_NUMBER() OVER(PARTITION BY order_number ORDER BY timestamp ASC) AS row_id
              FROM
                `flink-data-prod.flink_ios_production.order_placed` ios_order
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
                android_order.context_device_type,
                android_order.order_number,
                android_order.hub_slug,
                CAST(NULL AS STRING) AS country_iso,
                "STATE_CREATED" AS order_status,
                android_order.id,
                android_order.context_app_version,
                android_order.context_app_name,
                android_order.context_traits_email,
                android_order.context_traits_hub_slug,
                android_order.delivery_eta,
                timestamp,
                ROW_NUMBER() OVER(PARTITION BY order_number ORDER BY timestamp ASC) AS row_id
              FROM
                `flink-data-prod.flink_android_production.order_placed` android_order
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
              CAST(NULL AS timestamp) AS viewed_until,
              CAST(NULL AS INT64) AS duration
            FROM
              `flink-data-prod.flink_android_production.order_tracking_viewed_view` android_order
          --   WHERE android_order.origin_screen!="payment"
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
              status AS order_status,
              fulfillment_time,
              CAST(NULL AS STRING) AS delayed_component,
              ios_order.delivery_eta,
              ios_order.id,
              origin_screen,
              ios_order.timestamp,
              TIMESTAMP_DIFF(timestamp, LAG(timestamp) OVER (PARTITION BY anonymous_id ORDER BY timestamp ASC), SECOND) AS sec_since_prev
            FROM
              `flink-data-prod.flink_ios_production.order_tracking_viewed_view` ios_order
          )

          , ios_order_tracking_clean_tb AS (
              SELECT *
              , SUM(CASE WHEN (origin_screen!="orderTrackingScreen" OR (origin_screen="orderTrackingScreen" AND sec_since_prev >25) OR ((origin_screen IS NULL AND sec_since_prev >25))) THEN 1 ELSE 0 END) OVER (PARTITION BY anonymous_id ORDER BY timestamp ASC) AS view_counter
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
              SELECT * EXCEPT(view_counter, row_per_counter, sec_since_prev)
              , TIMESTAMP_DIFF(viewed_until, timestamp, SECOND) AS duration
              FROM ios_order_tracking_duration_tb
              WHERE row_per_counter=1
          )

          , order_tracking_tb AS (
              SELECT *
              FROM android_order_tracking_tb
              -- every tap to see the order tracking page should trigger order_tracking_viewed. Unfortunately it does Not trigger if the app is backgrounded and brought back to the page.
              -- we can't use api_order_getXXX to estimate that because these events are also triggered prior to orderTrackingViewed. We could also disregard orderTrackingViewed and simply count based on api_order_getXXX events, but I think their timing might be too unpredictable for that.
              UNION ALL
              SELECT *
              FROM ios_order_tracking_final_tb
              -- filter out tracking viewed events where the origin is from payment and users don't trigger another orderTrackingViewed by staying on the page
              WHERE NOT(origin_screen="payment" AND duration < 10)
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
              , viewed_until
              , id
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
              , NULL AS viewed_until
              , id
            FROM customer_service_intent_tb csi

            UNION ALL
            SELECT
              anonymous_id
              , timestamp
              , "order_placed" AS event
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
              , NULL AS viewed_until
              , id
            FROM order_placed_tb op
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
  dimension: is_ct_order {
    ## Can know whether is CT order by checking whether order_number is a number (Saleor: 11111) or a string (CT: de_muc_zue7y)
    type: yesno
    sql: (
          -- if safe_cast fails, returns null meaning order_number was not a number, meaning it was a CT order. Also ruling out NULL because with yesno, null turns into NO (FALSE).
          IF(SAFE_CAST(${order_number} AS INT64) is NULL,TRUE,FALSE) AND ${order_number} IS NOT NULL
          );;
  }

  dimension: order_uuid {
    ## This uuid is designed to follow the same format as order_uuid inside of orders.view (curated_layer).
    ## For saleor orders, it looks like this: DE_11111 (order_id is based on order_number)
    ## For CT orders, it looks like this: DE_c139c9c1-36b5-423b-97b2-79a94d116aea (order_id is based on order_token)
    ## The way we can know from the client side whether order_number or order_token should be used, is by checking whether order_number is a number (Saleor: 11111) or a string (CT: de_muc_zue7y)
    type: string
    sql: (
      IF(${is_ct_order}, ${country_iso}|| '_' ||${order_id}, ${country_iso}|| '_' ||${order_number})
    );;
    hidden: yes
  }


  ########## Device attributes #########

  dimension: full_app_version {
    group_label: "Device Dimensions"
    label: "Full App Version Detailed"
    type: string
    sql: ${context_device_type} || '-' || ${basic_padded_app_version} ;;
    order_by_field: version_ordering_field
  }

  dimension: main_app_version {
    group_label: "Device Dimensions"
    label: "Full App Version Main"
    type: string
    sql: ${context_device_type} || '-' || ${main_version_number} || '.' || ${secondary_version_number} ;;
    order_by_field: basic_version_field
  }

  dimension: basic_padded_app_version {
    group_label: "Device Dimensions"
    label: "App Version Main"
    type: string
    sql: CONCAT(${main_version_number},".",FORMAT('%02d',CAST(${secondary_version_number} AS INT64)));;
  }

  dimension: padded_app_version {
    group_label: "Device Dimensions"
    label: "App Version Detailed"
    type: string
    sql: CONCAT(${main_version_number},".",FORMAT('%02d',CAST(${secondary_version_number} AS INT64)),".",FORMAT('%02d',CAST(${tertiary_version_number} AS INT64)));;
  }

  dimension: context_device_type {
    group_label: "Device Dimensions"
    type: string
    sql: ${TABLE}.context_device_type ;;
  }

  dimension: context_app_version {
    hidden: yes
    type: string
    sql: ${TABLE}.context_app_version ;;
  }

  dimension: main_version_number {
    type: number
    sql: REGEXP_EXTRACT(${context_app_version}, r'(\d+)\.') ;;
    hidden: yes
  }

  dimension: secondary_version_number {
    type: number
    sql: REGEXP_EXTRACT(${context_app_version}, r'\.(\d+)\.') ;;
    hidden: yes
  }

  dimension: tertiary_version_number {
    type: number
    sql: REGEXP_EXTRACT(${context_app_version}, r'(?:\d+)\.(?:\d+)\.(\d+)') ;;
    hidden: yes
  }

  dimension: version_ordering_field {
    hidden: yes
    type: number
    sql: CONCAT(${main_version_number},${secondary_version_number},${tertiary_version_number}) ;;
  }

  dimension: basic_version_field {
    hidden: yes
    type: number
    sql: CAST(CONCAT(${main_version_number},${secondary_version_number}) AS INT64) ;;
  }

  measure: cnt_unique_order_ccs_intent {
    label: "# Unique Orders With CCS Intent"
    type: count_distinct
    sql: ${order_id} ;;
    filters: [event: "contact_customer_service_selected"]
  }

  measure: cnt_order_placed {
    label: "# Order Placed"
    type: count_distinct
    sql: ${order_id} ;;
    filters: [event: "order_placed"]
  }

  measure: cnt_order_tracking_viewed {
    label: "# Order Tracking Viewed"
    description: "Number of Order Tracking Viewed"
    type: count
    filters: [event: "order_tracking_viewed"]
  }

  measure: cnt_help_intent {
    label: "# CCS Intent Total"
    description: "Number of times there was an intent to contact customer service"
    type: count
    filters: [event: "contact_customer_service_selected"]
  }

  measure: cnt_help_intent_step1 {
    label: "# CCS Intent in Step1"
    description: "Number of times there was an intent to contact customer service in the ORDER CONFIRMATION stage"
    type: count_distinct
    filters: [event: "contact_customer_service_selected", order_status: "STATE_CREATED"]
    sql: ${order_id} ;;
  }

  measure: cnt_help_intent_step2 {
    label: "# CCS Intent in Step2"
    description: "Number of times there was an intent to contact customer service in the PACKING or PACKED stage "
    type: count_distinct
    sql:
      CASE WHEN ${event} = 'contact_customer_service_selected' AND (${order_status}="STATE_PICKER_ACCEPTED" OR ${order_status}="STATE_PACKED")
        THEN ${order_id}
        ELSE NULL
      END ;;
  }

  measure: cnt_help_intent_step3 {
    label: "# CCS Intent in Step3"
    description: "Number of times there was an intent to contact customer service in the PICKED UP and RIDER ON WAY stage"
    type: count_distinct
    sql:
      CASE WHEN ${event} = 'contact_customer_service_selected' AND (${order_status}="STATE_RIDER_CLAIMED" OR ${order_status}="STATE_ON_ROUTE")
      THEN ${order_id}
      ELSE NULL
    END ;;
  }

  measure: cnt_help_intent_step4 {
    label: "# CCS Intent in Step4"
    description: "Number of times there was an intent to contact customer service"
    type: count_distinct
    sql:
      CASE WHEN ${event} = 'contact_customer_service_selected' AND (${order_status}="STATE_ARRIVED" OR ${order_status}="STATE_DELIVERED")
      THEN ${order_id}
      ELSE NULL
    END ;;
  }

  measure: pct_orders_ccs_intent {
    label: "% CCS Intent"
    description: "The number of orders with CCS intent divided by the total number of orders."
    type: number
    sql: (1.0 * ${cnt_unique_order_ccs_intent}) / NULLIF(${cnt_order_placed}, 0) ;;
    value_format_name: percent_1
  }


  measure: pct_orders_ccs_intent_step1 {
    label: "% CCS Intent On Order Confirmation"
    description: "The number of orders with CCS intent on the order confirmation step divided by the total number of orders."
    type: number
    sql: (1.0 * ${cnt_help_intent_step1}) / NULLIF(${cnt_order_placed}, 0) ;;
    value_format_name: percent_1
  }

  measure: pct_orders_ccs_intent_step2 {
    label: "% CCS Intent On Order Packing"
    description: "The number of orders with CCS intent on the order confirmation step divided by the total number of orders."
    type: number
    sql: (1.0 * ${cnt_help_intent_step2}) / NULLIF(${cnt_order_placed}, 0) ;;
    value_format_name: percent_1
  }

  measure: pct_orders_ccs_intent_step3 {
    label: "% CCS Intent On Order In Delivery"
    description: "The number of orders with CCS intent on the order confirmation step divided by the total number of orders."
    type: number
    sql: (1.0 * ${cnt_help_intent_step3}) / NULLIF(${cnt_order_placed}, 0) ;;
    value_format_name: percent_1
  }

  measure: pct_orders_ccs_intent_step4 {
    label: "% CCS Intent On Order Delivered"
    description: "The number of orders with CCS intent on the order confirmation step divided by the total number of orders."
    type: number
    sql: (1.0 * ${cnt_help_intent_step4}) / NULLIF(${cnt_order_placed}, 0) ;;
    value_format_name: percent_1
  }

  measure: avg_duration_ordertrackingviewed {
    type: average
    sql: ${order_tracking_viewed_duration} ;;
    filters: [event: "order_tracking_viewed"]
  }

  measure: perc25_duration_ordertrackingviewed {
    type: percentile
    percentile: 25
    sql: ${order_tracking_viewed_duration} ;;
    filters: [event: "order_tracking_viewed"]
  }

  measure: median_duration_ordertrackingviewed {
    type: median
    sql: ${order_tracking_viewed_duration} ;;
    filters: [event: "order_tracking_viewed"]
  }

  measure: perc75_duration_ordertrackingviewed {
    type: percentile
    percentile: 75
    sql: ${order_tracking_viewed_duration} ;;
    filters: [event: "order_tracking_viewed"]
  }

  measure: max_duration_ordertrackingviewed {
    type: max
    sql: ${order_tracking_viewed_duration} ;;
    filters: [event: "order_tracking_viewed"]
  }

  measure: min_duration_ordertrackingviewed {
    type: min
    sql: ${order_tracking_viewed_duration} ;;
    filters: [event: "order_tracking_viewed"]
  }

  dimension: order_tracking_viewed_duration {
    type: duration_second
    sql_start: ${timestamp_raw} ;;
    sql_end: ${viewed_until_raw} ;;
    # hidden: yes
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

  parameter: xaxis_selector {
    type: unquoted
    allowed_value: {
      label: "Date"
      value: "date"
    }
    allowed_value: {
      label: "App Version"
      value: "app_version"
    }
    default_value: "Date"
  }

  dimension: plotby {
    label: "X-axis (Dynamic)"
    label_from_parameter: xaxis_selector
    type: string
    sql:
    {% if xaxis_selector._parameter_value == 'date' %}
      ${order_placed_timestamp_date}
    {% elsif xaxis_selector._parameter_value == 'app_version' %}
      ${full_app_version}
    {% else %}
      ${order_placed_timestamp_date}
    {% endif %};;
  }
  ###

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: id {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}.id ;;
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
    description: "Order Placement Date"
    timeframes: [
      raw,
      hour_of_day,
      hour,
      time,
      date,
      day_of_week,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.order_placed_timestamp ;;
  }

  dimension_group: viewed_until {
    type: time
    sql: ${TABLE}.viewed_until ;;
  }

  set: detail {
    fields: [
      anonymous_id,
      timestamp_time,
      event,
      id,
      context_app_version,
      context_device_type,
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
      order_placed_timestamp_date
    ]
  }
}
