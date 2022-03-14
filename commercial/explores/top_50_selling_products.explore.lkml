include: "/views/**/*.view"
include: "/**/*.view"
include: "/**/*.explore"

explore: top_50_selling_products {
  extends: [current_inventory]
  label: "Inventory"
  view_label: "* Inventory Data *"
  #view_name: order_orderline_cl
  group_label: "16) Retail Test"
  description: "Inventory data for top 50 selling products with a custom logic (substitite group for Fruits, Veggies, Eggs and product name for the rest)"
  hidden: yes
  # view_name: base_order_orderline
  #extension: required

  join: top_50_selling_products_custom {
    view_label: "* Top 50 Selling Products *"
    sql_on: ${inventory.country_iso} = ${top_50_selling_products_custom.country_iso} AND
        ${inventory.sku} = ${top_50_selling_products_custom.sku}  ;;
    relationship: many_to_one
    type: left_outer
  }

}
