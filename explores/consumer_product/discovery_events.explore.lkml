include: "/views/bigquery_tables/curated_layer/discovery_events.view.lkml"

explore: discovery_events {
  hidden: yes
  view_name: discovery_events
  label: "Discovery Events"
  view_label: "Discovery Events"
  group_label: "Consumer Product"
  description: "Discovery tracking events"
}
