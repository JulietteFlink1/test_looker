view: segment_tracking_sessions30 {
  derived_table: {
    persist_for: "1 hour"
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
          AND tracks.context_app_version NOT LIKE "%APP-RATING%"
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
          AND tracks.context_app_version NOT LIKE "%APP-RATING%"
          AND NOT (tracks.context_app_name = "Flink-Staging" OR tracks.context_app_name="Flink-Debug")
        ),

        location_help_table AS (
        SELECT
          location_joined_table.*,
          country_iso,
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
          `flink-backend.saleor_db_global.warehouse_warehouse` AS hub
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
      #    anonymous_id,
      #    timestamp,
      #    id,
      #    context_locale,
      #    hub_city,
      #    hub_encoded,
      #    country_lookup.country_iso,
      #    block,
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

      add_to_cart AS (
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
        location_table.event='product_added_to_cart'
      GROUP BY
        1,
        2 ),

      location_pin_placed AS (
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
        location_table.event='location_pin_placed'
      GROUP BY
        1,
        2 ),

      home_viewed AS (
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
        location_table.event='home_viewed'
      GROUP BY
        1,
        2 ),
      view_cart AS (
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
        location_table.event='cart_viewed'
      GROUP BY
        1,
        2 ),
      address_confirmed AS (
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
        location_table.event='address_confirmed'
      GROUP BY
        1,
        2 ),
      checkout_started AS (
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
        location_table.event='checkout_started'
      GROUP BY
        1,
        2 ),
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
        add_to_cart.event_count AS add_to_cart,
        location_pin_placed.event_count AS location_pin_placed,
        home_viewed.event_count AS home_viewed,
        view_cart.event_count AS view_cart,
        address_confirmed.event_count AS address_confirmed,
        checkout_started.event_count AS checkout_started,
        payment_started.event_count AS payment_started,
        order_placed.event_count AS order_placed
      FROM
        tracking_sessions
      LEFT JOIN
        add_to_cart
      ON
        tracking_sessions.session_id=add_to_cart.session_id
      LEFT JOIN
        location_pin_placed
      ON
        tracking_sessions.session_id=location_pin_placed.session_id
      LEFT JOIN
        home_viewed
      ON
        tracking_sessions.session_id=home_viewed.session_id
      LEFT JOIN
        view_cart
      ON
        tracking_sessions.session_id=view_cart.session_id
      LEFT JOIN
        address_confirmed
      ON
        tracking_sessions.session_id=address_confirmed.session_id
      LEFT JOIN
        checkout_started
      ON
        tracking_sessions.session_id=checkout_started.session_id
      LEFT JOIN
        payment_started
      ON
        tracking_sessions.session_id=payment_started.session_id
      LEFT JOIN
        order_placed
      ON
        tracking_sessions.session_id=order_placed.session_id
      ORDER BY
        1
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

  dimension: session_id {
    type: string
    sql: ${TABLE}.session_id ;;
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
    type: string
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

### Custom dimensions
  dimension: full_app_version {
    type: string
    sql: ${context_device_type} || '-' || ${context_app_version} ;;
  }

  dimension: returning_customer {
    type: yesno
    sql: ${TABLE}.has_ordered ;;
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
        sql: ${TABLE}.derived_country_iso = "DE" ;;
        label: "Germany"
      }
      when: {
        sql: ${TABLE}.derived_country_iso = "FR" ;;
        label: "France"
      }
      when: {
        sql: ${TABLE}.derived_country_iso = "NL" ;;
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

  measure: sum_sessions {
    label: "Session sum"
    type: sum
    sql: ${session} ;;
  }


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
      session,
      has_ordered,
      derived_country_iso,
      derived_city,
      derived_hub,
      country_derived_from_city,
      country_derived_from_locale,
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
