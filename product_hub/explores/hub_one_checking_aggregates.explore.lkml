# Owner: Product Analytics, Flavia Alvarez

# Main Stakeholder:
# - Hub Tech
# - Hub Operations

# Questions that can be answered
# - Amount of checks performed by hubs
# - Time spent on checks
# - Amount of corrections

include: "/**/stock_checks_acum.view"
include: "/**/hubs_ct.view.lkml"
include: "/**/global_filters_and_parameters.view.lkml"

explore: hub_one_checking_aggregates {
  from:  stock_checks_acum
  view_name: stock_checks_acum

  label: "Hub One Checking Aggregates"
  description: "This explore combines information from the hub task backend and inventory checks events coming from hub one frontend. "
  group_label: "Product - Hub Tech"

  access_filter: {
    field: stock_checks_acum.country_iso
    user_attribute: country_iso
  }

  sql_always_where:{% condition global_filters_and_parameters.datasource_filter %} DATE(${created_at}) {% endcondition %};;

  always_filter: {
    filters: [
      global_filters_and_parameters.datasource_filter: "last 7 days",
      stock_checks_acum.country_iso: "",
      stock_checks_acum.hub_code: ""
    ]
  }

  join: global_filters_and_parameters {
    sql: ;;
  relationship: one_to_one
}


join: hubs_ct {
  view_label: "3 Hub Dimensions"
  sql_on: ${stock_checks_acum.hub_code} = ${hubs_ct.hub_code} ;;
  type: left_outer
  relationship: many_to_one
}

}
