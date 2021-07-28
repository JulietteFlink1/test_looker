view: orders_ct {
  sql_table_name: `flink-data-dev.curated.orders_ct`
    ;;

  dimension: acceptance_time_minutes {
    type: number
    sql: ${TABLE}.acceptance_time_minutes ;;
  }

  dimension: amt_delivery_fee_gross {
    type: number
    sql: ${TABLE}.amt_delivery_fee_gross ;;
  }

  dimension: amt_delivery_fee_net {
    type: number
    sql: ${TABLE}.amt_delivery_fee_net ;;
  }

  dimension: amt_discount_gross {
    type: number
    sql: ${TABLE}.amt_discount_gross ;;
  }

  dimension: amt_discount_net {
    type: number
    sql: ${TABLE}.amt_discount_net ;;
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

  dimension: anonymous_id {
    type: string
    sql: ${TABLE}.anonymous_id ;;
  }

  dimension: backend_source {
    type: string
    sql: ${TABLE}.backend_source ;;
  }

  dimension: billing_address_id {
    type: number
    sql: ${TABLE}.billing_address_id ;;
  }

  dimension: cart_id {
    type: string
    sql: ${TABLE}.cart_id ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: currency {
    type: string
    sql: ${TABLE}.currency ;;
  }

  dimension: customer_email {
    type: string
    sql: ${TABLE}.customer_email ;;
  }

  dimension: customer_id {
    type: string
    sql: ${TABLE}.customer_id ;;
  }

  dimension: customer_note {
    type: string
    sql: ${TABLE}.customer_note ;;
  }

  dimension: delivery_address_id {
    type: string
    sql: ${TABLE}.delivery_address_id ;;
  }

  dimension: delivery_eta_minutes {
    type: number
    sql: ${TABLE}.delivery_eta_minutes ;;
  }

  dimension_group: delivery_eta_timestamp {
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
    sql: ${TABLE}.delivery_eta_timestamp ;;
  }

  dimension: delivery_id {
    type: string
    sql: ${TABLE}.delivery_id ;;
  }

  dimension: delivery_method {
    type: string
    sql: ${TABLE}.delivery_method ;;
  }

  dimension: delivery_provider {
    type: string
    sql: ${TABLE}.delivery_provider ;;
  }

  dimension: delivery_time_minutes {
    type: number
    sql: ${TABLE}.delivery_time_minutes ;;
  }

  dimension: discount_code {
    type: string
    sql: ${TABLE}.discount_code ;;
  }

  dimension: discount_id {
    type: string
    sql: ${TABLE}.discount_id ;;
  }

  dimension: discount_name {
    type: string
    sql: ${TABLE}.discount_name ;;
  }

  dimension: fulfillment_time_minutes {
    type: number
    sql: ${TABLE}.fulfillment_time_minutes ;;
  }

  dimension: fulfillment_time_raw_minutes {
    type: number
    sql: ${TABLE}.fulfillment_time_raw_minutes ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: hub_name {
    type: string
    sql: ${TABLE}.hub_name ;;
  }

  dimension: is_delivery_above_30min {
    type: yesno
    sql: ${TABLE}.is_delivery_above_30min ;;
  }

  dimension: is_delivery_eta_available {
    type: yesno
    sql: ${TABLE}.is_delivery_eta_available ;;
  }

  dimension: is_discounted_order {
    type: yesno
    sql: ${TABLE}.is_discounted_order ;;
  }

  dimension: is_first_order {
    type: yesno
    sql: ${TABLE}.is_first_order ;;
  }

  dimension: is_fulfillment_above_30min {
    type: yesno
    sql: ${TABLE}.is_fulfillment_above_30min ;;
  }

  dimension: is_internal_order {
    type: yesno
    sql: ${TABLE}.is_internal_order ;;
  }

  dimension: is_order_delay_above_10min {
    type: yesno
    sql: ${TABLE}.is_order_delay_above_10min ;;
  }

  dimension: is_order_delay_above_5min {
    type: yesno
    sql: ${TABLE}.is_order_delay_above_5min ;;
  }

  dimension: is_order_on_time {
    type: yesno
    sql: ${TABLE}.is_order_on_time ;;
  }

  dimension: is_successful_order {
    type: yesno
    sql: ${TABLE}.is_successful_order ;;
  }

  dimension: language_code {
    type: string
    sql: ${TABLE}.language_code ;;
  }

  dimension_group: last_modified {
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
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: number_of_distinct_skus {
    type: number
    sql: ${TABLE}.number_of_distinct_skus ;;
  }

  dimension: number_of_items {
    type: number
    sql: ${TABLE}.number_of_items ;;
  }

  dimension: order_date {
    type: date
    sql: ${TABLE}.order_date ;;
  }

  dimension: order_delivered_timestamp {
    type: date_time
    sql: ${TABLE}.order_delivered_timestamp ;;
  }

  dimension: order_dow {
    type: string
    sql: ${TABLE}.order_dow ;;
  }

  dimension: order_hour {
    type: number
    sql: ${TABLE}.order_hour ;;
  }

  dimension: order_id {
    type: string
    sql: ${TABLE}.order_id ;;
  }

  dimension: order_month {
    type: string
    sql: ${TABLE}.order_month ;;
  }

  dimension: order_number {
    type: string
    sql: ${TABLE}.order_number ;;
  }

  dimension: order_on_route_timestamp {
    type: date_time
    sql: ${TABLE}.order_on_route_timestamp ;;
  }

  dimension: order_packed_timestamp {
    type: date_time
    sql: ${TABLE}.order_packed_timestamp ;;
  }

  dimension: order_picker_accepted_timestamp {
    type: date_time
    sql: ${TABLE}.order_picker_accepted_timestamp ;;
  }

  dimension: order_rider_claimed_timestamp {
    type: date_time
    sql: ${TABLE}.order_rider_claimed_timestamp ;;
  }

  dimension: order_timestamp {
    type: date_time
    sql: ${TABLE}.order_timestamp ;;
  }

  dimension: order_uuid {
    type: string
    sql: ${TABLE}.order_uuid ;;
  }

  dimension: order_week {
    type: date_time
    convert_tz: no
    sql: ${TABLE}.order_week ;;
  }

  dimension: order_year {
    type: number
    sql: ${TABLE}.order_year ;;
  }

  dimension: payment_type {
    type: string
    sql: ${TABLE}.payment_type ;;
  }

  dimension: picker_id {
    type: string
    sql: ${TABLE}.picker_id ;;
  }

  dimension: picking_time_minutes {
    type: number
    sql: ${TABLE}.picking_time_minutes ;;
  }

  dimension: reaction_time_minutes {
    type: number
    sql: ${TABLE}.reaction_time_minutes ;;
  }

  dimension: rider_id {
    type: string
    sql: ${TABLE}.rider_id ;;
  }

  dimension: shipping_city {
    type: string
    sql: ${TABLE}.shipping_city ;;
  }

  dimension: shipping_method_id {
    type: number
    sql: ${TABLE}.shipping_method_id ;;
  }

  dimension: shipping_method_name {
    type: string
    sql: ${TABLE}.shipping_method_name ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: timezone {
    type: string
    sql: ${TABLE}.timezone ;;
  }

  dimension: translated_discount_name {
    type: string
    sql: ${TABLE}.translated_discount_name ;;
  }

  dimension: weight {
    type: number
    sql: ${TABLE}.weight ;;
  }

  measure: count {
    type: count
    drill_fields: [translated_discount_name, shipping_method_name, hub_name, discount_name]
  }
}
