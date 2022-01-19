include: "/views/bigquery_tables/curated_layer/app_sessions_dev.view.lkml"


explore: app_sessions_dev {
  hidden: yes
  label: "Sessions App"
  view_label: "Sessions - App"
  group_label: "Consumer Product"
  description: "App sessions"
  always_filter: {
    filters:  [
      app_sessions_dev.session_start_at_date: "last 7 days",
      app_sessions_dev.country: "",
      app_sessions_dev.device_type: "",
      app_sessions_dev.is_new_user: ""
    ]
  }
  access_filter: {
    field: app_sessions_dev.country_iso
    user_attribute: country_iso
  }
}
