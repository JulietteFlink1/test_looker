include: "/views/bigquery_tables/reporting_layer/competitive_intelligence/gorillas_daily_orders.view.lkml"
include: "/explores/competitive_intelligence/comp_intel_hub_mapping.explore.lkml"
include: "/explores/base_explores/orders_cl.explore.lkml"

explore: gorillas_daily_orders {
  view_name: gorillas_daily_orders
  label: "Gorillas Orders"
  view_label: "Gorillas Orders"
  hidden: yes
  group_label: "8) Competitive Intelligence"
  description: "Gorillas Number of Orders per Hub, WoW figures"

  join: comp_intel_hub_mapping {
    from:  comp_intel_hub_mapping
    view_label: "* Hub Mapping *"
    sql_on: ${gorillas_daily_orders.hub_id} = ${comp_intel_hub_mapping.gorillas_hub_id};;
    relationship: one_to_many
    type:  left_outer
  }

  join: orders{
    from:  orders
    view_label: "* Flink Orders *"
    sql_on: ${comp_intel_hub_mapping.flink_hub_id} = ${orders.hub_code} and ${gorillas_daily_orders.order_date} = ${orders.date};;
    relationship: one_to_many
    type:  left_outer
    fields: [orders.hub_code, orders.date, orders.date_granularity ,orders.cnt_orders]
  }
}
