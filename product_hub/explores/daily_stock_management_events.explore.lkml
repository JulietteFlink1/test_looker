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
include: "/**/daily_stock_management_events_items_inbounded.view"
include: "/**/add_to_cart_times.view"


explore: daily_stock_management_events {
  from:  daily_stock_management_events
  view_name: daily_stock_management_events
  hidden: no

  label: "Daily Stock Management Events"
  description: "This explore provides an overview of all behavioural events generated on Stock Management app.
    This explore is built on front-end data, and is subset to the limitations of front-end tracking.
    We can not, and do not, expect 100% accuracy compared to the Orders & Order Line Items explores.
    We consider the Orders Explore to be the source of truth."
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
    sql: ;;
    relationship: one_to_one
  }

  join: daily_stock_management_events_items_inbounded {
    view_label: "Inventory Movement Id Times"
    fields: [daily_stock_management_events_items_inbounded.to_include_product*]
    sql_on: ${daily_stock_management_events_items_inbounded.inventory_movement_id}=${daily_stock_management_events.inventory_movement_id};;
    type: left_outer
    relationship: many_to_one
  }

  join: products {
    view_label: "Product Dimensions"
    sql_on:
        ${products.product_sku} = ${daily_stock_management_events.sku} and
        ${products.country_iso} = ${daily_stock_management_events.country_iso}
        ;;
    type: left_outer
    relationship: one_to_one
  }

  join: hubs_ct {
    view_label: "Hub Dimensions"
    sql_on: ${daily_stock_management_events.hub_code} = ${hubs_ct.hub_code} ;;
    type: left_outer
    relationship: many_to_one
  }

  join: add_to_cart_times {
    view_label: "Add to Cart Times"
    sql_on: ${add_to_cart_times.primary_key}=concat(${daily_stock_management_events.inventory_movement_id}, ${daily_stock_management_events.country_iso}, ${daily_stock_management_events.sku}, ${daily_stock_management_events.is_scanned_item});;
    type: left_outer
    relationship: one_to_many
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
