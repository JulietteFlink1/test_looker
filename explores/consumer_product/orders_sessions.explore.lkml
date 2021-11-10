include: "/views/projects/consumer_product/order_placed_events.view.lkml"

explore: order_placed {
  hidden: no
  view_name:  order_placed_events
  label: "Orders Placed "
  view_label: "Orders Placed with payment Method"
  group_label: "In-app tracking data"
  description: "Orders Placed with Payment Method granularity"
}
