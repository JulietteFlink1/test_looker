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

  dimension: rider_queuing_time {
    alias: [acceptance_time]
    type: number
    group_label: "* Operations / Logistics *"
    hidden: no
    sql: ${TABLE}.rider_queuing_time_minutes ;;
  }

  dimension: google_cycling_time_minutes {
    type: number
    group_label: "* Operations / Logistics *"
    hidden: yes
    sql: ${TABLE}.google_cycling_time_minutes ;;
  }

  dimension: shipping_price_gross_amount {
    type: number
    label: "Delivery Fee (Gross)"
    hidden: no
    sql: ${TABLE}.amt_delivery_fee_gross ;;
  }

  dimension: shipping_price_net_amount {
    type: number
    label: "Delivery Fee (Net)"
    hidden: no
    sql: ${TABLE}.amt_delivery_fee_net ;;
  }

  dimension: discount_amount {
    group_label: "* Monetary Values *"
    label: "Total Discount Amount (Gross)"
    type: number
    hidden: no
    sql: ${TABLE}.amt_discount_gross ;;
  }

  dimension: amt_discount_net {
    group_label: "* Monetary Values *"
    label: "Total Discount Amount (Net)"
    type: number
    hidden: no
    sql: ${TABLE}.amt_discount_net ;;
  }

  dimension: amt_discount_cart_gross {
    group_label: "* Monetary Values *"
    label: "Cart Discount Amount (Gross)"
    type: number
    hidden: no
    sql: ${TABLE}.amt_discount_cart_gross ;;
  }

  dimension: amt_discount_cart_net {
    group_label: "* Monetary Values *"
    label: "Cart Discount Amount (Net)"
    type: number
    hidden: no
    sql: ${TABLE}.amt_discount_cart_net ;;
  }

  dimension: amt_discount_products_gross {
    group_label: "* Monetary Values *"
    label: "Product Discount Amount (Gross)"
    type: number
    hidden: no
    sql: ${TABLE}.amt_discount_products_gross ;;
  }

  dimension: amt_discount_products_net {
    group_label: "* Monetary Values *"
    label: "Product Discount Amount (Net)"
    type: number
    hidden: no
    sql: ${TABLE}.amt_discount_products_net ;;
  }

  dimension: gmv_gross {
    group_label: "* Monetary Values *"
    type: number
    hidden: no
    sql: ${TABLE}.amt_gmv_gross ;;
  }

  dimension: gmv_gross_tier_1 {
    group_label: "* Monetary Values *"
    label: "GMV (tiered, 1 EUR)"
    type: tier
    tiers: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35]
    style: relational
    sql: ${gmv_gross} ;;
  }

  dimension: gmv_gross_tier {
    alias: [gmv_gross_tier_2]
    group_label: "* Monetary Values *"
    label: "GMV (tiered, 2 EUR)"
    type: tier
    tiers: [0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36, 38, 40, 42, 44, 46, 48, 50, 52, 54, 56, 58, 60, 62, 64, 66, 68, 70]
    style: relational
    sql: ${gmv_gross} ;;
  }

  dimension: gmv_gross_tier_5 {
    group_label: "* Monetary Values *"
    label: "GMV (tiered, 5 EUR)"
    type: tier
    tiers: [0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70]
    style: relational
    sql: ${gmv_gross} ;;
  }

  dimension: gmv_net {
    type: number
    hidden: yes
    sql: ${TABLE}.amt_gmv_net ;;
  }

  dimension: item_value_gross {

    alias: [amt_total_price_gross]
    group_label: "* Monetary Values *"
    type: number
    hidden: no
    sql: ${TABLE}.amt_total_price_gross
    ;;
  }

  dimension: item_value_net {

    alias: [amt_total_price_net]
    group_label: "* Monetary Values *"
    type: number
    hidden: no
    sql: ${TABLE}.amt_total_price_net   ;;
  }

  dimension: item_value_gross_tier_1 {
    group_label: "* Monetary Values *"
    label: "Item Value (tiered, 1 EUR)"
    type: tier
    tiers: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35]
    style: relational
    sql: ${item_value_gross} ;;
  }

  dimension: item_value_gross_tier {
    alias: [item_value_gross_tier_2]
    group_label: "* Monetary Values *"
    label: "Item Value (tiered, 2 EUR)"
    type: tier
    tiers: [0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36, 38, 40, 42, 44, 46, 48, 50, 52, 54, 56, 58, 60, 62, 64, 66, 68, 70]
    style: relational
    sql: ${item_value_gross} ;;
  }

  dimension: item_value_gross_tier_5 {
    group_label: "* Monetary Values *"
    label: "Item Value (tiered, 5 EUR)"
    type: tier
    tiers: [0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70]
    style: relational
    sql: ${item_value_gross} ;;
  }
  dimension: rider_tip {
    type: number
    hidden: yes
    sql: ${TABLE}.amt_rider_tip ;;
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
    label: "Country"
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
    required_access_grants: [can_view_customer_data]
  }

  dimension: customer_id {
    group_label: "* IDs *"
    hidden: no
    type: string
    sql: ${TABLE}.customer_id ;;
  }

  dimension: external_id {
    group_label: "* IDs *"
    hidden: no
    type: string
    sql: ${TABLE}.external_id ;;
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
    label: "Delivery PDT (min)"
    description: "Promised Delivery Time as shown to customer"
    type: number
    sql: ${TABLE}.delivery_pdt_minutes ;;
  }

  dimension: delivery_estimate_model {
    type: string
    hidden: yes
    sql: ${TABLE}.delivery_estimate_model ;;
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
    description: "Order Placement Time/Date"
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

  dimension: order_time_of_day {
    group_label: "* Dates and Timestamps *"
    label: "Order Time of Day"
    description: "Categorizing orders into different time-based use case buckets depending on the day of week and hour of day. Exact definition in KPI Glossary"
    case: {

      # Breakfast use case:
      when: {
        sql:  ( ${created_day_of_week} IN ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday') AND ${created_hour_of_day} IN (5,6,7,8,9,10) )
              OR
              ( ${created_day_of_week} IN ('Saturday', 'Sunday') AND ${created_hour_of_day} IN (5,6,7,8,9,10,11) )
              ;;
        label: "Breakfast"
      }

      # Lunch use case:
      when: {
        sql:  ( ${created_day_of_week} IN ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday') AND ${created_hour_of_day} IN (11,12,13,14,15) )
              OR
              ( ${created_day_of_week} IN ('Saturday', 'Sunday') AND ${created_hour_of_day} IN (12,13,14,15) )
              ;;
        label: "Lunch"
      }

      # Snacks use case:
      when: {
        sql:  ( ${created_day_of_week} IN ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday') AND ${created_hour_of_day} IN (16,17,18) )
              OR
              ( ${created_day_of_week} IN ('Saturday', 'Sunday') AND ${created_hour_of_day} IN (16,17,18) )
              ;;
        label: "Snacks"
      }

      # Dinner use case:
      when: {
        sql:  ( ${created_day_of_week} IN ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday') AND ${created_hour_of_day} IN (19,20) )
              OR
              ( ${created_day_of_week} IN ('Saturday', 'Sunday') AND ${created_hour_of_day} IN (19,20,21) )
              ;;
        label: "Dinner"
      }

      # Drinks / Late Night use case:
      when: {
        sql:  ( ${created_day_of_week} IN ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday') AND ${created_hour_of_day} IN (21,22,23,0,1,2,3,4) )
              OR
              ( ${created_day_of_week} IN ('Saturday', 'Sunday') AND ${created_hour_of_day} IN (22,23,0,1,2,3,4) )
              ;;
        label: "Drinks / Late Night"
      }
    }
  }


  dimension: is_order_hour_before_now_hour {
    group_label: "* Operations / Logistics *"
    type: yesno
    sql: ${created_hour_of_day} < ${now_hour_of_day} ;;
  }

  dimension_group: delivery_eta_timestamp {
    group_label: "* Dates and Timestamps *"
    label: "Delivery PDT"
    description: "Promised Delivery time as shown to customer"
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
    description: "Delay versus promised delivery time (as shown to customer)"
    type: duration_minute
    sql_start: ${delivery_eta_timestamp_raw};;
    sql_end: ${delivery_timestamp_raw};;
  }

  dimension: delivery_delay_since_eta_seconds {
    group_label: "* Operations / Logistics *"
    label: "Delta to PDT (sec)"
    description: "Delay versus promised delivery time (as shown to customer)"
    hidden: yes
    type: duration_second
    sql_start: ${delivery_eta_timestamp_raw};;
    sql_end: ${delivery_timestamp_raw};;
  }

  dimension: delivery_delay_since_time_estimate {
    group_label: "* Operations / Logistics *"
    label: "Delta to Time Estimate (min)"
    description: "Delay versus delivery time estimate (internal model estimate, not necessarily the PDT which was down to customer)"
    type: number
    sql:  ${fulfillment_time_raw_minutes} - ${delivery_time_estimate_minutes};;
  }

  dimension: delivery_delay_since_time_targeted {
    group_label: "* Operations / Logistics *"
    label: "Delta to Time Targeted (min)"
    description: "Delay versus delivery time targeted (internal model estimate, not necessarily the PDT which was down to customer)"
    type: number
    sql:  ${fulfillment_time_raw_minutes} - ${delivery_time_targeted_minutes};;
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

  dimension: riding_to_customer_time_minutes {
    group_label: "* Operations / Logistics *"
    description: "The time for a rider to cycle from the hub to the customer (non-stacked orders) or from the previous customer to the current one (stacked orders)"
    type: number
    sql: ${TABLE}.riding_to_customer_time_minutes ;;
  }

  dimension: riding_to_hub_time_minutes {
    label: "Riding To Hub Time (min)"
    description: "The time for a rider to cycle from the customer back to the hub. Set to NULL for not-final stacked orders."
    group_label: "* Operations / Logistics *"
    type: number
    sql: ${TABLE}.riding_to_hub_time_minutes ;;
  }

  dimension: rider_handling_time_minutes {
    group_label: "* Operations / Logistics *"
    label: "Rider Handling Time (min)"
    description: "Total time needed for the rider to handle the order: Riding to customer + At customer + Riding to hub"
    type: number
    hidden: yes
    sql: ${TABLE}.rider_handling_time_minutes ;;
  }

  dimension: potential_rider_handling_time_without_stacking_minutes {
    group_label: "* Operations / Logistics *"
    label: "Potential Rider Handling Time Without Stacking Effect"
    description: "Total potential time needed for the rider to handle the order if it wasn't stacked. Definition depends on the stacking sequence of the order."
    type: number
    sql: ${TABLE}.potential_rider_handling_time_without_stacking_minutes ;;
  }

  dimension: rider_handling_time_minutes_saved_with_stacking {
    group_label: "* Operations / Logistics *"
    label: "Estimated number of minutes saved on this order due to stacking"
    description: "Total time needed for the rider to handle the order: Riding to customer + At customer + Riding to hub"
    type: number
    sql: case when ${TABLE}.is_stacked_order = true then ${TABLE}.potential_rider_handling_time_without_stacking_minutes - ${TABLE}.rider_handling_time_minutes end ;;
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

  dimension: estimated_picking_time_minutes {
    label: "Picking Time Estimate (min)"
    description: "The internally predicted time in minutes for the picking"
    group_label: "* Operations / Logistics *"
    type: number
    sql: ${TABLE}.estimated_picking_time_minutes;;
  }

  dimension: estimated_riding_time_minutes {
    label: "Riding Time Estimate (min)"
    description: "The internally predicted time in minutes for the riding"
    group_label: "* Operations / Logistics *"
    type: number
    sql: ${TABLE}.estimated_riding_time_minutes;;
  }

  dimension: delivery_time_estimate_minutes {
    label: "Fulfillment Time Estimate (min)"
    description: "The internally predicted time in minutes for the order to arrive at the customer"
    group_label: "* Operations / Logistics *"
    type: number
    sql: ${TABLE}.estimated_fulfillment_time_minutes;;
  }

  dimension: delivery_time_targeted_minutes {
    label: "Fulfillment Time Targeted (min)"
    description: "The internally targeted time in minutes for the order to arrive at the customer"
    group_label: "* Operations / Logistics *"
    type: number
    sql: ${TABLE}.targeted_fulfillment_time_minutes;;
  }

  dimension: estimated_queuing_time_for_picker_minutes {
    label: "Picker Queuing Time Estimate (min)"
    description: "The internally predicted time in minutes for the picker queuing"
    group_label: "* Operations / Logistics *"
    type: number
    sql: ${TABLE}.estimated_picker_queuing_time_minutes;;
  }

  dimension: queuing_time_for_picker_minutes {
    label: "Picker Queuing Time (min)"
    description: "The actual time in minutes for the picker queuing"
    group_label: "* Operations / Logistics *"
    type: number
    value_format: "0.0"
    sql: TIMESTAMP_DIFF(safe_cast(${order_picker_accepted_timestamp} as timestamp) , safe_cast(${created_time} as timestamp),second)/60;;
    hidden: yes
  }

  dimension: queuing_time_for_rider_minutes {
    label: "Rider Queuing Time (min)"
    description: "The actual time in minutes for the rider queuing"
    group_label: "* Operations / Logistics *"
    type: number
    value_format: "0.0"
    sql: TIMESTAMP_DIFF( safe_cast(${order_on_route_timestamp} as timestamp),safe_cast(${order_packed_timestamp} as timestamp),second)/60;;
    hidden: yes
  }

  dimension: estimated_queuing_time_for_rider_minutes {
    label: "Rider Queuing Time Estimate (min)"
    description: "The internally predicted time in minutes for the rider queuing"
    group_label: "* Operations / Logistics *"
    type: number
    sql: ${TABLE}.estimated_rider_queuing_time_minutes;;
  }

  dimension: pre_riding_time {
    label: "Pre Riding Time (min)"
    description: "Picker Queuing Time + Picking Time + Rider Queuing Time"
    group_label: "* Operations / Logistics *"
    type: number
    sql: ${picker_queuing_time} + ${rider_queuing_time} + ${time_diff_between_two_subsequent_fulfillments};;
  }

  dimension: is_critical_delivery_time_estimate_underestimation {
    description: "The actual fulfillment took more than 10min longer than the internally predicted delivery time"
    type:  yesno
    sql: ${fulfillment_time_raw_minutes} > (10 + ${delivery_time_estimate_minutes}) ;;
    hidden: yes
  }

  dimension: is_critical_delivery_time_estimate_overestimation {
    description: "The actual fulfillment took more than 10min less than the internally predicted delivery time"
    type:  yesno
    sql: ${fulfillment_time_raw_minutes} < (${delivery_time_estimate_minutes} - 10) ;;
    hidden: yes
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
    label: "Fulfillment Time (tiered, 1min)"
    type: tier
    tiers: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50]
    style: interval
    sql: ${fulfillment_time} ;;
  }

  dimension: fulfillment_time_tier_2 {
    group_label: "* Operations / Logistics *"
    label: "Fulfillment Time (tiered, 2min)"
    type: tier
    tiers: [0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36, 38, 40, 42, 44, 46, 48, 50, 52, 54, 56, 58, 60, 62, 64, 66, 68, 70]
    style: relational
    sql: ${fulfillment_time} ;;
  }

  dimension: rider_queuing_time_tier {
    alias: [acceptance_time_tier]
    group_label: "* Operations / Logistics *"
    label: "Rider Queuing Time (tiered, 1min)"
    type: tier
    tiers: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30]
    style: interval
    sql: ${rider_queuing_time} ;;
  }

  dimension: picker_queuing_time_tier {
    alias: [reaction_time_tier]
    group_label: "* Operations / Logistics *"
    label: "Picker Queuing Time (tiered, 1min)"
    type: tier
    tiers: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30]
    style: interval
    sql: ${picker_queuing_time} ;;
  }

  dimension: is_riding_to_customer_above_30_minute {
    label: "Is Riding To Customer Above 30min"
    group_label: "* Operations / Logistics *"
    type: yesno
    sql: ${TABLE}.is_riding_to_customer_above_30_minute ;;
  }

  dimension: is_delivery_eta_available {
    group_label: "* Operations / Logistics *"
    type: yesno
    hidden: yes
    sql: ${TABLE}.is_delivery_pdt_available ;;
  }

  dimension: is_targeted_eta_available {
    group_label: "* Operations / Logistics *"
    type: yesno
    hidden: yes
    sql: case when ${delivery_time_targeted_minutes} is not null then true else false end;;
  }

  dimension: is_voucher_order{
    group_label: "* Order Dimensions *"
    label: "Is Discounted Order (Yes/No)"
    description: "Flags if an Order has any Discount (Cart or Product) applied"
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

  dimension: is_rider_queuing_time_less_than_0_minute {
    alias: [is_acceptance_less_than_0_minute]
    hidden: yes
    group_label: "* Operations / Logistics *"
    type: yesno
    sql: ${rider_queuing_time} < 0 ;;
  }

  dimension: is_rider_queuing_time_more_than_30_minute {
    alias: [is_acceptance_more_than_30_minute]
    hidden: yes
    group_label: "* Operations / Logistics *"
    type: yesno
    sql: ${rider_queuing_time} > 30 ;;
  }

  dimension: is_picker_queuing_less_than_0_minute {
    alias: [is_reaction_less_than_0_minute]
    hidden: yes
    group_label: "* Operations / Logistics *"
    type: yesno
    sql: ${picker_queuing_time} < 0 ;;
  }

  dimension: is_picker_queuing_more_than_30_minute {
    alias: [is_reaction_more_than_30_minute]
    hidden: yes
    group_label: "* Operations / Logistics *"
    type: yesno
    sql: ${picker_queuing_time} > 30 ;;
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

  dimension: is_click_and_collect_order {
    group_label: "* Order Dimensions *"
    type: yesno
    sql: ${TABLE}.is_click_and_collect_order ;;
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
    label: "Customer Latitude"
    type: number
    sql: ${TABLE}.customer_latitude ;;
  }

  dimension: longitude {
    group_label: "* User Dimensions *"
    label: "Customer Longitude"
    type: number
    sql: ${TABLE}.customer_longitude ;;
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
    label: "Rider Arrived At Customer Timestamp"
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
    sql: coalesce(${TABLE}.rider_arrived_at_customer_timestamp, ${TABLE}.rider_completed_delivery_timestamp) ;;
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
    hidden: no
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
    label: "Rider on Route Timestamp"
    type: date_time
    sql: ${TABLE}.rider_on_route_timestamp ;;
  }

  dimension: order_packed_timestamp {
    group_label: "* Operations / Logistics *"
    label: "Picking Completed Timestamp"
    type: date_time
    sql: ${TABLE}.picking_completed_timestamp ;;
  }

  dimension: order_picker_accepted_timestamp {
    group_label: "* Operations / Logistics *"
    label: "Picking Started Timestamp"
    type: date_time
    sql: ${TABLE}.picking_started_timestamp ;;
  }

  dimension: order_rider_claimed_timestamp {
    group_label: "* Operations / Logistics *"
    label: "Rider Claimed Timestamp"
    type: date_time
    sql: ${TABLE}.rider_claimed_timestamp ;;
  }

  dimension: rider_arrived_at_customer_timestamp {
    group_label: "* Operations / Logistics *"
    label: "Rider Arrived At Customer Timestamp"
    type: date_time
    sql: ${TABLE}.rider_arrived_at_customer_timestamp ;;
  }

  dimension: rider_completed_delivery_timestamp {
    group_label: "* Operations / Logistics *"
    label: "Rider Completed Delivery Timestamp"
    type: date_time
    sql: ${TABLE}.rider_completed_delivery_timestamp ;;
  }

  dimension: rider_returned_to_hub_timestamp {
    group_label: "* Operations / Logistics *"
    label: "Rider Returned to Hub Timestamp"
    description: "The time, when a rider arrives back at the hub after delivering an order"
    type: date_time
    sql: ${TABLE}.rider_returned_to_hub_timestamp ;;
  }


  dimension: rider_on_duty_time {
    group_label: "* Operations / Logistics *"
    label: "Rider time spent from claiming an order until returning back to Hub in Minute"
    description: "The time, when a rider arrives back at the hub after delivering an order"
    type: number
    sql: timestamp_diff(timestamp(${rider_completed_delivery_timestamp}), timestamp(${order_on_route_timestamp}), minute)*2 ;;
  }




  dimension: order_uuid {
    type: string
    group_label: "* IDs *"
    label: "Order UUID"
    primary_key: yes
    hidden: no
    sql: ${TABLE}.order_uuid ;;
  }

  dimension: customer_uuid {
    type: string
    group_label: "* IDs *"
    label: "Customer UUID"
    hidden: no
    sql: ${TABLE}.customer_uuid ;;
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

  dimension: picker_queuing_time {
    alias: [reaction_time]
    group_label: "* Operations / Logistics *"
    label: "Picker Queuing Time Minutes"
    type: number
    sql: ${TABLE}.picker_queuing_time_minutes ;;
  }

  dimension: at_customer_time_minutes {
    group_label: "* Operations / Logistics *"
    label: "At Customer Time Minutes"
    type: number
    sql: ${TABLE}.at_customer_time_minutes ;;
  }

  dimension: at_customer_time_minutes_tier_5 {
    group_label: "* Operations / Logistics *"
    label: "At Customer Time Minutes (tiered, 0.5min)"
    type: tier
    tiers: [0, 0.5, 1, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0, 5.5, 6.0, 6.5, 7.0]
    sql: ${at_customer_time_minutes} ;;
  }

  dimension: rider_id {
    hidden: no
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
    group_label: "* Order Dimensions *"
    hidden: no
    type: number
    sql: ${TABLE}.weight ;;
  }

  dimension: weight_kg {
    group_label: "* Order Dimensions *"
    description: "Weight (kg)"
    hidden: no
    type: number
    sql: ${TABLE}.weight/1000 ;;
  }

  dimension: weight_kg_tier {
    group_label: "* Order Dimensions *"
    label: "Weight (tiered, 1kg)"
    type: tier
    tiers: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]
    style: relational
    sql: ${weight_kg} ;;
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

  dimension: is_business_day_completed {
    group_label: "* Dates and Timestamps *"
    type: yesno
    sql:  IF(${order_date} < ${now_date}, TRUE, FALSE) ;;
  }

  dimension: customer_order_rank {
    group_label: "* Order Dimensions *"
    type: number
    sql: ${TABLE}.customer_order_rank ;;
  }

  dimension: external_provider {
    group_label: "* Order Dimensions *"
    type: string
    sql: ${TABLE}.external_provider ;;
  }

  dimension: external_provider_order_id {
    group_label: "* IDs *"
    type: string
    sql: ${TABLE}.external_provider_order_id ;;
  }

  dimension: is_external_order {
    group_label: "* Order Dimensions *"
    type: yesno
    sql: ${TABLE}.is_external_order ;;
  }

  dimension: deposit {
    type: number
    hidden: yes
    sql: ${TABLE}.amt_deposit ;;
  }

  dimension: cancellation_reason {
    group_label: "* Cancelled Orders *"
    description: "Reason for the cancellation of the order (e.g. Wrong Address, Delivery Too Long...)"
    type: string
    sql: ${TABLE}.cancellation_reason;;
  }

  dimension: cancellation_user_name {
    group_label: "* Cancelled Orders *"
    description: "Either the name of the CS Agent who cancelled the order, either 'Self' if the customer cancelled him/herself"
    type: string
    sql: ${TABLE}.cancellation_user_name;;
  }

  dimension: cancellation_type {
    group_label: "* Cancelled Orders *"
    description: "Takes value Full if the whole order was cancelled."
    type: string
    sql: ${TABLE}.cancellation_type;;
  }

  dimension: cancellation_category {
    group_label: "* Cancelled Orders *"
    description: "Takes values CS Agent or Customer depending on the person who initiated the cancellation"
    type: string
    sql: ${TABLE}.cancellation_category;;
  }

  dimension: amt_cancelled_gross {
    group_label: "* Cancelled Orders *"
    hidden: yes
    type: number
    sql: ${TABLE}.amt_cancelled_gross;;
  }


  dimension: amt_refund_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_refund_gross;;
  }
  dimension: amt_total_sales_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_total_sales_gross;;
  }
  dimension: amt_total_sales_excluding_deposit_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_total_sales_excluding_deposit_gross;;
  }
  dimension: amt_total_sales_after_discount_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_total_sales_after_discount_gross;;
  }
  dimension: amt_total_sales_after_discount_and_refund_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_total_sales_after_discount_and_refund_gross;;
  }
  dimension: amt_total_sales_after_discount_and_refund_excluding_deposit_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_total_sales_after_discount_and_refund_excluding_deposit_gross;;
  }
  dimension: amt_gpv_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_gpv_gross;;
  }
  dimension: amt_npv_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_npv_gross;;
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
    allowed_value: { value: "share_of_orders_fulfilled_over_30min" label: "% Orders Fulfilled >30min"}
    allowed_value: { value: "gmv_gross" label: "GMV (Gross)"}
    allowed_value: { value: "gmv_net" label: "GMV (Net)"}
    allowed_value: { value: "revenue_gross" label: "Revenue (Gross)"}
    allowed_value: { value: "revenue_net" label: "Revenue (Net)"}
    allowed_value: { value: "discount_amount" label: "Discount Amount"}
    allowed_value: { value: "AVG_fulfillment_time" label: "AVG Fulfillment Time"}
    allowed_value: { value: "AVG_order_value_gross" label: "AVG Order Value (Gross)"}
    allowed_value: { value: "AVG_order_value_net" label: "AVG Order Value (Net)"}
    allowed_value: { value: "avg_item_value_gross" label: "AVG Item Value (Gross)"}
    allowed_value: { value: "avg_item_value_net" label: "AVG Item Value (Net)"}
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
    {% elsif KPI_parameter._parameter_value == 'share_of_orders_fulfilled_over_30min' %}
      ${pct_fulfillment_over_30_min}*100
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
    {% elsif KPI_parameter._parameter_value == 'avg_item_value_gross' %}
      ${avg_item_value_gross}
    {% elsif KPI_parameter._parameter_value == 'avg_item_value_net' %}
      ${avg_item_value_net}
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
          {% elsif KPI_parameter._parameter_value == 'share_of_orders_fulfilled_over_30min' %}
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
          {% elsif KPI_parameter._parameter_value == 'avg_item_value_gross' %}
            €{{ rendered_value }}
          {% elsif KPI_parameter._parameter_value == 'avg_item_value_net' %}
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
        description: "Average Promised Fulfillment Time (PDT) a shown to customer"
        hidden:  no
        type: average
        sql: ${delivery_eta_minutes};;
        value_format_name: decimal_1
      }

      measure: avg_pdt_mm_ss {
        group_label: "* Operations / Logistics *"
        label: "AVG PDT (MM:SS)"
        description: "Average Promised Fulfillment Time (PDT) a shown to customer"
        type: average
        sql: ${delivery_eta_minutes} * 60 / 86400.0;;
        value_format: "mm:ss"
      }

      measure: avg_delivery_time_estimate {
        label: "AVG Fulfillment Time Estimate (min)"
        description: "The average internally predicted time in minutes for the order to arrive at the customer (dynamic model result - not necessarily the PDT shown to the customer as some conversion can be applied in between)"
        group_label: "* Operations / Logistics *"
        type: average
        sql: ${delivery_time_estimate_minutes} ;;
        value_format_name: decimal_1
      }

      measure: avg_google_cycling_time_minutes {
        group_label: "* Operations / Logistics *"
        label: "AVG Google Cycling Time"
        description: "Average time needed to cycle to the customer estimated by Google in the moment of order placement"
        hidden:  no
        type: average
        sql: ${google_cycling_time_minutes};;
        value_format_name: decimal_1
      }

      measure: avg_diff_riding_to_customer_actual_vs_google {
        group_label: "* Operations / Logistics *"
        label: "AVG Riding to Customer Time Difference Actuals vs. Google Estimate"
        description: "The average of the difference beween the actual riding to customer time and what Google estimated is needed in the moment of order placement"
        hidden:  no
        type: average
        sql: ${riding_to_customer_time_minutes}-${google_cycling_time_minutes};;
        value_format_name: decimal_1
      }

      measure: avg_fulfillment_time {
        group_label: "* Operations / Logistics *"
        label: "AVG Fulfillment Time (decimal)"
        description: "Average Fulfillment Time (decimal minutes) considering order placement to delivery (rider at customer). Outliers excluded (<3min or >210min)"
        hidden:  no
        type: average
        sql: ${fulfillment_time};;
        value_format_name: decimal_1
      }

      measure: avg_fulfillment_time_mm_ss {
        group_label: "* Operations / Logistics *"
        label: "AVG Fulfillment Time (HH:MM:SS)"
        description: "Average Fulfillment Time considering order placement to delivery (rider at customer). Outliers excluded (<3min or >210min)"
        type: average
        sql: ${fulfillment_time} * 60 / 86400.0;;
        value_format: "hh:mm:ss"
      }


      measure: avg_picker_queuing_time {
        alias: [avg_reaction_time]
        group_label: "* Operations / Logistics *"
        label: "AVG Picker Queuing Time"
        description: "Average Picker Queuing Time of the Picker considering order placement until picking started. Outliers excluded (<0min or >120min)"
        hidden:  no
        type: average
        sql:${picker_queuing_time};;
        value_format_name: decimal_1
      }

      measure: avg_picking_time {
        group_label: "* Operations / Logistics *"
        label: "AVG Picking Time"
        description: "Average Picking Time considering first fulfillment to second fulfillment created. Outliers excluded (<0min or >30min)"
        hidden:  no
        type: average
        sql:${time_diff_between_two_subsequent_fulfillments};;
        value_format_name: decimal_1
      }

      measure: avg_rider_queuing_time {
        alias: [avg_acceptance_time]
        group_label: "* Operations / Logistics *"
        label: "AVG Rider Queuing Time"
        description: "Average time between picking completion and rider having claimed the order."
        hidden:  no
        type: average
        sql:${rider_queuing_time};;
        value_format_name: decimal_1
      }

      measure: avg_riding_to_customer_time {
        group_label: "* Operations / Logistics *"
        label: "AVG Riding To Customer Time"
        description: "Average riding to customer time considering delivery start to arrival at customer. Outliers excluded (<1min or >30min)"
        hidden:  no
        type: average
        sql: ${riding_to_customer_time_minutes};;
        value_format_name: decimal_1
      }

      measure: avg_discount_value {
        group_label: "* Monetary Values *"
        label: "AVG Discount Value"
        description: "Average Discount Value (only considering orders where discount was applied). Includes both Product and Cart discounts"
        hidden:  no
        type: average
        sql: ${discount_amount};;
        filters: [discount_amount: ">0"]
        value_format_name: euro_accounting_2_precision
      }

      measure: avg_discount_cart_gross {
        group_label: "* Monetary Values *"
        label: "AVG Cart Discount Value (Gross)"
        description: "Average of Cart Discount Value Gross (voucher applied at a checkout). Includes delivery discounts."
        hidden:  no
        type: average
        sql: ${amt_discount_cart_gross};;
        filters: [amt_discount_cart_gross: ">0"]
        value_format_name: euro_accounting_2_precision
      }

      measure: avg_discount_cart_net {
        group_label: "* Monetary Values *"
        label: "AVG Cart Discount Value (Net)"
        description: "Average of Cart Discount Value Net (voucher applied at a checkout). Includes delivery discounts."
        hidden:  no
        type: average
        sql: ${amt_discount_cart_net};;
        filters: [amt_discount_cart_net: ">0"]
        value_format_name: euro_accounting_2_precision
      }

      measure: avg_discount_product_gross {
        group_label: "* Monetary Values *"
        label: "AVG Product Discount Value (Gross)"
        description: "Average Discount Value Gross (only considering orders where discount on products was applied)"
        hidden:  no
        type: average
        sql: ${amt_discount_products_gross};;
        filters: [amt_discount_products_gross: ">0"]
        value_format_name: euro_accounting_2_precision
      }

       measure: avg_discount_product_net {
        group_label: "* Monetary Values *"
        label: "AVG Product Discount Value (Net)"
        description: "Average Discount Value Net (only considering orders where discount on products was applied)"
        hidden:  no
        type: average
        sql: ${amt_discount_products_net};;
        filters: [amt_discount_products_net: ">0"]
        value_format_name: euro_accounting_2_precision
      }

      measure: avg_gpv_gross {
        group_label: "* Monetary Values *"
        label: "AVG GPV"
        description: "Gross Payment Value. Actual amount paid by the customer in CT. Sum of Delivery Fees, Items Price, Tips, Deposit. Excl. Donations. After Deduction of Cart and Product Discounts. Incl. VAT"
        hidden:  no
        type: average
        sql: ${amt_gpv_gross};;
        value_format_name: euro_accounting_2_precision
      }

      measure: avg_npv_gross {
        group_label: "* Monetary Values *"
        label: "AVG NPV"
        description: "Net Payment Value. Actual amount paid by the customer in CT after Refunds. Sum of Delivery Fees, Items Price, Tips, Deposit. Excl. Donations. After Deduction of Cart and Product Discounts. After Refunds. Incl. VAT"
        hidden:  no
        type: average
        sql: ${amt_npv_gross};;
        value_format_name: euro_accounting_2_precision
      }

      measure: avg_estimated_picking_time_minutes {
        group_label: "* Operations / Logistics *"
        label: "AVG Estimated Picking Time"
        type: average
        sql: ${estimated_picking_time_minutes};;
        value_format_name: decimal_1
      }


      measure: avg_estimated_riding_time_minutes {
        group_label: "* Operations / Logistics *"
        label: "AVG Estimated Riding Time"
        type: average
        sql: ${estimated_riding_time_minutes};;
        value_format_name: decimal_1
      }

      measure: avg_estimated_queuing_time_for_picker_minutes {
        group_label: "* Operations / Logistics *"
        label: "AVG Estimated Queuing Time for Pickers"
        type: average
        sql: ${estimated_queuing_time_for_picker_minutes};;
        value_format_name: decimal_1
      }

      measure: avg_queuing_time_for_pickers_minutes {
        group_label: "* Operations / Logistics *"
        label: "AVG Queuing Time for Pickers"
        type: average
        sql: ${queuing_time_for_picker_minutes} ;;
        value_format_name: decimal_1
        hidden: yes
      }

      measure: avg_queuing_time_for_riders_minutes {
        group_label: "* Operations / Logistics *"
        label: "AVG Queuing Time for Riders"
        type: average
        sql: ${queuing_time_for_rider_minutes} ;;
        value_format_name: decimal_1
        hidden: yes
      }

      measure: avg_pre_riding_time {
        group_label: "* Operations / Logistics *"
        label: "AVG Pre Riding Time"
        type: average
        sql: ${pre_riding_time} ;;
        value_format_name: decimal_1
      }

      measure: avg_estimated_queuing_time_for_rider_minutes {
        group_label: "* Operations / Logistics *"
        label: "AVG Estimated Queuing Time for Riders"
        type: average
        sql: ${estimated_queuing_time_for_rider_minutes};;
        value_format_name: decimal_1
      }

      measure: avg_riding_to_hub_time {
        group_label: "* Operations / Logistics *"
        label: "AVG Riding to Hub time"
        description: "Average riding time from customer location back to the hub (<1min or >30min)."
        hidden:  no
        type: average
        sql: ${riding_to_hub_time_minutes};;
        value_format_name: decimal_1
      }

      measure: avg_rider_handling_time {
        group_label: "* Operations / Logistics *"
        label: "AVG Rider Handling Time"
        description: "Average total rider handling time: riding to customer + at customer + riding to hub"
        hidden:  no
        type: average
        sql: ${rider_handling_time_minutes};;
        value_format_name: decimal_1
      }

      measure: avg_rider_handling_time_stacked {
        group_label: "* Operations / Logistics *"
        label: "AVG Rider Handling Time Stacked"
        description: "Average total rider handling time (stacked): riding to customer + at customer + riding to hub"
        hidden:  yes
        type: average
        sql:
          case when ${TABLE}.is_stacked_order = true then ${rider_handling_time_minutes} end;;
        value_format_name: decimal_1
      }

      measure: avg_rider_handling_time_non_stacked {
        group_label: "* Operations / Logistics *"
        label: "AVG Rider Handling Time Non Stacked"
        description: "Average total rider handling time (non-stacked): riding to customer + at customer + riding to hub"
        hidden:  yes
        type: average
        sql: case when ${TABLE}.is_stacked_order = false then ${rider_handling_time_minutes} end;;
        value_format_name: decimal_1
      }

      measure: avg_rider_handling_time_saved_vs_non_stacked_orders {
        group_label: "* Stacked Orders *"
        label: "AVG Rider Handling Time Minutes Saved Stacked vs. Non-Stacked Orders"
        description: "The difference in minutes for average rider handling time between stacked and non-stacked orders"
        hidden:  no
        type: number
        sql: ${avg_rider_handling_time_non_stacked} - ${avg_rider_handling_time_stacked};;
        value_format_name: decimal_1
      }


      measure: avg_potential_rider_handling_time_without_stacking {
        group_label: "* Operations / Logistics *"
        label: "AVG Potential Rider Handling Time Without Stacking"
        description: "Average potential rider handling time estimated without stacking."
        hidden:  no
        type: average
        sql: ${potential_rider_handling_time_without_stacking_minutes};;
        value_format_name: decimal_1
      }

      measure: avg_targeted_delivery_time {
        group_label: "* Operations / Logistics *"
        label: "AVG Targeted Fulfillment Time (min)"
        description: "Average internal targeted delivery time for hub ops."
        hidden:  no
        type: average
        sql: ${delivery_time_targeted_minutes};;
        value_format_name: decimal_1
      }

      measure: avg_at_customer_time {
        group_label: "* Operations / Logistics *"
        label: "AVG At Customer Time"
        description: "Average Time the Rider spent at the customer between arrival and order completion confirmation"
        hidden:  no
        type: average
        sql:${at_customer_time_minutes};;
        value_format_name: decimal_1
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

      measure: avg_item_value_gross {
        alias: [avg_product_value_gross]
        group_label: "* Monetary Values *"
        label: "AVG Item Value (Gross)"
        description: "AIV represents the Average value of items (incl. VAT). Excludes fees (gross), before deducting discounts."
        hidden:  no
        type: average
        sql: ${item_value_gross};;
        value_format_name: euro_accounting_2_precision
      }

      measure: avg_item_value_net {
        alias: [avg_product_value_net]
        group_label: "* Monetary Values *"
        label: "AVG Item Value (Net)"
        description: "AIV represents the Average value of product items (excl. VAT). Excludes fees (net), before deducting discounts."
        hidden:  no
        type: average
        sql: ${item_value_net};;
        value_format_name: euro_accounting_2_precision
      }

      measure: avg_delivery_fee_gross {
        group_label: "* Monetary Values *"
        label: "AVG Delivery Fee (Gross)"
        description: "Average value of Delivery Fees (Gross)"
        hidden:  no
        type: average
        sql: coalesce(${shipping_price_gross_amount});;
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

      measure: avg_ratio_customer_to_hub {
        group_label: "* Operations / Logistics *"
        label: "% Riding to Hub vs. Riding to Customer Time"
        description: "AVG [(Riding to Hub Time / Riding to Customer Time) - 1]"
        hidden: no
        type: average
        sql: (${riding_to_hub_time_minutes} / NULLIF(${riding_to_customer_time_minutes}, 0)) - 1 ;;
        value_format: "0%"

      }

      measure: avg_rider_tip {
        group_label: "* Monetary Values *"
        description: "AVG Rider Tip Amount considering Orders where a tip was applied"
        label: "AVG Rider Tip"
        hidden:  no
        type: average
        sql: coalesce(${rider_tip}, 0);;
        value_format_name: euro_accounting_2_precision
      }

       measure: avg_deposit {
        group_label: "* Monetary Values *"
        description: "AVG Deposit Amount considering Orders having items with deposit "
        label: "AVG Deposit"
        hidden:  no
        type: average
        sql: coalesce(${deposit}, 0);;
        value_format_name: euro_accounting_2_precision
      }

      measure: avg_rider_handling_time_minutes_saved_with_stacking  {
        group_label: "* Operations / Logistics *"
        label: "AVG Rider Handling Time Minutes Saved (Stacking)"
        description: "Average number of minutes saved on each order due to stacking (compared to estimated handling time without stacking)"
        hidden: no
        type: average
        sql: ${rider_handling_time_minutes_saved_with_stacking} ;;
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
        description: "Sum of Revenue (GMV after subsidies) incl. VAT. After deduction of discounts, tips and deposit."
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
        label: "SUM Total Discount Amount (Gross)"
        description: "Sum of Discount amount applied on orders. Includes both Product and Cart discounts."
        hidden:  no
        type: sum
        sql: ${discount_amount};;
        value_format_name: euro_accounting_2_precision
      }

      measure: sum_discount_cart_gross {
        group_label: "* Monetary Values *"
        label: "SUM Cart Discount Amount (Gross)"
        description: "Sum of Cart Discounts Gross (voucher applied at a checkout). Includes delivery discounts."
        hidden:  no
        type: sum
        sql: ${amt_discount_cart_gross};;
        value_format_name: euro_accounting_2_precision
      }

      measure: sum_discount_cart_net {
        group_label: "* Monetary Values *"
        label: "SUM Cart Discount Amount (Net)"
        description: "Sum of Cart Discounts Net (voucher applied at a checkout). Includes delivery discounts."
        hidden:  no
        type: sum
        sql: ${amt_discount_cart_net};;
        value_format_name: euro_accounting_2_precision
      }

      measure: sum_discount_products_gross {
        group_label: "* Monetary Values *"
        label: "SUM Product Discount Amount (Gross)"
        description: "Sum of Discount amount (Gross) applied on orders. Includes only Product discounts."
        hidden:  no
        type: sum
        sql: ${amt_discount_products_gross};;
        value_format_name: euro_accounting_2_precision
      }

      measure: sum_discount_products_net {
        group_label: "* Monetary Values *"
        label: "SUM Product Discount Amount (Net)"
        description: "Sum of Discount amount (Net) applied on orders. Includes only Product discounts."
        hidden:  no
        type: sum
        sql: ${amt_discount_products_net};;
        value_format_name: euro_accounting_2_precision
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

      measure: sum_refund_gross {
        group_label: "* Monetary Values *"
        label: "SUM Refund (Gross)"
        description: "Sum of Refunds (Gross). Includes Items, Deposit, Delivery Fee and Tips Refunds."
        hidden:  no
        type: sum
        sql: ${amt_refund_gross};;
        value_format_name: euro_accounting_2_precision
      }

      measure: sum_total_sales_gross {
        group_label: "* Monetary Values *"
        label: "SUM Total Sales (Gross)"
        description: "Sum of Delivery Fees and Items Price and Deposit. Excl. Tips, Donations. Before Deduction of any Discount. Incl. VAT"
        hidden:  no
        type: sum
        sql: ${amt_total_sales_gross};;
        value_format_name: euro_accounting_2_precision
      }

      measure: sum_total_sales_excluding_deposit_gross {
        group_label: "* Monetary Values *"
        label: "SUM Total Sales excl. Deposit (Gross)"
        description: "Sum of Delivery Fees and Items Price. Excl. Deposit, Tips, Donations. Before Deduction of any Discount. Incl. VAT"
        hidden:  no
        type: sum
        sql: ${amt_total_sales_excluding_deposit_gross};;
        value_format_name: euro_accounting_2_precision
      }

      measure: sum_total_sales_after_discounts_gross {
        group_label: "* Monetary Values *"
        label: "SUM Total Sales After Discount (Gross)"
        description: "Sum of Delivery Fees and Items Price and Deposit. Excl. Tips, Donations. After Deduction of Cart and Product Discounts. Incl. VAT"
        hidden:  no
        type: sum
        sql: ${amt_total_sales_after_discount_gross};;
        value_format_name: euro_accounting_2_precision
      }

      measure: sum_total_sales_after_discount_and_refund_gross {
        group_label: "* Monetary Values *"
        label: "SUM Total Sales After Discounts & Refunds (Gross)"
        description: "Sum of Delivery Fees and Items Price and Deposit. Excl. Tips, Donations. After Deduction of Cart and Product Discounts. After Refunds. Incl. VAT"
        hidden:  no
        type: sum
        sql: ${amt_total_sales_after_discount_and_refund_gross};;
        value_format_name: euro_accounting_2_precision
      }

      measure: sum_total_sales_after_discount_and_refund_excluding_deposit_gross {
        group_label: "* Monetary Values *"
        label: "SUM Total Sales After Discounts & Refunds excl. Deposit (Gross)"
        description: "Sum of Delivery Fees and Items Price. Excl. Tips, Deposit, Donations. After Deduction of Cart and Product Discounts. After Refunds. Incl. VAT"
        hidden:  no
        type: sum
        sql: ${amt_total_sales_after_discount_and_refund_excluding_deposit_gross};;
        value_format_name: euro_accounting_2_precision
      }

      measure: sum_gpv_gross {
        group_label: "* Monetary Values *"
        label: "SUM GPV (Gross)"
        description: "Actual amount paid by the customer in CT. Sum of Delivery Fees, Items Price, Tips, Deposit. Excl. Donations. After Deduction of Cart and Product Discounts. Incl. VAT"
        hidden:  no
        type: sum
        sql: ${amt_gpv_gross};;
        value_format_name: euro_accounting_2_precision
      }

      measure: sum_npv_gross {
        group_label: "* Monetary Values *"
        label: "SUM NPV (Gross)"
        description: "Net Payment Value. Actual amount paid by the customer in CT after Refunds. Sum of Delivery Fees, Items Price, Tips, Deposit. Excl. Donations. After Deduction of Cart and Product Discounts. Incl. VAT"
        hidden:  no
        type: sum
        sql: ${amt_gpv_gross};;
        value_format_name: euro_accounting_2_precision
      }

      measure: sum_quantity_fulfilled {
        label: "Item Quantity Fulfilled"
        group_label: "* Basic Counts (Orders / Customers etc.) *"
        description: "Fulfilled Quantity"
        type: sum
        sql: ${number_of_items} ;;
      }

      measure: sum_rider_hours {
        label: "Sum Worked Rider Hours"
        group_label: "* Operations / Logistics *"
        description: "Sum of completed Rider shift Hours"
        type: number
        sql: NULLIF(${shyftplan_riders_pickers_hours.rider_hours},0);;
      }


      measure: order_handling_time_minute {
        label: "Sum Order Handling Time (min)"
        group_label: "* Operations / Logistics *"
        description: "Rider Time spent from claiming an order until returning to the hub "
        type: sum
        hidden: yes
        sql:${TABLE}.rider_handling_time_minutes ;;
        value_format_name: decimal_2
      }

      measure: avg_order_handling_time_minute {
        label: "AVG Order Handling Time (min)"
        group_label: "* Operations / Logistics *"
        description: "AVG ider Time spent from claiming an order until returning to the hub "
        type: average
        hidden: yes
        sql:${TABLE}.rider_handling_time_minutes;;
        value_format_name: decimal_2
      }

      measure: sum_rider_tip {
        group_label: "* Monetary Values *"
        label: "SUM Rider Tip"
        hidden:  no
        type: sum
        sql: ${rider_tip};;
        value_format_name: euro_accounting_2_precision
      }


      measure: sum_avg_queuing_time {
        alias: [sum_avg_acceptance_reaction_time]
        group_label: "* Operations / Logistics *"
        label: "AVG Picker Queuing Time + Rider Queuing Time"
        description: "Sum of the average of rider queuing time and the average of picker queuing time"
        hidden:  no
        type: number
        sql:${avg_rider_queuing_time} + ${avg_picker_queuing_time};;
        value_format_name: decimal_1
      }

      measure: sum_deposit {
        group_label: "* Monetary Values *"
        label: "SUM Total Deposit"
        hidden:  no
        type: sum
        sql: ${deposit};;
        description: "Sum of all deposits, paid by Flink or by the customers "
        value_format_name: euro_accounting_2_precision
      }

      measure: sum_amt_cancelled_gross {
        group_label: "* Cancelled Orders *"
        label: "SUM Cancelled Amount (Gross)"
        hidden:  no
        type: sum
        sql: ${amt_cancelled_gross};;
        value_format_name: euro_accounting_2_precision
      }

      measure: sum_rider_handling_time_minutes_saved_with_stacking  {
        group_label: "* Operations / Logistics *"
        label: "SUM Rider Handling Time Minutes Saved With Stacking"
        description: "Total number of minutes saved on all orders due to stacking (compared to estimated handling time without stacking)"
        hidden: no
        type: sum
        sql: ${rider_handling_time_minutes_saved_with_stacking} ;;
        value_format_name: decimal_1

      }

      measure: sum_rider_handling_time_minutes {
        group_label: "* Operations / Logistics *"
        label: "SUM Rider Handling Ttimes"
        hidden:  no
        type: sum
        sql: ${rider_handling_time_minutes};;
        value_format_name: decimal_1
      }

      measure: sum_potential_rider_handling_time_without_stacking_minutes {
        group_label: "* Operations / Logistics *"
        label: "SUM Potential Rider Handling Times (Without Stacking)"
        description: "Total estimated sum of minutes it would potentially take for a rider to handle all the orders without stacking"
        hidden:  no
        type: sum
        sql: ${potential_rider_handling_time_without_stacking_minutes};;
        value_format_name: decimal_1
      }

      ############
      ## COUNTS ##
      ############

      measure: cnt_unique_customers {
        group_label: "* Basic Counts (Orders / Customers etc.) *"
        label: "# Unique Customers"
        description: "Count of Unique Customers identified via their Customer UUID"
        hidden:  no
        type: count_distinct
        sql: ${customer_uuid};;
        value_format: "0"
      }

      measure: cnt_unique_customers_with_voucher {
        group_label: "* Basic Counts (Orders / Customers etc.) *"
        label: "# Unique Customers (with Cart Discount)"
        description: "Count of Unique Customers identified via their Customer UUID (only considering orders with a cart discount)"
        hidden:  no
        type: count_distinct
        sql: ${customer_uuid};;
        filters: [amt_discount_cart_gross: ">0"]
        value_format: "0"
      }

      measure: cnt_unique_customers_without_voucher {
        group_label: "* Basic Counts (Orders / Customers etc.) *"
        label: "# Unique Customers (without Cart Discount)"
        description: "Count of Unique Customers identified via their Customer UUID (not considering orders with a cart discount)"
        hidden:  no
        type: count_distinct
        sql: ${customer_uuid};;
        filters: [amt_discount_cart_gross: "0 OR null"]
        value_format: "0"
      }

      measure: cnt_unique_hubs {
        group_label: "* Basic Counts (Orders / Customers etc.) *"
        label: "# Unique Hubs"
        description: "Count of Unique Hubs which received orders"
        hidden:  no
        type: count_distinct
        sql: ${hub_code};;
        value_format: "0"
      }

      measure: cnt_orders {
        group_label: "* Basic Counts (Orders / Customers etc.) *"
        label: "# Orders"
        description: "Count of Orders"
        hidden:  no
        type: count_distinct
        sql: ${order_uuid} ;;
        value_format: "0"
      }

    measure: cnt_successful_orders {
      group_label: "* Basic Counts (Orders / Customers etc.) *"
      label: "# Successful Orders"
      description: "Count of Successful Orders"
      hidden:  yes
      type: count_distinct
      sql: ${order_uuid} ;;
      value_format: "0"
      filters: [
        is_successful_order: "yes"
      ]
    }

      measure: cnt_orders_with_discount_cart {
        group_label: "* Basic Counts (Orders / Customers etc.) *"
        label: "# Orders with Cart Discount"
        description: "Count of successful Orders with some Cart Discount applied"
        hidden:  no
        type: count
        filters: [amt_discount_cart_gross: ">0"]
        value_format: "0"
      }

      measure: cnt_orders_with_discount_products {
        group_label: "* Basic Counts (Orders / Customers etc.) *"
        label: "# Orders with Product Discount"
        description: "Number of successful Orders with a Product Discount included"
        hidden:  no
        type: count
        filters: [amt_discount_products_gross: ">0"]
        value_format: "0"
      }

      measure: cnt_orders_without_discount_products {
        group_label: "* Basic Counts (Orders / Customers etc.) *"
        label: "# Orders without Product Discount"
        description: "Number of successful Orders without a Product Discount included"
        hidden:  no
        type: count
        filters: [amt_discount_products_gross: "0 OR null"]
        value_format: "0"
      }

      measure: cnt_orders_without_discount_cart {
        group_label: "* Basic Counts (Orders / Customers etc.) *"
        label: "# Orders without Discount"
        description: "Count of successful Orders with no Cart Discount applied"
        hidden:  no
        type: count
        filters: [amt_discount_cart_gross: "0 OR null"]
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
        label: "# Orders with Delivery PDT available"
        description: "Count of Orders where a PDT is available"
        hidden:  no
        type: count
        filters: [is_delivery_eta_available: "yes"]
        value_format: "0"
      }

    measure: cnt_orders_with_targeted_eta_available {
      # group_label: "* Operations / Logistics *"
      view_label: "* Hubs *"
      group_label: "Hub Leaderboard - Order Metrics"
      label: "# Orders with Targeted Fulfillment Time is available"
      description: "Count of Orders where a Targeted Delivery Time  is available"
      hidden:  no
      type: count
      filters: [is_targeted_eta_available: "yes"]
      value_format: "0"
    }

      measure: cnt_orders_delayed_under_0_min {
        # group_label: "* Operations / Logistics *"
        view_label: "* Hubs *"
        group_label: "Hub Leaderboard - Order Metrics"
        label: "# Orders delivered on time (30 sec tolerance)"
        description: "Count of Orders delivered no later than PDT"
        hidden:  yes
        type: count
        filters: [delivery_delay_since_eta:"<=0.5"]
        value_format: "0"
      }

      measure: cnt_orders_with_rider_tip {
        group_label: "* Basic Counts (Orders / Customers etc.) *"
        label: "# Orders with Rider Tip"
        hidden:  no
        type: count
        filters: [rider_tip: ">0"]
        value_format: "0"
      }

      measure: cnt_cancelled_orders {
        group_label: "* Cancelled Orders *"
        label: "# Cancelled Orders"
        hidden:  no
        type: count
        filters: [amt_cancelled_gross: ">0"]
        value_format: "0"
      }

      measure: cnt_agent_cancelled_orders {
        group_label: "* Cancelled Orders *"
        label: "# Agent Cancelled Orders"
        hidden:  no
        type: count
        filters: [amt_cancelled_gross: ">0",cancellation_category: "- Customer"]
        value_format: "0"
      }

      measure: cnt_self_cancelled_orders {
        group_label: "* Cancelled Orders *"
        label: "# Self Cancelled Orders"
        hidden:  no
        type: count
        filters: [amt_cancelled_gross: ">0",cancellation_category: "Customer"]
        value_format: "0"
      }


      ############### Delays compared to delivery time internal estimate ###########

      measure: cnt_orders_delayed_over_12_min_internal_estimate {
        # group_label: "* Operations / Logistics *"
        view_label: "* Hubs *"
        group_label: "Hub Leaderboard - Order Metrics"
        label: "# Orders delivered late >12min (internal estimate)"
        description: "Count of Orders delivered >12min later than delivery time estimate"
        hidden:  yes
        type: count
        filters: [delivery_delay_since_time_estimate:">=12"]
        value_format: "0"
      }

      measure: cnt_orders_delayed_over_20_min_internal_estimate {
        # group_label: "* Operations / Logistics *"
        view_label: "* Hubs *"
        group_label: "Hub Leaderboard - Order Metrics"
        label: "# Orders delivered late >20min (internal estimate)"
        description: "Count of Orders delivered >20min later than delivery time estimate"
        hidden:  yes
        type: count
        filters: [delivery_delay_since_time_estimate:">=20"]
        value_format: "0"
      }


      measure: cnt_orders_delayed_over_30_min_internal_estimate {
        # group_label: "* Operations / Logistics *"
        view_label: "* Hubs *"
        group_label: "Hub Leaderboard - Order Metrics"
        label: "# Orders delivered late >30min (internal estimate)"
        description: "Count of Orders delivered >30min later than delivery time estimate"
        hidden:  yes
        type: count
        filters: [delivery_delay_since_time_estimate:">=30"]
        value_format: "0"
      }

      measure: cnt_orders_delayed_over_60_min_internal_estimate {
        # group_label: "* Operations / Logistics *"
        view_label: "* Hubs *"
        group_label: "Hub Leaderboard - Order Metrics"
        label: "# Orders delivered late >20min (internal estimate)"
        description: "Count of Orders delivered >60min later than delivery time estimate"
        hidden:  yes
        type: count
        filters: [delivery_delay_since_time_estimate:">=60"]
        value_format: "0"
      }

      measure: cnt_orders_delayed_over_5_min {
        # group_label: "* Operations / Logistics *"
        view_label: "* Hubs *"
        group_label: "Hub Leaderboard - Order Metrics"
        label: "# Orders delivered late >5min"
        description: "Count of Orders delivered >5min later than PDT"
        hidden:  yes
        type: count
        filters: [delivery_delay_since_eta:">=5"]
        value_format: "0"
      }

      measure: cnt_orders_delayed_over_10_min {
        group_label: "* Operations / Logistics *"
        label: "# Orders delivered late >10min"
        description: "Count of Orders delivered >10min later than PDT"
        hidden:  yes
        type: count
        filters: [delivery_delay_since_eta:">=10"]
        value_format: "0"
      }

      measure: cnt_orders_delayed_over_15_min {
        group_label: "* Operations / Logistics *"
        label: "# Orders delivered late >15min"
        description: "Count of Orders delivered >15min later than PDT"
        hidden:  yes
        type: count
        filters: [delivery_delay_since_eta:">=15"]
        value_format: "0"
      }


#######TEMP: adding new fields to compare how PDT versus Time Estimate will perform
      measure: cnt_orders_delayed_under_0_min_time_estimate {
        # group_label: "* Operations / Logistics *"
        view_label: "* Hubs *"
        group_label: "Hub Leaderboard - Order Metrics"
        label: "# Orders delivered in time (time estimate)"
        description: "Count of Orders delivered no later than internal time estimate"
        hidden:  yes
        type: count
        filters: [delivery_delay_since_time_estimate:"<=0"]
        value_format: "0"
      }

    measure: cnt_orders_delayed_under_0_min_time_targeted {
      # group_label: "* Operations / Logistics *"
      view_label: "* Hubs *"
      group_label: "Hub Leaderboard - Order Metrics"
      label: "# Orders delivered in time (time estimate)"
      description: "Count of Orders delivered no later than internal time estimate"
      hidden:  yes
      type: count
      filters: [delivery_delay_since_time_targeted:"<=0"]
      value_format: "0"
    }

      measure: cnt_orders_delayed_over_5_min_time_estimate {
        # group_label: "* Operations / Logistics *"
        view_label: "* Hubs *"
        group_label: "Hub Leaderboard - Order Metrics"
        label: "# Orders delivered in time (time estimate)"
        description: "Count of Orders delivered >5min later than internal time estimate"
        hidden:  yes
        type: count
        filters: [delivery_delay_since_time_estimate:">=5"]
        value_format: "0"
      }

      measure: cnt_orders_delayed_over_10_min_time_estimate {
        # group_label: "* Operations / Logistics *"
        view_label: "* Hubs *"
        group_label: "Hub Leaderboard - Order Metrics"
        label: "# Orders delivered in time (time estimate)"
        description: "Count of Orders delivered >10min later than internal time estimate"
        hidden:  yes
        type: count
        filters: [delivery_delay_since_time_estimate:">=10"]
        value_format: "0"
      }

      measure: cnt_orders_fulfilled_under_15_min {
        group_label: "* Operations / Logistics *"
        label: "# Orders delivered <15min"
        description: "Count of Orders delivered in <15min"
        hidden:  yes
        type: count
        filters: [fulfillment_time:"<15"]
        value_format: "0"
      }

      measure: cnt_orders_fulfilled_over_12_min {
        group_label: "* Operations / Logistics *"
        label: "# Orders delivered >12min"
        description: "Count of Orders delivered in >12min"
        hidden:  yes
        type: count
        filters: [fulfillment_time:">12"]
        value_format: "0"
      }

      measure: cnt_orders_fulfilled_over_20_min {
        group_label: "* Operations / Logistics *"
        label: "# Orders fulfilled >20min"
        description: "Count of Orders delivered >20min fulfillment time"
        hidden:  yes
        type: count
        filters: [fulfillment_time:">20"]
        value_format: "0"
      }

      measure: cnt_orders_fulfilled_over_30_min {
        group_label: "* Operations / Logistics *"
        label: "# Orders fulfilled >30min"
        description: "Count of Orders delivered >30min fulfillment time"
        hidden:  yes
        type: count
        filters: [fulfillment_time:">=30"]
        value_format: "0"
      }

      measure: cnt_orders_fulfilled_over_60_min {
        group_label: "* Operations / Logistics *"
        label: "# Orders delivered >60min"
        description: "Count of Orders delivered in >60min"
        hidden:  yes
        type: count
        filters: [fulfillment_time:">60"]
        value_format: "0"
      }

      measure: cnt_orders_delivery_time_critical_underestimation {
        group_label: "* Operations / Logistics *"
        label:       "# Orders with critical under-estimation delivery time"
        description: "# Orders with critical under-estimation delivery time"
        hidden:      yes
        type:        count
        filters:     [is_critical_delivery_time_estimate_underestimation: "Yes"]
        value_format: "0"
      }

      measure: cnt_orders_delivery_time_critical_overestimation {
        group_label: "* Operations / Logistics *"
        label:       "# Orders with critical over-estimation delivery time"
        description: "# Orders with critical over-estimation delivery time"
        hidden:      yes
        type:        count
        filters:     [is_critical_delivery_time_estimate_overestimation: "Yes"]
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


      measure: cnt_rider {
        label: "# Riders Delivering Orders"
        type: number
        group_label: "* Operations / Logistics *"
        sql:count (distinct ${rider_id});;
        value_format_name: decimal_0
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

      measure: pct_discount_cart_order_share {
        group_label: "* Marketing *"
        label: "% Cart Discount Order Share"
        description: "Share of Orders which had voucher applied at a checkout. Includes delivery discounts."
        hidden:  no
        type: number
        sql: ${cnt_orders_with_discount_cart} / NULLIF(${cnt_orders}, 0);;
        value_format: "0%"
      }

      measure: pct_discount_products_order_share {
       group_label: "* Monetary Values *"
       label: "% Product Discount Order Share"
       description: "Share of Orders which had some product discount applied."
       hidden:  no
       type: number
       sql: ${cnt_orders_with_discount_products} / NULLIF(${cnt_orders}, 0);;
       value_format: "0%"
  }

      measure: pct_discount_cart_value_of_gross_total{
        group_label: "* Marketing *"
        label: "% Cart Discount Value Share"
        description: "Dividing Total Discount Cart amounts over GMV"
        hidden:  no
        type: number
        sql: ${sum_discount_cart_gross} / NULLIF(${sum_gmv_gross}, 0);;
        value_format_name: percent_1
      }

      measure: pct_discount_products_value_of_gross_total{
        group_label: "* Monetary Values *"
        label: "% Product Discount Value Share"
        description: "Dividing Total Discount Products amounts over GMV"
        hidden:  no
        type: number
        sql: ${sum_discount_products_gross} / NULLIF(${sum_gmv_gross}, 0);;
        value_format_name: percent_1
      }

      measure: pct_tip_order_share {
        group_label: "* Basic Counts (Orders / Customers etc.) *"
        label: "% Tip Order Share"
        description: "Share of Orders which had some Rider Tip applied"
        hidden:  no
        type: number
        sql: ${cnt_orders_with_rider_tip} / NULLIF(${cnt_orders}, 0);;
        value_format: "0%"
      }

      measure: pct_tip_value_of_gross_total{
        group_label: "* Basic Counts (Orders / Customers etc.) *"
        label: "% Tip Value Share"
        description: "Dividing Total Rider Tip amounts over GMV"
        hidden:  no
        type: number
        sql: ${sum_rider_tip} / NULLIF(${sum_gmv_gross}, 0);;
        value_format: "0%"
      }

      measure: pct_cancelled_amount_value_of_gross_total{
        group_label: "* Cancelled Orders *"
        label: "% Cancelled Value Share"
        description: "Dividing Total Cancelled amount Gross over GMV Gross"
        hidden:  no
        type: number
        sql: ${sum_amt_cancelled_gross} / NULLIF(${sum_gmv_gross}, 0);;
        value_format: "0.0%"
      }

      measure: pct_cancelled_orders{
        group_label: "* Cancelled Orders *"
        label: "% Cancelled Orders"
        description: "Dividing Number of Cancelled Orders over Number of Orders"
        hidden:  no
        type: number
        sql: ${cnt_cancelled_orders} / NULLIF(${cnt_orders}, 0);;
        value_format: "0.0%"
      }

      measure: pct_self_cancelled_orders{
        group_label: "* Cancelled Orders *"
        label: "% Self Cancelled Orders"
        description: "Dividing Number of Self-Cancelled Orders by Customer over Number of Orders"
        hidden:  no
        type: number
        sql: ${cnt_self_cancelled_orders} / NULLIF(${cnt_orders}, 0);;
        value_format: "0.0%"
      }

      measure: pct_agent_cancelled_orders{
        group_label: "* Cancelled Orders *"
        label: "% Agent Cancelled Orders"
        description: "Dividing Number of Self-Cancelled Orders by CC Agents over Number of Orders"
        hidden:  no
        type: number
        sql: ${cnt_agent_cancelled_orders} / NULLIF(${cnt_orders}, 0);;
        value_format: "0.0%"
      }

      measure: pct_delivery_in_time{
        group_label: "* Operations / Logistics *"
        label: "% Orders delivered in time (PDT)"
        description: "Share of orders delivered no later than PDT (30 sec tolerance)"
        hidden:  no
        type: number
        sql: ${cnt_orders_delayed_under_0_min} / NULLIF(${cnt_orders_with_delivery_eta_available}, 0);;
        value_format: "0%"
      }

      measure: pct_delivery_late_over_5_min{
        group_label: "* Operations / Logistics *"
        label: "% Orders delayed >5min"
        description: "Share of orders delivered >5min later than PDT"
        hidden:  no
        type: number
        sql: ${cnt_orders_delayed_over_5_min} / NULLIF(${cnt_orders_with_delivery_eta_available}, 0);;
        value_format: "0%"
      }

      measure: pct_delivery_late_over_10_min{
        group_label: "* Operations / Logistics *"
        label: "% Orders delayed >10min"
        description: "Share of orders delivered >10min later than PDT"
        hidden:  no
        type: number
        sql: ${cnt_orders_delayed_over_10_min} / NULLIF(${cnt_orders_with_delivery_eta_available}, 0);;
        value_format: "0%"
      }

      measure: pct_delivery_late_over_15_min{
        group_label: "* Operations / Logistics *"
        label: "% Orders delayed >15min"
        description: "Share of orders delivered >15min later than PDT"
        hidden:  no
        type: number
        sql: ${cnt_orders_delayed_over_15_min} / NULLIF(${cnt_orders_with_delivery_eta_available}, 0);;
        value_format: "0%"
      }

      measure: pct_fulfillment_under_15_min{
        group_label: "* Operations / Logistics *"
        label: "% Orders fulfilled <15min"
        description: "Share of orders delivered <15min"
        hidden:  no
        type: number
        sql: ${cnt_orders_fulfilled_under_15_min} / NULLIF(${cnt_orders}, 0);;
        value_format: "0%"
      }

      measure: pct_fulfillment_over_12_min{
        group_label: "* Operations / Logistics *"
        label: "% Orders fulfilled >12min"
        description: "Share of orders delivered >12min"
        hidden:  no
        type: number
        sql: ${cnt_orders_fulfilled_over_12_min} / NULLIF(${cnt_orders}, 0);;
        value_format: "0%"
      }

      measure: pct_fulfillment_over_20_min{
        group_label: "* Operations / Logistics *"
        label: "% Orders fulfilled >20min"
        description: "Share of orders delivered >20min"
        hidden:  no
        type: number
        sql: ${cnt_orders_fulfilled_over_20_min} / NULLIF(${cnt_orders}, 0);;
        value_format: "0%"
      }

      measure: pct_fulfillment_over_60_min{
        group_label: "* Operations / Logistics *"
        label: "% Orders fulfilled >60min"
        description: "Share of orders delivered >60min"
        hidden:  no
        type: number
        sql: ${cnt_orders_fulfilled_over_60_min} / NULLIF(${cnt_orders}, 0);;
        value_format: "0%"
      }
###########  Delays with regards to Delivery Time Internal Estimate

      measure: pct_delayed_over_12_min_internal_estimate {
        group_label: "* Operations / Logistics *"
        label: "% Orders delayed >12min (Internal Estimate)"
        description: "Share of orders delayed >12min than Delivery Time Internal Estimate"
        hidden:  no
        type: number
        sql: ${cnt_orders_delayed_over_12_min_internal_estimate} / NULLIF(${cnt_orders}, 0);;
        value_format: "0%"
      }

      measure: pct_delayed_over_20_min_internal_estimate {
        group_label: "* Operations / Logistics *"
        label: "% Orders delayed >20min (Internal Estimate)"
        description: "Share of orders delayed >20min than Delivery Time Internal Estimate"
        hidden:  no
        type: number
        sql: ${cnt_orders_delayed_over_20_min_internal_estimate} / NULLIF(${cnt_orders}, 0);;
        value_format: "0%"
      }

      measure: pct_delayed_over_30_min_internal_estimate {
        group_label: "* Operations / Logistics *"
        label: "% Orders delayed >30min (Internal Estimate)"
        description: "Share of orders delayed >30min than Delivery Time Internal Estimate"
        hidden:  no
        type: number
        sql: ${cnt_orders_delayed_over_30_min_internal_estimate} / NULLIF(${cnt_orders}, 0);;
        value_format: "0%"
      }

      measure: pct_delayed_over_60_min_internal_estimate {
        group_label: "* Operations / Logistics *"
        label: "% Orders delayed >60min (Internal Estimate)"
        description: "Share of orders delayed >60min than Delivery Time Internal Estimate"
        hidden:  no
        type: number
        sql: ${cnt_orders_delayed_over_60_min_internal_estimate} / NULLIF(${cnt_orders}, 0);;
        value_format: "0%"
      }

      measure: pct_rider_handling_time_saved_with_stacking {
        group_label: "* Operations / Logistics *"
        label: "% Rider Handling Time Saved Due To Stacking"
        description: "% Total rider handling time savings achieved due to stacking. Compares estimated savings with the potential rider handling time without stacking."
        hidden:  no
        type: number
        sql: ${sum_rider_handling_time_minutes_saved_with_stacking} / NULLIF(${sum_potential_rider_handling_time_without_stacking_minutes}, 0);;
        value_format: "0%"
      }

      measure: pct_rider_handling_time_saved_with_stacking_vs_non_stacked {
        group_label: "* Stacked Orders *"
        label: "% Rider Handling Time Saved Stacked vs. Non-Stacked Orders"
        description: "Compared to non-stacked orders' average rider handling time, what are the % savings for stacked orders"
        hidden:  no
        type: number
        sql: (${avg_rider_handling_time_non_stacked} - ${avg_rider_handling_time_stacked})/${avg_rider_handling_time_non_stacked};;
        value_format: "0%"
      }

#######TEMP: adding new fields to compare how PDT versus Time Estimate will perform

      measure: pct_delivery_in_time_time_estimate{
        group_label: "* Operations / Logistics *"
        label: "% Orders delivered in time (targeted estimate)"
        description: "Share of orders delivered no later than targeted estimate"
        hidden:  no
        type: number
        sql: ${cnt_orders_delayed_under_0_min_time_targeted} / NULLIF(${cnt_orders_with_targeted_eta_available}, 0);;
        value_format: "0%"
      }

      ###### The below measure should not be removed

      measure: pct_delivery_late_over_5_min_time_estimate{
        group_label: "* Operations / Logistics *"
        label: "% Orders delayed >5min (internal estimate)"
        description: "Share of orders delivered >5min later than internal estimate"
        hidden:  no
        type: number
        sql: ${cnt_orders_delayed_over_5_min_time_estimate} / NULLIF(${cnt_orders_with_delivery_eta_available}, 0);;
        value_format: "0%"
      }

      measure: pct_delivery_late_over_10_min_time_estimate{
        group_label: "* Operations / Logistics *"
        label: "% Orders delayed >10min (internal estimate)"
        description: "Share of orders delivered >10min later than internal estimate"
        hidden:  no
        type: number
        sql: ${cnt_orders_delayed_over_10_min_time_estimate} / NULLIF(${cnt_orders_with_delivery_eta_available}, 0);;
        value_format: "0%"
      }

      # measure: pct_idle {
      #   label: "% Rider Idle Time"
      #   group_label: "* Operations / Logistics *"
      #   description: "% Rider Time spent not working on an order (not Occupied ) "
      #   type: number
      #   sql: 1 - ((${order_handling_time_minute}/60)/NULLIF(${shyftplan_riders_pickers_hours.rider_hours},0));;
      #   value_format_name:  percent_1
      # }


#######TEMP: adding new fields to compare how PDT versus Time Estimate will perform

#### ADDED PERMANENTLY --- SEE LINE 1873

      #measure: pct_fulfillment_over_20_min{
      #  group_label: "* Operations / Logistics *"
      #  label: "% Orders fulfilled >20min"
      #  description: "Share of orders delivered > 20min"
      #  hidden:  no
      #  type: number
      #  sql: ${cnt_orders_fulfilled_over_20_min} / NULLIF(${cnt_orders}, 0);;
      #  value_format: "0%"
      #}

      measure: pct_fulfillment_over_30_min{
        group_label: "* Operations / Logistics *"
        label: "% Orders fulfilled >30min"
        description: "Share of orders delivered > 30min"
        hidden:  no
        type: number
        sql: ${cnt_orders_fulfilled_over_30_min} / NULLIF(${cnt_orders}, 0);;
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
        value_format: "0.00"
        html:  {{rendered_value}}  || # {{ cnt_unique_hubs._rendered_value }} unique hubs ;;
      }

      measure: avg_daily_orders_per_hub{
        group_label: "* Basic Counts (Orders / Customers etc.) *"
        label: "AVG Daily Orders per hub"
        type: number
        sql: (${cnt_orders}/NULLIF(${cnt_unique_hubs},0))/ NULLIF(${cnt_unique_date},0);;

        value_format_name:decimal_2
      }


      measure: pct_delivery_time_estimate_critical_over_estimation {
        group_label: "* Operations / Logistics *"
        label:       "% Orders with critical over-estimation of delivery time"
        description: "% Orders with critical over-estimation of delivery time"
        type:        number
        sql:         ${cnt_orders_delivery_time_critical_overestimation} / ${cnt_orders} ;;
        value_format_name:  percent_2
      }

      measure: pct_delivery_time_estimate_critical_under_estimation {
        group_label: "* Operations / Logistics *"
        label:       "% Orders with critical under-estimation of delivery time"
        description: "% Orders with critical under-estimation of delivery time"
        type:        number
        sql:         ${cnt_orders_delivery_time_critical_underestimation} / ${cnt_orders} ;;
        value_format_name:  percent_2
      }

      measure: cnt_orders_with_delivery_time_estimate {
        group_label: "* Operations / Logistics *"
        label: "# Orders with Fulfillment Time Estimate"
        hidden:  yes
        type: count
        filters: [delivery_time_estimate_minutes: ">0", fulfillment_time: ">0"]
        value_format: "0"
      }

      measure: cnt_orders_with_delivery_time_targeted {
        group_label: "* Operations / Logistics *"
        label: "# Orders with Fulfillment Time Targeted"
        hidden:  yes
        type: count
        filters: [delivery_time_targeted_minutes: ">0", fulfillment_time: ">0"]
        value_format: "0"
      }

      measure: rmse_delivery_time_estimate {
        label: "Fulfillment Time Estimate Error (RMSE)"
        description: "The root-mean-squared-error when comparing actuall fulfillment times and predicted delivery estimate times"
        group_label: "* Operations / Logistics *"
        type: number
        sql: sqrt(sum(power((${fulfillment_time}- ${delivery_time_estimate_minutes}), 2)) / nullif(${cnt_orders_with_delivery_time_estimate}, 0) )  ;;
        value_format_name: decimal_2
      }

      measure: delta_return_delivery_time {
        group_label: "* Operations / Logistics *"
        label: "Delta between Riding to Customer Time and Riding to Hub Time"
        type: number
        value_format: "0.0"
        sql: ${avg_riding_to_customer_time} - ${avg_riding_to_hub_time} ;;
      }


    }
