view: user_accounts_analysis {
  derived_table: {
    sql:
WITH sessions AS (
SELECT DISTINCT
      session_uuid
    , s.anonymous_id
    , is_new_user
    , app_version
    , device_type
    , is_session_with_add_to_cart
    , is_session_with_checkout_started
    , is_session_with_order_placed
    , country_iso
    , case when t1.event_name is not null then 1 else 0 end as is_session_registration_success
    , case when t2.event_name is not null then 1 else 0 end as is_session_registration_viewed
    , case when t3.event_name is not null then 1 else 0 end as is_session_account_login_viewed
    , case when t4.event_name is not null then 1 else 0 end as is_session_account_login_succeeded
    , case when t5.event_name is not null then 1 else 0 end as is_session_account_login_clicked
    , case when t6.event_name is not null then 1 else 0 end as is_session_account_login_error_viewed
    , case when t7.event_name is not null then 1 else 0 end as is_session_account_registration_error_viewed
FROM `flink-data-prod.curated.app_sessions_full_load` s
    LEFT JOIN (
        SELECT
              event_name
            , session_id
            , anonymous_id
        FROM `flink-data-prod.curated.app_session_events_full_load`
            WHERE event_name = 'account_registration_succeeded'
            AND date(event_timestamp) >= "2021-11-01"
    ) t1
    ON s.session_uuid = t1.session_id
    LEFT JOIN (
        SELECT
              event_name
            , session_id
            , anonymous_id
        FROM `flink-data-prod.curated.app_session_events_full_load`
            WHERE event_name = 'account_registration_viewed'
            AND date(event_timestamp) >= "2021-11-01"
    ) t2
    ON s.session_uuid = t2.session_id
    LEFT JOIN (
        SELECT
              event_name
            , session_id
            , anonymous_id
        FROM `flink-data-prod.curated.app_session_events_full_load`
            WHERE event_name = 'account_login_viewed'
            AND date(event_timestamp) >= "2021-11-01"
    ) t3
    ON s.session_uuid = t3.session_id
    LEFT JOIN (
        SELECT
              event_name
            , session_id
            , anonymous_id
        FROM `flink-data-prod.curated.app_session_events_full_load`
            WHERE event_name = 'account_login_succeeded'
            AND date(event_timestamp) >= "2021-11-01"
    ) t4
    ON s.session_uuid = t4.session_id
    LEFT JOIN (
        SELECT
              event_name
            , session_id
            , anonymous_id
        FROM `flink-data-prod.curated.app_session_events_full_load`
            WHERE event_name = 'account_login_clicked'
            AND date(event_timestamp) >= "2021-11-01"
    ) t5
    ON s.session_uuid = t5.session_id
    LEFT JOIN (
        SELECT
              event_name
            , session_id
            , anonymous_id
        FROM `flink-data-prod.curated.app_session_events_full_load`
            WHERE event_name = 'account_login_error_viewed'
            AND date(event_timestamp) >= "2021-11-01"
    ) t6
    ON s.session_uuid = t6.session_id
    LEFT JOIN (
        SELECT
              event_name
            , session_id
            , anonymous_id
        FROM `flink-data-prod.curated.app_session_events_full_load`
            WHERE event_name = 'account_registration_error_viewed'
            AND date(event_timestamp) >= "2021-11-01"
    ) t7
    ON s.session_uuid = t7.session_id
WHERE
    DATE(session_start_at) >= "2021-11-01"
AND
     ((device_type = 'android' AND app_version >= '2.11') OR (device_type = 'ios' AND app_version >= '2.13'))
AND is_session_with_add_to_cart is true
)

SELECT *
FROM sessions  ;;
  }


  # # You can specify the table name if it's different from the view name:
  # sql_table_name: my_schema_name.tester ;;
  #
  # # Define your dimensions and measures here, like this:
  # dimension: user_id {
  #   description: "Unique ID for each user that has ordered"
  #   type: number
  #   sql: ${TABLE}.user_id ;;
  # }
  #
  # dimension: lifetime_orders {
  #   description: "The total number of orders for each user"
  #   type: number
  #   sql: ${TABLE}.lifetime_orders ;;
  # }
  #
  # dimension_group: most_recent_purchase {
  #   description: "The date when each user last ordered"
  #   type: time
  #   timeframes: [date, week, month, year]
  #   sql: ${TABLE}.most_recent_purchase_at ;;
  # }
  #
  # measure: total_lifetime_orders {
  #   description: "Use this for counting lifetime orders across many users"
  #   type: sum
  #   sql: ${lifetime_orders} ;;
  # }
}

# view: user_accounts_analysis {
#   # Or, you could make this view a derived table, like this:
#   derived_table: {
#     sql: SELECT
#         user_id as user_id
#         , COUNT(*) as lifetime_orders
#         , MAX(orders.created_at) as most_recent_purchase_at
#       FROM orders
#       GROUP BY user_id
#       ;;
#   }
#
#   # Define your dimensions and measures here, like this:
#   dimension: user_id {
#     description: "Unique ID for each user that has ordered"
#     type: number
#     sql: ${TABLE}.user_id ;;
#   }
#
#   dimension: lifetime_orders {
#     description: "The total number of orders for each user"
#     type: number
#     sql: ${TABLE}.lifetime_orders ;;
#   }
#
#   dimension_group: most_recent_purchase {
#     description: "The date when each user last ordered"
#     type: time
#     timeframes: [date, week, month, year]
#     sql: ${TABLE}.most_recent_purchase_at ;;
#   }
#
#   measure: total_lifetime_orders {
#     description: "Use this for counting lifetime orders across many users"
#     type: sum
#     sql: ${lifetime_orders} ;;
#   }
# }
