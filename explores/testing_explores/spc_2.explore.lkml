include: "/views/**/sku_performance_base.view"
include: "/views/**/products.view"
include: "/views/**/lexbizz_item.view"

explore: spc_2 {

  from: sku_performance_base
  view_name: sku_performance_base
  view_label: "SPC 2.0 Core Data"
  label: "SPC 2.0"

  hidden: yes

  join: products {
    view_label: "Product Data"
    type: left_outer
    relationship: many_to_one
    sql_on: ${products.product_sku} = ${sku_performance_base.sku} ;;
  }

  join: lexbizz_item {
    type: left_outer
    relationship: many_to_one
    sql: ${lexbizz_item.sku} = ${sku_performance_base.sku} ;;
  }
}
