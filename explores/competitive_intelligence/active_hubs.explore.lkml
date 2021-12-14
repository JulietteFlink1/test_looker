include: "/views/bigquery_tables/reporting_layer/competitive_intelligence/gorillas_daily_orders.view.lkml"
include: "/explores/competitive_intelligence/comp_intel_hub_mapping.explore.lkml"
include: "/explores/base_explores/orders_cl.explore.lkml"

explore: competitive_intelligence_active_hubs {
  view_name: competitive_intelligence_active_hubs
  label: "* Active Hubs *"
  view_label: "* Active Hubs *"
  hidden: yes
  group_label: "8) Competitive Intelligence"
  description: "Active Hubs of all providers"



}
