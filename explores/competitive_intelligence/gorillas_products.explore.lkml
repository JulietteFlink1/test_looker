include: "/views/**/*.view"

explore:  gorillas_products_hist {
  hidden: yes
  label: "Gorillas Products"
  view_label: "Gorillas Products"
  group_label: "08) Competitive Intel"
  description: "Competitive Intelligence Data"

  join: gorillas_categories {
    from: gorillas_categories
    sql_on: ${gorillas_categories.hub_id} = ${gorillas_products_hist.hub_id} AND ${gorillas_categories.product_id} = ${gorillas_products_hist.product_id};;
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
