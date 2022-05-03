include: "/competitive_intelligence/views/**/*.view.lkml"

explore: gorillas_inventory_stock_count {
  view_name: gorillas_inventory_stock_count
  label: "Gorillas Inventory Stock Count"
  view_label: "Gorillas Inventory Stock Count"
  hidden: yes
  group_label: "8) Competitive Intelligence"
  description: "Gorillas Product Sales"

  join: gorillas_categories {
    from: gorillas_categories
    sql_on: ${gorillas_categories.hub_id} = ${gorillas_inventory_stock_count.hub_id} AND ${gorillas_categories.product_id} = ${gorillas_inventory_stock_count.product_id};;
    relationship: many_to_one
    type:  left_outer
  }
}
