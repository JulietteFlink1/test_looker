# Owner: Brandon Beckett
# Created: 2022-05-20
# Main Stakeholder: Pricing Team
#
# Questions that can be answered:
# - What are our current product discounts in CommerceTools?
# - Which SKUs and/or hubs do these discounts apply to?

include: "/**/products.view"
include: "/**/global_filters_and_parameters.view"
include: "/**/product_discounts.view"

explore: product_discounts {
  from: product_discounts
  view_name: products_discounts
  group_label: "Pricing"
  view_label: "Flink Product Discounts"
  description: "Flink Product Discounts from CommerceTools."

  hidden: no

  access_filter: {
    field: country_iso
    user_attribute: country_iso
  }

  always_filter: {
    filters: [
      global_filters_and_parameters.datasource_filter: "last 30 days"
    ]
  }

  join: global_filters_and_parameters {
    sql_on: ${global_filters_and_parameters.generic_join_dim} = TRUE ;;
    type: left_outer
    relationship: many_to_one
  }

  join: products {

    from: products

    sql_on: ${product_sku} = ${products.product_sku} ;;
    type: left_outer
    relationship: many_to_many
  }
}
