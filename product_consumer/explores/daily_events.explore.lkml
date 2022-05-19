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
    sql_on: ${event_category_selected.event_uuid} = ${daily_events.event_uuid} ;;
    type: left_outer
    relationship: one_to_one
  }

  join: event_product_added_to_cart {
    view_label: "Event: Product Added to Cart"
    fields: [event_product_added_to_cart.category_name, event_product_added_to_cart.category_id,
      event_product_added_to_cart.sub_category_name, event_product_added_to_cart.sub_category_id,
      event_product_added_to_cart.screen_name, event_product_added_to_cart.product_name,
      event_product_added_to_cart.product_sku, event_product_added_to_cart.actual_product_price,
      event_product_added_to_cart.aiv, event_product_added_to_cart.discount, event_product_added_to_cart.is_discount_applied,
      event_product_added_to_cart.list_position, event_product_added_to_cart.original_price, event_product_added_to_cart.original_product_price,
      event_product_added_to_cart.product_placement, event_product_added_to_cart.product_position,
      event_product_added_to_cart.search_query_id]
    sql_on: ${event_product_added_to_cart.event_uuid} = ${daily_events.event_uuid}  ;;
    type: left_outer
    relationship: one_to_one
  }
}
