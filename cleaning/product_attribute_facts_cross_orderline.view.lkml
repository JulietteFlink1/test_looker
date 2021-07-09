include: "/**/*.view"
view: product_attribute_facts_cross_orderline {
  extends: [product_attribute_facts]

  dimension: substitue_group_complete {
    group_label: "* Product Attributes *"
    description: "Returns the substitute group if set, else returns the product name"
    type: string
    sql: coalesce(${substitute_group}, (${order_orderline.product_name})) ;;
  }

}
