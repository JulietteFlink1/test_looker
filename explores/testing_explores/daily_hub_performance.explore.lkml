# Owner:
# Nazrin Guliyeva

# Questions that can be answered
# - Basic rider and order data for daily performance of hubs
# - Details of the each hub

include: "/views/bigquery_tables/flink-data-dev/sandbox_nazrin/daily_hub_performance.view"
include: "/views/bigquery_tables/curated_layer/hubs_ct.view"


explore: daily_hub_performance {
  group_label: "Hub Performance"
  view_label: "*Daily Hub Performance *"
  label: "Daily Hub Performance"
  description: "Hub Performance KPIs such as # worked hours,# riders, # orders etc ."

  join: hubs {
    from: hubs_ct
    type: left_outer
    relationship: many_to_one
    sql_on:
    lower(${daily_hub_performance.hub_code}) = lower(${hubs.hub_code}) ;;
  }

}
