
include: "/**/*.view"

explore: double_listed_products {
  hidden: yes
  group_label: "Commercial"
  from: double_listed_products
  view_name: double_listed_products

join: products {
  sql_on:
      ${products.product_sku} = ${double_listed_products.sku} and
      ${products.country_iso} = ${double_listed_products.country_iso}
      ;;
  relationship: many_to_one
  type: left_outer
}

}
