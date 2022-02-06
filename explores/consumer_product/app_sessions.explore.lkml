include: "/views/bigquery_tables/curated_layer/app_sessions.view.lkml"


explore: app_sessions {
  label: "Sessions App"
  view_label: "Sessions - App"
  group_label: "Consumer Product"
  description: "App sessions"
  always_filter: {
    filters:  [
      app_sessions.session_start_at_date: "last 7 days",
      app_sessions.country: "",
      app_sessions.device_type: ""
    ]
  }
  access_filter: {
    field: app_sessions.country_iso
    user_attribute: country_iso
  }
}
