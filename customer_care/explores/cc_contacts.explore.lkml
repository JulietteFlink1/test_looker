include: "/*/**/cc_contacts.view.lkml"
include: "/*/**/orders.view.lkml"
include: "/*/**/products.view.lkml"
include: "/*/**/orderline.view.lkml"
include: "/*/**/cc_orders_hourly.view.lkml"
include: "/*/**/cc_contact_agents.view.lkml"
include: "/*/**/cc_headcount_forecast_performance.view.lkml"
include: "/*/**/cc_agent_staffing_half_hourly.view.lkml"
include: "/**/global_filters_and_parameters.view.lkml"



explore: cc_contacts {
  from: cc_contacts
  view_name: cc_contacts
  group_label: "Customer Care"
  view_label: "Intercom Contacts"
  label: "Contacts & Agents"
  description: "This explore provides information on all Intercom chats"

  sql_always_where: {% condition global_filters_and_parameters.datasource_filter %} ${cc_contacts.contact_created_date} {% endcondition %} ;;

  hidden: no

  access_filter: {
    field: cc_contacts.country_iso
    user_attribute: country_iso
  }

  always_filter: {
    filters: [
      cc_contacts.country_iso: "",
      global_filters_and_parameters.datasource_filter: "last 7 days"
    ]
  }
#  ,
  # cc_contacts.contact_created_date: "last 60 days"
  join: cc_orders_hourly2 {
    view_label: "Orders"
    sql_on: timestamp_trunc(cast(${cc_contacts.contact_created_time} as timestamp),hour) = cast(${cc_orders_hourly2.order_timestamp_time} as timestamp)
      and ${cc_contacts.country_iso} = ${cc_orders_hourly2.country_iso}
      and {% condition global_filters_and_parameters.datasource_filter %} ${cc_orders_hourly2.order_timestamp_date} {% endcondition %};;
    relationship: many_to_one
    type: left_outer
  }

  join: global_filters_and_parameters {
    sql: ;;
    relationship: one_to_one
  }

  join: cc_headcount_forecast_performance {
    view_label: "Headcount Forecast"
    sql_on: ${cc_contacts.cc_team} = ${cc_headcount_forecast_performance.team}
        and ${cc_contacts.contact_created_date} = ${cc_headcount_forecast_performance.forecasted_date}
        and {% condition global_filters_and_parameters.datasource_filter %} ${cc_headcount_forecast_performance.forecasted_date} {% endcondition %};;
    relationship: many_to_one
    type: left_outer
  }

  join: cc_agent_staffing_half_hourly {
    view_label: "Shifts"
    sql_on:${cc_agent_staffing_half_hourly.shift_date} = ${cc_contacts.last_close_date}
      and ${cc_agent_staffing_half_hourly.agent_email} = ${cc_contacts.agent_email}
      and {% condition global_filters_and_parameters.datasource_filter %} ${cc_agent_staffing_half_hourly.shift_date} {% endcondition %};;
    relationship: many_to_many
    type: left_outer
    fields: [cc_agent_staffing_half_hourly.cc_contacts_fields*]
  }

  join: orders {
    view_label: "Orders"
    sql_on: ${orders.order_number} = ${cc_contacts.order_number}
        and {% condition global_filters_and_parameters.datasource_filter %} ${orders.created_date} {% endcondition %};;
    relationship: many_to_one
    type: left_outer
  }

  join: orderline {
    view_label: "Order Lineitems"
    sql_on: ${orderline.order_uuid}    = ${orders.order_uuid}
            and {% condition global_filters_and_parameters.datasource_filter %} ${orderline.created_date} {% endcondition %}
      ;;
    relationship: one_to_many
    type: left_outer
  }

  join: products {
    view_label: "Product Data (CT)"
    sql_on:
        ${products.product_sku} = ${orderline.product_sku} and
        ${products.country_iso} = ${orderline.country_iso}
        ;;
    relationship: many_to_one
    type: left_outer
  }


}
