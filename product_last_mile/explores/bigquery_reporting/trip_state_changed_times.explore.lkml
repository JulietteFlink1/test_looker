# Owner: Product Analytics, Bastian Gerstner

# Main Stakeholder:
# - Last Mile Tech Team

# Questions that can be answered
# - Questions around handover times & trip times

include: "/**/*/trip_state_changed_times.view.lkml"
include: "/**/global_filters_and_parameters.view.lkml"


explore: trip_state_changed_times {
  from:  trip_state_changed_times
  view_name: trip_state_changed_times
  hidden: no

  label: "Trip State Updated Times"
  description: "This explore provides information around trip and the respective times in each state"
  group_label: "Product - Last Mile"

  # implement both date filters:
  # received_at is due cost reduction given a table is partitioned by this dimensions
  # event_date filter will fitler for the desired time frame when events triggered

  sql_always_where:{% condition global_filters_and_parameters.datasource_filter %} ${event_date_date} {% endcondition %};;


  always_filter: {
    filters: [
      trip_state_changed_times.event_date_date: "last 7 days"
    ]
  }

  access_filter: {
    field: trip_state_changed_times.country_iso
    user_attribute: country_iso
  }

  join: global_filters_and_parameters {
    sql: ;;
  relationship: one_to_one
}

}
