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
          `flink-backend.flink_ios_production.tracks_view` tracks
        WHERE
          tracks.event NOT LIKE "%api%"
          AND tracks.event NOT LIKE "%adjust%"
          AND tracks.event NOT LIKE "%install_attributed%"
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
          `flink-backend.flink_android_production.tracks_view` tracks
        WHERE
          tracks.event NOT LIKE "%api%"
          AND tracks.event NOT LIKE "%adjust%"
          AND tracks.event NOT LIKE "%install_attributed%"
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

, hub_data AS ( -- ios & android pulling address_confirmed and order_placed for hub_data and delivery_eta
    SELECT
          event.event,
          event.anonymous_id,
          event.timestamp,
          event.hub_city,
          country.country_iso as hub_country,
          event.hub_code AS hub_encoded,
          event.delivery_postcode,
          hub.slug as hub_code,
          SPLIT(SAFE_CONVERT_BYTES_TO_STRING(FROM_BASE64(regexp_extract(hub_code, "^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/][AQgw]==|[A-Za-z0-9+/]{2}[AEIMQUYcgkosw048]=)?$"))),':')[ OFFSET(1)] AS hub_id,
          CAST(event.delivery_eta as INT) as delivery_eta
    FROM `flink-backend.flink_ios_production.address_confirmed_view` event
        LEFT JOIN
            `flink-backend.saleor_db_global.warehouse_warehouse` AS hub
        ON SPLIT(SAFE_CONVERT_BYTES_TO_STRING(FROM_BASE64(regexp_extract(event.hub_code, "^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/][AQgw]==|[A-Za-z0-9+/]{2}[AEIMQUYcgkosw048]=)?$"))),':')[ OFFSET(1)] = hub.id
        LEFT JOIN (
            SELECT DISTINCT
                country_iso,
                city
            FROM `flink-backend.gsheet_store_metadata.hubs`
             ) country
        ON event.hub_city = country.city
UNION ALL
    SELECT
          event.event,
          event.anonymous_id,
          event.timestamp,
          event.hub_city,
          country.country_iso as hub_country,
          event.hub_code AS hub_encoded,
          event.delivery_postcode,
          hub.slug as hub_code,
          SPLIT(SAFE_CONVERT_BYTES_TO_STRING(FROM_BASE64(regexp_extract(hub_code, "^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/][AQgw]==|[A-Za-z0-9+/]{2}[AEIMQUYcgkosw048]=)?$"))),':')[ OFFSET(1)] AS hub_id,
          event.delivery_eta
    FROM `flink-backend.flink_android_production.address_confirmed_view` event
        LEFT JOIN
            `flink-backend.saleor_db_global.warehouse_warehouse` AS hub
        ON SPLIT(SAFE_CONVERT_BYTES_TO_STRING(FROM_BASE64(regexp_extract(event.hub_code, "^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/][AQgw]==|[A-Za-z0-9+/]{2}[AEIMQUYcgkosw048]=)?$"))),':')[ OFFSET(1)] = hub.id
        LEFT JOIN (
            SELECT DISTINCT
                country_iso,
                city
            FROM `flink-backend.gsheet_store_metadata.hubs`
             ) country
        ON event.hub_city = country.city
UNION ALL
    SELECT
          event.event,
          event.anonymous_id,
          event.timestamp,
          event.hub_city,
          country.country_iso as hub_country,
          event.hub_code AS hub_encoded,
          event.delivery_postcode,
          hub.slug as hub_code,
          SPLIT(SAFE_CONVERT_BYTES_TO_STRING(FROM_BASE64(regexp_extract(hub_code, "^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/][AQgw]==|[A-Za-z0-9+/]{2}[AEIMQUYcgkosw048]=)?$"))),':')[ OFFSET(1)] AS hub_id,
          CAST(event.delivery_eta as INT) as delivery_eta
    FROM `flink-backend.flink_ios_production.order_placed_view` event
        LEFT JOIN
            `flink-backend.saleor_db_global.warehouse_warehouse` AS hub
        ON SPLIT(SAFE_CONVERT_BYTES_TO_STRING(FROM_BASE64(regexp_extract(event.hub_code, "^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/][AQgw]==|[A-Za-z0-9+/]{2}[AEIMQUYcgkosw048]=)?$"))),':')[ OFFSET(1)] = hub.id
        LEFT JOIN (
            SELECT DISTINCT
                country_iso,
                city
            FROM `flink-backend.gsheet_store_metadata.hubs`
             ) country
        ON event.hub_city = country.city
UNION ALL
    SELECT
          event.event,
          event.anonymous_id,
          event.timestamp,
          event.hub_city,
          country.country_iso as hub_country,
          event.hub_code AS hub_encoded,
          event.delivery_postcode,
          hub.slug as hub_code,
          SPLIT(SAFE_CONVERT_BYTES_TO_STRING(FROM_BASE64(regexp_extract(hub_code, "^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/][AQgw]==|[A-Za-z0-9+/]{2}[AEIMQUYcgkosw048]=)?$"))),':')[ OFFSET(1)] AS hub_id,
          delivery_eta
    FROM `flink-backend.flink_android_production.order_placed_view` event
        LEFT JOIN
            `flink-backend.saleor_db_global.warehouse_warehouse` AS hub
        ON SPLIT(SAFE_CONVERT_BYTES_TO_STRING(FROM_BASE64(regexp_extract(event.hub_code, "^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/][AQgw]==|[A-Za-z0-9+/]{2}[AEIMQUYcgkosw048]=)?$"))),':')[ OFFSET(1)] = hub.id
        LEFT JOIN (
            SELECT DISTINCT
                country_iso,
                city
            FROM `flink-backend.gsheet_store_metadata.hubs`
             ) country
        ON event.hub_city = country.city
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
     , hub_country
     , hub_city
     , hub_code
     , hub_id
     , delivery_postcode
     , delivery_eta
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
        , hd.hub_id
        , hd.hub_code
        , hd.hub_country
        , hd.hub_city
        , hd.delivery_postcode
        , hd.delivery_eta
        , DENSE_RANK() OVER (PARTITION BY ts.anonymous_id, ts.session_id ORDER BY hd.timestamp DESC) as rank_hd -- ranks all data_hub related events // filter set = 1 to get 'latest' timestamp
    FROM tracking_sessions ts
            LEFT JOIN (
                SELECT
                    anonymous_id
                  , timestamp
                  , hub_id
                  , hub_code
                  , hub_city
                  , hub_country
                  , delivery_postcode
                  , delivery_eta
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

, location_pin_placed AS (
    SELECT
           sf.anonymous_id
         , sf.session_id
         , count(e.timestamp) as event_count
    FROM events e
        LEFT JOIN sessions_final sf
        ON e.anonymous_id = sf.anonymous_id
        AND e.timestamp >= sf.session_start_at
        AND ( e.timestamp < sf.next_session_start_at OR next_session_start_at IS NULL)
    WHERE e.event = 'location_pin_placed'
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

, first_order AS (
    SELECT
           e.anonymous_id
         , MIN(e.timestamp) as first_order_timestamp
    FROM events e
    WHERE e.event = 'order_placed'
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
          'Europe/Berlin') AS session_start_at
        , datetime(sf.next_session_start_at,
          'Europe/Berlin') AS next_session_start_at
        , sf.hub_id
        , sf.hub_code
        , sf.hub_country
        , sf.hub_city
        , sf.delivery_postcode
        , sf.delivery_eta
        , atc.event_count as add_to_cart
        , lpp.event_count as location_pin_placed
        , hv.event_count as home_viewed
        , cv.event_count as view_cart
        , ac.event_count as address_confirmed
        , cs.event_count as checkout_started
        , pc.event_count as payment_started
        , op.event_count as order_placed
        , CASE WHEN fo.first_order_timestamp < sf.session_start_at THEN true ELSE false END as has_ordered
    FROM sessions_final sf
        LEFT JOIN add_to_cart atc
        ON sf.session_id = atc.session_id
        LEFT JOIN location_pin_placed lpp
        ON sf.session_id = lpp.session_id
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

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: cnt_unique_anonymousid {
    label: "# Unique Users"
    description: "Number of Unique Users identified via Anonymous ID from Segment"
    hidden:  no
    type: count_distinct
    sql: ${anonymous_id};;
    value_format_name: decimal_0
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

  dimension: hub_id {
    type: string
    sql: ${TABLE}.hub_id ;;
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

  dimension: delivery_postcode {
    type: string
    sql: ${TABLE}.delivery_postcode ;;
  }

  dimension: delivery_eta {
    type: number
    sql: ${TABLE}.delivery_eta ;;
  }

  dimension: add_to_cart {
    type: number
    sql: ${TABLE}.add_to_cart ;;
  }

  dimension: location_pin_placed {
    type: number
    sql: ${TABLE}.location_pin_placed ;;
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

  dimension_group: session_start_at {
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

  dimension: session_start_date_granularity {
    label: "Session Start Date (Dynamic)"
    label_from_parameter: timeframe_picker
    type: string # cannot have this as a time type. See this discussion: https://community.looker.com/lookml-5/dynamic-time-granularity-opinions-16675
    sql:
    {% if timeframe_picker._parameter_value == 'Day' %}
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

  measure: cnt_address_selected {
    label: "Address selected count"
    description: "Number of sessions in which at least one Address Confirmed event happened"
    type: count
    filters: [address_confirmed: "NOT NULL"]
  }

  measure: cnt_location_pin_placed {
    label: "Location pin placed count"
    description: "Number of sessions in which at least one Location Pin Placed event happened"
    type: count
    filters: [location_pin_placed: "NOT NULL"]
  }

  measure: cnt_home_viewed {
    label: "Home view count"
    description: "Number of sessions in which at least one Home Viewed event happened"
    type: count
    filters: [home_viewed: "NOT NULL"]
  }

  measure: cnt_add_to_cart {
    label: "Add to cart count"
    description: "Number of sessions in which at least one Product Added To Cart event happened"
    type: count
    filters: [add_to_cart: "NOT NULL"]
  }

  measure: cnt_view_cart {
    label: "View cart count"
    description: "Number of sessions in which at least one Cart Viewed event happened"
    type: count
    filters: [view_cart: "NOT NULL"]
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


  measure: sum_address_selected {
    label: "Address selected sum of events"
    type: sum
    sql: ${address_confirmed} ;;
  }

  measure: sum_location_pin_placed {
    label: "Location pin placed sum of events"
    type: sum
    sql: ${location_pin_placed} ;;
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

  measure: sum_view_cart {
    label: "View cart sum of events"
    type: sum
    sql: ${view_cart} ;;
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

  measure: mcvr1 {
    type: number
    description: "Number of sessions in which an Addres Confirmed event happened, compared to the total number of Session Started"
    value_format_name: percent_1
    sql: ${cnt_address_selected}/NULLIF(${count},0) ;;
  }

  measure: mcvr2 {
    type: number
    description: "Number of sessions in which there was a Product Added To Cart, compared to the number of sessions in which there was a Home Viewed"
    value_format_name: percent_1
    sql: ${cnt_add_to_cart}/NULLIF(${cnt_home_viewed},0) ;;
  }

  measure: mcvr3 {
    type: number
    description: "Number of sessions in which there was a Checkout Started event happened, compared to the number of sessions in which there was a Product Added To Cart"
    value_format_name: percent_1
    sql: ${cnt_checkout_started}/NULLIF(${cnt_add_to_cart},0) ;;
  }

  measure: mcvr4 {
    type: number
    description: "Number of sessions in which there was a Payment Started event happened, compared to the number of sessions in which there was a Checkout Started"
    value_format_name: percent_1
    sql: ${cnt_payment_started}/NULLIF(${cnt_checkout_started},0) ;;
  }

  measure: payment_success {
    type: number
    description: "Number of sessions in which there was an Order Placed, compared to the number of sessions in which there was a Payment Started"
    value_format_name: percent_1
    sql: ${cnt_purchase}/NULLIF(${cnt_payment_started},0) ;;
  }

  set: detail {
    fields: [
      anonymous_id,
      session_id,
      context_locale,
      context_device_type,
      context_app_version,
      # session,
      session_number,
      has_ordered,
      hub_city,
      hub_code,
      hub_country,
      add_to_cart,
      location_pin_placed,
      home_viewed,
      view_cart,
      address_confirmed,
      checkout_started,
      payment_started,
      order_placed
    ]
  }
}
