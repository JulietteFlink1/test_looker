include: "/views/sql_derived_tables/hub_closure_rate.view.lkml"
include: "/views/bigquery_tables/curated_layer/hubs_ct.view.lkml"


explore: hub_closure {
  view_name: hub_closure_rate
   hidden:  yes
  label: "Hub Closure"
  view_label: "Hub Closure"

join: hubs_ct {
  view_label: "Hubs"
  sql_on: ${hubs_ct.hub_code}=${hub_closure_rate.hub_code};;
  type: left_outer
  relationship: many_to_one
}
}
