# Owner: Product Analytics, Bastian Gerstner

# Main Stakeholder:
# - Last Mile Tech Team

# Questions that can be answered
# - Questions around trip offers from auto assign

include: "/**/*/event_trip_offer_state_changed.view.lkml"
include: "/**/global_filters_and_parameters.view.lkml"


explore: event_trip_offer_state_changed {
  from:  event_trip_offer_state_changed
  view_name: event_trip_offer_state_changed
  hidden: no

  label: "Event Trip Offer State Changed"
  description: "This explore provides information around trip offers from auto assign"
  group_label: "Product - Last Mile"

  # implement both date filters:
  # received_at is due cost reduction given a table is partitioned by this dimensions
  # event_date filter will fitler for the desired time frame when events triggered

  sql_always_where:{% condition global_filters_and_parameters.datasource_filter %} date(${event_timestamp_date}) {% endcondition %};;


  always_filter: {
    filters: [
      event_trip_offer_state_changed.published_at_timestamp_date: "last 7 days"
    ]
  }

  access_filter: {
    field: event_trip_offer_state_changed.country_iso
    user_attribute: country_iso
  }

  join: global_filters_and_parameters {
    sql: ;;
  relationship: one_to_one
}
}
