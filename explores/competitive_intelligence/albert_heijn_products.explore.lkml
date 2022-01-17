include: "/views/**/*.view"

explore:  albert_heijn_products {
  hidden: yes
  label: "Albert Heijn Products"
  view_label: "Albert Heijn Products"
  group_label: "Competitive Intel"
  description: "Competitive Intelligence Data"


  join: nl_albert_heijn_to_flink {
    from: nl_albert_heijn_to_flink
    view_label: "* Albert Heijn-Flink Match Data *"
    sql_on: ${albert_heijn_products.product_id} = ${nl_albert_heijn_to_flink.albert_heijn_product_id}
            and ${albert_heijn_products.product_name} = ${nl_albert_heijn_to_flink.albert_heijn_product_name};;
    relationship: one_to_many
    type:  left_outer
  }

  join: products {
    from:  products
    view_label: "* Flink Product Data *"
    sql_on: ${products.product_sku} = ${nl_albert_heijn_to_flink.flink_product_sku};;
    relationship: one_to_many
    type: inner
  }

}
