include: "/views/projects/consumer_product/checkout_sessions.view.lkml"

explore: checkout_sessions {
  view_name: checkout_sessions
  label: "Checkout Sessions"
  view_label: "Checkout Sessions"
  group_label: "In-app tracking data"
  description: "Checkout tracking events in sessions format"
}
