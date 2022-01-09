include: "/views/bigquery_tables/reporting_layer/rider_ops/hub_staffing.view.lkml"
include: "/views/bigquery_tables/curated_layer/hubs_ct.view"

explore: hub_staffing {
  group_label: "Rider Ops"
  label: "Hub Staffing"
  description: "Hub Staffing KPIs such as # worked hours,# planned hours, # no_show etc ."
  hidden: no


  join: hubs {
    from: hubs_ct
    sql_on:
    lower(${hub_staffing.hub_code}) = lower(${hubs.hub_code}) ;;
    relationship: many_to_one
    type: left_outer
  }

}
