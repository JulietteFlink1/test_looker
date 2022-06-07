# Owner: Brandon Beckett
# Created: 2022-05-20
# Main Stakeholder: Pricing Team
#
# Questions that can be answered:
# - What are our current product discounts in CommerceTools?
# - Which SKUs and/or hubs do these discounts apply to?
# - What currently discounted products can be found in the "Angebote" category?

include: "/**/products.view"
include: "/**/global_filters_and_parameters.view"
include: "/**/product_discounts.view"
include: "/**/double_listed_products.view"

include: "/**/current_inventory.explore"

explore: current_product_discounts {

  extends: [current_inventory]

  group_label: "Pricing"

  join: double_listed_products {
    from: double_listed_products
    sql_on: ${products.product_sku} = ${double_listed_products.sku} ;;
    type: left_outer
    relationship: one_to_many
  }

  join: product_discounts {
    from: product_discounts
    sql_on: ${double_listed_products.sku} = ${product_discounts.product_sku} ;;
    type: left_outer
    relationship: many_to_many
  }
}
