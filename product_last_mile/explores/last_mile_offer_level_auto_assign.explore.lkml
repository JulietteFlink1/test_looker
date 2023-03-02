# Owner: Product Analytics, Bastian Gerstner

# Main Stakeholder:
# - Last Mile Tech Team

# Questions that can be answered
# - Questions around trip offers from auto assign

include: "/**/*/event_trip_offer_state_changed.view.lkml"
include: "/**/*/auto_assign_trip_state_changed_aggregates.view.lkml"
include: "/**/global_filters_and_parameters.view.lkml"
include: "/**/hubs_ct.view.lkml"


explore: event_trip_offer_state_changed {
  from:  event_trip_offer_state_changed
  view_name: event_trip_offer_state_changed
  hidden: no

  label: "Last Mile - Offer Level"
  description: "This explore provides information around trip offers from auto assign"
  group_label: "Product - Last Mile"

  # implement both date filters:
  # received_at is due cost reduction given a table is partitioned by this dimensions
  # event_date filter will fitler for the desired time frame when events triggered

  sql_always_where:{% condition global_filters_and_parameters.datasource_filter %} date(${event_timestamp_date}) {% endcondition %};;


  always_filter: {
    filters: [
      global_filters_and_parameters.datasource_filter: "last 7 days"
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
  join: auto_assign_trip_state_changed_aggregates {
    view_label: "2 Auto Assign Aggregates"
    fields: [to_include_set*]
    sql_on: ${event_trip_offer_state_changed.offer_id} = ${auto_assign_trip_state_changed_aggregates.offer_id}
          and ${event_trip_offer_state_changed.event_timestamp_date} = ${auto_assign_trip_state_changed_aggregates.event_date}
          and {% condition global_filters_and_parameters.datasource_filter %}
            ${auto_assign_trip_state_changed_aggregates.event_date} {% endcondition %};;
    type: left_outer
    relationship: many_to_one
  }
  join: hubs_ct {
    view_label: "3 Hub Dimensions"
    sql_on: ${event_trip_offer_state_changed.hub_code} = ${hubs_ct.hub_code} ;;
    type: left_outer
    relationship: many_to_one
  }
}
