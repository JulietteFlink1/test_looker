include: "/views/projects/consumer_product/delivery_time_sessions.view.lkml"

explore: delivery_time_sessions {
  view_name: delivery_time_sessions
  label: "Delivery Time Sessions"
  view_label: "Delivery Time Sessions"
  group_label: "Consumer Product"
  description: "Delivery time (home and address confirmed) tracking events in sessions format"
  hidden: yes
}
