# Owner: Product Analytics, Patricia Mitterova, Flavia Alvarez

# Main Stakeholder:
# - Consumer Product
# - Retail / Commercial team

# Questions that can be answered
# - user based conversions

include: "/product_consumer/views/bigquery_reporting/product_placement_performance.view"
include: "/**/global_filters_and_parameters.view.lkml"
include: "/product_consumer/views/sql_derived_tables/affected_by_impression_users.view"
include: "/**/orders.view"
include: "/**/products.view"
include: "/**/hubs_ct.view"
include: "/**/hub_specific_price_hub_cluster.view"
include: "/**/hub_specific_price_sku_cluster.view"

explore: product_placement_performance {
  from:  product_placement_performance
  view_name: product_placement_performance
  hidden: no

  label: "Impressions Product Placement Performance"
  description: "This explore provides an aggregated overview of product performance and its placement in the app & web. Please note the daily last-in first-out attribution logic. For ultimate truth on an order level, please refer to the Orders Explore."
  group_label: "Product - Consumer"

  sql_always_where:{% condition global_filters_and_parameters.datasource_filter %} ${product_placement_performance.event_date} {% endcondition %};;

  access_filter: {
    field: hubs.country_iso
    user_attribute: country_iso
  }

# is_exposed_to_impressions is needed as an always_filter because its the way we have to separate users that are sending impression tracking
# product_placement in needed as an always_filter because those are the placements where we are sending the tracking for now
  always_filter: {
    filters: [
      global_filters_and_parameters.datasource_filter: "last 7 days",
      affected_by_impression_users.is_exposed_to_impressions: "Yes",
      product_placement_performance.product_placement: "category, search, last_bought, swimlane",
      product_placement_performance.country_iso: "",
      product_placement_performance.platform: ""
    ]
  }

#  always_join: [global_filters_and_parameters]

  join: global_filters_and_parameters {
    fields: [global_filters_and_parameters.datasource_filter]
    sql_on: ${global_filters_and_parameters.generic_join_dim} = TRUE ;;
    type: left_outer
    relationship: many_to_one
  }

  join: affected_by_impression_users {
    sql_on: ${product_placement_performance.anonymous_id} = ${affected_by_impression_users.anonymous_id}
          and ${product_placement_performance.event_date} = ${affected_by_impression_users.event_date};;
    type: left_outer
    relationship: many_to_one
  }

  join: orders {
    fields: [orders.status]
    sql_on: ${orders.order_uuid} = ${product_placement_performance.order_uuid}
           and {% condition global_filters_and_parameters.datasource_filter %} ${orders.order_date} {% endcondition %}
;;
    type: left_outer
    relationship: many_to_one
  }

  join: products {
        view_label: "Product Data (CT)"
        sql_on: ${products.product_sku} = ${product_placement_performance.product_sku} ;;
    relationship: many_to_one
    type: left_outer
  }

  join: hubs {
    from: hubs_ct
        view_label: "Hubs"
        sql_on: lower(${product_placement_performance.hub_code}) = ${hubs.hub_code} ;;
    relationship: many_to_one
    type: left_outer
  }

  join: geographic_pricing_hub_cluster{
        view_label: "Pricing Hub Cluster"
        sql_on: ${geographic_pricing_hub_cluster.hub_code} = ${product_placement_performance.hub_code}  ;;
    type: left_outer
    relationship: many_to_one
    fields: [price_hub_cluster]

  }

  join: geographic_pricing_sku_cluster{
        view_label: "Pricing SKU Cluster"
        sql_on: ${geographic_pricing_sku_cluster.sku} = ${product_placement_performance.product_sku}  ;;
    type: left_outer
    relationship: many_to_one
    fields: [price_sku_cluster, price_sku_cluster_desc]

  }

}
