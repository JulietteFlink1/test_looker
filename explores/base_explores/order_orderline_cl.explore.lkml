include: "/views/**/*.view"
include: "/**/*.view"
include: "/**/*.explore"

explore: order_orderline_cl {
  extends: [orders_cl]
  label: "Order, Orderline, Operations CL"
  view_label: "* Orders CL *"
  group_label: "15) Ad-Hoc"
  description: "General Business Performance - Orders, Revenue, etc."
  hidden: no
  # view_name: base_order_orderline
  #extension: required

  join: orderline_ct {
    sql_on: ${orderline_ct.country_iso} = ${orders_cl.country_iso} AND
      ${orderline_ct.order_id}    = ${orders_cl.unique_id} ;;
    relationship: one_to_many
    type: left_outer
  }

  #join: product_facts {
  #  type: left_outer
  #  relationship: many_to_one
  #  sql_on: ${order_orderline.country_iso} = ${product_facts.country_iso}
  #     and  ${order_orderline.product_sku} = ${product_facts.sku}
  #  ;;
  #}
}
