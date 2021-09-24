
include: "/views/bigquery_tables/curated_layer/*.view"
include: "/views/extended_tables/order_lineitems_using_inventory.view"

explore: current_inventory {
  from: products
  view_name: products
  group_label: "02) Inventory"
  view_label: "* Product Information *"
  label: "Products & Inventory"

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
      products_hub_assignment.is_sku_assigned_to_hub: "Yes",
      hubs.is_hub_opened: "Yes"
    ]
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
    ;;
    relationship: many_to_many
    type: left_outer

  }

  join: orders {
    sql_on: ${orders.order_uuid} = ${order_lineitems.order_uuid}  ;;
    relationship: many_to_one
    type: left_outer
    fields: [orders.is_internal_order, orders.is_successful_order, created_date]
  }


}
