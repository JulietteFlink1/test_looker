include: "/**/*.view"

explore: ddf_tracking {

  extends: [order_orderline_cl]

  group_label: "Pricing"
  label: "ddf_tracking"
  hidden: no



  # join: products {
  #   sql_on: ${key_value_items.sku}         = ${products.product_sku} ;;
  #   relationship: many_to_one

  # }

  join: key_value_items {
    sql_on: ${key_value_items.sku}           = ${orderline.product_sku} ;;
    relationship: one_to_many
  }

  join: app_sessions {
    sql_on: ${app_sessions.hub_code}              = ${orders_cl.hub_code}
    and     ${app_sessions.session_start_at_date} = ${orders_cl.created_date}
     and     ${app_sessions.is_new_user}          = ${orders_cl.is_first_order}
    ;;
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
