view: checkout_sessions {
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
        FROM `flink-data-prod.flink_ios_production.address_confirmed_view` event
            LEFT JOIN
                `flink-data-prod.saleor_prod_global.warehouse_warehouse` AS hub
            ON SPLIT(SAFE_CONVERT_BYTES_TO_STRING(FROM_BASE64(regexp_extract(event.hub_code, "^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/][AQgw]==|[A-Za-z0-9+/]{2}[AEIMQUYcgkosw048]=)?$"))),':')[ OFFSET(1)] = hub.id
            LEFT JOIN (
                SELECT DISTINCT
                    country_iso,
                    city
                FROM `flink-data-prod.google_sheets.hub_metadata`
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
        FROM `flink-data-prod.flink_android_production.address_confirmed_view` event
            LEFT JOIN
                `flink-data-prod.saleor_prod_global.warehouse_warehouse` AS hub
            ON SPLIT(SAFE_CONVERT_BYTES_TO_STRING(FROM_BASE64(regexp_extract(event.hub_code, "^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/][AQgw]==|[A-Za-z0-9+/]{2}[AEIMQUYcgkosw048]=)?$"))),':')[ OFFSET(1)] = hub.id
            LEFT JOIN (
                SELECT DISTINCT
                    country_iso,
                    city
                FROM `flink-data-prod.google_sheets.hub_metadata`
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
        FROM `flink-data-prod.flink_ios_production.order_placed_view` event
            LEFT JOIN
                `flink-data-prod.saleor_prod_global.warehouse_warehouse` AS hub
            ON SPLIT(SAFE_CONVERT_BYTES_TO_STRING(FROM_BASE64(regexp_extract(event.hub_code, "^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/][AQgw]==|[A-Za-z0-9+/]{2}[AEIMQUYcgkosw048]=)?$"))),':')[ OFFSET(1)] = hub.id
            LEFT JOIN (
                SELECT DISTINCT
                    country_iso,
                    city
                FROM `flink-data-prod.google_sheets.hub_metadata`
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
        FROM `flink-data-prod.flink_android_production.order_placed_view` event
            LEFT JOIN
                `flink-data-prod.saleor_prod_global.warehouse_warehouse` AS hub
            ON SPLIT(SAFE_CONVERT_BYTES_TO_STRING(FROM_BASE64(regexp_extract(event.hub_code, "^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/][AQgw]==|[A-Za-z0-9+/]{2}[AEIMQUYcgkosw048]=)?$"))),':')[ OFFSET(1)] = hub.id
            LEFT JOIN (
                SELECT DISTINCT
                    country_iso,
                    city
                FROM `flink-data-prod.google_sheets.hub_metadata`
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
    GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13,14
    ),

    event_counts AS (
       SELECT
           sf.anonymous_id
         , sf.session_id
         , SUM(CASE WHEN e.event="address_confirmed" THEN 1 ELSE 0 END) as address_confirmed_event_count
         , SUM(CASE WHEN e.event="address_change_at_checkout_message_viewed" THEN 1 ELSE 0 END) as late_change_event_count
         , SUM(CASE WHEN e.event="hub_update_message_viewed" THEN 1 ELSE 0 END) as hub_update_event_count
         , SUM(CASE WHEN e.event="checkout_started" THEN 1 ELSE 0 END) as checkout_started_event_count
         , SUM(CASE WHEN e.event="purchase_confirmed" THEN 1 ELSE 0 END) as payment_started_event_count
         , SUM(CASE WHEN e.event="payment_failed" THEN 1 ELSE 0 END) as payment_failed_event_count
         , SUM(CASE WHEN e.event="order_placed" THEN 1 ELSE 0 END) as order_placed_event_count
        FROM events e
            LEFT JOIN sessions_final sf
            ON e.anonymous_id = sf.anonymous_id
            AND e.timestamp >= sf.session_start_at
            AND ( e.timestamp < sf.next_session_start_at OR next_session_start_at IS NULL)
        GROUP BY 1,2
    ),

    -- table to check whether checkout follows a hub_update message or hub_update message follows checkout (both are interesting)
    checkoutstarted_and_hubupdated_sequence AS (
       SELECT
           sf.anonymous_id
         , sf.session_id
         , e.event
         , e.timestamp
         , MAX(event="checkout_started") OVER
            (PARTITION BY session_id ORDER BY timestamp ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING)  AS preceeded_by_checkout_started
        , MAX(event="hub_update_message_viewed") OVER
            (PARTITION BY session_id ORDER BY timestamp ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING)  AS preceeded_by_hub_update
        , MAX(event="order_placed") OVER
            (PARTITION BY session_id ORDER BY timestamp ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING)  AS preceeded_by_order_placed
        FROM events e
            LEFT JOIN sessions_final sf
            ON e.anonymous_id = sf.anonymous_id
            AND e.timestamp >= sf.session_start_at
            AND ( e.timestamp < sf.next_session_start_at OR next_session_start_at IS NULL)
        WHERE e.event = 'checkout_started' OR e.event="hub_update_message_viewed" OR e.event="address_confirmed" OR e.event="order_placed"
    ),

    -- group the sequences to one session_id for merging with sessions table
    sequence_combined_tb AS (
      SELECT session_id
      , MAX(IF(event="checkout_started" AND preceeded_by_hub_update, TRUE, FALSE)) AS checkout_after_hub_update
      , MAX(IF(event="hub_update_message_viewed" AND preceeded_by_checkout_started, TRUE, FALSE)) AS hub_update_after_checkout
      , MAX(IF(event="address_confirmed" AND preceeded_by_checkout_started AND NOT(preceeded_by_order_placed), TRUE, FALSE)) AS address_confirm_after_checkout
       FROM checkoutstarted_and_hubupdated_sequence
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
        , sf.hub_id
        , sf.hub_code
        , sf.hub_country
        , sf.hub_city
        , sf.delivery_postcode
        , sf.delivery_eta
        , ec.payment_started_event_count as payment_started
        , ec.payment_failed_event_count as payment_failed
        , ec.order_placed_event_count as order_placed
        , ec.late_change_event_count as address_change_at_checkout
        , ec.hub_update_event_count as hub_update_message
        , ec.checkout_started_event_count as checkout_started
        , sc.checkout_after_hub_update
        , sc.hub_update_after_checkout
        , sc.address_confirm_after_checkout
        --, CASE WHEN fo.first_order_timestamp < sf.session_start_at THEN true ELSE false END as has_ordered
    FROM sessions_final sf
    LEFT JOIN event_counts ec
    ON sf.session_id=ec.session_id
    LEFT JOIN sequence_combined_tb sc
    ON sf.session_id=sc.session_id
    ORDER BY 1
 ;;
  }

  ### custom measures and dimensions
  dimension: is_first_session {
    type: yesno
    sql: ${TABLE}.session_number=1 ;;
  }

  measure: cnt_address_confirm_after_checkout {
    label: "Cnt Address Confirm After Checkout Started Sessions"
    description: "Number of sessions in which user confirmed an address after checkout was started without having placed an order inbetween"
    type: count
    filters: [address_confirm_after_checkout: "yes"]
  }

  measure: cnt_hub_update_after_checkout {
    label: "Cnt Hub Update Message Viewed After Checkout Started Sessions"
    description: "Number of sessions in which user lost their cart due to location update after checkout was started"
    type: count
    filters: [hub_update_after_checkout: "yes"]
  }

  measure: cnt_checkout_after_hub_update {
    label: "Cnt Checkout Started After Hub Update Message Viewed Sessions"
    description: "Number of sessions in which a checkout was started after the user lost their cart due to location update"
    type: count
    filters: [hub_update_after_checkout: "yes"]
  }

  measure: cnt_checkoutstarted_and_cart_lost {
    label: "Cnt Checkout Started And Hub Update Message Viewed Sessions"
    description: "Number of sessions in which a checkout was started and the user lost their cart due to location update (one event did not necessarily occur before the other)"
    type: count
    filters: [checkout_started: ">0", hub_update_message: ">0"]
  }

  measure: cnt_hub_update_message {
    label: "# Hub Update Message Viewed sessions"
    description: "# sessions with Hub Update Message Viewed event"
    type: count
    filters: [hub_update_message: ">0"]
  }

  measure: cnt_address_change_at_checkout {
    label: "# Address Change At Checkout Viewed sessions"
    description: "# sessions with Address Change At Checkout Viewed event"
    type: count
    filters: [address_change_at_checkout: ">0"]
  }

  measure: cnt_payment_started {
    label: "Payment started count"
    description: "Number of sessions in which at least one Payment Started event happened"
    type: count
    filters: [payment_started: ">0"]
  }

  measure: cnt_checkout_started {
    label: "Checkout started count"
    description: "Number of sessions in which at least one Checkout Started event happened"
    type: count
    filters: [checkout_started: ">0"]
  }

  measure: cnt_payment_failed {
    label: "Payment failed count"
    description: "Number of sessions in which at least one Payment Failed event happened"
    type: count
    filters: [payment_failed: ">0"]
  }

  measure: cnt_payment_failed_no_order {
    label: "Payment failed and no order placed"
    description: "Number of sessions in which at least one Payment Failed event happened and there was no order placed in the session"
    type: count
    filters: [payment_failed: ">0", order_placed: ">0"]
  }

  measure: cnt_unique_anonymousid {
    label: "Cnt Unique Users With Sessions"
    description: "Number of Unique Users identified via Anonymous ID from Segment that had a session"
    hidden:  no
    type: count_distinct
    sql: ${anonymous_id};;
    value_format_name: decimal_0
  }

  measure: paymentfailed_per_paymentstarted_perc{
    type: number
    sql: ${checkout_sessions.cnt_payment_failed}/NULLIF(${checkout_sessions.cnt_payment_started},0) ;;
    value_format_name: percent_1
    drill_fields: [session_start_at_date, paymentfailed_per_paymentstarted_perc]
    link: {
      label: "% Sessions Payment Failure And Payment Failure Without Order"
      url: "/looks/688"
    }
  }

  measure: paymentfailed_noorder_per_paymentstarted_perc{
    type: number
    sql: ${checkout_sessions.cnt_payment_failed_no_order}/NULLIF(${checkout_sessions.cnt_payment_started},0) ;;
    value_format_name: percent_1
    drill_fields: [session_start_at_date, paymentfailed_noorder_per_paymentstarted_perc]
    link: {
      label: "% Sessions Payment Failure And Payment Failure Without Order"
      url: "/looks/688"
    }
  }

  dimension: full_app_version {
    type: string
    sql: ${context_device_type} || '-' || ${context_app_version} ;;
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

  ### standard measures

  # warning: this typing will make all null values equal to false. In this dimension that seems appropriate
  dimension: address_confirm_after_checkout {
    type: yesno
    sql: ${TABLE}.address_confirm_after_checkout ;;
  }

  # warning: this typing will make all null values equal to false. In this dimension that seems appropriate
  dimension: hub_update_after_checkout {
    type: yesno
    sql: ${TABLE}.hub_update_after_checkout ;;
  }

  # warning: this typing will make all null values equal to false. In this dimension that seems appropriate
  dimension: checkout_after_hub_update {
    type: yesno
    sql: ${TABLE}.checkout_after_hub_update ;;
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

  dimension: checkout_started {
    type: number
    sql: ${TABLE}.checkout_started ;;
  }

  dimension: payment_started {
    type: number
    sql: ${TABLE}.payment_started ;;
  }

  dimension: payment_failed {
    type: number
    sql: ${TABLE}.payment_failed ;;
  }

  dimension: order_placed {
    type: number
    sql: ${TABLE}.order_placed ;;
  }

  dimension: address_change_at_checkout {
    type: number
    sql: ${TABLE}.address_change_at_checkout ;;
  }

  dimension: hub_update_message {
    type: number
    sql: ${TABLE}.hub_update_message ;;
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
      hub_id,
      hub_code,
      hub_country,
      hub_city,
      delivery_postcode,
      delivery_eta,
      payment_started,
      payment_failed,
      order_placed,
      address_change_at_checkout,
      hub_update_message,
      checkout_started
    ]
  }
}
