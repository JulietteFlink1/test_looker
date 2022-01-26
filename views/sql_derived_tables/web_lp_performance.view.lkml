view: web_lp_performance {
  derived_table: {
    sql:
WITH lp_sessions AS (
  SELECT
        session_date
      , session_uuid
      , page_path
      ,
      -- , anonymous_id
      -- , hit_uuid
      -- , timestamp
  FROM `flink-data-dev.sandbox_natalia.web_hits`
  where page_path like '%test-city%'
  group by session_date, session_uuid, page_path
  order by session_uuid
  )

  , click_sessions AS (
  SELECT
        lp_sessions.session_date
      , lp_sessions.session_uuid
      , lp_sessions.page_path
      , web_hits.hit_uuid
      , web_hits.timestamp
  FROM lp_sessions
    left join `flink-data-dev.sandbox_natalia.web_hits` as web_hits
      on lp_sessions.session_uuid = web_hits.session_uuid
  where web_hits.event_name = 'lp_map_clicked'
  group by session_date, session_uuid, page_path, hit_uuid, timestamp
  order by session_uuid
  )

  select
      click_sessions.session_date
    , click_sessions.session_uuid
    -- , click_sessions.page_path
    , web_sessions.device_category
    , web_sessions.session_duration_minutes
    , web_sessions.is_shop_session
    , web_sessions.is_session_with_added_to_cart
    , web_sessions.is_session_with_checkout_started
    , web_sessions.is_session_with_payment_started
    , web_sessions.is_session_with_order_placed
    , count(distinct click_sessions.hit_uuid) as clicks_count
  from click_sessions
  left join `flink-data-prod.curated.web_sessions_full_load` web_sessions
  on click_sessions.session_uuid = web_sessions.session_uuid
  where web_sessions.session_uuid is not null
  group by session_date
                    , session_uuid
                    -- , page_path
                    , device_category
                    , session_duration_minutes
                    , is_shop_session
                    , is_session_with_added_to_cart
                    , is_session_with_checkout_started
                    , is_session_with_payment_started
                    , is_session_with_order_placed
 ;;
  }

  dimension_group: session_date {
    type: time
    timeframes: [
      date,
      week,
      month,
      year
    ]
    sql: CAST(${TABLE}.session_date AS DATE) ;;
    datatype: date
  }

  dimension: device_category {
    type: string
    sql: ${TABLE}.device_category ;;
  }

  dimension: is_shop_session {
    type: yesno
    sql: ${TABLE}.is_shop_session ;;
  }

  dimension: is_session_with_added_to_cart {
    type: yesno
    sql: ${TABLE}.is_session_with_added_to_cart ;;
  }

  dimension: is_session_with_checkout_started {
    type: yesno
    sql: ${TABLE}.is_session_with_checkout_started ;;
  }

  dimension: is_session_with_payment_started {
    type: yesno
    sql: ${TABLE}.is_session_with_payment_started ;;
  }

  dimension: is_session_with_order_placed {
    type: yesno
    sql: ${TABLE}.is_session_with_order_placed ;;
  }

  dimension: clicks_count {
    type: number
    sql: ${TABLE}.clicks_count ;;
  }

  measure: sum_of_clicks_count {
    type: sum
    sql: ${TABLE}.clicks_count ;;
  }

  measure: count_sessions {
    type: count_distinct
    sql: ${TABLE}.session_uuid ;;
  }

  measure: count_sessions_is_shop {
    type: count_distinct
    sql: ${TABLE}.session_uuid ;;
    filters: [is_shop_session: "yes"]
  }

  measure: count_sessions_with_added_to_cart {
    type: count_distinct
    sql: ${TABLE}.session_uuid ;;
    filters: [is_session_with_added_to_cart: "yes"]
  }

  measure: count_sessions_with_checkout_started {
    type: count_distinct
    sql: ${TABLE}.session_uuid ;;
    filters: [is_session_with_checkout_started: "yes"]
  }

  measure: count_sessions_with_payment_started {
    type: count_distinct
    sql: ${TABLE}.session_uuid ;;
    filters: [is_session_with_payment_started: "yes"]
  }

  measure: count_sessions_with_order_placed {
    type: count_distinct
    sql: ${TABLE}.session_uuid ;;
    filters: [is_session_with_order_placed: "yes"]
  }


  #######
}
