include: "/**/micro_no_show_forecast_vs_actuals.view"
include: "/**/hubs_ct.view"

explore: micro_no_show_forecast_vs_actuals {
  hidden: no
  label: "No-show forecast error"
  view_label: "* No-show forecast error *"
  group_label: "Rider Ops"


  join: hubs {
    from: hubs_ct
    sql_on:
    lower(${micro_no_show_forecast_vs_actuals.hub_code}) = lower(${hubs.hub_code}) ;;
    relationship: many_to_one
    type: left_outer
  }

}
