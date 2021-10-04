view: address_tooltip_sessions {
  derived_table: {
    persist_for: "1 hour"
    sql: WITH
        events AS ( -- ios all events
        SELECT
            tracks.anonymous_id
          , tracks.context_app_version
          , tracks.context_device_type
          , tracks.context_locale
          , tracks.event
          , tracks.event_text
          , tracks.id
          , tracks.timestamp
          , tooltip.use_case
          , TIMESTAMP_DIFF(tracks.timestamp,LAG(tracks.timestamp) OVER(PARTITION BY tracks.anonymous_id ORDER BY tracks.timestamp), MINUTE) AS inactivity_time
        FROM
          `flink-data-prod.flink_ios_production.tracks_view` tracks
        LEFT JOIN `flink-data-prod.flink_ios_production.address_tooltip_viewed_view` tooltip ON tooltip.id = tracks.id
        WHERE
          tracks.event NOT LIKE "%api%"
          AND tracks.event NOT LIKE "%adjust%"
          AND tracks.event NOT LIKE "%install_attributed%"
          AND tracks.event != "app_opened"
          AND tracks.event != "application_updated"
          AND NOT (tracks.context_app_version LIKE "%APP-RATING%" OR tracks.context_app_version LIKE "%DEBUG%")
          AND NOT (tracks.context_app_name = "Flink-Staging" OR tracks.context_app_name="Flink-Debug")
    UNION ALL
        SELECT -- android all events
            tracks.anonymous_id
          , tracks.context_app_version
          , tracks.context_device_type
          , tracks.context_locale
          , tracks.event
          , tracks.event_text
          , tracks.id
          , tracks.timestamp
          , tooltip.use_case
          , TIMESTAMP_DIFF(tracks.timestamp,LAG(tracks.timestamp) OVER(PARTITION BY tracks.anonymous_id ORDER BY tracks.timestamp), MINUTE) AS inactivity_time
        FROM
          `flink-data-prod.flink_android_production.tracks_view` tracks
        LEFT JOIN `flink-data-prod.flink_android_production.address_tooltip_viewed_view` tooltip ON tooltip.id = tracks.id
        WHERE
          tracks.event NOT LIKE "%api%"
          AND tracks.event NOT LIKE "%adjust%"
          AND tracks.event NOT LIKE "%install_attributed%"
          AND tracks.event != "app_opened"
          AND tracks.event != "application_updated"
          AND NOT (tracks.context_app_version LIKE "%APP-RATING%" OR tracks.context_app_version LIKE "%DEBUG%")
          AND NOT (tracks.context_app_name = "Flink-Staging" OR tracks.context_app_name="Flink-Debug")

          )

     , tracking_sessions AS ( -- defining 30 min sessions
            SELECT
              anonymous_id
            , anonymous_id || '-' || ROW_NUMBER() OVER(PARTITION BY anonymous_id ORDER BY timestamp ASC) AS session_id
            , ROW_NUMBER() OVER(PARTITION BY anonymous_id ORDER BY timestamp ASC) AS session_number
            , timestamp AS session_start_at
            , LEAD(timestamp) OVER(PARTITION BY anonymous_id ORDER BY timestamp) AS next_session_start_at
            , context_app_version
            , context_device_type
            , context_locale
            FROM
              events
            WHERE
              (events.inactivity_time > 30
                OR events.inactivity_time IS NULL)
            ORDER BY
              1)

    , hub_data_union AS ( -- ios & android pulling address_confirmed and order_placed for hub_data and delivery_eta
        SELECT
              event.event,
              event.anonymous_id,
              event.timestamp,
              event.hub_city,
              hub.slug as hub_code,
              CAST(event.delivery_eta as INT) as delivery_eta,
              CAST(NULL AS BOOL) AS has_selected_address
        FROM `flink-data-prod.flink_ios_production.address_confirmed_view` event
            LEFT JOIN
                `flink-data-prod.saleor_prod_global.warehouse_warehouse` AS hub
            ON SPLIT(SAFE_CONVERT_BYTES_TO_STRING(FROM_BASE64(regexp_extract(event.hub_code, "^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/][AQgw]==|[A-Za-z0-9+/]{2}[AEIMQUYcgkosw048]=)?$"))),':')[ OFFSET(1)] = hub.id
    UNION ALL
        SELECT
              event.event,
              event.anonymous_id,
              event.timestamp,
              event.hub_city,
              hub.slug as hub_code,
              event.delivery_eta,
              CAST(NULL AS BOOL) AS has_selected_address
        FROM `flink-data-prod.flink_android_production.address_confirmed_view` event
            LEFT JOIN
                `flink-data-prod.saleor_prod_global.warehouse_warehouse` AS hub
            ON SPLIT(SAFE_CONVERT_BYTES_TO_STRING(FROM_BASE64(regexp_extract(event.hub_code, "^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/][AQgw]==|[A-Za-z0-9+/]{2}[AEIMQUYcgkosw048]=)?$"))),':')[ OFFSET(1)] = hub.id
    UNION ALL
        SELECT
              event.event,
              event.anonymous_id,
              event.timestamp,
              event.hub_city,
              hub.slug as hub_code,
              CAST(event.delivery_eta as INT) as delivery_eta,
              CAST(NULL AS BOOL) AS has_selected_address
        FROM `flink-data-prod.flink_ios_production.order_placed_view` event
            LEFT JOIN
                `flink-data-prod.saleor_prod_global.warehouse_warehouse` AS hub
            ON SPLIT(SAFE_CONVERT_BYTES_TO_STRING(FROM_BASE64(regexp_extract(event.hub_code, "^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/][AQgw]==|[A-Za-z0-9+/]{2}[AEIMQUYcgkosw048]=)?$"))),':')[ OFFSET(1)] = hub.id
    UNION ALL
        SELECT
              event.event,
              event.anonymous_id,
              event.timestamp,
              event.hub_city,
              hub.slug as hub_code,
              delivery_eta,
              CAST(NULL AS BOOL) AS has_selected_address
        FROM `flink-data-prod.flink_android_production.order_placed_view` event
            LEFT JOIN
                `flink-data-prod.saleor_prod_global.warehouse_warehouse` AS hub
            ON SPLIT(SAFE_CONVERT_BYTES_TO_STRING(FROM_BASE64(regexp_extract(event.hub_code, "^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/][AQgw]==|[A-Za-z0-9+/]{2}[AEIMQUYcgkosw048]=)?$"))),':')[ OFFSET(1)] = hub.id
    UNION ALL
        SELECT
              event.event,
              event.anonymous_id,
              event.timestamp,
              event.city AS hub_city,
              hub_slug as hub_code,
              NULL AS delivery_eta,
              event.has_selected_address
        FROM `flink-data-prod.flink_android_production.app_opened_view` event
    UNION ALL
        SELECT
              event.event,
              event.anonymous_id,
              event.timestamp,
              event.city AS hub_city,
              hub_slug as hub_code,
              NULL AS delivery_eta,
              event.has_selected_address
        FROM `flink-data-prod.flink_ios_production.app_opened_view` event
    )

    , has_address_fill AS (
      SELECT
        hd.event,
        hd.anonymous_id,
        hd.timestamp,
        hd.hub_city,
        hd.hub_code,
        COALESCE(hs.country_iso, hc.country_iso) as hub_country,
        hd.delivery_eta,
        LAST_VALUE(hd.has_selected_address IGNORE NULLS) OVER
            (PARTITION BY anonymous_id ORDER BY timestamp RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)  AS has_selected_address
      FROM hub_data_union hd
      LEFT JOIN (
                SELECT DISTINCT country_iso, city
                FROM `flink-data-prod.google_sheets.hub_metadata`
                 ) hc
            ON hd.hub_city = hc.city
      LEFT JOIN (
          SELECT DISTINCT country_iso, hub_code
          FROM `flink-data-prod.google_sheets.hub_metadata`
         ) hs
      ON LOWER(hd.hub_code) = LOWER(hs.hub_code)

      WHERE (hs.hub_code NOT IN('erp_spitzbergen', 'fr_hub_test', 'nl_hub_test')
          OR hs.hub_code is null)
    )

    , hub_data AS (
    SELECT  ha.event,
            ha.anonymous_id,
            ha.timestamp,
            ha.hub_city,
            ha.hub_country,
            ha.hub_code,
            ha.delivery_eta,
            ha.has_selected_address,
            CASE
                WHEN ha.has_selected_address THEN true
                WHEN ha.event="address_confirmed" THEN true
                WHEN ha.event="order_placed" THEN true
                ELSE false
            END AS has_address,
            ROW_NUMBER() OVER(PARTITION BY ha.event, ha.anonymous_id, ha.timestamp ORDER BY ha.timestamp DESC)       AS row_n
    FROM has_address_fill ha
    )

    , sessions_final AS ( -- merging sessions with hub_data
    SELECT
           anonymous_id
         , context_app_version
         , context_device_type
         , context_locale
         , session_id
         , session_number
         , session_start_at
         , next_session_start_at
         , CASE WHEN hub_city LIKE 'Ludwigshafen%' THEN 'DE'
            WHEN hub_city LIKE 'Mülheim%' THEN 'DE'
            WHEN hub_city LIKE 'Mulheim%' THEN 'DE'
            ELSE hub_country END AS hub_country
         , hub_city
         , hub_code
         , delivery_eta
         , has_address
         , has_selected_address
    FROM (
        SELECT
              ts.anonymous_id
            , ts.context_app_version
            , ts.context_device_type
            , ts.context_locale
            , ts.session_id
            , ts.session_number
            , ts.session_start_at
            , ts.next_session_start_at
            , hd.timestamp as hd_timestamp
        , hd.hub_code
        , hd.hub_country
        , hd.hub_city
        , hd.delivery_eta
        , hd.has_address
        , hd.has_selected_address
        , DENSE_RANK() OVER (PARTITION BY ts.anonymous_id, ts.session_id ORDER BY hd.timestamp DESC) as rank_hd -- ranks all data_hub related events // filter set = 1 to get 'latest' timestamp
    FROM tracking_sessions ts
            LEFT JOIN (
                SELECT
                    anonymous_id
                  , timestamp
                  , hub_code
                  , hub_city
                  , hub_country
                  -- , delivery_postcode
                  , delivery_eta
                  , has_address
                  , has_selected_address
                FROM hub_data
            ) hd
            ON ts.anonymous_id = hd.anonymous_id
            AND ( hd.timestamp < ts.next_session_start_at OR ts.next_session_start_at IS NULL)
        )
      WHERE
      rank_hd = 1  -- filter set = 1 to get 'latest' timestamp
  GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13,14
  )

  , tooltip AS (
        SELECT
               sf.anonymous_id
             , sf.session_id
             , count(e.timestamp) as event_count
             , countif(e.use_case = 'onboarding') as onboarding_count
             , countif(e.use_case = 'different_address_location') as different_address_location_count
             , countif(e.use_case = 'outside_delivery_area') as outside_delivery_area_count
        FROM events e
            LEFT JOIN sessions_final sf
            ON e.anonymous_id = sf.anonymous_id
            AND e.timestamp >= sf.session_start_at
            AND ( e.timestamp < sf.next_session_start_at OR next_session_start_at IS NULL)
        WHERE e.event = 'address_tooltip_viewed'
        GROUP BY 1,2
    )

    , first_order AS (
        SELECT
               e.anonymous_id
             , MIN(e.timestamp) as first_order_timestamp
        FROM events e
        WHERE e.event = 'order_placed'
        GROUP BY 1
    )

    , event_counts AS (
       SELECT
           sf.anonymous_id
         , sf.session_id
         , SUM(CASE WHEN e.event="address_tooltip_viewed" THEN 1 ELSE 0 END) as address_tooltip_viewed_count
         , SUM(CASE WHEN e.event="address_change_clicked" THEN 1 ELSE 0 END) as address_change_clicked_count
         , SUM(CASE WHEN e.event="address_confirmed" THEN 1 ELSE 0 END) as address_confirmed_count
         , SUM(CASE WHEN e.event="hub_update_message_viewed" THEN 1 ELSE 0 END) as hub_update_message_viewed_count
         , SUM(CASE WHEN e.event="contact_customer_service_selected" THEN 1 ELSE 0 END) as contact_customer_service_selected_count
         , SUM(CASE WHEN e.event="home_viewed" THEN 1 ELSE 0 END) as home_viewed_event_count
         , SUM(CASE WHEN e.event="map_viewed" THEN 1 ELSE 0 END) as map_viewed_event_count
         , SUM(CASE WHEN e.event="product_added_to_cart" THEN 1 ELSE 0 END) as product_added_to_cart_count
         , SUM(CASE WHEN e.event="order_placed" THEN 1 ELSE 0 END) as order_placed_count
        FROM events e
            LEFT JOIN sessions_final sf
            ON e.anonymous_id = sf.anonymous_id
            AND e.timestamp >= sf.session_start_at
            AND ( e.timestamp < sf.next_session_start_at OR next_session_start_at IS NULL)
        GROUP BY 1,2
    )

    -- table to check whether checkout follows a hub_update message or hub_update message follows checkout (both are interesting)
   , address_confirmation_sequence_tb AS (
       SELECT
           sf.anonymous_id
         , sf.session_id
         , e.event
         , e.timestamp
         , MAX(event="address_confirmed") OVER
            (PARTITION BY session_id ORDER BY timestamp ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING)  AS preceeded_by_address_confirmed
        , MAX(event="product_added_to_cart") OVER
            (PARTITION BY session_id ORDER BY timestamp ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING)  AS preceeded_by_product_added_to_cart
        , MAX(event="order_placed") OVER
            (PARTITION BY session_id ORDER BY timestamp ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING)  AS preceeded_by_order_placed
        FROM events e
            LEFT JOIN sessions_final sf
            ON e.anonymous_id = sf.anonymous_id
            AND e.timestamp >= sf.session_start_at
            AND ( e.timestamp < sf.next_session_start_at OR next_session_start_at IS NULL)
        WHERE e.event IN ('address_confirmed', "product_added_to_cart", "order_placed")
    )

    -- group the sequences to one session_id for merging with sessions table
   , sequence_combined_tb AS (
      SELECT session_id
      -- ac-pa-op OR op-ac-pa OR ac-op-pa (impossible)
      -- ontime_address_change + afterorder_address_change still needs minus op-pa-ac, maybe same strategy as with late_address_change_maybe
      , MAX(IF(event="address_confirmed" AND NOT(preceeded_by_product_added_to_cart), TRUE, FALSE)) AS ontime_address_change -- fine by itself
      , MAX(IF(event="product_added_to_cart" AND preceeded_by_address_confirmed, TRUE, FALSE)) AS ontime_address_change2 -- fine by itself
      -- pa-op-ac OR op-ac-pa OR op-pa-ac
      , MAX(IF(event="address_confirmed" AND preceeded_by_order_placed, TRUE, FALSE)) AS afterorder_address_change --use to correct count
      -- op-pa-ac OR op-ac-pa OR ac-op-pa (impossible)
      , MAX(IF(event="product_added_to_cart" AND preceeded_by_order_placed, TRUE, FALSE)) AS second_order_started --use to correct count
      -- pa-ac-op OR pa-op-ac -> so we want to have only pa-ac-op because pa-op-ac is the legitimate start of a second order, we do (late_address_change - (afterorder_address_change-second_order_started))
      -- additionally we want to have op-pa-ac because that's an error on the second order. That one I'm not sure how to get from our combinations, disregarding this edge case for now.
      , MAX(IF(event="address_confirmed" AND preceeded_by_product_added_to_cart AND NOT(preceeded_by_order_placed), TRUE, FALSE)) AS late_address_change
      , MAX(IF(event="address_confirmed" AND preceeded_by_product_added_to_cart, TRUE, FALSE)) AS late_address_change_maybe
       FROM address_confirmation_sequence_tb
       GROUP BY 1
    )

    SELECT
          sf.anonymous_id
        , sf.context_app_version
        , sf.context_device_type
        , sf.context_locale
        , sf.session_id
        , sf.session_number
        , datetime(sf.session_start_at,
          'UTC') AS session_start_at
        , datetime(sf.next_session_start_at,
          'UTC') AS next_session_start_at
        , sf.hub_code
        , sf.hub_country
        , sf.hub_city
        , sf.delivery_eta
        , sf.has_address
        , sf.has_selected_address
        , ec.address_tooltip_viewed_count AS address_tooltip_viewed_count
        , ec.address_change_clicked_count AS address_change_clicked_count
        , ec.address_confirmed_count AS address_confirmed_count
        , ec.hub_update_message_viewed_count AS hub_update_message_viewed_count
        , ec.contact_customer_service_selected_count AS contact_customer_service_selected_count
        , ec.home_viewed_event_count AS home_viewed_count
        , ec.map_viewed_event_count AS map_viewed_count
        , ec.order_placed_count AS order_placed_count
        , ec.product_added_to_cart_count AS product_added_to_cart_count
        , tt.event_count as tooltip_count
        , tt.onboarding_count as onboarding_count
        , tt.different_address_location_count as different_address_location_count
        , tt.outside_delivery_area_count AS outside_delivery_area_count
        , sc.ontime_address_change
        , sc.ontime_address_change2
        , sc.afterorder_address_change
        , sc.second_order_started
        , sc.late_address_change
        , sc.late_address_change_maybe
        , CASE WHEN fo.first_order_timestamp < sf.session_start_at THEN true ELSE false END as has_ordered
    FROM sessions_final sf
        LEFT JOIN event_counts  ec
        ON sf.session_id = ec.session_id
        LEFT JOIN tooltip tt
        ON sf.session_id = tt.session_id
        LEFT JOIN sequence_combined_tb sc
        ON sf.session_id=sc.session_id
        LEFT JOIN first_order fo
        ON sf.anonymous_id = fo.anonymous_id
 ;;
  }

#### custom dimensions and measures

  measure: cnt_address_tooltip_viewed {
    type: count
    label: "Cnt Address Tooltip"
    description: "# sessions in which address tooltip was viewed"
    filters: [address_tooltip_viewed_count: ">0"]
  }

  measure: cnt_tooltip_onboarding {
    type: count
    label: "Cnt Address Tooltip Onboarding"
    description: "# sessions in which address tooltip was viewed"
    filters: [onboarding_count: ">0"]
  }

  measure: cnt_tooltip_differentloc {
    type: count
    label: "Cnt Address Tooltip Different Location"
    description: "# sessions in which address tooltip was viewed"
    filters: [different_address_location_count: ">0"]
  }

  measure: cnt_tooltip_outsidearea {
    type: count
    label: "Cnt Address Tooltip Outside Area"
    description: "# sessions in which address tooltip was viewed"
    filters: [outside_delivery_area_count: ">0"]
  }

  measure: cnt_address_change_clicked{
    type: count
    label: "Cnt Address Change Clicked"
    description: "# sessions in which address change was clicked"
    filters: [address_change_clicked_count: ">0"]
  }

  measure: cnt_hub_update_message_viewed{
    type: count
    label: "Cnt Hub Update Message Viewed"
    description: "# sessions in which hub_update_message_viewed"
    filters: [hub_update_message_viewed_count: ">0"]
  }

  measure: cnt_contact_customer_service_selected{
    type: count
    label: "Cnt CCS Intent"
    description: "# sessions in which contact_customer_service_selected"
    filters: [contact_customer_service_selected_count: ">0"]
  }

  measure: cnt_address_confirmed{
    type: count
    label: "Cnt Address Confirmed"
    description: "# sessions in which address_confirmed"
    filters: [address_confirmed_count: ">0"]
  }

  dimension: has_address_current_session  {
    type: yesno
    sql: ${has_address}=true ;;
  }

  dimension: has_previously_set_address  {
    type: yesno
    sql: ${has_selected_address}=true ;;
  }

  dimension: full_app_version {
    type: string
    sql: ${context_device_type} || '-' || ${context_app_version} ;;
  }

  measure: cnt_has_address {
    type: count
    label: "Has address count"
    description: "# sessions in which the user had an address (selected in previous session or current)"
    filters: [has_address_current_session: "yes"]
  }

  measure: cnt_ontime_address_change {
    type: count
    label: "Cnt On Time Address Change"
    description: "# sessions in which address_confirmed happened before product added to cart"
    filters: [ontime_address_change: "yes"]
  }

  measure: cnt_ontime_address_change2 {
    type: count
    label: "Cnt On Time Address Change 2"
    description: "# sessions in which address_confirmed happened before product added to cart"
    filters: [ontime_address_change2: "yes"]
  }


  measure: cnt_late_address_change {
    type: count
    label: "Cnt Late Address Change"
    description: "# sessions in which address_confirmed happened after product added to cart"
    filters: [late_address_change: "yes"]
  }

  measure: cnt_afterorder_address_change {
    type: count
    label: "Cnt After Order Address Change"
    description: "# sessions in which address_confirmed happened after order placed"
    filters: [afterorder_address_change: "yes"]
  }

  measure: cnt_second_order_started {
    type: count
    label: "Cnt Second Order Started"
    description: "# sessions in which product_added_to_cart happened after order placed"
    filters: [second_order_started: "yes"]
  }

  measure: cnt_late_address_change_maybe {
    type: count
    label: "Cnt late_address_change_maybe"
    description: "# sessions in which product_added_to_cart happened after address_confirmed"
    filters: [late_address_change_maybe: "yes"]
  }

  measure: cnt_valid_orderplaced_before_addressconf {
    type: count
    label: "Cnt After Order Address Change And Second Order Started"
    description: "# sessions in which product_added_to_cart happened after order placed And address_confirmed happened after order placed And address_confirmed happened after product_added_to_cart"
    filters: [second_order_started: "yes", afterorder_address_change: "yes"]
  }

  measure: cnt_product_added_to_cart_and_address_confirmed {
    type: count
    label: "Cnt Product Added To Cart And Address Confirmed"
    description: "# sessions in which product_added_to_cart and address_confirmed happened"
    filters: [product_added_to_cart_count: ">0", address_confirmed_count: ">0"]
  }

  measure: cnt_product_added_to_cart {
    type: count
    label: "Cnt Product Added To Cart"
    description: "# sessions in which product_added_to_cart happened"
    filters: [product_added_to_cart_count: ">0"]
  }

  dimension: returning_customer {
    type: yesno
    sql: ${has_ordered} ;;
  }

  measure: mcvr1 {
    type: number
    label: "mCVR1"
    description: "# sessions with an address (either selected in previous session or in current session), compared to the total number of Sessions Started"
    value_format_name: percent_1
    sql: ${cnt_has_address}/NULLIF(${count},0);;
  }

  measure: cnt_order_placed {
    type: count
    label: "Cnt Order Placed"
    description: "# sessions in which order_placed happened"
    filters: [order_placed_count: ">0"]
  }


####

  dimension: order_placed_count {
    type: number
    sql: ${TABLE}.order_placed_count ;;
  }

  dimension: product_added_to_cart_count {
    type: number
    sql: ${TABLE}.product_added_to_cart_count ;;
  }

  dimension: has_ordered {
    type: yesno
    sql: ${TABLE}.has_ordered ;;
  }

  dimension: late_address_change_maybe {
    type: yesno
    sql: ${TABLE}.late_address_change_maybe ;;
  }

  dimension: ontime_address_change {
    type: yesno
    sql: ${TABLE}.ontime_address_change ;;
  }

  dimension: ontime_address_change2 {
    type: yesno
    sql: ${TABLE}.ontime_address_change2 ;;
  }

  dimension: afterorder_address_change {
    type: yesno
    sql: ${TABLE}.afterorder_address_change ;;
  }

  dimension: second_order_started {
    type: yesno
    sql: ${TABLE}.second_order_started ;;
  }

  dimension: late_address_change {
    type: yesno
    sql: ${TABLE}.late_address_change ;;
  }

  dimension: has_address {
    type: string
    hidden: yes
    sql: ${TABLE}.has_address ;;
  }

  dimension: has_selected_address {
    type: string
    hidden: yes
    sql: ${TABLE}.has_selected_address ;;
  }

  dimension: contact_customer_service_selected_count {
    type: number
    sql: ${TABLE}.contact_customer_service_selected_count ;;
  }

  dimension: hub_update_message_viewed_count {
    type: number
    sql: ${TABLE}.hub_update_message_viewed_count ;;
  }

  dimension: address_confirmed_count {
    type: number
    sql: ${TABLE}.address_confirmed_count ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: anonymous_id {
    type: string
    sql: ${TABLE}.anonymous_id ;;
  }

  dimension: context_app_version {
    type: string
    sql: ${TABLE}.context_app_version ;;
  }

  dimension: context_device_type {
    type: string
    sql: ${TABLE}.context_device_type ;;
  }

  dimension: context_locale {
    type: string
    sql: ${TABLE}.context_locale ;;
  }

  dimension: session_id {
    type: string
    sql: ${TABLE}.session_id ;;
  }

  dimension: session_number {
    type: number
    sql: ${TABLE}.session_number ;;
  }

  dimension_group: session_start_at {
    type: time
    datatype: datetime
    sql: ${TABLE}.session_start_at ;;
  }

  dimension_group: next_session_start_at {
    type: time
    datatype: datetime
    sql: ${TABLE}.next_session_start_at ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: hub_country {
    type: string
    sql: ${TABLE}.hub_country ;;
  }

  dimension: hub_city {
    type: string
    sql: ${TABLE}.hub_city ;;
  }

  dimension: delivery_eta {
    type: number
    sql: ${TABLE}.delivery_eta ;;
  }

  dimension: address_tooltip_viewed_count {
    type: number
    sql: ${TABLE}.address_tooltip_viewed_count ;;
  }

  dimension: address_change_clicked_count {
    type: number
    sql: ${TABLE}.address_change_clicked_count ;;
  }

  dimension: home_viewed_count {
    type: number
    sql: ${TABLE}.home_viewed_count ;;
  }

  dimension: map_viewed_count {
    type: number
    sql: ${TABLE}.map_viewed_count ;;
  }

  dimension: tooltip_count {
    type: number
    sql: ${TABLE}.tooltip_count ;;
  }

  dimension: onboarding_count {
    type: number
    sql: ${TABLE}.onboarding_count ;;
  }

  dimension: different_address_location_count {
    type: number
    sql: ${TABLE}.different_address_location_count ;;
  }

  dimension: outside_delivery_area_count {
    type: number
    sql: ${TABLE}.outside_delivery_area_count ;;
  }

  set: detail {
    fields: [
      anonymous_id,
      context_app_version,
      context_device_type,
      context_locale,
      session_id,
      session_number,
      session_start_at_time,
      next_session_start_at_time,
      hub_code,
      hub_country,
      hub_city,
      delivery_eta,
      address_tooltip_viewed_count,
      address_change_clicked_count,
      home_viewed_count,
      map_viewed_count,
      tooltip_count,
      onboarding_count,
      different_address_location_count,
      outside_delivery_area_count
    ]
  }
}
