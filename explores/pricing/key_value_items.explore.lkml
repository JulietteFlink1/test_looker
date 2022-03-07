include: "/**/*.view"

explore: key_value_items {

  extends: [order_orderline_cl]

  group_label: "Pricing"
  label: "Key Value Items"
  hidden: no



  # join: products {
  #   sql_on: ${key_value_items.sku}         = ${products.product_sku} ;;
  #   relationship: many_to_one

  # }

  join: key_value_items {
    sql_on: ${key_value_items.sku}           = ${orderline.product_sku} ;;
    relationship: one_to_many
  }



  # join: products_hub_assignment_v2 {
  #   sql_on:
  #           ${products_hub_assignment_v2.sku}           = ${orderline.product_sku} and
  #           ${products_hub_assignment_v2.hub_code}      = ${orderline.hub_code} and
  #           ${products_hub_assignment_v2.report_date}   = ${orderline.created_date}
  #   ;;
  #   type: left_outer
  #   relationship: one_to_many
  # }

  # join: inventory_daily {
  #   sql_on:
  #       ${inventory_daily.hub_code}    = ${products_hub_assignment_v2.hub_code}     and
  #       ${inventory_daily.sku}         = ${products_hub_assignment_v2.sku}          and
  #       ${inventory_daily.report_date} = ${products_hub_assignment_v2.report_date}
  #   ;;
  #   type: left_outer
  #   relationship: one_to_one
  # }





}
