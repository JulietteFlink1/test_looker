include: "/views/**/*.view"
include: "/**/*.view"
include: "/**/*.explore"


explore: hubs_pl_monthly {
  label: "Hubs P&Ls Monthly"
  view_name:  hub_pl_monthly
  view_label: "* Hubs P&Ls *"
  group_label: "Finance"

  required_access_grants: [can_view_buying_information]


  join: hubs {
    from: hubs_ct
    sql_on: ${hubs.hub_code} = ${hub_pl_monthly.hub_code};;
    type: left_outer
    relationship: many_to_one

  }


  join: global_filters_and_parameters {
    sql_on: ${global_filters_and_parameters.generic_join_dim} = TRUE ;;
    type: left_outer
    relationship: many_to_one
  }





}
