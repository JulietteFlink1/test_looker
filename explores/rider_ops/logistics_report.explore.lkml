include: "/views/bigquery_tables/curated_layer/orders.view.lkml"
include: "/views/bigquery_tables/reporting_layer/core/hub_level_kpis.view.lkml"
include: "/explores/base_explores/orders_cl.explore.lkml"

explore: logistics_report {
  extends: [orders_cl]
  group_label: "Rider Ops"
  label: "Logistics Report"
  description: "operational performance KPIs in a hub level such as AVG rider UTR, AVG delivery time, %late order, % no_show,  etc."
  hidden: no

}
