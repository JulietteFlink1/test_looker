include: "/competitive_intelligence/views/bigquery_curated/getir_products.view.lkml"
include: "/competitive_intelligence/views/bigquery_curated/getir_categories.view.lkml"
include: "/competitive_intelligence/views/bigquery_curated/getir_hubs.view.lkml"

explore:  getir_products {
  hidden: no
  label: "Getir Catalog "
  view_label: "Getir Catalog"
  group_label: "Competitive Intelligence"
  description: "Competitive Intelligence Data"

  join: getir_categories {
    view_label: "* Category Information *"
    from: getir_categories
    sql_on: ${getir_categories.hub_id} = ${getir_products.hub_id}
            AND ${getir_categories.subcategory_id} = ${getir_categories.subcategory_id}
            and ${getir_categories.parent_category_id} = ${getir_products.parent_category_id};;
    relationship: many_to_one
    type:  left_outer
  }

  join: getir_hubs {
    from: getir_hubs
    view_label: "* Hub Information *"
    sql_on: ${getir_hubs.hub_id} = ${getir_products.hub_id} ;;
    relationship: many_to_one
    type:  left_outer
  }

  # join: getir_to_flink_global {
  #   from: getir_to_flink_global
  #   view_label: "* Getir-Flink Product Matches *"
  #   sql_on: ${getir_to_flink_global.getir_product_id} = ${getir_products.product_id}
  #     -- and ${getir_to_flink_global.getir_product_name} = ${getir_products.product_name}
  #     ;;
  #     relationship: one_to_many
  #     type: left_outer
  # }

  # join: competitive_intelligence_active_hubs {
  #   from:  competitive_intelligence_active_hubs
  #   view_label: "* Active Hubs *"
  #   sql_on: ${getir_hubs.hub_id} = ${competitive_intelligence_active_hubs.hub_id} ;;
  #   relationship: one_to_many
  #   type: left_outer
  # }

  # join: products {
  #   from:  products
  #   view_label: "* Flink Product Data *"
  #   sql_on: ${products.product_sku} = ${getir_to_flink_global.flink_product_sku};;
  #   relationship: one_to_many
  #   type: inner
  # }

}
