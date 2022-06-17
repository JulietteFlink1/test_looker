view: user_attributes_daily_customer_lifecycle_aggregates {
  sql_table_name: `flink-data-dev.sandbox_natalia.user_attributes_daily_user_aggregates`;;
  view_label: "Daily Events "


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~     Sets    ~~~~~~~~~~~~~~~ #
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

  set: device_attributes {
    fields: [

      app_version,
      platform
    ]
  }

  set: location_attributes {
    fields: [
      city,
      country_iso,
    ]
  }

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
    # ~~~~~~~~~~~~~~~     Dimensions    ~~~~~~~~~~~~~~~ #
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

    # ======= IDs ======= #

  dimension: anonymous_id {
      group_label: "IDs"
      label: "anonymous_id"
      type: string
      sql: ${TABLE}.anonymous_id ;;
  }

  dimension: customer_uuid_filled {
    group_label: "IDs"
    label: "customer_uuid_filled"
    type: string
    sql: ${TABLE}.daily_unique_customer_uuid ;;
  }

  dimension: daily_user_uuid {
    group_label: "IDs"
    label: "daily_user_uuid"
    type: string
    sql: ${TABLE}.daily_user_uuid ;;
  }


  ######## Visits Flags ########

  dimension: is_active_user {
    group_label: "Flags | Visit"
    label: "is_active_user"
    type: yesno
    sql: ${TABLE}.is_active_user ;;
  }

  dimension: is_new_user {
    group_label: "Flags | Visit"
    type: yesno
    sql: ${TABLE}.is_new_user ;;
  }

  dimension: is_new_user_anonymous_id {
    group_label: "Flags | Visit"
    type: yesno
    sql: ${TABLE}.is_new_user_anonymous_id ;;
  }

  dimension: is_first_visit {
    group_label: "Flags | Visit"
    type: yesno
    sql: ${TABLE}.is_first_visit ;;
  }

    ######## First Visit Flags ########

  dimension: first_visit_date {
    group_label: "Flags | Visit"
    type: date
    sql: ${TABLE}.first_visit_date ;;
  }

  dimension: first_order_date {
    group_label: "Flags | User"
    type: date
    sql: ${TABLE}.first_order_date ;;
  }

    ######## Funnel Flags ########

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


  ######## Dates ########

  dimension_group: visit_date_at {
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
    sql: ${TABLE}.visit_date ;;
  }

  dimension: event_date_granularity {
    group_label: "Date Dimensions"
    label: "Event Date (Dynamic)"
    label_from_parameter: timeframe_picker
    type: string # cannot have this as a time type. See this discussion: https://community.looker.com/lookml-5/dynamic-time-granularity-opinions-16675
    hidden:  no
    sql:
      {% if timeframe_picker._parameter_value == 'Day' %}
        ${visit_date_at_date}
      {% elsif timeframe_picker._parameter_value == 'Week' %}
        ${visit_date_at_week}
      {% elsif timeframe_picker._parameter_value == 'Month' %}
        ${visit_date_at_month}
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

  dimension: app_version_order {
    group_label: "Device Dimensions"
    label: "App Version order"
    type: number
    hidden: yes
    description: "App release version middle digits for ordering"
    sql: split(${TABLE}.app_version,".")[SAFE_OFFSET(1)] ;;
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
  ######## Location Atributes ########

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

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
    # ~~~~~~~~~~~~~~~     Measures      ~~~~~~~~~~~~~~~ #
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #


  #### Basic counts

  measure: daily_user_events {
    group_label: "User Metrics"
    label: "Count "
    type: count_distinct
    sql: ${daily_user_uuid} ;;
  }
  measure: unique_users {
    group_label: "User Metrics"
    label: "# Unique Users"
    description: "Number of unique users"
    type: count_distinct
    sql: ${customer_uuid_filled} ;;
  }

  measure: active_users {
    group_label: "User Metrics"
    label: "# Active Users"
    description: "Active user generated at least 2 various events when browsing Flink app/web"
    type: count_distinct
    sql: ${customer_uuid_filled} ;;
    filters: [is_active_user: "yes"]
  }

  measure: new_users {
    group_label: "User Metrics"
    label: "# New Users"
    description: "New user is defined as in isits prior to first conversion"
    type: count_distinct
    sql: ${customer_uuid_filled} ;;
    filters: [is_new_user: "yes"]
  }

  measure: new_users_first_visits {
    group_label: "User Metrics"
    label: "# New Users First Visit"
    description: "New user is defined as on the very first day"
    type: count_distinct
    sql: ${customer_uuid_filled} ;;
    filters: [is_new_user: "yes", is_first_visit: "yes"]
  }

  measure: active_users_anonymous_id {
    group_label: "User Metrics"
    label: "# Active Users Anonymous_id"
    description: "Active user generated at least 2 various events when browsing Flink app/web"
    type: count_distinct
    sql: ${anonymous_id} ;;
    filters: [is_active_user: "yes"]
  }


  measure: users_with_order {
    group_label: "User Metrics"
    label: "# Users with Orders"
    description: "Number of users with at least one order"
    type: count_distinct
    sql: ${customer_uuid_filled} ;;
    filters: [is_order_placed: "yes"]
  }

  measure: users_with_order_anonymous_id {
    group_label: "User Metrics"
    label: "# Users with Orders Anonymous_id"
    description: "Number of users with at least one order"
    type: count_distinct
    sql: ${anonymous_id} ;;
    filters: [is_order_placed: "yes"]
  }

  measure: users_with_address {
    group_label: "User Metrics"
    label: "# Users with Address Set"
    description: "Number of users with at least one address set"
    type: count_distinct
    sql: ${customer_uuid_filled} ;;
    filters: [is_address_set: "yes"]
  }
  measure: users_with_add_to_cart {
    group_label: "User Metrics"
    label: "# Users with Add-to-Cart"
    description: "Number of users with at least one product added to cart"
    type: count_distinct
    sql: ${customer_uuid_filled} ;;
    filters: [is_product_added_to_cart: "yes"]
  }
  measure: users_with_cart_viewed {
    group_label: "User Metrics"
    label: "# Users with Cart Viewed"
    description: "Number of users with viewed their cart at least once"
    type: count_distinct
    sql: ${customer_uuid_filled} ;;
    filters: [is_cart_viewed: "yes"]
  }
  measure: users_with_checkout_viewed {
    group_label: "User Metrics"
    label: "# Users with Checkout Viewed"
    description: "Number of users with viewed checkout at least once"
    type: count_distinct
    sql: ${customer_uuid_filled} ;;
    filters: [is_checkout_viewed: "yes"]
  }
  measure: users_with_payment_started {
    group_label: "User Metrics"
    label: "# Users with Payment Started"
    description: "Number of users with started the payment process at least once"
    type: count_distinct
    sql: ${customer_uuid_filled} ;;
    filters: [is_payment_started: "yes"]
  }

  #### Conversions ###

  measure: cvr_anonymous_id {
    group_label: "Conversions - All Active Users (%)"
    label: "CVR Anonymous_id"
    type: number
    description: "# users with at least one order / # active users"
    value_format_name: percent_1
    sql: ${users_with_order_anonymous_id} / nullif(${active_users_anonymous_id},0) ;;
  }

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
  measure: mcvr_3 {
    group_label: "Conversions - Subsequent Steps (%)"
    label: "mCVR3 [old]"
    type: number
    description: "# users with checkout started, compared to users with add-to-cart"
    value_format_name: percent_1
    sql: ${users_with_checkout_viewed} / nullif(${users_with_add_to_cart},0);;
  }

  measure: mcvr_4 {
    group_label: "Conversions - Subsequent Steps (%)"
    label: "mCVR4"
    type: number
    description: "# users with payment started, compared to users with checkout started"
    value_format_name: percent_1
    sql: ${users_with_payment_started} / nullif(${users_with_checkout_viewed},0);;
  }

  measure: auth_rate {
    group_label: "Conversions - Subsequent Steps (%)"
    label: "Authentication Rate"
    type: number
    description: "# user with at least one order, compared to users with payment started"
    value_format_name: percent_1
    sql: ${users_with_order} / nullif(${users_with_payment_started},0);;
  }
}
