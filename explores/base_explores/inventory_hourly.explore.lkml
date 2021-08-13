
include: "/views/bigquery_tables/curated_layer/*.view"
include: "/views/extended_tables/order_lineitems_using_inventory.view"

explore: current_inventory_updated_hourly {
  from: products
  view_name: products

  persist_with: flink_hourly_datagroup
  hidden: yes

  access_filter: {
    field: hubs_ct.country_iso
    user_attribute: country_iso
  }

  access_filter: {
    field: hubs_ct.city
    user_attribute: city
  }

  always_filter: {
    filters:  [
      orders.is_internal_order: "no",
      orders.is_successful_order: "yes",
      orders.created_date: "after 2021-01-25",
      hubs_ct.country: "",
      hubs_ct.hub_name: ""
    ]
  }

  join: inventory {
    sql_on: ${inventory.sku} = ${products.product_sku} ;;
    relationship: one_to_many
    type: left_outer
    sql_where: (${inventory.is_most_recent_record} = TRUE) ;;
  }

  join: hubs_ct {
    sql_on: ${hubs_ct.hub_code} = ${inventory.hub_code} ;;
    relationship: many_to_one
    type:  left_outer
  }

  join: order_lineitems_using_inventory {
    sql_on: ${order_lineitems_using_inventory.product_sku} = ${inventory.sku}
        and ${order_lineitems_using_inventory.hub_code}    = ${inventory.hub_code}
    ;;
    relationship: many_to_many
    type: left_outer
  }

  join: orders {
    sql_on: ${orders.order_uuid} = ${order_lineitems_using_inventory.order_uuid}  ;;
    relationship: many_to_one
    type: left_outer
    fields: [orders.is_internal_order, orders.is_successful_order, created_date]
  }


}
