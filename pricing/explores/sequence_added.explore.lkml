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


  join: key_value_items {
    sql_on: ${sequence_added.sku}              = ${key_value_items.sku}
    and ${key_value_items.kvi_date} >=current_date() - 6
      ;;
    relationship: many_to_one
  }

join: geographic_pricing_hub_cluster {
sql_on: ${sequence_added.hub_code}              = ${geographic_pricing_hub_cluster.hub_code}
  ;;
relationship: many_to_one
}

  join: geographic_pricing_sku_cluster {
    sql_on: ${sequence_added.sku}              = ${geographic_pricing_sku_cluster.sku}
      ;;
    relationship: many_to_one
  }


}
