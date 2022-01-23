include: "/**/*.view"


explore: products_hub_assignment_v2 {

  hidden: yes

  join: products {
    sql_on: ${products.product_sku} = ${products_hub_assignment_v2.sku} ;;
    relationship: many_to_one
    type: left_outer
  }
}
