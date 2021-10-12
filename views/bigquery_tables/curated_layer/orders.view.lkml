view: orders {
  sql_table_name: `flink-data-prod.curated.orders`
    ;;

  view_label: "* Orders *"
  drill_fields: [core_dimensions*]

  set: core_dimensions {
    fields: [
      country_iso,
      id,
      warehouse_name,
      created_raw,
      customer_type,
      gmv_gross,
      discount_amount,
      delivery_eta_timestamp_raw,
      delivery_timestamp_raw
    ]
  }

  dimension: acceptance_time {
    type: number
    hidden: yes
    sql: ${TABLE}.acceptance_time_minutes ;;
  }

  dimension: shipping_price_gross_amount {
    type: number
    hidden: yes
    sql: ${TABLE}.amt_delivery_fee_gross ;;
  }

  dimension: shipping_price_net_amount {
    type: number
    hidden: yes
    sql: ${TABLE}.amt_delivery_fee_net ;;
  }

  dimension: discount_amount {
    type: number
    hidden: yes
    sql: ${TABLE}.amt_discount_gross ;;
  }

  dimension: amt_discount_net {
    type: number
    hidden: yes
    sql: ${TABLE}.amt_discount_net ;;
  }

  dimension: gmv_gross {
    type: number
    hidden: yes
    sql: ${TABLE}.amt_gmv_gross ;;
  }

  dimension: gmv_gross_tier {
    group_label: "* Monetary Values *"
    type: tier
    tiers: [0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36, 38, 40, 42, 44, 46, 48, 50, 52, 54, 56, 58, 60, 62, 64, 66, 68, 70]
    style: relational
    sql: ${total_gross_amount} + ${discount_amount} ;;
  }

  dimension: gmv_gross_tier_5 {
    group_label: "* Monetary Values *"
    type: tier
    tiers: [0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70]
    style: relational
    sql: ${total_gross_amount} + ${discount_amount} ;;
  }

  dimension: gmv_net {
    type: number
    hidden: yes
    sql: ${TABLE}.amt_gmv_net ;;
  }

  ############################## needs to be checked #################################

  dimension: tracking_client_id {
    group_label: "* IDs *"
    hidden: yes
    type: string
    sql: null ;;
  }

  ############################## needs to be checked #################################

  dimension: total_gross_amount {
    type: number
    hidden: yes
    sql: ${TABLE}.amt_revenue_gross ;;
  }

  dimension: total_net_amount {
    type: number
    hidden: yes
    sql: ${TABLE}.amt_revenue_net ;;
  }

  dimension: anonymous_id {
    type: string
    group_label: "* IDs *"
    hidden: no
    sql: ${TABLE}.anonymous_id ;;
  }

  dimension: backend_source {
    type: string
    sql: ${TABLE}.backend_source ;;
    hidden: yes
  }

  dimension: billing_address_id {
    group_label: "* IDs *"
    hidden: yes
    type: number
    sql: ${TABLE}.billing_address_id ;;
  }

  dimension: cart_id {
    group_label: "* IDs *"
    hidden: yes
    type: string
    sql: ${TABLE}.cart_id ;;
  }

  dimension: country_iso {
    group_label: "* Geographic Dimensions *"
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: currency {
    group_label: "* Monetary Values *"
    type: string
    sql: ${TABLE}.currency ;;
  }

  dimension: user_email {
    group_label: "* User Dimensions *"
    type: string
    sql: ${TABLE}.customer_email ;;
  }

  dimension: user_id {
    group_label: "* IDs *"
    hidden: no
    type: string
    sql: ${TABLE}.customer_id ;;
  }

  dimension: customer_note {
    group_label: "* User Dimensions *"
    label: "Add. Customer Information"
    type: string
    sql: ${TABLE}.customer_note ;;
  }

  dimension: shipping_address_id {
    group_label: "* IDs *"
    hidden: yes
    type: string
    sql: ${TABLE}.delivery_address_id ;;
  }

  dimension: delivery_eta_minutes {
    group_label: "* Operations / Logistics *"
    type: number
    sql: ${TABLE}.delivery_pdt_minutes ;;
  }

  dimension_group: now {
    group_label: "* Dates and Timestamps *"
    label: "Now"
    description: "Current Date/Time"
    type: time
    timeframes: [
      raw,
      hour_of_day,
      hour,
      time,
      date,
      day_of_week,
      week,
      month,
      quarter,
      year
    ]
    sql: current_timestamp;;
    datatype: timestamp
  }

  dimension_group: created {
    group_label: "* Dates and Timestamps *"
    label: "Order"
    description: "Order Placement Date"
    type: time
    timeframes: [
      raw,
      minute15,
      minute30,
      hour_of_day,
      hour,
      time,
      date,
      day_of_week,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.order_timestamp ;;
    datatype: timestamp
  }

  dimension: is_order_hour_before_now_hour {
    group_label: "* Operations / Logistics *"
    type: yesno
    sql: ${created_hour_of_day} <= ${now_hour_of_day} ;;
  }

  dimension_group: delivery_eta_timestamp {
    group_label: "* Dates and Timestamps *"
    type: time
    timeframes: [
          raw,
          minute15,
          minute30,
          hour_of_day,
          time,
          date,
          week,
          month,
          quarter,
          year
    ]
    sql: ${TABLE}.delivery_pdt_timestamp ;;
  }

  dimension: delivery_delay_since_eta {
    group_label: "* Operations / Logistics *"
    label: "Delta to PDT (min)"
    type: duration_minute
    sql_start: ${delivery_eta_timestamp_raw};;
    sql_end: ${delivery_timestamp_raw};;
  }

  dimension: delivery_id {
    hidden: yes
    group_label: "* IDs *"
    type: string
    sql: ${TABLE}.delivery_id ;;
  }

  dimension: delivery_method {
    group_label: "* Order Dimensions *"
    type: string
    sql: ${TABLE}.delivery_method ;;
  }

  dimension: delivery_provider {
    group_label: "* Order Dimensions *"
    type: string
    sql: ${TABLE}.delivery_provider ;;
  }

  dimension: delivery_time {
    group_label: "* Operations / Logistics *"
    type: number
    sql: ${TABLE}.delivery_time_minutes ;;
  }

  dimension: discount_code {
    group_label: "* Order Dimensions *"
    type: string
    sql: ${TABLE}.discount_code ;;
  }

  dimension: voucher_id {
    group_label: "* IDs *"
    hidden: yes
    type: string
    sql: ${TABLE}.discount_id ;;
  }

  dimension: discount_name {
    group_label: "* Order Dimensions *"
    type: string
    sql: ${TABLE}.discount_name ;;
  }

  dimension: fulfillment_time {
    group_label: "* Operations / Logistics *"
    type: number
    sql: ${TABLE}.fulfillment_time_minutes ;;
  }

  dimension: fulfillment_time_raw_minutes {
    group_label: "* Operations / Logistics *"
    type: number
    sql: ${TABLE}.fulfillment_time_raw_minutes ;;
  }

  dimension: hub_code {
    group_label: "* Hub Dimensions *"
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: warehouse_name {
    label: "Hub Name"
    group_label: "* Hub Dimensions *"
    type: string
    sql: ${TABLE}.hub_name ;;
  }

  dimension: fulfillment_time_tier {
    group_label: "* Operations / Logistics *"
    type: tier
    tiers: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30]
    style: interval
    sql: ${fulfillment_time} ;;
  }

  dimension: acceptance_time_tier {
    group_label: "* Operations / Logistics *"
    type: tier
    tiers: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30]
    style: interval
    sql: ${acceptance_time} ;;
  }

  dimension: reaction_time_tier {
    group_label: "* Operations / Logistics *"
    type: tier
    tiers: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30]
    style: interval
    sql: ${reaction_time} ;;
  }

  dimension: is_delivery_more_than_30_minute {
    group_label: "* Operations / Logistics *"
    type: yesno
    sql: ${TABLE}.is_delivery_above_30min ;;
  }

  dimension: is_delivery_eta_available {
    group_label: "* Operations / Logistics *"
    type: yesno
    sql: ${TABLE}.is_delivery_pdt_available ;;
  }

  dimension: is_voucher_order{
    group_label: "* Order Dimensions *"
    type: yesno
    sql: ${TABLE}.is_discounted_order ;;
  }

  dimension: is_first_order {
    group_label: "* Order Dimensions *"
    type: yesno
    sql: ${TABLE}.is_first_order ;;
  }

  dimension: is_fulfillment_more_than_30_minute {
    group_label: "* Operations / Logistics *"
    hidden: yes
    type: yesno
    sql: ${TABLE}.is_fulfillment_above_30min ;;
  }

  dimension: is_fulfillment_less_than_1_minute {
    hidden: yes
    group_label: "* Operations / Logistics *"
    type: yesno
    sql: ${fulfillment_time} < 1 ;;
  }

  dimension: is_acceptance_less_than_0_minute {
    hidden: yes
    group_label: "* Operations / Logistics *"
    type: yesno
    sql: ${acceptance_time} < 0 ;;
  }

  dimension: is_acceptance_more_than_30_minute {
    hidden: yes
    group_label: "* Operations / Logistics *"
    type: yesno
    sql: ${acceptance_time} > 30 ;;
  }

  dimension: is_reaction_less_than_0_minute {
    hidden: yes
    group_label: "* Operations / Logistics *"
    type: yesno
    sql: ${reaction_time} < 0 ;;
  }

  dimension: is_reaction_more_than_30_minute {
    hidden: yes
    group_label: "* Operations / Logistics *"
    type: yesno
    sql: ${reaction_time} > 30 ;;
  }

  dimension: is_delivery_less_than_0_minute {
    hidden: yes
    group_label: "* Operations / Logistics *"
    type: yesno
    sql: ${delivery_time} < 0 ;;
  }

  dimension: is_picking_less_than_0_minute {
    hidden: yes
    group_label: "* Operations / Logistics *"
    type: yesno
    sql: ${time_diff_between_two_subsequent_fulfillments} < 0 ;;
  }

  dimension: is_picking_more_than_30_minute {
    hidden: yes
    group_label: "* Operations / Logistics *"
    type: yesno
    sql: ${time_diff_between_two_subsequent_fulfillments} > 30 ;;
  }

  dimension: is_internal_order {
    group_label: "* Order Dimensions *"
    type: yesno
    sql: ${TABLE}.is_internal_order ;;
  }

  dimension: is_order_delay_above_10min {
    group_label: "* Operations / Logistics *"
    type: yesno
    sql: ${TABLE}.is_order_delay_above_10min ;;
  }

  dimension: is_order_delay_above_5min {
    group_label: "* Operations / Logistics *"
    type: yesno
    sql: ${TABLE}.is_order_delay_above_5min ;;
  }

  dimension: is_order_on_time {
    group_label: "* Operations / Logistics *"
    type: yesno
    sql: ${TABLE}.is_order_on_time ;;
  }

  dimension: is_successful_order {
    group_label: "* Order Dimensions *"
    type: yesno
    sql: ${TABLE}.is_successful_order ;;
  }

  dimension: language_code {
    group_label: "* Geographic Dimensions *"
    type: string
    sql: ${TABLE}.language_code ;;
  }

  dimension_group: last_modified {
    group_label: "* Dates and Timestamps *"
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.last_modified_at ;;
  }

  dimension: latitude {
    group_label: "* User Dimensions *"
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    group_label: "* User Dimensions *"
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: customer_location {
    group_label: "* User Dimensions *"
    type: location
    sql_latitude: ${latitude} ;;
    sql_longitude: ${longitude} ;;
  }

  dimension: customer_type {
    group_label: "* User Dimensions *"
    type: string
    sql: CASE WHEN ${is_first_order} is True
        THEN 'New Customer' ELSE 'Existing Customer' END ;;
  }

  dimension: no_distinct_skus {
    group_label: "* Order Dimensions *"
    type: number
    sql: ${TABLE}.number_of_distinct_skus ;;
  }

  dimension: number_of_items {
    group_label: "* Order Dimensions *"
    type: number
    sql: ${TABLE}.number_of_items ;;
  }

  dimension: quantity_fulfilled {
    group_label: "* Order Dimensions *"
    type: number
    sql: ${TABLE}.number_of_items ;;
  }

  dimension_group: order_date_30_min_bins {
    group_label: "* Dates and Timestamps *"
    label: "Order Date - 30 min bins"
    sql:SUBSTRING(${created_minute30}, 12, 16);;
  }

  ##################################################### CROSS REFERENCES - MOVED TO projects.cleaning.user_order_facts_clean & hub_order_facts_clean

##### helping dimensions for hiding incomplete cohorts #####

  #dimension_group: time_since_sign_up {
  #  group_label: "* User Dimensions *"
  #  type: duration
  #  sql_start: ${user_order_facts.first_order_raw} ;;
  #  sql_end: ${created_raw} ;;
  #}

  #dimension_group: time_between_sign_up_month_and_now {
  #  group_label: "* User Dimensions *"
  #  hidden: yes
  #  type: duration
  #  sql_start: DATE_TRUNC(${user_order_facts.first_order_raw}, MONTH) ;;
  #  sql_end: ${now_raw} ;;
  #}

  #dimension_group: time_between_sign_up_week_and_now {
  #  group_label: "* User Dimensions *"
  #  hidden: yes
  #  type: duration
  #  sql_start: DATE_TRUNC(${user_order_facts.first_order_raw}, WEEK) ;;
  #  sql_end: ${now_raw} ;;
  #}


  #dimension: time_since_sign_up_biweekly {
  #  group_label: "* User Dimensions *"
  #  type: number
  #  sql: floor((${user_order_facts_clean.days_time_since_sign_up} / 14)) ;;
  #  value_format: "0"
  #}

  ##################################################### CROSS REFERENCES - MOVED TO projects.cleaning.user_order_facts_clean & hub_order_facts_clean


  dimension: order_date {
    group_label: "* Dates and Timestamps *"
    type: date
    datatype: date
    sql: ${TABLE}.order_date ;;
    hidden: yes
  }

  dimension_group: delivery_timestamp {
    group_label: "* Dates and Timestamps *"
    type: time
    timeframes: [
      raw,
      minute15,
      minute30,
      hour_of_day,
      time,
      date,
      day_of_week,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.order_delivered_timestamp ;;
    datatype: timestamp
  }

  dimension: order_dow {
    group_label: "* Dates and Timestamps *"
    type: string
    sql: ${TABLE}.order_dow ;;
    hidden: yes
  }

  dimension: order_hour {
    group_label: "* Dates and Timestamps *"
    type: number
    sql: ${TABLE}.order_hour ;;
    hidden: yes
  }

  dimension: hour {
    group_label: "* Dates and Timestamps *"
    type: number
    sql: extract(hour from ${created_raw} AT TIME ZONE 'Europe/Berlin') ;;
  }

  dimension: id {
    group_label: "* IDs *"
    label: "Order ID"
    hidden: no
    type: string
    sql: ${TABLE}.order_id ;;
  }

  dimension: order_month {
    group_label: "* Dates and Timestamps *"
    type: string
    sql: ${TABLE}.order_month ;;
    hidden: yes
  }

  dimension: order_number {
    group_label: "* IDs *"
    type: string
    sql: ${TABLE}.order_number ;;
  }

  dimension: order_on_route_timestamp {
    group_label: "* Operations / Logistics *"
    type: date_time
    sql: ${TABLE}.order_on_route_timestamp ;;
  }

  dimension: order_packed_timestamp {
    group_label: "* Operations / Logistics *"
    type: date_time
    sql: ${TABLE}.order_packed_timestamp ;;
  }

  dimension: order_picker_accepted_timestamp {
    group_label: "* Operations / Logistics *"
    type: date_time
    sql: ${TABLE}.order_picker_accepted_timestamp ;;
  }

  dimension: order_rider_claimed_timestamp {
    group_label: "* Operations / Logistics *"
    type: date_time
    sql: ${TABLE}.order_rider_claimed_timestamp ;;
  }

  dimension: order_uuid {
    type: string
    group_label: "* IDs *"
    label: "Order UUID"
    primary_key: yes
    hidden: no
    sql: ${TABLE}.order_uuid ;;
  }

  dimension: order_week {
    group_label: "* Dates and Timestamps *"
    type: date_time
    convert_tz: no
    sql: ${TABLE}.order_week ;;
    hidden: yes
  }

  dimension: order_year {
    group_label: "* Dates and Timestamps *"
    type: number
    sql: ${TABLE}.order_year ;;
    hidden: yes
  }

  dimension: payment_type {
    group_label: "* Order Dimensions *"
    type: string
    sql: ${TABLE}.payment_type ;;
  }

  dimension: payment_method {
    group_label: "* Order Dimensions *"
    type: string
    sql: ${TABLE}.payment_method ;;
  }

  dimension: payment_company {
    group_label: "* Order Dimensions *"
    type: string
    sql: ${TABLE}.payment_company ;;
  }

  dimension: platform {
    group_label: "* Order Dimensions *"
    type: string
    sql: ${TABLE}.platform ;;
  }

  dimension: picker_id {
    hidden: yes
    group_label: "* IDs *"
    type: string
    sql: ${TABLE}.picker_id ;;
  }

  dimension: time_diff_between_two_subsequent_fulfillments {
    group_label: "* Operations / Logistics *"
    label: "Picking Time Minutes"
    type: number
    sql: ${TABLE}.picking_time_minutes ;;
  }

  dimension: reaction_time {
    group_label: "* Operations / Logistics *"
    label: "Reaction Time Minutes"
    type: number
    sql: ${TABLE}.reaction_time_minutes ;;
  }

  dimension: rider_id {
    hidden: yes
    group_label: "* IDs *"
    type: string
    sql: ${TABLE}.rider_id ;;
  }

  dimension: shipping_city {
    group_label: "* Geographic Dimensions *"
    type: string
    sql: ${TABLE}.shipping_city ;;
  }

  dimension: shipping_method_id {
    hidden: yes
    group_label: "* IDs *"
    type: number
    sql: ${TABLE}.shipping_method_id ;;
  }

  dimension: shipping_method_name {
    group_label: "* Order Dimensions *"
    type: string
    sql: ${TABLE}.shipping_method_name ;;
  }

  dimension: status {
    group_label: "* Order Dimensions *"
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: timezone {
    hidden: yes
    group_label: "* Dates and Timestamps *"
    type: string
    sql: ${TABLE}.timezone ;;
  }

  ####################################################### Needs to be checked ##################################

  dimension: token {
    hidden: yes
    group_label: "* IDs *"
    type: string
    sql: null ;;
  }

   ####################################################### Needs to be checked ##################################

  dimension: translated_discount_name {
    hidden: yes
    type: string
    sql: ${TABLE}.translated_discount_name ;;
  }

  dimension: weight {
    hidden: yes
    type: number
    sql: ${TABLE}.weight ;;
  }

  dimension: is_customer_location_available {
    group_label: "* Operations / Logistics *"
    type: yesno
    sql: IF(${customer_location::latitude} IS NULL, FALSE, TRUE)  ;;
  }

  dimension: is_business_week_completed {
    group_label: "* Dates and Timestamps *"
    type: yesno
    sql:  CASE WHEN ${now_day_of_week} = 'Sunday'
              THEN IF (${created_week} <= ${now_week}, TRUE, FALSE)
              ELSE IF (${created_week} < ${now_week}, TRUE, FALSE)
          END
              ;;
  }



  ######## PARAMETERS

  parameter: date_granularity {
    group_label: "* Dates and Timestamps *"
    label: "Date Granularity"
    type: unquoted
    allowed_value: { value: "Day" }
    allowed_value: { value: "Week" }
    allowed_value: { value: "Month" }
    default_value: "Day"
  }

  parameter: KPI_parameter {
    label: "* KPI Parameter *"
    type: unquoted
    allowed_value: { value: "orders" label: "# Orders"}
    allowed_value: { value: "unique_customers" label: "# Unique Customers" }
    allowed_value: { value: "orders_existing_customers" label: "# Orders Existing Customers" }
    allowed_value: { value: "orders_new_customers" label: "# Orders New Customers"}
    allowed_value: { value: "share_of_orders_delivered_in_time" label: "% Orders Delivered In Time"}
    allowed_value: { value: "share_of_orders_delayed_5min" label: "% Orders Delayed >5min"}
    allowed_value: { value: "share_of_orders_delayed_10min" label: "% Orders Delayed >10min"}
    allowed_value: { value: "share_of_orders_delayed_15min" label: "% Orders Delayed >15min"}
    #allowed_value: { value: "share_of_total_orders" label: "% Of Total Orders"}
    allowed_value: { value: "gmv_gross" label: "GMV (Gross)"}
    allowed_value: { value: "gmv_net" label: "GMV (Net)"}
    allowed_value: { value: "revenue_gross" label: "Revenue (Gross)"}
    allowed_value: { value: "revenue_net" label: "Revenue (Net)"}
    allowed_value: { value: "discount_amount" label: "Discount Amount"}
    allowed_value: { value: "AVG_fulfillment_time" label: "AVG Fulfillment Time"}
    allowed_value: { value: "AVG_order_value_gross" label: "AVG Order Value (Gross)"}
    allowed_value: { value: "AVG_order_value_net" label: "AVG Order Value (Net)"}
    allowed_value: { value: "rider_utr" label: "Rider UTR"}
    allowed_value: { value: "picker_utr" label: "Picker UTR"}
    allowed_value: { value: "picker_hours" label: "# Picker Hours"}
    allowed_value: { value: "rider_hours" label: "# Rider Hours"}
    allowed_value: { value: "pickers" label: "# Pickers"}
    allowed_value: { value: "riders" label: "# Riders"}
    default_value: "orders"
  }

  ######## DYNAMIC DIMENSIONS

  dimension: date {
    group_label: "* Dates and Timestamps *"
    label: "Date (Dynamic)"
    label_from_parameter: date_granularity
    sql:
    {% if date_granularity._parameter_value == 'Day' %}
      ${created_date}
    {% elsif date_granularity._parameter_value == 'Week' %}
      ${created_week}
    {% elsif date_granularity._parameter_value == 'Month' %}
      ${created_month}
    {% endif %};;
  }

  dimension: date_granularity_pass_through {
    group_label: "* Parameters *"
    description: "To use the parameter value in a table calculation (e.g WoW, % Growth) we need to materialize it into a dimension "
    type: string
    hidden: no # yes
    sql:
            {% if date_granularity._parameter_value == 'Day' %}
              "Day"
            {% elsif date_granularity._parameter_value == 'Week' %}
              "Week"
            {% elsif date_granularity._parameter_value == 'Month' %}
              "Month"
            {% endif %};;
  }

  ########## Measures

  measure: KPI {
    group_label: "* Dynamic KPI Fields *"
    label: "KPI - Dynamic"
    label_from_parameter: KPI_parameter
    value_format: "#,##0.00"
    type: number
    sql:
    {% if KPI_parameter._parameter_value == 'orders' %}
      ${cnt_orders}
    {% elsif KPI_parameter._parameter_value == 'unique_customers' %}
      ${cnt_unique_customers}
    {% elsif KPI_parameter._parameter_value == 'orders_existing_customers' %}
      ${cnt_unique_orders_existing_customers}
    {% elsif KPI_parameter._parameter_value == 'orders_new_customers' %}
      ${cnt_unique_orders_new_customers}
    {% elsif KPI_parameter._parameter_value == 'share_of_orders_delivered_in_time' %}
      ${pct_delivery_in_time}*100
    {% elsif KPI_parameter._parameter_value == 'share_of_orders_delayed_5min' %}
      ${pct_delivery_late_over_5_min}*100
    {% elsif KPI_parameter._parameter_value == 'share_of_orders_delayed_10min' %}
      ${pct_delivery_late_over_10_min}*100
    {% elsif KPI_parameter._parameter_value == 'share_of_orders_delayed_15min' %}
      ${pct_delivery_late_over_15_min}*100
    --{% elsif KPI_parameter._parameter_value == 'share_of_total_orders' %}
    --  ${percent_of_total_orders}*100
    {% elsif KPI_parameter._parameter_value == 'gmv_gross' %}
      ${sum_gmv_gross}
    {% elsif KPI_parameter._parameter_value == 'gmv_net' %}
      ${sum_gmv_net}
    {% elsif KPI_parameter._parameter_value == 'revenue_gross' %}
      ${sum_revenue_gross}
    {% elsif KPI_parameter._parameter_value == 'revenue_net' %}
      ${sum_revenue_net}
    {% elsif KPI_parameter._parameter_value == 'discount_amount' %}
      ${sum_discount_amt}
    {% elsif KPI_parameter._parameter_value == 'AVG_fulfillment_time' %}
      ${avg_fulfillment_time}
    {% elsif KPI_parameter._parameter_value == 'AVG_order_value_gross' %}
      ${avg_order_value_gross}
    {% elsif KPI_parameter._parameter_value == 'AVG_order_value_net' %}
      ${avg_order_value_net}
    {% elsif KPI_parameter._parameter_value == 'rider_utr' %}
      ${shyftplan_riders_pickers_hours.rider_utr}
    {% elsif KPI_parameter._parameter_value == 'picker_utr' %}
      ${shyftplan_riders_pickers_hours.picker_utr}
    {% elsif KPI_parameter._parameter_value == 'picker_hours' %}
      ${shyftplan_riders_pickers_hours.picker_hours}
    {% elsif KPI_parameter._parameter_value == 'rider_hours' %}
      ${shyftplan_riders_pickers_hours.rider_hours}
    {% elsif KPI_parameter._parameter_value == 'pickers' %}
      ${shyftplan_riders_pickers_hours.pickers}
    {% elsif KPI_parameter._parameter_value == 'riders' %}
      ${shyftplan_riders_pickers_hours.riders}
    {% endif %};;

      html:
          {% if KPI_parameter._parameter_value == 'share_of_orders_delivered_in_time' %}
            {{ rendered_value | round: 2  | append: "%" }}
          {% elsif KPI_parameter._parameter_value == 'share_of_orders_delayed_5min' %}
            {{ rendered_value | round: 2  | append: "%" }}
          {% elsif KPI_parameter._parameter_value == 'share_of_orders_delayed_10min' %}
            {{ rendered_value | round: 2  | append: "%" }}
          {% elsif KPI_parameter._parameter_value == 'share_of_orders_delayed_15min' %}
            {{ rendered_value | round: 2  | append: "%" }}
          {% elsif KPI_parameter._parameter_value == 'share_of_total_orders' %}
            {{ rendered_value | round: 2  | append: "%" }}
          {% elsif KPI_parameter._parameter_value == 'gmv_gross' %}
            €{{ value | round }}
          {% elsif KPI_parameter._parameter_value == 'gmv_net' %}
            €{{ value | round }}
          {% elsif KPI_parameter._parameter_value == 'revenue_gross' %}
            €{{ value | round }}
          {% elsif KPI_parameter._parameter_value == 'revenue_net' %}
            €{{ value | round }}
          {% elsif KPI_parameter._parameter_value == 'discount_amount' %}
            €{{ value | round }}
          {% elsif KPI_parameter._parameter_value == 'AVG_fulfillment_time' %}
            {{ rendered_value }}
          {% elsif KPI_parameter._parameter_value == 'AVG_order_value_gross' %}
            €{{ rendered_value }}
          {% elsif KPI_parameter._parameter_value == 'AVG_order_value_net' %}
            €{{ rendered_value }}
          {% elsif KPI_parameter._parameter_value == 'rider_utr' %}
            {{ rendered_value }}
          {% elsif KPI_parameter._parameter_value == 'picker_utr' %}
            {{ rendered_value }}
          {% elsif KPI_parameter._parameter_value == 'picker_hours' %}
            {{ value | round }}
          {% elsif KPI_parameter._parameter_value == 'rider_hours' %}
            {{ value | round }}
          {% else %}
            {{ value }}
          {% endif %};;

      }


  ##############
  ## AVERAGES ##
  ##############


  measure: count {
    type: count
    drill_fields: [translated_discount_name, shipping_method_name, warehouse_name, discount_name]
  }

  measure: avg_promised_eta {
    group_label: "* Operations / Logistics *"
    label: "AVG PDT"
    description: "Average Promised Fulfillment Time (PDT)"
    hidden:  no
    type: average
    sql: ${delivery_eta_minutes};;
    value_format: "0.0"
  }

  measure: avg_fulfillment_time {
    group_label: "* Operations / Logistics *"
    label: "AVG Fulfillment Time (decimal)"
    description: "Average Fulfillment Time (decimal minutes) considering order placement to delivery. Outliers excluded (<1min or >30min)"
    hidden:  no
    type: average
    sql: ${fulfillment_time};;
    value_format: "0.0"
  }

  measure: avg_fulfillment_time_mm_ss {
    group_label: "* Operations / Logistics *"
    label: "AVG Fulfillment Time (MM:SS)"
    description: "Average Fulfillment Time considering order placement to delivery. Outliers excluded (<1min or >30min)"
    type: average
    sql: ${fulfillment_time} * 60 / 86400.0;;
    value_format: "mm:ss"
  }

  measure: avg_delivery_time {
    group_label: "* Operations / Logistics *"
    label: "AVG Delivery Time"
    description: "Average Delivery Time considering delivery start to delivery completion. Outliers excluded (<0min or >30min)"
    hidden:  no
    type: average
    sql: ${delivery_time};;
    value_format: "0.0"
  }



  measure: avg_reaction_time {
    group_label: "* Operations / Logistics *"
    label: "AVG Reaction Time"
    description: "Average Reaction Time of the Picker considering order placement to first fulfillment created. Outliers excluded (<0min or >30min)"
    hidden:  no
    type: average
    sql:${reaction_time};;
    value_format: "0.0"
  }

  measure: avg_picking_time {
    group_label: "* Operations / Logistics *"
    label: "AVG Picking Time"
    description: "Average Picking Time considering first fulfillment to second fulfillment created. Outliers excluded (<0min or >30min)"
    hidden:  no
    type: average
    sql:${time_diff_between_two_subsequent_fulfillments};;
    value_format: "0.0"
  }

  measure: avg_acceptance_time {
    group_label: "* Operations / Logistics *"
    label: "AVG Acceptance Time"
    description: "Average Acceptance Time of the Rider considering second fulfillment created until Tracking Timestamp. Outliers excluded (<0min or >30min)"
    hidden:  no
    type: average
    sql:${acceptance_time};;
    value_format: "0.0"
  }

  measure: avg_order_value_gross {
    group_label: "* Monetary Values *"
    label: "AVG Order Value (Gross)"
    description: "Average value of orders considering total gross order values. Includes fees (gross), before deducting discounts."
    hidden:  no
    type: average
    sql: ${gmv_gross};;
    value_format_name: euro_accounting_2_precision
  }

  measure: avg_order_value_net {
    group_label: "* Monetary Values *"
    label: "AVG Order Value (Net)"
    description: "Average value of orders considering total net order values. Includes fees (net), before deducting discounts."
    hidden:  no
    type: average
    sql: ${gmv_net};;
    value_format_name: euro_accounting_2_precision
  }

  measure: avg_product_value_gross {
    group_label: "* Monetary Values *"
    label: "AVG Product Value (Gross)"
    description: "Average value of product items (incl. VAT). Excludes fees (gross), before deducting discounts."
    hidden:  no
    type: average
    sql: ${gmv_gross} - ${shipping_price_gross_amount};;
    value_format_name: euro_accounting_2_precision
  }

  measure: avg_product_value_net {
    group_label: "* Monetary Values *"
    label: "AVG Product Value (Net)"
    description: "Average value of product items (excl. VAT). Excludes fees (net), before deducting discounts."
    hidden:  no
    type: average
    sql: ${gmv_net} - ${shipping_price_net_amount};;
    value_format_name: euro_accounting_2_precision
  }

  measure: avg_delivery_fee_gross {
    group_label: "* Monetary Values *"
    label: "AVG Delivery Fee (Gross)"
    description: "Average value of Delivery Fees (Gross)"
    hidden:  no
    type: average
    sql: ${shipping_price_gross_amount};;
    value_format_name: euro_accounting_2_precision
  }

  measure: avg_delivery_fee_net {
    group_label: "* Monetary Values *"
    label: "AVG Delivery Fee (Net)"
    description: "Average value of Delivery Fees (Net)"
    hidden:  no
    type: average
    sql: ${shipping_price_net_amount};;
    value_format_name: euro_accounting_2_precision
  }

  measure: avg_number_items {
    group_label: "* Basic Counts (Orders / Customers etc.) *"
    label: "AVG # items"
    description: "Average number of items per order"
    hidden:  no
    type: number
    sql: ${sum_quantity_fulfilled}/nullif(${cnt_orders},0);;
    value_format_name: decimal_1
  }

  ##########
  ## SUMS ##
  ##########

  measure: sum_gmv_gross {
    group_label: "* Monetary Values *"
    label: "SUM GMV (Gross)"
    description: "Sum of Gross Merchandise Value of orders incl. fees and before deduction of discounts (incl. VAT)"
    hidden:  no
    type: sum
    sql: ${gmv_gross};;
    value_format_name: euro_accounting_0_precision
  }

  measure: sum_gmv_net {
    group_label: "* Monetary Values *"
    label: "SUM GMV (Net)"
    description: "Sum of Gross Merchandise Value of orders incl. fees and before deduction of discounts (excl. VAT)"
    hidden:  no
    type: sum
    sql: ${gmv_net};;
    value_format_name: euro_accounting_0_precision
  }

  measure: sum_revenue_gross {
    group_label: "* Monetary Values *"
    label: "SUM Revenue (gross)"
    description: "Sum of Revenue (GMV after subsidies) incl. VAT"
    hidden:  no
    type: sum
    sql: ${total_gross_amount};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_revenue_net {
    group_label: "* Monetary Values *"
    label: "SUM Revenue (Net)"
    description: "Sum of Revenue (GMV after subsidies) excl. VAT"
    hidden:  no
    type: sum
    sql: ${total_net_amount};;
    value_format_name: euro_accounting_0_precision
  }

  measure: sum_discount_amt {
    group_label: "* Monetary Values *"
    label: "SUM Discount Amount"
    description: "Sum of Discount amount applied on orders"
    hidden:  no
    type: sum
    sql: ${discount_amount};;
    value_format_name: euro_accounting_0_precision
  }

  measure: sum_delivery_fee_gross {
    group_label: "* Monetary Values *"
    label: "SUM Delivery Fee (Gross)"
    description: "Sum of Delivery Fees (Gross) paid by Customers"
    hidden:  no
    type: sum
    sql: ${shipping_price_gross_amount};;
    value_format_name: euro_accounting_0_precision
  }

  measure: sum_delivery_fee_net {
    group_label: "* Monetary Values *"
    label: "SUM Delivery Fee (Net)"
    description: "Sum of Delivery Fees (Net) paid by Customers"
    hidden:  no
    type: sum
    sql: ${shipping_price_net_amount};;
    value_format_name: euro_accounting_0_precision
  }

  measure: sum_quantity_fulfilled {
    label: "Item Quantity Fulfilled"
    group_label: "* Basic Counts (Orders / Customers etc.) *"
    description: "Fulfilled Quantity"
    type: sum
    sql: ${number_of_items} ;;
  }

  ############
  ## COUNTS ##
  ############

  measure: cnt_unique_customers {
    group_label: "* Basic Counts (Orders / Customers etc.) *"
    label: "# Unique Customers"
    description: "Count of Unique Customers identified via their Email"
    hidden:  no
    type: count_distinct
    sql: ${user_email};;
    value_format: "0"
  }

  measure: cnt_unique_customers_with_voucher {
    group_label: "* Basic Counts (Orders / Customers etc.) *"
    label: "# Unique Customers (with Voucher)"
    description: "Count of Unique Customers identified via their Email (only considering orders with a voucher)"
    hidden:  no
    type: count_distinct
    sql: ${user_email};;
    filters: [discount_amount: ">0"]
    value_format: "0"
  }

  measure: cnt_unique_customers_without_voucher {
    group_label: "* Basic Counts (Orders / Customers etc.) *"
    label: "# Unique Customers (without Voucher)"
    description: "Count of Unique Customers identified via their Email (not considering orders with a voucher)"
    hidden:  no
    type: count_distinct
    sql: ${user_email};;
    filters: [discount_amount: "0 OR null"]
    value_format: "0"
  }

  measure: cnt_unique_hubs {
    group_label: "* Basic Counts (Orders / Customers etc.) *"
    label: "# Unique Hubs"
    description: "Count of Unique Hubs which received orders"
    hidden:  no
    type: count_distinct
    sql: ${warehouse_name};;
    value_format: "0"
  }

  measure: cnt_orders {
    group_label: "* Basic Counts (Orders / Customers etc.) *"
    label: "# Orders"
    description: "Count of successful Orders"
    hidden:  no
    type: count
    value_format: "0"
  }

  measure: cnt_orders_with_discount {
    group_label: "* Basic Counts (Orders / Customers etc.) *"
    label: "# Orders with Discount"
    description: "Count of successful Orders with some Discount applied"
    hidden:  no
    type: count
    filters: [discount_amount: ">0"]
    value_format: "0"
  }

  measure: cnt_orders_without_discount {
    group_label: "* Basic Counts (Orders / Customers etc.) *"
    label: "# Orders without Discount"
    description: "Count of successful Orders with no Discount applied"
    hidden:  no
    type: count
    filters: [discount_amount: "0 OR null"]
    value_format: "0"
  }

  measure: cnt_unique_orders_new_customers {
    group_label: "* Basic Counts (Orders / Customers etc.) *"
    label: "# Orders New Customers"
    description: "Count of successful Orders placed by new customers (Acquisitions)"
    hidden:  no
    type: count
    value_format: "0"
    filters: [customer_type: "New Customer"]
  }

  measure: cnt_unique_orders_existing_customers {
    group_label: "* Basic Counts (Orders / Customers etc.) *"
    label: "# Orders Existing Customers"
    description: "Count of successful Orders placed by returning customers"
    hidden:  no
    type: count
    value_format: "0"
    filters: [customer_type: "Existing Customer"]
  }

  measure: cnt_orders_with_delivery_eta_available {
    # group_label: "* Operations / Logistics *"
    view_label: "* Hubs *"
    group_label: "Hub Leaderboard - Order Metrics"
    label: "# Orders with Delivery ETA available"
    description: "Count of Orders where a promised ETA is available"
    hidden:  no
    type: count
    filters: [is_delivery_eta_available: "yes"]
    value_format: "0"
  }

  measure: cnt_orders_delayed_under_0_min {
    # group_label: "* Operations / Logistics *"
    view_label: "* Hubs *"
    group_label: "Hub Leaderboard - Order Metrics"
    label: "# Orders delivered in time"
    description: "Count of Orders delivered no later than promised ETA"
    hidden:  no
    type: count
    filters: [delivery_delay_since_eta:"<=0"]
    value_format: "0"
  }

  measure: cnt_orders_delayed_over_5_min {
    # group_label: "* Operations / Logistics *"
    view_label: "* Hubs *"
    group_label: "Hub Leaderboard - Order Metrics"
    label: "# Orders delivered late >5min"
    description: "Count of Orders delivered >5min later than promised ETA"
    hidden:  no
    type: count
    filters: [delivery_delay_since_eta:">=5"]
    value_format: "0"
  }

  measure: cnt_orders_delayed_over_10_min {
    group_label: "* Operations / Logistics *"
    label: "# Orders delivered late >10min"
    description: "Count of Orders delivered >10min later than promised ETA"
    hidden:  yes
    type: count
    filters: [delivery_delay_since_eta:">=10"]
    value_format: "0"
  }

  measure: cnt_orders_delayed_over_15_min {
    group_label: "* Operations / Logistics *"
    label: "# Orders delivered late >15min"
    description: "Count of Orders delivered >15min later than promised ETA"
    hidden:  yes
    type: count
    filters: [delivery_delay_since_eta:">=15"]
    value_format: "0"
  }

  measure: cnt_orders_deliverd_over_20_min {
    group_label: "* Operations / Logistics *"
    label: "# Orders delivered >20min"
    description: "Count of Orders delivered >20min"
    hidden:  yes
    type: count
    filters: [fulfillment_time:">20"]
    value_format: "0"
  }

  measure: cnt_unique_date {
    group_label: "* Basic Counts (Orders / Customers etc.) *"
    label: "# Unique Date"
    description: "Count of Unique Dates"
    hidden:  no
    type: count_distinct
    sql: case when ${country_iso} = 'DE' and ${order_dow} = 'Sunday' then null
          else ${order_date} end;;
    value_format: "0"
  }


  ################
  ## PERCENTAGE ##
  ################

  measure: pct_acquisition_share {
    group_label: "* Marketing *"
    label: "% Acquisition Share"
    description: "Share of New Customer Acquisitions over Total Orders"
    hidden:  no
    type: number
    sql: ${cnt_unique_orders_new_customers} / NULLIF(${cnt_orders}, 0);;
    value_format: "0%"
  }

  measure: pct_discount_order_share {
    group_label: "* Marketing *"
    label: "% Discount Order Share"
    description: "Share of Orders which had some Discount applied"
    hidden:  no
    type: number
    sql: ${cnt_orders_with_discount} / NULLIF(${cnt_orders}, 0);;
    value_format: "0%"
  }

  measure: pct_discount_value_of_gross_total{
    group_label: "* Marketing *"
    label: "% Discount Value Share"
    description: "Dividing Total Discount amounts over GMV"
    hidden:  no
    type: number
    sql: ${sum_discount_amt} / NULLIF(${sum_gmv_gross}, 0);;
    value_format: "0%"
  }

  measure: pct_delivery_in_time{
    group_label: "* Operations / Logistics *"
    label: "% Orders delivered in time"
    description: "Share of orders delivered no later than promised ETA (only orders with valid ETA time considered)"
    hidden:  no
    type: number
    sql: ${cnt_orders_delayed_under_0_min} / NULLIF(${cnt_orders_with_delivery_eta_available}, 0);;
    value_format: "0%"
  }

  measure: pct_delivery_late_over_5_min{
    group_label: "* Operations / Logistics *"
    label: "% Orders delayed >5min"
    description: "Share of orders delivered >5min later than promised ETA (only orders with valid ETA time considered)"
    hidden:  no
    type: number
    sql: ${cnt_orders_delayed_over_5_min} / NULLIF(${cnt_orders_with_delivery_eta_available}, 0);;
    value_format: "0%"
  }

  measure: pct_delivery_late_over_10_min{
    group_label: "* Operations / Logistics *"
    label: "% Orders delayed >10min"
    description: "Share of orders delivered >10min later than promised ETA (only orders with valid ETA time considered)"
    hidden:  no
    type: number
    sql: ${cnt_orders_delayed_over_10_min} / NULLIF(${cnt_orders_with_delivery_eta_available}, 0);;
    value_format: "0%"
  }

  measure: pct_delivery_late_over_15_min{
    group_label: "* Operations / Logistics *"
    label: "% Orders delayed >15min"
    description: "Share of orders delivered >15min later than promised ETA (only orders with valid ETA time considered)"
    hidden:  no
    type: number
    sql: ${cnt_orders_delayed_over_15_min} / NULLIF(${cnt_orders_with_delivery_eta_available}, 0);;
    value_format: "0%"
  }

  measure: pct_fulfillment_over_20_min{
    group_label: "* Operations / Logistics *"
    label: "% Orders delivered >20min"
    description: "Share of orders delivered > 20min"
    hidden:  no
    type: number
    sql: ${cnt_orders_deliverd_over_20_min} / NULLIF(${cnt_orders}, 0);;
    value_format: "0%"
  }

  measure: percent_of_total_orders {
    group_label: "* Basic Counts (Orders / Customers etc.) *"
    label: "% Of Total Orders"
    direction: "column"
    type: percent_of_total
    sql: ${cnt_orders} ;;
  }

  measure: avg_orders_per_hub{
    group_label: "* Basic Counts (Orders / Customers etc.) *"
    label: "AVG # Orders per hub"
    type: number
    sql: ${cnt_orders}/NULLIF(${cnt_unique_hubs},0) ;;
  }

  measure: avg_daily_orders_per_hub{
    group_label: "* Basic Counts (Orders / Customers etc.) *"
    label: "AVG Daily Orders per hub"
    type: number
    sql: (${cnt_orders}/NULLIF(${cnt_unique_hubs},0))/ NULLIF(${cnt_unique_date},0);;
  }


}
