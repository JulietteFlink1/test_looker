include: "/explores/base_explores/current_inventory_updated_hourly.explore"

explore: retail_current_inventory {
  extends: [current_inventory_updated_hourly]
  hidden: yes

  join: top_10_products_per_parent_category {
    sql_on: ${top_10_products_per_parent_category.product_name} = ${products.product_name} ;;
    type: left_outer
    relationship: many_to_one
    view_label: "* Top-10 per Parent Category *"

  }

}
