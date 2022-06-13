view: consumer_behaviour_dynamic_delivery_fee {
  sql_table_name: `flink-data-prod.reporting.consumer_behaviour_dynamic_delivery_fee`
    ;;

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: cart_viewed_event_uuid {
    group_label: "IDs"
    label: "Cart Viewed Event UUID"
    type: string
    primary_key: yes
    sql: ${TABLE}.anonymous_id ;;
  }

  dimension: user_uuid {
    group_label: "IDs"
    label: "Anonymous ID"
    type: string
    sql: ${TABLE}.anonymous_id ;;
  }

  dimension: cart_difference_amount {
    type: number
    hidden: yes
    sql: ${TABLE}.cart_difference_amount ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: delivery_fee {
    group_label: "Delivery Fee Information"
    label: "Delivery Fee Paid"
    type: number
    sql: ${TABLE}.delivery_fee ;;
  }

  dimension: delivery_fee_effect {
    group_label: "Delivery Fee Information"
    label: "Delivery Fee Category"
    type: string
    sql: ${TABLE}.delivery_fee_effect ;;
  }

  dimension: device_type {
    group_label: "Device Dimensions"
    label: "device_type"
    description: "Device Type Information"
    type: string
    sql: ${TABLE}.device_type ;;
  }

  dimension_group: event {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.event_date ;;
  }

  dimension: first_cart_event_name {
    type: string
    hidden: yes
    sql: ${TABLE}.first_cart_event_name ;;
  }

  dimension_group: first_cart_view_timestamp {
    type: time
    hidden: yes
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.first_cart_view_timestamp ;;
  }

  dimension: first_delivery_fee_displayed {
    group_label: "Delivery Fee Information"
    label: "First Delivery Fee Seen"
    type: number
    sql: ${TABLE}.first_delivery_fee_displayed ;;
  }

  dimension: first_event_sub_total {
    group_label: "Delivery Fee Information"
    label: "First Cart Value Seen"
    type: number
    sql: ${TABLE}.first_event_sub_total ;;
  }

  dimension: first_message_displayed {
    hidden: yes
    type: string
    sql: ${TABLE}.first_message_displayed ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: last_cart_event_name {
    hidden: yes
    type: string
    sql: ${TABLE}.last_cart_event_name ;;
  }

  dimension_group: last_cart_view_timestamp {
    type: time
    hidden: yes
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.last_cart_view_timestamp ;;
  }

  dimension: last_delivery_fee_displayed {
    group_label: "Delivery Fee Information"
    label: "Last Delivery Fee Seen"
    type: number
    sql: ${TABLE}.last_delivery_fee_displayed ;;
  }

  dimension: last_event_sub_total {
    group_label: "Delivery Fee Information"
    label: "Last Cart Value Seen"
    type: number
    sql: ${TABLE}.last_event_sub_total ;;
  }

  dimension: last_message_displayed {
    type: string
    hidden: yes
    sql: ${TABLE}.last_message_displayed ;;
  }

  dimension: number_of_products_ordered_dim {
    type: number
    sql: ${TABLE}.number_of_products_ordered ;;
  }

  dimension_group: order_placed_timestamp {
    type: time
    hidden: yes
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.order_placed_timestamp ;;
  }

  dimension: order_uuid {
    group_label: "IDs"
    label: "Order UUID"
    type: string
    sql: ${TABLE}.order_uuid ;;
  }

  dimension: platform {
    group_label: "Device Dimensions"
    label: "Platform"
    description: "Platform is either iOS, Android or Web"
    type: string
    sql: ${TABLE}.platform ;;
  }

  dimension: rider_tip_value {
    type: number
    sql: ${TABLE}.rider_tip_value ;;
  }

  dimension: user_id {
    group_label: "IDs"
    label: "User ID"
    type: string
    sql: ${TABLE}.user_id ;;
  }

    ######## Flags | Event ########

  dimension: flag_rider_tip {
    group_label: "Flags | Event"
    label: "Is Rider Tip"
    description: "Did the user tip the rider?"
    type: yesno
    sql: ${TABLE}.flag_rider_tip ;;
  }

  dimension: is_cart_viewed {
    group_label: "Flags | Event"
    label: "Is Cart Viewed"
    description: "Did the user view their cart?"
    type: yesno
    sql: ${TABLE}.is_cart_viewed ;;
  }

  dimension: is_checkout_started {
    group_label: "Flags | Event"
    label: "Is Checkout Started?"
    description: "Did the user start checkout process?"
    type: yesno
    sql: ${TABLE}.is_checkout_started ;;
  }

  dimension: is_checkout_viewed {
    group_label: "Flags | Event"
    label: "Is Checkout Viewed?"
    description: "Did the user view checkout screen?"
    type: yesno
    sql: ${TABLE}.is_checkout_viewed ;;
  }

  dimension: is_order_placed {
    group_label: "Flags | Event"
    label: "Is Order Placed?"
    description: "Did the user place an order?"
    type: yesno
    sql: ${TABLE}.is_order_placed ;;
  }

  dimension: is_payment_started {
    group_label: "Flags | Event"
    label: "Is Payment Started Started?"
    description: "Did the user start the payment process?"
    type: yesno
    sql: ${TABLE}.is_payment_started ;;
  }

  dimension: single_cart_view {
    group_label: "Flags | Event"
    label: "Is Single Cart Viewed?"
    description: "Did the user only fire one cart viewed event during checkout process?"
    type: yesno
    sql: ${TABLE}.single_cart_view ;;
  }

    ######## Dates ########

  dimension_group: event_date {
    group_label: "Date Dimensions"
    label: "Event date"
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
        ${event_date}
      {% elsif timeframe_picker._parameter_value == 'Week' %}
        ${event_date}
      {% elsif timeframe_picker._parameter_value == 'Month' %}
        ${event_date}
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

  set: detail {
    fields: [
      cart_viewed_event_uuid,
      event_date,
      is_cart_viewed,
      is_checkout_viewed,
      is_payment_started,
      is_order_placed
    ]
  }

  ######## Measures ########

  measure: revenue {
    group_label: "Financial Metrics"
    label: "Revenue"
    type: number
    value_format_name: decimal_1
    sql: ${TABLE}.revenue ;;
  }

  measure: cart_difference_amount_avg {
    group_label: "Delivery Fee Metrics"
    label: "AVG Cart Difference"
    type: average
    value_format_name: decimal_1
    sql: ${TABLE}.cart_difference_amount ;;
  }

  measure: first_cart_total_avg {
    group_label: "Delivery Fee Metrics"
    label: "AVG First Cart Total "
    type: average
    value_format_name: decimal_1
    sql: ${TABLE}.first_event_sub_total ;;
  }

  measure: last_cart_total_avg {
    group_label: "Delivery Fee Metrics"
    label: "AVG Last Cart Total "
    type: average
    value_format_name: decimal_1
    sql: ${TABLE}.last_event_sub_total ;;
  }

  measure: number_of_products_ordered_sum {
    group_label: "Financial Metrics"
    label: "Total Number of Products Ordered"
    type: sum
    value_format_name: decimal_0
    sql: ${TABLE}.number_of_products_ordered ;;
  }

  measure: revenue_total {
    group_label: "Financial Metrics"
    label: "Total Revenue"
    type: sum
    value_format_name: decimal_1
    sql: ${TABLE}.revenue ;;
  }

  measure: delivery_fee_avg {
    group_label: "Delivery Fee Metrics"
    label: "Avg. Delivery Fee"
    type: average
    value_format_name: decimal_1
    sql: ${TABLE}.delivery_fee ;;
  }

  measure: delivery_fee_sum {
    group_label: "Delivery Fee Metrics"
    label: "Total Delivery Fee"
    type: sum
    value_format_name: decimal_1
    sql: ${TABLE}.delivery_fee ;;
  }

  measure: discount_value_avg {
    group_label: "Financial Metrics"
    label: "AVG Discount Value "
    type: average
    value_format_name: decimal_1
    sql: ${TABLE}.discount_value ;;
  }

  measure: rider_tip_value_sum {
    group_label: "Financial Metrics"
    label: "Rider Tip Total"
    type: sum
    value_format_name: decimal_0
    sql: ${TABLE}.rider_tip_value ;;
  }

  measure: cart_viewed_cnt {
    group_label: "# Active User Metrics"
    label: "# Active Users With Cart Viewed"
    description: "# of daily active users viewing cart"
    type: count_distinct
    sql: ${user_uuid} ;;
    filters: [is_cart_viewed: "yes"]
  }

  measure: checkout_viewed_cnt {
    group_label: "# Active User Metrics"
    label: "# Active Users With Checkout Viewed"
    description: "# of daily active users viewing checkout"
    type: count_distinct
    sql: ${user_uuid} ;;
    filters: [is_checkout_viewed: "yes"]
  }

  measure: payment_started_cnt {
    group_label: "# Active User Metrics"
    label: "# Active Users With Payment Started"
    description: "# of daily active users starting payment"
    type: count_distinct
    sql: ${user_uuid} ;;
    filters: [is_payment_started: "yes"]
  }

  measure: order_placed_cnt {
    group_label: "# Active User Metrics"
    label: "# Active Users With Order Placed"
    description: "# of daily active users placing order"
    type: count_distinct
    sql: ${user_uuid} ;;
    filters: [is_order_placed: "yes"]
  }

  measure: cart_abandonment_rate {
    group_label: "# Active User Metrics"
    label: "% Active Users Abandoning Cart"
    description: "% of daily active users abandoning cart"
    type: number
    value_format_name: percent_1
    sql:  1- (${checkout_viewed_cnt} / NULLIF(${cart_viewed_cnt},2) ) ;;
  }

  measure: checkout_abandonment_rate {
    group_label: "# Active User Metrics"
    label: "% Active Users Abandoning Checkout"
    description: "% of daily active users abandoning cart"
    type: number
    value_format_name: percent_1
    sql:  1- (${payment_started_cnt} / NULLIF(${checkout_viewed_cnt},0) ) ;;
  }

  measure: order_placed_rate {
    group_label: "# Active User Metrics"
    label: "% Active Users Placing an Order Compared to Cart Viewed"
    description: "# of daily active users placing order"
    type: number
    value_format_name: percent_1
    sql: ${order_placed_cnt} / ${cart_viewed_cnt} ;;
  }
}
