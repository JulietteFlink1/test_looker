include: "/views/projects/consumer_product/order_placed_events.view.lkml"
include: "/views/bigquery_tables/curated_layer/orders.view.lkml"

explore: order_backend_and_client{
  from: orders
  # view_name: order_backend_and_client
  label: "Order Client Tracking And Backend Matches"
  view_label: "Order Backend"
  group_label: "In-app tracking data"
  description: "Combines (backend) orders view and client orderPlaced view to show platform and other user information for orders"

  join: order_client {
    from: order_placed_events
    type: left_outer
    relationship: one_to_one
    sql_on: ${order_client.order_uuid} = ${order_backend_and_client.order_uuid} ;;
  }

  fields: [order_backend_and_client.fulfillment_time
    , order_backend_and_client.fulfillment_time_tier
    , order_backend_and_client.is_fulfillment_less_than_1_minute
    , order_backend_and_client.is_successful_order, delivery_time
    , order_backend_and_client.delivery_eta_minutes
    , order_backend_and_client.is_internal_order
    , order_backend_and_client.delivery_eta_timestamp_date
    , order_backend_and_client.delivery_timestamp_date
    , order_backend_and_client.delivery_delay_since_eta
    , order_backend_and_client.hub_code
    , order_backend_and_client.created_date
    , order_client*]
}
