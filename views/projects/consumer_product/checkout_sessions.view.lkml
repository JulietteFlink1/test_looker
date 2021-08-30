view: checkout_sessions {
  derived_table: {
    sql: WITH
        location_joined_table AS (
        SELECT
          tracks.anonymous_id, tracks.context_app_build, tracks.context_app_version, CAST(NULL AS BOOL) AS context_device_ad_tracking_enabled, tracks.context_device_id, tracks.context_device_manufacturer, tracks.context_device_model, tracks.context_device_name, tracks.context_device_type, tracks.context_ip, tracks.context_library_name, tracks.context_library_version, tracks.context_locale, CAST(NULL AS BOOL) AS context_network_bluetooth, tracks.context_network_carrier, tracks.context_network_cellular, tracks.context_network_wifi, tracks.context_os_name, tracks.context_os_version, tracks.context_protocols_source_id, tracks.context_timezone, CAST(NULL AS STRING) AS context_traits_anonymous_id, CAST(NULL AS STRING) AS context_user_agent, tracks.event, tracks.event_text, tracks.id, tracks.loaded_at, tracks.original_timestamp, tracks.received_at, tracks.sent_at, tracks.timestamp, tracks.uuid_ts,
          TIMESTAMP_DIFF(tracks.timestamp,LAG(tracks.timestamp) OVER(PARTITION BY tracks.anonymous_id ORDER BY tracks.timestamp), MINUTE) AS inactivity_time,
          tracks.event="order_placed" AS ordered_tmp,
          --the following is not entirely elegant as it starts a new block with every order_placed, but the results are correct
          SUM(CASE
              WHEN tracks.event="order_placed" THEN 1
            ELSE
            0
          END
        ) OVER(PARTITION BY tracks.anonymous_id ORDER BY tracks.timestamp) AS has_ordered_block_per_id,
          event.hub_city,
          event.hub_code AS hub_encoded,
          event.delivery_lat,
          event.delivery_lng,
          event.delivery_postcode,
          event.user_area_available,
          SPLIT(SAFE_CONVERT_BYTES_TO_STRING(FROM_BASE64(regexp_extract(hub_code, "^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/][AQgw]==|[A-Za-z0-9+/]{2}[AEIMQUYcgkosw048]=)?$"))),':')[
        OFFSET
          (1)] AS hub_id
        FROM
          `flink-backend.flink_ios_production.tracks_view` tracks
        LEFT JOIN
          `flink-backend.flink_ios_production.address_confirmed_view` event
        ON
          tracks.id=event.id
        WHERE
          tracks.event NOT LIKE "%api%"
          AND tracks.event NOT LIKE "%adjust%"
          AND tracks.event NOT LIKE "%install_attributed%"
          AND NOT (tracks.context_app_version LIKE "%APP-RATING%" OR tracks.context_app_version LIKE "%DEBUG%")
          AND NOT (tracks.context_app_name = "Flink-Staging" OR tracks.context_app_name="Flink-Debug")

        UNION ALL

        SELECT
          tracks.anonymous_id, tracks.context_app_build, tracks.context_app_version, tracks.context_device_ad_tracking_enabled, tracks.context_device_id, tracks.context_device_manufacturer, tracks.context_device_model, tracks.context_device_name, tracks.context_device_type, tracks.context_ip, tracks.context_library_name, tracks.context_library_version, tracks.context_locale, tracks.context_network_bluetooth, tracks.context_network_carrier, tracks.context_network_cellular, tracks.context_network_wifi, tracks.context_os_name, tracks.context_os_version, tracks.context_protocols_source_id, tracks.context_timezone, tracks.context_traits_anonymous_id, tracks.context_user_agent, tracks.event, tracks.event_text, tracks.id, tracks.loaded_at, tracks.original_timestamp, tracks.received_at, tracks.sent_at, tracks.timestamp, tracks.uuid_ts,
          TIMESTAMP_DIFF(tracks.timestamp,LAG(tracks.timestamp) OVER(PARTITION BY tracks.anonymous_id ORDER BY tracks.timestamp), MINUTE) AS inactivity_time,
          tracks.event="order_placed" AS ordered_tmp,
          --the following is not entirely elegant as it starts a new block with every order_placed, but the results are correct
          SUM(CASE
              WHEN tracks.event="order_placed" THEN 1
            ELSE
            0
          END
        ) OVER(PARTITION BY tracks.anonymous_id ORDER BY tracks.timestamp) AS has_ordered_block_per_id,
          event.hub_city,
          event.hub_code AS hub_encoded,
          event.delivery_lat,
          event.delivery_lng,
          event.delivery_postcode,
          event.user_area_available,
          SPLIT(SAFE_CONVERT_BYTES_TO_STRING(FROM_BASE64(regexp_extract(hub_code, "^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/][AQgw]==|[A-Za-z0-9+/]{2}[AEIMQUYcgkosw048]=)?$"))),':')[
        OFFSET
          (1)] AS hub_id
        FROM
          `flink-backend.flink_android_production.tracks_view` tracks
        LEFT JOIN
          `flink-backend.flink_android_production.address_confirmed_view` event
        ON
          tracks.id=event.id
        WHERE
          tracks.event NOT LIKE "%api%"
          AND tracks.event NOT LIKE "%adjust%"
          AND tracks.event NOT LIKE "%install_attributed%"
          AND NOT (tracks.context_app_version LIKE "%APP-RATING%" OR tracks.context_app_version LIKE "%DEBUG%")
          AND NOT (tracks.context_app_name = "Flink-Staging" OR tracks.context_app_name="Flink-Debug")
        ),

        location_help_table AS (
        SELECT
          location_joined_table.*,
          IF
          (derived_city LIKE "Mülheim%"
            OR derived_city LIKE "%Ludwigshafen%",
            "DE",
            country_iso) AS country_iso,
          -- divide events into blocks, belonging to the last seen "addressConfirmed" event
          SUM(CASE
              WHEN hub_city IS NULL THEN 0
            ELSE
            1
          END
            ) OVER(PARTITION BY anonymous_id ORDER BY timestamp) AS block,
          -- translate the hub-id into hub-code
          hub.slug AS hub_code
        FROM
          location_joined_table
        LEFT JOIN
          `flink-data-prod.saleor_prod_global.warehouse_warehouse` AS hub
        ON
          location_joined_table.hub_id = hub.id
        ORDER BY
          anonymous_id,
          timestamp ),

        country_lookup AS (
        SELECT
          DISTINCT country_iso,
          city
        FROM
          `flink-backend.gsheet_store_metadata.hubs` ),

      location_table AS (
       SELECT
         location_help_table.*, country_lookup.country_iso  as lookup_country_iso,
         CASE
           WHEN FIRST_VALUE(location_help_table.hub_code) OVER (PARTITION BY location_help_table.anonymous_id, block ORDER BY location_help_table.timestamp) IS NOT NULL THEN FIRST_VALUE(location_help_table.country_iso) OVER (PARTITION BY location_help_table.anonymous_id, block ORDER BY location_help_table.timestamp)
           WHEN FIRST_VALUE(location_help_table.hub_city) OVER (PARTITION BY location_help_table.anonymous_id, block ORDER BY location_help_table.timestamp) IS NOT NULL THEN FIRST_VALUE(country_lookup.country_iso) OVER (PARTITION BY location_help_table.anonymous_id, block ORDER BY location_help_table.timestamp)
         ELSE
         SUBSTRING(location_help_table.context_locale,
           4,
           2)
       END
         AS derived_country_iso,
         (FIRST_VALUE(hub_city) OVER (PARTITION BY location_help_table.anonymous_id, block ORDER BY location_help_table.timestamp) IS NOT NULL
           AND FIRST_VALUE(location_help_table.hub_code) OVER (PARTITION BY location_help_table.anonymous_id, block ORDER BY location_help_table.timestamp) IS NULL) AS country_derived_from_city,
         (FIRST_VALUE(hub_city) OVER (PARTITION BY location_help_table.anonymous_id, block ORDER BY location_help_table.timestamp) IS NULL
           AND FIRST_VALUE(location_help_table.hub_code) OVER (PARTITION BY location_help_table.anonymous_id, block ORDER BY location_help_table.timestamp) IS NULL) AS country_derived_from_locale,
         FIRST_VALUE(location_help_table.hub_city) OVER (PARTITION BY location_help_table.anonymous_id, block ORDER BY location_help_table.timestamp) AS derived_city,
         FIRST_VALUE(location_help_table.hub_code) OVER (PARTITION BY location_help_table.anonymous_id, block ORDER BY location_help_table.timestamp) AS derived_hub,
         FIRST_VALUE(ordered_tmp) OVER (PARTITION BY location_help_table.anonymous_id, has_ordered_block_per_id ORDER BY location_help_table.timestamp) AS has_ordered
       FROM
         location_help_table
       LEFT JOIN
         country_lookup
       ON
         country_lookup.city = location_help_table.hub_city
       ORDER BY
         anonymous_id,
         timestamp),

        tracking_sessions AS (
        SELECT
          anonymous_id || '-' || ROW_NUMBER() OVER(PARTITION BY anonymous_id ORDER BY timestamp) AS session_id,
          *,
          timestamp AS session_start_at,
          LEAD(timestamp) OVER(PARTITION BY anonymous_id ORDER BY timestamp) AS next_session_start_at,
        FROM
          location_table
        WHERE
          (location_table.inactivity_time > 30
            OR location_table.inactivity_time IS NULL)
        ORDER BY
          1),

      payment_started AS (
      SELECT
        tracking_sessions.anonymous_id,
        tracking_sessions.session_id,
        COUNT(*) AS event_count
      FROM
        location_table
      LEFT JOIN
        tracking_sessions
      ON
        location_table.anonymous_id = tracking_sessions.anonymous_id
        AND location_table.timestamp >= tracking_sessions.session_start_at
        AND (location_table.timestamp < tracking_sessions.next_session_start_at
          OR tracking_sessions.next_session_start_at IS NULL)
      WHERE
        location_table.event='purchase_confirmed'
      GROUP BY
        1,
        2 ),

      payment_failed AS (
      SELECT
        tracking_sessions.anonymous_id,
        tracking_sessions.session_id,
        COUNT(*) AS event_count
      FROM
        location_table
      LEFT JOIN
        tracking_sessions
      ON
        location_table.anonymous_id = tracking_sessions.anonymous_id
        AND location_table.timestamp >= tracking_sessions.session_start_at
        AND (location_table.timestamp < tracking_sessions.next_session_start_at
          OR tracking_sessions.next_session_start_at IS NULL)
      WHERE
        location_table.event='payment_failed'
      GROUP BY
        1,
        2 ),

      order_placed AS (
      SELECT
        tracking_sessions.anonymous_id,
        tracking_sessions.session_id,
        COUNT(*) AS event_count
      FROM
        location_table
      LEFT JOIN
        tracking_sessions
      ON
        location_table.anonymous_id = tracking_sessions.anonymous_id
        AND location_table.timestamp >= tracking_sessions.session_start_at
        AND (location_table.timestamp < tracking_sessions.next_session_start_at
          OR tracking_sessions.next_session_start_at IS NULL)
      WHERE
        location_table.event='order_placed'
      GROUP BY
        1,
        2 )

      SELECT
        tracking_sessions.anonymous_id,
        tracking_sessions.session_id,
        datetime(tracking_sessions.session_start_at,
          'Europe/Berlin') AS session_start_at,
        datetime(tracking_sessions.next_session_start_at,
          'Europe/Berlin') AS next_session_start_at,
        tracking_sessions.context_locale,
        tracking_sessions.context_device_type,
        tracking_sessions.context_app_version,
        1 AS session,
        tracking_sessions.has_ordered,
        tracking_sessions.derived_country_iso,
        tracking_sessions.derived_city,
        tracking_sessions.derived_hub,
        tracking_sessions.country_derived_from_city,
        tracking_sessions.country_derived_from_locale,
        payment_started.event_count AS payment_started,
        payment_failed.event_count AS payment_failed,
        order_placed.event_count AS order_placed
      FROM
        tracking_sessions
      LEFT JOIN
        payment_started
      ON
        tracking_sessions.session_id=payment_started.session_id
      LEFT JOIN
        payment_failed
      ON
        tracking_sessions.session_id=payment_failed.session_id
      LEFT JOIN
        order_placed
      ON
        tracking_sessions.session_id=order_placed.session_id
      ORDER BY 1
 ;;
  }

  ### custom measures
  measure: cnt_payment_started {
    label: "Payment started count"
    description: "Number of sessions in which at least one Payment Started event happened"
    type: count
    filters: [payment_started: "NOT NULL"]
  }

  measure: cnt_payment_failed {
    label: "Payment failed count"
    description: "Number of sessions in which at least one Payment Failed event happened"
    type: count
    filters: [payment_failed: "NOT NULL"]
  }

  measure: cnt_payment_failed_no_order {
    label: "Payment failed and no order placed"
    description: "Number of sessions in which at least one Payment Failed event happened and there was no order placed in the session"
    type: count
    filters: [payment_failed: "NOT NULL", order_placed: "NULL"]
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

  ### standard measures

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: anonymous_id {
    type: string
    sql: ${TABLE}.anonymous_id ;;
  }

  dimension: session_id {
    type: string
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.session_id ;;
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

  dimension: context_locale {
    type: string
    sql: ${TABLE}.context_locale ;;
  }

  dimension: context_device_type {
    type: string
    sql: ${TABLE}.context_device_type ;;
  }

  dimension: context_app_version {
    type: string
    sql: ${TABLE}.context_app_version ;;
  }

  dimension: session {
    type: number
    sql: ${TABLE}.session ;;
  }

  dimension: has_ordered {
    type: yesno
    sql: ${TABLE}.has_ordered ;;
  }

  dimension: derived_country_iso {
    type: string
    sql: ${TABLE}.derived_country_iso ;;
  }

  dimension: derived_city {
    type: string
    sql: ${TABLE}.derived_city ;;
  }

  dimension: derived_hub {
    type: string
    sql: ${TABLE}.derived_hub ;;
  }

  dimension: country_derived_from_city {
    type: string
    sql: ${TABLE}.country_derived_from_city ;;
  }

  dimension: country_derived_from_locale {
    type: string
    sql: ${TABLE}.country_derived_from_locale ;;
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

  set: detail {
    fields: [
      anonymous_id,
      session_id,
      session_start_at_time,
      next_session_start_at_time,
      context_locale,
      context_device_type,
      context_app_version,
      session,
      has_ordered,
      derived_country_iso,
      derived_city,
      derived_hub,
      country_derived_from_city,
      country_derived_from_locale,
      payment_started,
      payment_failed,
      order_placed
    ]
  }
}
