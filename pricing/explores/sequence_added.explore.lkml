include: "/**/*.view"

explore: sequence_added {

  # extends: [order_orderline_cl]

  group_label: "Pricing"
  label: "Sequence added to basket"
  hidden: no



  join: products {
    sql_on: ${sequence_added.sku}        = ${products.product_sku} ;;
    relationship: many_to_one

  }


  join: hubs_ct {
    sql_on: ${sequence_added.hub_code}              = ${hubs_ct.hub_code}
        ;;
    relationship: many_to_one
  }



}
