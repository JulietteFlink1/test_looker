view: daily_user_aggregates {
  sql_table_name: `flink-data-prod.reporting.daily_user_aggregates`
    ;;
  view_label: "Daily User Aggregates"

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~     Sets    ~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

  set: device_attributes {
    fields: [
      device_type,
      device_model,
      app_version,
      full_app_version,
      platform,
      is_device_android,
      is_device_ios,
      is_device_macintosh
    ]
  }

  set: location_attributes {
    fields: [
      hub_code,
      city,
      country_iso,
      delivery_lat,
      delivery_lng,
      delivery_pdt
    ]
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~     Dimensions    ~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

  ######## IDs ########

  dimension: daily_user_uuid {
    type: string
    hidden: yes
    primary_key: yes
    description: "A surrogate key representing a unique identifier per user per day. If the same users interacted with the app on two different days, they will get a different identifier."
    sql: ${TABLE}.daily_user_uuid ;;
  }
  dimension: user_uuid {
    group_label: "IDs"
    label: "User UUID"
    type: string
    description: "Unique user identifier: if user was logged in, the identifier is 'user_id' populated upon registration, else 'anonymous_id' populated by Segment"
    sql: ${TABLE}.anonymous_id ;;
  }
  dimension: order_uuids {
    group_label: "IDs"
    label: "Order UUIDs"
    type: string
    description: "An array of order_uuids as a concatenation of country_iso and order_id"
    sql: ${TABLE}.order_uuids ;;
  }

  ######## Dates ########

  dimension_group: event_date_at {
    group_label: "Date Dimensions"
    label: ""
    type: time
    datatype: date
    timeframes: [
      day_of_week,
      date,
      week,
      week_of_year,
      month,
      quarter
    ]
    sql: ${TABLE}.event_date ;;
  }
  dimension: event_date_granularity {
    group_label: "Date Dimensions"
    label: "Event Date (Dynamic)"
    label_from_parameter: timeframe_picker
    type: string # cannot have this as a time type. See this discussion: https://community.looker.com/lookml-5/dynamic-time-granularity-opinions-16675
    hidden:  yes
    sql:
      {% if timeframe_picker._parameter_value == 'Day' %}
        ${event_date_at_date}
      {% elsif timeframe_picker._parameter_value == 'Week' %}
        ${event_date_at_week}
      {% elsif timeframe_picker._parameter_value == 'Month' %}
        ${event_date_at_month}
      {% endif %};;
  }




  parameter: timeframe_picker {
    group_label: "Date Dimensions"
    label: "Event Date Granularity"
    type: unquoted
    allowed_value: { value: "Day" }
    allowed_value: { value: "Week" }
    allowed_value: { value: "Month" }
    default_value: "Day"
  }

  ######## Device Atributes ########

  dimension: device_type {
    group_label: "Device Dimensions"
    label: "Device Type"
    type: string
    description: "Device type is one of: ios, android, windows, macintosh, linux or other "
    sql: ${TABLE}.device_type ;;
  }
  dimension: device_model {
    group_label: "Device Dimensions"
    label: "Device Model"
    type: string
    description: "Model of the device"
    sql: ${TABLE}.device_model ;;
  }
  dimension: app_version_order {
    group_label: "Device Dimensions"
    label: "App Version order"
    type: number
    hidden: no
    description: "App release version middle digits for ordering"
    sql: safe_cast(split(app_version,".")[SAFE_OFFSET(1)] as INTEGER) ;;
  }
  dimension: app_version {
    group_label: "Device Dimensions"
    label: "App Version"
    type: string
    description: "App release version"
    order_by_field: app_version_order
    sql: ${TABLE}.app_version ;;
  }
  dimension: platform {
    group_label: "Device Dimensions"
    label: "Platform"
    type: string
    description: "Platform is either iOS, Android or Web"
    sql: ${TABLE}.platform ;;
  }
  dimension: is_device_android {
    group_label: "Device Dimensions"
    type: yesno
    sql: ${TABLE}.is_device_android ;;
  }
  dimension: is_device_ios {
    group_label: "Device Dimensions"
    type: yesno
    sql: ${TABLE}.is_device_ios ;;
  }
  dimension: is_device_windows {
    group_label: "Device Dimensions"
    type: yesno
    sql: ${TABLE}.is_device_windows ;;
  }
  dimension: is_device_macintosh {
    group_label: "Device Dimensions"
    type: yesno
    sql: ${TABLE}.is_device_macintosh ;;
  }
  dimension: full_app_version {
    group_label: "Device Dimensions"
    type: string
    description: "Concatenation of device_type and app_version"
    order_by_field: app_version_order
    sql: CASE WHEN ${TABLE}.device_type IN ('ios','android') THEN  (${TABLE}.device_type || '-' || ${TABLE}.app_version ) END ;;
  }

  ######## Location Atributes ########

  dimension: hub_code {
    group_label: "Location Dimensions"
    type: string
    sql: ${TABLE}.hub_code ;;
  }
  dimension: city {
    group_label: "Location Dimensions"
    type: string
    sql: ${TABLE}.city ;;
  }
  dimension: country_iso {
    group_label: "Location Dimensions"
    label: "Country ISO"
    type: string
    sql: ${TABLE}.country_iso ;;
  }
  dimension: delivery_lat {
    group_label: "Location Dimensions"
    label: "Delivery Latitude"
    type: number
    sql: ${TABLE}.delivery_lat ;;
  }
  dimension: delivery_lng {
    group_label: "Location Dimensions"
    label: "Delivery Longitude"
    type: number
    sql: ${TABLE}.delivery_lng ;;
  }
  dimension: delivery_pdt {
    group_label: "Location Dimensions"
    label: "Delivery PDT"
    description: "Delivery Promised Time Delivery"
    type: number
    sql: ${TABLE}.delivery_pdt ;;
  }

  ######## Event Flags ########
  # User Flags

  dimension: is_active_user {
    group_label: "Flags | User"
    type: yesno
    sql: ${TABLE}.is_active_user ;;
  }
  dimension: is_new_user {
    group_label: "Flags | User"
    type: yesno
    sql: ${TABLE}.is_new_user ;;
  }

  dimension: is_user_logged_in {
    group_label: "Flags | User"
    type: yesno
    sql: ${TABLE}.is_user_logged_in ;;
  }

  # Conversion Flags
  dimension: is_web_app_opened {
    group_label: "Flags | Conversion"
    type: yesno
    sql: ${TABLE}.is_web_app_opened ;;
  }
  dimension: is_address_set {
    group_label: "Flags | Conversion"
    type: yesno
    sql: ${TABLE}.is_address_set ;;
  }
  dimension: is_product_added_to_cart {
    group_label: "Flags | Conversion"
    type: yesno
    sql: ${TABLE}.is_product_added_to_cart ;;
  }
  dimension: is_cart_viewed {
    group_label: "Flags | Conversion"
    type: yesno
    sql: ${TABLE}.is_cart_viewed ;;
  }
  dimension: is_checkout_viewed {
    group_label: "Flags | Conversion"
    type: yesno
    sql: ${TABLE}.is_checkout_viewed ;;
  }
  dimension: is_payment_started {
    group_label: "Flags | Conversion"
    type: yesno
    sql: ${TABLE}.is_payment_started ;;
  }
  dimension: is_order_placed {
    group_label: "Flags | Conversion"
    type: yesno
    sql: ${TABLE}.is_order_placed ;;
  }

  # Add-to-Cart even flags

  dimension: is_category_placement {
    group_label: "Flags | Product Placement"
    hidden:  yes
    type: yesno
    sql: ${TABLE}.is_add_to_cart_from_category_placement ;;
  }
  dimension: is_search_placement {
    group_label: "Flags | Product Placement"
    hidden:  yes
    type: yesno
    sql: ${TABLE}.is_add_to_cart_from_search_placement ;;
  }
  dimension: is_cart_placement {
    group_label: "Flags | Product Placement"
    hidden:  yes
    type: yesno
    sql: ${TABLE}.is_add_to_cart_from_cart_placement ;;
  }
  dimension: is_pdp_placement {
    group_label: "Flags | Product Placement"
    hidden:  yes
    type: yesno
    sql: ${TABLE}.is_add_to_cart_from_pdp_placement ;;
  }
  dimension: is_favourites_placement {
    group_label: "Flags | Product Placement"
    hidden:  yes
    type: yesno
    sql: ${TABLE}.is_add_to_cart_from_favourites_placement ;;
  }
  dimension: is_swimlane_placement {
    group_label: "Flags | Product Placement"
    hidden:  yes
    type: yesno
    sql: ${TABLE}.is_add_to_cart_from_swimlane_placement ;;
  }
  dimension: is_last_bought_placement {
    group_label: "Flags | Product Placement"
    hidden:  yes
    type: yesno
    sql: ${TABLE}.is_add_to_cart_from_last_bought_placement ;;
  }
  dimension: is_recommendation_placement {
    group_label: "Flags | Product Placement"
    hidden:  yes
    type: yesno
    sql: ${TABLE}.is_add_to_cart_from_recommendation_placement ;;
  }
  dimension: is_recipes_placement {
    group_label: "Flags | Product Placement"
    hidden:  yes
    type: yesno
    sql: ${TABLE}.is_add_to_cart_from_recipes_placement ;;
  }
  dimension: is_collection_placement {
    group_label: "Flags | Product Placement"
    hidden:  yes
    type: yesno
    sql: ${TABLE}.is_add_to_cart_from_collection_placement ;;
  }
  dimension: is_undefined_placement {
    group_label: "Flags | Product Placement"
    hidden:  yes
    type: yesno
    sql: ${TABLE}.is_add_to_cart_from_undefined_placement ;;
  }

  # Product Flags

  dimension: is_product_removed_from_cart {
    group_label: "Flags | Event"
    type: yesno
    sql: ${TABLE}.is_product_removed_from_cart ;;
  }
  dimension: is_product_added_to_favourites {
    group_label: "Flags | Event"
    type: yesno
    sql: ${TABLE}.is_product_added_to_favourites ;;
  }
  dimension: is_product_details_viewed {
    group_label: "Flags | Event"
    type: yesno
    sql: ${TABLE}.is_product_details_viewed ;;
  }
  dimension: is_product_search_viewed {
    group_label: "Flags | Event"
    type: yesno
    sql: ${TABLE}.is_product_search_viewed ;;
  }
  dimension: is_product_search_executed {
    group_label: "Flags | Event"
    type: yesno
    sql: ${TABLE}.is_product_search_executed ;;
  }

  # Checkout Flags

  dimension: is_checkout_started {
    group_label: "Flags | Event"
    type: yesno
    sql: ${TABLE}.is_checkout_started ;;
  }
  dimension: is_payment_failed {
    group_label: "Flags | Event"
    type: yesno
    sql: ${TABLE}.is_payment_failed ;;
  }
  dimension: is_first_order_placed {
    group_label: "Flags | Event"
    type: yesno
    sql: ${TABLE}.is_first_order_placed ;;
  }
  dimension: is_voucher_redemption_attempted {
    group_label: "Flags | Event"
    type: yesno
    sql: ${TABLE}.is_voucher_redemption_attempted ;;
  }
  dimension: is_voucher_applied_succeeded {
    group_label: "Flags | Event"
    type: yesno
    sql: ${TABLE}.is_voucher_applied_succeeded ;;
  }
  dimension: is_voucher_applied_failed {
    group_label: "Flags | Event"
    type: yesno
    sql: ${TABLE}.is_voucher_applied_failed ;;
  }
  dimension: is_rider_tip_selected {
    group_label: "Flags | Event"
    type: yesno
    sql: ${TABLE}.is_rider_tip_selected ;;
  }

  # Generic Flags
  dimension: is_address_confirmed {
    group_label: "Flags | Event"
    type: yesno
    sql: ${TABLE}.is_address_confirmed ;;
  }
  dimension: is_account_login_succeeded {
    group_label: "Flags | Event"
    type: yesno
    sql: ${TABLE}.is_account_login_succeeded ;;
  }
  dimension: is_account_logout_clicked {
    group_label: "Flags | Event"
    type: yesno
    sql: ${TABLE}.is_account_logout_clicked ;;
  }
  dimension: is_account_registration_viewed {
    group_label: "Flags | Event"
    type: yesno
    sql: ${TABLE}.is_account_registration_viewed ;;
  }
  dimension: is_account_registration_succeeded {
    group_label: "Flags | Event"
    type: yesno
    sql: ${TABLE}.is_account_registration_succeeded ;;
  }
  dimension: is_sms_verification_request_viewed {
    group_label: "Flags | Event"
    type: yesno
    sql: ${TABLE}.is_sms_verification_request_viewed ;;
  }
  dimension: is_sms_verification_send_code_clicked {
    group_label: "Flags | Event"
    type: yesno
    sql: ${TABLE}.is_sms_verification_send_code_clicked ;;
  }
  dimension: is_sms_verification_viewed {
    group_label: "Flags | Event"
    type: yesno
    sql: ${TABLE}.is_sms_verification_viewed ;;
  }
  dimension: is_sms_verification_clicked {
    group_label: "Flags | Event"
    type: yesno
    sql: ${TABLE}.is_sms_verification_clicked ;;
  }
  dimension: is_sms_verification_confirmed {
    group_label: "Flags | Event"
    type: yesno
    sql: ${TABLE}.is_sms_verification_confirmed ;;
  }
  dimension: is_home_viewed {
    group_label: "Flags | Event"
    type: yesno
    sql: ${TABLE}.is_home_viewed ;;
  }
  dimension: is_category_selected {
    group_label: "Flags | Event"
    type: yesno
    sql: ${TABLE}.is_category_selected ;;
  }

  # ~~~~~~~~~~~ Hidden Dimensions ~~~~~~~~~~~~ #

  dimension: dim_total_amt_gmv_gross {
    type: number
    hidden: yes
    sql: ${TABLE}.total_amt_gmv_gross ;;
  }
  dimension: dim_aov_gross {
    type: number
    hidden: yes
    sql: ${TABLE}.aov_gross ;;
  }
  dimension: dim_total_rider_tip {
    type: number
    hidden: yes
    sql: ${TABLE}.total_rider_tip ;;
  }
  dimension: dim_total_discount_value {
    type: number
    hidden: yes
    sql: ${TABLE}.total_discount_value ;;
  }
  dimension: dim_number_of_web_app_opened {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_web_app_opened ;;
  }
  dimension: dim_number_of_address_confirmed {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_address_confirmed ;;
  }
  dimension: dim_number_of_home_viewed {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_home_viewed ;;
  }
  dimension: dim_number_of_product_added_to_cart {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_product_added_to_cart ;;
  }
  dimension: dim_number_of_product_removed_from_cart {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_product_removed_from_cart ;;
  }
  dimension: dim_number_of_product_added_to_favourites {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_product_added_to_favourites ;;
  }
  dimension: dim_number_of_product_details_viewed {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_product_details_viewed ;;
  }
  dimension: dim_number_of_product_search_viewed {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_product_search_viewed ;;
  }
  dimension: dim_number_of_cart_viewed {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_cart_viewed ;;
  }
  dimension: dim_number_of_checkout_viewed {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_checkout_viewed ;;
  }
  dimension: dim_number_of_checkout_started {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_checkout_started ;;
  }
  dimension: dim_number_of_payment_started {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_payment_started ;;
  }
  dimension: dim_number_of_payment_failed {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_payment_failed ;;
  }
  dimension: dim_number_of_first_order_placed {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_first_order_placed ;;
  }
  dimension: dim_number_of_order_placed {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_order_placed ;;
  }
  dimension: dim_number_of_voucher_redemption_attempted {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_voucher_redemption_attempted ;;
  }
  dimension: dim_number_of_voucher_applied_succeeded {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_voucher_applied_succeeded ;;
  }
  dimension: dim_number_of_voucher_applied_failed {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_voucher_applied_failed ;;
  }
  dimension: dim_number_of_rider_tip_selected {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_rider_tip_selected ;;
  }
  dimension: dim_number_of_account_login_succeeded {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_account_login_succeeded ;;
  }
  dimension: dim_number_of_account_logout_clicked {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_account_logout_clicked ;;
  }
  dimension: dim_number_of_categories_selected {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_categories_selected ;;
  }
  dimension: dim_number_of_product_search_executed {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_product_search_executed ;;
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~      Measures     ~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

  ### Monetary Metrics ###

  measure: total_amt_gmv_gross {
    group_label: "Monetary Values"
    label: "SUM GMV (Gross)"
    description: "Sum of Gross Merchandise Value of orders incl. fees and before deduction of discounts (incl. VAT)"
    type: sum
    hidden: no
    sql: ${dim_total_amt_gmv_gross} ;;
  }
  measure: avg_order_value_gross {
    group_label: "Monetary Values"
    label: "AVG Order Value (Gross)"
    description: "Average value of orders considering total gross order values. Includes fees (gross), before deducting discounts."
    type: average
    hidden: no
    sql: ${dim_total_amt_gmv_gross} ;;
    value_format_name: euro_accounting_2_precision
  }
  measure: total_rider_tip {
    group_label: "Monetary Values"
    label: "SUM Rider Tip"
    description: "Sum of rider tip amount considering orders where a tip was applied"
    type: sum
    hidden: no
    sql: ${dim_total_rider_tip} ;;
  }
  measure: avg_rider_tip {
    group_label: "Monetary Values"
    label: "AVG Rider Tip"
    description: "AVG Rider Tip Amount considering Orders where a tip was applied"
    type: average
    hidden: no
    sql: ${dim_total_rider_tip} ;;
    value_format_name: euro_accounting_2_precision
  }
  measure: total_discount_value {
    group_label: "Monetary Values"
    label: "SUM Discount Amount"
    description: "Sum of Discount amount applied on orders"
    type: sum
    hidden: no
    sql: ${dim_total_discount_value} ;;
  }
  measure: avg_discount_value {
    group_label: "Monetary Values"
    label: "AVG Discount Amount"
    description: "Average of discount amount applied on orders"
    type: average
    hidden: no
    sql: ${dim_total_discount_value} ;;
    value_format_name: euro_accounting_2_precision
  }

  # Conversion Events

  measure: number_of_address_confirmed {
    group_label: "Event Metrics"
    label: "# Address Confirmed"
    type: sum
    hidden: no
    sql: ${dim_number_of_address_confirmed} ;;
  }
  measure: number_of_product_added_to_cart {
    group_label: "Event Metrics"
    label: "# Product Added to Cart"
    type: sum
    hidden: no
    sql: ${dim_number_of_product_added_to_cart} ;;
  }
  measure: number_of_cart_viewed {
    group_label: "Event Metrics"
    label: "# Cart Viewed"
    type: sum
    hidden: no
    sql: ${dim_number_of_cart_viewed} ;;
  }
  measure: number_of_checkout_viewed {
    group_label: "Event Metrics"
    label: "# Checkout Viewed"
    type: sum
    hidden: no
    sql: ${dim_number_of_checkout_viewed} ;;
  }
  measure: number_of_payment_started {
    group_label: "Event Metrics"
    label: "# Payment Atarted"
    type: sum
    hidden: no
    sql: ${dim_number_of_payment_started};;
  }
  measure: number_of_order_placed {
    group_label: "Event Metrics"
    label: "# Order Placed"
    type: sum
    hidden: no
    sql: ${dim_number_of_order_placed};;
  }

  # Product Events
  measure: number_of_product_removed_from_cart {
    group_label: "Event Metrics"
    label: "# Product Removed from Cart"
    type: sum
    hidden: no
    sql: ${dim_number_of_product_removed_from_cart} ;;
  }
  measure: number_of_product_added_to_favourites {
    group_label: "Event Metrics"
    label: "# Product Added to Favourites"
    type: sum
    hidden: no
    sql: ${dim_number_of_product_added_to_favourites} ;;
  }
  measure: number_of_product_details_viewed {
    group_label: "Event Metrics"
    label: "# Product Details Viewed (PDP)"
    type: sum
    hidden: no
    sql: ${dim_number_of_product_details_viewed} ;;
  }
  measure: number_of_product_search_viewed {
    group_label: "Event Metrics"
    label: "# Product Search Viewed"
    type: sum
    hidden: no
    sql: ${dim_number_of_product_search_viewed} ;;
  }

  ## Checkout Events
  measure: number_of_checkout_started {
    group_label: "Event Metrics"
    label: "# Checkout Started"
    type: sum
    hidden: no
    sql: ${dim_number_of_checkout_started} ;;
    value_format_name: euro_accounting_0_precision
  }
  measure: number_of_payment_failed {
    group_label: "Event Metrics"
    label: "# Payment Failed"
    type: sum
    hidden: no
    sql: ${dim_number_of_payment_failed};;
  }
  measure: number_of_first_order_placed {
    group_label: "Event Metrics"
    label: "# First Order Placed"
    type: sum
    hidden: no
    sql: ${dim_number_of_first_order_placed};;
  }
  measure: number_of_rider_tip_selected {
    group_label: "Event Metrics"
    label: "# Rider Tip Selected"
    type: sum
    hidden: no
    sql: ${dim_number_of_rider_tip_selected};;
  }

  ## Voucher Event Metrics
  measure: number_of_voucher_redemption_attempted {
    group_label: "Event Metrics"
    label: "# Voucher Redemption Attempted"
    type: sum
    hidden: no
    sql: ${dim_number_of_voucher_redemption_attempted};;
  }
  measure: number_of_voucher_applied_succeeded {
    group_label: "Event Metrics"
    label: "# Voucher Applied Succeeded"
    type: sum
    hidden: no
    sql: ${dim_number_of_voucher_applied_succeeded};;
  }
  measure: number_of_voucher_applied_failed {
    group_label: "Event Metrics"
    label: "# Voucher Applied Failed"
    type: sum
    hidden: no
    sql: ${dim_number_of_voucher_applied_failed};;
  }
  measure: voucher_failure_rate {
    group_label: "Event Metrics"
    label: "% Voucher Failure Rate"
    type: number
    hidden: no
    sql: ${number_of_voucher_applied_failed}/${number_of_voucher_redemption_attempted};;
    value_format_name: percent_1
  }
  measure: voucher_success_rate {
    group_label: "Event Metrics"
    label: "% Voucher Success Rate"
    type: number
    hidden: no
    sql: ${number_of_voucher_applied_succeeded}/${number_of_voucher_redemption_attempted};;
    value_format_name: percent_1
  }
  measure: voucher_attempt_rate {
    group_label: "Event Metrics"
    label: "% Voucher Attempt Rate"
    type: number
    hidden: no
    sql: ${number_of_voucher_redemption_attempted}/${number_of_checkout_viewed};;
    value_format_name: percent_1
  }

  # Other Event Metrics
  measure: number_of_account_login_succeeded {
    group_label: "Event Metrics"
    label: "# Accounts Logged-in"
    type: sum
    hidden: no
    sql: ${dim_number_of_account_login_succeeded};;
  }
  measure: number_of_account_logout_clicked {
    group_label: "Event Metrics"
    label:  "# Accounts Logged-out"
    type: sum
    hidden: no
    sql: ${dim_number_of_account_logout_clicked};;
  }
  measure: number_of_categories_selected {
    group_label: "Event Metrics"
    label: "# Category Selected"
    type: sum
    hidden: no
    sql: ${dim_number_of_categories_selected};;
  }
  measure: number_of_home_viewed {
    group_label: "Event Metrics"
    label: "# Home Viewed"
    type: sum
    hidden: no
    sql: ${dim_number_of_home_viewed} ;;
  }
  measure: number_of_search_executed {
    group_label: "Event Metrics"
    label: "# Product Search Executed"
    type: sum
    hidden: no
    sql: ${dim_number_of_product_search_executed} ;;
  }

  # Basic counts
  measure: daily_user_events {
    label: "Count "
    type: count_distinct
    sql: ${daily_user_uuid} ;;
  }
  measure: unique_users {
    group_label: "User Metrics"
    label: "# Unique Users"
    description: "Number of unique users"
    type: count_distinct
    sql: ${user_uuid} ;;
  }
  measure: active_users {
    group_label: "User Metrics"
    label: "# Active Users"
    description: "Active user generated at least 2 various events when browsing Flink app/web"
    type: count_distinct
    sql: ${user_uuid} ;;
    filters: [is_active_user: "yes"]
  }

  #### User Metrics  ####

  measure: users_with_order {
    group_label: "User Metrics"
    label: "# Users with Orders"
    description: "Number of users with at least one order"
    type: count_distinct
    sql: ${user_uuid} ;;
    filters: [is_order_placed: "yes"]
  }
  measure: users_with_address {
    group_label: "User Metrics"
    label: "# Users with Address Set"
    description: "Number of users with at least one address set"
    type: count_distinct
    sql: ${user_uuid} ;;
    filters: [is_address_set: "yes"]
  }
  measure: users_with_add_to_cart {
    group_label: "User Metrics"
    label: "# Users with Add-to-Cart"
    description: "Number of users who at least one product added to cart"
    type: count_distinct
    sql: ${user_uuid} ;;
    filters: [is_product_added_to_cart: "yes"]
  }
  measure: users_with_cart_viewed {
    group_label: "User Metrics"
    label: "# Users with Cart Viewed"
    description: "Number of users who viewed their cart at least once"
    type: count_distinct
    sql: ${user_uuid} ;;
    filters: [is_cart_viewed: "yes"]
  }
  measure: users_with_checkout_viewed {
    group_label: "User Metrics"
    label: "# Users with Checkout Viewed"
    description: "Number of users who viewed checkout at least once"
    type: count_distinct
    sql: ${user_uuid} ;;
    filters: [is_checkout_viewed: "yes"]
  }
  measure: users_with_payment_started {
    group_label: "User Metrics"
    label: "# Users with Payment Started"
    description: "Number of users who started the payment process at least once"
    type: count_distinct
    sql: ${user_uuid} ;;
    filters: [is_payment_started: "yes"]
  }
  measure: users_with_home_viewed {
    group_label: "User Metrics"
    label: "# Users with Home Viewed"
    description: "Number of users who viewed home at least once"
    type: count_distinct
    sql: ${user_uuid} ;;
    filters: [is_home_viewed: "yes"]
  }
  measure: users_with_category_selected {
    group_label: "User Metrics"
    label: "# Users with Category Selected"
    description: "Number of users who clicked on a category at least once"
    type: count_distinct
    sql: ${user_uuid} ;;
    filters: [is_category_selected: "yes"]
  }
  measure: users_with_product_search {
    group_label: "User Metrics"
    label: "# Users with Executed Search"
    description: "Number of users with started the payment process at least once"
    type: count_distinct
    sql: ${user_uuid} ;;
    filters: [is_product_search_executed: "yes"]
  }
  measure: users_with_product_search_viewed {
    group_label: "User Metrics"
    label: "# Users with Viewing Search"
    description: "Number of users with started the payment process at least once"
    type: count_distinct
    sql: ${user_uuid} ;;
    filters: [is_product_search_viewed: "yes"]
  }
  measure: users_with_product_details_viewed {
    group_label: "User Metrics"
    label: "# Users with PDP"
    description: "Number of users who viwed (PDP) a product at least once"
    type: count_distinct
    sql: ${user_uuid} ;;
    filters: [is_product_details_viewed: "yes"]
  }
  #### Conversions ###

  measure: cvr {
    group_label: "Conversions - All Active Users (%)"
    label: "CVR"
    type: number
    description: "# users with at least one order / # active users"
    value_format_name: percent_1
    sql: ${users_with_order} / nullif(${active_users},0) ;;
  }
  measure: mcvr_1 {
    group_label: "Conversions - All Active Users (%)"
    label: "mCVR1 [AAU]"
    type: number
    description: "# users with an address (either selected in previous session or in current session), compared to the total number of active users"
    value_format_name: percent_1
    sql: ${users_with_address} / nullif(${active_users},0);;
  }
  measure: mcvr_2_add_to_cart {
    group_label: "Conversions - Subsequent Steps (%)"
    label: "mCVR2 - Add-To-Cart"
    type: number
    description: "# users with add-to-cart, compared to the total number of users with an address"
    value_format_name: percent_1
    sql: ${users_with_add_to_cart} / nullif(${users_with_address},0);;
  }
  measure: mcvr_2_add_to_cart_all_active_users {
    group_label: "Conversions - All Active Users (%)"
    label: "mCVR2 - Add-To-Cart [AAU]"
    type: number
    description: "# users with add-to-cart, compared to # of all active users"
    value_format_name: percent_1
    sql: ${users_with_add_to_cart} / nullif(${active_users},0);;
  }
  measure: mcvr_2_cart_viewed {
    group_label: "Conversions - Subsequent Steps (%)"
    label: "mCVR2 - Cart Viewed"
    type: number
    description: "# users with cart-viewed, compared to the total number of users with add to cart"
    value_format_name: percent_1
    sql: ${users_with_cart_viewed} / nullif(${users_with_add_to_cart},0);;
  }
  measure: mcvr_2_cart_viewed_all_active_users {
    group_label: "Conversions - All Active Users (%)"
    label: "mCVR2 - Cart Viewed [AAU]"
    type: number
    description: "# users with cart-viewed, compared to # of all active users"
    value_format_name: percent_1
    sql: ${users_with_cart_viewed} / nullif(${active_users},0);;
  }
  measure: mcvr_3_old {
    group_label: "Conversions - Subsequent Steps (%)"
    label: "mCVR3 [old]"
    type: number
    description: "# users with checkout started, compared to users with add-to-cart"
    value_format_name: percent_1
    sql: ${users_with_checkout_viewed} / nullif(${users_with_add_to_cart},0);;
  }
  measure: mcvr_3 {
    group_label: "Conversions - Subsequent Steps (%)"
    label: "mCVR3 [new] "
    type: number
    description: "# users with checkout started, compared to users with cart viewed"
    value_format_name: percent_1
    sql: ${users_with_checkout_viewed} / nullif(${users_with_cart_viewed},0);;
  }
  measure: mcvr_3_all_active_users {
    group_label: "Conversions - All Active Users (%)"
    label: "mCVR3 [AAU]"
    type: number
    description: "# users with checkout started, compared to # of all active users"
    value_format_name: percent_1
    sql: ${users_with_checkout_viewed} / nullif(${active_users},0);;
  }
  measure: mcvr_4 {
    group_label: "Conversions - Subsequent Steps (%)"
    label: "mCVR4"
    type: number
    description: "# users with payment started, compared to users with checkout started"
    value_format_name: percent_1
    sql: ${users_with_payment_started} / nullif(${users_with_checkout_viewed},0);;
  }
  measure: mcvr_4_all_active_users {
    group_label: "Conversions - All Active Users (%)"
    label: "mCVR4 [AAU]"
    type: number
    description: "# users with payment started, compared to users with checkout started"
    value_format_name: percent_1
    sql: ${users_with_payment_started} / nullif(${active_users},0);;
  }
  measure: auth_rate {
    group_label: "Conversions - Subsequent Steps (%)"
    label: "Authentication Rate"
    type: number
    description: "# user with at least one order, compared to users with payment started"
    value_format_name: percent_1
    sql: ${users_with_order} / nullif(${users_with_payment_started},0);;
  }



  #### Abandonment Rates ###

  measure: cart_abandonment_rate {
    group_label: "Funnel Abandonment Rates (%)"
    label: "Cart Abandonment Rate"
    type: number
    description: "% users that viewed their cart but did not proceed to checkout "
    value_format_name: percent_1
    sql: 1 -  ${users_with_checkout_viewed} / nullif(${users_with_cart_viewed},0);;
  }
  measure: checkout_abandonment_rate {
    group_label: "Funnel Abandonment Rates (%)"
    label: "Checkout Abandonment Rate"
    type: number
    description: "% users that viewed checkout but did not start the payment process"
    value_format_name: percent_1
    sql: 1 -  ${users_with_payment_started} / nullif(${users_with_checkout_viewed},0);;
  }


  ### Conversions mcvr2 from product placement ###

  measure: mcvr_2_category {
    group_label: "Conversions | Product Placement mCVR2 (%)"
    label: "Category mCVR2"
    type: number
    description: "# users with add-to-cart from Category, compared to the total number of users with an address"
    value_format_name: percent_1
    sql: ${users_with_category_atc} / nullif(${users_with_address},0);;
  }
  measure: mcvr_2_search {
    group_label: "Conversions | Product Placement mCVR2 (%)"
    label: "Search mCVR2"
    type: number
    description: "# users with add-to-cart from Search, compared to the total number of users with an address"
    value_format_name: percent_1
    sql: ${users_with_search_atc} / nullif(${users_with_address},0);;
  }
  measure: mcvr_2_cart {
    group_label: "Conversions | Product Placement mCVR2 (%)"
    label: "Cart mCVR2"
    type: number
    description: "# users with add-to-cart from Cart, compared to the total number of users with an address"
    value_format_name: percent_1
    sql: ${users_with_cart_atc} / nullif(${users_with_address},0);;
  }
  measure: mcvr_2_favourites {
    group_label: "Conversions | Product Placement mCVR2 (%)"
    label: "Favourites mCVR2"
    type: number
    description: "# users with add-to-cart from Favourites, compared to the total number of users with an address"
    value_format_name: percent_1
    sql: ${users_with_favourites_atc} / nullif(${users_with_address},0);;
  }
  measure: mcvr_2_pdp {
    group_label: "Conversions | Product Placement mCVR2 (%)"
    label: "PDP mCVR2"
    type: number
    description: "# users with add-to-cart from PDP (Product Details Viewed), compared to the total number of users with an address"
    value_format_name: percent_1
    sql: ${users_with_pdp_atc} / nullif(${users_with_address},0);;
  }
  measure: mcvr_2_swimlane {
    group_label: "Conversions | Product Placement mCVR2 (%)"
    label: "Swimlane mCVR2"
    type: number
    description: "# users with add-to-cart from Swimlane, compared to the total number of users with an address"
    value_format_name: percent_1
    sql: ${users_with_swimlane_atc} / nullif(${users_with_address},0);;
  }
  measure: mcvr_2_last_bought {
    group_label: "Conversions | Product Placement mCVR2 (%)"
    label: "Last Bought mCVR2"
    type: number
    description: "# users with add-to-cart from Last Bought, compared to the total number of users with an address"
    value_format_name: percent_1
    sql: ${users_with_last_bought_atc} / nullif(${users_with_address},0);;
  }
  measure: mcvr_2_recommendation {
    group_label: "Conversions | Product Placement mCVR2 (%)"
    label: "Recommendation mCVR2"
    type: number
    hidden: no
    description: "# users with add-to-cart from Recommendation, compared to the total number of users with an address"
    value_format_name: percent_1
    sql: ${users_with_recommendation_atc} / nullif(${users_with_address},0);;
  }
  measure: mcvr_2_recipes {
    group_label: "Conversions | Product Placement mCVR2 (%)"
    label: "Recipes mCVR2"
    type: number
    hidden: no
    description: "# users with add-to-cart from Recipes, compared to the total number of users with an address"
    value_format_name: percent_1
    sql: ${users_with_recipes_atc} / nullif(${users_with_address},0);;
  }
  measure: mcvr_2_collection {
    group_label: "Conversions | Product Placement mCVR2 (%)"
    label: "Collection mCVR2"
    type: number
    hidden: no
    description: "# users with add-to-cart from Collection, compared to the total number of users with an address"
    value_format_name: percent_1
    sql: ${users_with_collection_atc} / nullif(${users_with_address},0);;
  }

  # ======= User Authentication & SMS Verification Metrics ======= #

  ###### Total aggregates ######

  ##### User Auth & SMS Verification Rates ######

  measure: all_users_with_account_registration_viewed {
    group_label: "User And Account Verification Metrics"
    label: "# All Users with Account Registration Viewed"
    description: "Number of users viewing account registration"
    type: count_distinct
    sql: ${user_uuid} ;;
    filters: [is_account_registration_viewed: "yes"]
  }

  measure: all_users_with_account_registration_success {
    group_label: "User And Account Verification Metrics"
    label: "# All Users with Account Registration Success"
    description: "Number of new users successfully registrating account"
    type: count_distinct
    sql: ${user_uuid} ;;
    filters: [is_account_registration_succeeded: "yes"]
  }

  measure: all_users_with_sms_verification_request_viewed {
    group_label: "User And Account Verification Metrics"
    label: "# All Users with SMS Veri Request Viewed"
    description: "Number of users viewing sms verification request"
    type: count_distinct
    sql: ${user_uuid} ;;
    filters: [is_sms_verification_request_viewed: "yes"]
  }
  measure: all_users_with_sms_verification_send_code_clicked {
    hidden: no
    group_label: "User And Account Verification Metrics"
    label: "# All Users with Clicking Send Code for SMS Verification"
    description: "Number of users clicking send code for SMS verification"
    type: count_distinct
    sql: ${user_uuid} ;;
    filters: [is_sms_verification_send_code_clicked: "yes"]
  }
  measure: all_users_with_sms_verification_viewed {
    hidden: no
    group_label: "User And Account Verification Metrics"
    label: "# All Users with Viewing SMS Verification"
    description: "Number of users viewing SMS verification"
    type: count_distinct
    sql: ${user_uuid} ;;
    filters: [is_sms_verification_viewed: "yes"]
  }
  measure: all_users_with_sms_verification_clicked {
    hidden: no
    group_label: "User And Account Verification Metrics"
    label: "# All Users with Clicking SMS Verification"
    description: "Number of users clicking SMS verification"
    type: count_distinct
    sql: ${user_uuid} ;;
    filters: [is_sms_verification_clicked: "yes"]
  }
  measure: all_users_with_sms_verification_confirmed {
    group_label: "User And Account Verification Metrics"
    label: "# All Users with Successful SMS Verification"
    description: "Number of users successfully verifying their account through SMS"
    type: count_distinct
    sql: ${user_uuid} ;;
    filters: [is_sms_verification_confirmed: "yes"]
  }

  measure: all_users_with_sms_verification_confirmed_and_order{
    hidden:  no
    group_label: "User And Account Verification Metrics"
    label: "# All Users with Successful SMS Verification"
    description: "Number of users successfully verifying their account through SMS"
    type: count_distinct
    sql: ${user_uuid} ;;
    filters: [is_sms_verification_confirmed: "yes", is_order_placed: "yes"]
  }

  measure: user_sms_verification_rate_all_users{
    group_label: "User And Account Verification Metrics"
    label: "SMS Verification - All Users(%)"
    type: number
    hidden: no
    description: "# Users with Successful SMS Verification, compared to the total number of all users with SMS verification requested"
    value_format_name: percent_1
    sql: ${all_users_with_sms_verification_confirmed} / nullif(${all_users_with_sms_verification_request_viewed},0);;
  }

  measure: order_rate_after_sms_vrification{
    group_label: "User And Account Verification Metrics"
    label: "Order Placed after SMS Verification (%)"
    type: number
    hidden: no
    description: "# Users with Successful Order out of successfull SMS Verification"
    value_format_name: percent_1
    sql: ${all_users_with_sms_verification_confirmed_and_order} / nullif(${all_users_with_sms_verification_confirmed},0);;
  }

  measure: order_rate_after_sms_vrification_new{
    group_label: "User And Account Verification Metrics"
    label: "New Users Order Placed after SMS Verification (%)"
    type: number
    hidden: no
    description: "# New Users with Successful Order out of successfull SMS Verification"
    value_format_name: percent_1
    sql: ${new_users_with_sms_verification_confirmed_and_order} / nullif(${new_users_with_sms_verification_confirmed},0);;
  }

  measure: user_authentication_rate_all_users {
    group_label: "User And Account Verification Metrics"
    label: "User Authentication - All Users (%)"
    type: number
    hidden: no
    description: "# users with Successfully Registered Account, compared to the total number of users viewing account registration page"
    value_format_name: percent_1
    sql: ${all_users_with_account_registration_success} / nullif(${all_users_with_account_registration_viewed},0);;
  }


  # ========= HIDDEN ========== #

  ### Hidden supporting metrics: SMS Verification Flow ###

  measure: new_users_with_sms_verification_request_viewed {
    hidden: yes
    group_label: "User And Account Verification Metrics"
    label: "# New Users with SMS Veri Request Viewed "
    type: count_distinct
    sql: ${user_uuid} ;;
    filters: [is_account_registration_succeeded: "yes" , is_sms_verification_request_viewed: "yes"]
  }

  measure: new_users_with_sms_verification_confirmed {
    hidden: yes
    group_label: "User And Account Verification Metrics"
    label: "# New Users with Successful SMS Verification"
    description: "Number of users successfully verifying their account through SMS"
    type: count_distinct
    sql: ${user_uuid} ;;
    filters: [is_account_registration_succeeded: "yes", is_sms_verification_confirmed: "yes"]
  }

  measure: new_users_with_sms_verification_confirmed_and_order{
    hidden: yes
    group_label: "User And Account Verification Metrics"
    label: "# New Users with Successful SMS Verification and Order"
    description: "Number of New users successfully verifying their account through SMS"
    type: count_distinct
    sql: ${user_uuid} ;;
    filters: [is_account_registration_succeeded: "yes", is_sms_verification_confirmed: "yes", is_order_placed: "yes"]
  }

  measure: new_sms_verification_rate_all{
    group_label: "User And Account Verification Metrics"
    label: "SMS Verification - New Users(%)"
    type: number
    hidden: yes
    description: "# New Users with Successful SMS Verification, compared to the total number of all users with SMS verification requested"
    value_format_name: percent_1
    sql: ${new_users_with_sms_verification_confirmed} / nullif(${new_users_with_sms_verification_request_viewed},0);;
  }

  measure: existing_loggedin_users_with_sms_verification_request_viewed {
    hidden: yes
    group_label: "User And Account Verification Metrics"
    label: "# Existing LoggedIn Users with SMS Veri Request Viewed "
    type: count_distinct
    sql: ${user_uuid} ;;
    filters: [is_account_registration_viewed: "no" , is_sms_verification_request_viewed: "yes"]
  }

  measure: existing_loggedin_users_with_sms_verification_confirmed {
    hidden: yes
    group_label: "User And Account Verification Metrics"
    label: "# Existing LoggedIn Users with Successful SMS Verification"
    description: "Number of Existing LoggedIn users successfully verifying their account through SMS"
    type: count_distinct
    sql: ${user_uuid} ;;
    filters: [is_account_registration_viewed: "no", is_sms_verification_confirmed: "yes"]
  }

  measure: existing_loggedin_users_with_sms_verification_confirmed_and_order{
    hidden: yes
    group_label: "User And Account Verification Metrics"
    label: "# Existing LoggedIn Users with Successful SMS Verification and Order"
    description: "Number of Existing LoggedIn users successfully verifying their account through SMS and placed order"
    type: count_distinct
    sql: ${user_uuid} ;;
    filters: [is_account_registration_viewed: "no", is_sms_verification_confirmed: "yes", is_order_placed: "yes"]
  }

  measure: existing_loggedin_sms_verification_rate{
    group_label: "User And Account Verification Metrics"
    label: "SMS Verification - Existing LoggedIn Users(%)"
    type: number
    hidden: yes
    description: "# Existing LoggedIn Users with Successful SMS Verification, compared to the total number of all users with SMS verification requested"
    value_format_name: percent_1
    sql: ${existing_loggedin_users_with_sms_verification_confirmed} / nullif(${existing_loggedin_users_with_sms_verification_request_viewed},0);;
  }


  measure: existing_loggedout_users_with_sms_verification_request_viewed {
    hidden: yes
    group_label: "User And Account Verification Metrics"
    label: "# Existing LoggedOut Users with SMS Veri Request Viewed "
    type: count_distinct
    sql: ${user_uuid} ;;
    filters: [is_account_login_succeeded: "yes" , is_sms_verification_request_viewed: "yes"]
  }

  measure: existing_loggedout_users_with_sms_verification_confirmed {
    hidden: yes
    group_label: "User And Account Verification Metrics"
    label: "# Existing LoggedOut Users with Successful SMS Verification"
    description: "Number of Existing LoggedIn users successfully verifying their account through SMS"
    type: count_distinct
    sql: ${user_uuid} ;;
    filters: [is_account_login_succeeded: "yes", is_sms_verification_confirmed: "yes"]
  }

  measure: existing_loggedout_users_with_sms_verification_confirmed_and_order{
    hidden: yes
    group_label: "User And Account Verification Metrics"
    label: "# Existing LoggedOut Users with Successful SMS Verification and Order"
    description: "Number of Existing LoggedIn users successfully verifying their account through SMS and placed order"
    type: count_distinct
    sql: ${user_uuid} ;;
    filters: [is_account_login_succeeded: "yes", is_sms_verification_confirmed: "yes", is_order_placed: "yes"]
  }

  measure: existing_loggedout_sms_verification_rate{
    group_label: "User And Account Verification Metrics"
    label: "SMS Verification - Existing LoggedOut Users(%)"
    type: number
    hidden: yes
    description: "# Existing LoggedOut Users with Successful SMS Verification, compared to the total number of all users with SMS verification requested"
    value_format_name: percent_1
    sql: ${existing_loggedout_users_with_sms_verification_confirmed} / nullif(${existing_loggedout_users_with_sms_verification_request_viewed},0);;
  }



  ### Hidden supporting metrics: Users with Add-to-Cart Product Placement ###

  measure: users_with_category_atc {
    type: count_distinct
    hidden:  yes
    sql: ${user_uuid} ;;
    filters: [is_category_placement: "yes"]
  }
  measure: users_with_search_atc {
    type: count_distinct
    hidden:  yes
    sql: ${user_uuid} ;;
    filters: [is_search_placement: "yes"]
  }
  measure: users_with_cart_atc {
    type: count_distinct
    hidden:  yes
    sql: ${user_uuid} ;;
    filters: [is_cart_placement: "yes"]
  }
  measure: users_with_favourites_atc {
    type: count_distinct
    hidden:  yes
    sql: ${user_uuid} ;;
    filters: [is_favourites_placement: "yes"]
  }
  measure: users_with_pdp_atc {
    type: count_distinct
    hidden:  yes
    sql: ${user_uuid} ;;
    filters: [is_pdp_placement: "yes"]
  }
  measure: users_with_swimlane_atc {
    type: count_distinct
    hidden:  yes
    sql: ${user_uuid} ;;
    filters: [is_swimlane_placement: "yes"]
  }
  measure: users_with_last_bought_atc {
    type: count_distinct
    hidden:  yes
    sql: ${user_uuid} ;;
    filters: [is_last_bought_placement: "yes"]
  }
  measure: users_with_recommendation_atc {
    type: count_distinct
    hidden:  yes
    sql: ${user_uuid} ;;
    filters: [is_recommendation_placement: "yes"]
  }
  measure: users_with_recipes_atc {
    type: count_distinct
    hidden:  no
    sql: ${user_uuid} ;;
    filters: [is_recipes_placement: "yes"]
  }
  measure: users_with_collection_atc {
    type: count_distinct
    hidden:  yes
    sql: ${user_uuid} ;;
    filters: [is_collection_placement: "yes"]
  }
  measure: users_with_undefined_atc {
    type: count_distinct
    hidden:  yes
    sql: ${user_uuid} ;;
    filters: [is_undefined_placement: "yes"]
  }

  ### These measures reformat cnt so it shows % in the label as well -> for the conversion funnel visualization ###

  measure: perc_of_total_has_address {
    hidden: yes
    type: number
    sql: ${users_with_address}/${active_users} ;;
    value_format_name: percent_1
  }
  measure: total_has_address {
    hidden: yes
    type: number
    sql: ${users_with_address} ;;
    html: {{ rendered_value }} ({{ perc_of_total_has_address._rendered_value }} % of total) ;;
  }
  measure: perc_of_total_patc {
    hidden: yes
    type: number
    sql: ${users_with_add_to_cart}/${active_users} ;;
    value_format_name: percent_1
  }
  measure: total_has_patc {
    hidden: yes
    type: number
    sql: ${users_with_add_to_cart} ;;
    html: {{ rendered_value }} ({{ perc_of_total_patc._rendered_value }} % of total) ;;
  }
  measure: perc_of_total_checkout {
    hidden: yes
    type: number
    sql: ${users_with_checkout_viewed}/${active_users} ;;
    value_format_name: percent_1
  }
  measure: total_has_checkout {
    hidden: yes
    type: number
    sql: ${users_with_checkout_viewed} ;;
    html: {{ rendered_value }} ({{ perc_of_total_checkout._rendered_value }} % of total) ;;
  }
  measure: perc_of_total_payment {
    hidden: yes
    type: number
    sql: ${users_with_payment_started}/${active_users} ;;
    value_format_name: percent_1
  }
  measure: total_has_payment {
    hidden: yes
    type: number
    sql: ${users_with_payment_started} ;;
    html: {{ rendered_value }} ({{ perc_of_total_payment._rendered_value }} % of total) ;;
  }
  measure: perc_of_total_order {
    hidden: yes
    type: number
    sql: ${users_with_order}/${active_users} ;;
    value_format_name: percent_1
  }
  measure: total_has_order {
    hidden: yes
    type: number
    sql: ${users_with_order} ;;
    html: {{ rendered_value }} ({{ perc_of_total_order._rendered_value }} % of total) ;;
  }
}
