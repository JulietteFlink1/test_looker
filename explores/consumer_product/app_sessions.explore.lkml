include: "/views/bigquery_tables/curated_layer/app_sessions.view.lkml"


explore: app_sessions {
  label: "App Sessions."
  view_label: "Sessions - App"
  group_label: "In-app tracking data"
  description: "App sessions"
  always_filter: {
    filters:  [
      app_sessions.session_start_at_date: "",
      app_sessions.country: "",
      app_sessions.device_type: "",
      app_sessions.is_new_user: ""
    ]
  }
  access_filter: {
    field: app_sessions.country_iso
    user_attribute: country_iso
  }
}
