# Owner: Product Analytics, Pete Kell

# Main Stakeholder:
# - Hub Tech
# - Hub Operations

# Questions that can be answered
# - How pickers use the functionality of the picker app

include: "/**/daily_picker_events.view"
include: "/**/products.view"
include: "/**/global_filters_and_parameters.view.lkml"

explore: daily_picker_events {
  from:  daily_picker_events
  view_name: daily_picker_events

  label: "Daily Picker Events"
  description: "This explore provides an overview of the front-end events generated by the picker app."
  group_label: "Product - Hub Tech"

  access_filter: {
    field: daily_picker_events.country_iso
    user_attribute: country_iso
  }

sql_always_where:{% condition global_filters_and_parameters.datasource_filter %} ${event_timestamp_date} {% endcondition %};;

  always_filter: {
    filters: [
      global_filters_and_parameters.datasource_filter: "last 7 days",
      daily_picker_events.country_iso: "",
      daily_picker_events.hub_code: ""
    ]
  }

  join: global_filters_and_parameters {
    sql: ;;
    relationship: one_to_one
  }

  join: products {
    sql_on: ${daily_picker_events.sku} = ${products.product_sku} ;;
    type: left_outer
    relationship: many_to_one
  }
}
