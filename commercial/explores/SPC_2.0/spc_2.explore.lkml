include: "/**/sku_performance_base.view"
include: "/**/products.view"
include: "/**/lexbizz_item.view"
include: "/**/hubs_ct.view"
include: "/**/spc_2_ranks.view"
include: "/**/lexbizz_item_warehouse.view"
include: "/**/lexbizz_warehouse.view"
include: "/**/orderline.view"
include: "/**/*.view"
include: "/**/global_filters_and_parameters.view"


explore: spc_2 {

  from: sku_performance_base
  view_name: sku_performance_base
  view_label: "SPC 2.0 Core Data"
  label: "SPC 2.0"

  hidden: yes

  join: global_filters_and_parameters {
    sql: ;;
    # Use `sql` instead of `sql_on` and put some whitespace in it
    relationship: one_to_one
  }


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

  join: orderline {

    view_label: "Order Lineitems (Reporting Period)"

    type: left_outer
    relationship: one_to_many

    sql_on: ${orderline.product_sku} =  ${sku_performance_base.joining_sku}
       and  ${orderline.hub_code}    = ${sku_performance_base.hub_code}
       and ${orderline.created_date} between ${sku_performance_base.reporting_period_start_date} and ${sku_performance_base.reporting_period_end_date}
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

  join: lexbizz_warehouse {

    view_label: ""

    type: left_outer
    relationship: many_to_one

    sql_on: ${lexbizz_warehouse.hub_code} =  ${sku_performance_base.hub_code}
    and   ${lexbizz_warehouse.ingestion_date} = current_date()
    ;;

  }

  join: lexbizz_item_warehouse {

    type: left_outer
    relationship: many_to_one

    sql_on: ${lexbizz_item_warehouse.warehouse_id} = ${lexbizz_warehouse.warehouse_id} and
            ${lexbizz_item_warehouse.sku}        =${sku_performance_base.joining_sku} and
            ${lexbizz_item_warehouse.ingestion_date} = current_date()
    ;;

    fields: [lexbizz_item_warehouse.item_at_warehouse_status]
  }




}
