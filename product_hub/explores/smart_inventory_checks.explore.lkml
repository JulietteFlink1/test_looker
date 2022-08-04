# Owner: Product Analytics, Flavia Alvarez

# Main Stakeholder:
# - Hub Tech
# - Hub Operations

# Questions that can be answered
# - Amount of checks performed by hubs
# - Time spent on checks
# - Amount of corrections

include: "/**/views/bigquery_curated/daily_smart_inventory_checks.view"
include: "/views/bigquery_tables/curated_layer/products.view"
include: "/**/global_filters_and_parameters.view.lkml"

explore: smart_inventory_checks {
  from:  daily_smart_inventory_checks
  view_name: smart_inventory_checks

  label: "Smart Inventory Checks"
  description: "This explore provides an overview of the backend events related to inventory checks and corrections."
  group_label: "Consumer Hub"

  access_filter: {
    field: smart_inventory_checks.country_iso
    user_attribute: country_iso
  }

  sql_always_where:{% condition global_filters_and_parameters.datasource_filter %} ${scheduled_date} {% endcondition %};;

  always_filter: {
    filters: [
      global_filters_and_parameters.datasource_filter: "last 7 days",
      smart_inventory_checks.country_iso: "",
      smart_inventory_checks.hub_code: ""
    ]
  }

  join: global_filters_and_parameters {
    sql_on: ${global_filters_and_parameters.generic_join_dim} = TRUE ;;
    type: left_outer
    relationship: many_to_one
  }

  join: products {
    sql_on: ${smart_inventory_checks.sku} = ${products.product_sku} ;;
    type: left_outer
    relationship: many_to_one
  }
}
