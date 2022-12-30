# Owner: Product Analytics, Flavia Alvarez

# Main Stakeholder:
# - Hub Tech

# Questions that can be answered
# - Questions around behavioural events coming from Hub One app

include: "/**/global_filters_and_parameters.view.lkml"
include: "/**/employee_level_kpis.view.lkml"
include: "/**/products.view.lkml"
include: "/**/hubs_ct.view.lkml"
include: "/**/orders.view.lkml"
include: "/**/daily_hub_staff_events.view.lkml"
include: "/**/event_order_progressed.view.lkml"
include: "/**/event_order_state_updated.view.lkml"
include: "/**/event_container_assigned.view.lkml"
include: "/**/event_container_assignment_skipped.view.lkml"
include: "/**/event_login_completed.view.lkml"
include: "/**/event_logout_completed.view.lkml"
include: "/**/hub_one_picking_times.view.lkml"
include: "/**/event_stock_check_started.view.lkml"
include: "/**/event_stock_check_finished.view.lkml"
include: "/**/event_inbound_state_updated.view.lkml"
include: "/**/event_inbound_progressed.view.lkml"
include: "/product_consumer/views/bigquery_reporting/daily_violations_aggregates.view.lkml"
include: "/**/daily_smart_inventory_checks.view"

explore: daily_hub_staff_events {
  from:  daily_hub_staff_events
  view_name: daily_hub_staff_events
  hidden: no

  label: "Daily Hub Staff Events"
  description: "This explore provides an overview of all behavioural events generated on Hub One.
    This explore is built on front-end data, and is subset to the limitations of front-end tracking.
    We can not, and do not, expect 100% accuracy compared to the back-end based explores such as Orders,
    Orders & Lineitems or Inbound Outbound Kpi Report.
    We consider the back-end based Explores to be the source of truth."
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
    sql: ;;
    relationship: one_to_one
  }

  join: event_order_progressed {
    view_label: "2 Event: Order Progressed"
    fields: [to_include_set*]
    sql_on: ${event_order_progressed.event_uuid} = ${daily_hub_staff_events.event_uuid}
      and {% condition global_filters_and_parameters.datasource_filter %}
        ${event_order_progressed.event_timestamp_date} {% endcondition %};;
    type: left_outer
    relationship: one_to_one
  }

  join: event_order_state_updated {
    view_label: "3 Event: Order State Updated"
    fields: [to_include_set*]
    sql_on: ${event_order_state_updated.event_uuid} = ${daily_hub_staff_events.event_uuid}
      and {% condition global_filters_and_parameters.datasource_filter %}
        ${event_order_state_updated.event_timestamp_date} {% endcondition %};;
    type: left_outer
    relationship: one_to_one
  }

