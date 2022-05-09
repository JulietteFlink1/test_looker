include: "/views/projects/consumer_product/monitoring_metrics.view.lkml"

explore: monitoring_metrics {
  hidden: yes
  label: "(Internal Use Only) Monitoring Events"
  view_label: "Monitoring Events"
  group_label: "Consumer Product"
  description: "Monitoring behavioural metrics for tracking events"
  always_filter: {
    filters: [
    monitoring_metrics.filter_event_date: "last 7 days"
    ]
  }
}
