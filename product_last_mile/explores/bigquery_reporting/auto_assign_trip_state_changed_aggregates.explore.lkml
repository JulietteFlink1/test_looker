# Owner: Product Analytics, Bastian Gerstner

# Main Stakeholder:
# - Last Mile Tech Team

# Questions that can be answered
# - Questions around auto assign times & trip times

include: "/**/*/auto_assign_trip_state_changed_aggregates.view.lkml"
include: "/**/global_filters_and_parameters.view.lkml"


explore: auto_assign_trip_state_changed_aggregates {
  from:  auto_assign_trip_state_changed_aggregates
  view_name: auto_assign_trip_state_changed_aggregates
  hidden: no

  label: "Auto Assign Aggregates"
  description: "This explore provides information around auto assign offers and the respective trip information"
  group_label: "Product - Last Mile"

# event_date filter will fitler for the desired time frame when events triggered

  sql_always_where:{% condition global_filters_and_parameters.datasource_filter %} ${event_date} {% endcondition %};;


  always_filter: {
    filters: [
      auto_assign_trip_state_changed_aggregates.event_date: "last 7 days"
    ]
  }

  access_filter: {
    field: auto_assign_trip_state_changed_aggregates.country_iso
    user_attribute: country_iso
  }

  join: global_filters_and_parameters {
    sql: ;;
  relationship: one_to_one
}
}
