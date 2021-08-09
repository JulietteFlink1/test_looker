include: "/views/**/*.view"
include: "/**/*.view"
include: "/**/*.explore"

explore: top_50_selling_products {
  extends: [inventory_cl]
  label: "Inventory"
  view_label: "* Inventory Data *"
  #view_name: order_orderline_cl
  group_label: "16) Retail Test"
  description: "Inventory data for top 50 selling products with a custom logic (substitite group for Fruits, Veggies, Eggs and product name for the rest)"
  hidden: no
  # view_name: base_order_orderline
  #extension: required

  join: top_50_selling_products_custom {
    sql_on: ${inventory_cl.country_iso} = ${top_50_selling_products_custom.country_iso} AND
      ${inventory_cl.sku}    = ${top_50_selling_products_custom.sku} ;;
    relationship: many_to_one
    type: left_outer
  }

}
