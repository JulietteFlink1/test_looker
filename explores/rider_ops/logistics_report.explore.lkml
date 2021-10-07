include: "/views/bigquery_tables/curated_layer/orders.view.lkml"
include: "/views/bigquery_tables/reporting_layer/core/hub_level_kpis.view.lkml"
include: "/explores/base_explores/orders_cl.explore.lkml"


explore: logistics_report {
  extends: [orders_cl]
  group_label: "Rider Ops"
  label: "Logistics Report"
  description: "Orderline Items sold quantities, prices, gmv, etc."
  hidden: no


  join: hub_level_kpis {
    view_label: "* Hub Level KPIs*"
    sql_on: lower(${orders_cl.hub_code}) = ${hub_level_kpis.hub_code}
    and ${hub_level_kpis.order_date} = ${orders_cl.order_date};;
    relationship: many_to_one
    type: left_outer
  }
  }
