view: sms_verification_analysis {
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
        , country_iso
        , is_session_with_add_to_cart
        , case when t10.event_name is not null then true else false end as is_session_with_cart_viewed
        , is_session_with_checkout_started
        , case when t9.event_name is not null then true else false end as is_session_with_checkout_viewed
        , is_session_with_payment_started
        , is_session_with_order_placed
        , t0.registration_timestamp
        , case when (t0.registration_timestamp  is not null and s.session_start_at > t0.registration_timestamp) then true else false end as is_user_already_registered
        , case when t1.event_name is not null then true else false end as is_session_registration_success
        , case when t2.event_name is not null then true else false end as is_session_registration_viewed
        , case when t3.event_name is not null then true else false end as is_session_sms_verification_request_viewed
        , case when t4.event_name is not null then true else false end as is_session_login_succeeded
        , case when t5.event_name is not null then true else false end as is_session_sms_verification_request_closed

        , case when t6.event_name is not null then true else false end as is_session_sms_verification_phone_added
        , case when t7.event_name is not null then true else false end as is_session_sms_verification_send_code_clicked
        , case when t8.event_name is not null then true else false end as is_session_sms_verification_resend_code_clicked

        , case when t11.event_name is not null then true else false end as is_session_sms_verification_viewed
        , case when t12.event_name is not null then true else false end as is_session_sms_verification_added
        , case when t13.event_name is not null then true else false end as is_session_sms_verification_clicked
        , case when t14.event_name is not null then true else false end as is_session_sms_verification_error_viewed
        , case when t15.event_name is not null then true else false end as is_session_sms_verification_confirmed
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
                AND date(event_timestamp) >= "2021-12-01"
        ) t2
        ON s.session_uuid = t2.session_id
        LEFT JOIN (
            SELECT
                  event_name
                , session_id
                , anonymous_id
            FROM `flink-data-prod.curated.app_session_events_full_load`
                WHERE event_name = 'sms_verification_request_viewed'
                AND date(event_timestamp) >= "2021-12-01"
        ) t3
        ON s.session_uuid = t3.session_id
        LEFT JOIN (
            SELECT
                  event_name
                , session_id
                , anonymous_id
            FROM `flink-data-prod.curated.app_session_events_full_load`
                WHERE event_name = 'account_login_succeeded'
                AND date(event_timestamp) >= "2021-12-01"
        ) t4
        ON s.session_uuid = t4.session_id
        LEFT JOIN (
            SELECT
                  event_name
                , session_id
                , anonymous_id
            FROM `flink-data-prod.curated.app_session_events_full_load`
                WHERE event_name = 'sms_verification_request_closed'
                AND date(event_timestamp) >= "2021-12-01"
        ) t5
        ON s.session_uuid = t5.session_id
        LEFT JOIN (
            SELECT
                  event_name
                , session_id
                , anonymous_id
            FROM `flink-data-prod.curated.app_session_events_full_load`
                WHERE event_name = 'sms_verification_phone_added'
                AND date(event_timestamp) >= "2021-12-01"
        ) t6
        ON s.session_uuid = t6.session_id
    LEFT JOIN (
        SELECT
              event_name
            , session_id
            , anonymous_id
        FROM `flink-data-prod.curated.app_session_events_full_load`
            WHERE event_name = 'sms_verification_send_code_clicked'
            AND date(event_timestamp) >= "2021-12-05"
    ) t7
    ON s.session_uuid = t7.session_id
        LEFT JOIN (
            SELECT
                  event_name
                , session_id
                , anonymous_id
            FROM `flink-data-prod.curated.app_session_events_full_load`
                WHERE event_name = 'sms_verification_resend_code_clicked'
                AND date(event_timestamp) >= "2021-12-01"
        ) t8
        ON s.session_uuid = t8.session_id
        LEFT JOIN (
            SELECT
                  event_name
                , session_id
                , anonymous_id
            FROM `flink-data-prod.curated.app_session_events_full_load`
                WHERE event_name = 'checkout_viewed'
                AND date(event_timestamp) >= "2021-12-01"
        ) t9
        ON s.session_uuid = t9.session_id
        LEFT JOIN (
            SELECT
                  event_name
                , session_id
                , anonymous_id
            FROM `flink-data-prod.curated.app_session_events_full_load`
                WHERE event_name = 'cart_viewed'
                AND date(event_timestamp) >= "2021-12-01"
        ) t10
        ON s.session_uuid = t10.session_id
        LEFT JOIN (
            SELECT
                  event_name
                , session_id
                , anonymous_id
            FROM `flink-data-prod.curated.app_session_events_full_load`
                WHERE event_name = 'sms_verification_viewed'
                AND date(event_timestamp) >= "2021-12-01"
        ) t11
        ON s.session_uuid = t11.session_id
    LEFT JOIN (
        SELECT
              event_name
            , session_id
            , anonymous_id
        FROM `flink-data-prod.curated.app_session_events_full_load`
            WHERE event_name = 'sms_verification_added'
            AND date(event_timestamp) >= "2021-12-05"
    ) t12
    ON s.session_uuid = t12.session_id
    LEFT JOIN (
        SELECT
              event_name
            , session_id
            , anonymous_id
        FROM `flink-data-prod.curated.app_session_events_full_load`
            WHERE event_name = 'sms_verification_clicked'
            AND date(event_timestamp) >= "2021-12-05"
    ) t13
    ON s.session_uuid = t13.session_id
    LEFT JOIN (
        SELECT
              event_name
            , session_id
            , anonymous_id
        FROM `flink-data-prod.curated.app_session_events_full_load`
            WHERE event_name = 'sms_verification_error_viewed'
            AND date(event_timestamp) >= "2021-12-05"
    ) t14
    ON s.session_uuid = t14.session_id
    LEFT JOIN (
        SELECT
              event_name
            , session_id
            , anonymous_id
        FROM `flink-data-prod.curated.app_session_events_full_load`
            WHERE event_name = 'sms_verification_confirmed'
            AND date(event_timestamp) >= "2021-12-05"
    ) t15
    ON s.session_uuid = t15.session_id
    WHERE
        DATE(session_start_at) >= "2021-12-01"
    AND
         device_type = 'ios'
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
    hidden: yes
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


  dimension: is_session_account_login_succeeded {
    description: "Session with Successfull Login"
    type: yesno
    sql: ${TABLE}.is_session_account_login_succeeded ;;
  }

  dimension: is_user_already_registered {
    description: "Is Registered User"
    type: yesno
    sql: ${TABLE}.is_user_already_registered ;;
  }
  dimension: is_session_sms_verification_request_viewed {
    description: "Is SMS Verification Request Viewed "
    type: yesno
    sql: ${TABLE}.is_session_sms_verification_request_viewed ;;
  }

  dimension: is_session_sms_verification_phone_added {
    description: "Is SMS Verification Phone Added"
    type: yesno
    sql: ${TABLE}.is_session_sms_verification_phone_added ;;
  }

  dimension: is_session_sms_verification_send_code_clicked {
    description: "Is SMS Verification Send Code"
    type: yesno
    sql: ${TABLE}.is_session_sms_verification_send_code_clicked ;;
  }

  dimension: is_session_sms_verification_added {
    description: "Is SMS Verification Added"
    type: yesno
    sql: ${TABLE}.is_session_sms_verification_added ;;
  }

  dimension: is_session_sms_verification_clicked {
    description: "Is SMS Verification Clicked"
    type: yesno
    sql: ${TABLE}.is_session_sms_verification_clicked ;;
  }

  dimension: is_session_sms_verification_resend_code_clicked {
    description: "Is SMS Verification Resend Code"
    type: yesno
    sql: ${TABLE}.is_session_sms_verification_resend_code_clicked ;;
  }

  dimension: is_session_sms_verification_confirmed {
    description: "Is SMS Verification Resend Code"
    type: yesno
    sql: ${TABLE}.is_session_sms_verification_confirmed ;;
  }

  dimension: is_session_sms_verification_request_closed {
    description: "Is SMS Verification Resend Code"
    type: yesno
    sql: ${TABLE}.is_session_sms_verification_request_closed ;;
  }

  dimension: is_session_sms_verification_viewed {
    description: "Is SMS Verification viewedd"
    type: yesno
    sql: ${TABLE}.is_session_sms_verification_viewed ;;
  }

  dimension: is_session_sms_verification_error_viewed {
    description: "Is SMS Verification error viewed"
    type: yesno
    sql: ${TABLE}.is_session_sms_verification_error_viewed ;;
  }

  ## Measures

  measure: unique_sessions_count {
    description: "# Unique Sessions"
    type: count_distinct
    sql: ${session_id} ;;
  }


  measure: unique_sessions_cart_viewd {
    description: "# Unique Sessions Cart Viewed"
    type: count_distinct
    sql: ${session_id} ;;
    filters: [is_session_with_cart_viewed: "yes"]
  }

  measure: unique_sessions_cart_viewd_control {
    description: "# Unique Sessions Cart Viewed"
    type: count_distinct
    sql: ${session_id} ;;
    filters: [is_session_with_cart_viewed: "yes", is_session_sms_verification_request_viewed: "no"]
  }

  measure: unique_sessions_cart_viewd_variant {
    description: "# Unique Sessions Cart Viewed"
    type: count_distinct
    sql: ${session_id} ;;
    filters: [is_session_with_cart_viewed: "yes", is_session_sms_verification_request_viewed: "yes"]
  }

  measure: unique_sessions_checkout_started {
    description: "# Unique Sessions Checkout Started"
    type: count_distinct
    sql: ${session_id} ;;
    filters: [is_session_with_checkout_started: "yes"]
    hidden: yes
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

  measure: unique_sessions_exposed_to_sms{
    description: "# Unique Sessions exposed to SMS Verficiation"
    type: count_distinct
    sql: ${session_id} ;;
    filters: [is_session_sms_verification_request_viewed: "yes"]
  }

  measure: unique_sessions_exposed_to_sms_and_success{
    description: "# Unique Sessions exposed to SMS Verficiation"
    type: count_distinct
    sql: ${session_id} ;;
    filters: [is_session_sms_verification_request_viewed: "yes",is_session_sms_verification_confirmed: "yes"]
  }

  measure: unique_sessions_new_customer_exposed_sms {
    description: "# Unique Sessions Not registered users and SMS Verficiation"
    type: count_distinct
    sql: ${session_id} ;;
    filters: [is_user_already_registered: "no", is_session_sms_verification_request_viewed: "yes"]
  }

  measure: unique_sessions_registration_viewes {
    description: "# Unique Sessions Registration Viewed"
    type: count_distinct
    sql: ${session_id} ;;
    filters: [is_session_with_registration_viewed: "yes"]
  }

  measure: unique_sessions_registration_success {
    description: "# Unique Sessions Registration Viewed"
    type: count_distinct
    sql: ${session_id} ;;
    filters: [is_session_with_registration_success: "yes"]
  }

  measure: unique_sessions_send_code {
    description: "# Unique Sessions send code "
    type: count_distinct
    sql: ${session_id} ;;
    filters: [is_session_sms_verification_send_code_clicked: "yes"]
  }

  measure: unique_sessions_resend_code {
    description: "# Unique Sessions resend code"
    type: count_distinct
    sql: ${session_id} ;;
    filters: [is_session_sms_verification_resend_code_clicked: "yes"]
  }

  measure: unique_sessions_phone_added {
    description: "# Unique Sessions phone added"
    type: count_distinct
    sql: ${session_id} ;;
    filters: [is_session_sms_verification_phone_added: "yes"]
  }

  measure: unique_sessions_code_added {
    description: "# Unique Sessions verification code added"
    type: count_distinct
    sql: ${session_id} ;;
    filters: [is_session_sms_verification_added: "yes"]
  }

  measure: unique_sessions_verification_closed{
    description: "# Unique Sessions verification closed"
    type: count_distinct
    sql: ${session_id} ;;
    filters: [is_session_sms_verification_request_closed: "yes"]
  }

  measure: unique_sessions_verification_viewed{
    description: "# Unique Sessions verification viewed"
    type: count_distinct
    sql: ${session_id} ;;
    filters: [is_session_sms_verification_viewed: "yes"]
  }

  measure: unique_sessions_verification_confirmed{
    description: "# Unique Sessions verification confirmed"
    type: count_distinct
    sql: ${session_id} ;;
    filters: [is_session_sms_verification_confirmed: "yes"]
  }

  measure: unique_sessions_error_viewed{
    description: "# Unique Sessions verification confirmed"
    type: count_distinct
    sql: ${session_id} ;;
    filters: [is_session_sms_verification_error_viewed: "yes"]
  }

  # is session_start_at > than timestamp_registration then already_registerede else non_registered

}
