view: postorder_sessions {
  derived_table: {
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

    order_tracking_viewed AS (
    SELECT
           sf.anonymous_id
         , sf.session_id
         , count(e.timestamp) as event_count
    FROM events e
        LEFT JOIN sessions_final sf
        ON e.anonymous_id = sf.anonymous_id
        AND e.timestamp >= sf.session_start_at
        AND ( e.timestamp < sf.next_session_start_at OR next_session_start_at IS NULL)
    WHERE e.event = 'order_tracking_viewed'
    GROUP BY 1,2
    ),

    contact_customer_service AS (
    SELECT
           sf.anonymous_id
         , sf.session_id
         , count(e.timestamp) as event_count
    FROM events e
        LEFT JOIN sessions_final sf
        ON e.anonymous_id = sf.anonymous_id
        AND e.timestamp >= sf.session_start_at
        AND ( e.timestamp < sf.next_session_start_at OR next_session_start_at IS NULL)
    WHERE e.event = 'contact_customer_service_selected'
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
          'UTC') AS session_start_at
        , datetime(sf.next_session_start_at,
          'UTC') AS next_session_start_at
        , sf.hub_id
        , sf.hub_code
        , sf.hub_country
        , sf.hub_city
        , sf.delivery_postcode
        , sf.delivery_eta
        , ot.event_count as order_tracking_viewed
        , ccs.event_count as contact_customer_service
        , CASE WHEN fo.first_order_timestamp < sf.session_start_at THEN true ELSE false END as has_ordered
    FROM sessions_final sf
    LEFT JOIN order_tracking_viewed ot
    ON sf.session_id=ot.session_id
    LEFT JOIN contact_customer_service ccs
    ON sf.session_id=ccs.session_id
    LEFT JOIN first_order fo
    ON sf.anonymous_id = fo.anonymous_id
    ORDER BY 1
 ;;
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

  dimension: order_tracking_viewed {
    type: number
    sql: ${TABLE}.order_tracking_viewed ;;
  }

  dimension: contact_customer_service {
    type: number
    sql: ${TABLE}.contact_customer_service ;;
  }

  dimension: has_ordered {
    type: yesno
    sql: ${TABLE}.has_ordered ;;
  }

  dimension: returning_customer {
    type: yesno
    sql: ${has_ordered} ;;
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
      order_tracking_viewed,
      contact_customer_service,
      returning_customer
    ]
  }
}
