include: "/views/sql_derived_tables/order_forecasting_models.view"
include: "/views/bigquery_tables/curated_layer/hubs_ct.view"

explore: order_forecasting_models {
  hidden: no
  label: "Order Forecasting Models"
  view_label: "Order Forecasting Models"
  group_label: "Rider Ops"


  join: hubs {
    from: hubs_ct
    sql_on:
    lower(${order_forecasting_models.hub_code}) = lower(${hubs.hub_code}) ;;
    relationship: many_to_one
    type: left_outer
  }

}
