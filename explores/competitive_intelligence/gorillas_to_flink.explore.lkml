include: "/views/**/*.view"
include: "/views/bigquery_tables/curated_layer/*.view"
include: "/views/bigquery_tables/reporting_layer/competitive_intelligence/gorillas_inventory_stock_count.view.lkml"

explore:  gorillas_to_flink {
  hidden: yes
  view_name: gorillas_inventory_stock_count
  label: "Gorillas Sales"
  view_label: "Gorillas Product Data"
  group_label: "08) Competitive Intel"
  description: "Gorillas assortment & sales matched to Flink's assortment and sales"

  join: de_gorillas_to_flink {
    from:  de_gorillas_to_flink
    view_label: "* Product Matches *"
    sql_on: ${gorillas_inventory_stock_count.product_id} = ${de_gorillas_to_flink.gorillas_product_id};;
    relationship: one_to_many
    type:  inner
  }

  join: products {
    from:  products
    view_label: "* Flink Product Data *"
    sql_on: ${products.product_sku} = ${de_gorillas_to_flink.flink_product_sku};;
    relationship: one_to_many
    type: inner
  }

  # join: inventory {
  #   sql_on: ${inventory.sku} = ${products.product_sku} ;;
  #   relationship: one_to_many
  #   type: left_outer
  #   sql_where: (${inventory.is_most_recent_record} = TRUE) ;;
  # }

  # # join: hubs {
  #   from:  hubs_ct
  #   sql_on: ${hubs.hub_code} = ${inventory.hub_code} ;;
  #   relationship: many_to_one
  #   type:  left_outer
  # }

  # join: order_lineitems {
  #   from:  order_lineitems_using_inventory
  #   sql_on: ${order_lineitems.product_sku} = ${inventory.sku}
  #       and ${order_lineitems.hub_code}    = ${inventory.hub_code}
  #   ;;
  #   relationship: many_to_many
  #   type: left_outer
  # }

  # join: orders {
  #   sql_on: ${orders.order_uuid} = ${order_lineitems.order_uuid}  ;;
  #   relationship: many_to_one
  #   type: left_outer
  #   fields: [orders.is_internal_order, orders.is_successful_order, created_date]
  # }

}
