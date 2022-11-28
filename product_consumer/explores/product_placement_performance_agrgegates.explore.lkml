# Owner: Product Analytics, Galina Larina

# Main Stakeholder:
# - Consumer Product

# Questions that can be answered
# - number of users impacted by product at the product placement

include: "/product_consumer/views/bigquery_reporting/product_placement_performance_aggregates.view"
include: "/**/global_filters_and_parameters.view.lkml"


explore: product_placement_performance_aggregates {
  from:  product_placement_performance_aggregates
  view_name: product_placement_performance_aggregates
  hidden: no

  label: "Product Placement Performance Aggregates"
  description: "This explore provides an aggregated overview of the different placements used by Flink users add products to cart and order. Please note the following limitations:
  - This explore uses front-end behavioural tracking, and may understate actual counts due to the standard limitations of front-end tracking. We only attribute orders placed in the same day as the product was added to cart. Please use the Orders or Line Items explores as the source of truth for SKU sales.
  - Removing either the SKU or Placement dimension will lead to counts being overstated as users may be counted multiple times."
  group_label: "Product - Consumer"

  sql_always_where:{% condition global_filters_and_parameters.datasource_filter %} ${event_date_date} {% endcondition %};;

  access_filter: {
    field: country_iso
    user_attribute: country_iso
  }

  always_filter: {
    filters: [
      global_filters_and_parameters.datasource_filter: "last 7 days",
      product_placement_performance_aggregates.country_iso: "",
      product_placement_performance_aggregates.hub_code: ""
    ]
  }

  join: global_filters_and_parameters {
    sql: ;;
  relationship: one_to_one
}
}
