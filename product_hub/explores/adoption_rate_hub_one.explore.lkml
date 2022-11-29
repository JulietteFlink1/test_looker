# Owner: Product Analytics, Flavia Alvarez

# Main Stakeholder:
# - Hub Tech
# - Hub Operations

# Questions that can be answered
# - Adoption Rate of Hub One flows

include: "/**/global_filters_and_parameters.view.lkml"
include: "/**/hubs_ct.view.lkml"
include: "/**/adoption_rate_hub_one.view"


explore: adoption_rate_hub_one {
  from:  adoption_rate_hub_one
  view_name: adoption_rate_hub_one

  label: "Adoption Rate Hub One"
  description: "This explore provides the adoption rate of hub one against backend and the other frontend apps."
  group_label: "Product - Hub Tech"

  access_filter: {
    field: adoption_rate_hub_one.country_iso
    user_attribute: country_iso
  }

  sql_always_where:{% condition global_filters_and_parameters.datasource_filter %} ${event_date} {% endcondition %};;

  always_filter: {
    filters: [
      global_filters_and_parameters.datasource_filter: "last 7 days",
      adoption_rate_hub_one.country_iso: "",
      adoption_rate_hub_one.hub_code: ""
    ]
  }

  join: global_filters_and_parameters {
    sql: ;;
  relationship: one_to_one
}

join: hubs_ct {
  view_label: "Hub Dimensions"
  sql_on: ${adoption_rate_hub_one.hub_code} = ${hubs_ct.hub_code} ;;
  type: left_outer
  relationship: many_to_one
}

}
