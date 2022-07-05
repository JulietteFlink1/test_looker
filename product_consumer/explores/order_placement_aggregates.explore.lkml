# Owner: Product Analytics, Patricia Mitterova, Flavia Alvarez

# Main Stakeholder:
# - Consumer Product / Data Team
# Questions that can be answered
# - Order Placement Information

include: "/product_consumer/views/bigquery_reporting/order_placement_aggregates.view"
include: "/**/global_filters_and_parameters.view.lkml"

explore: order_placement_aggregates {
  from:  order_placement_aggregates
  view_name: order_placement_aggregates

  label: "Order Placement Aggregates"
  description: "This explore provides an aggregated overview of orders and their AIV per product placement. This explore shall stay hidden."
  group_label: "Consumer Product"
  hidden: yes

  sql_always_where:{% condition global_filters_and_parameters.datasource_filter %} ${event_date} {% endcondition %};;

  access_filter: {
    field: country_iso
    user_attribute: country_iso
  }

# is_exposed_to_impressions is needed as an always_filter because its the way we have to separate users that are sending impression tracking
# product_placement in needed as an always_filter because those are the placements where we are sending the tracking for now
  always_filter: {
    filters: [
      global_filters_and_parameters.datasource_filter: "last 7 days",
      order_placement_aggregates.country_iso: "",
      order_placement_aggregates.platform: ""
    ]
  }

#  always_join: [global_filters_and_parameters]

  join: global_filters_and_parameters {
    sql_on: ${global_filters_and_parameters.generic_join_dim} = TRUE ;;
    type: left_outer
    relationship: many_to_one
  }
}
