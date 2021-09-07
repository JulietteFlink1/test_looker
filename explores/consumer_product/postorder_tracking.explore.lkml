include: "/views/projects/consumer_product/postorder_tracking.view.lkml"
include: "/views/bigquery_tables/curated_layer/orders.view.lkml"

explore: postorder_tracking {
  view_name: postorder_tracking
  label: "Postorder Events"
  view_label: "Postorder Events"
  group_label: "10) In-app tracking data"
  description: "Postorder tracking events and orders data"

}
