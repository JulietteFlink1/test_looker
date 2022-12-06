# Owner: Product Analytics, Flavia Alvarez

# Main Stakeholder:
# - Hub Tech
# - Hub Operations

# Questions that can be answered
# - Amount of checks performed by hubs
# - Time spent on checks
# - Amount of corrections

include: "/**/daily_smart_inventory_checks.view"
include: "/**/products.view"
include: "/**/hubs_ct.view.lkml"
include: "/**/global_filters_and_parameters.view.lkml"
include: "/**/event_stock_check_finished.view.lkml"
include: "/**/employee_level_kpis.view.lkml"

explore: smart_inventory_checks {
  from:  daily_smart_inventory_checks
  view_name: smart_inventory_checks

  label: "Smart Inventory Checks"
  description: "This explore provides an overview of the backend events related to inventory checks and corrections."
  group_label: "Product - Hub Tech"

  access_filter: {
    field: smart_inventory_checks.country_iso
    user_attribute: country_iso
  }

  sql_always_where:{% condition global_filters_and_parameters.datasource_filter %} ${scheduled_date} {% endcondition %};;

  always_filter: {
    filters: [
      global_filters_and_parameters.datasource_filter: "last 7 days",
      smart_inventory_checks.country_iso: "",
      smart_inventory_checks.hub_code: ""
    ]
  }

  join: global_filters_and_parameters {
    sql: ;;
    relationship: one_to_one
  }

  join: event_stock_check_finished {
    view_label: "2 Stock Check Finished Event"
    fields: [to_include_set*]
    sql_on: ${smart_inventory_checks.table_uuid}=${event_stock_check_finished.check_id}
    and {% condition global_filters_and_parameters.datasource_filter %}
            ${event_stock_check_finished.event_timestamp_date} {% endcondition %} ;;
    type: left_outer
    relationship: one_to_one
  }

  join: products {
    view_label: "3 Product Dimensions"
    sql_on:
        ${smart_inventory_checks.sku} = ${products.product_sku} and
        ${smart_inventory_checks.country_iso} = ${products.country_iso}
        ;;
    type: left_outer
    relationship: many_to_one
  }

  join: hubs_ct {
    view_label: "4 Hub Dimensions"
    sql_on: ${smart_inventory_checks.hub_code} = ${hubs_ct.hub_code} ;;
    type: left_outer
    relationship: many_to_one
  }

  join: employee_level_kpis {
    view_label: "5 Employee Attributes"
    fields: [ employee_level_kpis.number_of_worked_hours
      , employee_level_kpis.number_of_assigned_hours
      , employee_level_kpis.number_of_no_show_hours]
    sql_on: cast(${employee_level_kpis.staff_number} as string)=${smart_inventory_checks.completed_by}
      and ${employee_level_kpis.shift_date}=${smart_inventory_checks.scheduled_date}
      and ${employee_level_kpis.hub_code}=${smart_inventory_checks.hub_code};;
    type: left_outer
    relationship: many_to_one
  }
}
