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

  access_filter: {
    field: country_iso
    user_attribute: country_iso
  }

  always_filter: {
    filters: [
      product_placement_performance_excluding_impressions.event_date: "last 7 days",
      product_placement_performance_excluding_impressions.country_iso: ""
    ]
  }

}
