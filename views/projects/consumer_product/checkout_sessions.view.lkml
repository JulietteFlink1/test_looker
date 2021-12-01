view: checkout_sessions {
  derived_table: {
    persist_for: "1 hour"
    sql: WITH
      events AS (
          SELECT
            anonymous_id,
            event_name AS event,
            event_timestamp AS timestamp,
            event_uuid AS id
          FROM `flink-data-prod.curated.app_session_events_full_load`
        )

      , sessions_final AS ( -- getting 30 min sessions
            SELECT
              anonymous_id,
              session_uuid AS session_id,
              is_new_user,
              session_start_at,
              session_end_at,
              app_version AS context_app_version,
              device_type AS context_device_type,
              country_iso AS hub_country,
              city AS hub_city,
              hub_code,
              delivery_pdt_minutes AS delivery_pdt,
              case when user_id is not null then true else false end as flag_session_logged_in
            FROM `flink-data-prod.curated.app_sessions_full_load`
        )

    , event_counts AS (
       SELECT
           sf.anonymous_id
         , sf.session_id
         , sf.flag_session_logged_in
         , COALESCE(op.voucher_code, vaf.voucher_code,vas.voucher_code) as voucher_code
         , vaf.error_message
         , arev.error as error_registration
         , alev.error as error_login
         , SUM(CASE WHEN e.event="account_registration_viewed" THEN 1 ELSE 0 END) as account_registration_viewed_count
         , SUM(CASE WHEN e.event="account_registration_succeeded" THEN 1 ELSE 0 END) as account_registration_succeeded_count
         , SUM(CASE WHEN e.event="account_registration_error_viewed" THEN 1 ELSE 0 END) as account_registration_error_viewed_count
         , SUM(CASE WHEN e.event="account_login_clicked" THEN 1 ELSE 0 END) as account_login_clicked_count
         , SUM(CASE WHEN e.event="account_login_viewed" THEN 1 ELSE 0 END) as account_login_viewed_count
         , SUM(CASE WHEN e.event="account_login_succeeded" THEN 1 ELSE 0 END) as account_login_succeeded_count
         , SUM(CASE WHEN e.event="account_login_error_viewed" THEN 1 ELSE 0 END) as account_login_error_viewed_count
         , SUM(CASE WHEN ch.id IS NOT NULL THEN 1 ELSE 0 END) as checkout_stared_count
         , SUM(CASE WHEN e.event="address_confirmed" THEN 1 ELSE 0 END) as address_confirmed_event_count
         , SUM(CASE WHEN e.event="product_added_to_cart" THEN 1 ELSE 0 END) as product_added_to_cart_count
         , SUM(CASE WHEN e.event="cart_viewed" THEN 1 ELSE 0 END) as cart_viewed_count
         , SUM(CASE WHEN e.event="address_change_at_checkout_message_viewed" THEN 1 ELSE 0 END) as late_change_event_count
         , SUM(CASE WHEN e.event="hub_update_message_viewed" THEN 1 ELSE 0 END) as hub_update_event_count
         , SUM(CASE WHEN e.event="checkout_started" THEN 1 ELSE 0 END) as checkout_started_event_count
         , SUM(CASE WHEN e.event IN ("purchase_confirmed","payment_started") THEN 1 ELSE 0 END) as payment_started_event_count
         , SUM(CASE WHEN e.event="payment_failed" THEN 1 ELSE 0 END) as payment_failed_event_count
         , SUM(CASE WHEN e.event="order_placed" THEN 1 ELSE 0 END) as order_placed_event_count
         , SUM(CASE WHEN op.voucher_code IS NOT NULL THEN 1 else 0 end) as order_placed_with_voucher_count
         , SUM(CASE WHEN vaf.id IS NOT NULL THEN 1 ELSE 0 END) as voucher_applied_failed_count
         , SUM(CASE WHEN vas.id IS NOT NULL THEN 1 ELSE 0 END) as voucher_applied_succeeded_count
         , SUM(CASE WHEN vra.id IS NOT NULL THEN 1 ELSE 0 END) as voucher_redemption_attempted_count
         , SUM(op.revenue) as revenue
         , SUM(COALESCE(op.voucher_value,vas.voucher_value)) as voucher_value
        FROM events e
            LEFT JOIN sessions_final sf
            ON e.anonymous_id = sf.anonymous_id
            AND e.timestamp >= sf.session_start_at
            AND ( e.timestamp <= sf.session_end_at OR session_end_at IS NULL)
            LEFT JOIN (
                SELECT
                      id
                FROM `flink-data-prod.flink_ios_production.checkout_started` csi
                UNION ALL
                SELECT
                      id
                FROM `flink-data-prod.flink_android_production.checkout_started` csi
            ) ch
                ON e.id = ch.id
            LEFT JOIN (
                SELECT
                      id
                    , voucher_code
                    , voucher_value
                    , revenue
                    , order_number
                FROM `flink-data-prod.flink_ios_production.order_placed`
                UNION ALL
                SELECT
                      id
                    , voucher_code
                    , voucher_value
                    , revenue
                    , order_number
                FROM `flink-data-prod.flink_android_production.order_placed`
            ) op
                ON e.id = op.id
            LEFT JOIN (
                SELECT
                      id
                    , voucher_code
                    , error_message
                FROM `flink-data-prod.flink_ios_production.voucher_applied_failed`
                UNION ALL
                SELECT
                      id
                    , voucher_code
                    , error_message
                FROM `flink-data-prod.flink_ios_production.voucher_applied_failed`
            ) vaf
                ON vaf.id = e.id
           LEFT JOIN (
                SELECT
                      id
                    , voucher_code
                    , voucher_value
                FROM `flink-data-prod.flink_ios_production.voucher_applied_succeeded`
                UNION ALL
                SELECT
                      id
                    , voucher_code
                    , voucher_value
                FROM `flink-data-prod.flink_android_production.voucher_applied_succeeded`
            ) vas
            ON vas.id = e.id
            LEFT JOIN (
                SELECT
                      id
                    , voucher_code
                FROM `flink-data-prod.flink_ios_production.voucher_redemption_attempted`
                UNION ALL
                SELECT
                      id
                    , voucher_code
                FROM `flink-data-prod.flink_android_production.voucher_redemption_attempted`
            ) vra
            ON vra.id = e.id
            LEFT JOIN (
                SELECT
                      id
                    , error
                FROM `flink-data-prod.flink_ios_production.account_login_error_viewed`
                UNION ALL
                SELECT
                      id
                    , error
                FROM `flink-data-prod.flink_android_production.account_login_error_viewed`
            ) alev
            ON alev.id = e.id
            LEFT JOIN (
                SELECT
                      id
                    , error
                FROM `flink-data-prod.flink_ios_production.account_registration_error_viewed`
                UNION ALL
                SELECT
                      id
                    , error
                FROM `flink-data-prod.flink_android_production.account_registration_error_viewed`

            ) arev
            ON arev.id = e.id
        GROUP BY 1,2,3,4,5,6,7
    ),



    -- table to check whether checkout follows a hub_update message or hub_update message follows checkout (both are interesting)
    checkoutstarted_and_hubupdated_sequence AS (
       SELECT
           sf.anonymous_id
         , sf.session_id
         , e.event
         , e.timestamp
         , MAX(event="checkout_started") OVER
            (PARTITION BY session_id ORDER BY timestamp ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING)  AS preceeded_by_checkout_started
        , MAX(event="hub_update_message_viewed") OVER
            (PARTITION BY session_id ORDER BY timestamp ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING)  AS preceeded_by_hub_update
        , MAX(event="order_placed") OVER
            (PARTITION BY session_id ORDER BY timestamp ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING)  AS preceeded_by_order_placed
        FROM events e
            LEFT JOIN sessions_final sf
            ON e.anonymous_id = sf.anonymous_id
            AND e.timestamp >= sf.session_start_at
            AND ( e.timestamp <= sf.session_end_at OR session_end_at IS NULL)
        WHERE e.event = 'checkout_started' OR e.event="hub_update_message_viewed" OR e.event="address_confirmed" OR e.event="order_placed"
    ),

    -- group the sequences to one session_id for merging with sessions table
    sequence_combined_tb AS (
      SELECT session_id
      , MAX(IF(event="checkout_started" AND preceeded_by_hub_update, TRUE, FALSE)) AS checkout_after_hub_update
      , MAX(IF(event="hub_update_message_viewed" AND preceeded_by_checkout_started, TRUE, FALSE)) AS hub_update_after_checkout
      , MAX(IF(event="address_confirmed" AND preceeded_by_checkout_started AND NOT(preceeded_by_order_placed), TRUE, FALSE)) AS address_confirm_after_checkout
       FROM checkoutstarted_and_hubupdated_sequence
       GROUP BY 1
    )

    SELECT
          sf.anonymous_id
        , sf.context_app_version
        , sf.context_device_type
        , sf.session_id
        , sf.is_new_user
        , datetime(sf.session_start_at,
          'UTC') AS session_start_at
        , datetime(sf.session_end_at,
          'UTC') AS session_end_at
        , sf.hub_code
        , sf.hub_country
        , sf.hub_city
        , sf.delivery_pdt
        , sf.flag_session_logged_in
        , ec.product_added_to_cart_count as product_added_to_cart
        , ec.cart_viewed_count as cart_viewed
        , ec.account_registration_viewed_count as account_registration_viewed
        , ec.account_registration_succeeded_count as account_registration_succeeded
        , ec.account_registration_error_viewed_count as account_registration_error_viewed
        , ec.account_login_clicked_count as account_login_clicked
        , ec.account_login_viewed_count as account_login_viewed
        , ec.account_login_succeeded_count as account_login_succeeded
        , ec.account_login_error_viewed_count as account_login_error_viewed
        , ec.checkout_started_event_count as checkout_started
        , ec.voucher_redemption_attempted_count as voucher_redemption_attempted
        , ec.voucher_applied_failed_count as voucher_applied_failed
        , ec.error_message
        , ec.error_login
        , ec.error_registration
        , ec.voucher_applied_succeeded_count as voucher_applied_succeeded
        , ec.voucher_code
        , ec.voucher_value
        , ec.order_placed_event_count as order_placed
        , ec.order_placed_with_voucher_count  as order_placed_with_voucher
        , ec.revenue
        , ec.hub_update_event_count as hub_update_message
        , ec.late_change_event_count as address_change_at_checkout
        , sc.checkout_after_hub_update
        , sc.hub_update_after_checkout
        , sc.address_confirm_after_checkout
        , ec.payment_started_event_count as payment_started
        , ec.payment_failed_event_count as payment_failed

        --, CASE WHEN fo.first_order_timestamp < sf.session_start_at THEN true ELSE false END as has_ordered
    FROM sessions_final sf
    LEFT JOIN event_counts ec
    ON sf.session_id=ec.session_id
    LEFT JOIN sequence_combined_tb sc
    ON sf.session_id=sc.session_id
    ORDER BY 1
 ;;
  }

  ### custom measures and dimensions
  dimension: is_first_session {
    type: yesno
    sql: ${TABLE}.is_new_user ;;
  }

  dimension: is_logged_in_session {
    type: yesno
    sql: ${TABLE}.flag_session_logged_in ;;
  }

  dimension: is_exposed_registration {
    type: yesno
    sql: ${TABLE}.account_registration_viewed>0 ;;
  }

  measure: cnt_address_confirm_after_checkout {
    label: "Cnt Address Confirm After Checkout Started Sessions"
    description: "Number of sessions in which user confirmed an address after checkout was started without having placed an order inbetween"
    type: count
    filters: [address_confirm_after_checkout: "yes"]
  }

  measure: cnt_hub_update_after_checkout {
    label: "Cnt Hub Update Message Viewed After Checkout Started Sessions"
    description: "Number of sessions in which user lost their cart due to location update after checkout was started"
    type: count
    filters: [hub_update_after_checkout: "yes"]
  }

  measure: cnt_checkout_after_hub_update {
    label: "Cnt Checkout Started After Hub Update Message Viewed Sessions"
    description: "Number of sessions in which a checkout was started after the user lost their cart due to location update"
    type: count
    filters: [hub_update_after_checkout: "yes"]
  }

  measure: cnt_checkoutstarted_and_cart_lost {
    label: "Cnt Checkout Started And Hub Update Message Viewed Sessions"
    description: "Number of sessions in which a checkout was started and the user lost their cart due to location update (one event did not necessarily occur before the other)"
    type: count
    filters: [checkout_started: ">0", hub_update_message: ">0"]
  }

  measure: cnt_hub_update_message {
    label: "# Hub Update Message Viewed sessions"
    description: "# sessions with Hub Update Message Viewed event"
    type: count
    filters: [hub_update_message: ">0"]
  }

  measure: cnt_address_change_at_checkout {
    label: "# Address Change At Checkout Viewed sessions"
    description: "# sessions with Address Change At Checkout Viewed event"
    type: count
    filters: [address_change_at_checkout: ">0"]
  }

  measure: cnt_add_to_cart {
    label: "Add to cart count"
    description: "Number of sessions in which at least one Product Added To Cart event happened"
    type: count
    filters: [product_added_to_cart: ">0"]
  }

  measure: cnt_cart_viewed {
    label: "Cart Viewed count"
    description: "Number of sessions in which at least one Cart Viewed event happened"
    type: count
    filters: [cart_viewed: ">0"]
  }

  measure: cnt_payment_started {
    label: "Payment started count"
    description: "Number of sessions in which at least one Payment Started event happened"
    type: count
    filters: [payment_started: ">0"]
  }

  measure: cnt_checkout_started {
    label: "Checkout started count"
    description: "Number of sessions in which at least one Checkout Started event happened"
    type: count
    filters: [checkout_started: ">0"]
  }

  measure: cnt_voucher_attempt {
    label: "Checkout started and attempt voucher count"
    description: "Number of sessions in which at least one Checkout Started event happened and attemoted to apply a voucher at least once"
    type: count
    filters: [voucher_redemption_attempted: ">0"]
  }

  measure: cnt_voucher_attempt_voucher_success {
    label: "Voucher attempts and Success count"
    description: "Number of sessions in which at least one Voucher Attempt happened in checkout session and was successfull"
    type: count
    filters: [voucher_applied_succeeded: ">0"]
  }

  measure: cnt_voucher_attempt_voucher_failure {
    label: "Voucher attempts and Failure count"
    description: "Number of sessions in which at least one Voucher Attempt happened in checkout session and failed"
    type: count
    filters: [voucher_applied_failed: ">0"]
  }

  measure: cnt_voucher_failed_no_order {
    label: "Voucher Failure and No order count"
    description: "Number of sessions in which at least one Voucher Attempt happened in checkout session, failed, and thre was no order generated"
    type: count
    filters: [voucher_applied_failed: ">0", order_placed: "=0"]
  }

  measure: cnt_voucher_failed_yes_order {
    label: "Voucher Failure but placed Order count"
    description: "Number of sessions in which at least one Voucher Attempt happened in checkout session, failed, and thre was no order generated"
    type: count
    filters: [voucher_applied_failed: ">0", order_placed: ">0"]
  }

  measure: cnt_payment_failed {
    label: "Payment failed count"
    description: "Number of sessions in which at least one Payment Failed event happened"
    type: count
    filters: [payment_failed: ">0"]
  }

  measure: cnt_payment_failed_no_order {
    label: "Payment failed and no order placed"
    description: "Number of sessions in which at least one Payment Failed event happened and there was no order placed in the session"
    type: count
    filters: [payment_failed: ">0", order_placed: "=0"]
  }

  measure: cnt_order_placed {
    label: "Order Placed"
    description: "Number of sessions in which there was at least one Order Placed"
    type: count
    filters: [order_placed: ">0"]
  }

  measure: cnt_account_registration_viewed {
    label: "Registration Viewed"
    description: "Number of sessions in which there was at least one Registration Screen was viewed"
    type: count
    filters: [account_registration_viewed: ">0"]
  }

  measure: cnt_account_registration_succeeded {
    label: "Registration Succeeded"
    description: "Number of sessions in which there was at least one Successfull Registration"
    type: count
    filters: [account_registration_succeeded: ">0"]
  }

  measure: cnt_account_registration_error {
    label: "Registration Error"
    description: "Number of sessions in which there was at least one Registration Error"
    type: count
    filters: [account_registration_error_viewed: ">0"]
  }

  measure: cnt_account_login_clicked {
    label: "Login Attempt"
    description: "Number of sessions in which there was at least one Login Click (attempt)"
    type: count
    filters: [account_login_clicked: ">0"]
  }

  measure: cnt_account_login_succeeded {
    label: "Login Succeeded"
    description: "Number of sessions in which there was at least one Successfull Login"
    type: count
    filters: [account_login_succeeded: ">0"]
  }

  measure: cnt_account_login_viewed {
    label: "Login Viewed"
    description: "Number of sessions in which there was at least one Login Screen View"
    type: count
    filters: [account_login_viewed: ">0"]
  }

  measure: cnt_account_login_error {
    label: "Login Error"
    description: "Number of sessions in which there was at least one Login Error"
    type: count
    filters: [account_login_error_viewed: ">0"]
  }

  measure: cnt_unique_anonymousid {
    label: "Cnt Unique Users With Sessions"
    description: "Number of Unique Users identified via Anonymous ID from Segment that had a session"
    hidden:  no
    type: count_distinct
    sql: ${anonymous_id};;
    value_format_name: decimal_0
  }

  measure: cnt_unique_sessionid {
    label: "Cnt Unique Sessions"
    description: "Number of Unique sessions"
    hidden:  no
    type: count_distinct
    sql: ${session_id};;
    value_format_name: decimal_0
  }


  measure: orderplaced_per_paymentstarted_perc{
    type: number
    sql: ${checkout_sessions.cnt_order_placed}/NULLIF(${checkout_sessions.cnt_payment_started},0) ;;
    value_format_name: percent_1
    drill_fields: [session_start_at_date, orderplaced_per_paymentstarted_perc]
    link: {
      label: "% Sessions with Order Placed out of Payment Started"
      url: "/looks/688"
    }
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

  measure: mcvr3 {
    type: number
    label: "mCVR3"
    description: "#sessions in which there was a Checkout Started event happened, compared to the number of sessions in which there was a Product Added To Cart"
    value_format_name: percent_1
    sql: ${cnt_checkout_started}/NULLIF(${cnt_add_to_cart},0) ;;
  }

  measure: mcvr4 {
    type: number
    label: "mCVR4"
    description: "# sessions in which there was a Payment Started event happened, compared to the number of sessions in which there was a Checkout Started"
    value_format_name: percent_1
    sql: ${cnt_payment_started}/NULLIF(${cnt_checkout_started},0) ;;
  }

  measure: payment_success {
    type: number
    description: "Number of sessions in which there was an Order Placed, compared to the number of sessions in which there was a Payment Started"
    value_format_name: percent_1
    sql: ${cnt_order_placed}/NULLIF(${cnt_payment_started},0) ;;
  }



  dimension: full_app_version {
    type: string
    sql: ${context_device_type} || '-' || ${context_app_version} ;;
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

  ### standard measures

  # warning: this typing will make all null values equal to false. In this dimension that seems appropriate
  dimension: address_confirm_after_checkout {
    type: yesno
    sql: ${TABLE}.address_confirm_after_checkout ;;
  }

  # warning: this typing will make all null values equal to false. In this dimension that seems appropriate
  dimension: hub_update_after_checkout {
    type: yesno
    sql: ${TABLE}.hub_update_after_checkout ;;
  }

  # warning: this typing will make all null values equal to false. In this dimension that seems appropriate
  dimension: checkout_after_hub_update {
    type: yesno
    sql: ${TABLE}.checkout_after_hub_update ;;
  }

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
    primary_key: yes
  }

  dimension_group: session_start_at {
    type: time
    datatype: datetime
    sql: ${TABLE}.session_start_at ;;
  }

  dimension_group: session_end_at {
    type: time
    datatype: datetime
    sql: ${TABLE}.session_end_at ;;
  }

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

  dimension: delivery_pdt {
    type: number
    sql: ${TABLE}.delivery_pdt ;;
  }

  dimension: product_added_to_cart {
    type: number
    sql: ${TABLE}.product_added_to_cart ;;
  }

  dimension: cart_viewed {
    type: number
    sql: ${TABLE}.cart_viewed ;;
  }

  dimension: checkout_started {
    type: number
    sql: ${TABLE}.checkout_started ;;
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

  dimension: address_change_at_checkout {
    type: number
    sql: ${TABLE}.address_change_at_checkout ;;
  }

  dimension: hub_update_message {
    type: number
    sql: ${TABLE}.hub_update_message ;;
  }

  dimension: voucher_value {
    type: number
    sql: ${TABLE}.voucher_value ;;
  }

  dimension: voucher_code {
    type: string
    sql: ${TABLE}.voucher_code ;;
  }

  dimension: error_message {
    type: string
    sql: ${TABLE}.error_message ;;
  }

  dimension: voucher_applied_failed {
    type: number
    sql: ${TABLE}.voucher_applied_failed ;;
  }

  dimension: voucher_applied_succeeded {
    type: number
    sql: ${TABLE}.voucher_applied_succeeded ;;
  }

  dimension: voucher_redemption_attempted {
    type: number
    sql: ${TABLE}.voucher_redemption_attempted ;;
  }

  dimension: error_login {
    type: string
    sql: ${TABLE}.error_login ;;
  }

  dimension: error_registration {
    type: string
    sql: ${TABLE}.error_registration ;;
  }

  dimension: account_registration_viewed {
    type: number
    sql: ${TABLE}.account_registration_viewed ;;
  }

  dimension: account_registration_succeeded {
    type: number
    sql: ${TABLE}.account_registration_succeeded ;;
  }

  dimension: account_registration_error_viewed {
    type: number
    sql: ${TABLE}.account_registration_error_viewed ;;
  }

  dimension: account_login_clicked {
    type: number
    sql: ${TABLE}.account_login_clicked ;;
  }

  dimension: account_login_viewed {
    type: number
    sql: ${TABLE}.account_login_viewed ;;
  }

  dimension: account_login_succeeded {
    type: number
    sql: ${TABLE}.account_login_succeeded ;;
  }

  dimension: account_login_error_viewed {
    type: number
    sql: ${TABLE}.account_login_error_viewed ;;
  }


  set: detail {
    fields: [
      anonymous_id,
      context_app_version,
      context_device_type,
      session_id,
      session_start_at_time,
      session_end_at_time,
      hub_code,
      hub_country,
      hub_city,
      delivery_pdt,
      payment_started,
      payment_failed,
      order_placed,
      address_change_at_checkout,
      hub_update_message,
      checkout_started,
      voucher_value,
      voucher_code,
      error_message,
      error_login,
      error_registration,
      voucher_applied_failed,
      voucher_applied_succeeded,
      voucher_redemption_attempted,
      account_registration_viewed,
      account_registration_succeeded,
      account_registration_error_viewed,
      account_login_clicked,
      account_login_succeeded,
      account_login_viewed,
      account_login_error_viewed,
      is_logged_in_session,
      is_first_session,
      is_exposed_registration

    ]
  }
}
