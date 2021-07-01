include: "/tracking/events_orders_monitoring.view.lkml"

explore: events_order_monitoring {
  view_name: events_orders_monitoring
  label: "Events & Orders Monitoring"
  view_label: "Events & Orders Monitoring"
  group_label: "10) In-app tracking data"
  description: "Events and Orders monitoring per user"
  always_filter:  {
    filters: [
      iso_country: "",
      events_orders_monitoring.event_date: "14 days"
      ]
  }
}
