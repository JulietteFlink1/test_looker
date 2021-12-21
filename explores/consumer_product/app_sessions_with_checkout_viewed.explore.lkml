include: "/views/bigquery_tables/curated_layer/app_sessions_with_checkout_viewed.view.lkml"


explore: app_sessions_with_checkout_viewed {
  hidden: yes
  label: "Sessions App with Checkout Viewed"
  view_label: "Sessions - App with Checkout Viewed"
  group_label: "Consumer Product"
  description: "App sessions with Checkout Viewed"
  always_filter: {
    filters:  [
      app_sessions_with_checkout_viewed.session_start_at_date: "last 7 days",
      app_sessions_with_checkout_viewed.country: "",
      app_sessions_with_checkout_viewed.device_type: "",
      app_sessions_with_checkout_viewed.is_new_user: ""
    ]
  }
  access_filter: {
    field: app_sessions_with_checkout_viewed.country_iso
    user_attribute: country_iso
  }
}
