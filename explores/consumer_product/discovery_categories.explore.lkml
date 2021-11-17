include: "/views/projects/consumer_product/discovery_categories.view.lkml"

explore: discovery_categories {
  hidden: yes
  view_name:  discovery_categories
  label: "Categories - session aggregation"
  view_label: "Categories - session aggregation"
  group_label: "Consumer Product"
  description: "Categories events on a sessions level"
  always_filter: {
    filters:  [
    discovery_categories.event_timestamp_date: "last 7 days",
    discovery_categories.event_name: ""
  ]
}
}
