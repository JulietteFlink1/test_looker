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
      delivery_pdt_timestamp_raw,
      delivery_timestamp_raw
    ]
  }

  dimension:  waiting_for_rider_decision_time_minutes {
    alias: [acceptance_time, rider_queuing_time, waiting_for_rider_time_minutes]
    type: number
    group_label: "* Operations / Logistics *"
    hidden: no
    sql: ${TABLE}.waiting_for_rider_decision_time_minutes ;;
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
    tiers: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50]
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

  dimension: item_value_after_product_discount_gross {

    group_label: "* Monetary Values *"
    type: number
    hidden: no
    sql: ${TABLE}.amt_total_price_after_product_discount_gross
      ;;
  }

  dimension: item_value_net {

    alias: [amt_total_price_net]
    group_label: "* Monetary Values *"
    type: number
    hidden: no
    sql: ${TABLE}.amt_total_price_net   ;;
  }

  dimension: item_value_after_product_discount_net {

    group_label: "* Monetary Values *"
    type: number
    hidden: no
    sql: ${TABLE}.amt_total_price_after_product_discount_net
      ;;
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

  dimension: item_value_gross_tier_minus_discounts{
    group_label: "* Monetary Values *"
    description: "Tiers for item value minus cart and product discount"
    label: "Item Value minus discounts (tiered)"
    type: tier
    tiers: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 32, 34, 36, 38, 40, 45, 50, 55, 60, 65, 70, 75, 80, 90, 100, 110, 120, 130]
    style: relational
    sql: ${TABLE}.amt_total_price_after_product_discount_gross -  ${TABLE}.amt_discount_cart_gross;;
  }

  dimension: rider_tip {
    group_label: "* Monetary Values *"
    type: number
    hidden: no
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
    required_access_grants: [can_access_pii_customers]
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
    hidden: yes
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
      day_of_week_index,
      week_of_year,
      week,
      month,
      month_num,
      quarter,
      quarter_of_year,
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

  dimension_group: delivery_pdt_timestamp {
    alias: [delivery_eta_timestamp]
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

  dimension: delivery_delay_since_pdt {
    alias: [delivery_delay_since_eta]
    group_label: "* Operations / Logistics *"
    label: "Delivery delay to PDT (min)"
    description: "Delay versus promised delivery time (as shown to customer)"
    type: number
    sql: ${TABLE}.delivery_delay_since_pdt_minutes ;;
  }

  dimension: delta_to_pdt_minutes {
    group_label: "* Operations / Logistics *"
    label: "Delta to PDT (min)"
    description: "Delta to promised delivery time (as shown to customer)"
    type: number
    sql: ${TABLE}.delta_to_pdt_minutes ;;
  }

  dimension: delivery_delay_since_pdt_seconds {
    alias: [delivery_delay_since_eta_seconds]
    group_label: "* Operations / Logistics *"
    label: "Delivery delay to PDT (sec)"
    description: "Delay versus promised delivery time in seconds (as shown to customer)"
    hidden: yes
    type: number
    sql: ${TABLE}.delivery_delay_since_pdt_minutes * 60 ;;
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

  dimension: is_gps_order {
    group_label: "* Order Dimensions *"
    description: "A flag for outdoor orders (orders with non-address location)"
    type: yesno
    sql: ${TABLE}.is_gps_order ;;
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

  dimension: riding_hub_to_customer_time_minutes {
    group_label: "* Operations / Logistics *"
    description: "The time for a rider to cycle from the hub to the customer. No matter the stacking sequence, it captures the total time from hub to customer."
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
    description: "Total time needed for the rider to handle the order: Riding to customer + At customer + Riding to hub. For DaaS orders it is the time from rider on route to order delivered."
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
    label: "Discount Code ID"
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
    label: "Pick-Pack Handling Time Estimate (min)"
    description: "The internally predicted time in minutes for the pick-pack handling time."
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

  dimension: estimated_waiting_for_picker_time_minutes {
    alias: [estimated_queuing_time_for_picker_minutes]
    label: "Picker Queuing Time Estimate (min)"
    description: "The internally predicted time in minutes for the picker queuing"
    group_label: "* Operations / Logistics *"
    type: number
    sql: ${TABLE}.estimated_waiting_for_picker_time_minutes;;
  }

  dimension: queuing_time_for_picker_minutes {
    label: "Waiting For Picker Time (min)"
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
    description: "Withheld From Picking + Waiting For Picker Time + Pick-Pack Handling Time + Withheld From Rider + Waiting For Rider Time"
    group_label: "* Operations / Logistics *"
    type: number
    sql: ${waiting_for_picker_time} + ${waiting_for_rider_decision_time_minutes} + ${pick_pack_handling_time_minutes} + coalesce(${withheld_from_picking_time_minutes},0) + coalesce(${waiting_for_available_rider_time_minutes},0) + coalesce(${waiting_for_trip_readiness_time_minutes},0);;
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

  dimension: is_critical_pdt_underestimation {
    description: "The actual fulfillment took more than 10min longer than the PDT"
    type:  yesno
    sql: ${fulfillment_time_raw_minutes} > (10 + ${delivery_eta_minutes}) ;;
    hidden: yes
  }

  dimension: is_critical_pdt_overestimation {
    description: "The actual fulfillment took more than 10min less than the PDT"
    type:  yesno
    sql: ${fulfillment_time_raw_minutes} < (${delivery_eta_minutes} - 10) ;;
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

  dimension: waiting_for_rider_decision_time_tier{
    alias: [acceptance_time_tier, rider_queuing_time_tier, waiting_for_rider_time_tier]
    group_label: "* Operations / Logistics *"
    label: "Waiting for Rider Time (tiered, 1min)"
    type: tier
    tiers: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30]
    style: interval
    sql: ${waiting_for_rider_decision_time_minutes} ;;
  }

  dimension: waiting_for_picker_time_tier {
    alias: [reaction_time_tier]
    group_label: "* Operations / Logistics *"
    label: "Waiting For Picker Time (tiered, 1min)"
    type: tier
    tiers: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30]
    style: interval
    sql: ${waiting_for_picker_time} ;;
  }

  dimension: is_riding_to_customer_above_30_minute {
    label: "Is Riding To Customer Above 30min"
    group_label: "* Operations / Logistics *"
    type: yesno
    sql: ${TABLE}.is_riding_to_customer_above_30_minute ;;
  }

  dimension: turf_name {
    group_label: "* Operations / Logistics *"
    label: "Turf Name"
    description: "This field reflects the Turf (aka Delivery Tier) which the order was assigned to (e.g. core, turf12, turf20 etc.). If a hub has multiple Turfs, this reflects the Turf which covers the customer location"
    type: string
    sql: ${TABLE}.turf_name ;;
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

  dimension: is_product_discounted_order{
    group_label: "* Order Dimensions *"
    label: "Is Product Discounted Order (Yes/No)"
    description: "Flags if an Order has a Product Discount (Commercial) applied"
    type: yesno
    sql: ${TABLE}.is_product_discounted_order ;;
  }

  dimension: is_cart_discounted_order{
    group_label: "* Order Dimensions *"
    label: "Is Cart Discounted Order (Yes/No)"
    description: "Flags if an Order has a Cart Discount (Marketing) applied"
    type: yesno
    sql: ${TABLE}.is_cart_discounted_order ;;
  }

  dimension: is_first_order {
    group_label: "* Order Dimensions *"
    type: yesno
    sql: ${TABLE}.is_first_order ;;
  }

  dimension: is_rider_tip {
    group_label: "* Order Dimensions *"
    label: "Is Rider Tip Order (Yes/No)"
    description: "Flags if an Order contained a tip for the rider"
    type: yesno
    sql: ${TABLE}.amt_rider_tip > 0  ;;
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

  dimension: is_waiting_for_rider_time_less_than_0_minute {
    alias: [is_acceptance_less_than_0_minute, is_rider_queuing_time_less_than_0_minute]
    hidden: yes
    group_label: "* Operations / Logistics *"
    type: yesno
    sql: ${waiting_for_rider_decision_time_minutes} < 0 ;;
  }

  dimension: is_waiting_for_rider_time_more_than_30_minute {
    alias: [is_acceptance_more_than_30_minute, is_rider_queuing_time_more_than_30_minute]
    hidden: yes
    group_label: "* Operations / Logistics *"
    type: yesno
    sql: ${waiting_for_rider_decision_time_minutes} > 30 ;;
  }

  dimension: is_waiting_for_picker_time_less_than_0_minute {
    alias: [is_reaction_less_than_0_minute, is_picker_queuing_less_than_0_minute]
    hidden: yes
    group_label: "* Operations / Logistics *"
    type: yesno
    sql: ${waiting_for_picker_time} < 0 ;;
  }

  dimension: is_waiting_for_picker_time_more_than_30_minute {
    alias: [is_reaction_more_than_30_minute, is_picker_queuing_more_than_30_minute]
    hidden: yes
    group_label: "* Operations / Logistics *"
    type: yesno
    sql: ${waiting_for_picker_time} > 30 ;;
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

  dimension: order_was_withheld {
    group_label: "* Operations / Logistics *"
    label: "Was the order withheld (Yes/No)?"
    description: "Checks if the order was withheld from hub back into dispatching queue (withheld queue) at least once."
    type: yesno
    sql: ${TABLE}.order_was_withheld ;;
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
      minute,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.last_modified_at ;;
    hidden: yes
    convert_tz: yes
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
    group_label: "* Operations / Logistics *"
    label: "Rider Arrived At Customer"
    type: time
    timeframes: [
      raw,
      time,
      minute15,
      minute30,
      hour_of_day,
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
    hidden: yes
  }

  dimension: hour {
    hidden: yes
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
    link: {
      label: "See Order in CT"
      url: "https://mc.europe-west1.gcp.commercetools.com/flink-production/orders/{{ id._value | url_encode }}/general"
    }
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
    link: {
      label: "See Order in CT"
      url: "https://mc.europe-west1.gcp.commercetools.com/flink-production/orders/{{ id._value | url_encode }}/general"
    }
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

  dimension: order_offered_to_hub_timestamp {
    group_label: "* Operations / Logistics *"
    label: "Order Offered to Hub Timestamp"
    description: "Order offered to hub from dispatching events. Takes the last event if there are multiple *offered* events"
    type: date_time
    sql: ${TABLE}.order_offered_to_hub_timestamp ;;
  }

  dimension: order_offered_to_rider_timestamp {
    group_label: "* Operations / Logistics *"
    label: "Order Offered to Rider Timestamp"
    description: "Timestamp at which an order was offered to a rider."
    type: date_time
    sql: ${TABLE}.order_offered_to_rider_timestamp ;;
  }

  dimension: order_withheld_timestamp {
    group_label: "* Operations / Logistics *"
    label: "Order Withheld from Hub"
    description: "Order withheld back into the dispatching (withheld) queue (if any). Takes the last event if there are multiple *withheld* events"
    type: date_time
    sql: ${TABLE}.order_withheld_timestamp ;;
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
    link: {
      label: "See Order in CT"
      url: "https://mc.europe-west1.gcp.commercetools.com/flink-production/orders/{{ id._value | url_encode }}/general"
    }
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

  dimension: start_picking_to_first_scan_time_seconds {
    group_label: "* Operations / Logistics *"
    label: "Start Picking to First Item Scan Time (Seconds)"
    description: "Duration between the timestamp at which the picker clicked on 'Start Picking' and the first item scanned.
    In seconds."
    type: number
    sql: ${TABLE}.start_picking_to_first_scan_time_seconds ;;
    value_format_name: decimal_1
  }

  dimension: first_item_scan_to_last_item_scan_time_seconds {
    group_label: "* Operations / Logistics *"
    label: "First Item Scan to Last Item Scan Time (Seconds)"
    description: "Duration between the first and last items scanned. In seconds."
    type: number
    sql: ${TABLE}.first_item_scan_to_last_item_scan_time_seconds ;;
    value_format_name: decimal_1
  }

  dimension: last_item_to_click_scan_container_time_seconds {
    group_label: "* Operations / Logistics *"
    label: "Last Item Scan to Click Scan Container Time (Seconds)"
    description: "Duration between the last item scanned and the timestamp at which the
    picker clicked on 'Scan Container'. In seconds."
    type: number
    sql: ${TABLE}.last_item_to_click_scan_container_time_seconds ;;
    value_format_name: decimal_1
  }

  dimension: click_scan_container_to_validate_container_scan_time_seconds {
    group_label: "* Operations / Logistics *"
    label: "Click Scan Container to Validate Container Scan Time (Seconds)"
    description: "Duration between the times at which the picker clicked on 'Scan Container'
    and on 'Next Step' to validate the containers scanned. In seconds."
    type: number
    sql: ${TABLE}.click_scan_container_to_validate_container_scan_time_seconds ;;
    value_format_name: decimal_1
  }

  dimension: click_scan_container_to_skip_container_time_seconds {
    group_label: "* Operations / Logistics *"
    label: "Click Scan Container to Skip Container Scan Time (Seconds)"
    description: "Duration between the times at which the picker clicked on 'Scan Container'
    and 'Skip Scanning' to skip the containers' scanning. In seconds."
    type: number
    sql: ${TABLE}.click_scan_container_to_skip_container_time_seconds ;;
    value_format_name: decimal_1
  }

  dimension: validate_container_scan_to_validate_shelf_scan_time_seconds {
    group_label: "* Operations / Logistics *"
    label: "Validate Container Scan to Validate Shelf Scan Time (Seconds)"
    description: "Duration between the times at which the picker clicked on 'Next Step' (after scanning the containers)
    and 'Finish Picking' to assign the scanned shelves. In seconds."
    type: number
    sql: ${TABLE}.validate_container_scan_to_validate_shelf_scan_time_seconds ;;
    value_format_name: decimal_1
  }

  dimension: skip_container_to_skip_shelf_time_seconds {
    group_label: "* Operations / Logistics *"
    label: "Skip Containers Scan to Skip Shelves Scan Time (Seconds)"
    description: "Duration between the times at which the picker clicked on 'Skip Scanning' (on the Scan Container screen)
    and 'Skip Scanning' (on the Assign Shelves screen) to skip the shelves' scanning. In seconds."
    type: number
    sql: ${TABLE}.skip_container_to_skip_shelf_time_seconds ;;
    value_format_name: decimal_1
  }

  dimension: picking_time_seconds_actual {
    group_label: "* Operations / Logistics *"
    label: "Picking Time (Seconds)"
    description: "Duration between the times at which the picker clicked on 'Start Picking'
    and 'Scan Container' (if not available, the last item scan timestamp is used). In seconds."
    type: number
    sql: ${TABLE}.picking_time_seconds ;;
    value_format_name: decimal_1
  }

  dimension: picking_time_minutes_actual {
    group_label: "* Operations / Logistics *"
    label: "Picking Time (Minutes)"
    description: "Duration between the times at which the picker clicked on 'Start Picking'
    and 'Scan Container' (if not available, the last item scan timestamp is used). In minutes."
    type: number
    sql: ${TABLE}.picking_time_minutes ;;
    value_format_name: decimal_2
  }

  dimension: packing_time_seconds {
    group_label: "* Operations / Logistics *"
    label: "Packing Time (Seconds)"
    description: "Duration between the times at which the picker clicked on 'Scan Container'
    and 'Finish Picking' (if 'Scan Container' is not available, the last item scan timestamp is used). In seconds."
    type: number
    sql: ${TABLE}.packing_time_seconds ;;
    value_format_name: decimal_1
  }

  dimension: packing_time_minutes {
    group_label: "* Operations / Logistics *"
    label: "Packing Time (Minutes)"
    description: "Duration between the times at which the picker clicked on 'Scan Container'
    and 'Finish Picking' (if 'Scan Container' is not available, the last item scan timestamp is used). In minutes."
    type: number
    sql: ${TABLE}.packing_time_minutes ;;
    value_format_name: decimal_2
  }

  dimension: pick_pack_handling_time_seconds {
    group_label: "* Operations / Logistics *"
    label: "Pick-Pack Handling Time (Seconds)"
    description: "Time it took for the picker to pick the order and pack it. In seconds. Outliers excluded (<0min or >30min).
    It corresponds to the duration between the times at which the picker clicked on 'Start Picking' and 'Finish Picking'."
    type: number
    sql: ${TABLE}.pick_pack_handling_time_seconds ;;
    value_format_name: decimal_1
  }

  dimension: pick_pack_handling_time_minutes {
    alias: [picking_time_minutes]
    group_label: "* Operations / Logistics *"
    label: "Pick-Pack Handling Time (Minutes)"
    description: "Time it took for the picker to pick the order and pack it. In minutes. Outliers excluded (<0min or >30min).
    It corresponds to the duration between the times at which the picker clicked on 'Start Picking' and 'Finish Picking'."
    type: number
    sql: ${TABLE}.pick_pack_handling_time_minutes ;;
    value_format_name: decimal_2
  }

  dimension: waiting_for_picker_time {
    alias: [reaction_time, picker_queuing_time]
    group_label: "* Operations / Logistics *"
    label: "Waiting For Picker Time Minutes"
    type: number
    sql: ${TABLE}.waiting_for_picker_time_minutes ;;
  }

  dimension: withheld_from_picking_time_minutes {
    alias: [dispatching_queuing_time_minutes]
    group_label: "* Operations / Logistics *"
    label: "Withheld From Picking Time Minutes"
    description: "Dispatch-related (withheld) queuing time - from order created to order offered to hub for picking. Outliers excluded (<0min or >120min)"
    type: number
    sql: ${TABLE}.withheld_from_picking_time_minutes ;;
  }

  dimension: waiting_for_available_rider_time_minutes {
    alias: [withheld_from_rider_time_minutes]
    group_label: "* Operations / Logistics *"
    label: "Waiting For Available Rider Time Minutes"
    description: "Number of minutes an order waited for an available rider in order to be offered."
    type: number
    sql: ${TABLE}.waiting_for_available_rider_time_minutes ;;
  }

  dimension: waiting_for_trip_readiness_time_minutes {
    group_label: "* Operations / Logistics *"
    label: "Waiting For Trip Readiness Time Minutes"
    description: "Number of minutes an order waited for other orders in the stack to be ready."
    type: number
    sql: ${TABLE}.waiting_for_trip_readiness_time_minutes ;;
  }

  dimension: rider_preparing_for_trip_time_minutes {
    group_label: "* Operations / Logistics *"
    label: "Rider Preparing For Trip Time Minutes"
    description: "Total number of minutes between Claimed and On Route state changes. Signifies the time a rider needed to scan containers and start the trip."
    type: number
    sql: ${TABLE}.rider_preparing_for_trip_time_minutes ;;
  }

  dimension: at_customer_time_minutes {
    group_label: "* Operations / Logistics *"
    label: "At Customer Time Minutes"
    type: number
    sql: ${TABLE}.at_customer_time_minutes ;;
  }

  dimension: number_of_offered_to_riders_events {
    group_label: "* Operations / Logistics *"
    label: "Total number of Offered to Riders events an order had. Multiple events might mean offers were rejected by riders or expired."
    type: number
    sql: ${TABLE}.number_of_offered_to_riders_events ;;
  }

  dimension: number_of_withheld_from_riders_events {
    group_label: "* Operations / Logistics *"
    label: "Total number of Withheld From Riders events an order had. Multiple events might mean an order's trip changed several times."
    type: number
    sql: ${TABLE}.number_of_withheld_from_riders_events ;;
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
    tiers: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30]
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

  dimension: is_last_mile_order {
    group_label: "* Order Dimensions *"
    type: yesno
    sql: ${TABLE}.is_last_mile_order ;;
    description: "TRUE if the order is delivered by flink's riders.
    Not click and collect order, not delivered by an external provider (e.g. uber direct), not created through an external provider (e.g. uber-eats and wolt). Doordash orders are included as they are delivered by Flink's riders."
  }

  dimension: is_daas_order {
    group_label: "* Order Dimensions *"
    label: "Is DaaS Order"
    type: yesno
    sql: ${TABLE}.is_daas_order ;;
    description: "TRUE if the order is created on the Flink app but delivered by an external provider (e.g. Uber Direct)."
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
    description: "Takes values CS Agent or Customer depending on the person who initiated the cancellation.
    All CT cancelled orders are considered to be CS Agent"
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

  ########### STORAGE FEES ##########

  dimension: amt_storage_fee_gross {
    hidden:  yes
    type: number
    sql: ${TABLE}.amt_storage_fee_gross ;;
  }
  dimension: amt_storage_fee_net {
    hidden:  yes
    type: number
    sql: ${TABLE}.amt_storage_fee_net ;;
  }

  ########### LATE NIGHT FEES ##########

  dimension: amt_late_night_fee_gross {
    hidden:  yes
    type: number
    sql: ${TABLE}.amt_late_night_fee_gross ;;
  }

  dimension: amt_late_night_fee_net {
    hidden:  yes
    type: number
    sql: ${TABLE}.amt_late_night_fee_net ;;
  }

  ########### CRF FEES DIMENSIONS ##########

  dimension: amt_gmv_excluding_crf_fees_gross {
    hidden:  yes
    type: number
    sql: ${TABLE}.amt_gmv_excluding_crf_fees_gross ;;
  }
  dimension: amt_gmv_excluding_crf_fees_net {
    hidden:  yes
    type: number
    sql: ${TABLE}.amt_gmv_excluding_crf_fees_net ;;
  }
  dimension: amt_crf_total_fee_gross {
    hidden:  yes
    type: number
    sql: ${TABLE}.amt_crf_total_fee_gross ;;
  }
  dimension: amt_crf_total_fee_net {
    hidden:  yes
    type: number
    sql: ${TABLE}.amt_crf_total_fee_net ;;
  }
  dimension: amt_crf_markdown_fee_gross {
    hidden:  yes
    type: number
    sql: ${TABLE}.amt_crf_markdown_fee_gross ;;
  }
  dimension: amt_crf_markdown_fee_net {
    hidden:  yes
    type: number
    sql: ${TABLE}.amt_crf_markdown_fee_net ;;
  }
  dimension: amt_crf_it_cost_fee_gross {
    hidden:  yes
    type: number
    sql: ${TABLE}.amt_crf_it_cost_fee_gross ;;
  }
  dimension: amt_crf_it_cost_fee_net {
    hidden:  yes
    type: number
    sql: ${TABLE}.amt_crf_it_cost_fee_net ;;
  }
  dimension: amt_crf_fulfillment_fee_gross {
    hidden:  yes
    type: number
    sql: ${TABLE}.amt_crf_fulfillment_fee_gross ;;
  }
  dimension: amt_crf_fulfillment_fee_net {
    hidden:  yes
    type: number
    sql: ${TABLE}.amt_crf_fulfillment_fee_net ;;
  }

  ############################  MARKETPLACE INTEGRATIONS   #######################

  ########### UberEats #############

  dimension: amt_uber_eats_commission_fee_net {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_uber_eats_commission_fee_net ;;
  }

  dimension: amt_uber_eats_commission_fee_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_uber_eats_commission_fee_gross ;;
  }

########### WOLT #############

  dimension: amt_wolt_commission_fee_net {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_wolt_commission_fee_net ;;
  }

  dimension: amt_wolt_commission_fee_gross {
    hidden: yes
    type: number
    sql: ${TABLE}.amt_wolt_commission_fee_gross ;;
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

  parameter: is_after_crf_fees_deduction {
    type: yesno
    label: "Is after CRF Fees Deduction"
    default_value: "No"
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


  measure: avg_item_value_gross_dynamic {
    group_label: "* Monetary Values *"
    label: "AVG Item Value (Dynamic) (Gross)"
    description: "AIV represents the Average value of items (incl. VAT). Excludes fees (gross). before deducting Cart Discounts. To be used together with the Is After Product Discounts Deduction parameter."
    label_from_parameter: global_filters_and_parameters.is_after_product_discounts
    value_format_name: eur
    type: number
    sql:
    {% if global_filters_and_parameters.is_after_product_discounts._parameter_value == 'true' %}
    ${avg_item_value_after_product_discount_gross}
    {% elsif global_filters_and_parameters.is_after_product_discounts._parameter_value == 'false' %}
    ${avg_item_value_gross}
    {% endif %}
    ;;
  }

  measure: avg_item_value_net_dynamic {
    group_label: "* Monetary Values *"
    label: "AVG Item Value (Dynamic) (Net)"
    description: "AIV represents the Average value of items (excl. VAT). Excludes fees (net). before deducting Cart Discounts. To be used together with the Is After Product Discounts Deduction parameter."
    label_from_parameter: global_filters_and_parameters.is_after_product_discounts
    value_format_name: eur
    type: number
    sql:
    {% if global_filters_and_parameters.is_after_product_discounts._parameter_value == 'true' %}
    ${avg_item_value_after_product_discount_net}
    {% elsif global_filters_and_parameters.is_after_product_discounts._parameter_value == 'false' %}
    ${avg_item_value_net}
    {% endif %}
    ;;
  }

  ##############
  ## AVERAGES ##
  ##############


  measure: count {
    type: count
    hidden: yes
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
    description: "Average Fulfillment Time (decimal minutes) considering order placement to delivery (rider at customer, or order delivered for DaaS orders). Outliers excluded (<3min or >210min)"
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

  measure: avg_withheld_from_picking_time_minutes {
    alias: [avg_dispatching_queuing_time_minutes]
    group_label: "* Operations / Logistics *"
    label: "AVG Withheld From Picking Time"
    description: "Average dispatch-related (withheld) queuing time - from order created to order offered to hub for picking. Outliers excluded (<0min or >120min)"
    type: average
    sql:${withheld_from_picking_time_minutes};;
    value_format_name: decimal_1
  }

  measure: avg_number_of_offered_to_riders_events {
    group_label: "* Operations / Logistics *"
    label: "AVG Offered To Riders Events"
    description: "Average number of Offered to Riders events orders had. Multiple events might mean offers were rejected by riders or expired."
    type: average
    sql: ${number_of_offered_to_riders_events};;
    value_format_name: decimal_1
  }

  measure: avg_number_of_withheld_from_riders_events {
    group_label: "* Operations / Logistics *"
    label: "AVG Withheld From Riders Events"
    description: "Average number of Withheld From Riders events orders had. Multiple events might mean an order's trip changed several times."
    type: average
    sql: ${number_of_withheld_from_riders_events};;
    value_format_name: decimal_1
  }

  measure: avg_waiting_for_available_rider_time_minutes {
    alias: [avg_withheld_from_rider_time_minutes]
    group_label: "* Operations / Logistics *"
    label: "AVG Waiting For Available Rider Time (Minutes)"
    description: "Average time an order waited for an available rider in order to be offered. Outliers excluded (<0min or >120min)"
    type: average
    sql: ${waiting_for_available_rider_time_minutes};;
    value_format_name: decimal_1
  }

  measure: avg_waiting_for_trip_readiness_time_minutes {
    group_label: "* Operations / Logistics *"
    label: "AVG Waiting For Trip Readiness Time (Minutes)"
    description: "Average time an order waited for other orders in the stack to be ready. Outliers excluded (<0min or >120min)"
    type: average
    sql: ${waiting_for_trip_readiness_time_minutes};;
    value_format_name: decimal_1
  }

  measure: avg_rider_preparing_for_trip_time_minutes {
    group_label: "* Operations / Logistics *"
    label: "AVG Rider Preparing For Trip Time (Minutes)"
    description: "Average time between Claimed and On Route state changes. Signifies the time a rider needed to scan containers and start the trip. Outliers excluded (<0min or >60min)"
    type: average
    sql: ${rider_preparing_for_trip_time_minutes};;
    value_format_name: decimal_1
  }

  measure: avg_waiting_for_picker_time {
    alias: [avg_reaction_time, avg_picker_queuing_time]
    group_label: "* Operations / Logistics *"
    label: "AVG Waiting For Picker Time (Minutes)"
    description:
      "Average picker acceptance-related queuing - from order offered to hub to order started being picked.
      Outliers excluded (>120min). If offered to hub time is not available (no dispatching event), takes the time from order created to picking started"
    type: average
    sql:${waiting_for_picker_time};;
    value_format_name: decimal_1
  }


  measure: sum_pick_pack_handling_time_minutes {
    alias: [sum_picking_time_minutes]
    group_label: "* Operations / Logistics *"
    label: "SUM Pick-Pack Handling Time (Minutes)"
    description: "SUM of time it took for the picker to pick the order and pack it. In minutes. Outliers excluded (<0min or >30min).
    It corresponds to the duration between the times at which the picker clicked on 'Start Picking' and 'Finish Picking'."
    type: sum
    sql:${pick_pack_handling_time_minutes};;
    value_format_name: decimal_2
  }

  measure: sum_picking_time_minutes_actual {
    group_label: "* Operations / Logistics *"
    label: "SUM Picking Time (Minutes)"
    description: "SUM Duration between the times at which the picker clicked on 'Start Picking'
    and 'Scan Container' (if not available, the last item scan timestamp is used). In minutes."
    type: sum
    sql:${picking_time_minutes_actual};;
    value_format_name: decimal_2
  }

  measure: sum_packing_time_minutes {
    group_label: "* Operations / Logistics *"
    label: "SUM Packing Time (Minutes)"
    description: " SUM Duration between the times at which the picker clicked on 'Scan Container'
    and 'Finish Picking' (if 'Scan Container' is not available, the last item scan timestamp is used). In minutes."
    type: sum
    sql:${packing_time_minutes};;
    value_format_name: decimal_2
  }

  measure: avg_start_picking_to_first_scan_time_seconds {
    group_label: "* Operations / Logistics *"
    label: "AVG Start Picking to First Item Scan Time (Seconds)"
    description: "AVG Duration between the timestamp at which the picker clicked on 'Start Picking' and the first item scanned.
    In seconds."
    type: average
    sql: ${start_picking_to_first_scan_time_seconds} ;;
    value_format_name: decimal_1
  }

  measure: avg_first_item_scan_to_last_item_scan_time_seconds {
    group_label: "* Operations / Logistics *"
    label: "AVG First Item Scan to Last Item Scan (Seconds)"
    description: "AVG Duration between the first and last items scanned. In seconds."
    type: average
    sql: ${first_item_scan_to_last_item_scan_time_seconds} ;;
    value_format_name: decimal_1
  }

  measure: avg_last_item_to_click_scan_container_time_seconds {
    group_label: "* Operations / Logistics *"
    label: "AVG Last Item Scan to Click Scan Container Time (Seconds)"
    description: "AVG Duration between the last item scanned and the timestamp at which the
    picker clicked on 'Scan Container'. In seconds."
    type: average
    sql: ${last_item_to_click_scan_container_time_seconds} ;;
    value_format_name: decimal_1
  }

  measure: avg_click_scan_container_to_validate_container_scan_time_seconds {
    group_label: "* Operations / Logistics *"
    label: "AVG Click Scan Container to Validate Containers Scan Time (Seconds)"
    description: "AVG Duration between the times at which the picker clicked on 'Scan Container'
    and on 'Next Step' to validate the containers scanned. In seconds."
    type: average
    sql: ${click_scan_container_to_validate_container_scan_time_seconds} ;;
    value_format_name: decimal_1
  }

  measure: avg_click_scan_container_to_skip_container_time_seconds {
    group_label: "* Operations / Logistics *"
    label: "AVG Click Scan Container to Skip Container Scan Time (Seconds)"
    description: "AVG Duration between the times at which the picker clicked on 'Scan Container'
    and 'Skip Scanning' to skip the containers' scanning. In seconds."
    type: average
    sql: ${click_scan_container_to_skip_container_time_seconds} ;;
    value_format_name: decimal_1
  }

  measure: avg_validate_container_scan_to_validate_shelf_scan_time_seconds {
    group_label: "* Operations / Logistics *"
    label: "AVG Validate Containers Scan to Validate Shelves Scan Time (Seconds)"
    description: "AVG Duration between the times at which the picker clicked on 'Next Step' (after scanning the containers)
    and 'Finish Picking' to assign the scanned shelves. In seconds."
    type: average
    sql: ${validate_container_scan_to_validate_shelf_scan_time_seconds} ;;
    value_format_name: decimal_1
  }

  measure: avg_skip_container_to_skip_shelf_time_seconds {
    group_label: "* Operations / Logistics *"
    label: "AVG Skip Containers Scan to Skip Shelves Scan Time (Seconds)"
    description: "AVG Duration between the times at which the picker clicked on 'Skip Scanning' (on the Scan Container screen)
    and 'Skip Scanning' (on the Assign Shelves screen) to skip the shelves' scanning. In seconds."
    type: average
    sql: ${skip_container_to_skip_shelf_time_seconds} ;;
    value_format_name: decimal_1
  }

  measure: avg_picking_time_seconds {
    group_label: "* Operations / Logistics *"
    label: "AVG Picking Time (Seconds)"
    description: "AVG Duration between the times at which the picker clicked on 'Start Picking'
    and 'Scan Container' (if not available, the last item scan timestamp is used). In seconds."
    type: average
    sql: ${picking_time_seconds_actual} ;;
    value_format_name: decimal_1
  }

  measure: avg_picking_time_minutes {
    group_label: "* Operations / Logistics *"
    label: "AVG Picking Time (Minutes)"
    description: "AVG Duration between the times at which the picker clicked on 'Start Picking'
    and 'Scan Container' (if not available, the last item scan timestamp is used). In minutes."
    type: average
    sql: ${picking_time_minutes_actual} ;;
    value_format_name: decimal_1
  }

  measure: avg_packing_time_seconds {
    group_label: "* Operations / Logistics *"
    label: "AVG Packing Time (Seconds)"
    description: "AVG Duration between the times at which the picker clicked on 'Scan Container'
    and 'Finish Picking' (if 'Scan Container' is not available, the last item scan timestamp is used). In seconds."
    type: average
    sql: ${packing_time_seconds} ;;
    value_format_name: decimal_1
  }

  measure: avg_packing_time_minutes {
    group_label: "* Operations / Logistics *"
    label: "AVG Packing Time (Minutes)"
    description: "AVG Duration between the times at which the picker clicked on 'Scan Container'
    and 'Finish Picking' (if 'Scan Container' is not available, the last item scan timestamp is used). In minutes."
    type: average
    sql: ${packing_time_minutes} ;;
    value_format_name: decimal_1
  }

  measure: avg_pick_pack_handling_time_seconds  {
    group_label: "* Operations / Logistics *"
    label: "AVG Pick-Pack Handling Time (Seconds)"
    description: "AVG time it took for the picker to pick the order and pack it. In seconds. Outliers excluded (<0min or >30min).
    It corresponds to the duration between the times at which the picker clicked on 'Start Picking' and 'Finish Picking'."
    type: average
    sql:${pick_pack_handling_time_seconds};;
    value_format_name: decimal_1
  }

  measure: avg_pick_pack_handling_time_minutes  {
    alias: [avg_picking_time]
    group_label: "* Operations / Logistics *"
    label: "AVG Pick-Pack Handling Time (Minutes)"
    description: "AVG time it took for the picker to pick the order and pack it. In minutes. Outliers excluded (<0min or >30min).
    It corresponds to the duration between the times at which the picker clicked on 'Start Picking' and 'Finish Picking'."
    type: average
    sql:${pick_pack_handling_time_minutes};;
    value_format_name: decimal_1
  }

  measure: avg_picking_time_per_item {
    group_label: "* Operations / Logistics *"
    label: "AVG Pick-Pack Handling Time Per Item (Seconds)"
    description: "Computed as Pick-Pack Handling Time / # Items Picked. Outliers excluded (<0min or >30min)"
    type: number
    sql:nullif(${sum_pick_pack_handling_time_minutes}*60,0)/nullif(${sum_quantity_fulfilled},0);;
    value_format_name: decimal_1
  }

  measure: avg_waiting_for_rider_decision_time {
    alias: [avg_acceptance_time, avg_rider_queuing_time, avg_waiting_for_rider_time]
    group_label: "* Operations / Logistics *"
    label: "AVG Waiting for Rider Decision Time"
    description: "Average time an order spent waiting for rider acceptance. Outliers excluded (<0min or >120min)"
    type: average
    sql:${waiting_for_rider_decision_time_minutes};;
    value_format_name: decimal_1
  }

  measure: avg_riding_to_customer_time {
    group_label: "* Operations / Logistics *"
    label: "AVG Riding To Customer Time"
    description: "Average riding to customer time considering delivery start to arrival at customer (or order delivered for DaaS orders). Outliers excluded (<1min or >30min)"
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
    description: "Average of Cart Discount Value Gross (Discount Code applied at a checkout). Includes delivery discounts."
    hidden:  no
    type: average
    sql: ${amt_discount_cart_gross};;
    filters: [amt_discount_cart_gross: ">0"]
    value_format_name: euro_accounting_2_precision
  }

  measure: avg_discount_cart_net {
    group_label: "* Monetary Values *"
    label: "AVG Cart Discount Value (Net)"
    description: "Average of Cart Discount Value Net (Discount Code applied at a checkout). Includes delivery discounts."
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
    sql: ${estimated_waiting_for_picker_time_minutes};;
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

  measure: avg_item_value_after_product_discount_gross {
    group_label: "* Monetary Values *"
    label: "AVG Item Value After Product Discount (Gross)"
    description: "AIV represents the Average value of items (incl. VAT). Excludes fees (gross), before deducting cart discount. After deducting product (commercial) discounts"
    hidden:  no
    type: average
    sql: ${item_value_after_product_discount_gross};;
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

  measure: avg_item_value_after_product_discount_net {
    group_label: "* Monetary Values *"
    label: "AVG Item Value After Product Discount (Net)"
    description: "AIV represents the Average value of items (excl. VAT). Excludes fees (net), before deducting cart discount. After deducting product (commercial) discounts"
    hidden:  no
    type: average
    sql: ${item_value_after_product_discount_net};;
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
    label: "AVG # Items"
    description: "Average number of items per order"
    hidden:  no
    type: number
    sql: ${sum_quantity_fulfilled}/nullif(${cnt_orders},0);;
    value_format_name: decimal_1
  }

  measure: avg_number_sku {
    group_label: "* Basic Counts (Orders / Customers etc.) *"
    label: "AVG # Distinct SKUs"
    description: "Average number of SKUs per order"
    hidden:  no
    type: number
    sql: ${sum_distinct_skus}/nullif(${cnt_orders},0);;
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

  measure: picking_time_estimate_mae {
    group_label: "* Operations / Logistics *"
    label: "Mean Absolute Error Pick-Pack Handling Time Estimate"
    description: "The mean absolute error between actual pick-pack handling time and estimated picking time"
    hidden:  no
    type: average
    sql: abs(${pick_pack_handling_time_minutes} - ${estimated_picking_time_minutes});;
    value_format_name: decimal_1
  }

  measure: riding_time_estimate_mae {
    group_label: "* Operations / Logistics *"
    label: "Mean Absolute Error Riding Time Estimate"
    description: "The mean absolute error between actual riding to customer time and estimated riding to customer time"
    hidden:  no
    type: average
    sql:  abs(${riding_hub_to_customer_time_minutes} - ${estimated_riding_time_minutes});;
    value_format_name: decimal_1
  }

  measure: picker_queuing_time_estimate_mae {
    group_label: "* Operations / Logistics *"
    label: "Mean Absolute Error Total Picking-related Queuing Time Estimate"
    description: "The mean absolute error between actual waiting for picker + withheld from picking time and estimated total picking-related queuing time"
    hidden:  no
    type: average
    sql: abs(${waiting_for_picker_time}+coalesce(${withheld_from_picking_time_minutes}, 0) - ${estimated_waiting_for_picker_time_minutes});;
    value_format_name: decimal_1
  }

  measure: rider_queuing_time_estimate_mae {
    group_label: "* Operations / Logistics *"
    label: "Mean Absolute Error Rider Queuing Time Estimate"
    description: "The mean absolute error between actual rider queuing time and estimated rider queuing time"
    hidden:  no
    type: average
    sql: abs(${waiting_for_rider_decision_time_minutes}+coalesce(${waiting_for_available_rider_time_minutes}, 0)+coalesce(${waiting_for_trip_readiness_time_minutes},0) - ${estimated_queuing_time_for_rider_minutes});;
    value_format_name: decimal_1
  }

  measure: avg_order_weight_kg {
    group_label: "* Order Characteristics *"
    label: "AVG Order Weight (kg)"
    description: "Average order weight based on quantity of line items * weight of individual products"
    type: average
    sql: ${weight_kg};;
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
    value_format_name: euro_accounting_0_precision
    sql: ${gmv_gross};;
  }

  measure: sum_gmv_net {
    group_label: "* Monetary Values *"
    label: "SUM GMV (Net)"
    description: "Sum of Gross Merchandise Value of orders incl. fees and before deduction of discounts (excl. VAT)"
    hidden:  no
    type: sum
    value_format_name: euro_accounting_0_precision
    sql: ${gmv_net};;
  }

  measure: sum_gmv_gross_dynamic {
    group_label: "* Monetary Values *"
    label: "SUM GMV (Gross) (Dynamic)"
    description: "Sum of Gross Merchandise Value of orders incl. fees and before deduction of discounts (incl. VAT). To be used together with the Is After CRF Fees Deduction parameter."
    hidden:  no
    label_from_parameter: is_after_crf_fees_deduction
    type: sum
    value_format_name: euro_accounting_0_precision
    sql:
    {% if is_after_crf_fees_deduction._parameter_value == 'true' %}
    ${amt_gmv_excluding_crf_fees_gross}
    {% elsif is_after_crf_fees_deduction._parameter_value == 'false' %}
    ${gmv_gross}
    {% endif %};;
  }

  measure: sum_gmv_net_dynamic {
    group_label: "* Monetary Values *"
    label: "SUM GMV (Net) (Dynamic)"
    description: "Sum of Gross Merchandise Value of orders incl. fees and before deduction of discounts (excl. VAT). To be used together with the Is After CRF Fees Deduction parameter."
    hidden:  no
    label_from_parameter: is_after_crf_fees_deduction
    type: sum
    value_format_name: euro_accounting_0_precision
    sql:
    {% if is_after_crf_fees_deduction._parameter_value == 'true' %}
    ${amt_gmv_excluding_crf_fees_net}
    {% elsif is_after_crf_fees_deduction._parameter_value == 'false' %}
    ${gmv_net}
    {% endif %};;
  }

  measure: sum_revenue_gross {
    group_label: "* Monetary Values *"
    label: "SUM Revenue (gross)"
    description: "Sum of Revenue (GMV after subsidies) incl. VAT. After deduction of discounts, tips and deposit."
    hidden:  yes
    type: sum
    sql: ${total_gross_amount};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_revenue_net {
    group_label: "* Monetary Values *"
    label: "SUM Revenue (Net)"
    description: "Sum of Revenue (GMV after subsidies) excl. VAT"
    hidden:  yes
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
    description: "Sum of Cart Discounts Gross (Discount Code applied at a checkout). Includes delivery discounts."
    hidden:  no
    type: sum
    sql: ${amt_discount_cart_gross};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_discount_cart_net {
    group_label: "* Monetary Values *"
    label: "SUM Cart Discount Amount (Net)"
    description: "Sum of Cart Discounts Net (Discount Code applied at a checkout). Includes delivery discounts."
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
    description: "Sum of Refunds (Gross). Includes Items, Deposit, Total Fees (Delivery, Storage & Late Night) and Tips Refunds."
    hidden:  no
    type: sum
    sql: ${amt_refund_gross};;
    value_format_name: euro_accounting_2_precision
  }

  measure: avg_refund_gross {
    group_label: "* Monetary Values *"
    label: "AVG Refund (Gross)"
    description: "Average Refund value (Gross). Includes Items, Deposit, Total Fees (Delivery, Storage & Late Night) and Tips Refunds."
    hidden:  no
    type: average
    sql: ${amt_refund_gross};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_total_sales_gross {
    group_label: "* Monetary Values *"
    label: "SUM Total Sales (Gross)"
    description: "Sum of Total Fees (Delivery, Storage & Late Night) and Items Price and Deposit. Excl. Tips, Donations. Before Deduction of any Discount. Incl. VAT"
    hidden:  no
    type: sum
    sql: ${amt_total_sales_gross};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_total_sales_excluding_deposit_gross {
    group_label: "* Monetary Values *"
    label: "SUM Total Sales excl. Deposit (Gross)"
    description: "Sum of Total Fees (Delivery, Storage & Late Night) and Items Price. Excl. Deposit, Tips, Donations. Before Deduction of any Discount. Incl. VAT"
    hidden:  no
    type: sum
    sql: ${amt_total_sales_excluding_deposit_gross};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_total_sales_after_discounts_gross {
    group_label: "* Monetary Values *"
    label: "SUM Total Sales After Discount (Gross)"
    description: "Sum of Total Fees (Delivery, Storage & Late Night) and Items Price and Deposit. Excl. Tips, Donations. After Deduction of Cart and Product Discounts. Incl. VAT"
    hidden:  no
    type: sum
    sql: ${amt_total_sales_after_discount_gross};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_total_sales_after_discount_and_refund_gross {
    group_label: "* Monetary Values *"
    label: "SUM Total Sales After Discounts & Refunds (Gross)"
    description: "Sum of Total Fees (Delivery, Storage & Late Night) and Items Price and Deposit. Excl. Tips, Donations. After Deduction of Cart and Product Discounts. After Refunds. Incl. VAT"
    hidden:  no
    type: sum
    sql: ${amt_total_sales_after_discount_and_refund_gross};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_total_sales_after_discount_and_refund_excluding_deposit_gross {
    group_label: "* Monetary Values *"
    label: "SUM Total Sales After Discounts & Refunds excl. Deposit (Gross)"
    description: "Sum of Total Fees (Delivery, Storage & Late Night) and Items Price. Excl. Tips, Deposit, Donations. After Deduction of Cart and Product Discounts. After Refunds. Incl. VAT"
    hidden:  no
    type: sum
    sql: ${amt_total_sales_after_discount_and_refund_excluding_deposit_gross};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_gpv_gross {
    group_label: "* Monetary Values *"
    label: "SUM GPV (Gross)"
    description: "Actual amount paid by the customer in CT. Sum of Total Fees (Delivery, Storage & Late Night), Items Price, Tips, Deposit. Excl. Donations. After Deduction of Cart and Product Discounts. Incl. VAT"
    hidden:  no
    type: sum
    sql: ${amt_gpv_gross};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_npv_gross {
    group_label: "* Monetary Values *"
    label: "SUM NPV (Gross)"
    description: "Net Payment Value. Actual amount paid by the customer in CT after Refunds. Sum of Total Fees (Delivery, Storage & Late Night), Items Price, Tips, Deposit. Excl. Donations. After Deduction of Cart and Product Discounts. Incl. VAT"
    hidden:  no
    type: sum
    sql: ${amt_npv_gross};;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_quantity_fulfilled {
    label: "Quantity Sold"
    group_label: "* Basic Counts (Orders / Customers etc.) *"
    description: "Fulfilled Quantity"
    type: sum
    sql: ${number_of_items} ;;
  }

  measure: sum_distinct_skus {
    label: "# Distinct SKUs Sold"
    group_label: "* Basic Counts (Orders / Customers etc.) *"
    description: "Number of distinct SKUs"
    type: sum
    sql: ${no_distinct_skus} ;;
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


  measure: sum_avg_waiting_time {
    alias: [sum_avg_acceptance_reaction_time, sum_avg_queuing_time]
    group_label: "* Operations / Logistics *"
    label: "AVG Waiting For Picker Time + Waiting for Rider Decision Time"
    description: "Sum of the average of waiting for rider decision and the average of waiting for picker time"
    hidden:  no
    type: number
    sql: ${avg_waiting_for_rider_decision_time} + ${avg_waiting_for_picker_time};;
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
    label: "SUM Rider Handling Times"
    hidden:  no
    type: sum
    sql: ${rider_handling_time_minutes};;
    value_format_name: decimal_1
  }

  measure: sum_rider_handling_time_minutes_last_mile {
    group_label: "* Operations / Logistics *"
    label: "SUM Rider Handling Times (Last Mile)"
    hidden:  yes
    type: sum
    sql: ${rider_handling_time_minutes};;
    value_format_name: decimal_1
    filters: [is_last_mile_order: "yes"]
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

  measure: cnt_internal_orders {
    group_label: "* Basic Counts (Orders / Customers etc.) *"
    label: "# Internal Orders"
    description: "Count of Internal Orders. All orders placed via Flink App."
    hidden:  no
    type: count_distinct
    sql: ${order_uuid} ;;
    filters: [is_external_order: "no"]
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

  measure: cnt_external_orders {
    group_label: "* Basic Counts (Orders / Customers etc.) *"
    label: "# External Orders"
    description: "Count of External orders (orders placed via marketplace integrations like Wolt, UberEats, etc.)"
    type: count_distinct
    sql: ${order_uuid} ;;
    value_format: "0"
    filters: [is_external_order: "yes"]
  }

  measure: cnt_daas_orders {
    group_label: "* Basic Counts (Orders / Customers etc.) *"
    label: "# DaaS Orders"
    description: "Count of Delivery as a Service orders (orders placed via Flink but delivered by an external provider (e.g. Uber Direct)"
    type: count_distinct
    sql: ${order_uuid} ;;
    value_format: "0"
    filters: [is_daas_order: "yes"]
  }

  measure: cnt_click_and_collect_orders {
    group_label: "* Basic Counts (Orders / Customers etc.) *"
    label: "# Click & Collect Orders"
    description: "Count of Click & Collect Orders"
    hidden:  yes
    type: count_distinct
    sql: ${order_uuid} ;;
    value_format: "0"
    filters: [
      is_click_and_collect_order: "yes",
      is_successful_order: "yes"
    ]
  }

  measure: cnt_ubereats_orders {
    group_label: "* Basic Counts (Orders / Customers etc.) *"
    label: "# Ubereats Orders"
    description: "Count of Ubereats Orders"
    hidden:  yes
    type: count_distinct
    sql: ${order_uuid} ;;
    value_format: "0"
    filters: [
      external_provider: "uber-eats, uber-eats-carrefour",
      is_successful_order: "yes"
      ]
  }

  measure: number_of_unique_flink_delivered_orders {
    alias: [cnt_rider_orders]
    group_label: "* Basic Counts (Orders / Customers etc.) *"
    label: "# Flink Delivered Orders"
    description: "Count of Orders delivered by Flink Riders (Excluding External and Click & Collect Orders)."
    hidden:  yes
    type: count_distinct
    sql: ${order_uuid} ;;
    value_format: "0"
    filters: [
      is_last_mile_order: "yes"
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
    label: "# Orders without Cart Discount"
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
    group_label: "* Basic Counts (Orders / Customers etc.) *"
    label: "# Orders with Delivery PDT available"
    description: "Count of Orders where a PDT is available"
    hidden:  no
    type: count
    filters: [is_delivery_eta_available: "yes", is_click_and_collect_order: "no"]
    value_format: "0"
  }

  measure: cnt_orders_with_targeted_eta_available {
    # group_label: "* Operations / Logistics *"
    group_label: "* Basic Counts (Orders / Customers etc.) *"
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
    filters: [delta_to_pdt_minutes:"<=0.5"]
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
    description: "Number of all Cancelled Orders. Includes Orders cancelled by customers via self cancellation AND orders cancelled by CC agents via CT or Intercom."
    filters: [amt_cancelled_gross: ">0"]
    value_format: "0"
  }

  measure: cnt_agent_cancelled_orders {
    group_label: "* Cancelled Orders *"
    label: "# Agent Cancelled Orders"
    description: "Number of Agent Cancelled orders, also includes CT cancelled orders."
    hidden:  no
    type: count
    filters: [amt_cancelled_gross: ">0",cancellation_category: "- Customer"]
    value_format: "0"
  }

  measure: cnt_self_cancelled_orders {
    group_label: "* Cancelled Orders *"
    label: "# Self Cancelled Orders"
    description: "Number of Orders Cancelled by customers directly in the app via the cancel order feature."
    hidden:  no
    type: count
    filters: [amt_cancelled_gross: ">0",cancellation_category: "Customer"]
    value_format: "0"
  }

  measure: cnt_ct_cancelled_orders {
    group_label: "* Cancelled Orders *"
    label: "# CT Cancelled Orders"
    hidden:  no
    type: count
    filters: [amt_cancelled_gross: ">0",cancellation_reason: "NULL"]
    value_format: "0"
  }

############### STORAGE FEES ################

  measure: sum_amt_storage_fee_gross {
    group_label: "* Monetary Values *"
    label: "SUM Storage Fees (Gross)"
    description: "Sum of Storage Fees Gross, applied when an item requiring such a fee is added to the basket."

    value_format_name: euro_accounting_2_precision
    type:  sum
    sql: ${amt_storage_fee_gross} ;;
  }
  measure: sum_amt_storage_fee_net {
    group_label: "* Monetary Values *"
    label: "SUM Storage Fees (Net)"
    description: "Sum of Storage Fees Net, applied when an item requiring such a fee is added to the basket."

    value_format_name: euro_accounting_2_precision
    type:  sum
    sql: ${amt_storage_fee_net} ;;
  }

  measure: avg_storage_fee_gross {
    group_label: "* Monetary Values *"
    label: "AVG Storage Fee (Gross)"
    description: "Average value of Storage Fees (Gross)"

    type: average
    sql: ${amt_storage_fee_gross};;
    value_format_name: euro_accounting_2_precision
  }

  measure: avg_storage_fee_net {
    group_label: "* Monetary Values *"
    label: "AVG Storage Fee (Net)"
    description: "Average value of Storage Fees (Net)"

    type: average
    sql: ${amt_storage_fee_net};;
    value_format_name: euro_accounting_2_precision
  }

############### LATE NIGHT FEES ################

  measure: sum_amt_late_night_fee_gross {
    group_label: "* Monetary Values *"
    label: "SUM Late Night Fees (Gross)"
    description: "Gross amount of late night fees applied to orders placed after a given hour. Incl. VAT"
    value_format_name: euro_accounting_2_precision
    type:  sum
    sql: ${amt_late_night_fee_gross} ;;
  }

  measure: sum_amt_late_night_fee_net {
    group_label: "* Monetary Values *"
    label: "SUM Late Night Fees (Net)"
    description: "Net amount of late night fees applied to orders placed after a given hour. Incl. VAT"
    value_format_name: euro_accounting_2_precision
    type:  sum
    sql: ${amt_late_night_fee_net} ;;
  }

  measure: avg_late_night_fee_gross {
    group_label: "* Monetary Values *"
    label: "AVG Late Night Fee (Gross)"
    description: "Average value of Late Night Fees (Gross, incl. VAT) per order. Considering all orders."
    type: average
    sql: ${amt_late_night_fee_gross};;
    value_format_name: euro_accounting_2_precision
  }

  measure: avg_late_night_fee_net {
    group_label: "* Monetary Values *"
    label: "AVG Late Night Fee (Net)"
    description: "Average value of Late Night Fees (Net, excl. VAT) per order. Considering all orders."
    type: average
    sql: ${amt_late_night_fee_net};;
    value_format_name: euro_accounting_2_precision
  }

  measure: number_of_orders_with_late_night_fee {
    group_label:  "* Basic Counts (Orders / Customers etc.) *"
    label: "# Orders with Late Night Fee"
    description: "Number of orders for which late night fee applied."
    type: count_distinct
    sql: ${order_uuid};;
    filters: [amt_late_night_fee_gross: ">0"]
  }

  ##### TOTAL FEES #####

  measure: sum_total_fees_gross {
    alias: [sum_total_fees]
    group_label: "* Monetary Values *"
    label: "SUM Total Fees (Gross)"
    description: "Sum of Delivery Fees (Gross), Storage Fees (Gross) and Late Night Fees (Gross)"
    type: number
    sql: ${sum_delivery_fee_gross} + ${sum_amt_storage_fee_gross} + ${sum_amt_late_night_fee_gross};;
    value_format_name: euro_accounting_2_precision
  }

  measure: avg_total_fees_gross {
    group_label: "* Monetary Values *"
    label: "AVG Total Fees (Gross)"
    description: "Average value of Delivery Fees (Gross) + Storage Fees (Gross) + and Late Night Fees (Gross)"
    type: average
    sql: (${shipping_price_gross_amount} + ${amt_storage_fee_gross} + ${amt_late_night_fee_gross}) ;;
    value_format_name: euro_accounting_2_precision
  }

  measure: sum_total_fees_net {
    group_label: "* Monetary Values *"
    label: "SUM Total Fees (Net)"
    description: "Sum of Delivery Fees (Net), Storage Fees (Net) and Late Night Fees (Net)"
    type: number
    sql: ${sum_delivery_fee_net} + ${sum_amt_storage_fee_net} + ${sum_amt_late_night_fee_net};;
    value_format_name: euro_accounting_2_precision
  }

  measure: avg_total_fees_net {
    group_label: "* Monetary Values *"
    label: "AVG Total Fees (Net)"
    description: "Average value of Delivery Fees (Net) + Storage Fees (Net) + Late Night Fees (Net)"
    type: average
    sql: ${shipping_price_net_amount} + ${amt_storage_fee_net} + coalesce(${amt_late_night_fee_net},0);;
    value_format_name: euro_accounting_2_precision
  }

########### CRF FEES MEASURES ##########

  measure: sum_amt_gmv_excluding_crf_fees_gross {
    group_label: "* Monetary Values *"
    label: "SUM GMV excluding CRF fees gross"
    description: "Sum of GMV gross - CRF fees gross "
    type: sum
    value_format_name: euro_accounting_2_precision
    sql: ${amt_gmv_excluding_crf_fees_gross} ;;
  }
  measure: sum_amt_gmv_excluding_crf_fees_net {
    group_label: "* Monetary Values *"
    label: "SUM GMV excluding CRF fees net"
    description: "Sum of GMV net - CRF fees net "
    type: sum
    value_format_name: euro_accounting_2_precision
    sql: ${amt_gmv_excluding_crf_fees_net} ;;
  }
  measure: sum_amt_crf_total_fee_gross {
    group_label: "* Monetary Values *"
    label: "SUM CRF Total fees gross"
    description: "Sum (gross): IT cost fee + Markdown fee + Fulfillment fee"
    type: sum
    value_format_name: euro_accounting_2_precision
    sql: ${amt_crf_total_fee_gross} ;;
  }
  measure: sum_amt_crf_total_fee_net {
    group_label: "* Monetary Values *"
    label: "SUM CRF Total fees net"
    description: "Sum (net): IT cost fee + Markdown fee + Fulfillment fee. 20% tax rate applied."
    type: sum
    value_format_name: euro_accounting_2_precision
    sql: ${amt_crf_total_fee_net} ;;
  }
  measure: sum_amt_crf_markdown_fee_gross {
    group_label: "* Monetary Values *"
    label: "SUM CRF Markdown fee gross"
    description: "Sum of CRF Markdown fee gross. Markdown fee calculated as 3% of the total net product prices sum"
    type: sum
    value_format_name: euro_accounting_2_precision
    sql: ${amt_crf_markdown_fee_gross} ;;
  }
  measure: sum_amt_crf_markdown_fee_net {
    group_label: "* Monetary Values *"
    label: "SUM CRF Markdown fee net"
    description: "Sum of CRF Markdown fee net. Markdown fee calculated as 3% of the total net product prices sum. 20% tax rate applied."
    type: sum
    value_format_name: euro_accounting_2_precision
    sql: ${amt_crf_markdown_fee_net} ;;
  }
  measure: sum_amt_crf_it_cost_fee_gross {
    group_label: "* Monetary Values *"
    label: "SUM CRF IT cost fee gross"
    description: "Sum of CRF IT cost fee gross. IT cost fee is 0.15 per order."
    type: sum
    value_format_name: euro_accounting_2_precision
    sql: ${amt_crf_it_cost_fee_gross} ;;
  }
  measure: sum_amt_crf_it_cost_fee_net {
    group_label: "* Monetary Values *"
    label: "SUM CRF IT cost fee net"
    description: "Sum of CRF IT cost fee net. IT cost fee is 0.15 per order. 20% tax rate applied."
    type: sum
    value_format_name: euro_accounting_2_precision
    sql: ${amt_crf_it_cost_fee_net} ;;
  }
  measure: sum_amt_crf_fulfillment_fee_gross {
    group_label: "* Monetary Values *"
    label: "SUM CRF Fulfillment fee gross"
    description: "Sum of CRF Fulfillmet fee gross. This fee might vary throughout the last settlement period. The final value is known on the 20th of each month for the previous 30-day period."
    type: sum
    value_format_name: euro_accounting_2_precision
    sql: ${amt_crf_fulfillment_fee_gross} ;;
  }
  measure: sum_amt_crf_fulfillment_fee_net {
    group_label: "* Monetary Values *"
    label: "SUM CRF Fulfillment fee net"
    description: "Sum of CRF Fulfillmet fee net. This fee might vary throughout the last settlement period. The final value is known on the 20th of each month for the previous 30-day period. 20% tax rate applied."
    type: sum
    value_format_name: euro_accounting_2_precision
    sql: ${amt_crf_fulfillment_fee_net} ;;
  }

########### MARKETPLACE INTEGRATIONS ##########

  measure: sum_amt_uber_eats_commission_fee_net {
    group_label: "* Monetary Values *"
    label: "SUM UberEats Commission Fee Net"
    description: "Net amount of commission fee paid by Flink on UberEats orders: 23% of gross item value in the Netherlands, and 20% in France."
    value_format_name: euro_accounting_2_precision
    type:  sum
    sql: ${amt_uber_eats_commission_fee_net} ;;
  }

  measure: sum_amt_uber_eats_commission_fee_gross {
    group_label: "* Monetary Values *"
    label: "SUM UberEats Commission Fee Gross"
    description: "Gross amount of commission fee paid by Flink on UberEats orders."
    value_format_name: euro_accounting_2_precision
    type:  sum
    sql: ${amt_uber_eats_commission_fee_gross} ;;
  }

  measure: sum_amt_wolt_commission_fee_net {
    group_label: "* Monetary Values *"
    label: "SUM Wolt Commission Fee Net"
    description: "Net amount of commission fee paid by Flink on Wolt orders: 24% of gross item value in Germany."
    value_format_name: euro_accounting_2_precision
    type:  sum
    sql: ${amt_wolt_commission_fee_net} ;;
  }

  measure: sum_amt_wolt_commission_fee_gross {
    group_label: "* Monetary Values *"
    label: "SUM Wolt Commission Fee Gross"
    description: "Gross amount of commission fee paid by Flink on Wolt orders."
    value_format_name: euro_accounting_2_precision
    type:  sum
    sql: ${amt_wolt_commission_fee_gross} ;;
  }

  measure: avg_amt_marketplace_commission_fee_gross {
    group_label: "* Monetary Values *"
    label: "AVG Marketplace Commission Fee Gross"
    description: "Average gross amount of commission fee paid by Flink on UberEats/Wolt orders."
    value_format_name: euro_accounting_2_precision
    type:  average
    sql: ${amt_uber_eats_commission_fee_gross} + ${amt_wolt_commission_fee_gross} ;;
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
    filters: [delta_to_pdt_minutes:">=5"]
    value_format: "0"
  }

  measure: cnt_orders_delayed_over_10_min {
    group_label: "* Operations / Logistics *"
    label: "# Orders delivered late >10min"
    description: "Count of Orders delivered >10min later than PDT"
    hidden:  yes
    type: count
    filters: [delta_to_pdt_minutes:">=10"]
    value_format: "0"
  }

  measure: cnt_orders_delayed_over_15_min {
    group_label: "* Operations / Logistics *"
    label: "# Orders delivered late >15min"
    description: "Count of Orders delivered >15min later than PDT"
    hidden:  yes
    type: count
    filters: [delta_to_pdt_minutes:">=15"]
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

  measure: cnt_orders_fulfilled_over_45_min {
    group_label: "* Operations / Logistics *"
    label: "# Orders fulfilled >45min"
    description: "Count of Orders delivered >45min fulfillment time"
    hidden:  yes
    type: count
    filters: [fulfillment_time:">=45"]
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

  measure: cnt_orders_pdt_critical_underestimation {
    group_label: "* Operations / Logistics *"
    label:       "# Orders with critical under-estimation PDT"
    description: "# Orders with critical under-estimation PDT"
    hidden:      yes
    type:        count
    filters:     [is_critical_pdt_underestimation: "Yes"]
    value_format: "0"
  }

  measure: cnt_orders_pdt_critical_overestimation {
    group_label: "* Operations / Logistics *"
    label:       "# Orders with critical over-estimation PDT"
    description: "# Orders with critical over-estimation PDT"
    hidden:      yes
    type:        count
    filters:     [is_critical_pdt_overestimation: "Yes"]
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
    label: "# Employees Delivering Orders"
    type: number
    group_label: "* Operations / Logistics *"
    sql:count (distinct ${rider_id});;
    value_format_name: decimal_0
    description: "Number of distinct employees delivered at least one order based on Workforce app (not based on punched hours) include none riders if they deliver orders"
  }


  ################
  ## PERCENTAGE ##
  ################

  measure: share_of_external_orders {
    group_label: "* Basic Counts (Orders / Customers etc.) *"
    label: "% External Orders"
    description: "Share of External orders over total number of orders"
    hidden:  no
    type: number
    sql: ${cnt_external_orders} / NULLIF(${cnt_orders}, 0);;
    value_format: "0.0%"
  }

  measure: share_of_daas_orders_over_all_internal_orders {
    alias: [share_of_daas_orders_over_all_orders]
    group_label: "* Basic Counts (Orders / Customers etc.) *"
    label: "% DaaS Orders"
    description: "Share of DaaS orders over total number of internal orders"
    type: number
    sql: ${cnt_daas_orders} / NULLIF(${cnt_internal_orders}, 0);;
    value_format: "0.0%"
  }

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
    description: "Share of Orders which had Discount Code applied at a checkout. Includes delivery discounts."
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
    description: "Dividing Number of Cancelled Orders by CC Agents over Number of Orders.
    CT-cancelled orders are included in Agent-Cancelled orders."
    hidden:  no
    type: number
    sql: ${cnt_agent_cancelled_orders} / NULLIF(${cnt_orders}, 0);;
    value_format: "0.0%"
  }

  measure: pct_ct_cancelled_orders {
    group_label: "* Cancelled Orders *"
    label: "% CT Cancelled Orders"
    description: "Dividing Number of CT-Cancelled Orders by CC Agents over Number of Orders"
    hidden:  no
    type: number
    sql: ${cnt_ct_cancelled_orders} / NULLIF(${cnt_orders}, 0);;
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

  measure: pct_fulfillment_over_30_min{
    group_label: "* Operations / Logistics *"
    label: "% Orders fulfilled >30min"
    description: "Share of orders delivered > 30min"
    hidden:  no
    type: number
    sql: ${cnt_orders_fulfilled_over_30_min} / NULLIF(${cnt_orders}, 0);;
    value_format: "0%"
  }

  measure: pct_fulfillment_over_45_min{
    group_label: "* Operations / Logistics *"
    label: "% Orders fulfilled >45min"
    description: "Share of orders delivered > 45min"
    hidden:  no
    type: number
    sql: ${cnt_orders_fulfilled_over_45_min} / NULLIF(${cnt_orders}, 0);;
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
    label: "AVG # Daily Orders per hub"
    description: "AVG number of daily orders.
    Computed as the number of orders, divided by the number of hubs, divided by the number of open days, over the selected timeframe."
    type: number
    sql: (${cnt_orders}/NULLIF(${cnt_unique_hubs},0))/ NULLIF(${cnt_unique_date},0);;
    value_format_name:decimal_2
  }

  measure: avg_daily_orders{
    group_label: "* Basic Counts (Orders / Customers etc.) *"
    label: "AVG # Daily Orders"
    description: "AVG number of daily orders.
    Computed as the number of orders divided by the number of open days, over the selected timeframe."
    type: number
    sql: (${cnt_orders})/ NULLIF(${cnt_unique_date},0);;
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

  measure: pct_pdt_critical_over_estimation {
    group_label: "* Operations / Logistics *"
    label:       "% Orders with critical over-estimation of PDT"
    description: "% Orders with critical over-estimation of PDT"
    type:        number
    sql:         ${cnt_orders_pdt_critical_overestimation} / ${cnt_orders} ;;
    value_format_name:  percent_2
  }

  measure: pct_pdt_critical_under_estimation {
    group_label: "* Operations / Logistics *"
    label:       "% Orders with critical under-estimation of PDT"
    description: "% Orders with critical under-estimation of PDT"
    type:        number
    sql:         ${cnt_orders_pdt_critical_underestimation} / ${cnt_orders} ;;
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


  measure: std_fulfillment_time {
    type: number
    group_label: "* Operations / Logistics *"
    label: "Fulfillment Time Standard Deviation"
    sql: stddev_pop(${fulfillment_time}) ;;
    value_format_name: decimal_1
  }
}
