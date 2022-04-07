# Owner: Patricia Mitterova

# Main Stakeholder:
# - Consumer Product
# - Retail / Commercial team

# Questions that can be answered
# - user based conversions

include: "/**/product_placement_performance_excluding_impressions.view"
include: "/**/global_filters_and_parameters.view.lkml"

explore: product_placement_performance_excluding_impressions {
  from:  product_placement_performance_excluding_impressions
  view_name: product_placement_performance_excluding_impressions
  hidden: no

  label: "Product Placement Performance"
  description: "This explore provides an aggregated overview of Flink active users, including placement conversion metrics (both App & Web)"
  group_label: "Consumer Product"

  sql_always_where:{% condition global_filters_and_parameters.datasource_filter %} ${event_date} {% endcondition %};;

  access_filter: {
    field: country_iso
    user_attribute: country_iso
  }

  always_filter: {
    filters: [
      global_filters_and_parameters.datasource_filter: "last 7 days",
      product_placement_performance_excluding_impressions.country_iso: "",
      product_placement_performance_excluding_impressions.platform: "",
      product_placement_performance_excluding_impressions.product_placement: "category, search, last_bought, swimlane"
    ]
  }

  join: global_filters_and_parameters {
    sql_on: ${global_filters_and_parameters.generic_join_dim} = TRUE ;;
    type: left_outer
    relationship: many_to_one
  }
}
