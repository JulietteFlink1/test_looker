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


  ######### IDs ##########

  dimension: anonymous_id {
    group_label: "IDs"
    description: "Anonymous ID generated by Segment as user identifier"
    type: string
    sql: ${TABLE}.anonymous_id ;;
  }

  dimension: session_id {
    group_label: "IDs"
    description: "Session ID based on user and session definition, primary key of this model"
    type: string
    sql: ${TABLE}.session_id ;;
    primary_key: yes
  }

  ########## Device attributes #########
  dimension: context_app_version {
    group_label: "Device Dimensions"
    label: "App version"
    description: "App version used in the session"
    type: string
    sql: ${TABLE}.context_app_version ;;
  }

  dimension: context_device_type {
    group_label: "Device Dimensions"
    label: "Device Type"
    description: "iOS or Android"
    type: string
    sql: ${TABLE}.context_device_type ;;
  }

  dimension: full_app_version {
    group_label: "Device Dimensions"
    description: "Device type and app version combined in one dimension"
    type: string
    sql: ${context_device_type} || '-' || ${context_app_version} ;;
  }

  ########## Location attributes #########
  dimension: hub_code {
    group_label: "Location Dimensions"
    description: "Hub code associated with the last address the user selected"
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: hub_country {
    group_label: "Location Dimensions"
    hidden: yes
    type: string
    sql: ${TABLE}.hub_country ;;
  }

  dimension: hub_city {
    group_label: "Location Dimensions"
    label: "City"
    description: "City associated with the last address the user selected"
    type: string
    sql: ${TABLE}.hub_city ;;
  }

  dimension: country {
    group_label: "Location Dimensions"
    description: "Country ISO associated with the last address the user selected"
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


  ######## Count Sessions ########
  ##### Unique count of events during a session. If multiple events are triggerred during a session, e.g 3 times checkout started, this is counted as 1 session containing checkout started

  measure: cnt_address_confirm_after_checkout {
    group_label: "# Sessions"
    label: "# Sessions With Address Confirm After Checkout Started"
    description: "# sessions in which user confirmed an address after checkout was started without having placed an order inbetween"
    type: count
    filters: [address_confirm_after_checkout: "yes"]
  }

  measure: cnt_hub_update_after_checkout {
    group_label: "# Sessions"
    label: "# Sessions With Hub Update Message Viewed After Checkout Started"
    description: "# sessions in which user lost their cart due to location update after checkout was started"
    type: count
    filters: [hub_update_after_checkout: "yes"]
  }

  measure: cnt_checkout_after_hub_update {
    group_label: "# Sessions"
    label: "# Sessions With Checkout Started After Hub Update Message Viewed"
    description: "# sessions in which a checkout was started after the user lost their cart due to location update"
    type: count
    filters: [hub_update_after_checkout: "yes"]
  }

  measure: cnt_checkoutstarted_and_cart_lost {
    group_label: "# Sessions"
    label: "# Sessions With Checkout Started And Hub Update Message Viewed"
    description: "# sessions in which a checkout was started and the user lost their cart due to location update (one event did not necessarily occur before the other)"
    type: count
    filters: [checkout_started: ">0", hub_update_message: ">0"]
  }

  measure: cnt_hub_update_message {
    group_label: "# Sessions"
    label: "# Sessions With Hub Update Message Viewed"
    description: "# sessions with Hub Update Message Viewed event"
    type: count
    filters: [hub_update_message: ">0"]
  }

  measure: cnt_address_change_at_checkout {
    group_label: "# Sessions"
    label: "# Sessions With Address Change At Checkout Viewed"
    description: "# sessions with Address Change At Checkout Viewed event"
    type: count
    filters: [address_change_at_checkout: ">0"]
  }

  measure: cnt_add_to_cart {
    group_label: "# Sessions"
    label: "# Sessions With Add To Cart"
    description: "# sessions in which at least one Product Added To Cart event happened"
    type: count
    filters: [product_added_to_cart: ">0"]
  }

  measure: cnt_cart_viewed {
    group_label: "# Sessions"
    label: "# Sessions With Cart Viewed"
    description: "# sessions in which at least one Cart Viewed event happened"
    type: count
    filters: [cart_viewed: ">0"]
  }

  measure: cnt_payment_started {
    group_label: "# Sessions"
    label: "# Sessions With Payment Started"
    description: "# sessions in which at least one Payment Started event happened"
    type: count
    filters: [payment_started: ">0"]
  }

  measure: cnt_checkout_started {
    group_label: "# Sessions"
    label: "# Sessions With Checkout Started"
    description: "# sessions in which at least one Checkout Started event happened"
    type: count
    filters: [checkout_started: ">0"]
  }

  measure: cnt_voucher_attempt {
    group_label: "# Sessions"
    label: "# Sessions With Checkout Started and Voucher Attempted"
    description: "# sessions in which at least one Checkout Started event happened and attempted to apply a voucher at least once"
    type: count
    filters: [voucher_redemption_attempted: ">0"]
  }

  measure: cnt_voucher_attempt_voucher_success {
    group_label: "# Sessions"
    label: "# Sessions With Voucher Attempted and Succeeded"
    description: "# sessions in which at least one Voucher Attempt happened in checkout session and was successfull"
    type: count
    filters: [voucher_applied_succeeded: ">0"]
  }

  measure: cnt_voucher_attempt_voucher_failure {
    group_label: "# Sessions"
    label: "# Sessions With Voucher Attempted and Failedt"
    description: "# sessions in which at least one Voucher Attempt happened in checkout session and failed"
    type: count
    filters: [voucher_applied_failed: ">0"]
  }

  measure: cnt_voucher_failed_no_order {
    group_label: "# Sessions"
    label: "# Sessions With Voucher Failure and No order"
    description: "# sessions in which at least one Voucher Attempt happened in checkout session, failed, and thre was no order generated"
    type: count
    filters: [voucher_applied_failed: ">0", order_placed: "=0"]
  }

  measure: cnt_voucher_failed_yes_order {
    group_label: "# Sessions"
    label: "# Sessions With Voucher Failure but Placed Order"
    description: "# sessions in which at least one Voucher Attempt happened in checkout session, failed, but there was still at least one order placed during the session"
    type: count
    filters: [voucher_applied_failed: ">0", order_placed: ">0"]
  }

  measure: cnt_payment_failed {
    group_label: "# Sessions"
    label: "# Sessions With Payment Failed"
    description: "# sessions in which at least one Payment Failed event happened"
    type: count
    filters: [payment_failed: ">0"]
  }

  measure: cnt_payment_failed_no_order {
    group_label: "# Sessions"
    label: "# Sessions With Payment failed and no Order Placed"
    description: "# sessions in which at least one Payment Failed event happened and there was no order placed in the session"
    type: count
    filters: [payment_failed: ">0", order_placed: "=0"]
  }

  measure: cnt_order_placed {
    group_label: "# Sessions"
    label: "# Sessions With Order Placed"
    description: "# sessions in which there was at least one Order Placed"
    type: count
    filters: [order_placed: ">0"]
  }

  measure: cnt_account_registration_viewed {
    group_label: "# Sessions"
    label: "# Sessions With Registration Viewed"
    description: "# sessions in which there was at least one Registration Screen was viewed"
    type: count
    filters: [account_registration_viewed: ">0"]
  }

  measure: cnt_account_registration_succeeded {
    group_label: "# Sessions"
    label: "# Sessions With Registration Succeeded"
    description: "# sessions in which there was at least one Successfull Registration"
    type: count
    filters: [account_registration_succeeded: ">0"]
  }

  measure: cnt_account_registration_error {
    group_label: "# Sessions"
    label: "# Sessions With Registration Error"
    description: "# sessions in which there was at least one Registration Error"
    type: count
    filters: [account_registration_error_viewed: ">0"]
  }

  measure: cnt_account_login_clicked {
    group_label: "# Sessions"
    label: "# Sessions With Login Attempt"
    description: "# sessions in which there was at least one Login Click (attempt)"
    type: count
    filters: [account_login_clicked: ">0"]
  }

  measure: cnt_account_login_succeeded {
    group_label: "# Sessions"
    label: "# Sessions With Login Succeeded"
    description: "# sessions in which there was at least one Successfull Login"
    type: count
    filters: [account_login_succeeded: ">0"]
  }

  measure: cnt_account_login_viewed {
    group_label: "# Sessions"
    label: "# Sessions With Login Viewed"
    description: "# sessions in which there was at least one Login Screen View"
    type: count
    filters: [account_login_viewed: ">0"]
  }

  measure: cnt_account_login_error {
    group_label: "# Sessions"
    label: "# Sessions With Login Error"
    description: "# sessions in which there was at least one Login Error"
    type: count
    filters: [account_login_error_viewed: ">0"]
  }


  ######## Count Events Within Session ########

  dimension: product_added_to_cart {
    group_label: "Count Events"
    label: "# Product Added To Cart Events"
    description: "# Add To Cart events within a single session. For example, if the event occured twice in one session, number for that session id would be 2"
    type: number
    sql: ${TABLE}.product_added_to_cart ;;
  }

  dimension: cart_viewed {
    group_label: "Count Events"
    label: "# Cart Viewed Events"
    description: "# Cart Viewed events within a single session. For example, if the event occured twice in one session, number for that session id would be 2"
    type: number
    sql: ${TABLE}.cart_viewed ;;
  }

  dimension: checkout_started {
    group_label: "Count Events"
    label: "# Checkout Started Events"
    description: "# Checkout Started events within a single session. For example, if the event occured twice in one session, number for that session id would be 2"
    type: number
    sql: ${TABLE}.checkout_started ;;
  }

  dimension: payment_started {
    group_label: "Count Events"
    label: "# Payment Started Events"
    description: "# Payment Started events within a single session. For example, if the event occured twice in one session, number for that session id would be 2"
    type: number
    sql: ${TABLE}.payment_started ;;
  }

  dimension: payment_failed {
    group_label: "Count Events"
    label: "# Payment Failed Events"
    description: "# Payment Failed events within a single session. For example, if the event occured twice in one session, number for that session id would be 2"
    type: number
    sql: ${TABLE}.payment_failed ;;
  }

  dimension: order_placed {
    group_label: "Count Events"
    label: "# Order Placed Events"
    description: "# Order Placed events within a single session. For example, if the event occured twice in one session, number for that session id would be 2"
    type: number
    sql: ${TABLE}.order_placed ;;
  }

  dimension: address_change_at_checkout {
    group_label: "Count Events"
    label: "# Address Change At Checkout Events"
    description: "# Address Change At Checkout events within a single session. For example, if the event occured twice in one session, number for that session id would be 2"
    type: number
    sql: ${TABLE}.address_change_at_checkout ;;
  }

  dimension: hub_update_message {
    group_label: "Count Events"
    label: "# Hub Update Message Viewed Events"
    description: "# Hub Update Message Viewed events within a single session. For example, if the event occured twice in one session, number for that session id would be 2"
    type: number
    sql: ${TABLE}.hub_update_message ;;
  }

  dimension: account_registration_viewed {
    group_label: "Count Events"
    label: "# Account Registration Viewed Events"
    description: "# Account Registration Viewed events within a single session. For example, if the event occured twice in one session, number for that session id would be 2"
    type: number
    sql: ${TABLE}.account_registration_viewed ;;
  }

  dimension: account_registration_succeeded {
    group_label: "Count Events"
    label: "# Account Registration Succeeded Events"
    description: "# Account Registration Succeeded events within a single session. For example, if the event occured twice in one session, number for that session id would be 2"
    type: number
    sql: ${TABLE}.account_registration_succeeded ;;
  }

  dimension: account_registration_error_viewed {
    group_label: "Count Events"
    label: "# Account Registration Error Events"
    description: "# Account Registration Error Viewed events within a single session. For example, if the event occured twice in one session, number for that session id would be 2"
    type: number
    sql: ${TABLE}.account_registration_error_viewed ;;
  }

  dimension: account_login_clicked {
    group_label: "Count Events"
    label: "# Account Login Clicked Events"
    description: "# Account Login Clicked events within a single session. For example, if the event occured twice in one session, number for that session id would be 2"
    type: number
    sql: ${TABLE}.account_login_clicked ;;
  }

  dimension: account_login_viewed {
    group_label: "Count Events"
    label: "# Account Login Viewed Events"
    description: "# Account Login Viewed events within a single session. For example, if the event occured twice in one session, number for that session id would be 2"
    type: number
    sql: ${TABLE}.account_login_viewed ;;
  }

  dimension: account_login_succeeded {
    group_label: "Count Events"
    label: "# Account Login Succeeded Events"
    description: "# Account Login Succeeded events within a single session. For example, if the event occured twice in one session, number for that session id would be 2"
    type: number
    sql: ${TABLE}.account_login_succeeded ;;
  }

  dimension: account_login_error_viewed {
    group_label: "Count Events"
    label: "# Account Login Error Events"
    description: "# Account Login Error Viewed events within a single session. For example, if the event occured twice in one session, number for that session id would be 2"
    type: number
    sql: ${TABLE}.account_login_error_viewed ;;
  }

  dimension: voucher_applied_failed {
    group_label: "Count Events"
    label: "# Voucher Applied Failed Events"
    description: "# Voucher Redemption Failed events within a single session. For example, if the event occured twice in one session, number for that session id would be 2"
    type: number
    sql: ${TABLE}.voucher_applied_failed ;;
  }

  dimension: voucher_applied_succeeded {
    group_label: "Count Events"
    label: "# Voucher Applied Succeeded Events"
    description: "# Voucher Redemption Succeeded events within a single session. For example, if the event occured twice in one session, number for that session id would be 2"
    type: number
    sql: ${TABLE}.voucher_applied_succeeded ;;
  }

  dimension: voucher_redemption_attempted {
    group_label: "Count Events"
    label: "# Voucher Redemption Attempted Events"
    description: "# Voucher Redemption Attempted events within a single session. For example, if the event occured twice in one session, number for that session id would be 2"
    type: number
    sql: ${TABLE}.voucher_redemption_attempted ;;
  }


  ######## Session Attributes ########

  dimension: is_new_user {
    group_label: "Session Dimensions"
    description: "Whether it was the first session of the user (= new user)"
    type: yesno
    sql: ${TABLE}.is_new_user ;;
  }

  dimension: is_logged_in_session {
    group_label: "Session Dimensions"
    description: "Whether the user was logged in during the session"
    type: yesno
    sql: ${TABLE}.flag_session_logged_in ;;
  }

  dimension: delivery_pdt {
    group_label: "Session Dimensions"
    label: "Delivery PDT"
    description: "The delivery PDT in minutes associated with the selected address"
    type: number
    sql: ${TABLE}.delivery_pdt ;;
  }

  dimension: is_exposed_registration {
    group_label: "Session Dimensions"
    label: "Is Exposed To Registration Screen"
    description: "Whether the user saw the registation screen during the session"
    type: yesno
    sql: ${TABLE}.account_registration_viewed>0 ;;
  }

  # warning: this typing will make all null values equal to false. In this dimension that seems appropriate
  dimension: address_confirm_after_checkout {
    group_label: "Session Dimensions"
    label: "Has Late Address Selection"
    description: "Whether there was an address selected after checkout screen has been visited (late address selection) in the session"
    type: yesno
    sql: ${TABLE}.address_confirm_after_checkout ;;
  }

  # warning: this typing will make all null values equal to false. In this dimension that seems appropriate
  dimension: hub_update_after_checkout {
    group_label: "Session Dimensions"
    label: "Has Checkout Started and Hub Updated (Cart Lost)"
    description: "Whether the hub was updated (lost cart) after checkout screen has been visited in the session"
    type: yesno
    sql: ${TABLE}.hub_update_after_checkout ;;
  }

  # warning: this typing will make all null values equal to false. In this dimension that seems appropriate
  dimension: checkout_after_hub_update {
    group_label: "Session Dimensions"
    label: "Has Checkout Started After Hub Updated (Cart Lost)"
    description: "Whether checkout screen was visited after the user saw the hub updated (lost cart) message in the session"
    type: yesno
    sql: ${TABLE}.checkout_after_hub_update ;;
  }

  dimension: voucher_value {
    group_label: "Session Dimensions"
    description: "Voucher Value of the session if a voucher was applied"
    type: number
    sql: ${TABLE}.voucher_value ;;
  }

  dimension: voucher_code {
    group_label: "Session Dimensions"
    description: "Voucher Code of the session if a voucher was applied"
    type: string
    sql: ${TABLE}.voucher_code ;;
  }

  dimension: error_message {
    group_label: "Session Dimensions"
    label: "Voucher Error Msg"
    description: "Error message in voucher redemption in the session if a voucher redemption attempt was made"
    type: string
    sql: ${TABLE}.error_message ;;
  }

  dimension: error_login {
    group_label: "Session Dimensions"
    label: "Login Error Msg"
    description: "Error message if account login attempt was made in session and resulted in an error"
    type: string
    sql: ${TABLE}.error_login ;;
  }

  dimension: error_registration {
    group_label: "Session Dimensions"
    label: "Registration Error Msg"
    description: "Error message if account registration attempt was made in session and resulted in an error"
    type: string
    sql: ${TABLE}.error_registration ;;
  }


  ######## Percentages ########

  measure: orderplaced_per_paymentstarted_perc{
    group_label: "Percentages"
    label: "% Sessions Order Placed From Payment Started"
    description: "Number of sessions in which there was an Order Placed, compared to the number of sessions in which there was a Payment Started"
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
    group_label: "Percentages"
    label: "% Sessions Payment Failed From Payment Started"
    description: "Number of sessions in which there was a Payment Failed, compared to the number of sessions in which there was a Payment Started"
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
    group_label: "Percentages"
    label: "% Sessions Payment Failed And No Order From Payment Started"
    description: "Number of sessions in which there was a Payment Failed and no Order Placed, compared to the number of sessions in which there was a Payment Started"
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
    group_label: "Percentages"
    type: number
    label: "mCVR3"
    description: "#sessions in which there was a Checkout Started event happened, compared to the number of sessions in which there was a Product Added To Cart"
    value_format_name: percent_1
    sql: ${cnt_checkout_started}/NULLIF(${cnt_add_to_cart},0) ;;
  }

  measure: mcvr4 {
    group_label: "Percentages"
    type: number
    label: "mCVR4"
    description: "# sessions in which there was a Payment Started event happened, compared to the number of sessions in which there was a Checkout Started"
    value_format_name: percent_1
    sql: ${cnt_payment_started}/NULLIF(${cnt_checkout_started},0) ;;
  }

  measure: payment_success {
    # note: this is a duplicate from the one at the top of this list
    group_label: "Percentages"
    label: "% Payment Succeeded From Payment Started"
    type: number
    hidden: yes
    description: "Number of sessions in which there was an Order Placed, compared to the number of sessions in which there was a Payment Started"
    value_format_name: percent_1
    sql: ${cnt_order_placed}/NULLIF(${cnt_payment_started},0) ;;
  }


  ######## Dates ########

  dimension_group: session_start_at {
    group_label: "Date Dimensions"
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

  dimension_group: session_end_at {
    group_label: "Date Dimensions"
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
    sql: ${TABLE}.session_end_at ;;
  }

  measure: count {
    description: "Counts the number of occurrences of the selected dimension(s)"
    type: count
    drill_fields: [detail*]
  }

  measure: cnt_unique_anonymousid {
    label: "# Users"
    description: "# unique users based on Anonymous ID from Segment"
    type: count_distinct
    sql: ${anonymous_id};;
    value_format_name: decimal_0
  }

  measure: cnt_unique_sessionid {
    label: "Count Unique Sessions"
    description: "# Unique sessions"
    hidden: yes
    type: count_distinct
    sql: ${session_id};;
    value_format_name: decimal_0
  }

  set: detail {
    fields: [
      anonymous_id,
      context_app_version,
      context_device_type,
      session_id,
      session_start_at_date,
      session_end_at_date,
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
      is_new_user,
      is_exposed_registration

    ]
  }
}
