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

  join: product_productvariant {
    sql_on: ${order_orderline.country_iso} = ${product_productvariant.country_iso} AND
            ${order_orderline.product_sku} = ${product_productvariant.sku} ;;
    relationship: one_to_one
    type: left_outer
  }

  join: product_product {
    sql_on: ${product_productvariant.country_iso} = ${product_product.country_iso} AND
            ${product_productvariant.product_id}  = ${product_product.id} ;;
    relationship: one_to_one
    type: left_outer
  }

  join: product_attribute_facts {
    sql_on: ${product_product.country_iso} = ${product_attribute_facts.country_iso} AND
            ${product_product.id}          = ${product_attribute_facts.id} ;;
    relationship: one_to_one
    type: left_outer
  }

  join: product_category {
    sql_on: ${product_category.country_iso} = ${product_product.country_iso} AND
            ${product_category.id}          = ${product_product.category_id} ;;
    relationship: one_to_one
    type: left_outer
  }

  join: product_producttype {
    sql_on:${product_product.country_iso}     = ${product_producttype.country_iso} AND
           ${product_product.product_type_id} = ${product_producttype.id} ;;
    relationship: one_to_one
    type: left_outer
  }

  join: parent_category {
    view_label: "* Product / SKU Parent Category Data *"
    from: product_category
    sql_on: ${product_category.country_iso} = ${parent_category.country_iso} AND
            ${product_category.parent_id}   = ${parent_category.id} ;;
    relationship: one_to_one
    type: left_outer
  }



}
