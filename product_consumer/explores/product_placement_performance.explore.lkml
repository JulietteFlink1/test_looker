# Owner: Patricia Mitterova

# Main Stakeholder:
# - Consumer Product
# - Retail / Commercial team

# Questions that can be answered
# - user based conversions

include: "/**/product_placement_performance.view"
include: "/**/global_filters_and_parameters.view.lkml"
include: "/**/affected_by_impression_users.view"

explore: product_placement_performance {
  from:  product_placement_performance
  view_name: product_placement_performance

  label: "Impressions Product Placement Performance"
  description: "This explore provides an aggregated overview of product performance and its placement in the app & web. Please note the daily last-in first-out attribution logic. For ultimate truth on an order level, please refer to the Orders Explore."
  group_label: "Consumer Product"

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
      affected_by_impression_users.is_exposed_to_impressions: "Yes",
      product_placement_performance.product_placement: "category, search, last_bought, swimlane",
      product_placement_performance.country_iso: "",
      product_placement_performance.platform: ""
    ]
  }

#  always_join: [global_filters_and_parameters]

  join: global_filters_and_parameters {
    sql_on: ${global_filters_and_parameters.generic_join_dim} = TRUE ;;
    type: left_outer
    relationship: many_to_one
  }

  join: affected_by_impression_users {
    sql_on: ${product_placement_performance.anonymous_id}= ${affected_by_impression_users.anonymous_id}
            and ${product_placement_performance.event_date}=${affected_by_impression_users.event_date};;
    type: left_outer
    relationship: many_to_one
  }

}
