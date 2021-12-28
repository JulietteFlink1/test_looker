view: orders_cleaned_dev {
  derived_table: {
    sql: WITH
      curated_customers as (
      SELECT
                  lower(customer_email) as customer_email
                , first_order_country as country_iso
                , first_order_phone_number as phone_number
                , account_created_at_timestamp as sign_up_timestamp
                , 'commercetools' as backed_source
       FROM `flink-data-dev.curated.customers`
      ),

      curated_customers_cleaned as
      ( select * from ( with
      customer_map AS (
          SELECT *
              , CONCAT(country_iso, "_", phone_number_cleaned) as customer_id
              , FIRST_VALUE(sign_up_timestamp) OVER (PARTITION BY CONCAT(country_iso, "_", phone_number_cleaned) ORDER BY sign_up_timestamp) as sign_up_timestamp_customer_id
          FROM (
      SELECT
                  customer_email
                , phone_number
                , CASE
                       WHEN phone_number LIKE '%+%' AND LEFT(SUBSTR(REGEXP_REPLACE(phone_number, ' ', '' ),4),1) = '0' THEN SUBSTR(REGEXP_REPLACE(phone_number, ' ', '' ),5)
                       WHEN phone_number LIKE '%+%' THEN SUBSTR(REGEXP_REPLACE(phone_number, ' ', '' ),4)
                       WHEN LEFT(phone_number,2) = '00' THEN SUBSTR(REGEXP_REPLACE(phone_number, ' ', '' ),5)
                       WHEN LEFT(phone_number,1) = '0' AND LEFT(phone_number,2) != '00' THEN SUBSTR(REGEXP_REPLACE(phone_number, ' ', '' ),2)
                       ELSE REGEXP_REPLACE(phone_number, ' ', '' )
                  END as phone_number_cleaned
                , sign_up_timestamp
                , country_iso
                , backed_source
       FROM curated_customers
      --  where phone_number != ''
      --    and phone_number not like '000%'
      )t
      )
      , customer_map_clean AS (
      SELECT
              customer_email
            -- , customer_email_cleaned
            , case when phone_number_cleaned like '00%' then concat(country_iso,"_",customer_email)
                   when phone_number_cleaned = ''       then concat(country_iso,"_",customer_email)
                  else customer_id
              end as customer_id
            , country_iso
            , phone_number
            , phone_number_cleaned
            , sign_up_timestamp
            , sign_up_timestamp_customer_id
            , backed_source
            , DENSE_RANK() OVER(PARTITION BY customer_email ORDER BY sign_up_timestamp_customer_id ASC) as rank
      FROM customer_map
      GROUP BY 1,2,3,4,5,6,7,8
      )

      SELECT customer_email
           , customer_id
           , country_iso
           , sign_up_timestamp_customer_id
      FROM customer_map_clean
      WHERE rank = 1
      GROUP BY 1,2,3,4  )
      ),

      orders_cleaned as (
        SELECT   o.*
              , cc.customer_email as customer_email_mapped
              , cc.customer_id as customer_id_mapped
              , cc.sign_up_timestamp_customer_id
          FROM `flink-data-prod.curated.orders` o
              LEFT JOIN curated_customers_cleaned cc
              ON lower(o.customer_email) = cc.customer_email
          WHERE  is_successful_order is true
            AND o.customer_email NOT IN ('qa@goflink.con','qa@gflink.com','qa@flink.com','qa@goflinkk.com',
                                              'qa@golink.com','qa@gofink.com','qa@gofilnk.com','qaa@goflink.com','qa@gofliink.com',
                                              'qa@goflin.com','qa@goflnik.com','qa@goflink.com','contact@goflink.com','.@gmail.com')
            AND o.customer_email != ''
            --and o.order_date < "2021-10-01" -- temp, to be changed/removed when the schedules are aligned
      )
      select * from orders_cleaned
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: order_uuid {
    type: string
    sql: ${TABLE}.order_uuid ;;
  }

  dimension: order_id {
    type: string
    sql: ${TABLE}.order_id ;;
  }

  dimension: customer_id {
    type: string
    sql: ${TABLE}.customer_id ;;
  }

  dimension: external_id {
    type: string
    sql: ${TABLE}.external_id ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: shipping_city {
    type: string
    sql: ${TABLE}.shipping_city ;;
  }

  dimension: backend_source {
    type: string
    sql: ${TABLE}.backend_source ;;
  }

  dimension: platform {
    type: string
    sql: ${TABLE}.platform ;;
  }

  dimension_group: order_timestamp {
    type: time
    sql: ${TABLE}.order_timestamp ;;
  }

  dimension: timezone {
    type: string
    sql: ${TABLE}.timezone ;;
  }

  dimension: order_date {
    type: date
    datatype: date
    sql: ${TABLE}.order_date ;;
  }

  dimension: order_week {
    type: date
    datatype: date
    sql: ${TABLE}.order_week ;;
  }

  dimension: order_month {
    type: string
    sql: ${TABLE}.order_month ;;
  }

  dimension: order_year {
    type: number
    sql: ${TABLE}.order_year ;;
  }

  dimension: order_dow {
    type: string
    sql: ${TABLE}.order_dow ;;
  }

  dimension: order_hour {
    type: number
    sql: ${TABLE}.order_hour ;;
  }

  dimension: billing_address_id {
    type: number
    sql: ${TABLE}.billing_address_id ;;
  }

  dimension: discount_id {
    type: string
    sql: ${TABLE}.discount_id ;;
  }

  dimension: discount_code {
    type: string
    sql: ${TABLE}.discount_code ;;
  }

  dimension: customer_email {
    type: string
    sql: ${TABLE}.customer_email ;;
  }

  dimension: delivery_address_id {
    type: string
    sql: ${TABLE}.delivery_address_id ;;
  }

  dimension: customer_note {
    type: string
    sql: ${TABLE}.customer_note ;;
  }

  dimension: shipping_method_name {
    type: string
    sql: ${TABLE}.shipping_method_name ;;
  }

  dimension: anonymous_id {
    type: string
    sql: ${TABLE}.anonymous_id ;;
  }

  dimension: currency {
    type: string
    sql: ${TABLE}.currency ;;
  }

  dimension: discount_name {
    type: string
    sql: ${TABLE}.discount_name ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: shipping_method_id {
    type: number
    sql: ${TABLE}.shipping_method_id ;;
  }

  dimension: weight {
    type: number
    sql: ${TABLE}.weight ;;
  }

  dimension: language_code {
    type: string
    sql: ${TABLE}.language_code ;;
  }

  dimension: amt_delivery_fee_gross {
    type: number
    sql: ${TABLE}.amt_delivery_fee_gross ;;
  }

  dimension: amt_delivery_fee_net {
    type: number
    sql: ${TABLE}.amt_delivery_fee_net ;;
  }

  dimension: amt_gmv_gross {
    type: number
    sql: ${TABLE}.amt_gmv_gross ;;
  }

  dimension: amt_gmv_net {
    type: number
    sql: ${TABLE}.amt_gmv_net ;;
  }

  dimension: amt_revenue_gross {
    type: number
    sql: ${TABLE}.amt_revenue_gross ;;
  }

  dimension: amt_revenue_net {
    type: number
    sql: ${TABLE}.amt_revenue_net ;;
  }

  dimension: amt_discount_gross {
    type: number
    sql: ${TABLE}.amt_discount_gross ;;
  }

  dimension: amt_discount_net {
    type: number
    sql: ${TABLE}.amt_discount_net ;;
  }

  dimension: hub_name {
    type: string
    sql: ${TABLE}.hub_name ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: customer_latitude {
    type: number
    sql: ${TABLE}.customer_latitude ;;
  }

  dimension: customer_longitude {
    type: number
    sql: ${TABLE}.customer_longitude ;;
  }

  dimension: delivery_pdt_minutes {
    type: number
    sql: ${TABLE}.delivery_pdt_minutes ;;
  }

  dimension_group: delivery_pdt_timestamp {
    type: time
    sql: ${TABLE}.delivery_pdt_timestamp ;;
  }

  dimension_group: picking_started_timestamp {
    type: time
    sql: ${TABLE}.picking_started_timestamp ;;
  }

  dimension_group: picking_completed_timestamp {
    type: time
    sql: ${TABLE}.picking_completed_timestamp ;;
  }

  dimension_group: rider_claimed_timestamp {
    type: time
    sql: ${TABLE}.rider_claimed_timestamp ;;
  }

  dimension_group: rider_on_route_timestamp {
    type: time
    sql: ${TABLE}.rider_on_route_timestamp ;;
  }

  dimension_group: rider_arrived_at_customer_timestamp {
    type: time
    sql: ${TABLE}.rider_arrived_at_customer_timestamp ;;
  }

  dimension_group: rider_completed_delivery_timestamp {
    type: time
    sql: ${TABLE}.rider_completed_delivery_timestamp ;;
  }

  dimension_group: rider_returned_to_hub_timestamp {
    type: time
    sql: ${TABLE}.rider_returned_to_hub_timestamp ;;
  }

  dimension: fulfillment_time_minutes {
    type: number
    sql: ${TABLE}.fulfillment_time_minutes ;;
  }

  dimension: fulfillment_time_raw_minutes {
    type: number
    sql: ${TABLE}.fulfillment_time_raw_minutes ;;
  }

  dimension: reaction_time_minutes {
    type: number
    sql: ${TABLE}.reaction_time_minutes ;;
  }

  dimension: acceptance_time_minutes {
    type: number
    sql: ${TABLE}.acceptance_time_minutes ;;
  }

  dimension: picking_time_minutes {
    type: number
    sql: ${TABLE}.picking_time_minutes ;;
  }

  dimension: at_customer_time_minutes {
    type: number
    sql: ${TABLE}.at_customer_time_minutes ;;
  }

  dimension: delivery_time_minutes {
    type: number
    sql: ${TABLE}.delivery_time_minutes ;;
  }

  dimension: return_to_hub_time_minutes {
    type: number
    sql: ${TABLE}.return_to_hub_time_minutes ;;
  }

  dimension: delivery_estimate_model {
    type: string
    sql: ${TABLE}.delivery_estimate_model ;;
  }

  dimension: estimated_picking_time_minutes {
    type: number
    sql: ${TABLE}.estimated_picking_time_minutes ;;
  }

  dimension: estimated_riding_time_minutes {
    type: number
    sql: ${TABLE}.estimated_riding_time_minutes ;;
  }

  dimension: estimated_delivery_time_minutes {
    type: number
    sql: ${TABLE}.estimated_delivery_time_minutes ;;
  }

  dimension: google_cycling_time_minutes {
    type: number
    sql: ${TABLE}.google_cycling_time_minutes ;;
  }

  dimension: estimated_queuing_time_for_picker_minutes {
    type: number
    sql: ${TABLE}.estimated_queuing_time_for_picker_minutes ;;
  }

  dimension: estimated_queuing_time_for_rider_minutes {
    type: number
    sql: ${TABLE}.estimated_queuing_time_for_rider_minutes ;;
  }

  dimension: ct_new_customer_flag {
    type: string
    sql: ${TABLE}.ct_new_customer_flag ;;
  }

  dimension: is_discounted_order {
    type: string
    sql: ${TABLE}.is_discounted_order ;;
  }

  dimension: is_successful_order {
    type: string
    sql: ${TABLE}.is_successful_order ;;
  }

  dimension: is_internal_order {
    type: string
    sql: ${TABLE}.is_internal_order ;;
  }

  dimension: is_first_order {
    type: string
    sql: ${TABLE}.is_first_order ;;
  }

  dimension: number_of_distinct_skus {
    type: number
    sql: ${TABLE}.number_of_distinct_skus ;;
  }

  dimension: number_of_items {
    type: number
    sql: ${TABLE}.number_of_items ;;
  }

  dimension: rider_id {
    type: string
    sql: ${TABLE}.rider_id ;;
  }

  dimension: picker_id {
    type: string
    sql: ${TABLE}.picker_id ;;
  }

  dimension: delivery_id {
    type: string
    sql: ${TABLE}.delivery_id ;;
  }

  dimension: delivery_provider {
    type: string
    sql: ${TABLE}.delivery_provider ;;
  }

  dimension: delivery_method {
    type: string
    sql: ${TABLE}.delivery_method ;;
  }

  dimension: payment_type {
    type: string
    sql: ${TABLE}.payment_type ;;
  }

  dimension: payment_method {
    type: string
    sql: ${TABLE}.payment_method ;;
  }

  dimension: payment_company {
    type: string
    sql: ${TABLE}.payment_company ;;
  }

  dimension: is_fulfillment_above_30min {
    type: string
    sql: ${TABLE}.is_fulfillment_above_30min ;;
  }

  dimension: is_delivery_above_30min {
    type: string
    sql: ${TABLE}.is_delivery_above_30min ;;
  }

  dimension: is_order_on_time {
    type: string
    sql: ${TABLE}.is_order_on_time ;;
  }

  dimension: is_order_delay_above_5min {
    type: string
    sql: ${TABLE}.is_order_delay_above_5min ;;
  }

  dimension: is_order_delay_above_10min {
    type: string
    sql: ${TABLE}.is_order_delay_above_10min ;;
  }

  dimension: is_delivery_pdt_available {
    type: string
    sql: ${TABLE}.is_delivery_pdt_available ;;
  }

  dimension: cart_id {
    type: string
    sql: ${TABLE}.cart_id ;;
  }

  dimension: order_number {
    type: string
    sql: ${TABLE}.order_number ;;
  }

  dimension: stack_uuid {
    type: string
    sql: ${TABLE}.stack_uuid ;;
  }

  dimension: is_stacked_order {
    type: string
    sql: ${TABLE}.is_stacked_order ;;
  }

  dimension: number_of_stacked_orders {
    type: number
    sql: ${TABLE}.number_of_stacked_orders ;;
  }

  dimension: stacking_sequence {
    type: number
    sql: ${TABLE}.stacking_sequence ;;
  }

  dimension: delivery_time_from_prev_customer_minutes {
    type: number
    sql: ${TABLE}.delivery_time_from_prev_customer_minutes ;;
  }

  dimension: amt_rider_tip {
    type: number
    sql: ${TABLE}.amt_rider_tip ;;
  }

  dimension_group: last_modified_at {
    type: time
    sql: ${TABLE}.last_modified_at ;;
  }

  dimension: is_leading_system {
    type: string
    sql: ${TABLE}.is_leading_system ;;
  }

  dimension: customer_coordinates {
    type: string
    sql: ${TABLE}.customer_coordinates ;;
  }

  dimension: h3_hexagon_resolution_6 {
    type: string
    sql: ${TABLE}.h3_hexagon_resolution_6 ;;
  }

  dimension: h3_hexagon_resolution_7 {
    type: string
    sql: ${TABLE}.h3_hexagon_resolution_7 ;;
  }

  dimension: h3_hexagon_resolution_8 {
    type: string
    sql: ${TABLE}.h3_hexagon_resolution_8 ;;
  }

  dimension: h3_hexagon_resolution_9 {
    type: string
    sql: ${TABLE}.h3_hexagon_resolution_9 ;;
  }

  dimension: customer_order_rank {
    type: number
    sql: ${TABLE}.customer_order_rank ;;
  }

  dimension: customer_email_mapped {
    type: string
    sql: ${TABLE}.customer_email_mapped ;;
  }

  dimension: customer_id_mapped {
    type: string
    sql: ${TABLE}.customer_id_mapped ;;
  }

  dimension_group: sign_up_timestamp_customer_id {
    type: time
    sql: ${TABLE}.sign_up_timestamp_customer_id ;;
  }

  set: detail {
    fields: [
      order_uuid,
      order_id,
      customer_id,
      external_id,
      country_iso,
      shipping_city,
      backend_source,
      platform,
      order_timestamp_time,
      timezone,
      order_date,
      order_week,
      order_month,
      order_year,
      order_dow,
      order_hour,
      billing_address_id,
      discount_id,
      discount_code,
      customer_email,
      delivery_address_id,
      customer_note,
      shipping_method_name,
      anonymous_id,
      currency,
      discount_name,
      status,
      shipping_method_id,
      weight,
      language_code,
      amt_delivery_fee_gross,
      amt_delivery_fee_net,
      amt_gmv_gross,
      amt_gmv_net,
      amt_revenue_gross,
      amt_revenue_net,
      amt_discount_gross,
      amt_discount_net,
      hub_name,
      hub_code,
      customer_latitude,
      customer_longitude,
      delivery_pdt_minutes,
      delivery_pdt_timestamp_time,
      picking_started_timestamp_time,
      picking_completed_timestamp_time,
      rider_claimed_timestamp_time,
      rider_on_route_timestamp_time,
      rider_arrived_at_customer_timestamp_time,
      rider_completed_delivery_timestamp_time,
      rider_returned_to_hub_timestamp_time,
      fulfillment_time_minutes,
      fulfillment_time_raw_minutes,
      reaction_time_minutes,
      acceptance_time_minutes,
      picking_time_minutes,
      at_customer_time_minutes,
      delivery_time_minutes,
      return_to_hub_time_minutes,
      delivery_estimate_model,
      estimated_picking_time_minutes,
      estimated_riding_time_minutes,
      estimated_delivery_time_minutes,
      google_cycling_time_minutes,
      estimated_queuing_time_for_picker_minutes,
      estimated_queuing_time_for_rider_minutes,
      ct_new_customer_flag,
      is_discounted_order,
      is_successful_order,
      is_internal_order,
      is_first_order,
      number_of_distinct_skus,
      number_of_items,
      rider_id,
      picker_id,
      delivery_id,
      delivery_provider,
      delivery_method,
      payment_type,
      payment_method,
      payment_company,
      is_fulfillment_above_30min,
      is_delivery_above_30min,
      is_order_on_time,
      is_order_delay_above_5min,
      is_order_delay_above_10min,
      is_delivery_pdt_available,
      cart_id,
      order_number,
      stack_uuid,
      is_stacked_order,
      number_of_stacked_orders,
      stacking_sequence,
      delivery_time_from_prev_customer_minutes,
      amt_rider_tip,
      last_modified_at_time,
      is_leading_system,
      customer_coordinates,
      h3_hexagon_resolution_6,
      h3_hexagon_resolution_7,
      h3_hexagon_resolution_8,
      h3_hexagon_resolution_9,
      customer_order_rank,
      customer_email_mapped,
      customer_id_mapped,
      sign_up_timestamp_customer_id_time
    ]
  }
}
