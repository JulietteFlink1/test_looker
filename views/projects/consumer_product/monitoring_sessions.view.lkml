view: monitoring_sessions {
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

  , address_resolution_failed_data AS (-- ios & android pulling address_resolution_failed data for is_inside_delivery_area
      SELECT
            event.event,
            event.anonymous_id,
            event.timestamp,
            event.is_inside_delivery_area
      FROM `flink-data-prod.flink_ios_production.address_resolution_failed_view` event
       -- WHERE event.location_selection_method = "locateMe" OR event.location_selection_method="addressSearch"

      UNION ALL

      SELECT
            event.event,
            event.anonymous_id,
            event.timestamp,
            event.is_inside_delivery_area
      FROM `flink-data-prod.flink_android_production.address_resolution_failed_view` event
      -- WHERE event.location_selection_method = "locateMe" OR event.location_selection_method="addressSearch"
  )

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
        -- , hd.delivery_postcode
        , hd.delivery_eta
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
                  -- , delivery_postcode
                  , delivery_eta
                  , has_address
                FROM hub_data
            ) hd
            ON ts.anonymous_id = hd.anonymous_id
            AND ( hd.timestamp < ts.next_session_start_at OR ts.next_session_start_at IS NULL)
        )

      WHERE
      rank_hd = 1  -- filter set = 1 to get 'latest' timestamp
    GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13
  ),

event_counts AS (
       SELECT
           sf.anonymous_id
         , sf.session_id
         , SUM(CASE WHEN e.event="home_viewed" THEN 1 ELSE 0 END) as hv_count
         , SUM(CASE WHEN e.event="home_error_viewed" THEN 1 ELSE 0 END) as hev_count
         , SUM(CASE WHEN e.event="home_error_retry_selected" THEN 1 ELSE 0 END) as hers_count
         , SUM(CASE WHEN e.event="cities_viewed" THEN 1 ELSE 0 END) as cv_count
         , SUM(CASE WHEN e.event="city_not_available_selected" THEN 1 ELSE 0 END) as cnas_count
         , SUM(CASE WHEN e.event="countries_viewed" THEN 1 ELSE 0 END) as cov_count
         , SUM(CASE WHEN e.event="country_not_available_selected" THEN 1 ELSE 0 END) as conas_count
         , SUM(CASE WHEN e.event="purchase_confirmed" THEN 1 ELSE 0 END) as pc_count
         , SUM(CASE WHEN e.event="payment_failed" THEN 1 ELSE 0 END) as pf_count
        FROM events e
            LEFT JOIN sessions_final sf
            ON e.anonymous_id = sf.anonymous_id
            AND e.timestamp >= sf.session_start_at
            AND ( e.timestamp < sf.next_session_start_at OR next_session_start_at IS NULL)
        GROUP BY 1,2
    )

, address_resolution_failed_inside_area AS (
    SELECT
           sf.anonymous_id
         , sf.session_id
         , count(e.timestamp) as event_count
    FROM address_resolution_failed_data e
        LEFT JOIN sessions_final sf
        ON e.anonymous_id = sf.anonymous_id
        AND e.timestamp >= sf.session_start_at
        AND ( e.timestamp < sf.next_session_start_at OR next_session_start_at IS NULL)
    WHERE e.is_inside_delivery_area=true
    GROUP BY 1,2
)

, address_resolution_failed_outside_area AS (
    SELECT
           sf.anonymous_id
         , sf.session_id
         , count(e.timestamp) as event_count
    FROM address_resolution_failed_data e
        LEFT JOIN sessions_final sf
        ON e.anonymous_id = sf.anonymous_id
        AND e.timestamp >= sf.session_start_at
        AND ( e.timestamp < sf.next_session_start_at OR next_session_start_at IS NULL)
    WHERE e.is_inside_delivery_area=false
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
        , afi.event_count as address_resolution_failed_inside_area
        , afo.event_count as address_resolution_failed_outside_area
        , ec.hv_count as home_viewed
        , ec.hev_count as home_error_viewed
        , ec.hers_count as home_error_retry_selected
        , ec.cv_count as cities_viewed
        , ec.cnas_count as city_not_available_selected
        , ec.cov_count as countries_viewed
        , ec.conas_count as country_not_available_selected
        , ec.pc_count as payment_started
        , ec.pf_count as payment_failed
        --, CASE WHEN fo.first_order_timestamp < sf.session_start_at THEN true ELSE false END as has_ordered
    FROM sessions_final sf
        LEFT JOIN event_counts  ec
        ON sf.session_id = ec.session_id
        LEFT JOIN address_resolution_failed_inside_area afi
        ON sf.session_id = afi.session_id
        LEFT JOIN address_resolution_failed_outside_area afo
        ON sf.session_id = afo.session_id
 ;;
  }

