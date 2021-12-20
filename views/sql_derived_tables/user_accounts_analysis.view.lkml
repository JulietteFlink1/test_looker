view: user_accounts_analysis {
  derived_table: {
    sql:
WITH sessions AS (
SELECT DISTINCT
      session_uuid
    , s.anonymous_id
    , DATE(session_start_at) as session_start_at
    , is_new_user
    , app_version
    , device_type
    , is_session_with_add_to_cart
    , case when t10.event_name is not null then true else false end as is_session_with_cart_viewed
    , is_session_with_checkout_started
    , case when t9.event_name is not null then true else false end as is_session_with_checkout_viewed
    , is_session_with_payment_started
    , is_session_with_order_placed
    , country_iso
    , t0.registration_timestamp
    , case when (t0.registration_timestamp  is not null and s.session_start_at > t0.registration_timestamp) then true else false end as is_user_already_registered
    , case when t1.event_name is not null then true else false end as is_session_registration_success
    , case when t2.event_name is not null then true else false end as is_session_registration_viewed
    , case when t3.event_name is not null then true else false end as is_session_login_viewed
    , case when t4.event_name is not null then true else false end as is_session_login_succeeded
    , case when t5.event_name is not null then true else false end as is_session_login_clicked
    , case when t6.event_name is not null then true else false end as is_session_login_error_viewed
    , case when t7.event_name is not null then true else false end as is_session_registration_error_viewed
    , case when t8.event_name is not null then true else false end as is_session_logout
FROM `flink-data-prod.curated.app_sessions_full_load` s
    LEFT JOIN (
        SELECT
              event_name
            , anonymous_id
            , min(event_timestamp) as registration_timestamp
        FROM `flink-data-prod.curated.app_session_events_full_load`
            WHERE event_name = 'account_registration_succeeded'
            AND date(event_timestamp) >= "2021-10-20"
            GROUP BY 1,2
    ) t0
    ON s.anonymous_id = t0.anonymous_id
    LEFT JOIN (
        SELECT
              event_name
            , session_id
            , anonymous_id
        FROM `flink-data-prod.curated.app_session_events_full_load`
            WHERE event_name = 'account_registration_succeeded'
            AND date(event_timestamp) >= "2021-10-20"
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
    LEFT JOIN (
        SELECT
              event_name
            , session_id
            , anonymous_id
        FROM `flink-data-prod.curated.app_session_events_full_load`
            WHERE event_name = 'account_logout_clicked'
            AND date(event_timestamp) >= "2021-11-01"
    ) t8
    ON s.session_uuid = t8.session_id
    LEFT JOIN (
        SELECT
              event_name
            , session_id
            , anonymous_id
        FROM `flink-data-prod.curated.app_session_events_full_load`
            WHERE event_name = 'checkout_viewed'
            AND date(event_timestamp) >= "2021-11-01"
    ) t9
    ON s.session_uuid = t9.session_id
    LEFT JOIN (
        SELECT
              event_name
            , session_id
            , anonymous_id
        FROM `flink-data-prod.curated.app_session_events_full_load`
            WHERE event_name = 'cart_viewed'
            AND date(event_timestamp) >= "2021-11-01"
    ) t10
    ON s.session_uuid = t10.session_id
WHERE
    DATE(session_start_at) >= "2021-11-01"
AND
     ((device_type = 'android' AND app_version >= '2.11') OR (device_type = 'ios' AND app_version >= '2.13'))
AND is_session_with_add_to_cart is true
)

SELECT *
FROM sessions  ;;
  }


## Dimensions

  dimension: session_id {
    description: "Unique session_uuid"
    type: string
    sql: ${TABLE}.session_uuid ;;
    primary_key: yes
  }

  dimension: anonymous_id {
    description: "Unique anonymous_id"
    type: string
    sql: ${TABLE}.anonymous_id ;;
    hidden: yes
  }

  dimension: is_new_user {
    description: "New User Flag"
    type: yesno
    sql: ${TABLE}.is_new_user ;;
  }

  dimension: app_version {
    description: "App version"
    type: string
    sql: ${TABLE}.app_version ;;
  }

  dimension: device_type {
    description: "Platform"
    type: string
    sql: ${TABLE}.device_type ;;
  }

  dimension: country_iso {
    description: "Country"
    type: string
    sql: ${TABLE}.country_iso ;;
  }


  dimension_group: session_start_at {
    description: "The date when session started"
    type: time
    timeframes: [date, week, month, year]
    sql: CAST(${TABLE}.session_start_at as DATE) ;;
    datatype: date
  }


## Dimensions session

  dimension: is_session_with_add_to_cart {
    description: "Session with Add To Cart"
    type: yesno
    sql: ${TABLE}.is_session_with_add_to_cart ;;
  }

  dimension: is_session_with_cart_viewed {
    description: "Session with Cart Viewed"
    type: yesno
    sql: ${TABLE}.is_session_with_cart_viewed ;;
  }
  dimension: is_session_with_checkout_started {
    description: "Session with Checkout Started"
    type: yesno
    sql: ${TABLE}.is_session_with_checkout_started ;;
  }

  dimension: is_session_with_checkout_viewed {
    description: "Session with Checkout Viewed"
    type: yesno
    sql: ${TABLE}.is_session_with_checkout_viewed ;;
  }

  dimension: is_session_with_payment_started {
    description: "Session with Payment Started"
    type: yesno
    sql: ${TABLE}.is_session_with_payment_started ;;
  }
  dimension: is_session_with_order_placed {
    description: "Session with Order Placed"
    type: yesno
    sql: ${TABLE}.is_session_with_order_placed ;;
  }

  dimension: is_session_with_registration_success {
    description: "Session with Successfull registration"
    type: yesno
    sql: ${TABLE}.is_session_registration_success ;;
  }

  dimension: is_session_with_registration_viewed {
    description: "Session with Successfull registration"
    type: yesno
    sql: ${TABLE}.is_session_registration_viewed ;;
  }

  dimension: is_session_with_registration_error {
    description: "Session with Successfull registration"
    type: yesno
    sql: ${TABLE}.is_session_registration_error_viewed ;;
  }

  dimension: is_session_account_login_succeeded {
    description: "Session with Successfull Login"
    type: yesno
    sql: ${TABLE}.is_session_account_login_succeeded ;;
  }

  dimension: is_session_with_logout {
    description: "Session with Successfull registration"
    type: yesno
    sql: ${TABLE}.is_session_logout ;;
  }

  dimension: is_user_already_registered {
    description: "Is Registered User"
    type: yesno
    sql: ${TABLE}.is_user_already_registered ;;
  }

  ## Measures

  measure: unique_sessions_count {
    description: "# Unique Sessions"
    type: count_distinct
    sql: ${session_id} ;;
  }

  # measure: unique_sessions_add_to_cart_with_registration_screen {
  #   description: "# Unique Sessions Add To Cart and Registration Screen Viewed"
  #   type: count_distinct
  #   sql: ${session_id} ;;
  #   filters: [is_session_with_add_to_cart: "yes", is_session_with_registration_viewed: "yes"]
  # }

  # measure: unique_sessions_add_to_cart_with_no_registration_screen {
  #   description: "# Unique Sessions Add To Cart and No Registration Screen Viewed"
  #   type: count_distinct
  #   sql: ${session_id} ;;
  #   filters: [is_session_with_add_to_cart: "yes", is_session_with_registration_viewed: "no"]
  # }

  measure: unique_sessions_cart_viewd {
    description: "# Unique Sessions Cart Viewed"
    type: count_distinct
    sql: ${session_id} ;;
    filters: [is_session_with_cart_viewed: "yes"]
  }

  measure: unique_sessions_checkout_started {
    description: "# Unique Sessions Checkout Started"
    type: count_distinct
    sql: ${session_id} ;;
    filters: [is_session_with_checkout_started: "yes"]
  }

  measure: unique_sessions_checkout_viewed {
    description: "# Unique Sessions Checkout Viewed"
    type: count_distinct
    sql: ${session_id} ;;
    filters: [is_session_with_checkout_viewed: "yes"]
  }

  measure: unique_sessions_payment_started {
    description: "# Unique Sessions Payment Started"
    type: count_distinct
    sql: ${session_id} ;;
    filters: [is_session_with_payment_started: "yes"]
  }

  measure: unique_sessions_order_placed {
    description: "# Unique Sessions Order Placed"
    type: count_distinct
    sql: ${session_id} ;;
    filters: [is_session_with_order_placed: "yes"]
  }

  # is session_start_at > than timestamp_registration then already_registerede else non_registered

}
