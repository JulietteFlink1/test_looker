include: "/competitive_intelligence/views/bigquery_curated/gorillas_products.view.lkml"
include: "/competitive_intelligence/views/bigquery_curated/gorillas_categories.view.lkml"
include: "/competitive_intelligence/views/bigquery_curated/gorillas_hubs.view.lkml"
include: "/competitive_intelligence/views/bigquery_comp_intel/gorillas_to_flink_global.view.lkml"

explore:  gorillas_products {
  hidden: no
  label: "Gorillas Catalog"
  view_label: "Gorillas Catalog"
  group_label: "Competitive Intelligence"
  description: "Competitive Intelligence Data"

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

}
