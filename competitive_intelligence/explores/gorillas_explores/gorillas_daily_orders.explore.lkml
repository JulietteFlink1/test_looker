include: "/competitive_intelligence/views/bigquery_reporting/gorillas_daily_orders.view.lkml"
include: "/explores/base_explores/orders_cl.explore.lkml"

explore: gorillas_daily_orders {
  view_name: gorillas_daily_orders
  label: "* Gorillas Orders *"
  view_label: "* Gorillas Orders *"
  hidden: yes
  group_label: "8) Competitive Intelligence"
  description: "Gorillas Number of Orders per Hub, WoW figures"

  join: comp_intel_hub_mapping {
    from:  comp_intel_hub_mapping
    view_label: "* Hub Mapping *"
    sql_on: ${gorillas_daily_orders.hub_id} = ${comp_intel_hub_mapping.gorillas_hub_id};;
    relationship: one_to_one
    type: inner
  }

  join: comp_intel_city_matching {
    from: comp_intel_city_matching
    view_label: "* City Mapping *"
    sql_on: ${gorillas_daily_orders.city} = ${comp_intel_city_matching.gorillas_city_name};;
    relationship: one_to_one
    type: inner
  }


  join: orders{
    from:  orders
    view_label: "* Flink Orders *"
    sql_on: ${comp_intel_hub_mapping.flink_hub_id} = ${orders.hub_code} and ${gorillas_daily_orders.order_date} = ${orders.date};;
    relationship: one_to_many
    type:  left_outer
    fields: [orders.hub_code, orders.date, orders.date_granularity ,orders.cnt_orders]
  }

  join: hubs {
    from: hubs_ct
    view_label: "* Flink Hub Information *"
    sql_on: ${comp_intel_hub_mapping.flink_hub_id} = ${hubs.hub_code} ;;
    type: left_outer
    relationship: many_to_one
  }


}
