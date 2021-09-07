include: "/explores/consumer_product/order_backend_and_client.explore.lkml"
# include: "/views/projects/consumer_product/order_placed_events.view.lkml"
# include: "/views/bigquery_tables/curated_layer/orders.view.lkml"
include: "/views/projects/consumer_product/contact_customer_service_selected_view.view.lkml"
include: "/views/projects/consumer_product/order_comments.view.lkml"

explore: order_for_postorder{
  from: order_comments
  label: "Postorder With Backend Orders"
  view_label: "Postorder With Backend Orders"
  group_label: "10) In-app tracking data"
  description: "Combines (backend) orders view and postorder events"

  join: order_client {
    from: order_placed_events
    type: left_outer
    relationship: one_to_one
    sql_on: ${order_client.order_uuid} = ${order_for_postorder.order_uuid} ;;
  }

  join: contact_customer_service_selected_view {
    from: contact_customer_service_selected_view
    type: left_outer
    relationship: one_to_one
    sql_on: ${contact_customer_service_selected_view.order_uuid} = ${order_for_postorder.order_uuid} ;;
  }


  # fields: [order_for_postorder.fulfillment_time
  #   , order_for_postorder.fulfillment_time_tier
  #   , order_for_postorder.is_fulfillment_less_than_1_minute
  #   , order_for_postorder.is_successful_order, delivery_time
  #   , order_for_postorder.delivery_eta_minutes
  #   , order_for_postorder.is_internal_order
  #   , order_for_postorder.delivery_eta_timestamp_date
  #   , order_for_postorder.delivery_timestamp_date
  #   , order_for_postorder.delivery_delay_since_eta
  #   , order_for_postorder.hub_code
  #   , order_for_postorder.created_date
  #   , order_client*
  #   , contact_customer_service_selected_view*]
}
