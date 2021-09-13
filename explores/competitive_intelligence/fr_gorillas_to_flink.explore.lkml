include: "/views/**/*.view"
include: "/views/bigquery_tables/curated_layer/*.view"
include: "/views/bigquery_tables/reporting_layer/competitive_intelligence/gorillas_inventory_stock_count.view.lkml"

explore:  fr_gorillas_to_flink {
  hidden: yes
  view_name: gorillas_inventory_stock_count
  label: "Gorillas FR Sales"
  view_label: "Gorillas FR Product Data"
  group_label: "08) Competitive Intel"
  description: "Gorillas FR assortment & sales matched to Flink's assortment and sales"

  join: fr_gorillas_to_flink {
    from:  fr_gorillas_to_flink
    view_label: "* Product Matches *"
    sql_on: ${gorillas_inventory_stock_count.product_id} = ${fr_gorillas_to_flink.gorillas_product_id};;
    relationship: one_to_many
    type:  inner
  }

  join: products {
    from:  products
    view_label: "* Flink Product Data *"
    sql_on: ${products.product_sku} = ${fr_gorillas_to_flink.flink_product_sku};;
    relationship: one_to_many
    type: inner
  }

}
