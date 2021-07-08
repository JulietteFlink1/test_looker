include: "/views/**/*.view"
include: "/**/*.view"
include: "/**/*.explore"

explore: base_order_orderline {
  extends: [base_orders]
  # view_name: base_order_orderline
  extension: required

  join: order_orderline {
    sql_on: ${order_orderline.country_iso} = ${base_orders.country_iso} AND
            ${order_orderline.order_id}    = ${base_orders.id} ;;
    relationship: one_to_many
    type: left_outer
  }

  join: product_facts {
    type: left_outer
    relationship: many_to_one
    sql_on: ${order_orderline.country_iso} = ${product_facts.country_iso}
       and  ${order_orderline.product_sku} = ${product_facts.sku}
    ;;
  }



}
