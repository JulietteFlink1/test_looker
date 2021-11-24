view: app_sessions {
  sql_table_name: `flink-data-prod.curated.app_sessions_full_load`
    ;;

  view_label: "* App Sessions *"
  drill_fields: [core_dimensions*]

  set: core_dimensions {
    fields: [
      country,
      city,
      hub_code,
      device_type,
      is_new_user
    ]
  }

########### DIMENSIONS ###########
  ## IDs

  dimension: session_uuid {
    group_label: "IDs"
    type: string
    description: "Session ID defined in DWH as a primary key of this model"
    sql: ${TABLE}.session_uuid ;;
    primary_key: yes
    hidden: yes
  }
  dimension: user_id  {
    group_label: "IDs"
    type: string
    description: "User ID populated upon registration"
    sql: ${TABLE}.user_id  ;;
    hidden: yes
  }
  dimension: anonymous_id {
    group_label: "IDs"
    type: string
    description: "Anonymou ID populated by Segment as a user identifier"
    sql: ${TABLE}.anonymous_id ;;
  }
  dimension: last_order_id {
    group_label: "IDs"
    type: string
    description: "Last order ID which happened during a session (in case of multiple orders we take the latest order_id only"
    sql: ${TABLE}.last_order_id ;;
    hidden: yes
  }
  dimension: last_order_uuid {
    group_label: "IDs"
    label: "Last Order UUID"
    type: string
    description: "Last Order UUID as a concatenation of country_iso and order_id"
    sql: ${TABLE}.last_order_uuid ;;
  }

  ## Device attributes

  dimension: platform {
    group_label: "Device Dimensions"
    type: string
    description: "Platform where session appeared >> app"
    sql: ${TABLE}.platform ;;
    hidden: yes
  }
  dimension: device_type {
    group_label: "Device Dimensions"
    type: string
    description: "Device type is either iOS or Android"
    sql: ${TABLE}.device_type ;;
  }
  dimension: app_version {
    group_label: "Device Dimensions"
    type: string
    description: "App realease version"
    sql: ${TABLE}.app_version ;;
  }
  dimension: full_app_version {
    group_label: "Device Dimensions"
    type: string
    description: "Concatenation of device_type and app_version"
    sql: ${device_type} || '-' || ${app_version} ;;
  }
  dimension: timezone {
    group_label: "Device Dimensions"
    type: string
    description: "Timezone in which session occured"
    sql: ${TABLE}.timezone ;;
    hidden: yes
  }

  ## GENERIC: Dates / Timestamp

  dimension_group: session_start_at {
    group_label: "Date Dimensions"
    label: "Session Start "
    type: time
    description: "Start of the session with varioud granulairty available"
    datatype: timestamp
    timeframes: [
      hour,
      hour_of_day,
      date,
      day_of_week,
      week,
      month,
      year
    ]
    sql: ${TABLE}.session_start_at ;;
  }
  dimension_group: session_end_at {
    group_label: "Date Dimensions"
    type: time
    description: "End of the session with varioud granulairty available"
    datatype: datetime
    timeframes: [
      hour,
      hour_of_day,
      date,
      day_of_week,
      week,
      month,
      year
    ]
    sql: ${TABLE}.session_end_at ;;
    hidden: yes
  }
  dimension: is_customer {
    group_label: "Generic Dimensions"
    description: "A customer is a user who made at least one purchase in their lifetime history with Flink"
    type: yesno
    sql: ${has_order} ;;
  }
  dimension: hub_code {
    group_label: "Generic Dimensions"
    type: string
    sql: ${TABLE}.hub_code ;;
  }
  dimension: hub_unknown {
    group_label: "Generic Dimensions"
    description: "Unknown hub"
    type: yesno
    sql: ${hub_code} IS NULL ;;
  }
  dimension: is_new_user {
    group_label: "Generic Dimensions"
    description: "New user generates the first session, any subsequent session would belong to an existing user"
    type: yesno
    sql: ${TABLE}.is_new_user ;;
  }
  # dimension: has_address {
  #   type: yesno
  #   sql: ${TABLE}.is_session_with_address ;;
  #   hidden: yes
  # }

  ## Hub attributes
  dimension: city {
    group_label: "Geo Dimensions"
    type: string
    sql: ${TABLE}.city ;;
  }
  dimension: delivery_pdt_minutes {
    group_label: "Geo Dimensions"
    label: "Delivery PDT Minutes"
    type: number
    sql: ${TABLE}.delivery_pdt_minutes ;;
  }
  dimension: delivery_lat {
    group_label: "Geo Dimensions"
    label: "Delivery Latitude"
    type: number
    sql: ${TABLE}.delivery_lat ;;
  }
  dimension: delivery_lng {
    group_label: "Geo Dimensions"
    description: "Delivery Longitude"
    type: number
    sql: ${TABLE}.delivery_lng ;;
  }
  dimension: country_iso {
    group_label: "Geo Dimensions"
    type: string
    sql: ${TABLE}.country_iso ;;
    hidden: yes
  }
  dimension: country {
    group_label: "Geo Dimensions"
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

  ## Checkout attributes

  dimension: has_order {
    type: yesno
    sql: ${TABLE}.has_order ;;
    hidden: yes
  }
  dimension: has_order_failed_error {
    group_label: "Checkout Dimensions"
    label: "Is Session with Failed Error"
    description: "Sessions with order_failed error event"
    type: yesno
    sql: ${TABLE}.has_order_failed_error ;;
  }
  dimension: has_payment_failed_error {
    group_label: "Checkout Dimensions"
    label: "Is Session with Payment Failed Error"
    description: "Sessions with payment_failed error event"
    type: yesno
    sql: ${TABLE}.has_payment_failed_error ;;
  }
  dimension: has_discount_attempted {
    group_label: "Checkout Dimensions"
    label: "Is Session with Attempted Discount"
    description: "Sessions with voucher_attempted event"
    type: yesno
    sql: ${TABLE}.has_discount_attempted ;;
  }
  dimension: has_discount_successfully_applied {
    group_label: "Checkout Dimensions"
    label: "Is Session with Successfully Applied Discount"
    description: "Sessions with voucher_succeed event"
    type: yesno
    sql: ${TABLE}.is_discount_successfully_applied ;;
  }
  dimension: order_discount_code {
    group_label: "Checkout Dimensions"
    label: "Order Discount Code"
    description: "Voucher / Discount Code"
    type: string
    sql: ${TABLE}.order_discount_code ;;
  }

  ## Session attributes
  dimension: is_session_with_address {
    group_label: "Generic Dimensions"
    label: "Is Session with Confirmed Address"
    description: "Session with confirmed address"
    type: yesno
    sql: ${TABLE}.is_session_with_address ;;
  }
  dimension: is_session_with_add_to_cart {
    group_label: "Generic Dimensions"
    description: "Session with product add to cart"
    type: yesno
    sql: ${TABLE}.is_session_with_add_to_cart ;;
  }
  dimension: is_session_with_checkout_started {
    group_label: "Generic Dimensions"
    description: "Session with started checkout"
    type: yesno
    sql: ${TABLE}.is_session_with_checkout_started ;;
  }
  dimension: is_session_with_payment_started {
    group_label: "Generic Dimensions"
    description: "Session with started payment"
    type: yesno
    sql: ${TABLE}.is_session_with_payment_started ;;
  }
  dimension: is_session_with_order_placed {
    group_label: "Generic Dimensions"
    description: "Session with placed order"
    type: yesno
    sql: ${TABLE}.is_session_with_order_placed ;;
  }

### Custom dimensions
  dimension: session_start_date_granularity {
    group_label: "Date Dimensions"
    label: "Session Start Date (Dynamic)"
    label_from_parameter: timeframe_picker
    type: string # cannot have this as a time type. See this discussion: https://community.looker.com/lookml-5/dynamic-time-granularity-opinions-16675
    hidden:  yes
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
    group_label: "Date Dimensions"
    label: "Session Start Date Granularity"
    type: unquoted
    allowed_value: { value: "Hour" }
    allowed_value: { value: "Day" }
    allowed_value: { value: "Week" }
    allowed_value: { value: "Month" }
    default_value: "Day"
  }

  ################ Measures from dimensions #################
  dimension: amt_discount_gross {
    type: number
    sql: ${TABLE}.amt_discount_gross ;;
    hidden: yes
  }
  dimension: amt_gmv_gross {
    type: number
    sql: ${TABLE}.amt_gmv_gross ;;
    hidden: yes
  }
  dimension: number_of_orders_placed {
    type: number
    sql: ${TABLE}.number_of_orders_placed ;;
    hidden: yes
  }
  dimension: number_of_items_in_cart {
    type: number
    sql: ${TABLE}.number_of_items_in_cart ;;
    hidden: yes
  }
  dimension: number_of_discounts_attempted {
    type: number
    sql: ${TABLE}.number_of_discounts_attempted ;;
    hidden: yes
  }
  dimension: session_duration_minutes {
    type: duration_minute
    sql: ${TABLE}.session_duration_minutes ;;
    hidden: yes
  }


  ################ Measures ################

  measure: count {
    group_label: "Basic Counts (Orders / Customers etc.)"
    label: "Count All"
    type: count
    drill_fields: [detail*]
  }

  measure: cnt_unique_anonymousid {
    label: "# Unique Users"
    group_label: "Basic Counts (Orders / Customers etc.)"
    description: "Number of unique users identified via anonymous ID from Segment"
    hidden:  no
    type: count_distinct
    sql: ${anonymous_id};;
    value_format_name: decimal_0
  }

  measure: cnt_unique_sessions {
    label: "# Unique Sessions"
    group_label: "Basic Counts (Orders / Customers etc.)"
    description: "Number of unique sessions based on sessions_uuid"
    hidden:  no
    type: count_distinct
    sql: ${session_uuid};;
    value_format_name: decimal_0
  }


#### Sessions with events ###
  measure: cnt_has_address {
    group_label: "Sessions with Event Flags"
    label: "# Session with Confirmed Address"
    description: "# sessions in which the user had an address (selected in previous session or current)"
    type: count
    filters: [is_session_with_address: "yes"]
  }

  measure: cnt_add_to_cart {
    group_label: "Sessions with Event Flags"
    label: "# Session with Add to Cart"
    description: "Number of sessions in which at least one Product Added To Cart event happened"
    type: count
    filters: [is_session_with_add_to_cart: "yes"]
  }

  measure: cnt_checkout_started {
    group_label: "Sessions with Event Flags"
    label: "# Session with Checkout Started"
    description: "Number of sessions in which at least one Checkout Started event happened"
    type: count
    filters: [is_session_with_checkout_started: "yes"]
  }

  measure: cnt_payment_started {
    group_label: "Sessions with Event Flags"
    label: "# Session with Payment Started"
    description: "Number of sessions in which at least one Payment Started event happened"
    type: count
    filters: [is_session_with_payment_started: "yes"]
  }

  measure: cnt_purchase {
    group_label: "Sessions with Event Flags"
    label: "# Session with Order Placed"
    description: "Number of sessions in which at least one Order Placed event happened"
    type: count
    filters: [is_session_with_order_placed: "yes"]
  }

  measure: cnt_discounts_attempted {
    group_label: "Sessions with Event Flags"
    label: "# Session with Attempted Discounts"
    description: "Number of sessions in which at least one Discount Attempt event happened"
    type: count
    filters: [has_discount_attempted: "yes"]
  }

  measure: cnt_discounts_applied{
    group_label: "Sessions with Event Flags"
    label: "# Session with Applied Discounts"
    description: "Number of sessions in which at least one Discount Applied event happened"
    type: count
    filters: [has_discount_successfully_applied: "yes"]
  }

  ### These measures reformat cnt so it shows % in the label as well -> for the conversion funnel visualization ###

  measure: perc_of_total_has_address {
    hidden: yes
    type: number
    sql: ${cnt_has_address}/${count} ;;
    value_format_name: percent_1
  }

  measure: total_has_address {
    hidden: yes
    type: number
    sql: ${cnt_has_address} ;;
    html: {{ rendered_value }} ({{ perc_of_total_has_address._rendered_value }} % of total) ;;
  }

  measure: perc_of_total_patc {
    hidden: yes
    type: number
    sql: ${cnt_add_to_cart}/${count} ;;
    value_format_name: percent_1
  }

  measure: total_has_patc {
    hidden: yes
    type: number
    sql: ${cnt_add_to_cart} ;;
    html: {{ rendered_value }} ({{ perc_of_total_patc._rendered_value }} % of total) ;;
  }

  measure: perc_of_total_checkout {
    hidden: yes
    type: number
    sql: ${cnt_checkout_started}/${count} ;;
    value_format_name: percent_1
  }

  measure: total_has_checkout {
    hidden: yes
    type: number
    sql: ${cnt_checkout_started} ;;
    html: {{ rendered_value }} ({{ perc_of_total_checkout._rendered_value }} % of total) ;;
  }

  measure: perc_of_total_payment {
    hidden: yes
    type: number
    sql: ${cnt_payment_started}/${count} ;;
    value_format_name: percent_1
  }

  measure: total_has_payment {
    hidden: yes
    type: number
    sql: ${cnt_payment_started} ;;
    html: {{ rendered_value }} ({{ perc_of_total_payment._rendered_value }} % of total) ;;
  }

  measure: perc_of_total_order {
    hidden: yes
    type: number
    sql: ${cnt_purchase}/${count} ;;
    value_format_name: percent_1
  }

  measure: total_has_order {
    hidden: yes
    type: number
    sql: ${cnt_purchase} ;;
    html: {{ rendered_value }} ({{ perc_of_total_order._rendered_value }} % of total) ;;
  }

  ## Measures based on other measures
  measure: overall_conversion_rate {
    group_label: "Conversions"
    label: "CVR"
    type: number
    description: "Number of sessions in which an Order Placed event happened, compared to the total number of Session Started"
    value_format_name: percent_1
    sql: ${cnt_purchase}/NULLIF(${count},0) ;;
  }

  measure: mcvr1 {
    group_label: "Conversions"
    label: "mCVR1"
    type: number
    description: "# sessions with an address (either selected in previous session or in current session), compared to the total number of Sessions Started"
    value_format_name: percent_1
    sql: ${cnt_has_address}/NULLIF(${count},0);;
  }

  measure: mcvr2 {
    group_label: "Conversions"
    label: "mCVR2"
    type: number
    description: "# sessions in which there was a Product Added To Cart, compared to the number of sessions in which there was a Home Viewed"
    value_format_name: percent_1
    sql: ${cnt_add_to_cart}/NULLIF(${cnt_has_address},0) ;;
  }

  measure: mcvr3 {
    group_label: "Conversions"
    label: "mCVR3"
    type: number
    description: "#sessions in which there was a Checkout Started event happened, compared to the number of sessions in which there was a Product Added To Cart"
    value_format_name: percent_1
    sql: ${cnt_checkout_started}/NULLIF(${cnt_add_to_cart},0) ;;
  }

  measure: mcvr4 {
    group_label: "Conversions"
    label: "mCVR4"
    type: number
    description: "# sessions in which there was a Payment Started event happened, compared to the number of sessions in which there was a Checkout Started"
    value_format_name: percent_1
    sql: ${cnt_payment_started}/NULLIF(${cnt_checkout_started},0) ;;
  }

  measure: payment_success {
    group_label: "Conversions"
    label: "Paymenr Success Rate"
    type: number
    description: "Number of sessions in which there was an Order Placed, compared to the number of sessions in which there was a Payment Started"
    value_format_name: percent_1
    sql: ${cnt_purchase}/NULLIF(${cnt_payment_started},0) ;;
  }

  ### Monterary metrics ###

  measure: sum_amt_gmv_gross {
    group_label: "Monetary Values"
    label: "SUM GMV (Gross)"
    description: "Sum of Gross Merchandise Value of orders incl. fees and before deduction of discounts (incl. VAT)"
    type: sum
    hidden: no
    sql: ${amt_gmv_gross} ;;
    value_format_name: euro_accounting_2_precision
  }
  measure: avg_amt_gmv_gross {
    group_label: "Monetary Values"
    label: "AOV (Gross)"
    description: "Average of Gross Merchandise Value of orders incl. fees and before deduction of discounts (incl. VAT)"
    type: average
    hidden: no
    sql: ${amt_gmv_gross} ;;
    value_format_name: euro_accounting_2_precision
  }
  measure: sum_amt_discount_gross {
    group_label: "Monetary Values"
    label: "SUM Discount Amount (Gross)"
    description: "Sum of Discounts in orders incl. fees and before deduction of discounts (incl. VAT)"
    type: sum
    hidden: no
    sql: ${amt_discount_gross} ;;
    value_format_name: euro_accounting_2_precision
  }
  measure: avg_amt_discount_gross {
    group_label: "Monetary Values"
    label: "AVG Discount (Gross)"
    description: "Average Discount per orders incl. fees and before deduction of discounts (incl. VAT)"
    type: average
    hidden: no
    sql: ${amt_discount_gross} ;;
    value_format_name: euro_accounting_2_precision
  }
  measure: sum_order_placed {
    group_label: "Basic Counts (Orders / Customers etc.)"
    label: "# Orders Placed"
    type: sum
    hidden: no
    sql: ${number_of_orders_placed} ;;
    value_format_name: decimal_0
  }
  measure: sum_items_in_cart{
    group_label: "Basic Counts (Orders / Customers etc.)"
    label: "# Items in Cart"
    type: sum
    hidden: no
    sql: ${number_of_items_in_cart} ;;
    value_format_name: decimal_0
  }
  measure: avg_items_in_cart{
    group_label: "Basic Counts (Orders / Customers etc.)"
    label: "AVG # Items in Cart"
    type: average
    hidden: no
    sql: ${number_of_items_in_cart} ;;
    value_format_name: decimal_1
  }
  measure: avg_discount_attempts{
    group_label: "Basic Counts (Orders / Customers etc.)"
    label: "AVG # Attempted Discounts"
    type: average
    hidden: no
    sql: ${number_of_discounts_attempted} ;;
    value_format_name: decimal_1
  }
  measure: sum_session_duration_minutes{
    group_label: "Basic Counts (Orders / Customers etc.)"
    label: "Session Duration (Minutes)"
    type: sum
    hidden: no
    sql: ${session_duration_minutes} ;;
    value_format_name: decimal_0
  }
  measure: avg_session_duration_minutes{
    group_label: "Basic Counts (Orders / Customers etc.)"
    label: "AVG Session Duration (Minutes)"
    type: average
    hidden: no
    sql: ${session_duration_minutes} ;;
    value_format_name: decimal_2
  }

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
      has_discount_successfully_applied,
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
}
