
include: "/views/bigquery_tables/curated_layer/*.view"
include: "/views/extended_tables/order_lineitems_using_inventory.view"
include: "/**/price_test_tracking.view"
include: "/**/*.view"

include: "/**/global_filters_and_parameters.view.lkml"

explore: current_inventory {
  from: products
  view_name: products
  group_label: "Commercial"
  view_label: "* Product Information (CT) *"
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

    from: products_hub_assignment_v2

    sql_on: ${products_hub_assignment.sku} = ${products.product_sku}
       and ${products_hub_assignment.report_date} = current_date()
    ;;
    type: left_outer
    relationship: one_to_many
  }

  join: lexbizz_item {

    view_label: "* Product Information (ERP) *"

    type: left_outer
    relationship: one_to_one

    sql_on:
            ${products.product_sku} = ${lexbizz_item.sku}
        and ${lexbizz_item.ingestion_date} = current_date()
    ;;
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

  join: price_test_tracking {
    sql_on:  ${products.product_sku} = ${price_test_tracking.product_sku};;
    relationship: many_to_one
    type:  left_outer
  }

  join: unique_assortment {
    sql_on: ${products.product_sku} = ${unique_assortment.product_sku} ;;
    relationship: many_to_one
    type: left_outer
  }

  join: key_value_items {
    sql_on: ${products.product_sku} = ${key_value_items.sku} ;;
    relationship: many_to_one
    type: left_outer
  }

  # join: erp_product_hub_vendor_assignment {
  #   sql_on:  ${erp_product_hub_vendor_assignment.country_iso}    = ${products_hub_assignment.country_iso}
  #       and ${erp_product_hub_vendor_assignment.sku}            = ${products_hub_assignment.sku}
  #       and ${erp_product_hub_vendor_assignment.hub_code}       = ${products_hub_assignment.hub_code}
  #       -- get the status from the last data pull
  #       and ${erp_product_hub_vendor_assignment.ingestion_date} = date_sub(current_date(), interval 1 day)
  #   ;;
  #   type: left_outer
  #   relationship: one_to_many
  # }


}
