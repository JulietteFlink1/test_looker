# include: "/explores/consumer_product/order_backend_and_client.explore.lkml"
# include: "/views/projects/consumer_product/contact_customer_service_selected_view.view.lkml"
# include: "/views/projects/consumer_product/order_tracking_raw.view.lkml"
# include: "/**/*/order_comments.view.lkml"
# include: "/**/*//postorder_events.view.lkml"
# include: "/views/bigquery_tables/curated_layer/nps_after_order_cl.view"
include: "/**/*.view"

explore: order_for_postorder{
  from: order_comments
  label: "Postorder Events"
  view_label: "Postorder Events"
  group_label: "Product - Consumer"
  description: "Post-order related events, order dimensions, comments and nps"
 #   fields: [ALL_FIELDS*, -order_for_postorder.cnt_orders_delayed_under_0_min,
 #     -order_for_postorder.cnt_orders_delayed_over_5_min, -order_for_postorder.cnt_orders_with_delivery_eta_available, -order_for_postorder.pct_orders_delivered_by_riders]

  join: global_filters_and_parameters {
    sql: ;;
    # Use `sql` instead of `sql_on` and put some whitespace in it
    relationship: one_to_one
    fields: [global_filters_and_parameters.is_after_product_discounts]
  }

  join: order_client {
    from: order_placed_events
    view_label: "Client Orders"
    type: left_outer
    relationship: one_to_one
    sql_on: ${order_client.order_uuid} = ${order_for_postorder.order_uuid} ;;
  }

  join: postorder_events {
    from: postorder_events
    type: left_outer
    relationship: one_to_one
    sql_on: ${postorder_events.order_uuid} = ${order_for_postorder.order_uuid} ;;
  }

  join: nps_after_order {
    from: nps_after_order_cl
    view_label: "NPS"
    sql_on: ${order_for_postorder.country_iso}   = ${nps_after_order.country_iso} AND
      ${order_for_postorder.order_number}  =       ${nps_after_order.order_number} ;;
    relationship: one_to_many
    type: left_outer
  }

}
