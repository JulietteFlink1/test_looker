include: "/**/gorillas_inventory_stock_count.view"
include: "/**/gorillas_to_flink_global.view"
include: "/**/products.view"
include: "/**/gorillas_products.view"

explore:  gorillas_to_flink_global {
  view_name: gorillas_inventory_stock_count
  label: "Gorillas Assortment Matched"
  view_label: "Gorillas Stock Data"
  group_label: "08) Competitive Intel"
  description: "Gorillas assortment & sales matched to Flink's assortment and sales"

  hidden: yes

  join: gorillas_to_flink_global {
    from:  gorillas_to_flink_global
    view_label: "* Product Matches *"
    sql_on: ${gorillas_inventory_stock_count.product_id} = ${gorillas_to_flink_global.gorillas_product_id};;
    relationship: one_to_many
    type:  left_outer
  }

  join: products {
    from:  products
    view_label: "* Flink Product Data *"
    sql_on: ${products.product_sku} = ${gorillas_to_flink_global.flink_product_sku};;
    relationship: one_to_many
    type: inner
  }

  join: gorillas_products {
    from: gorillas_products
    view_label: "* Gorillas Product Data *"
    sql_on: ${gorillas_products.product_id} = ${gorillas_inventory_stock_count.product_id} ;;
    relationship: one_to_many
    type: left_outer
  }

}
