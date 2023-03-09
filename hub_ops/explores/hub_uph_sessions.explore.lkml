include: "/**/hub_uph_sessions.view"
include: "/**/hubs_ct.view"
include: "/**/global_filters_and_parameters.view"
include: "/**/hub_monthly_orders.view"
include: "/**/shyftplan_riders_pickers_hours_clean.view"


explore: hub_uph_sessions {
  view_name: hub_uph_sessions
  view_label: "Hub UPH Sessions"
  group_label: "Hub Ops"
  label: "Hub UPH Sessions"
  description: "This Explore is on employee, shift and session level. It is based on Hub One events and Quinyx data. It contains hub productivity metrics (UPH) as well as the breakdown of hub worked hours between direct and idle."
  sql_always_where: {% condition global_filters_and_parameters.datasource_filter %} ${hub_uph_sessions.shift_date} {% endcondition %} ;;

  always_filter: {
    filters: [
              global_filters_and_parameters.datasource_filter: "last 7 days",
              hub_uph_sessions.country_iso: "",
              hub_uph_sessions.hub_code: "",
              hub_uph_sessions.position_name: "ops associate, picker",
              hub_uph_sessions.quinyx_badge_number: "",
              hub_uph_sessions.is_idle_session_more_than_2_hours: "no"
              ]
  }

  access_filter: {
    field: hub_uph_sessions.country_iso
    user_attribute: country_iso
  }

  join: global_filters_and_parameters {
    sql: ;;
    relationship: one_to_one
  }

  join: hubs_ct {
    view_label: "Hubs"
    sql_on: ${hubs_ct.hub_code} = ${hub_uph_sessions.hub_code};;
    relationship: many_to_one
    type: left_outer
  }

  join: hub_monthly_orders {
    view_label: "Hubs"
    sql_on:
      ${hub_uph_sessions.hub_code} = ${hub_monthly_orders.hub_code} and
      date_trunc(${hub_uph_sessions.shift_date},month) = ${hub_monthly_orders.created_month} ;;
    relationship: many_to_one
    type: left_outer
  }

  join: shyftplan_riders_pickers_hours_clean {
    view_label: "Hub UPH Sessions"
    sql_on:
      ${hub_uph_sessions.hub_code} = ${shyftplan_riders_pickers_hours_clean.hub_name}
      and ${hub_uph_sessions.shift_date} = ${shyftplan_riders_pickers_hours_clean.shift_date};;
    fields: [
      shyftplan_riders_pickers_hours_clean.ops_associate_utr,
      shyftplan_riders_pickers_hours_clean.hub_staff_utr,
      shyftplan_riders_pickers_hours_clean.position_name
    ]
    relationship: many_to_one
    type: left_outer
  }

  }
