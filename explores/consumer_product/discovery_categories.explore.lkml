include: "/views/projects/consumer_product/discovery_categories.view.lkml"

explore: discovery_categories {
  hidden: no
  view_name:  discovery_categories
  label: "Categories - session aggregation"
  view_label: "Categories - session aggregation"
  group_label: "In-app tracking data"
  description: "Categories events on a sessions level"
  always_filter: {
    filters:  [
    discovery_categories.event_timestamp_date: "2021-10-04",
    discovery_categories.event_name: ""
  ]
}
}
