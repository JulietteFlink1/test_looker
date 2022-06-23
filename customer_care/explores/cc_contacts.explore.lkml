include: "/*/**/cc_contacts.view.lkml"
include: "/*/**/cc_orders_hourly.view.lkml"
include: "/*/**/cc_contact_agents.view.lkml"
include: "/*/**/cc_headcount_forecast_performance.view.lkml"


explore: cc_contacts {
  from: cc_contacts
  view_name: cc_contacts
  group_label: "Customer Care"
  view_label: "* Intercom Contacts *"
  label: "Contacts & Agents"
  description: "This explore provides information on all Intercom chats"

  hidden: no

  access_filter: {
    field: cc_contacts.country_iso
    user_attribute: country_iso
  }

  always_filter: {
    filters: [
      cc_contacts.country_iso: "",
      cc_contacts.contact_created_date: "last 60 days"
    ]
  }

  join: cc_orders_hourly2 {
    from: cc_orders_hourly2
    view_label: "* Orders *"
    sql_on: timestamp_trunc(cast(${cc_contacts.contact_created_time} as timestamp),hour) = cast(${cc_orders_hourly2.order_timestamp_time} as timestamp)
      and ${cc_contacts.country_iso} = ${cc_orders_hourly2.country_iso};;
    relationship: many_to_one
    type: left_outer

  }

  join: cc_contact_agents {
    from: cc_contact_agents
    view_label: "* Agents *"
    sql_on:${cc_contact_agents.contact_id} = ${cc_contacts.contact_uuid}
      and ${cc_contacts.country_iso} = ${cc_contact_agents.country_iso};;
    relationship: one_to_many
    type: left_outer

  }

  join: cc_headcount_forecast_performance {
    from: cc_headcount_forecast_performance
    view_label: "* Headcount Forecast *"
    sql_on: ${cc_contacts.cc_team} = ${cc_headcount_forecast_performance.team}
        and ${cc_contacts.contact_created_date} = ${cc_headcount_forecast_performance.forecasted_date}            ;;
    relationship: many_to_one
    type: left_outer
  }
}
