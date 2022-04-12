include: "/**/albert_hejn_products.view"
include: "/**/albert_heijn_to_flink_global.view"
include: "/**/products.view"

explore:  albert_heijn_products {
  hidden: yes
  label: "Albert Heijn Products"
  view_label: "Albert Heijn Products"
  group_label: "Competitive Intel"
  description: "Competitive Intelligence Data"


  join: albert_heijn_to_flink_global {
    from: albert_heijn_to_flink_global
    view_label: "* Albert Heijn-Flink Match Data *"
    sql_on: ${albert_heijn_products.product_id} = ${albert_heijn_to_flink_global.albert_heijn_product_id} ;;
    relationship: one_to_one
    type:  left_outer
  }

  join: products {
    from:  products
    view_label: "* Flink Product Data *"
    sql_on: ${products.product_sku} = ${albert_heijn_to_flink_global.flink_product_sku}
        and ${products.country_iso} = ${albert_heijn_to_flink_global.country_iso};;
    relationship: one_to_many
    type: left_outer
  }

}
