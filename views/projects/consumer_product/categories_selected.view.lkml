view: categories_selected {
  derived_table: {
    persist_for: "8 hour"
    sql: WITH
        events AS ( -- ios all events
        SELECT
            tracks.anonymous_id
          , tracks.context_app_version
          , tracks.context_device_type
          , tracks.event
          , tracks.event_text
          , tracks.id
          , tracks.timestamp
          , TIMESTAMP_DIFF(tracks.timestamp,LAG(tracks.timestamp) OVER(PARTITION BY tracks.anonymous_id ORDER BY tracks.timestamp), MINUTE) AS inactivity_time
        FROM
          `flink-data-prod.flink_ios_production.tracks` tracks
        WHERE DATE(tracks._partitiontime) > "2021-08-01"
          AND tracks.event NOT LIKE "%api%"
          AND tracks.event NOT LIKE "%adjust%"
          AND tracks.event NOT LIKE "%install_attributed%"
          AND tracks.event != "app_opened"
          AND tracks.event != "application_updated"
          AND tracks.event != "application_opened"
          AND NOT (LOWER(tracks.context_app_version) LIKE "%app-rating%"
           OR LOWER(tracks.context_app_version) LIKE "%debug%")
          AND NOT (LOWER(tracks.context_app_name) = "flink-staging"
           OR LOWER(tracks.context_app_name) = "flink-debug")
          AND (LOWER(tracks.context_traits_email) != "qa@goflink.com"
           OR tracks.context_traits_email is null)
          AND (tracks.context_traits_hub_slug NOT IN('erp_spitzbergen', 'fr_hub_test', 'nl_hub_test')
           OR tracks.context_traits_hub_slug is null)
    UNION ALL
        SELECT -- android all events
            tracks.anonymous_id
          , tracks.context_app_version
          , tracks.context_device_type
          , tracks.event
          , tracks.event_text
          , tracks.id
          , tracks.timestamp
          , TIMESTAMP_DIFF(tracks.timestamp,LAG(tracks.timestamp) OVER(PARTITION BY tracks.anonymous_id ORDER BY tracks.timestamp), MINUTE) AS inactivity_time
        FROM
          `flink-data-prod.flink_android_production.tracks` tracks
        WHERE DATE(tracks._partitiontime) > "2021-08-01"
          AND tracks.event NOT LIKE "%api%"
          AND tracks.event NOT LIKE "%adjust%"
          AND tracks.event NOT LIKE "%install_attributed%"
          AND tracks.event != "app_opened"
          AND tracks.event != "application_updated"
          AND tracks.event != "application_opened"
          AND NOT (LOWER(tracks.context_app_version) LIKE "%app-rating%"
           OR LOWER(tracks.context_app_version) LIKE "%debug%")
          AND NOT (LOWER(tracks.context_app_name) = "flink-staging"
           OR LOWER(tracks.context_app_name) = "flink-debug")
          AND (LOWER(tracks.context_traits_email) != "qa@goflink.com"
           OR tracks.context_traits_email is null)
          AND (tracks.context_traits_hub_slug NOT IN('erp_spitzbergen', 'fr_hub_test', 'nl_hub_test')
           OR tracks.context_traits_hub_slug is null)
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
            FROM
              events
            WHERE
              (events.inactivity_time > 30
                OR events.inactivity_time IS NULL)
            ORDER BY
              1)

    , add_to_cart AS (
        SELECT
               sf.anonymous_id
             , sf.session_id
             , count(e.timestamp) as event_count
        FROM events e
            LEFT JOIN tracking_sessions sf
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
            LEFT JOIN tracking_sessions sf
            ON e.anonymous_id = sf.anonymous_id
            AND e.timestamp >= sf.session_start_at
            AND ( e.timestamp < sf.next_session_start_at OR next_session_start_at IS NULL)
        WHERE e.event = 'home_viewed'
        GROUP BY 1,2
    )

    , categories AS (
        SELECT
               sf.anonymous_id
             , sf.session_id
             , count(e.timestamp) as event_count
        FROM events e
            LEFT JOIN tracking_sessions sf
            ON e.anonymous_id = sf.anonymous_id
            AND e.timestamp >= sf.session_start_at
            AND ( e.timestamp < sf.next_session_start_at OR next_session_start_at IS NULL)
        WHERE e.event = 'categories_show_more_selected'
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
            LEFT JOIN tracking_sessions sf
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
        , sf.session_id
        , sf.session_number
        , datetime(sf.session_start_at,
          'UTC') AS session_start_at
        , datetime(sf.next_session_start_at,
          'UTC') AS next_session_start_at
        , atc.event_count as add_to_cart
        , op.event_count as order_placed
        , ca.event_count as more_categories
        , hv.event_count as home_viewed
        , CASE WHEN fo.first_order_timestamp < sf.session_start_at THEN true ELSE false END as has_ordered
    FROM tracking_sessions sf
        LEFT JOIN add_to_cart atc
        ON sf.session_id = atc.session_id
        LEFT JOIN home_viewed hv
        ON sf.session_id = hv.session_id
        LEFT JOIN order_placed op
        ON sf.session_id = op.session_id
        LEFT JOIN first_order fo
        ON sf.anonymous_id = fo.anonymous_id
        LEFT JOIN categories ca
        ON sf.anonymous_id = ca.anonymous_id
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

  # dimension_group: next_session_start_at {
  #   type: time
  #   datatype: datetime
  #   timeframes: [
  #     date,
  #     day_of_week,
  #     week,
  #     month,
  #     quarter,
  #     year
  #   ]
  #   sql: ${TABLE}.next_session_start_at ;;
  # }


  dimension: has_ordered {
    type: yesno
    sql: ${TABLE}.has_ordered ;;
  }

### Custom dimensions
  dimension: returning_customer {
    type: yesno
    sql: ${has_ordered} ;;
  }

  dimension: is_first_session {
    type: yesno
    sql: ${TABLE}.session_number=1 ;;
  }

##### Unique count of events during a session. If multiple events are triggerred during a session, e.g 3 times view item, the event is only counted once.

  measure: cnt_home_viewed {
    label: "Home view count"
    description: "Number of sessions in which at least one Home Viewed event happened"
    type: count
    filters: [home_viewed: "NOT NULL"]
  }

  measure: cnt_more_categories {
    label: "More Categories count"
    description: "Number of sessions in which at least one More Categories event happened"
    type: count
    filters: [more_categories: "NOT NULL"]
  }

  measure: cnt_add_to_cart {
    label: "Add to cart count"
    description: "Number of sessions in which at least one Product Added To Cart event happened"
    type: count
    filters: [add_to_cart: "NOT NULL"]
  }

  measure: cnt_purchase {
    label: "Order placed count"
    description: "Number of sessions in which at least one Order Placed event happened"
    type: count
    filters: [order_placed: "NOT NULL"]
  }

  ###### Sum of events
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

  measure: sum_purchases {
    label: "Order placed sum of events"
    type: sum
    sql: ${order_placed} ;;
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

  dimension: session_id {
    type: string
    sql: ${TABLE}.session_id ;;
  }

  dimension: session_number {
    type: number
    sql: ${TABLE}.session_number ;;
  }

  dimension: add_to_cart {
    type: number
    sql: ${TABLE}.add_to_cart ;;
  }

  dimension: home_viewed {
    type: number
    sql: ${TABLE}.home_viewed ;;
  }

  dimension: more_categories {
    type:  number
    sql:  ${TABLE}.more_categories ;;
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
      session_id,
      session_number,
      session_start_at_date,
      add_to_cart,
      home_viewed,
      more_categories,
      order_placed,
      has_ordered
    ]
  }
}
