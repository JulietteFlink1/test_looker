include: "/**/hub_pl_monthly.view"
include: "/**/hubs_ct.view"
include: "/**/global_filters_and_parameters.view"

explore: hubs_pl_monthly {
  label: "Hubs P&Ls Monthly"
  view_name:  hub_pl_monthly
  view_label: "* Hubs P&Ls *"
  group_label: "Finance"
  hidden: yes

  required_access_grants: [can_access_pricing_margins]


  join: hubs {
    from: hubs_ct
    sql_on: ${hubs.hub_code} = ${hub_pl_monthly.hub_code};;
    type: left_outer
    relationship: many_to_one
  }

  join: global_filters_and_parameters {
    sql: ;;
    relationship: one_to_one
  }





}
