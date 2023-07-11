
include: "/**/order_lineitems_using_inventory.view"
include: "/**/price_test_tracking.view"
include: "/**/*.view"
include: "/**/shipping_methods_ct.view"

include: "/**/global_filters_and_parameters.view.lkml"

explore: current_inventory {
  from: products
  view_name: products
  group_label: "Commercial"
  view_label: "Product Data (as of today)"
  label: "Products & Inventory"
  description: "This explore provides information on all SKUs (published/unpublished), on the recent inventory stock levels as well as some order related metrics"

  hidden: no

  access_filter: {
    field: hubs.country_iso
    user_attribute: country_iso
  }


  always_filter: {
    filters: [
      products_hub_assignment.is_sku_assigned_to_hub: "",
      hubs.is_active_hub: "Yes",
      global_filters_and_parameters.datasource_filter: "last 7 days"
    ]
  }

  join: global_filters_and_parameters {
    sql: ;;
    relationship: one_to_one
  }

  join: products_hub_assignment {
    view_label: "Products Hub Assignment (as of today)"
    from: products_hub_assignment

    sql_on: ${products_hub_assignment.sku} = ${products.product_sku}
      and ${products_hub_assignment.country_iso} = ${products.country_iso}
      and ${products_hub_assignment.report_date} = current_date()
    ;;
    type: left_outer
    relationship: one_to_many
  }

  join: lexbizz_item {

    # HIDDEN
    view_label: ""
    from: erp_item

    type: left_outer
    relationship: one_to_one

    sql_on:
              ${products.product_sku} = ${lexbizz_item.sku}
          and ${lexbizz_item.ingestion_date} = current_date()
      ;;
  }

  join: erp_product_hub_vendor_assignment_unfiltered {
    view_label: "Product-Hub Data (as of today)"
    relationship: one_to_one
    type: left_outer
    sql_on:
          ${erp_product_hub_vendor_assignment_unfiltered.hub_code}  = ${products_hub_assignment.hub_code}
      and ${erp_product_hub_vendor_assignment_unfiltered.sku}       = ${products_hub_assignment.sku}
      and ${erp_product_hub_vendor_assignment_unfiltered.report_date} = current_date()
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
    fields: [orders.is_successful_order, created_date]
  }

  join: product_prices_daily {
    relationship: one_to_one
    type: left_outer
    sql_on: ${product_prices_daily.sku}      = ${products_hub_assignment.sku}
          and ${product_prices_daily.hub_code} = ${products_hub_assignment.hub_code}
          and ${product_prices_daily.reporting_date} = current_date()
          ;;
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
    sql_on: ${products.product_sku} = ${key_value_items.sku}
       -- get only the most recent KVIs (they are upadted every Monday)
         and ${key_value_items.kvi_date} >= current_date() - 6;;
    relationship: many_to_one
    type: left_outer
  }

  join: shipping_methods_ct {

    view_label: "Shipping Methods"

    type: left_outer
    relationship: one_to_many
    sql_on:
            ${hubs.shipping_method_id} = ${shipping_methods_ct.shipping_method_id}
        and ${hubs.country_iso}        = ${shipping_methods_ct.country_iso};;
  }

}
