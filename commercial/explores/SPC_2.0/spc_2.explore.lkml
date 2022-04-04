include: "/**/sku_performance_base.view"
include: "/**/products.view"
include: "/**/lexbizz_item.view"
include: "/**/hubs_ct.view"
include: "/**/spc_2_ranks.view"


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
    sql_on: ${products.product_sku} = ${sku_performance_base.joining_sku} ;;
  }

  join: lexbizz_item {

    type: left_outer
    relationship: many_to_one

    sql_on: ${lexbizz_item.sku} = ${sku_performance_base.joining_sku} and
            ${lexbizz_item.ingestion_date} = current_date()
    ;;
  }

  join: hubs_ct {
    view_label: "Hub Data"

    type: left_outer
    relationship: many_to_one

    sql_on:  ${sku_performance_base.hub_code} = ${hubs_ct.hub_code};;
  }

  join: spc_2_ranks {

    view_label: "SPC 2.0 Core Data"

    type: left_outer
    relationship: many_to_one

    sql_on: ${sku_performance_base.hub_code} = ${spc_2_ranks.hub_code} and
            ${sku_performance_base.sku}      = ${spc_2_ranks.sku}
            ;;
  }

  # join: lexbizz_item {
  #   type: left_outer
  #   relationship: many_to_one
  #   sql: ${lexbizz_item.sku} = ${sku_performance_base.sku} ;;
  # }
}
