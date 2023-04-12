# Owner: Brandon Beckett
# Created: 2023-02-14
# Main Stakeholder: Pricing Team
#
# Questions that can be answered:
# - How do competitor prices compare to Flink's prices?
# - What number & % of Flink products do we match with each competitor?

include: "/**/flink_to_competitors_prices.view"
include: "/**/published_and_assigned_products.view"

explore: flink_to_competitors_prices {
  from: flink_to_competitors_prices

  label:       "Competitor Price Benchmarking"
  description: "This explore provides a comprehensive view of Flink's assortment and all competitor product matches, prices, and price differences from Flink."
  group_label: "Competitive Intelligence"
  view_label:  "Competitor Price Benchmarking"

  access_filter: {
    field: flink_to_competitors_prices.country_iso
    user_attribute: country_iso
  }

  join: published_and_assigned_products {
    from: published_and_assigned_products
    sql_on: ${flink_to_competitors_prices.flink_product_sku} = ${published_and_assigned_products.product_sku}
        and ${flink_to_competitors_prices.country_iso} = ${published_and_assigned_products.country_iso} ;;
    type: left_outer
    relationship: one_to_one
  }

}
