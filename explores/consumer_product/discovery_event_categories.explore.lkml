include: "/views/projects/consumer_product/discovery_event_categories.view.lkml"

explore: discovery_event_categories {
  hidden: yes
  view_name:  discovery_event_categories
  label: "Categories Selection"
  view_label: "Categories Selection"
  group_label: "Consumer Product"
  description: "Sub/Categories selection in the app"
  always_filter: {
    filters:  [
      discovery_event_categories.filter_event_date: "last 7 days",
      discovery_event_categories.country_iso: ""
    ]
  }
}
