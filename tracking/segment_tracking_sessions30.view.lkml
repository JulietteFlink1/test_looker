view: segment_tracking_sessions30 {
  derived_table: {
    persist_for: "1 hour"
    sql: WITH
        tracking_sessions_ios AS (
        SELECT
          anonymous_id || '-' || ROW_NUMBER() OVER(PARTITION BY anonymous_id ORDER BY timestamp) AS session_id,
          *,
          timestamp AS session_start_at,
          LEAD(timestamp) OVER(PARTITION BY anonymous_id ORDER BY timestamp) AS next_session_start_at,
        FROM (
          SELECT
            *,
            TIMESTAMP_DIFF(timestamp,LAG(timestamp) OVER(PARTITION BY anonymous_id ORDER BY timestamp), MINUTE) AS inactivity_time
          FROM
            `flink-backend.flink_ios_production.tracks_view`
          WHERE
            NOT (context_app_name = "Flink-Staging" OR context_app_name="Flink-Debug")) event_ios
        WHERE
          (event_ios.inactivity_time > 30
            OR event_ios.inactivity_time IS NULL)
        ORDER BY
          1),
        add_to_cart_ios AS (
        SELECT
          tracking_sessions_ios.anonymous_id,
          tracking_sessions_ios.session_id,
          COUNT(*) AS event_count
        FROM
          `flink-backend.flink_ios_production.tracks_view` tracking_ios
        LEFT JOIN
          tracking_sessions_ios
        ON
          tracking_ios.anonymous_id = tracking_sessions_ios.anonymous_id
          AND tracking_ios.timestamp >= tracking_sessions_ios.session_start_at
          AND (tracking_ios.timestamp < tracking_sessions_ios.next_session_start_at
            OR tracking_sessions_ios.next_session_start_at IS NULL)
        WHERE
          tracking_ios.event='product_added_to_cart'
        GROUP BY
          1,
          2 ),

        location_pin_placed_ios AS (
        SELECT
          tracking_sessions_ios.anonymous_id,
          tracking_sessions_ios.session_id,
          COUNT(*) AS event_count
        FROM
          `flink-backend.flink_ios_production.tracks_view` tracking_ios
        LEFT JOIN
          tracking_sessions_ios
        ON
          tracking_ios.anonymous_id = tracking_sessions_ios.anonymous_id
          AND tracking_ios.timestamp >= tracking_sessions_ios.session_start_at
          AND (tracking_ios.timestamp < tracking_sessions_ios.next_session_start_at
            OR tracking_sessions_ios.next_session_start_at IS NULL)
        WHERE
          tracking_ios.event='location_pin_placed'
        GROUP BY
          1,
          2 ),

        home_viewed_ios AS (
        SELECT
          tracking_sessions_ios.anonymous_id,
          tracking_sessions_ios.session_id,
          COUNT(*) AS event_count
        FROM
          `flink-backend.flink_ios_production.tracks_view` tracking_ios
        LEFT JOIN
          tracking_sessions_ios
        ON
          tracking_ios.anonymous_id = tracking_sessions_ios.anonymous_id
          AND tracking_ios.timestamp >= tracking_sessions_ios.session_start_at
          AND (tracking_ios.timestamp < tracking_sessions_ios.next_session_start_at
            OR tracking_sessions_ios.next_session_start_at IS NULL)
        WHERE
          tracking_ios.event='home_viewed'
        GROUP BY
          1,
          2 ),

        view_item_ios AS (
        SELECT
          tracking_sessions_ios.anonymous_id,
          tracking_sessions_ios.session_id,
          COUNT(*) AS event_count
        FROM
          `flink-backend.flink_ios_production.tracks_view` tracking_ios
        LEFT JOIN
          tracking_sessions_ios
        ON
          tracking_ios.anonymous_id = tracking_sessions_ios.anonymous_id
          AND tracking_ios.timestamp >= tracking_sessions_ios.session_start_at
          AND (tracking_ios.timestamp < tracking_sessions_ios.next_session_start_at
            OR tracking_sessions_ios.next_session_start_at IS NULL)
        WHERE
          tracking_ios.event='product_details_viewed'
        GROUP BY
          1,
          2 ),

        view_cart_ios AS (
        SELECT
          tracking_sessions_ios.anonymous_id,
          tracking_sessions_ios.session_id,
          COUNT(*) AS event_count
        FROM
          `flink-backend.flink_ios_production.tracks_view` tracking_ios
        LEFT JOIN
          tracking_sessions_ios
        ON
          tracking_ios.anonymous_id = tracking_sessions_ios.anonymous_id
          AND tracking_ios.timestamp >= tracking_sessions_ios.session_start_at
          AND (tracking_ios.timestamp < tracking_sessions_ios.next_session_start_at
            OR tracking_sessions_ios.next_session_start_at IS NULL)
        WHERE
          tracking_ios.event='cart_viewed'
        GROUP BY
          1,
          2 ),

      address_confirmed_ios AS (
      SELECT
        tracking_sessions_ios.anonymous_id,
        tracking_sessions_ios.session_id,
        COUNT(*) AS event_count
      FROM
        `flink-backend.flink_ios_production.tracks_view` tracking_ios
      LEFT JOIN
        tracking_sessions_ios
      ON
        tracking_ios.anonymous_id = tracking_sessions_ios.anonymous_id
        AND tracking_ios.timestamp >= tracking_sessions_ios.session_start_at
        AND (tracking_ios.timestamp < tracking_sessions_ios.next_session_start_at
          OR tracking_sessions_ios.next_session_start_at IS NULL)
      WHERE
        tracking_ios.event='address_confirmed'
      GROUP BY
        1,
        2 ),

      checkout_started_ios AS (
      SELECT
        tracking_sessions_ios.anonymous_id,
        tracking_sessions_ios.session_id,
        COUNT(*) AS event_count
      FROM
        `flink-backend.flink_ios_production.tracks_view` tracking_ios
      LEFT JOIN
        tracking_sessions_ios
      ON
        tracking_ios.anonymous_id = tracking_sessions_ios.anonymous_id
        AND tracking_ios.timestamp >= tracking_sessions_ios.session_start_at
        AND (tracking_ios.timestamp < tracking_sessions_ios.next_session_start_at
          OR tracking_sessions_ios.next_session_start_at IS NULL)
      WHERE
        tracking_ios.event='checkout_started'
      GROUP BY
        1,
        2 ),


      payment_started_ios AS (
      SELECT
        tracking_sessions_ios.anonymous_id,
        tracking_sessions_ios.session_id,
        COUNT(*) AS event_count
      FROM
        `flink-backend.flink_ios_production.tracks_view` tracking_ios
      LEFT JOIN
        tracking_sessions_ios
      ON
        tracking_ios.anonymous_id = tracking_sessions_ios.anonymous_id
        AND tracking_ios.timestamp >= tracking_sessions_ios.session_start_at
        AND (tracking_ios.timestamp < tracking_sessions_ios.next_session_start_at
          OR tracking_sessions_ios.next_session_start_at IS NULL)
      WHERE
        tracking_ios.event='purchase_confirmed'
      GROUP BY
        1,
        2 ),

        order_placed_ios AS (
        SELECT
          tracking_sessions_ios.anonymous_id,
          tracking_sessions_ios.session_id,
          COUNT(*) AS event_count
        FROM
          `flink-backend.flink_ios_production.tracks_view` tracking_ios
        LEFT JOIN
          tracking_sessions_ios
        ON
          tracking_ios.anonymous_id = tracking_sessions_ios.anonymous_id
          AND tracking_ios.timestamp >= tracking_sessions_ios.session_start_at
          AND (tracking_ios.timestamp < tracking_sessions_ios.next_session_start_at
            OR tracking_sessions_ios.next_session_start_at IS NULL)
        WHERE
          tracking_ios.event='order_placed'
        GROUP BY
          1,
          2 ),

        tracking_sessions_android AS (
        SELECT
          anonymous_id || '-' || ROW_NUMBER() OVER(PARTITION BY anonymous_id ORDER BY timestamp) AS session_id,
          *,
          timestamp AS session_start_at,
          LEAD(timestamp) OVER(PARTITION BY anonymous_id ORDER BY timestamp) AS next_session_start_at,
        FROM (
          SELECT
            *,
            TIMESTAMP_DIFF(timestamp,LAG(timestamp) OVER(PARTITION BY anonymous_id ORDER BY timestamp), MINUTE) AS inactivity_time
          FROM
            `flink-backend.flink_android_production.tracks_view` ) event_android
        WHERE
          (event_android.inactivity_time > 30
            OR event_android.inactivity_time IS NULL)
        ORDER BY
          1),
        add_to_cart_android AS (
        SELECT
          tracking_sessions_android.anonymous_id,
          tracking_sessions_android.session_id,
          COUNT(*) AS event_count
        FROM
          `flink-backend.flink_android_production.tracks_view` tracking_android
        LEFT JOIN
          tracking_sessions_android
        ON
          tracking_android.anonymous_id = tracking_sessions_android.anonymous_id
          AND tracking_android.timestamp >= tracking_sessions_android.session_start_at
          AND (tracking_android.timestamp < tracking_sessions_android.next_session_start_at
            OR tracking_sessions_android.next_session_start_at IS NULL)
        WHERE
          tracking_android.event='product_added_to_cart'
        GROUP BY
          1,
          2 ),

        location_pin_placed_android AS (
        SELECT
          tracking_sessions_android.anonymous_id,
          tracking_sessions_android.session_id,
          COUNT(*) AS event_count
        FROM
          `flink-backend.flink_android_production.tracks_view` tracking_android
        LEFT JOIN
          tracking_sessions_android
        ON
          tracking_android.anonymous_id = tracking_sessions_android.anonymous_id
          AND tracking_android.timestamp >= tracking_sessions_android.session_start_at
          AND (tracking_android.timestamp < tracking_sessions_android.next_session_start_at
            OR tracking_sessions_android.next_session_start_at IS NULL)
        WHERE
          tracking_android.event='location_pin_placed'
        GROUP BY
          1,
          2 ),

        home_viewed_android AS (
        SELECT
          tracking_sessions_android.anonymous_id,
          tracking_sessions_android.session_id,
          COUNT(*) AS event_count
        FROM
          `flink-backend.flink_android_production.tracks_view` tracking_android
        LEFT JOIN
          tracking_sessions_android
        ON
          tracking_android.anonymous_id = tracking_sessions_android.anonymous_id
          AND tracking_android.timestamp >= tracking_sessions_android.session_start_at
          AND (tracking_android.timestamp < tracking_sessions_android.next_session_start_at
            OR tracking_sessions_android.next_session_start_at IS NULL)
        WHERE
          tracking_android.event='home_viewed'
        GROUP BY
          1,
          2 ),

        view_item_android AS (
        SELECT
          tracking_sessions_android.anonymous_id,
          tracking_sessions_android.session_id,
          COUNT(*) AS event_count
        FROM
          `flink-backend.flink_android_production.tracks_view` tracking_android
        LEFT JOIN
          tracking_sessions_android
        ON
          tracking_android.anonymous_id = tracking_sessions_android.anonymous_id
          AND tracking_android.timestamp >= tracking_sessions_android.session_start_at
          AND (tracking_android.timestamp < tracking_sessions_android.next_session_start_at
            OR tracking_sessions_android.next_session_start_at IS NULL)
        WHERE
          tracking_android.event='product_details_viewed'
        GROUP BY
          1,
          2 ),

         view_cart_android AS (
        SELECT
          tracking_sessions_android.anonymous_id,
          tracking_sessions_android.session_id,
          COUNT(*) AS event_count
        FROM
          `flink-backend.flink_android_production.tracks_view` tracking_android
        LEFT JOIN
          tracking_sessions_android
        ON
          tracking_android.anonymous_id = tracking_sessions_android.anonymous_id
          AND tracking_android.timestamp >= tracking_sessions_android.session_start_at
          AND (tracking_android.timestamp < tracking_sessions_android.next_session_start_at
            OR tracking_sessions_android.next_session_start_at IS NULL)
        WHERE
          tracking_android.event='cart_viewed'
        GROUP BY
          1,
          2 ),

          address_confirmed_android AS (
      SELECT
        tracking_sessions_android.anonymous_id,
        tracking_sessions_android.session_id,
        COUNT(*) AS event_count
      FROM
        `flink-backend.flink_android_production.tracks_view` tracking_android
      LEFT JOIN
        tracking_sessions_android
      ON
        tracking_android.anonymous_id = tracking_sessions_android.anonymous_id
        AND tracking_android.timestamp >= tracking_sessions_android.session_start_at
        AND (tracking_android.timestamp < tracking_sessions_android.next_session_start_at
          OR tracking_sessions_android.next_session_start_at IS NULL)
      WHERE
        tracking_android.event='address_confirmed'
      GROUP BY
        1,
        2 ),

      checkout_started_android AS (
      SELECT
        tracking_sessions_android.anonymous_id,
        tracking_sessions_android.session_id,
        COUNT(*) AS event_count
      FROM
        `flink-backend.flink_android_production.tracks_view` tracking_android
      LEFT JOIN
        tracking_sessions_android
      ON
        tracking_android.anonymous_id = tracking_sessions_android.anonymous_id
        AND tracking_android.timestamp >= tracking_sessions_android.session_start_at
        AND (tracking_android.timestamp < tracking_sessions_android.next_session_start_at
          OR tracking_sessions_android.next_session_start_at IS NULL)
      WHERE
        tracking_android.event='checkout_started'
      GROUP BY
        1,
        2 ),

      payment_started_android AS (
      SELECT
        tracking_sessions_android.anonymous_id,
        tracking_sessions_android.session_id,
        COUNT(*) AS event_count
      FROM
        `flink-backend.flink_android_production.tracks_view` tracking_android
      LEFT JOIN
        tracking_sessions_android
      ON
        tracking_android.anonymous_id = tracking_sessions_android.anonymous_id
        AND tracking_android.timestamp >= tracking_sessions_android.session_start_at
        AND (tracking_android.timestamp < tracking_sessions_android.next_session_start_at
          OR tracking_sessions_android.next_session_start_at IS NULL)
      WHERE
        tracking_android.event='purchase_confirmed'
      GROUP BY
        1,
        2 ),

        order_placed_android AS (
        SELECT
          tracking_sessions_android.anonymous_id,
          tracking_sessions_android.session_id,
          COUNT(*) AS event_count
        FROM
          `flink-backend.flink_android_production.tracks_view` tracking_android
        LEFT JOIN
          tracking_sessions_android
        ON
          tracking_android.anonymous_id = tracking_sessions_android.anonymous_id
          AND tracking_android.timestamp >= tracking_sessions_android.session_start_at
          AND (tracking_android.timestamp < tracking_sessions_android.next_session_start_at
            OR tracking_sessions_android.next_session_start_at IS NULL)
        WHERE
          tracking_android.event='order_placed'
        GROUP BY
          1,
          2 )

      SELECT
        tracking_sessions_ios.anonymous_id,
        tracking_sessions_ios.session_id,
        datetime(tracking_sessions_ios.session_start_at,
          'Europe/Berlin') AS session_start_at,
        datetime(tracking_sessions_ios.next_session_start_at,
          'Europe/Berlin') AS next_session_start_at,
        tracking_sessions_ios.context_locale,
        tracking_sessions_ios.context_device_type,
        tracking_sessions_ios.context_app_version,
        1 AS session,
        add_to_cart_ios.event_count AS add_to_cart,
        location_pin_placed_ios.event_count AS location_pin_placed,
        home_viewed_ios.event_count AS home_viewed,
        view_item_ios.event_count AS view_item,
        view_cart_ios.event_count AS view_cart,
        address_confirmed_ios.event_count AS address_confirmed,
        checkout_started_ios.event_count AS checkout_started,
        payment_started_ios.event_count AS payment_started,
        order_placed_ios.event_count AS order_placed
      FROM
        tracking_sessions_ios
      LEFT JOIN
        add_to_cart_ios
      ON
        tracking_sessions_ios.session_id=add_to_cart_ios.session_id
      LEFT JOIN
        location_pin_placed_ios
      ON
        tracking_sessions_ios.session_id=location_pin_placed_ios.session_id
      LEFT JOIN
        home_viewed_ios
      ON
        tracking_sessions_ios.session_id=home_viewed_ios.session_id
      LEFT JOIN
        view_item_ios
      ON
        tracking_sessions_ios.session_id=view_item_ios.session_id
      LEFT JOIN
        view_cart_ios
      ON
        tracking_sessions_ios.session_id=view_cart_ios.session_id
      LEFT JOIN
        address_confirmed_ios
      ON
        tracking_sessions_ios.session_id=address_confirmed_ios.session_id
      LEFT JOIN
        checkout_started_ios
      ON
        tracking_sessions_ios.session_id=checkout_started_ios.session_id
      LEFT JOIN
        payment_started_ios
      ON
        tracking_sessions_ios.session_id=payment_started_ios.session_id
      LEFT JOIN
        order_placed_ios
      ON
        tracking_sessions_ios.session_id=order_placed_ios.session_id
      UNION ALL
      SELECT
        tracking_sessions_android.anonymous_id,
        tracking_sessions_android.session_id,
        datetime(tracking_sessions_android.session_start_at,
          'Europe/Berlin') AS session_start_at,
        datetime(tracking_sessions_android.next_session_start_at,
          'Europe/Berlin') AS next_session_start_at,
        tracking_sessions_android.context_locale,
        tracking_sessions_android.context_device_type,
        tracking_sessions_android.context_app_version,
        1 AS session,
        add_to_cart_android.event_count AS add_to_cart,
        location_pin_placed_android.event_count AS location_pin_placed,
        home_viewed_android.event_count AS home_viewed,
        view_item_android.event_count AS view_item,
        view_cart_android.event_count AS view_cart,
        address_confirmed_android.event_count AS address_confirmed,
        checkout_started_android.event_count AS checkout_started,
        payment_started_android.event_count AS payment_started,
        order_placed_android.event_count AS order_placed
      FROM
        tracking_sessions_android
      LEFT JOIN
        add_to_cart_android
      ON
        tracking_sessions_android.session_id=add_to_cart_android.session_id
      LEFT JOIN
        location_pin_placed_android
      ON
        tracking_sessions_android.session_id=location_pin_placed_android.session_id
      LEFT JOIN
        home_viewed_android
      ON
        tracking_sessions_android.session_id=home_viewed_android.session_id
      LEFT JOIN
        view_item_android
      ON
        tracking_sessions_android.session_id=view_item_android.session_id
      LEFT JOIN
        view_cart_android
      ON
        tracking_sessions_android.session_id=view_cart_android.session_id
      LEFT JOIN
        address_confirmed_android
      ON
        tracking_sessions_android.session_id=address_confirmed_android.session_id
      LEFT JOIN
        checkout_started_android
      ON
        tracking_sessions_android.session_id=checkout_started_android.session_id
      LEFT JOIN
        payment_started_android
      ON
        tracking_sessions_android.session_id=payment_started_android.session_id
      LEFT JOIN
        order_placed_android
      ON
        tracking_sessions_android.session_id=order_placed_android.session_id
      ORDER BY
        1
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: full_app_version {
    type: string
    sql: ${context_device_type} || '-' || ${context_app_version} ;;
  }

  dimension: anonymous_id {
    type: string
    sql: ${TABLE}.anonymous_id ;;
  }

  dimension: session_id {
    type: string
    primary_key: yes
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

  dimension: view_item {
    type: number
    sql: ${TABLE}.view_item ;;
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

##### Unique count of events during a session. If multiple events are triggerred during a session, e.g 3 times view item, the event is only counted once.

  measure: cnt_address_selected {
    label: "Address selected count"
    type: count
    filters: [address_confirmed: "NOT NULL"]
  }

  measure: cnt_location_pin_placed {
    label: "Location pin placed count"
    type: count
    filters: [location_pin_placed: "NOT NULL"]
  }

  measure: cnt_home_viewed {
    label: "Home view count"
    type: count
    filters: [home_viewed: "NOT NULL"]
  }

  measure: cnt_view_item {
    label: "View item count"
    type: count
    filters: [view_item: "NOT NULL"]
  }

  measure: cnt_add_to_cart {
    label: "Add to cart count"
    type: count
    filters: [add_to_cart: "NOT NULL"]
  }

  measure: cnt_view_cart {
    label: "View cart count"
    type: count
    filters: [view_cart: "NOT NULL"]
  }

  measure: cnt_checkout_started {
    label: "Checkout started count"
    type: count
    filters: [checkout_started: "NOT NULL"]
  }

  measure: cnt_payment_started {
    label: "Payment started count"
    type: count
    filters: [payment_started: "NOT NULL"]
  }

  measure: cnt_purchase {
    label: "Order placed count"
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

  measure: sum_view_item {
    label: "View item sum of events"
    type: sum
    sql: ${view_item} ;;
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
    value_format_name: percent_2
    sql: ${cnt_purchase}/${count} ;;
  }

  measure: mcvr1 {
    type: number
    value_format_name: percent_2
    sql: ${cnt_address_selected}/${count} ;;
  }

  measure: mcvr2 {
    type: number
    value_format_name: percent_2
    sql: ${cnt_add_to_cart}/${count} ;;
  }

  measure: mcvr3 {
    type: number
    value_format_name: percent_2
    sql: ${cnt_checkout_started}/${count} ;;
  }

  measure: mcvr4 {
    type: number
    value_format_name: percent_2
    sql: ${cnt_payment_started}/${count} ;;
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
      add_to_cart,
      location_pin_placed,
      home_viewed,
      view_item,
      view_cart,
      address_confirmed,
      checkout_started,
      payment_started,
      order_placed
    ]
  }
}
