# Owner: Product Analytics, Flavia Alvarez

# Main Stakeholder:
# - Hub Tech
# - Hub Operations

# Questions that can be answered
# - Amount of checks performed by hubs
# - Time spent on checks
# - Amount of corrections

include: "/**/hub_one_inventory_checking.view"
include: "/**/products.view"
include: "/**/hubs_ct.view.lkml"
include: "/**/global_filters_and_parameters.view.lkml"

explore: hub_one_inventory_checking {
  from:  hub_one_inventory_checking
  view_name: hub_one_inventory_checking

  label: "Hub One Inventory Checking"
  description: "This explore combines information from the hub task backend and inventory checks events coming from hub one frontend. "
  group_label: "Product - Hub Tech"

  access_filter: {
    field: hub_one_inventory_checking.country_iso
    user_attribute: country_iso
  }

  sql_always_where:{% condition global_filters_and_parameters.datasource_filter %} ${created_at_timestamp_date} {% endcondition %};;

  always_filter: {
    filters: [
      global_filters_and_parameters.datasource_filter: "last 7 days",
      hub_one_inventory_checking.country_iso: "",
      hub_one_inventory_checking.hub_code: ""
    ]
  }

  join: global_filters_and_parameters {
    sql: ;;
  relationship: one_to_one
}

join: products {
  view_label: "2 Product Dimensions"
  sql_on:
        ${hub_one_inventory_checking.product_sku} = ${products.product_sku} and
        ${hub_one_inventory_checking.country_iso} = ${products.country_iso}
        ;;
  type: left_outer
  relationship: many_to_one
}

join: hubs_ct {
  view_label: "3 Hub Dimensions"
  sql_on: ${hub_one_inventory_checking.hub_code} = ${hubs_ct.hub_code} ;;
  type: left_outer
  relationship: many_to_one
}

}
