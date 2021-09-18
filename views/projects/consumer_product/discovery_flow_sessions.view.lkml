view: discovery_flow_sessions {
  derived_table: {
    persist_for: "1 hour"
    sql: WITH
        -- join events android and ios as base for calculating sessions
        pre_events_tb AS (
        SELECT
            tracks.anonymous_id
            , tracks.context_app_version
            , tracks.context_device_type
            , tracks.context_locale
            , tracks.event
            , tracks.event_text
            , tracks.id AS event_id
            , tracks.timestamp
            , TIMESTAMP_DIFF(tracks.timestamp,LAG(tracks.timestamp) OVER(PARTITION BY tracks.anonymous_id ORDER BY tracks.timestamp), MINUTE) AS inactivity_time
        FROM
            `flink-data-prod.flink_ios_production.tracks_view` tracks
        WHERE
            tracks.event NOT LIKE "%api%"
            AND tracks.event NOT LIKE "%adjust%"
            AND tracks.event NOT LIKE "%install_attributed%"
            AND tracks.event != "app_opened"
            AND tracks.event NOT LIKE "%application%"
            AND NOT (LOWER(tracks.context_app_version) LIKE "%app-rating%" OR LOWER(tracks.context_app_version) LIKE "%debug%")
            AND NOT (tracks.context_app_name = "Flink-Staging" OR tracks.context_app_name="Flink-Debug")
        UNION ALL
        SELECT
            tracks.anonymous_id
            , tracks.context_app_version
            , tracks.context_device_type
            , tracks.context_locale
            , tracks.event
            , tracks.event_text
            , tracks.id AS event_id
            , tracks.timestamp
            , TIMESTAMP_DIFF(tracks.timestamp,LAG(tracks.timestamp) OVER(PARTITION BY tracks.anonymous_id ORDER BY tracks.timestamp), MINUTE) AS inactivity_time
        FROM
            `flink-data-prod.flink_android_production.tracks_view` tracks
        WHERE
            tracks.event NOT LIKE "%api%"
            AND tracks.event NOT LIKE "%adjust%"
            AND tracks.event NOT LIKE "%install_attributed%"
            AND tracks.event != "app_opened"
            AND tracks.event NOT LIKE "%application%"
            AND NOT (LOWER(tracks.context_app_version) LIKE "%app-rating%" OR LOWER(tracks.context_app_version) LIKE "%debug%")
            AND NOT (tracks.context_app_name = "Flink-Staging" OR tracks.context_app_name="Flink-Debug")
            )

      , search_data AS (
    SELECT
        anonymous_id
        , id
        , INITCAP(TRIM(search_query)) AS search_query_clean
        , LEAD(search_query) OVER(PARTITION BY anonymous_id ORDER BY timestamp ASC) NOT LIKE CONCAT('%', search_query,'%') AS is_not_subquery
        , timestamp
    FROM
        `flink-data-prod.flink_android_production.product_search_executed_view`
    UNION ALL
    SELECT
        anonymous_id
        , id
        , INITCAP(TRIM(search_query)) AS search_query_clean
        , LEAD(search_query) OVER(PARTITION BY anonymous_id ORDER BY timestamp ASC) NOT LIKE CONCAT('%', search_query,'%') AS is_not_subquery
        , timestamp
    FROM
        `flink-data-prod.flink_ios_production.product_search_executed_view` )

    , -- exclude repeat searches from tracks
        exclude_from_tracks AS (
        SELECT id
        FROM search_data
        WHERE NOT(is_not_subquery) OR search_query_clean="" OR search_query_clean IS NULL
      )

    , events_tb AS (
        SELECT pre_events_tb.*
        FROM pre_events_tb
        LEFT JOIN exclude_from_tracks
        ON pre_events_tb.event_id=exclude_from_tracks.id
        WHERE exclude_from_tracks.id IS NULL
      )

        -- defining 30 min sessions
        , tracking_sessions_tb AS (
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
            events_tb
        WHERE
            (events_tb.inactivity_time > 30
            OR events_tb.inactivity_time IS NULL)
        ORDER BY
            1),

        session_event_counts_tb AS (
        SELECT
            s.session_id
            , s.next_session_start_at
            , s.session_start_at
            , s.anonymous_id
            , s.session_number
            , SUM(CASE WHEN e.event="product_added_to_cart" THEN 1 ELSE 0 END) as product_added_to_cart_count
            , SUM(CASE WHEN e.event="home_viewed" THEN 1 ELSE 0 END) as home_viewed_count
        FROM events_tb e
            LEFT JOIN tracking_sessions_tb  s
            ON e.anonymous_id = s.anonymous_id
            AND e.timestamp >= s.session_start_at
            AND ( e.timestamp < s.next_session_start_at OR s.next_session_start_at IS NULL)
        GROUP BY 1,2,3,4,5
        ),

        -- labeling events with session_id and prepare fields we need later
        session_events_tb AS (
        SELECT u.event_id,
         s.session_id,
           s.session_number,
           u.anonymous_id,
           u.timestamp AS event_timestamp,
           u.event AS event_name,
           u.context_app_version AS app_version,
           u.context_device_type AS device_type,
           u.context_locale AS locale,
           u.inactivity_time,
           s.session_start_at,
           s.next_session_start_at,
           LAST_VALUE(u.timestamp)
                 OVER(PARTITION BY s.session_id ORDER BY u.timestamp ASC
                   ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)          AS session_end,
            LAG(u.event) OVER(PARTITION BY u.anonymous_id ORDER BY u.timestamp ASC) AS prev_event,
            --TIME_DIFF(TIME(LAG(u.timestamp) OVER(PARTITION BY u.anonymous_id ORDER BY u.timestamp ASC)), TIME(u.timestamp), MILLISECOND) < 1500 AS quick_succession
        FROM events_tb u
        LEFT JOIN session_event_counts_tb s
            ON (u.timestamp < s.next_session_start_at OR s.next_session_start_at is NULL )
            AND u.timestamp >= s.session_start_at
            AND u.anonymous_id = s.anonymous_id
        -- cart_opened and cart_viewed always trigger together so don't need both. Same for checkout_viewed and checkout_started. marketing_banner_viewed not interesting for flow
        -- everything after cart_viewed not interesting because not accessible from the path of home to add product to cart.
        -- categories_main_viewed always follows category_selected, so also not informative (we already know it comes from category)
        WHERE u.event NOT IN ("marketing_banner_viewed", "article_opened", "cart_opened", "home_view_updated", "checkout_viewed"
                                , "order_placed", "payment_method_added", "order_details_viewed"
                                , "deep_link_opened", "first_order_placed","order_tracking_viewed", "address_tooltip_viewed", "categories_show_more_selected"
                                , "categories_main_viewed", "address_search_viewed")
              AND LOWER(u.event) NOT LIKE "%scroll%"
              AND LOWER(u.event) NOT LIKE "%voucher%"
              AND LOWER(u.event) NOT LIKE "%failed%"
              AND LOWER(u.event) NOT LIKE "%app_rating%"
              AND LOWER(u.event) NOT LIKE "%message%"
        AND s.product_added_to_cart_count!=0
        ),

      session_events_filtered AS (
      SELECT *
      , IF(event_name = "home_viewed" OR prev_event="product_added_to_cart" OR LAG(event_id) OVER(PARTITION BY session_id ORDER BY event_timestamp ASC) IS NULL, TRUE, FALSE) AS flow_breakpoint
      , SUM(CASE WHEN event_name="product_added_to_cart" THEN 1 ELSE 0 END) OVER (PARTITION BY session_id ORDER BY event_timestamp) AS addtocart_count
      , IF(event_name="product_added_to_cart", TRUE, FALSE) AS conversion
      FROM session_events_tb se
      --filter out searches that follow impossible events (at <1.5sec) because of the mistriggers in ios. Only added home_viewed because if excluded it resuces search a lot even on android. Probably segment event order not being 100% reliable
      WHERE NOT(event_name="product_search_executed" AND NOT(prev_event IN ("product_added_to_cart","product_details_viewed","product_added_to_favourites", "product_search_viewed")))
      -- filter out product_search_viewed since it is often linked with search_executed
      AND event_name!="product_search_viewed"
    ),

      session_add_block AS (
      SELECT *
      , session_id || '-' || SUM(CASE WHEN NOT(flow_breakpoint) THEN 0 ELSE 1 END) OVER (PARTITION BY session_id ORDER BY event_timestamp) AS flow_id
      -- , IF(LEAD(flow_breakpoint) OVER (PARTITION BY session_id ORDER BY event_timestamp), TRUE, FALSE) AS last_step
      , IF(addtocart_count=0, TRUE, FALSE) AS first_product
      FROM session_events_filtered
      -- filter out repeating events which will make sequences longer and not provide that much more information about the pattern
      WHERE event_name != prev_event
      ),

      session_add_counter AS (
      SELECT * EXCEPT(prev_event)
      , ROW_NUMBER() OVER(PARTITION BY flow_id ORDER BY event_timestamp ASC) AS flow_step
      FROM session_add_block
      ),

      session_tag_flows AS (
      SELECT *
      , FIRST_VALUE(conversion) OVER (PARTITION BY flow_id ORDER BY flow_step DESC) AS successful_flow
      , FIRST_VALUE(flow_step) OVER (PARTITION BY flow_id ORDER BY flow_step DESC) AS max_steps_current_flow
      FROM session_add_counter
      )

      -- SELECT *
      -- FROM session_tag_flows
      -- ORDER BY session_id, event_timestamp

      SELECT flow_id
      , MAX(session_start_at) AS session_start
      , MAX(session_end) AS session_end
      , MAX(anonymous_id) AS anonymous_id
      , MAX(session_id) AS session_id
      , MAX(app_version) AS app_version
      , MAX(device_type ) AS device_type
      , MAX(locale) AS locale
      , MAX(first_product) AS first_product_of_session
      , MAX(successful_flow) AS successful_flow
      , MAX(max_steps_current_flow) AS max_steps_current_flow
      , COALESCE(MAX(IF(flow_step = 1, event_name, NULL)), "end_of_flow") AS step1
      , COALESCE(MAX(IF(flow_step = 2, event_name, NULL)), "end_of_flow") AS step2
      , COALESCE(MAX(IF(flow_step = 3, event_name, NULL)), "end_of_flow") AS step3
      , COALESCE(MAX(IF(flow_step = 4, event_name, NULL)), "end_of_flow") AS step4
      , COALESCE(MAX(IF(flow_step = 5, event_name, NULL)), "end_of_flow") AS step5
      , COALESCE(MAX(IF(flow_step = 6, event_name, NULL)), "end_of_flow") AS step6
      , COALESCE(MAX(IF(flow_step = 7, event_name, NULL)), "end_of_flow") AS step7
      , COALESCE(MAX(IF(flow_step = 8, event_name, NULL)), "end_of_flow") AS step8
      FROM session_tag_flows
      GROUP BY 1

      -- SELECT flow_step
      -- , SUM(CASE WHEN addtocart_count=0 THEN 1 ELSE 0 END) AS first_product_counter
      -- , SUM(CASE WHEN addtocart_count!=0 THEN 1 ELSE 0 END) AS nonfirst_product_counter
      -- , COUNT(*)
      -- FROM session_add_counter
      --     GROUP BY 1
      --     ORDER BY 1
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: flow_id {
    type: string
    sql: ${TABLE}.flow_id ;;
  }

  dimension_group: session_start {
    type: time
    sql: ${TABLE}.session_start ;;
  }

  dimension_group: session_end {
    type: time
    sql: ${TABLE}.session_end ;;
  }

  dimension: anonymous_id {
    type: string
    sql: ${TABLE}.anonymous_id ;;
  }

  dimension: session_id {
    type: string
    sql: ${TABLE}.session_id ;;
  }

  dimension: app_version {
    type: string
    sql: ${TABLE}.app_version ;;
  }

  dimension: device_type {
    type: string
    sql: ${TABLE}.device_type ;;
  }

  dimension: locale {
    type: string
    sql: ${TABLE}.locale ;;
  }

  dimension: first_product_of_session {
    type: yesno
    description: "The user hasn't added a product to cart in the current session before the current flow "
    sql: ${TABLE}.first_product_of_session ;;
  }

  dimension: successful_flow {
    type: yesno
    description: "The current flow ends in a product added to cart"
    sql: ${TABLE}.successful_flow ;;
  }

  dimension: max_steps_current_flow {
    type: number
    sql: ${TABLE}.max_steps_current_flow ;;
  }

  dimension: step1 {
    type: string
    sql: ${TABLE}.step1 ;;
  }

  dimension: step2 {
    type: string
    sql: ${TABLE}.step2 ;;
  }

  dimension: step3 {
    type: string
    sql: ${TABLE}.step3 ;;
  }

  dimension: step4 {
    type: string
    sql: ${TABLE}.step4 ;;
  }

  dimension: step5 {
    type: string
    sql: ${TABLE}.step5 ;;
  }

  dimension: step6 {
    type: string
    sql: ${TABLE}.step6 ;;
  }

  dimension: step7 {
    type: string
    sql: ${TABLE}.step7 ;;
  }

  dimension: step8 {
    type: string
    sql: ${TABLE}.step8 ;;
  }

  set: detail {
    fields: [
      flow_id,
      session_start_time,
      session_end_time,
      anonymous_id,
      session_id,
      app_version,
      device_type,
      locale,
      first_product_of_session,
      successful_flow,
      max_steps_current_flow,
      step1,
      step2,
      step3,
      step4,
      step5,
      step6,
      step7,
      step8
    ]
  }
}
