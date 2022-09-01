include: "/**/daily_hub_staffing.view.lkml"
include: "/**/hubs_ct.view"

explore: daily_hub_staffing {
  group_label: "Rider Ops"
  view_label: "*Daily Hub Staffing *"
  label: "Daily Hub Staffing"
  description: "Hub Staffing KPIs such as # worked hours,# planned hours, # no_show etc ."
  hidden: yes



  always_filter: {
    filters:  [
      daily_hub_staffing.shift_date: "last 7 days",
      hubs.country: "",
      hubs.hub_name: ""
    ]
  }

  join: hubs {
    from: hubs_ct
    sql_on:
    lower(${daily_hub_staffing.hub_code}) = lower(${hubs.hub_code}) ;;
    relationship: many_to_one
    type: left_outer
  }

}
