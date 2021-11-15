view: location_segment_sessions {
  derived_table: {
    persist_for: "1 hour"
    sql: WITH
        pre_events AS ( -- ios all events
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
          , ROW_NUMBER() OVER (PARTITION BY tracks.id ORDER BY tracks.timestamp) AS row_id
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
          , ROW_NUMBER() OVER (PARTITION BY tracks.id ORDER BY tracks.timestamp) AS row_id
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

     , events AS (
        SELECT *
        FROM pre_events
        WHERE row_id =1
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

  , location_pin_placed_data AS (-- ios & android pulling location_pin_placed for user_area_available
      SELECT
            event.event,
            event.anonymous_id,
            event.timestamp,
            event.user_area_available
      FROM `flink-data-prod.flink_ios_production.location_pin_placed_view` event

      UNION ALL

      SELECT
            event.event,
            event.anonymous_id,
            event.timestamp,
            event.user_area_available
      FROM `flink-data-prod.flink_android_production.location_pin_placed_view` event
      -- WHERE event.location_selection_method = "locateMe" OR event.location_selection_method="addressSearch"
  )

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

      WHERE (hs.hub_code NOT IN('erp_spitzbergen', 'fr_hub_test', 'nl_hub_test', 'at_hub_test')
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
         , user_area_available
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
        , ld.user_area_available
        , DENSE_RANK() OVER (PARTITION BY ts.anonymous_id, ts.session_id ORDER BY hd.timestamp DESC) as rank_hd -- ranks all data_hub related events // filter set = 1 to get 'latest' timestamp
        , DENSE_RANK() OVER (PARTITION BY ts.anonymous_id, ts.session_id ORDER BY ld.timestamp DESC) as order_ld --ranks all location_pin_placed events to surface FALSE before TRUE
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

            LEFT JOIN (
                SELECT
                    anonymous_id
                  , timestamp
                  , user_area_available
                FROM location_pin_placed_data
            ) ld
            ON ts.anonymous_id = ld.anonymous_id
            AND ld.timestamp >= ts.session_start_at
            AND ( ld.timestamp < ts.next_session_start_at OR ts.next_session_start_at IS NULL)
        )

      WHERE
      rank_hd = 1  -- filter set = 1 to get 'latest' timestamp
  AND
      order_ld = 1 -- filter set = 1 to get last pin value - to get false if there is a false value (set DENSE_RANK ORDER BY ld.user_area_available ASC)
  GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13,14
  ),

event_counts AS (
       SELECT
           sf.anonymous_id
         , sf.session_id
         , SUM(CASE WHEN e.event="location_pin_placed" THEN 1 ELSE 0 END) as location_pin_placed_event_count
         , SUM(CASE WHEN e.event="address_skipped" THEN 1 ELSE 0 END) as address_skipped_event_count
         , SUM(CASE WHEN e.event="address_confirmed" THEN 1 ELSE 0 END) as address_confirmed_event_count
         , SUM(CASE WHEN e.event="waitlist_signup_selected" THEN 1 ELSE 0 END) as waitlist_signup_selected_event_count
         , SUM(CASE WHEN e.event="selection_browse_selected" THEN 1 ELSE 0 END) as selection_browse_selected_event_count
         , SUM(CASE WHEN e.event="home_viewed" THEN 1 ELSE 0 END) as home_viewed_event_count
         , SUM(CASE WHEN e.event="map_viewed" THEN 1 ELSE 0 END) as map_viewed_event_count
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
        -- , sf.hub_id
        , sf.hub_code
        , sf.hub_country
        , sf.hub_city
        -- , sf.delivery_postcode
        , sf.delivery_eta
        , sf.user_area_available
        , sf.has_address
        , ec.location_pin_placed_event_count as location_pin_placed
        , ec.address_skipped_event_count as address_skipped
        , ec.address_confirmed_event_count as address_confirmed
        , ec.waitlist_signup_selected_event_count as waitlist_signup_selected
        , ec.selection_browse_selected_event_count as selection_browse
        , afi.event_count as address_resolution_failed_inside_area
        , afo.event_count as address_resolution_failed_outside_area
        , ec.map_viewed_event_count as map_viewed
        --, hu.event_count as hub_updated
        --, acac.event_count as address_change_at_checkout
        -- , ae.event_count as any_event
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

  ## I want to additional fields: one is the hub that appOpened detected, one is a flag that says whether appOpened changed the hub assignment since the last other event happened

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: cnt_unique_anonymousid {
    label: "Count Unique Users"
    description: "Number of Unique Users identified via Anonymous ID from Segment"
    hidden:  no
    type: count_distinct
    sql: ${anonymous_id};;
    value_format_name: decimal_0
  }

  dimension: has_address_confirmed_event {
    type: yesno
    sql: ${TABLE}.address_confirmed >0 ;;
  }

  dimension: has_waitlist_signup_selected {
    type: yesno
    sql: ${TABLE}.waitlist_signup_selected >0;;
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
    primary_key: yes
    sql: ${TABLE}.session_id ;;
  }

  dimension: session_number {
    type: number
    sql: ${TABLE}.session_number ;;
  }

  # dimension: hub_id {
  #   type: string
  #   sql: ${TABLE}.hub_id ;;
  # }

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

  # dimension: delivery_postcode {
  #   type: string
  #   sql: ${TABLE}.delivery_postcode ;;
  # }

  dimension: delivery_eta {
    type: number
    sql: ${TABLE}.delivery_eta ;;
  }

  dimension: location_pin_placed {
    type: number
    sql: ${TABLE}.location_pin_placed ;;
  }

  dimension: user_area_available {
    type: string
    sql: CAST(${TABLE}.user_area_available AS STRING) ;;
    description: "FALSE if there is any locationPinPlaced event in the session for which user_area_available was FALSE, TRUE if not and NULL if there was no locationPinPlaced event)"
  }

  dimension: address_resolution_failed_inside_area {
    type: number
    sql: ${TABLE}.address_resolution_failed_inside_area ;;
    description: "Number of addressResolutionFailed events inside delivery area if there are any, NULL otherwise"
  }

  dimension: address_resolution_failed_outside_area {
    type: number
    sql: ${TABLE}.address_resolution_failed_outside_area ;;
    description: "Number of addressResolutionFailed events outside delivery area if there are any, NULL otherwise"
  }

  dimension: map_viewed {
    type: number
    sql: ${TABLE}.map_viewed ;;
  }

  # dimension: hub_updated {
  #   type: number
  #   sql: ${TABLE}.hub_updated ;;
  # }

  # dimension: address_change_at_checkout {
  #   type: number
  #   sql: ${TABLE}.address_change_at_checkout ;;
  # }

  dimension: address_skipped {
    type: number
    sql: ${TABLE}.address_skipped ;;
  }

  dimension: address_confirmed {
    type: number
    sql: ${TABLE}.address_confirmed ;;
  }

  dimension: waitlist_signup_selected {
    type: number
    sql: ${TABLE}.waitlist_signup_selected;;
  }

  dimension: selection_browse {
    type: number
    sql: ${TABLE}.selection_browse;;
  }

  dimension: has_address {
    type: yesno
    sql: ${TABLE}.has_address ;;
  }

  dimension: has_ordered {
    type: number
    sql: ${TABLE}.has_ordered ;;
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

### Custom dimensions
  dimension: full_app_version {
    type: string
    sql: ${context_device_type} || '-' || ${context_app_version} ;;
  }

  # dimension: returning_customer {
  #   type: yesno
  #   sql: ${TABLE}.has_ordered ;;
  # }

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
      when: {
        sql: ${TABLE}.hub_country = "AT" ;;
        label: "Austria"
      }
      else: "Other / Unknown"
    }
  }

##### Unique count of events during a session. If multiple events are triggerred during a session, e.g 3 times view item, the event is only counted once.

  measure: cnt_has_address {
    label: "Has address count"
    description: "# sessions in which the user had an address (selected in previous session or current)"
    type: count
    filters: [has_address: "yes"]
  }

  measure: cnt_address_selected {
    label: "Count sessions address confirmed"
    description: "Number of sessions in which at least one Address Confirmed event happened"
    type: count
    filters: [address_confirmed: ">0"]
  }

  measure: cnt_location_pin_placed {
    label: "Count sessions location pin placed"
    description: "Number of sessions in which at least one Location Pin Placed event happened"
    type: count
    filters: [location_pin_placed: ">0"]
  }

# for unknown reasons didn't work to count NOT NULL on waitlist_signup_selected, that's why created boolean and counting those
  measure: cnt_has_waitlist_signup_selected {
    label: "Count sessions waitlist intent"
    description: "Number of sessions in which Waitlist Signup Selected happened"
    type: count
    filters: [has_waitlist_signup_selected: "yes"]
  }

  measure: cnt_available_area {
    label: "Count sessions with available area"
    description: "Number of sessions in which at least one Location Pin Placed event landed on an available area"
    type: count
    filters: [user_area_available: "true"]
  }

  measure: cnt_unavailable_area {
    label: "Count sessions with unavailable area"
    description: "Number of sessions in which at least one Location Pin Placed event landed on an unavailable area"
    type: count
    filters: [user_area_available: "false"]
  }

  measure: cnt_address_skipped_in_available_area {
    label: "Count sessions available area with skipped address"
    description: "Number of sessions in which Address Skipped was selected at least once and the user was in an available area and did not confirm any address"
    type: count
    filters: [user_area_available: "true", address_skipped: ">0", address_confirmed: "0"]
  }

  measure: cnt_address_confirmed_area_available {
    label: "Count sessions available area with address confirmed"
    description: "Number of sessions in which Address Confirm was selected at least once and the user was in an available area"
    type: count
    filters: [user_area_available: "true", address_confirmed: ">0", address_skipped: "0"]
  }

  measure: cnt_confirmed_and_skipped_area_available {
    label: "Count sessions available area with address confirmed and address skipped events"
    description: "Number of sessions in which user was in an available area and both confirmed and skipped address at least once"
    type: count
    filters: [user_area_available: "true", address_confirmed: ">0", address_skipped: ">0"]
  }

  measure: cnt_noaction_area_available {
    label: "Count sessions available area without confirmation or skipping action"
    description: "Number of sessions in which the user was in an available area but did not perform any address confirmation or skipping action"
    type: count
    filters: [user_area_available: "true", address_confirmed: "0", address_skipped: "0"]
  }

  measure: cnt_waitlist_area_unavailable {
    label: "Count sessions unavailable area with waitlist intent"
    description: "Number of sessions in which the user was in an unavailable area and selected join waitlist"
    type: count
    filters: [user_area_available: "false", waitlist_signup_selected: ">0", selection_browse: "0"]
  }

  measure: cnt_browse_area_unavailable {
    label: "Count sessions unavailable area with product browsing"
    description: "Number of sessions in which the user was in an unavailable area and selected browse products"
    type: count
    filters: [user_area_available: "false", selection_browse: ">0", waitlist_signup_selected: "0"]
  }

  measure: cnt_waitlist_and_browse_area_unavailable {
    label: "Count sessions unavailable area with waitlist intent and product browsing"
    description: "Number of sessions in which the user was in an unavailable area and selected join waitlist and selected browse products"
    type: count
    filters: [user_area_available: "false", selection_browse: ">0", waitlist_signup_selected: ">0"]
  }

  measure: cnt_noaction_area_unavailable {
    label: "Count sessions unavailable area without waitlist intent or browsing"
    description: "Number of sessions in which the user was in an unavailable area and did not have a waitlist joining intent or browsing selection action"
    type: count
    filters: [user_area_available: "false", waitlist_signup_selected: "0", selection_browse: "0"]
  }

 # NOTE: want to update this to also be able to specify whether it's failed within delivery area or not
  measure: cnt_address_resolution_failed_inside_area {
    label: "Cnt Address Unidentified Inside Delivery Area Sessions"
    description: "Number of sessions in which there was at least one unidentified address inside delivery area"
    type: count
    filters: [address_resolution_failed_inside_area: ">0"]
  }

  measure: cnt_address_resolution_failed_outside_area {
    label: "Cnt Address Unidentified Outside Delivery Area Sessions"
    description: "Number of sessions in which there was at least one unidentified address outside delivery area"
    type: count
    filters: [address_resolution_failed_outside_area: ">0"]
  }

  measure: cnt_address_skipped {
    label: "Cnt Address Skipped Sessions"
    description: "Number of sessions in which at least one Address Skipped event happened"
    type: count
    filters: [address_skipped: ">0"]
  }

  measure: cnt_map_viewed {
    label: "Cnt Map Viewed Sessions"
    description: "Number of sessions with Map Viewed"
    type: count
    filters: [map_viewed: ">0"]
  }

  ## Measures based on other measures

  measure: mcvr1 {
    type: number
    description: "Number of sessions in which an Addres Confirmed event happened, compared to the total number of Session Started"
    value_format_name: percent_1
    sql: ${cnt_address_selected}/NULLIF(${count},0) ;;
  }

  set: detail {
    fields: [
      location_pin_placed,
      user_area_available,
      address_skipped,
      address_resolution_failed_inside_area,
      address_resolution_failed_outside_area,
      address_confirmed,
      waitlist_signup_selected,

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
      has_address,
      has_ordered
    ]
  }
}
