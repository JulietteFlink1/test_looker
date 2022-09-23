# Owner: Product Analytics, Flavia Alvarez

# Main Stakeholder:
# - Hub Tech

# Questions that can be answered
# - Questions around behavioural events coming from Stock Management app

include: "/**/global_filters_and_parameters.view.lkml"
include: "/**/employee_level_kpis.view.lkml"
include: "/**/products.view.lkml"
include: "/**/hubs_ct.view.lkml"
include: "/**/daily_stock_management_events.view.lkml"
include: "/**/inventory_movement_id_times.view"

explore: daily_stock_management_events {
  from:  daily_stock_management_events
  view_name: daily_stock_management_events
  hidden: no

  label: "Daily Stock Management Events"
  description: "This explore provides an overview of all behavioural events generated on Stock Management app."
  group_label: "Product - Hub Tech"


  sql_always_where:{% condition global_filters_and_parameters.datasource_filter %}
    ${event_timestamp_date} {% endcondition %};;

  access_filter: {
    field: daily_stock_management_events.country_iso
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

  join: inventory_movement_id_times {
    view_label: "Inventory Movement Id Times"
    sql_on: ${inventory_movement_id_times.inventory_movement_id}=${daily_stock_management_events.inventory_movement_id};;
    type: left_outer
    relationship: one_to_one
  }

  join: products {
    view_label: "Product Dimensions"
    sql_on: ${products.product_sku} = ${daily_stock_management_events.sku};;
    type: left_outer
    relationship: one_to_one
  }

  join: hubs_ct {
    view_label: "Hub Dimensions"
    sql_on: ${daily_stock_management_events.hub_code} = ${hubs_ct.hub_code} ;;
    type: left_outer
    relationship: many_to_one
  }

  # join: employee_level_kpis {
  #   view_label: "7 Employee Attributes"
  #   fields: [ employee_level_kpis.number_of_worked_hours
  #     , employee_level_kpis.number_of_scheduled_hours
  #     , employee_level_kpis.number_of_no_show_hours]
  #   sql_on: cast(${employee_level_kpis.staff_number} as string)=${daily_stock_management_events.employee_id}
  #     and ${employee_level_kpis.shift_date}=${daily_stock_management_events.event_timestamp_date}
  #     and ${employee_level_kpis.hub_code}=${daily_stock_management_events.hub_code};;
  #   type: left_outer
  #   relationship: many_to_one
  # }
}
