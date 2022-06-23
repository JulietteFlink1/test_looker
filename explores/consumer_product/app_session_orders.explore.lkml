include: "/views/bigquery_tables/curated_layer/app_session_orders.view.lkml"


explore: app_session_orders {
  hidden: yes
  label: "App Session Orders"
  view_label: "App Orders - Sessions"
  group_label: "Consumer Product"
  description: "App orders per session"
  always_filter: {
    filters:  [
      app_session_orders.order_at_date: "last 7 days",
      app_session_orders.country_iso: ""
    ]
  }
}
