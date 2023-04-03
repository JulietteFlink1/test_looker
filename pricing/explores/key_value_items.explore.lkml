include: "/**/*.view"
include: "/**/products_hub_assignment.view"
include: "/**/replenishment_purchase_orders.view"
include: "/**/bulk_items.view"
include: "/**/bulk_inbounding_performance.view"
include: "/**/shipping_methods_ct.view"

explore: key_value_items {
  extends: [order_orderline_cl]

  group_label: "Pricing"
  label: "Key Value Items"
  hidden: no

  #deleting date because was generated twice in the same week
  join: key_value_items {
    sql_on: ${key_value_items.sku}           = ${orderline.product_sku} and
            ${key_value_items.country_iso}   = ${orderline.country_iso} and
            ${key_value_items.kvi_date}      <> "2022-05-10" ;;
    type: left_outer
    relationship: many_to_many #changed from one_to_many
  }

  join: products_hub_assignment {
    from: products_hub_assignment
    sql_on:
            ${products_hub_assignment.sku}           = ${orderline.product_sku} and
            ${products_hub_assignment.hub_code}      = ${orderline.hub_code} and
            ${products_hub_assignment.report_date}   = ${orderline.created_date} ;;
    type: left_outer
    relationship: many_to_many
  }

  join: shipping_methods_ct {
    view_label: "Shipping Methods"
    sql_on:
      ${orders_cl.shipping_method_id} = ${shipping_methods_ct.shipping_method_id} and
      ${orders_cl.country_iso} = ${shipping_methods_ct.country_iso} ;;
    type: left_outer
    relationship: many_to_many
  }
}
