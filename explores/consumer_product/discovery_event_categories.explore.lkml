include: "/views/projects/consumer_product/discovery_event_categories.view.lkml"

explore: discovery_event_categories {
  hidden: no
  view_name:  discovery_event_categories
  label: "Categories - session aggregation"
  view_label: "Categories - session aggregation"
  group_label: "Consumer Product"
  description: "Categories events on a sessions level"
  always_filter: {
    filters:  [
      discovery_event_categories.filter_event_date: "last 7 days",
      discovery_event_categories.country_iso: ""
    ]
  }
}
