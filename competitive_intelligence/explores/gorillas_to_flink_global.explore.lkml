include: "/competitive_intelligence/views/bigquery_comp_intel/gorillas_to_flink_global.view.lkml"
include: "/competitive_intelligence/views/bigquery_curated/gorillas_products.view.lkml"
include: "/competitive_intelligence/views/bigquery_reporting/gorillas_inventory_stock_count.view.lkml"
include: "/**/products.view"


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
    sql_on: ${gorillas_inventory_stock_count.product_id} = ${gorillas_to_flink_global.gorillas_product_id}
      and ${gorillas_inventory_stock_count.country_iso} = ${gorillas_to_flink_global.country_iso};;
    relationship: one_to_many
    type:  left_outer
  }

  join: products {
    from:  products
    view_label: "* Flink Product Data *"
    sql_on: ${products.product_sku} = ${gorillas_to_flink_global.flink_product_sku}
      and ${products.country_iso} = ${gorillas_to_flink_global.country_iso};;
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
