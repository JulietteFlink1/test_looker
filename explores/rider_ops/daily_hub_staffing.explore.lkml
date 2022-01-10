include: "/views/bigquery_tables/reporting_layer/rider_ops/daily_hub_staffing.view.lkml"
include: "/views/bigquery_tables/curated_layer/hubs_ct.view"

explore: daily_hub_staffing {
  group_label: "Rider Ops"
  label: "Daily Hub Staffing"
  description: "Hub Staffing KPIs such as # worked hours,# planned hours, # no_show etc ."
  hidden: no


  join: hubs {
    from: hubs_ct
    sql_on:
    lower(${daily_hub_staffing.hub_code}) = lower(${hubs.hub_code}) ;;
    relationship: many_to_one
    type: left_outer
  }

}
