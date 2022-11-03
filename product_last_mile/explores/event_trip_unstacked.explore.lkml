# Owner: Product Analytics, Bastian Gerstner

# Main Stakeholder:
# - Last Mile Tech Team

# Questions that can be answered
# - Questions around manual unstacking trips

include: "/product_last_mile/views/event_trip_unstacked.view.lkml"
include: "/**/global_filters_and_parameters.view.lkml"


explore: event_trip_unstacked {
  from:  event_trip_unstacked
  view_name: event_trip_unstacked
  hidden: no

  label: "Event Trip Unstacked"
  description: "This explore provides an overview manual unstacks performed in the Hubs"
  group_label: "Product - Last Mile"

  # implement both date filters:
  # received_at is due cost reduction given a table is partitioned by this dimensions
  # event_date filter will fitler for the desired time frame when events triggered

  sql_always_where:{% condition global_filters_and_parameters.datasource_filter %} date(${event_timestamp_date}) {% endcondition %};;


  always_filter: {
    filters: [
      event_trip_unstacked.published_at_timestamp_date: "last 7 days"
    ]
  }

  join: global_filters_and_parameters {
    sql: ;;
    relationship: one_to_one
  }
}
