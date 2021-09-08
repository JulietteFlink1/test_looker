include: "/views/**/*.view"
include: "/views/bigquery_tables/curated_layer/*.view"
include: "/views/bigquery_tables/reporting_layer/competitive_intelligence/gorillas_inventory_stock_count.view.lkml"

explore:  nl_gorillas_to_flink {
  hidden: yes
  view_name: gorillas_inventory_stock_count
  label: "Gorillas NL Sales"
  view_label: "Gorillas NL Product Data"
  group_label: "08) Competitive Intel"
  description: "Gorillas NL assortment & sales matched to Flink's assortment and sales"

  join: nl_gorillas_to_flink {
    from:  de_gorillas_to_flink
    view_label: "* Product Matches *"
    sql_on: ${gorillas_inventory_stock_count.product_id} = ${nl_gorillas_to_flink.gorillas_product_id};;
    relationship: one_to_many
    type:  inner
  }

  join: products {
    from:  products
    view_label: "* Flink Product Data *"
    sql_on: ${products.product_sku} = ${nl_gorillas_to_flink.flink_product_sku};;
    relationship: one_to_many
    type: inner
  }

}
