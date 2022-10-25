# created : December 2021

include: "/**/*.view"
include: "/**/global_filters_and_parameters.view"


explore: recurring_sku_purchases {

  hidden: yes

  always_filter: {
    filters: [
        recurring_sku_purchases.select_skus_for_recurring_sku_tracking: "",
        filter_order_date: ""
      ]
  }

  join: global_filters_and_parameters {
    sql: ;;
    # Use `sql` instead of `sql_on` and put some whitespace in it
    relationship: one_to_one
    fields: [global_filters_and_parameters.is_after_product_discounts]
  }

  join: orderline {
    type: left_outer
    relationship: one_to_many
    sql_on: ${orderline.order_uuid} = ${recurring_sku_purchases.order_uuid} ;;
  }

  join: products {

    type: left_outer
    relationship: many_to_one
    sql_on:  ${products.product_sku} = ${orderline.product_sku};;
  }
}
