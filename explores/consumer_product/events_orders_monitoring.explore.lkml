include: "/views/projects/consumer_product/events_orders_monitoring.view.lkml"

explore: events_order_monitoring {
  view_name: events_orders_monitoring
  label: "Events & Orders Monitoring"
  view_label: "Events & Orders Monitoring"
  group_label: "In-app tracking data"
  description: "Events and Orders monitoring per user"
  always_filter:  {
    filters: [
      events_orders_monitoring.iso_country: "",
      events_orders_monitoring.event_date: "14 days"
      ]
  }
}
