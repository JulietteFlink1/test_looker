include: "/views/bigquery_tables/micro_forecasts_vs_actuals.view"
include: "/views/bigquery_tables/curated_layer/hubs_ct.view"

explore: micro_forecasts_vs_actuals {
  hidden: no
  label: "Order Forecasting Models"
  view_label: "Order Forecasting Models"
  group_label: "Rider Ops"


  join: hubs {
    from: hubs_ct
    sql_on:
    lower(${micro_forecasts_vs_actuals.hub_code}) = lower(${hubs.hub_code}) ;;
    relationship: many_to_one
    type: left_outer
  }

}
