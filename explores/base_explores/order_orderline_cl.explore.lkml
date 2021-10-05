include: "/views/**/*.view"
include: "/**/*.view"
include: "/**/*.explore"

explore: order_orderline_cl {
  extends: [orders_cl]
  group_label: "01) Performance"
  label: "Orders & Lineitems"
  description: "Orderline Items sold quantities, prices, gmv, etc."
  hidden: no
  # view_name: base_order_orderline
  #extension: required

  join: orderline {
    view_label: "* Order Lineitems *"
    sql_on: ${orderline.country_iso} = ${orders_cl.country_iso} AND
            ${orderline.order_uuid}    = ${orders_cl.order_uuid} ;;
    relationship: one_to_many
    type: left_outer
  }

  join: products {
    sql_on: ${products.product_sku} = ${orderline.product_sku} ;;
    relationship: many_to_one
    type: left_outer
  }

  join: customer_address {
    # can only be seen by people with related permissions
    sql_on: ${orders_cl.order_uuid} = ${customer_address.order_uuid} ;;
    type: left_outer
    relationship: one_to_one
  }
}
