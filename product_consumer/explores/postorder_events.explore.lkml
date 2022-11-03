include: "/product_consumer/views/sql_derived_tables/postorder_events.view.lkml"

explore: postorder_events {
  view_name: postorder_events
  label: "Postorder Events"
  view_label: "Postorder Events"
  group_label: "Consumer Product"
  description: "Postorder events"
  hidden: yes
}
