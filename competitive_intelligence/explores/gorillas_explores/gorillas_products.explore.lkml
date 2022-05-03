include: "/competitive_intelligence/views/**/*.view.lkml"

explore:  gorillas_products {
  hidden: yes
  label: "Gorillas Products"
  view_label: "Gorillas Products"
  group_label: "Competitive Intel"
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

  join: gorillas_to_flink_global {
    from: gorillas_to_flink_global
    view_label: "* gorillas-Flink Product Matches *"
    sql_on: ${gorillas_to_flink_global.gorillas_product_id} = ${gorillas_products.product_id} ;;
    relationship: one_to_many
    type: left_outer
  }

}
