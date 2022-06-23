# Owner: Brandon Beckett
# Created: 2022-04-26
# Main Stakeholder: Pricing Team
#
# Questions that can be answered:
# - How do competitor prices compare to Flink while taking only matched products into consideration?

include: "/**/products.view"
include: "/**/global_filters_and_parameters.view.lkml"
include: "/**/products_hub_assignment_v2.view"
include: "/**/inventory.view"
include: "/**/unique_assortment.view"
include: "/**/hubs_ct.view"
include: "/**/flink_to_gorillas_global.view"
include: "/**/gorillas_products.view"
include: "/**/gorillas_categories.view"
include: "/**/gorillas_hubs.view"
include: "/**/gorillas_historical_prices_fact.view"
include: "/**/flink_to_getir_global.view"
include: "/**/getir_products.view"
include: "/**/getir_categories.view"
include: "/**/getir_hubs.view"
include: "/**/flink_to_albert_heijn_global.view"
include: "/competitive_intelligence/views/bigquery_curated/albert_heijn_products.view.lkml"
include: "/**/key_value_items.view"
include: "/**/price_test_tracking.view"
include: "/**/product_prices_daily.view"
include: "/**/gorillas_pricing_hist.view"

explore: competitive_pricing {
  from: products
  view_name: products
  group_label: "08) Competitive Intel"
  view_label: "Flink Products"
  description: "Flink's entire assortment and competitor product matches."

  hidden: yes

  access_filter: {
    field: hubs.country_iso
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

  join: inventory {
    sql_on: ${inventory.sku} = ${products_hub_assignment.sku}
        and ${inventory.hub_code} = ${products_hub_assignment.hub_code} ;;
    relationship: one_to_many
    type: left_outer
    sql_where: (${inventory.is_most_recent_record} = TRUE) ;;
  }

  join: product_prices_daily {
    view_label: "* Flink Product Prices Daily *"
    sql_on: ${product_prices_daily.sku} = ${products.product_sku} and
      ${product_prices_daily.hub_code} = ${products_hub_assignment.hub_code} ;;
    relationship: one_to_many
    type: left_outer
  }

  join: price_test_tracking {
    sql_on:  ${products.product_sku} = ${price_test_tracking.product_sku};;
    relationship: many_to_one
    type:  left_outer
  }

  join: unique_assortment {
    sql_on: ${products.product_sku} = ${unique_assortment.product_sku} ;;
    relationship: many_to_one
    type: left_outer
  }

  join: key_value_items {
    sql_on: ${products.product_sku} = ${key_value_items.sku} ;;
    relationship: many_to_one
    type: left_outer
  }

  join: flink_to_gorillas_global {
    from: flink_to_gorillas_global
    view_label: "* Flink-Gorillas Match Data *"
    sql_on: ${flink_to_gorillas_global.flink_product_sku} = ${products.product_sku};;
    relationship: one_to_one
    type: left_outer
  }

  join: gorillas_products {
    from:  gorillas_products
    view_label: "* Gorillas Products *"
    sql_on: ${gorillas_products.product_id} = ${flink_to_gorillas_global.gorillas_product_id}
      AND ${flink_to_gorillas_global.gorillas_product_name} = ${gorillas_products.product_name};;
    relationship: one_to_many
    type: left_outer
  }

  join: gorillas_pricing_hist {
    sql_on: ${gorillas_products.product_id} = ${gorillas_pricing_hist.product_id} ;;
    relationship: many_to_many
    type: left_outer
  }

  join: gorillas_categories {
    from: gorillas_categories
    view_label: "* Gorillas Categories *"
    sql_on: ${gorillas_categories.hub_id} = ${gorillas_products.hub_id} AND ${gorillas_categories.product_id} = ${gorillas_products.product_id};;
    relationship: many_to_one
    type:  left_outer
  }

  join: gorillas_hubs {
    from:  gorillas_hubs
    view_label: "* Gorillas Hubs *"
    sql_on: ${gorillas_hubs.hub_id} = ${gorillas_categories.hub_id} ;;
    relationship: many_to_one
    type:  left_outer
  }

  join: gorillas_historical_prices_fact {
    from: gorillas_historical_prices_fact
    view_label: "* Gorillas Historical Prices *"
    sql_on: ${gorillas_products.product_id} = ${gorillas_historical_prices_fact.product_id} ;;
    relationship: many_to_one
    type: left_outer
  }

  join: flink_to_getir_global {
    from: flink_to_getir_global
    view_label: "* Flink-Getir Match Data *"
    sql_on: ${flink_to_getir_global.flink_product_sku} = ${products.product_sku} ;;
    relationship: one_to_one
    type: left_outer
  }

  join: getir_products {
    from: getir_products
    view_label: "* Getir Products *"
    sql_on: ${flink_to_getir_global.getir_product_id} = ${getir_products.product_id} ;;
    relationship: one_to_many
    type: left_outer
  }

  join: getir_categories {
    view_label: "* Getir Categories *"
    from: getir_categories
    sql_on: ${getir_categories.hub_id} = ${getir_products.hub_id}
            and ${getir_categories.subcategory_id} = ${getir_categories.subcategory_id}
            and ${getir_categories.parent_category_id} = ${getir_products.parent_category_id};;
    relationship: many_to_one
    type:  left_outer
  }

  join: getir_hubs {
    from: getir_hubs
    view_label: "* Getir Hubs *"
    sql_on: ${getir_hubs.hub_id} = ${getir_products.hub_id} ;;
    relationship: many_to_one
    type:  left_outer
  }

  join: flink_to_albert_heijn_global {
    from: flink_to_albert_heijn_global
    view_label: "* Flink-Albert Heijn Match Data *"
    sql_on: ${flink_to_albert_heijn_global.flink_product_sku} = ${products.product_sku} and
            ${flink_to_albert_heijn_global.country_iso} = ${products.country_iso};;
    relationship: one_to_one
    type: left_outer
  }

  join: albert_heijn_products {
    from: albert_heijn_products
    view_label: "* Albert Heijn Products *"
    sql_on: ${albert_heijn_products.product_id} = ${flink_to_albert_heijn_global.albert_heijn_product_id} ;;
    relationship: one_to_one
    type: left_outer
  }

}
