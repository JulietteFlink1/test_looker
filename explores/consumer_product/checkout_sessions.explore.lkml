include: "/views/projects/consumer_product/checkout_sessions.view.lkml"

explore: checkout_sessions {
  hidden: yes
  view_name: checkout_sessions
  label: "Checkout Sessions"
  view_label: "Checkout Sessions"
  group_label: "Consumer Product"
  description: "Checkout tracking events in sessions format"
}
