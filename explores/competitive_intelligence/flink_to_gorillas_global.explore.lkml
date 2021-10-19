include: "/views/**/*.view"
include: "/views/bigquery_tables/curated_layer/*.view"
include: "/views/bigquery_tables/reporting_layer/competitive_intelligence/*.view"
include: "/views/bigquery_tables/reporting_layer/competitive_intelligence/gorillas_inventory_stock_count.view.lkml"

explore: flink_to_gorillas_global {
  from: products
  view_name: products
  group_label: "08) Competitive Intel"
  view_label: "* Flink Product Matches *"
  label: "Flink Assortment Matched"
  description: "Flink assortment matched to Gorillas assortment"

  hidden: yes

  join: inventory {
    sql_on: ${inventory.sku} = ${products.product_sku} ;;
    relationship: one_to_many
    type: left_outer
    sql_where: (${inventory.is_most_recent_record} = TRUE) ;;
  }

  join: hubs {
    from:  hubs_ct
    sql_on: ${hubs.hub_code} = ${inventory.hub_code} ;;
    relationship: many_to_one
    type:  left_outer
  }

  join: flink_to_gorillas_global {
    from: flink_to_gorillas_global
    view_label: "* Product Match Data *"
    sql_on: ${flink_to_gorillas_global.flink_product_sku} = ${products.product_sku} ;;
    relationship: one_to_many
    type: left_outer
  }

  join: gorillas_products {
    from:  gorillas_products
    view_label: "* Gorillas Product Data *"
    sql_on: ${gorillas_products.product_id} = ${flink_to_gorillas_global.gorillas_product_id};;
    relationship: one_to_one
    type: left_outer
  }

  join: gorillas_historical_prices_fact {
    from: gorillas_historical_prices_fact
    view_label: "* Gorillas Historical Price Data *"
    sql_on: ${gorillas_products.product_id} = ${gorillas_historical_prices_fact.product_id} ;;
    relationship: one_to_many
    type: left_outer
  }
}
