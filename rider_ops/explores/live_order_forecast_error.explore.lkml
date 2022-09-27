include: "/**/micro_forecasts_vs_actuals.view"
include: "/**/hubs_ct.view"

explore: micro_forecasts_vs_actuals {
  hidden: no
  label: "Live Order Forecast Error"
  view_label: "* Live Order Forecast Error *"
  group_label: "Rider Ops"


  join: hubs {
    from: hubs_ct
    sql_on:
    lower(${micro_forecasts_vs_actuals.hub_code}) = lower(${hubs.hub_code}) ;;
    relationship: many_to_one
    type: left_outer
  }

}
