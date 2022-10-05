# Owner: Product Analytics, Bastian Gerstner

# Main Stakeholder:
# Last Mile Tech Team


include: "/**/*/event_delivery_state_updated.view.lkml"
include: "/**/global_filters_and_parameters.view.lkml"


explore: event_delivery_state_updated {
  from:  event_delivery_state_updated
  view_name: event_delivery_state_updated
  hidden: no

  label: "Event Delivery State Updated"
  description: "This explore provides information around deliveries"
  group_label: "Product - Last Mile"

  # implement both date filters:
  # received_at is due cost reduction given a table is partitioned by this dimensions
  # event_date filter will fitler for the desired time frame when events triggered

  sql_always_where:{% condition global_filters_and_parameters.datasource_filter %} date(${event_timestamp_date}) {% endcondition %};;


  always_filter: {
    filters: [
      event_delivery_state_updated.event_timestamp_date: "last 7 days"
    ]
  }

  join: global_filters_and_parameters {
    sql_on: ${global_filters_and_parameters.generic_join_dim} = TRUE ;;
    type: left_outer
    relationship: many_to_one
  }

}
