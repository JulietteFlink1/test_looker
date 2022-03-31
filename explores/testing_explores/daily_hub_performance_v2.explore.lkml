# Owner:
# Nazrin Guliyeva

# Questions that can be answered
# - Basic rider and order data for daily performance of hubs
# - Details of the each hub

include: "/views/bigquery_tables/flink-data-dev/sandbox_nazrin/daily_hub_performance_v2.view"
include: "/views/bigquery_tables/curated_layer/hubs_ct.view"
include: "/views/bigquery_tables/flink-data-dev/sandbox_nazrin/derived_table.view"

explore: daily_hub_performance_v2 {
  group_label: "Hub Performance V2"
  view_label: "*Daily Hub Performance *"
  label: "Daily Hub Performance V2"
  description: "Hub Performance KPIs such as # worked hours,# riders, # orders etc ."
  hidden: yes


  join: hubs {
    from: hubs_ct
    type: left_outer
    relationship: many_to_one
    sql_on:
    lower(${daily_hub_performance_v2.hub_code}) = lower(${hubs.hub_code}) ;;
  }

  join: derived_table {
    from: derived_table
    type: left_outer
    relationship: one_to_one
    sql_on:
    lower(${derived_table.hub_name}) = lower(${hubs.hub_name}) and ${derived_table.order_date}=${daily_hub_performance_v2.order_date} ;;
  }

}
