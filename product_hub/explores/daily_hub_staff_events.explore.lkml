# Owner: Product Analytics, Flavia Alvarez

# Main Stakeholder:
# - Hub Tech

# Questions that can be answered
# - Questions around behavioural events coming from Hub One app

include: "/**/global_filters_and_parameters.view.lkml"
include: "/product_hub/views/bigquery_curated/daily_hub_staff_events.view.lkml"
include: "/product_hub/views/bigquery_curated/event_order_progressed.view.lkml"
include: "/product_hub/views/bigquery_curated/event_order_state_updated.view.lkml"

explore: daily_hub_staff_events {
  from:  daily_hub_staff_events
  view_name: daily_hub_staff_events
  hidden: no

  label: "Daily Hub Staff Events"
  description: "This explore provides an overview of all behavioural events generated on Hub One."
  group_label: "Consumer Hub"


  sql_always_where:{% condition global_filters_and_parameters.datasource_filter %} ${event_date} {% endcondition %};;

  access_filter: {
    field: daily_hub_staff_events.country_iso
    user_attribute: country_iso
  }

  always_filter: {
    filters: [
      global_filters_and_parameters.datasource_filter: "last 7 days"
    ]
  }

  join: global_filters_and_parameters {
    sql_on: ${global_filters_and_parameters.generic_join_dim} = TRUE ;;
    type: left_outer
    relationship: many_to_one
  }

  join: event_order_progressed {
    view_label: "Event: Order Progressed"
    fields: [event_dimensions*]
    sql_on: ${event_order_progressed.event_uuid} = ${daily_hub_staff_events.event_uuid}
      and {% condition global_filters_and_parameters.datasource_filter %} ${event_order_progressed.event_date} {% endcondition %};;
    type: left_outer
    relationship: one_to_one
  }

  join: event_order_state_updated {
    view_label: "Event: Order State Updated"
    fields: [event_dimensions*]
    sql_on: ${event_order_state_updated.event_uuid} = ${daily_hub_staff_events.event_uuid}
      and {% condition global_filters_and_parameters.datasource_filter %} ${event_order_state_updated.event_date} {% endcondition %};;
    type: left_outer
    relationship: one_to_one
  }
}
