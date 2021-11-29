include: "/views/bigquery_tables/curated_layer/web_sessions.view.lkml"


explore: web_sessions {
  label: "Sessions Web"
  view_label: "Sessions - Web"
  group_label: "Consumer Product"
  description: "Web sessions"
  always_filter: {
    filters:  [
      web_sessions.session_start_at_date: "last 7 days",
      web_sessions.country: "",
      web_sessions.device_type: "",
      web_sessions.is_new_user: ""
    ]
  }
  access_filter: {
    field: web_sessions.country_iso
    user_attribute: country_iso
  }
}
