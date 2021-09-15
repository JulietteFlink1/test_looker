include: "/views/**/*.view"
include: "/views/bigquery_tables/curated_layer/*.view"
include: "/views/bigquery_tables/reporting_layer/competitive_intelligence/gorillas_inventory_stock_count.view.lkml"

explore:  gorillas_prices {
  hidden: yes
  label: "Gorillas Prices"
  view_label: "* Gorillas Product Data *"
  view_name: gorillas_products
  group_label: "08) Competitive Intel"
  description: "Gorillas Pricing Data"

  join: gorillas_categories {
    from: gorillas_categories
    sql_on: ${gorillas_categories.hub_id} = ${gorillas_products.hub_id} AND ${gorillas_categories.product_id} = ${gorillas_products.product_id};;
    relationship: many_to_one
    type:  left_outer
  }

  join: gorillas_hubs {
    from:  gorillas_hubs
    sql_on: ${gorillas_hubs.hub_id} = ${gorillas_categories.hub_id} ;;
    relationship: many_to_one
    type:  left_outer
  }

  join: gorillas_historical_prices_fact {
    from: gorillas_historical_prices_fact
    view_label: "* Gorillas Historical Price Data *"
    sql_on: ${gorillas_products.product_id} = ${gorillas_historical_prices_fact.product_id} ;;
    relationship: one_to_many
    type: left_outer
  }

  join: de_gorillas_to_flink {
    from:  de_gorillas_to_flink
    view_label: "* Product Matches *"
    sql_on: ${gorillas_products.product_id} = ${de_gorillas_to_flink.gorillas_product_id};;
    relationship: many_to_one
    type:  left_outer
  }

  join: products {
    from:  products
    view_label: "* Flink Product Data *"
    sql_on: ${products.product_sku} = ${de_gorillas_to_flink.flink_product_sku};;
    relationship: one_to_many
    type: inner
  }

}
