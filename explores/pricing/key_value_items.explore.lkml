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

}
