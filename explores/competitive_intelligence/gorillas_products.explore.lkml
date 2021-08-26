include: "/views/**/*.view"

explore:  gorillas_products {
  hidden: yes
  label: "Gorillas Products"
  view_label: "Gorillas Products"
  group_label: "08) Competitive Intel"
  description: "Competitive Intelligence Data"

  join: gorillas_hubs {
    from:  gorillas_hubs
    sql_on: ${gorillas_hubs.hub_id} = ${gorillas_products.hub_id} ;;
    relationship: many_to_one
    type:  left_outer
  }
}
