# Owner: Brandon Beckett
# Created: 2022-06-24
# Main Stakeholder: Pricing Team
#
# Questions that can be answered:
# - How do Gorillas prices compare to Flink prices on matched products?
# Note: This explore was created modeled after the competitive_pricing explore, with the difference of joining Flink and Gorillas dates for better comparisons.

include: "/**/products.view"
include: "/**/products_hub_assignment_v2.view"
include: "/**/inventory.view"
include: "/**/unique_assortment.view"
include: "/**/hubs_ct.view"
include: "/**/flink_to_gorillas_global.view"
include: "/**/gorillas_products.view"
include: "/**/gorillas_categories.view"
include: "/**/gorillas_hubs.view"
include: "/**/key_value_items.view"
include: "/**/price_test_tracking.view"
include: "/**/product_prices_daily.view"
include: "/**/gorillas_pricing_hist.view"

explore: gorillas_flink_price_comparison {
  view_name: flink_to_gorillas_global
  group_label: "Competitive Intelligence"
  view_label: "Flink <> Gorillas Product Matches"
  description: "Flink's entire assortment and Gorillas product matches."

  hidden: yes

  access_filter: {
    field: flink_to_gorillas_global.country_iso
    user_attribute: country_iso
  }

  join: products {
    from:  products
    sql_on: ${flink_to_gorillas_global.flink_product_sku} = ${products.product_sku} ;;
    relationship: one_to_one
    type: left_outer
}

  join: products_hub_assignment {
    from: products_hub_assignment_v2
    sql_on: ${products_hub_assignment.sku} = ${products.product_sku}
      and ${products_hub_assignment.report_date} = current_date() ;;
    type: left_outer
    relationship: one_to_many
  }

  join: hubs {
    from:  hubs_ct
    sql_on: ${hubs.hub_code} = ${products_hub_assignment.hub_code} ;;
    relationship: many_to_one
    type:  left_outer
  }

  # join: inventory {
  #   sql_on: ${inventory.sku} = ${products_hub_assignment.sku}
  #     and ${inventory.hub_code} = ${products_hub_assignment.hub_code} ;;
  #   relationship: one_to_many
  #   type: left_outer
  #   sql_where: (${inventory.is_most_recent_record} = TRUE) ;;
  # }

  join: product_prices_daily {
    view_label: "* Flink Product Prices Daily *"
    sql_on: ${product_prices_daily.sku} = ${products.product_sku} and
      ${product_prices_daily.hub_code} = ${products_hub_assignment.hub_code} ;;
    relationship: one_to_many
    type: left_outer
  }

  join: key_value_items {
    sql_on: ${products.product_sku} = ${key_value_items.sku} ;;
    relationship: many_to_one
    type: left_outer
  }

  join: gorillas_products {
    from:  gorillas_products
    view_label: "* Gorillas Products *"
    sql_on: ${gorillas_products.product_id} = ${flink_to_gorillas_global.gorillas_product_id}
      AND ${flink_to_gorillas_global.gorillas_product_name} = ${gorillas_products.product_name};;
    relationship: one_to_one
    type: left_outer
  }

  join: gorillas_pricing_hist {
    sql_on: ${gorillas_products.product_id} = ${gorillas_pricing_hist.product_id} and
            ${product_prices_daily.reporting_date} = ${gorillas_pricing_hist.latest_timestamp_date};;
    relationship: one_to_many
    type: left_outer
  }

  join: gorillas_categories {
    from: gorillas_categories
    view_label: "* Gorillas Categories *"
    sql_on: ${gorillas_categories.hub_id} = ${gorillas_products.hub_id} AND
            ${gorillas_categories.product_id} = ${gorillas_products.product_id};;
    relationship: one_to_many
    type:  left_outer
  }

  join: gorillas_hubs {
    from:  gorillas_hubs
    view_label: "* Gorillas Hubs *"
    sql_on: ${gorillas_hubs.hub_id} = ${gorillas_categories.hub_id} ;;
    relationship: one_to_one
    type:  left_outer
  }

}
