# Owner: Product Analytics, Patricia Mitterova

# Main Stakeholder:
# - Consumer Product
# - Retail / Commercial team

# Questions that can be answered
# - user based conversions

include: "/product_consumer/views/bigquery_reporting/product_placement_performance_excluding_impressions.view"
include: "/**/global_filters_and_parameters.view.lkml"
include: "/**/orders.view"
include: "/**/products.view"

explore: product_placement_performance_excluding_impressions {
  from:  product_placement_performance_excluding_impressions
  view_name: product_placement_performance_excluding_impressions
  hidden: no

  label: "Product Placement Performance"
  description: "This explore provides an aggregated overview of product performance and its placement in the app & web. Please note the daily last-in first-out attribution logic. For ultimate truth on an order level, please refer to the Orders Explore.
  Product impressions are not part of this report."
  group_label: "Product - Consumer"

  sql_always_where:{% condition global_filters_and_parameters.datasource_filter %} ${product_placement_performance_excluding_impressions.event_date} {% endcondition %};;

  access_filter: {
    field: country_iso
    user_attribute: country_iso
  }

  always_filter: {
    filters: [
      global_filters_and_parameters.datasource_filter: "last 7 days",
      product_placement_performance_excluding_impressions.country_iso: ""
    ]
  }

  join: global_filters_and_parameters {
    fields: [global_filters_and_parameters.datasource_filter]
    sql_on: ${global_filters_and_parameters.generic_join_dim} = TRUE ;;
    type: left_outer
    relationship: many_to_one
  }

  join: orders {
    fields: [orders.status]
    sql_on: ${orders.order_uuid} = ${product_placement_performance_excluding_impressions.order_uuid}
            and {% condition global_filters_and_parameters.datasource_filter %} ${orders.order_date} {% endcondition %} ;;
    type: left_outer
    relationship: many_to_one
  }

  join: products {
    view_label: "Product Data (CT)"
    sql_on: ${products.product_sku} = ${product_placement_performance_excluding_impressions.product_sku} ;;
    relationship: many_to_one
    type: left_outer
  }

}
