include: "/views/**/*.view"
include: "/views/bigquery_tables/curated_layer/*.view"
include: "/views/bigquery_tables/reporting_layer/competitive_intelligence/*.view"
include: "/views/bigquery_tables/reporting_layer/competitive_intelligence/gorillas_inventory_stock_count.view.lkml"

explore: flink_to_gorillas_global {
  from: products
  view_name: products
  group_label: "08) Competitive Intel"
  view_label: "* Flink Products *"
  label: "Flink Assortment Matched to Competitors"
  description: "Flink assortment matched to Gorillas & Getir assortment"

  hidden: yes

  join: inventory {
    view_label: "* Flink Products *"
    sql_on: ${inventory.sku} = ${products.product_sku} ;;
    relationship: one_to_many
    type: left_outer
    sql_where: (${inventory.is_most_recent_record} = TRUE) ;;
  }

  join: hubs {
    from:  hubs_ct
    view_label: "* Flink Hubs *"
    sql_on: ${hubs.hub_code} = ${inventory.hub_code} ;;
    relationship: many_to_one
    type:  left_outer
  }

  join: flink_to_gorillas_global {
    from: flink_to_gorillas_global
    view_label: "* Flink-Gorillas Match Data *"
    sql_on: ${flink_to_gorillas_global.flink_product_sku} = ${products.product_sku};;
    relationship: one_to_many
    type: left_outer
  }

  join: gorillas_products {
    from:  gorillas_products
    view_label: "* Gorillas Products *"
    sql_on: ${gorillas_products.product_id} = ${flink_to_gorillas_global.gorillas_product_id}
    AND ${flink_to_gorillas_global.gorillas_product_name} = ${gorillas_products.product_name};;
    relationship: one_to_one
    type: left_outer
  }

  join: gorillas_categories {
    from: gorillas_categories
    view_label: "* Gorillas Categories *"
    sql_on: ${gorillas_categories.hub_id} = ${gorillas_products.hub_id} AND ${gorillas_categories.product_id} = ${gorillas_products.product_id};;
    relationship: many_to_one
    type:  left_outer
  }

  join: gorillas_hubs {
    from:  gorillas_hubs
    view_label: "* Gorillas Hubs *"
    sql_on: ${gorillas_hubs.hub_id} = ${gorillas_categories.hub_id} ;;
    relationship: many_to_one
    type:  left_outer
  }

  join: gorillas_historical_prices_fact {
    from: gorillas_historical_prices_fact
    view_label: "* Gorillas Historical Prices *"
    sql_on: ${gorillas_products.product_id} = ${gorillas_historical_prices_fact.product_id} ;;
    relationship: one_to_many
    type: left_outer
  }

  join: flink_to_getir_global {
    from: flink_to_getir_global
    view_label: "* Flink-Getir Match Data *"
    sql_on: ${flink_to_getir_global.flink_product_sku} = ${products.product_sku};;
    relationship: one_to_many
    type: left_outer
  }

  join: getir_products {
    from: getir_products
    view_label: "* Getir Products *"
    sql_on: ${flink_to_getir_global.getir_product_id} = ${getir_products.product_id} ;;
    relationship: one_to_one
    type: left_outer
  }

  join: getir_categories {
    view_label: "* Getir Categories *"
    from: getir_categories
    sql_on: ${getir_categories.hub_id} = ${getir_products.hub_id}
            and ${getir_categories.subcategory_id} = ${getir_categories.subcategory_id}
            and ${getir_categories.parent_category_id} = ${getir_products.parent_category_id};;
    relationship: many_to_one
    type:  left_outer
  }

  join: getir_hubs {
    from: getir_hubs
    view_label: "* Getir Hubs *"
    sql_on: ${getir_hubs.hub_id} = ${getir_products.hub_id} ;;
    relationship: many_to_one
    type:  left_outer
  }

  join: nl_flink_to_albert_heijn {
    from: nl_flink_to_albert_heijn
    view_label: "* Flink-Albert Heijn Match Data *"
    sql_on: ${nl_flink_to_albert_heijn.flink_product_sku} = ${products.product_sku} ;;
    relationship: one_to_many
    type: left_outer
  }

  join: albert_heijn_products {
    from: albert_heijn_products
    view_label: "* Albert Heijn Products *"
    sql_on: ${albert_heijn_products.product_id} = ${nl_flink_to_albert_heijn.albert_heijn_product_id} ;;
    relationship: one_to_one
    type: left_outer
  }

}
