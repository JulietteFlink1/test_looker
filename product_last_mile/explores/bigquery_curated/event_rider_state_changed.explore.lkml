# Owner: Product Analytics, Bastian Gerstner

# Main Stakeholder:
# - Last Mile Tech Team

# Questions that can be answered
# - Questions around rider states

include: "/**/*/event_rider_state_changed.view.lkml"
include: "/**/global_filters_and_parameters.view.lkml"


explore: event_rider_state_changed {
  from:  event_rider_state_changed
  view_name: event_rider_state_changed
  hidden: no

  label: "Event Rider State Changed"
  description: "This explore provides information around rider states"
  group_label: "Product - Last Mile"

  # implement both date filters:
  # received_at is due cost reduction given a table is partitioned by this dimensions
  # event_date filter will fitler for the desired time frame when events triggered

  sql_always_where:{% condition global_filters_and_parameters.datasource_filter %} date(${event_timestamp_date}) {% endcondition %};;


  always_filter: {
    filters: [
      event_rider_state_changed.event_timestamp_date: "last 7 days"
    ]
  }

  access_filter: {
    field: event_rider_state_changed.country_iso
    user_attribute: country_iso
  }

  join: global_filters_and_parameters {
    sql: ;;
  relationship: one_to_one
}

}
