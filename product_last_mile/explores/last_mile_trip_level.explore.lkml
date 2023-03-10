# Owner: Product Analytics, Bastian Gerstner

# Main Stakeholder:
# - Last Mile Tech Team

# Questions that can be answered
# - Questions around deliveries on trip level

include: "/**/*/event_trip_state_updated.view.lkml"
include: "/**/*/trip_state_changed_times.view.lkml"
include: "/**/hubs_ct.view.lkml"
include: "/**/global_filters_and_parameters.view.lkml"



explore: event_trip_state_updated {
  from:  event_trip_state_updated
  view_name: event_trip_state_updated
  hidden: no

  label: "Last Mile - Trip Level Events"
  description: "This explore provides information around trips"
  group_label: "Product - Last Mile"

  sql_always_where:{% condition global_filters_and_parameters.datasource_filter %} date(${event_timestamp_date}) {% endcondition %};;


  always_filter: {
    filters: [
      global_filters_and_parameters.datasource_filter: "last 7 days"
    ]
  }

  access_filter: {
    field: event_trip_state_updated.country_iso
    user_attribute: country_iso
  }

  join: global_filters_and_parameters {
    sql: ;;
    relationship: one_to_one
  }

  join: trip_state_changed_times {
    view_label: "2 Trip Time Calculations"
    fields: [to_include_set*]
    sql_on: ${event_trip_state_updated.trip_id} = ${trip_state_changed_times.trip_id}
            and {% condition global_filters_and_parameters.datasource_filter %}
                  ${trip_state_changed_times.event_date_date} {% endcondition %};;
    type: left_outer
    relationship: many_to_one
  }
  join: hubs_ct {
    view_label: "3 Hub Dimensions"
    sql_on: ${event_trip_state_updated.hub_code} = ${hubs_ct.hub_code} ;;
    type: left_outer
    relationship: many_to_one
  }
}
