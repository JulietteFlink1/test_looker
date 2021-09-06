view: segment_tracking_sessions30 {
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
          , TIMESTAMP_DIFF(tracks.timestamp,LAG(tracks.timestamp) OVER(PARTITION BY tracks.anonymous_id ORDER BY tracks.timestamp), MINUTE) AS inactivity_time
        FROM
          `flink-data-prod.flink_ios_production.tracks_view` tracks
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
          , TIMESTAMP_DIFF(tracks.timestamp,LAG(tracks.timestamp) OVER(PARTITION BY tracks.anonymous_id ORDER BY tracks.timestamp), MINUTE) AS inactivity_time
        FROM
          `flink-data-prod.flink_android_production.tracks_view` tracks
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
              event.hub_code AS hub_encoded,
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
              event.hub_code AS hub_encoded,
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
              event.hub_code AS hub_encoded,
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
              event.hub_code AS hub_encoded,
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
              NULL AS hub_encoded,
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
              NULL AS hub_encoded,
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
         , has_selected_address
         , has_address
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
            , hd.has_selected_address
            , hd.has_address
            , DENSE_RANK() OVER (PARTITION BY ts.anonymous_id, ts.session_id ORDER BY hd.timestamp DESC) as rank_hd -- ranks all data_hub related events // filter set = 1 to get 'latest' timestamp
        FROM tracking_sessions ts
                LEFT JOIN (
                    SELECT
                        anonymous_id
                      , timestamp
                      , hub_code
                      , hub_city
                      , hub_country
                      , delivery_eta
                      , event
                      , has_selected_address
                      , has_address
                    FROM hub_data
                ) hd
                ON ts.anonymous_id = hd.anonymous_id
                AND ( hd.timestamp < ts.next_session_start_at OR ts.next_session_start_at IS NULL)
            )
    WHERE
        rank_hd = 1  -- filter set = 1 to get 'latest' timestamp
    GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13, 14
    )
    , add_to_cart AS (
        SELECT
               sf.anonymous_id
             , sf.session_id
             , count(e.timestamp) as event_count
        FROM events e
            LEFT JOIN sessions_final sf
            ON e.anonymous_id = sf.anonymous_id
            AND e.timestamp >= sf.session_start_at
            AND ( e.timestamp < sf.next_session_start_at OR next_session_start_at IS NULL)
        WHERE e.event = 'product_added_to_cart'
        GROUP BY 1,2
    )

    , home_viewed AS (
        SELECT
               sf.anonymous_id
             , sf.session_id
             , count(e.timestamp) as event_count
        FROM events e
            LEFT JOIN sessions_final sf
            ON e.anonymous_id = sf.anonymous_id
            AND e.timestamp >= sf.session_start_at
            AND ( e.timestamp < sf.next_session_start_at OR next_session_start_at IS NULL)
        WHERE e.event = 'home_viewed'
        GROUP BY 1,2
    )

    , address_confirmed AS (
        SELECT
               sf.anonymous_id
             , sf.session_id
             , count(e.timestamp) as event_count
        FROM events e
            LEFT JOIN sessions_final sf
            ON e.anonymous_id = sf.anonymous_id
            AND e.timestamp >= sf.session_start_at
            AND ( e.timestamp < sf.next_session_start_at OR next_session_start_at IS NULL)
        WHERE e.event = 'address_confirmed'
        GROUP BY 1,2
    )

    , cart_viewed AS (
        SELECT
               sf.anonymous_id
             , sf.session_id
             , count(e.timestamp) as event_count
        FROM events e
            LEFT JOIN sessions_final sf
            ON e.anonymous_id = sf.anonymous_id
            AND e.timestamp >= sf.session_start_at
            AND ( e.timestamp < sf.next_session_start_at OR next_session_start_at IS NULL)
        WHERE e.event = 'cart_viewed'
        GROUP BY 1,2
    )

    , checkout_started AS (
        SELECT
               sf.anonymous_id
             , sf.session_id
             , count(e.timestamp) as event_count
        FROM events e
            LEFT JOIN sessions_final sf
            ON e.anonymous_id = sf.anonymous_id
            AND e.timestamp >= sf.session_start_at
            AND ( e.timestamp < sf.next_session_start_at OR next_session_start_at IS NULL)
        WHERE e.event = 'checkout_started'
        GROUP BY 1,2
    )

    , purchase_confirmed AS (
        SELECT
               sf.anonymous_id
             , sf.session_id
             , count(e.timestamp) as event_count
        FROM events e
            LEFT JOIN sessions_final sf
            ON e.anonymous_id = sf.anonymous_id
            AND e.timestamp >= sf.session_start_at
            AND ( e.timestamp < sf.next_session_start_at OR next_session_start_at IS NULL)
        WHERE e.event = 'purchase_confirmed'
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

    , order_placed AS (
        SELECT
               sf.anonymous_id
             , sf.session_id
             , count(e.timestamp) as event_count
        FROM events e
            LEFT JOIN sessions_final sf
            ON e.anonymous_id = sf.anonymous_id
            AND e.timestamp >= sf.session_start_at
            AND ( e.timestamp < sf.next_session_start_at OR next_session_start_at IS NULL)
        WHERE e.event = 'order_placed'
        GROUP BY 1,2
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
        , sf.has_selected_address
        , sf.has_address
        , atc.event_count as add_to_cart
        , hv.event_count as home_viewed
        , cv.event_count as view_cart
        , ac.event_count as address_confirmed
        , cs.event_count as checkout_started
        , pc.event_count as payment_started
        , op.event_count as order_placed
        -- , ae.event_count as any_event
        , CASE WHEN fo.first_order_timestamp < sf.session_start_at THEN true ELSE false END as has_ordered
    FROM sessions_final sf
        LEFT JOIN add_to_cart atc
        ON sf.session_id = atc.session_id
        LEFT JOIN home_viewed hv
        ON sf.session_id = hv.session_id
        LEFT JOIN cart_viewed cv
        ON sf.session_id = cv.session_id
        LEFT JOIN address_confirmed ac
        ON sf.session_id = ac.session_id
        LEFT JOIN checkout_started cs
        ON sf.session_id = cs.session_id
        LEFT JOIN purchase_confirmed pc
        ON sf.session_id = pc.session_id
        LEFT JOIN order_placed op
        ON sf.session_id = op.session_id
        LEFT JOIN first_order fo
        ON sf.anonymous_id = fo.anonymous_id
 ;;
  }

  ######### custom measures and dimensions

  measure: cnt_unique_anonymousid {
    label: "# Unique Users"
    description: "Number of Unique Users identified via Anonymous ID from Segment"
    hidden:  no
    type: count_distinct
    sql: ${anonymous_id};;
    value_format_name: decimal_0
  }

  dimension_group: session_start_at {
    type: time
    datatype: datetime
    timeframes: [
      hour,
      date,
      day_of_week,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.session_start_at ;;
  }

  dimension_group: next_session_start_at {
    type: time
    datatype: datetime
    timeframes: [
      date,
      day_of_week,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.next_session_start_at ;;
  }

# dimension: session {
  #   type: number
  #   sql: ${TABLE}.session ;;
  # }

  dimension: has_ordered {
    type: yesno
    sql: ${TABLE}.has_ordered ;;
  }

### Custom dimensions
  dimension: full_app_version {
    type: string
    sql: ${context_device_type} || '-' || ${context_app_version} ;;
  }

  dimension: returning_customer {
    type: yesno
    sql: ${has_ordered} ;;
  }

  dimension: is_first_session {
    type: yesno
    sql: ${TABLE}.session_number=1 ;;
  }

  dimension: hub_unknown {
    type: yesno
    sql: ${hub_code} IS NULL ;;
  }

  dimension: is_setting_address {
    type: yesno
    description: "TRUE if user has at least one addressConfirmed event in this session, FALSE otherwise"
    sql: ${address_confirmed} IS NOT NULL ;;
  }

  dimension: session_start_date_granularity {
    label: "Session Start Date (Dynamic)"
    label_from_parameter: timeframe_picker
    type: string # cannot have this as a time type. See this discussion: https://community.looker.com/lookml-5/dynamic-time-granularity-opinions-16675
    sql:
    {% if timeframe_picker._parameter_value == 'Hour' %}
      ${session_start_at_hour}
    {% elsif timeframe_picker._parameter_value == 'Day' %}
      ${session_start_at_date}
    {% elsif timeframe_picker._parameter_value == 'Week' %}
      ${session_start_at_week}
    {% elsif timeframe_picker._parameter_value == 'Month' %}
      ${session_start_at_month}
    {% endif %};;
  }

  parameter: timeframe_picker {
    label: "Session Start Date Granular"
    type: unquoted
    allowed_value: { value: "Hour" }
    allowed_value: { value: "Day" }
    allowed_value: { value: "Week" }
    allowed_value: { value: "Month" }
    default_value: "Day"
  }

  dimension: country {
    type: string
    case: {
      when: {
        sql: ${TABLE}.hub_country = "DE" ;;
        label: "Germany"
      }
      when: {
        sql: ${TABLE}.hub_country = "FR" ;;
        label: "France"
      }
      when: {
        sql: ${TABLE}.hub_country = "NL" ;;
        label: "Netherlands"
      }
      else: "Other / Unknown"
    }
  }

  dimension: checkout_payment_ratio_per_session {
    type: number
    sql: ${checkout_started}/${payment_started};;
  }

  dimension: payment_order_ratio_per_session {
    type: number
    sql: ${payment_started}/${order_placed};;
  }

##### Unique count of events during a session. If multiple events are triggerred during a session, e.g 3 times view item, the event is only counted once.

  # measure: single_event_sessions {
  #   label: "Sessions with 1 event count"
  #   description: "Number of sessions with 1 event"
  #   type: sum
  #   sql: CASE WHEN ${any_event}=1 THEN 1 END;;
  # }

  measure: cnt_address_selected {
    label: "Address selected count"
    description: "Number of sessions in which at least one Address Confirmed event happened"
    type: count
    filters: [address_confirmed: "NOT NULL"]
  }

  measure: cnt_home_viewed {
    label: "Home view count"
    description: "Number of sessions in which at least one Home Viewed event happened"
    type: count
    filters: [home_viewed: "NOT NULL"]
  }

  measure: cnt_has_address {
    label: "Has address count"
    description: "# sessions in which the user had an address (selected in previous session or current)"
    type: count
    filters: [has_address: "yes"]
  }

  measure: cnt_view_cart {
    label: "View cart count"
    description: "Number of sessions in which at least one Cart Viewed event happened"
    type: count
    filters: [view_cart: "NOT NULL"]
  }

  measure: cnt_add_to_cart {
    label: "Add to cart count"
    description: "Number of sessions in which at least one Product Added To Cart event happened"
    type: count
    filters: [add_to_cart: "NOT NULL"]
  }

  measure: cnt_checkout_started {
    label: "Checkout started count"
    description: "Number of sessions in which at least one Checkout Started event happened"
    type: count
    filters: [checkout_started: "NOT NULL"]
  }

  measure: cnt_payment_started {
    label: "Payment started count"
    description: "Number of sessions in which at least one Payment Started event happened"
    type: count
    filters: [payment_started: "NOT NULL"]
  }

  measure: cnt_purchase {
    label: "Order placed count"
    description: "Number of sessions in which at least one Order Placed event happened"
    type: count
    filters: [order_placed: "NOT NULL"]
  }

  ###### Sum of events

  # measure: sum_sessions {
  #   label: "Session sum"
  #   type: sum
  #   sql: ${session} ;;
  # }

  # measure: median_number_of_events {
  #   type: median
  #   label: "Median number of events in a session"
  #   sql: ${any_event} ;;
  # }

  # measure: number_of_events_75th_percentile {
  #   type: percentile
  #   percentile: 75
  #   sql: ${any_event};;
  # }

  # measure: number_of_events_25th_percentile {
  #   type: percentile
  #   percentile: 25
  #   sql: ${any_event};;
  # }

  measure: sum_address_selected {
    label: "Address selected sum of events"
    type: sum
    sql: ${address_confirmed} ;;
  }

  measure: sum_home_viewed {
    label: "Home viewed sum of events"
    type: sum
    sql: ${home_viewed} ;;
  }

  measure: sum_add_to_cart {
    label: "Add to cart sum of events"
    type: sum
    sql: ${add_to_cart} ;;
  }

  measure: sum_checkout_started {
    label: "Checkout started sum of events"
    type: sum
    sql: ${checkout_started} ;;
  }

  measure: sum_payment_started {
    label: "Payment started sum of events"
    type: sum
    sql: ${payment_started} ;;
  }

  measure: sum_purchases {
    label: "Order placed sum of events"
    type: sum
    sql: ${order_placed} ;;
  }

  ## Measures based on other measures
  measure: overall_conversion_rate {
    type: number
    description: "Number of sessions in which an Order Placed event happened, compared to the total number of Session Started"
    value_format_name: percent_1
    sql: ${cnt_purchase}/NULLIF(${count},0) ;;
  }

  # measure: mcvr1 {
  #   type: number
  #   description: "Number of sessions in which an Addres Confirmed event happened, compared to the total number of Session Started"
  #   value_format_name: percent_1
  #   sql: ${cnt_address_selected}/NULLIF(${count},0) ;;
  # }
  measure: mcvr1 {
    type: number
    description: "# sessions with an address (either selected in previous session or in current session), compared to the total number of Sessions Started"
    value_format_name: percent_1
    sql: ${cnt_has_address}/NULLIF(${count},0);;
  }

  measure: mcvr2 {
    type: number
    description: "# sessions in which there was a Product Added To Cart, compared to the number of sessions in which there was a Home Viewed"
    value_format_name: percent_1
    sql: ${cnt_add_to_cart}/NULLIF(${cnt_has_address},0) ;;
  }

  measure: mcvr3 {
    type: number
    description: "#sessions in which there was a Checkout Started event happened, compared to the number of sessions in which there was a Product Added To Cart"
    value_format_name: percent_1
    sql: ${cnt_checkout_started}/NULLIF(${cnt_add_to_cart},0) ;;
  }

  measure: mcvr4 {
    type: number
    description: "# sessions in which there was a Payment Started event happened, compared to the number of sessions in which there was a Checkout Started"
    value_format_name: percent_1
    sql: ${cnt_payment_started}/NULLIF(${cnt_checkout_started},0) ;;
  }

  measure: payment_success {
    type: number
    description: "Number of sessions in which there was an Order Placed, compared to the number of sessions in which there was a Payment Started"
    value_format_name: percent_1
    sql: ${cnt_purchase}/NULLIF(${cnt_payment_started},0) ;;
  }


  #########

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

  dimension: has_selected_address {
    type: string
    sql: ${TABLE}.has_selected_address ;;
  }

  dimension: has_address {
    type: yesno
    sql: ${TABLE}.has_address ;;
  }

  dimension: add_to_cart {
    type: number
    sql: ${TABLE}.add_to_cart ;;
  }

  dimension: home_viewed {
    type: number
    sql: ${TABLE}.home_viewed ;;
  }

  dimension: view_cart {
    type: number
    sql: ${TABLE}.view_cart ;;
  }

  dimension: address_confirmed {
    type: number
    sql: ${TABLE}.address_confirmed ;;
  }

  dimension: checkout_started {
    type: number
    sql: ${TABLE}.checkout_started ;;
  }

  dimension: payment_started {
    type: number
    sql: ${TABLE}.payment_started ;;
  }

  dimension: order_placed {
    type: number
    sql: ${TABLE}.order_placed ;;
  }

  set: detail {
    fields: [
      anonymous_id,
      context_app_version,
      context_device_type,
      context_locale,
      session_id,
      session_number,
      session_start_at_date,
      next_session_start_at_date,
      hub_code,
      hub_country,
      hub_city,
      delivery_eta,
      has_selected_address,
      has_address,
      add_to_cart,
      home_viewed,
      view_cart,
      address_confirmed,
      checkout_started,
      payment_started,
      order_placed,
      has_ordered
    ]
  }
}
