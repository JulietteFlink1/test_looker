# Owner: Product Analytics, Flavia Alvarez

# Main Stakeholder:
# - Hub Tech

# Questions that can be answered
# - Questions around behavioural events coming from Hub One app

include: "/**/global_filters_and_parameters.view.lkml"
include: "/**/employee_level_kpis.view.lkml"
include: "/views/bigquery_tables/curated_layer/products.view.lkml"
include: "/views/bigquery_tables/curated_layer/hubs_ct.view.lkml"
include: "/views/bigquery_tables/curated_layer/orders.view.lkml"
include: "/product_hub/views/bigquery_curated/daily_hub_staff_events.view.lkml"
include: "/product_hub/views/bigquery_curated/event_order_progressed.view.lkml"
include: "/product_hub/views/bigquery_curated/event_order_state_updated.view.lkml"
include: "/product_hub/views/sql_derived_tables/picking_times.view.lkml"

explore: daily_hub_staff_events {
  from:  daily_hub_staff_events
  view_name: daily_hub_staff_events
  hidden: no

  label: "Daily Hub Staff Events"
  description: "This explore provides an overview of all behavioural events generated on Hub One."
  group_label: "Product - Hub Tech"


  sql_always_where:{% condition global_filters_and_parameters.datasource_filter %}
    ${event_timestamp_date} {% endcondition %};;

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
    view_label: "" # This is to hide this view on the explore
    sql_on: ${global_filters_and_parameters.generic_join_dim} = TRUE ;;
    type: left_outer
    relationship: many_to_one
  }

  join: event_order_progressed {
    view_label: "2 Event: Order Progressed"
    fields: [to_include_dimensions*, to_include_measures*]
    sql_on: ${event_order_progressed.event_uuid} = ${daily_hub_staff_events.event_uuid}
      and {% condition global_filters_and_parameters.datasource_filter %}
        ${event_order_progressed.event_timestamp_date} {% endcondition %};;
    type: left_outer
    relationship: one_to_one
  }

  join: event_order_state_updated {
    view_label: "3 Event: Order State Updated"
    fields: [to_include_dimensions*, to_include_measures*]
    sql_on: ${event_order_state_updated.event_uuid} = ${daily_hub_staff_events.event_uuid}
      and {% condition global_filters_and_parameters.datasource_filter %}
        ${event_order_state_updated.event_timestamp_date} {% endcondition %};;
    type: left_outer
    relationship: one_to_one
  }

  join: picking_times {
    view_label: "4 Picking Times"
    sql_on: ${picking_times.order_id} = ${event_order_state_updated.order_id}
      and {% condition global_filters_and_parameters.datasource_filter %}
        ${picking_times.event_timestamp_date} {% endcondition %};;
    type: left_outer
    relationship: one_to_one
  }

  join: products {
    view_label: "5 Product Dimensions"
    fields: [product_name, category]
    sql_on: ${products.product_sku} = ${event_order_progressed.product_sku};;
    type: left_outer
    relationship: one_to_one
  }

  join: hubs_ct {
      view_label: "6 Hub Dimensions"
      sql_on: ${daily_hub_staff_events.hub_code} = ${hubs_ct.hub_code} ;;
      type: left_outer
      relationship: many_to_one
    }

  join: employee_level_kpis {
    view_label: "7 Employee Attributes"
    fields: [ employee_level_kpis.number_of_worked_hours
            , employee_level_kpis.number_of_scheduled_hours
            , employee_level_kpis.number_of_no_show_hours]
    sql_on: cast(${employee_level_kpis.staff_number} as string)=${daily_hub_staff_events.quinyx_badge_number}
      and ${employee_level_kpis.shift_date}=${daily_hub_staff_events.event_timestamp_date}
      and ${employee_level_kpis.hub_code}=${daily_hub_staff_events.hub_code};;
    type: left_outer
    relationship: many_to_one
  }

  join: orders {
    view_label: "8 Order Dimensions"
    fields: [orders.is_external_order]
    sql_on: ${event_order_progressed.order_id} = ${orders.id} ;;
    type: left_outer
    relationship: many_to_one
  }
}
