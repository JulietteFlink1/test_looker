include: "/views/projects/consumer_product/order_placed_events.view.lkml"

explore: order_placed {
  hidden: yes
  view_name:  order_placed_events
  label: "Orders Placed With Payment Method "
  view_label: "Orders Placed with payment Method"
  group_label: "Consumer Product"
  description: "Orders Placed with Payment Method granularity"
}
