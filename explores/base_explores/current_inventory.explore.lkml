
include: "/views/bigquery_tables/curated_layer/*.view"
include: "/views/extended_tables/order_lineitems_using_inventory.view"

include: "/**/global_filters_and_parameters.view.lkml"

explore: current_inventory {
  from: products
  view_name: products
  group_label: "02) Inventory"
  view_label: "* Product Information *"
  label: "Products & Inventory"
  description: "This explore provides information on all SKUs (published/unpublished), on the recent inventory stock levels as well as some order related metrics"

  hidden: no

  access_filter: {
    field: hubs.country_iso
    user_attribute: country_iso
  }

  access_filter: {
    field: hubs.city
    user_attribute: city
  }

  always_filter: {
    filters: [
      products_hub_assignment.is_sku_assigned_to_hub: "",
      hubs.is_hub_opened: "Yes",
      global_filters_and_parameters.datasource_filter: "last 30 days"
    ]
  }

  join: global_filters_and_parameters {
    sql_on: ${global_filters_and_parameters.generic_join_dim} = TRUE ;;
    type: left_outer
    relationship: many_to_one
  }

  join: products_hub_assignment {
    sql_on: ${products_hub_assignment.sku} = ${products.product_sku} ;;
    sql_where: ${products_hub_assignment.is_most_recent_record} = TRUE ;;
    type: left_outer
    relationship: one_to_many
  }

  join: hubs {
    from:  hubs_ct
    sql_on: ${hubs.hub_code} = ${products_hub_assignment.hub_code} ;;
    relationship: many_to_one
    type:  left_outer
  }


  join: inventory {
    sql_on: ${inventory.sku} = ${products_hub_assignment.sku}
        and ${inventory.hub_code} = ${products_hub_assignment.hub_code}
    ;;
    relationship: one_to_many
    type: left_outer
    sql_where: (${inventory.is_most_recent_record} = TRUE) ;;
  }



  join: order_lineitems {
    from:  order_lineitems_using_inventory
    sql_on: ${order_lineitems.product_sku} = ${products_hub_assignment.sku}
        and ${order_lineitems.hub_code}    = ${products_hub_assignment.hub_code}
        and {% condition global_filters_and_parameters.datasource_filter %} ${order_lineitems.created_date} {% endcondition %}
    ;;
    relationship: many_to_many
    type: left_outer

  }

  join: orders {
    sql_on: ${orders.order_uuid} = ${order_lineitems.order_uuid}
        and {% condition global_filters_and_parameters.datasource_filter %} ${orders.created_date} {% endcondition %}
    ;;
    relationship: many_to_one
    type: left_outer
    fields: [orders.is_internal_order, orders.is_successful_order, created_date]
  }


}