### Custom dimensions and measures
  dimension: full_app_version {
    type: string
    sql: ${context_device_type} || '-' || ${context_app_version} ;;
  }

  measure: cnt_unique_anonymousid {
    label: "Count Unique Users"
    description: "Number of Unique Users identified via Anonymous ID from Segment"
    hidden:  no
    type: count_distinct
    sql: ${anonymous_id};;
    value_format_name: decimal_0
  }

  measure: cnt_home_viewed {
    label: "Home Viewed count"
    description: "# sessions in which Home Viewed occurred"
    type: count
    filters: [home_viewed: ">0"]
  }

  measure: sum_home_viewed {
    label: "Home Viewed sum of events"
    type: sum
    sql: ${home_viewed} ;;
  }

  measure: cnt_home_error_viewed {
    label: "Home Error Viewed count"
    description: "# sessions in which Home Error Viewed occurred"
    type: count
    filters: [home_error_viewed: ">0"]
  }

  measure: sum_home_error_viewed {
    label: "Home Error Viewed sum of events"
    type: sum
    sql: ${home_error_viewed} ;;
  }

  measure: cnt_home_error_retry_selected {
    label: "Home Error Retry count"
    description: "# sessions in which Home Error Retry was selected"
    type: count
    filters: [home_error_retry_selected: ">0"]
  }

  measure: sum_home_error_retry_selected {
    label: "Home Error Retry sum of events"
    type: sum
    sql: ${home_error_retry_selected} ;;
  }

  measure: cnt_cities_viewed {
    label: "Cities Viewed count"
    description: "# sessions in which the Cities Selection screen was viewed"
    type: count
    filters: [cities_viewed: ">0"]
  }

  measure: sum_cities_viewed {
    label: "Cities Viewed sum of events"
    type: sum
    sql: ${cities_viewed} ;;
  }

  measure: cnt_city_not_available_selected {
    label: "City Not Available count"
    description: "# sessions in which City Not Available was selected"
    type: count
    filters: [city_not_available_selected: ">0"]
  }

  measure: sum_city_not_available_selected {
    label: "City Not Available sum of events"
    type: sum
    sql: ${city_not_available_selected} ;;
  }

  measure: cnt_countries_viewed {
    label: "Countries Viewed count"
    description: "# sessions in which the Countries Selection screen was viewed"
    type: count
    filters: [countries_viewed: ">0"]
  }

  measure: sum_countries_viewed {
    label: "Countries Viewed sum of events"
    type: sum
    sql: ${countries_viewed} ;;
  }

  measure: cnt_country_not_available_selected {
    label: "Country Not Available count"
    description: "# sessions in which Country Not Available was selected"
    type: count
    filters: [country_not_available_selected: ">0"]
  }

  measure: sum_country_not_available_selected {
    label: "Country Not Available sum of events"
    type: sum
    sql: ${country_not_available_selected} ;;
  }

  measure: cnt_payment_started {
    label: "Payment Started count"
    description: "# sessions in which Payment Started occurred"
    type: count
    filters: [payment_started: ">0"]
  }

  measure: sum_payment_started {
    label: "Payment Started sum of events"
    type: sum
    sql: ${payment_started} ;;
  }

  measure: cnt_payment_failed {
    label: "Payment Failed count"
    description: "# sessions in which Payment Failed occurred"
    type: count
    filters: [payment_failed: ">0"]
  }

  measure: sum_payment_failed {
    label: "Payment Failed sum of events"
    type: sum
    sql: ${payment_failed} ;;
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

  dimension: address_resolution_failed_inside_area {
    type: number
    sql: ${TABLE}.address_resolution_failed_inside_area ;;
  }

  dimension: address_resolution_failed_outside_area {
    type: number
    sql: ${TABLE}.address_resolution_failed_outside_area ;;
  }

  dimension: home_viewed {
    type: number
    sql: ${TABLE}.home_viewed ;;
  }

  dimension: home_error_viewed {
    type: number
    sql: ${TABLE}.home_error_viewed ;;
  }

  dimension: home_error_retry_selected {
    type: number
    sql: ${TABLE}.home_error_retry_selected ;;
  }

  dimension: cities_viewed {
    type: number
    sql: ${TABLE}.cities_viewed ;;
  }

  dimension: city_not_available_selected {
    type: number
    sql: ${TABLE}.city_not_available_selected ;;
  }

  dimension: countries_viewed {
    type: number
    sql: ${TABLE}.countries_viewed ;;
  }

  dimension: country_not_available_selected {
    type: number
    sql: ${TABLE}.country_not_available_selected ;;
  }

  dimension: payment_started {
    type: number
    sql: ${TABLE}.payment_started ;;
  }

  dimension: payment_failed {
    type: number
    sql: ${TABLE}.payment_failed ;;
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
      address_resolution_failed_inside_area,
      address_resolution_failed_outside_area,
      home_viewed,
      home_error_viewed,
      home_error_retry_selected,
      cities_viewed,
      city_not_available_selected,
      countries_viewed,
      country_not_available_selected,
      payment_started,
      payment_failed
    ]
  }
}
