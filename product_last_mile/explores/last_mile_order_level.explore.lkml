# Owner: Product Analytics, Bastian Gerstner

# Main Stakeholder:
# Last Mile Tech Team


include: "/**/*/event_delivery_state_updated.view.lkml"
include: "/**/*/event_trip_unstacked.view.lkml"
include: "/**/*/event_order_dispatching_state_changed.view.lkml"
include: "/**/global_filters_and_parameters.view.lkml"
include: "/**/hubs_ct.view.lkml"


explore: event_delivery_state_updated {
  from:  event_delivery_state_updated
  view_name: event_delivery_state_updated
  hidden: no

  label: "Last Mile - Order Level Events"
  description: "This explore provides information around deliveries"
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
    field: event_delivery_state_updated.country_iso
    user_attribute: country_iso
  }

  join: global_filters_and_parameters {
    sql: ;;
    relationship: one_to_one
  }

  join: event_trip_unstacked {
    view_label: "2 Event Order Unstacked"
    fields: [to_include_set*]
    sql_on: ${event_delivery_state_updated.order_id} = ${event_trip_unstacked.trip_order_ids}
    and {% condition global_filters_and_parameters.datasource_filter %}
      ${event_trip_unstacked.event_timestamp_date} {% endcondition %};;
    type: left_outer
    relationship: many_to_many
  }
  join: event_order_dispatching_state_changed {
    view_label: "3 Event Dispatching State Changed"
    fields: [to_include_set*]
    sql_on: ${event_delivery_state_updated.order_id} = ${event_order_dispatching_state_changed.order_id}
          and {% condition global_filters_and_parameters.datasource_filter %}
            ${event_order_dispatching_state_changed.event_timestamp_date} {% endcondition %};;
    type: left_outer
    relationship: many_to_many
  }
  join: hubs_ct {
    view_label: "4 Hub Dimensions"
    sql_on: ${event_delivery_state_updated.hub_code} = ${hubs_ct.hub_code} ;;
    type: left_outer
    relationship: many_to_one
  }

}
