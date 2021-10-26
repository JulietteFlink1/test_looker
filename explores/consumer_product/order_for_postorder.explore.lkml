include: "/explores/consumer_product/order_backend_and_client.explore.lkml"
# include: "/views/projects/consumer_product/contact_customer_service_selected_view.view.lkml"
# include: "/views/projects/consumer_product/order_tracking_raw.view.lkml"
include: "/views/projects/consumer_product/order_comments.view.lkml"
include: "/views/projects/consumer_product/postorder_events.view.lkml"
include: "/views/bigquery_tables/curated_layer/nps_after_order_cl.view"

explore: order_for_postorder{
  from: order_comments
  label: "Postorder With Backend Orders"
  view_label: "Postorder With Backend Orders"
  group_label: "In-app tracking data"
  description: "Combines (backend) orders view and postorder events"

  join: order_client {
    from: order_placed_events
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
    view_label: "* NPS CL*"
    sql_on: ${order_for_postorder.country_iso}   = ${nps_after_order.country_iso} AND
      ${order_for_postorder.order_number}  =       ${nps_after_order.order_number} ;;
    relationship: one_to_many
    type: left_outer
  }

}
