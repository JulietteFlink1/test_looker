# Owner: Product Analytics

# Main Stakeholder:
# - Consumer Product
# - Retail / Commercial team

# Questions that can be answered
# - Questions around behavioural events with country and device drill downs

include: "/**/daily_user_aggregates.view.lkml"
include: "/**/daily_events.view.lkml"
include: "/**/global_filters_and_parameters.view.lkml"
include: "/**/event_product_added_to_cart.view.lkml"
include: "/**/event_category_selected.view.lkml"
include: "/**/event_address_confirmed.view.lkml"
include: "/**/event_contact_customer_service_selected.view.lkml"
include: "/**/event_cart_viewed.view.lkml"
include: "/**/event_cart_updated.view.lkml"
include: "/**/event_checkout_viewed.view.lkml"
include: "/**/event_order_placed.view.lkml"
include: "/**/daily_violations_aggregates.view.lkml"
include: "/**/event_sponsored_product_impressions.view.lkml"
include: "/**/event_payment_failed.view.lkml"
include: "/**/event_order_tracking_viewed.view.lkml"
include: "/**/event_load_trace_started.view.lkml"
include: "/**/event_load_trace_completed.view.lkml"
include: "/**/hubs_ct.view.lkml"

explore: daily_events {
  from:  daily_events
  view_name: daily_events
  hidden: no

  label: "Daily Events"
  description: "This explore provides an overview of all behavioural events generated on Flink App and Web"
  group_label: "Product - Consumer"

  # implement both date filters:
    # received_at is due cost reduction given a table is partitioned by this dimensions
    # event_date filter will fitler for the desired time frame when events triggered

  sql_always_where:{% condition global_filters_and_parameters.datasource_filter %} ${event_date} {% endcondition %}
  and ${event_date}<= CURRENT_DATE();;
  # add current_date() requirement to avoid showing future dates

  access_filter: {
    field: daily_events.country_iso
    user_attribute: country_iso
  }

  always_filter: {
    filters: [
      global_filters_and_parameters.datasource_filter: "last 7 days",
      global_filters_and_parameters.timeframe_picker: "Date",
      daily_events.event_name: "",
      daily_events.country_iso: ""
      ]
  }

  join: global_filters_and_parameters {
    sql: ;;
    relationship: one_to_one
  }

  join: event_category_selected {
    view_label: "Event: Category Selected"
    fields: [event_category_selected.category_name, event_category_selected.category_id,
            event_category_selected.subcategory_name, event_category_selected.sub_category_id,
            event_category_selected.screen_name]
    sql_on: ${event_category_selected.event_uuid} = ${daily_events.event_uuid}
            and {% condition global_filters_and_parameters.datasource_filter %} ${event_category_selected.event_date} {% endcondition %};;
    type: left_outer
    relationship: one_to_one
  }

  join: event_product_added_to_cart {
    view_label: "Event: Product Added to Cart"
    fields: [event_product_added_to_cart.category_name, event_product_added_to_cart.category_id,
      event_product_added_to_cart.sub_category_name, event_product_added_to_cart.sub_category_id,
      event_product_added_to_cart.screen_name, event_product_added_to_cart.product_name,
      event_product_added_to_cart.product_sku, event_product_added_to_cart.actual_product_price,
      event_product_added_to_cart.discount, event_product_added_to_cart.is_discount_applied,
      event_product_added_to_cart.list_position, event_product_added_to_cart.original_price, event_product_added_to_cart.original_product_price,
      event_product_added_to_cart.product_placement, event_product_added_to_cart.product_position,
      event_product_added_to_cart.search_query_id, event_product_added_to_cart.product_sku_per_user]
    sql_on: ${event_product_added_to_cart.event_uuid} = ${daily_events.event_uuid}
            and {% condition global_filters_and_parameters.datasource_filter %} ${event_product_added_to_cart.event_date} {% endcondition %};;
    type: left_outer
    relationship: one_to_one
  }

  join: event_address_confirmed {
    view_label: "Event: Address Confirmed"
    fields: [event_attributes*]
    sql_on: ${event_address_confirmed.event_uuid} = ${daily_events.event_uuid}
            and {% condition global_filters_and_parameters.datasource_filter %} ${event_address_confirmed.event_date} {% endcondition %};;
    type: left_outer
    relationship: one_to_one
  }

  join: event_contact_customer_service_selected {
    view_label: "Event: Contact Customer Service Selected"
    fields: [event_attributes*]
    sql_on: ${event_contact_customer_service_selected.event_uuid} = ${daily_events.event_uuid}
            and {% condition global_filters_and_parameters.datasource_filter %} ${event_contact_customer_service_selected.event_date} {% endcondition %};;
    type: left_outer
    relationship: one_to_one
  }

  join: event_cart_viewed {
    view_label: "Event: Cart Viewed"
    fields: [event_cart_viewed.amt_delivery_fee_eur,
            event_cart_viewed.amt_sub_total_eur,
            event_cart_viewed.rank_of_daily_cart_views ,
            event_cart_viewed.message_displayed,
            event_cart_viewed.avg_daily_cart_viewed_events,
            event_cart_viewed.shipping_method_id,
            event_cart_viewed.cart_id,
            event_cart_viewed.screen_name,
            event_cart_viewed.products,
            event_cart_viewed.is_empty_cart]
    sql_on: ${event_cart_viewed.event_uuid} = ${daily_events.event_uuid}
            and {% condition global_filters_and_parameters.datasource_filter %} ${event_cart_viewed.event_date} {% endcondition %};;
    type: left_outer
    relationship: one_to_one
  }

  join: event_cart_updated {
    view_label: "Event: Cart Updated"
    fields: [event_cart_updated.amt_delivery_fee_eur,
            event_cart_updated.amt_sub_total_eur,
            event_cart_updated.rank_of_daily_cart_updates ,
            event_cart_updated.message_displayed,
            event_cart_updated.avg_daily_cart_updates_events,
            event_cart_updated.shipping_method_id,
            event_cart_updated.cart_id]
    sql_on: ${event_cart_updated.event_uuid} = ${daily_events.event_uuid}
      and {% condition global_filters_and_parameters.datasource_filter %} ${event_cart_updated.event_date} {% endcondition %};;
    type: left_outer
    relationship: one_to_one
  }

  join: event_checkout_viewed {
    view_label: "Event: Checkout Viewed"
    fields: [event_checkout_viewed.amt_delivery_fee_eur,
            event_checkout_viewed.amt_storage_fee_eur,
            event_checkout_viewed.amt_late_night_fee_eur,
            event_checkout_viewed.amt_deposit_eur,
            event_checkout_viewed.amt_discount_value_eur,
            event_checkout_viewed.amt_order_subtotal_eur,
            event_checkout_viewed.amt_order_total_eur,
            event_checkout_viewed.products,
            event_checkout_viewed.shipping_method_id,
            event_checkout_viewed.cart_id,
            event_checkout_viewed.delivery_pdt,
            event_checkout_viewed.is_pdt_shown,
            event_checkout_viewed.is_planned_delivery,
            event_checkout_viewed.timeslot_start_hour,
            event_checkout_viewed.timeslot_end_hour]
    sql_on: ${event_checkout_viewed.event_uuid} = ${daily_events.event_uuid}
      and {% condition global_filters_and_parameters.datasource_filter %} ${event_checkout_viewed.event_timestamp_date} {% endcondition %};;
    type: left_outer
    relationship: one_to_one
  }

  join: event_load_trace_started {
    view_label: "Event: Load Tracing Started"
    fields: [event_load_trace_started.action_id,
      event_load_trace_started.trace_name,
      event_load_trace_completed.start_timestamp_time]
    sql_on: ${event_load_trace_started.event_uuid} = ${daily_events.event_uuid}
      and {% condition global_filters_and_parameters.datasource_filter %} ${event_load_trace_started.event_timestamp_date} {% endcondition %}
      and {% condition global_filters_and_parameters.datasource_filter %} ${event_load_trace_started.start_timestamp_date} {% endcondition %};;
    type: left_outer
    relationship: one_to_one
  }

  join: event_load_trace_completed {
    view_label: "Event: Load Tracing Completed"
    fields: [event_load_trace_completed.load_duration,
             event_load_trace_completed.load_duration_ms_min,
             event_load_trace_completed.load_duration_ms_max,
             event_load_trace_completed.load_duration_ms_5th,
             event_load_trace_completed.load_duration_ms_25th,
             event_load_trace_completed.load_duration_ms_50th,
             event_load_trace_completed.load_duration_ms_75th,
             event_load_trace_completed.load_duration_ms_90th,
             event_load_trace_completed.load_duration_ms_95th,
             event_load_trace_completed.trace_name,
             event_load_trace_completed.action_id,
             event_load_trace_completed.start_timestamp_time,
             event_load_trace_completed.start_timestamp_date,
             event_load_trace_completed.start_timestamp_week,
             event_load_trace_completed.start_timestamp_month,
             event_load_trace_completed.end_timestamp_time,
             event_load_trace_completed.end_timestamp_date,
             event_load_trace_completed.end_timestamp_week,
             event_load_trace_completed.end_timestamp_month,
            event_load_trace_completed.load_duration_tier_size,
            event_load_trace_completed.dynamic_load_duration_tier
            ]
    sql_on: ${event_load_trace_completed.event_uuid} = ${daily_events.event_uuid}
      and {% condition global_filters_and_parameters.datasource_filter %} ${event_load_trace_completed.event_timestamp_date} {% endcondition %}
      and {% condition global_filters_and_parameters.datasource_filter %} ${event_load_trace_completed.start_timestamp_date} {% endcondition %};;
    type: left_outer
    relationship: one_to_one
  }

  join: event_order_placed {
    view_label: "Event: Order Placed"
    fields: [event_order_placed.amt_delivery_fee_eur,
            event_order_placed.shipping_method_id,
            event_order_placed.cart_id,
            event_order_placed.delivery_pdt,
            event_order_placed.discount_value,
            event_order_placed.number_of_products_ordered,
            event_order_placed.amt_revenue_eur,
            event_order_placed.rider_tip_value,
            event_order_placed.is_pdt_shown,
            event_order_placed.is_planned_delivery,
            event_order_placed.timeslot_start_hour,
            event_order_placed.timeslot_end_hour]
    sql_on: ${event_order_placed.event_id} = ${daily_events.event_uuid}
            and {% condition global_filters_and_parameters.datasource_filter %} ${event_order_placed.event_timestamp_date} {% endcondition %};;
    type: left_outer
    relationship: one_to_one
  }

  join: event_payment_failed {
    view_label: "Event: Payment Failed"
    fields: [event_payment_failed.failed_at,
      event_payment_failed.payment_method,
      event_payment_failed.error_details]
    sql_on: ${event_payment_failed.event_uuid} = ${daily_events.event_uuid}
      and {% condition global_filters_and_parameters.datasource_filter %} ${event_payment_failed.event_timestamp_date} {% endcondition %};;
    type: left_outer
    relationship: one_to_one
  }

  join: event_order_tracking_viewed {
    view_label: "Event: Order Tracking Viewed"
    fields: [event_order_tracking_viewed.order_id,
      event_order_tracking_viewed.order_status,
      event_order_tracking_viewed.delivery_eta,
      event_order_tracking_viewed.delivery_pdt]
    sql_on: ${event_order_tracking_viewed.event_uuid} = ${daily_events.event_uuid}
      and {% condition global_filters_and_parameters.datasource_filter %} ${event_order_tracking_viewed.event_timestamp_date} {% endcondition %};;
    type: left_outer
    relationship: one_to_one
  }

  join: event_sponsored_product_impressions {
    view_label: "Event: Sponsored Product Impressions"
    fields: [event_sponsored_product_impressions.category_name,
      event_sponsored_product_impressions.category_id,
      event_sponsored_product_impressions.sub_category_name,
      event_sponsored_product_impressions.screen_name,
      event_sponsored_product_impressions.product_sku,
      event_sponsored_product_impressions.product_placement,
      event_sponsored_product_impressions.product_position,
      event_sponsored_product_impressions.ad_decision_id,
      event_sponsored_product_impressions.event_timestamp_date,
      event_sponsored_product_impressions.is_sponsored_product,
      event_sponsored_product_impressions.number_of_ad_decisions_ids,
      event_sponsored_product_impressions.events,
      event_sponsored_product_impressions.all_users,
      event_sponsored_product_impressions.categories_with_reco_highlights
      ]
    sql_on: ${event_sponsored_product_impressions.event_id} = ${daily_events.event_uuid}
           and {% condition global_filters_and_parameters.datasource_filter %} ${event_sponsored_product_impressions.event_timestamp_date} {% endcondition %}  ;;
    type: left_outer
    relationship: one_to_many
  }

join: daily_violations_aggregates {
  view_label: "Event: Violation Generated" ##to unhide change the label to: Event: Violation Generated
  fields: [daily_violations_aggregates.violated_event_name , daily_violations_aggregates.number_of_violations]
  sql_on: ${daily_events.event_name_camel_case} = ${daily_violations_aggregates.violated_event_name}
          and ${daily_events.event_date}=${daily_violations_aggregates.event_date}
          and ${daily_events.platform} = ${daily_violations_aggregates.platform}
          and ${daily_violations_aggregates.domain}="consumer"
          and {% condition global_filters_and_parameters.datasource_filter %}
            ${daily_violations_aggregates.event_date} {% endcondition %};;
  type: left_outer
  relationship: many_to_many
}

  join: daily_user_aggregates {
    view_label: "Daily User Aggregates"
    fields: [daily_user_aggregates.is_address_confirmed, daily_user_aggregates.is_address_deliverable,
             daily_user_aggregates.is_checkout_started, daily_user_aggregates.is_checkout_viewed,
             daily_user_aggregates.is_order_placed,
             daily_user_aggregates.is_cart_viewed,
             daily_user_aggregates.is_product_search_viewed,
             daily_user_aggregates.is_product_search_executed,
             daily_user_aggregates.is_product_added_to_cart,
             daily_user_aggregates.is_payment_started,
             daily_user_aggregates.is_product_details_viewed,
             daily_user_aggregates.is_account_registration_viewed, is_home_viewed, is_new_user,
             users_with_product_details_viewed, daily_user_aggregates.users_with_product_search_viewed,
             daily_user_aggregates.users_with_cart_viewed, daily_user_aggregates.users_with_home_viewed,
             daily_user_aggregates.users_with_add_to_cart,
             daily_user_aggregates.users_with_address,
            daily_user_aggregates.users_with_category_selected,
             daily_user_aggregates.daily_users_with_address,
             daily_user_aggregates.daily_users_with_product_search_viewed,
            daily_user_aggregates.daily_users_with_cart_viewed,
            daily_user_aggregates.daily_users_with_add_to_cart,
            daily_user_aggregates.daily_users_with_home_viewed,
            daily_user_aggregates.daily_users_with_product_details_viewed,
            daily_user_aggregates.daily_users_with_category_selected,
            daily_user_aggregates.is_category_selected,
            daily_user_aggregates.is_active_user,
            daily_user_aggregates.daily_active_users,
            daily_user_aggregates.is_pdt_shown,
            daily_user_aggregates.is_planned_delivery
    ]
    sql_on: ${daily_user_aggregates.user_uuid} = ${daily_events.anonymous_id}
      and ${daily_user_aggregates.event_date_at_date} = ${daily_events.event_date}
      and {% condition global_filters_and_parameters.datasource_filter %} ${daily_user_aggregates.event_date_at_date} {% endcondition %}  ;;
    type: left_outer
    relationship: many_to_one
  }

  join: hubs_ct {
    view_label: "Hubs"
    sql_on: ${hubs_ct.hub_code} = ${daily_events.hub_code};;
    type: left_outer
    relationship: many_to_one
  }

}