#Coalesce in the join is to be able to see times and quantities processed at order_id and sku level
  join: hub_one_picking_times {
    view_label: "3 Event: Order State Updated"
    fields: [to_include_set*]
    sql_on: ${hub_one_picking_times.order_id} = coalesce(${event_order_state_updated.order_id},${event_order_progressed.order_id})
      and {% condition global_filters_and_parameters.datasource_filter %}
        ${hub_one_picking_times.event_date} {% endcondition %};;
    type: left_outer
    relationship: one_to_one
  }

  join: event_container_assigned {
    view_label: "4 Handover Process"
    fields: [to_include_set*]
    sql_on: ${event_container_assigned.event_uuid} = ${daily_hub_staff_events.event_uuid}
      and {% condition global_filters_and_parameters.datasource_filter %}
        ${event_container_assigned.event_timestamp_date} {% endcondition %};;
    type: left_outer
    relationship: one_to_one
  }

  join: event_container_assignment_skipped {
    view_label: "4 Handover Process"
    fields: [to_include_set*]
    sql_on: ${event_container_assignment_skipped.event_uuid} = ${daily_hub_staff_events.event_uuid}
      and {% condition global_filters_and_parameters.datasource_filter %}
        ${event_container_assignment_skipped.event_timestamp_date} {% endcondition %};;
    type: left_outer
    relationship: one_to_one
  }

  join: event_login_completed {
    view_label: "5 Login/Logout Completed"
    fields: [to_include_set*]
    sql_on: ${event_login_completed.event_uuid} = ${daily_hub_staff_events.event_uuid}
      and {% condition global_filters_and_parameters.datasource_filter %}
        ${event_login_completed.event_timestamp_date} {% endcondition %};;
    type: left_outer
    relationship: one_to_one
  }

  join: event_logout_completed {
    view_label: "5 Login/Logout Completed"
    fields: [to_include_set*]
    sql_on: ${event_logout_completed.event_uuid} = ${daily_hub_staff_events.event_uuid}
      and {% condition global_filters_and_parameters.datasource_filter %}
        ${event_logout_completed.event_timestamp_date} {% endcondition %};;
    type: left_outer
    relationship: one_to_one
  }

  join: event_stock_check_started {
    view_label: "6 Stock Check Started/ Finished"
    fields: [to_include_set*]
    sql_on: ${event_stock_check_started.event_uuid} = ${daily_hub_staff_events.event_uuid}
      and {% condition global_filters_and_parameters.datasource_filter %}
        ${event_stock_check_started.event_timestamp_date} {% endcondition %};;
    type: left_outer
    relationship: one_to_one
  }

  join: event_stock_check_finished {
    view_label: "6 Stock Check Started/ Finished"
    fields: [to_include_set*]
    sql_on: ${event_stock_check_finished.event_uuid} = ${daily_hub_staff_events.event_uuid}
      and {% condition global_filters_and_parameters.datasource_filter %}
        ${event_stock_check_finished.event_timestamp_date} {% endcondition %};;
    type: left_outer
    relationship: one_to_one
  }

  join: event_inbound_state_updated {
    view_label: "7 Event: Inbound State Updated"
    fields: [to_include_dimensions*]
    sql_on: ${event_inbound_state_updated.event_uuid} = ${daily_hub_staff_events.event_uuid}
      and {% condition global_filters_and_parameters.datasource_filter %}
        ${event_inbound_state_updated.event_timestamp_date} {% endcondition %};;
    type: left_outer
    relationship: one_to_one
  }

  join: event_inbound_progressed {
    view_label: "8 Event: Inbound Progressed"
    fields: [to_include_set*]
    sql_on: ${event_inbound_progressed.event_uuid} = ${daily_hub_staff_events.event_uuid}
      and {% condition global_filters_and_parameters.datasource_filter %}
        ${event_inbound_progressed.event_timestamp_date} {% endcondition %};;
    type: left_outer
    relationship: one_to_one
  }

  join: products {
    view_label: "9 Product Dimensions"
    fields: [product_name, category, subcategory, erp_category, erp_subcategory]
    sql_on: ${products.product_sku} = ${event_order_progressed.product_sku};;
    type: left_outer
    relationship: one_to_one
  }

  join: hubs_ct {
      view_label: "9 Hub Dimensions"
      sql_on: ${daily_hub_staff_events.hub_code} = ${hubs_ct.hub_code} ;;
      type: left_outer
      relationship: many_to_one
    }

  join: employee_level_kpis {
    view_label: "9 Employee Attributes"
    fields: [ employee_level_kpis.number_of_worked_hours
            , employee_level_kpis.number_of_assigned_hours
            , employee_level_kpis.number_of_no_show_hours]
    sql_on: cast(${employee_level_kpis.staff_number} as string)=${daily_hub_staff_events.quinyx_badge_number}
      and ${employee_level_kpis.shift_date}=${daily_hub_staff_events.event_timestamp_date}
      and ${employee_level_kpis.hub_code}=${daily_hub_staff_events.hub_code};;
    type: left_outer
    relationship: many_to_one
  }

  join: orders {
    view_label: "9 Order Dimensions"
    fields: [ is_external_order
            , order_picker_accepted_timestamp
            , order_packed_timestamp
            , is_click_and_collect_order]
    sql_on: ${event_order_progressed.order_id} = ${orders.id} ;;
    type: left_outer
    relationship: many_to_one
  }

  join: daily_violations_aggregates {
    view_label: "91 Event: Violation Generated" ##to unhide change the label to: Event: Violation Generated
    fields: [daily_violations_aggregates.violated_event_name , daily_violations_aggregates.number_of_violations]
    sql_on: ${daily_hub_staff_events.event_text} = ${daily_violations_aggregates.violated_event_name}
          and ${daily_hub_staff_events.event_date}=${daily_violations_aggregates.event_date}
          and ${daily_violations_aggregates.domain}='hub staff'
          and {% condition global_filters_and_parameters.datasource_filter %}
            ${daily_violations_aggregates.event_date} {% endcondition %};;
    type: left_outer
    relationship: many_to_many
  }

  join: daily_smart_inventory_checks {
    view_label: "92 Smart Inventory Checks"
    sql_on: ${daily_smart_inventory_checks.scheduled_date} = ${daily_hub_staff_events.event_date}
          and ${daily_smart_inventory_checks.hub_code}=${daily_hub_staff_events.hub_code}
          and ${daily_smart_inventory_checks.sku}=${event_order_progressed.product_sku}
          and {% condition global_filters_and_parameters.datasource_filter %}
            ${daily_smart_inventory_checks.scheduled_date} {% endcondition %};;
    type: left_outer
    relationship: many_to_many
  }
}
