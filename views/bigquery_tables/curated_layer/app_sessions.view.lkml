view: app_sessions {
  sql_table_name: `flink-data-prod.curated.sessions_app`
    ;;

  view_label: "* App Sessions *"
  drill_fields: [core_dimensions*]

  set: core_dimensions {
    fields: [
      country_iso,
      city,
      hub_code,
      device_type,
      is_new_user,
      has_order
    ]
  }

  ## IDs

  dimension: session_uuid {
    type: string
    sql: ${TABLE}.session_uuid ;;
    hidden: yes
  }
  dimension: user_id  {
    type: string
    sql: ${TABLE}.user_id  ;;
    hidden: yes
  }
  dimension: anonymous_id {
    type: string
    sql: ${TABLE}.anonymous_id ;;
  }
  dimension: last_order_id {
    type: string
    sql: ${TABLE}.last_order_id ;;
  }
  dimension: last_order_uuid {
    type: string
    sql: ${TABLE}.last_order_uuid ;;
  }

  ## Device attributes

  dimension: platform {
    type: string
    sql: ${TABLE}.platform ;;
    hidden: yes
  }
  dimension: device_type {
    type: string
    sql: ${TABLE}.device_type ;;
  }
  dimension: app_version {
    type: string
    sql: ${TABLE}.app_version ;;
  }
  dimension: full_app_version {
    type: string
    sql: ${device_type} || '-' || ${app_version} ;;
  }
  dimension: timezone {
    type: string
    sql: ${TABLE}.timezone ;;
    hidden: yes
  }

  ## Dates / Timestamp

  dimension_group: session_start_at {
    type: time
    datatype: timestamp
    timeframes: [
      hour,
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

  ## Hub attributes

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }
  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }
  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }
  dimension: delivery_pdt_minutes {
    type: duration_minute
    sql: ${TABLE}.delivery_pdt_minutes ;;
  }
  dimension: delivery_lat {
    type: number
    sql: ${TABLE}.delivery_lat ;;
  }
  dimension: delivery_lng {
    type: number
    sql: ${TABLE}.delivery_lng ;;
  }

  ## Discount / Order attributes

  dimension: has_order {
    type: yesno
    sql: ${TABLE}.has_order ;;
  }
  dimension: has_order_failed_error {
    type: yesno
    sql: ${TABLE}.has_order_failed_error ;;
  }
  dimension: has_payment_failed_error {
    type: yesno
    sql: ${TABLE}.has_payment_failed_error ;;
  }
  dimension: has_discount_attempted {
    type: yesno
    sql: ${TABLE}.has_discount_attempted ;;
  }
  dimension: number_of_discounts_attempted {
    type: number
    sql: ${TABLE}.number_of_discounts_attempted ;;
  }
  dimension: is_discount_successfully_applied {
    type: yesno
    sql: ${TABLE}.is_discount_successfully_applied ;;
  }
  dimension: order_discount_code {
    type: string
    sql: ${TABLE}.order_discount_code ;;
  }
  dimension: amt_discount_gross {
    type: number
    sql: ${TABLE}.amt_discount_gross ;;
  }
  dimension: amt_gmv_gross {
    type: number
    sql: ${TABLE}.amt_gmv_gross ;;
  }
  dimension: number_of_orders_placed {
    type: number
    sql: ${TABLE}.number_of_orders_placed ;;
  }
  dimension: number_of_items_in_cart {
    type: number
    sql: ${TABLE}.number_of_items_in_cart ;;
  }

  ## Session attributes

  dimension: session_duration_minutes {
    type: duration_minute
    sql: ${TABLE}.session_duration_minutes ;;
  }
  dimension: is_new_user {
    type: yesno
    sql: ${TABLE}.is_new_user ;;
  }
  dimension: has_address {
    type: yesno
    sql: ${TABLE}.is_session_with_address ;;
  }
  dimension: has_address_original {
    type: yesno
    sql: ${TABLE}.has_address ;;
  }
  dimension: is_session_with_address {
    type: yesno
    sql: ${TABLE}.is_session_with_address ;;
  }
  dimension: is_session_with_add_to_cart {
    type: yesno
    sql: ${TABLE}.is_session_with_add_to_cart ;;
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

### Custom dimensions

  dimension: returning_customer {
    type: yesno
    sql: ${has_order} ;;
  }
  dimension: hub_unknown {
    type: yesno
    sql: ${hub_code} IS NULL ;;
  }

  # dimension: is_setting_address {
  #   type: yesno
  #   description: "TRUE if user has at least one addressConfirmed event in this session, FALSE otherwise"
  #   sql: ${address_confirmed} IS NOT NULL ;;
  # }

  dimension: session_start_date_granularity {
    label: "Session Start Date (Dynamic)"
    label_from_parameter: timeframe_picker
    type: string # cannot have this as a time type. See this discussion: https://community.looker.com/lookml-5/dynamic-time-granularity-opinions-16675
    sql:
    {% if timeframe_picker._parameter_value == 'Hour' %}
      ${session_start_at_hour}
    {% elsif timeframe_picker._parameter_value == 'Day' %}
      ${session_start_at_date}
    {% elsif timeframe_picker._parameter_value == 'Week' %}
      ${session_start_at_week}
    {% elsif timeframe_picker._parameter_value == 'Month' %}
      ${session_start_at_month}
    {% endif %};;
  }

  parameter: timeframe_picker {
    label: "Session Start Date Granular"
    type: unquoted
    allowed_value: { value: "Hour" }
    allowed_value: { value: "Day" }
    allowed_value: { value: "Week" }
    allowed_value: { value: "Month" }
    default_value: "Day"
  }

  dimension: country {
    type: string
    case: {
      when: {
        sql: ${TABLE}.country_iso = "DE" ;;
        label: "Germany"
      }
      when: {
        sql: ${TABLE}.country_iso = "FR" ;;
        label: "France"
      }
      when: {
        sql: ${TABLE}.country_iso = "NL" ;;
        label: "Netherlands"
      }
      when: {
        sql: ${TABLE}.country_iso = "AT" ;;
        label: "Austria"
      }
      else: "Other / Unknown"
    }
  }

  # dimension: checkout_payment_ratio_per_session {
  #   type: number
  #   sql: ${checkout_started}/${payment_started};;
  # }

  # dimension: payment_order_ratio_per_session {
  #   type: number
  #   sql: ${payment_started}/${order_placed};;
  # }


## Measures

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: cnt_unique_anonymousid {
    label: "# Unique Users"
    description: "Number of Unique Users identified via Anonymous ID from Segment"
    hidden:  no
    type: count_distinct
    sql: ${anonymous_id};;
    value_format_name: decimal_0
  }

  # measure: cnt_address_selected {
  #   label: "Address selected count"
  #   description: "Number of sessions in which at least one Address Confirmed event happened"
  #   type: count
  #   filters: [address_confirmed: "NOT NULL"]
  # }

  # measure: cnt_home_viewed {
  #   label: "Home view count"
  #   description: "Number of sessions in which at least one Home Viewed event happened"
  #   type: count
  #   filters: [home_viewed: "NOT NULL"]
  # }

  measure: cnt_has_address {
    label: "Has address count"
    description: "# sessions in which the user had an address (selected in previous session or current)"
    type: count
    filters: [has_address: "yes"]
  }

  # measure: cnt_view_cart {
  #   label: "View cart count"
  #   description: "Number of sessions in which at least one Cart Viewed event happened"
  #   type: count
  #   filters: [view_cart: "NOT NULL"]
  # }

  measure: cnt_add_to_cart {
    label: "Add to cart count"
    description: "Number of sessions in which at least one Product Added To Cart event happened"
    type: count
    filters: [is_session_with_add_to_cart: "yes"]
  }

  measure: cnt_checkout_started {
    label: "Checkout started count"
    description: "Number of sessions in which at least one Checkout Started event happened"
    type: count
    filters: [is_session_with_checkout_started: "yes"]
  }

  measure: cnt_payment_started {
    label: "Payment started count"
    description: "Number of sessions in which at least one Payment Started event happened"
    type: count
    filters: [is_session_with_payment_started: "yes"]
  }

  measure: cnt_purchase {
    label: "Order placed count"
    description: "Number of sessions in which at least one Order Placed event happened"
    type: count
    filters: [is_session_with_order_placed: "yes"]
  }

  measure: cnt_discounts_attempted {
    label: "Order placed count"
    description: "Number of sessions in which at least one Discount Attempt event happened"
    type: count
    filters: [has_discount_attempted: "yes"]
  }

  measure: cnt_discounts_applied{
    label: "Order placed count"
    description: "Number of sessions in which at least one Discount Applied event happened"
    type: count
    filters: [is_discount_successfully_applied: "yes"]
  }

  ###### Sum of events

  measure: sum_address_selected {
    label: "Address selected sum of events"
    type: sum
    sql: ${has_address} ;;
  }

  measure: sum_add_to_cart {
    label: "Add to cart sum of events"
    type: sum
    sql: ${is_session_with_add_to_cart} ;;
  }

  measure: sum_checkout_started {
    label: "Checkout started sum of events"
    type: sum
    sql: ${is_session_with_checkout_started} ;;
  }

  measure: sum_payment_started {
    label: "Payment started sum of events"
    type: sum
    sql: ${is_session_with_payment_started} ;;
  }

  measure: sum_purchases {
    label: "Order placed sum of events"
    type: sum
    sql: ${is_session_with_order_placed} ;;
  }

  ## Measures based on other measures
  measure: overall_conversion_rate {
    type: number
    description: "Number of sessions in which an Order Placed event happened, compared to the total number of Session Started"
    value_format_name: percent_1
    sql: ${cnt_purchase}/NULLIF(${count},0) ;;
  }

  # measure: mcvr1 {
  #   type: number
  #   description: "Number of sessions in which an Addres Confirmed event happened, compared to the total number of Session Started"
  #   value_format_name: percent_1
  #   sql: ${cnt_address_selected}/NULLIF(${count},0) ;;
  # }
  measure: mcvr1 {
    type: number
    label: "mCVR1"
    description: "# sessions with an address (either selected in previous session or in current session), compared to the total number of Sessions Started"
    value_format_name: percent_1
    sql: ${cnt_has_address}/NULLIF(${count},0);;
  }

  measure: mcvr2 {
    type: number
    label: "mCVR2"
    description: "# sessions in which there was a Product Added To Cart, compared to the number of sessions in which there was a Home Viewed"
    value_format_name: percent_1
    sql: ${cnt_add_to_cart}/NULLIF(${cnt_has_address},0) ;;
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
    sql: ${cnt_purchase}/NULLIF(${cnt_payment_started},0) ;;
  }


  #########

  # dimension: add_to_cart {
  #   type: number
  #   sql: ${TABLE}.add_to_cart ;;
  # }

  # dimension: view_cart {
  #   type: number
  #   sql: ${TABLE}.view_cart ;;
  # }

  # dimension: checkout_started {
  #   type: number
  #   sql: ${TABLE}.checkout_started ;;
  # }

  # dimension: payment_started {
  #   type: number
  #   sql: ${TABLE}.payment_started ;;
  # }

  # dimension: order_placed {
  #   type: number
  #   sql: ${TABLE}.order_placed ;;
  # }

  set: detail {
    fields: [
      session_uuid,
      user_id,
      anonymous_id,
      last_order_id,
      last_order_uuid,
      session_start_at_date,
      session_end_at_date,
      session_duration_minutes,
      platform,
      device_type,
      app_version,
      timezone,
      country,
      country_iso,
      city,
      hub_code,
      delivery_pdt_minutes,
      delivery_lat,
      delivery_lng,
      is_new_user,
      has_order,
      amt_gmv_gross,
      amt_discount_gross,
      has_order_failed_error,
      has_payment_failed_error,
      is_discount_successfully_applied,
      has_discount_attempted,
      is_session_with_address,
      is_session_with_add_to_cart,
      is_session_with_checkout_started,
      is_session_with_payment_started,
      is_session_with_order_placed,
      number_of_discounts_attempted,
      number_of_items_in_cart,
      number_of_orders_placed
    ]
  }

#   sql: ${TABLE}.most_recent_purchase_at ;;
# }
#
# measure: total_lifetime_orders {
#   description: "Use this for counting lifetime orders across many users"
#   type: sum
#   sql: ${lifetime_orders} ;;
# }
}
