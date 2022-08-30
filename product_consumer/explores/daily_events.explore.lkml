# Owner: Product Analytics, Patricia Mitterova

# Main Stakeholder:
# - Consumer Product
# - Retail / Commercial team

# Questions that can be answered
# - Questions around behavioural events with country and device drill downs

include: "/product_consumer/views/bigquery_curated/daily_events.view.lkml"
include: "/**/global_filters_and_parameters.view.lkml"
include: "/product_consumer/views/bigquery_curated/event_product_added_to_cart.view.lkml"
include: "/product_consumer/views/bigquery_curated/event_category_selected.view.lkml"
include: "/product_consumer/views/bigquery_curated/event_address_confirmed.view.lkml"
include: "/product_consumer/views/bigquery_curated/event_contact_customer_service_selected.view.lkml"
include: "/product_consumer/views/bigquery_curated/event_cart_viewed.view.lkml"
include: "/product_consumer/views/bigquery_curated/event_order_placed.view.lkml"
include: "/product_consumer/views/bigquery_reporting/daily_violations_aggregates.view.lkml"
include: "/product_consumer/views/bigquery_curated/event_sponsored_product_impressions.view.lkml"

explore: daily_events {
  from:  daily_events
  view_name: daily_events
  hidden: no

  label: "Daily Events"
  description: "This explore provides an overview of all behavioural events generated on Flink App and Web"
  group_label: "Consumer Product"

  # implement both date filters:
    # received_at is due cost reduction given a table is partitioned by this dimensions
    # event_date filter will fitler for the desired time frame when events triggered

  sql_always_where:{% condition global_filters_and_parameters.datasource_filter %} ${event_date} {% endcondition %};;

  access_filter: {
    field: daily_events.country_iso
    user_attribute: country_iso
  }

  always_filter: {
    filters: [
      global_filters_and_parameters.datasource_filter: "last 7 days"
      ]
  }

  join: global_filters_and_parameters {
    sql_on: ${global_filters_and_parameters.generic_join_dim} = TRUE ;;
    type: left_outer
    relationship: many_to_one
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
      event_product_added_to_cart.search_query_id]
    sql_on: ${event_product_added_to_cart.event_uuid} = ${daily_events.event_uuid}  ;;
    type: left_outer
    relationship: one_to_one
  }

  join: event_address_confirmed {
    view_label: "Event: Address Confirmed"
    fields: [event_attributes*]
    sql_on: ${event_address_confirmed.event_uuid} = ${daily_events.event_uuid}  ;;
    type: left_outer
    relationship: one_to_one
  }

  join: event_contact_customer_service_selected {
    view_label: "Event: Contact Customer Service Selected"
    fields: [event_attributes*]
    sql_on: ${event_contact_customer_service_selected.event_uuid} = ${daily_events.event_uuid}  ;;
    type: left_outer
    relationship: one_to_one
  }

  join: event_cart_viewed {
    view_label: "Event: Cart Viewed"
    fields: [event_cart_viewed.delivery_fee, event_cart_viewed.rank_of_daily_cart_views , event_cart_viewed.message_displayed,
      event_cart_viewed.avg_daily_cart_events]
    sql_on: ${event_cart_viewed.event_uuid} = ${daily_events.event_uuid}  ;;
    type: left_outer
    relationship: one_to_one
  }

  join: event_order_placed {
    view_label: "Event: Order Placed"
    fields: [event_order_placed.delivery_fee , event_order_placed.delivery_pdt, event_order_placed.discount_value,
      event_order_placed.number_of_products_ordered , event_order_placed.revenue , event_order_placed.rider_tip_value]
    sql_on: ${event_order_placed.event_id} = ${daily_events.event_uuid}  ;;
    type: left_outer
    relationship: one_to_one
  }

  join: event_sponsored_product_impressions {
    view_label: "Event: Sponsored Product Impressions"
    fields: [event_sponsored_product_impressions.category_name, event_sponsored_product_impressions.category_id,
      event_sponsored_product_impressions.sub_category_name,
      event_sponsored_product_impressions.screen_name,
      event_sponsored_product_impressions.product_sku,
      event_sponsored_product_impressions.product_placement, event_sponsored_product_impressions.product_position,
      event_sponsored_product_impressions.ad_decision_id,event_sponsored_product_impressions.event_timestamp_date,
      event_sponsored_product_impressions.number_of_ad_decisions_ids,event_sponsored_product_impressions.events,
      event_sponsored_product_impressions.all_users,
      ]
    sql_on: ${event_sponsored_product_impressions.event_id} = ${daily_events.event_uuid}
           and {% condition global_filters_and_parameters.datasource_filter %} ${event_sponsored_product_impressions.event_timestamp_date} {% endcondition %}  ;;
    type: left_outer
    relationship: one_to_many
  }

join: daily_violations_aggregates {
  view_label: "Event: Violation Generated" ##to unhide change the label to: Event: Violation Generated
  fields: [daily_violations_aggregates.violated_event_name , daily_violations_aggregates.number_of_violations]
  sql_on: ${daily_events.event_name_camel_case} = ${daily_violations_aggregates.violated_event_name} and ${daily_events.event_date}=${daily_violations_aggregates.event_date} and ${daily_events.platform}=${daily_violations_aggregates.platform};;
  type: left_outer
  relationship: many_to_many
}
}
