view: daily_user_aggregates {
    sql_table_name: `flink-data-prod.curated.daily_user_aggregates`
     ;;
  view_label: "Daily User Aggregates"

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
      sql: ${TABLE}.user_uuid ;;
    }
    dimension: anonymous_ids {
      group_label: "IDs"
      label: "Anonymous IDs"
      type: string
      description: "An array of anonymous IDs populated by Segment as a user identifier"
      sql: ${TABLE}.anonymous_ids ;;
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
        month
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
      allowed_value: { value: "Hour" }
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
    dimension: app_version {
      group_label: "Device Dimensions"
      label: "App Version"
      type: string
      description: "App release version"
      sql: ${TABLE}.app_version ;;
    }
    dimension: platform {
      group_label: "Device Dimensions"
      label: "Platform"
      type: string
      description: "Platform is either App or Web"
      sql: ${TABLE}.platform ;;
    }
    dimension: is_platform_web {
      group_label: "Device Dimensions"
      type: yesno
      sql: ${TABLE}.is_platform_web ;;
    }
    dimension: is_platform_app {
      group_label: "Device Dimensions"
      type: yesno
      sql: ${TABLE}.is_platform_app ;;
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

    ######## Event Flags ########
    # Conversion Flags

    dimension: is_active_user {
      group_label: "Flags | Conversion"
      type: yesno
      sql: ${TABLE}.is_active_user ;;
    }
    dimension: is_new_user {
      group_label: "Flags | Conversion"
      type: yesno
      sql: ${TABLE}.is_new_user ;;
    }

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

    # Product Flags

    dimension: is_product_removed_from_cart {
      group_label: "Flags | Product"
      type: yesno
      sql: ${TABLE}.is_product_removed_from_cart ;;
    }
    dimension: is_product_added_to_favourites {
      group_label: "Flags | Product"
      type: yesno
      sql: ${TABLE}.is_product_added_to_favourites ;;
    }
    dimension: is_product_details_viewed {
      group_label: "Flags | Product"
      type: yesno
      sql: ${TABLE}.is_product_details_viewed ;;
    }
    dimension: is_product_search_viewed {
      group_label: "Flags | Product"
      type: yesno
      sql: ${TABLE}.is_product_search_viewed ;;
    }

    # Checkout Flags

    dimension: is_checkout_started {
      group_label: "Flags | Checkout"
      type: yesno
      sql: ${TABLE}.is_checkout_started ;;
    }
    dimension: is_payment_failed {
      group_label: "Flags | Checkout"
      type: yesno
      sql: ${TABLE}.is_payment_failed ;;
    }
    dimension: is_first_order_placed {
      group_label: "Flags | Checkout"
      type: yesno
      sql: ${TABLE}.is_first_order_placed ;;
    }
    dimension: is_voucher_redemption_attempted {
      group_label: "Flags | Checkout"
      type: yesno
      sql: ${TABLE}.is_voucher_redemption_attempted ;;
    }
    dimension: is_voucher_applied_succeeded {
      group_label: "Flags | Checkout"
      type: yesno
      sql: ${TABLE}.is_voucher_applied_succeeded ;;
    }
    dimension: is_voucher_applied_failed {
      group_label: "Flags | Checkout"
      type: yesno
      sql: ${TABLE}.is_voucher_applied_failed ;;
    }
    dimension: is_rider_tip_selected {
      group_label: "Flags | Checkout"
      type: yesno
      sql: ${TABLE}.is_rider_tip_selected ;;
    }

    # Generic Flags
    dimension: is_address_confirmed {
      group_label: "Flags | Generic"
      type: yesno
      sql: ${TABLE}.is_address_confirmed ;;
    }
    dimension: is_account_login_succeeded {
      group_label: "Flags | Generic"
      type: yesno
      sql: ${TABLE}.is_account_login_succeeded ;;
    }
    dimension: is_account_logout_clicked {
      group_label: "Flags | Generic"
      type: yesno
      sql: ${TABLE}.is_account_logout_clicked ;;
    }
    dimension: is_account_registration_succeeded {
      group_label: "Flags | Generic"
      type: yesno
      sql: ${TABLE}.is_account_registration_succeeded ;;
    }
    dimension: is_home_viewed {
      group_label: "Flags | Generic"
      type: yesno
      sql: ${TABLE}.is_home_viewed ;;
    }
    dimension: is_category_selected {
      group_label: "Flags | Generic"
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
    dimension: dim_number_of_account_registration_succeeded {
      type: number
      hidden: yes
      sql: ${TABLE}.number_of_account_registration_succeeded ;;
    }
    dimension: dim_number_of_categories_selected {
      type: number
      hidden: yes
      sql: ${TABLE}.number_of_categories_selected ;;
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
  measure: number_of_rider_tip_selected {
    group_label: "Event Metrics"
    label: "# Rider Tip Selected"
    type: sum
    hidden: no
    sql: ${dim_number_of_rider_tip_selected};;
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
  measure: number_of_account_registration_succeeded {
    group_label: "Event Metrics"
    label: "# Accounts Registered"
    type: sum
    hidden: no
    sql: ${dim_number_of_account_registration_succeeded};;
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
    description: "Active user generated at least 2 various event during session"
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
    description: "Number of users with at least one order"
    type: count_distinct
    sql: ${user_uuid} ;;
    filters: [is_address_set: "yes"]
  }
  measure: users_with_add_to_cart {
    group_label: "User Metrics"
    label: "# Users with Add-to-Cart"
    description: "Number of users with at least one order"
    type: count_distinct
    sql: ${user_uuid} ;;
    filters: [is_product_added_to_cart: "yes"]
  }
  measure: users_with_checkout_viewed {
    group_label: "User Metrics"
    label: "# Users with Checkout Viewed"
    description: "Number of users with at least one order"
    type: count_distinct
    sql: ${user_uuid} ;;
    filters: [is_checkout_viewed: "yes"]
  }
  measure: users_with_payment_started {
    group_label: "User Metrics"
    label: "# Users with Payment Started"
    description: "Number of users with at least one order"
    type: count_distinct
    sql: ${user_uuid} ;;
    filters: [is_payment_started: "yes"]
  }

  #### Conversions ###

  measure: cvr {
    group_label: "Conversions (%)"
    label: "CVR"
    type: number
    description: "# users with at least one order / # active users"
    value_format_name: percent_1
    sql: ${users_with_order} / nullif(${active_users},0) ;;
  }
  measure: mcvr_1 {
    group_label: "Conversions (%)"
    label: "mCVR1"
    type: number
    description: "# users with an address (either selected in previous session or in current session), compared to the total number of active users"
    value_format_name: percent_1
    sql: ${users_with_address} / nullif(${active_users},0);;
  }
  measure: mcvr_2 {
    group_label: "Conversions (%)"
    label: "mCVR2"
    type: number
    description: "# users with add-to-cart, compared to the total number of users with an address"
    value_format_name: percent_1
    sql: ${users_with_add_to_cart} / nullif(${users_with_address},0);;
  }
  measure: mcvr_3 {
    group_label: "Conversions (%)"
    label: "mCVR3"
    type: number
    description: "# users with checkout started, compared to users with add-to-cart"
    value_format_name: percent_1
    sql: ${users_with_checkout_viewed} / nullif(${users_with_add_to_cart},0);;
  }
  measure: mcvr_4 {
    group_label: "Conversions (%)"
    label: "mCVR4"
    type: number
    description: "# users with payment started, compared to users with checkout started"
    value_format_name: percent_1
    sql: ${users_with_payment_started} / nullif(${users_with_checkout_viewed},0);;
  }
  measure: auth_rate {
    group_label: "Conversions (%)"
    label: "Authentication Rate"
    type: number
    description: "# user with at least one order, compared to users with payment started"
    value_format_name: percent_1
    sql: ${users_with_order} / nullif(${users_with_payment_started},0);;
  }


  # ========= HIDDEN ========== #

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
