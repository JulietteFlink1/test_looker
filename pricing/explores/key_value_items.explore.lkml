include: "/**/*.view"
include: "/**/products_hub_assignment_v2.view"
include: "/**/replenishment_purchase_orders.view"
include: "/**/bulk_items.view"
include: "/**/bulk_inbounding_performance.view"

explore: key_value_items {
  extends: [order_orderline_cl]


  group_label: "Pricing"
  label: "Key Value Items"
  hidden: no



  # join: products {
  #   sql_on: ${key_value_items.sku}         = ${products.product_sku} ;;
  #   relationship: many_to_one
  # }


  #deleting date because was generated twice in the same week
  join: key_value_items {
    sql_on: ${key_value_items.sku}           = ${orderline.product_sku} and
            ${key_value_items.kvi_date}      <> "2022-05-10";;
    type: left_outer
    relationship: many_to_many #changed from one_to_many
  }


  join: products_hub_assignment_v2 {
    sql_on:
            ${products_hub_assignment_v2.sku}           = ${orderline.product_sku} and
            ${products_hub_assignment_v2.hub_code}      = ${orderline.hub_code} and
            ${products_hub_assignment_v2.report_date}   = ${orderline.created_date}
    ;;
    type: left_outer
    relationship: many_to_many
    }


  #join: products_hub_assignment {
  #  sql_on:
  #          ${products_hub_assignment.sku}           = ${orderline.product_sku} and
  #          ${products_hub_assignment.hub_code}      = ${orderline.hub_code} and
  #          ${products_hub_assignment.valid_from}    = ${orderline.created_date}
  #  ;;
  #  type: left_outer
  #  relationship: many_to_many
  #}

  # join: aov_certain_sku_is_in {
  #   sql_on:
  #           ${aov_certain_sku_is_in.product_sku}  = ${orderline.product_sku} and
  #           ${aov_certain_sku_is_in.hub_code}     = ${orderline.hub_code} and
  #           ${aov_certain_sku_is_in.order_date}   = ${orderline.created_date}
  #   ;;
  #   type: left_outer
  #   relationship: one_to_many #changed from one_to_one
  # }
  # join: aov_certain_sku_is_in {
  #   sql_on:
  #           ${aov_certain_sku_is_in.product_sku}  = ${key_value_items.sku}
  #   ;;
  #   type: left_outer
  #   relationship: one_to_many #changed from one_to_one
  # }

  #join: inventory_daily {
  #  sql_on:
  #      ${inventory_daily.hub_code}    = ${orderline.hub_code}     and
  #      ${inventory_daily.sku}         = ${orderline.product_sku}  and
  #      ${inventory_daily.report_date} = ${orderline.created_date}
  #      {% condition global_filters_and_parameters.datasource_filter %} ${inventory_daily.report_date} {% endcondition %}
  #  ;;
  #  type: left_outer
  #  relationship: many_to_one
  #}


  #join: inventory_daily {
  #  type: left_outer
  #  relationship: one_to_one
  #  sql_on:
  #      ${inventory_daily.hub_code}    = ${products_hub_assignment_v2.hub_code}     and
  #      ${inventory_daily.sku}         = ${products_hub_assignment_v2.sku}          and
  #      ${inventory_daily.report_date} = ${products_hub_assignment_v2.report_date}  and
  #      {% condition global_filters_and_parameters.datasource_filter %} ${inventory_daily.report_date} {% endcondition %}
  #  ;;
  # }
}
