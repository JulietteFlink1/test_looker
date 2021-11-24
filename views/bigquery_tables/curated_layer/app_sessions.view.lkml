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
      is_new_user,
      has_order
    ]
  }

########### DIMENSIONS ###########
  ## IDs

  dimension: session_uuid {
    group_label: "IDs"
    type: string
    sql: ${TABLE}.session_uuid ;;
    primary_key: yes
    hidden: yes
  }
  dimension: user_id  {
    group_label: "IDs"
    type: string
    sql: ${TABLE}.user_id  ;;
    hidden: yes
  }
  dimension: anonymous_id {
    group_label: "IDs"
    type: string
    sql: ${TABLE}.anonymous_id ;;
  }
  dimension: last_order_id {
    group_label: "IDs"
    type: string
    sql: ${TABLE}.last_order_id ;;
    hidden: yes
  }
  dimension: last_order_uuid {
    group_label: "IDs"
    type: string
    sql: ${TABLE}.last_order_uuid ;;
  }

  ## Device attributes

  dimension: platform {
    group_label: "Device Dimensions"
    type: string
    sql: ${TABLE}.platform ;;
    hidden: yes
  }
  dimension: device_type {
    group_label: "Device Dimensions"
    type: string
    sql: ${TABLE}.device_type ;;
  }
  dimension: app_version {
    group_label: "Device Dimensions"
    type: string
    sql: ${TABLE}.app_version ;;
  }
  dimension: full_app_version {
    group_label: "Device Dimensions"
    type: string
    sql: ${device_type} || '-' || ${app_version} ;;
  }
  dimension: timezone {
    group_label: "Device Dimensions"
    type: string
    sql: ${TABLE}.timezone ;;
    hidden: yes
  }

  ## GENERIC: Dates / Timestamp

  dimension_group: session_start_at {
    group_label: "Generic Dimensions"
    label: "Session Start "
    type: time
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
    group_label: "Generic Dimensions"
    type: time
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
    type: yesno
    sql: ${hub_code} IS NULL ;;
  }
  dimension: is_new_user {
    group_label: "Generic Dimensions"
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
    type: number
    sql: ${TABLE}.delivery_pdt_minutes ;;
  }
  dimension: delivery_lat {
    group_label: "Geo Dimensions"
    type: number
    sql: ${TABLE}.delivery_lat ;;
  }
  dimension: delivery_lng {
    group_label: "Geo Dimensions"
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

  ## Discount / Order attributes

  dimension: has_order {
    group_label: "Order Dimensions"
    type: yesno
    sql: ${TABLE}.has_order ;;
  }
  dimension: has_order_failed_error {
    group_label: "Order Dimensions"
    type: yesno
    sql: ${TABLE}.has_order_failed_error ;;
  }
  dimension: has_payment_failed_error {
    group_label: "Order Dimensions"
    type: yesno
    sql: ${TABLE}.has_payment_failed_error ;;
  }
  dimension: has_discount_attempted {
    group_label: "Order Dimensions"
    type: yesno
    sql: ${TABLE}.has_discount_attempted ;;
  }
  dimension: has_discount_successfully_applied {
    group_label: "Order Dimensions"
    type: yesno
    sql: ${TABLE}.is_discount_successfully_applied ;;
  }
  dimension: order_discount_code {
    group_label: "Order Dimensions"
    type: string
    sql: ${TABLE}.order_discount_code ;;
  }

  ## Session attributes
  dimension: is_session_with_address {
    group_label: "Conversion Dimensions"
    type: yesno
    sql: ${TABLE}.is_session_with_address ;;
  }
  dimension: is_session_with_add_to_cart {
    group_label: "Conversion Dimensions"
    type: yesno
    sql: ${TABLE}.is_session_with_add_to_cart ;;
  }
  dimension: is_session_with_checkout_started {
    group_label: "Conversion Dimensions"
    type: yesno
    sql: ${TABLE}.is_session_with_checkout_started ;;
  }
  dimension: is_session_with_payment_started {
    group_label: "Conversion Dimensions"
    type: yesno
    sql: ${TABLE}.is_session_with_payment_started ;;
  }
  dimension: is_session_with_order_placed {
    group_label: "Conversion Dimensions"
    type: yesno
    sql: ${TABLE}.is_session_with_order_placed ;;
  }

### Custom dimensions
  dimension: session_start_date_granularity {
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
    label: "Session Start Date Granular"
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
    type: count
    drill_fields: [detail*]
  }

  measure: cnt_unique_anonymousid {
    label: "# Unique Users"
    group_label: "Basic Counts (Orders / Customers etc.)"
    description: "Number of Unique Users identified via Anonymous ID from Segment"
    hidden:  no
    type: count_distinct
    sql: ${anonymous_id};;
    value_format_name: decimal_0
  }

  measure: cnt_unique_sessions {
    label: "# Unique Sessions"
    group_label: "Basic Counts (Orders / Customers etc.)"
    description: "Number of Unique Sessions based on sessions_uuid"
    hidden:  no
    type: count_distinct
    sql: ${session_uuid};;
    value_format_name: decimal_0
  }


#### Sessions with events ###
  measure: cnt_has_address {
    group_label: "Sessions Count With"
    label: "Confirmed address
    description: "# sessions in which the user had an address (selected in previous session or current)"
    type: count
    filters: [is_session_with_address: "yes"]
  }

  measure: cnt_add_to_cart {
    group_label: "Sessions Count With"
    label: "Add to cart"
    description: "Number of sessions in which at least one Product Added To Cart event happened"
    type: count
    filters: [is_session_with_add_to_cart: "yes"]
  }

  measure: cnt_checkout_started {
    group_label: "Sessions Count With"
    label: "Checkout started"
    description: "Number of sessions in which at least one Checkout Started event happened"
    type: count
    filters: [is_session_with_checkout_started: "yes"]
  }

  measure: cnt_payment_started {
    group_label: "Sessions Count With"
    label: "Payment started"
    description: "Number of sessions in which at least one Payment Started event happened"
    type: count
    filters: [is_session_with_payment_started: "yes"]
  }

  measure: cnt_purchase {
    group_label: "Sessions Count With"
    label: "Order placed"
    description: "Number of sessions in which at least one Order Placed event happened"
    type: count
    filters: [is_session_with_order_placed: "yes"]
  }

  measure: cnt_discounts_attempted {
    group_label: "Sessions Count With"
    label: "Attempted discounts"
    description: "Number of sessions in which at least one Discount Attempt event happened"
    type: count
    filters: [has_discount_attempted: "yes"]
  }

  measure: cnt_discounts_applied{
    group_label: "Sessions Count With"
    label: "Applied discounts"
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

  ###### Sum of events

  # measure: sum_address_selected {
  #   group_label: "Sessions With Event Count For"
  #   label: "Address confirmed"
  #   type: sum
  #   sql: ${is_session_with_address} ;;
  # }

  # measure: sum_add_to_cart {
  #   group_label: "Sessions With Event Count For"
  #   label: "Add to cart"
  #   type: sum
  #   sql: ${is_session_with_add_to_cart} ;;
  # }

  # measure: sum_checkout_started {
  #   group_label: "Sessions With Event Count For"
  #   label: "Checkout started"
  #   type: sum
  #   sql: ${is_session_with_checkout_started} ;;
  # }

  # measure: sum_payment_started {
  #   group_label: "Sessions With Event Count For"
  #   label: "Payment started"
  #   type: sum
  #   sql: ${is_session_with_payment_started} ;;
  # }

  # measure: sum_purchases {
  #   group_label: "Sessions With Event Count For"
  #   label: "Order placed"
  #   type: sum
  #   sql: ${is_session_with_order_placed} ;;
  # }

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
    label: "SUM AMT Discount (Gross)"
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
    label: "SUM of Orders Placed"
    type: sum
    hidden: no
    sql: ${number_of_orders_placed} ;;
    value_format_name: decimal_0
  }
  measure: sum_items_in_cart{
    group_label: "Basic Counts (Orders / Customers etc.)"
    label: "SUM of Items in Cart"
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
    label: "SUM Session Duration (Minutes)"
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
