include: "/views/bigquery_tables/reporting_layer/gorillas_daily_orders.view.lkml"

explore: gorillas_daily_orders {
  view_name: gorillas_daily_orders
  label: "Gorillas Orders"
  view_label: "Gorillas Orders"
  hidden: yes
  group_label: "8) Competitive Intelligence"
  description: "Gorillas Number of Orders per Hub, WoW figures"
}
