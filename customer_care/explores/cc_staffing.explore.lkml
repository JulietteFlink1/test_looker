include: "/*/**/cc_headcount_forecast_performance.view.lkml"
include: "/*/**/cc_agent_staffing_half_hourly.view.lkml"
include: "/**/global_filters_and_parameters.view.lkml"



explore: cc_staffing {
  from: cc_headcount_forecast_performance
  view_name: cc_headcount_forecast_performance
  group_label: "Customer Care"
  view_label: "Headcount Forecast"
  label: "Agent Staffing"
  description: "This explore provides information on customer care agents staffing."

  sql_always_where: {% condition global_filters_and_parameters.datasource_filter %} ${cc_agent_staffing_half_hourly.shift_date} {% endcondition %} ;;

  always_filter: {
    filters: [
      global_filters_and_parameters.datasource_filter: "last 7 days"
    ]
  }

  join: global_filters_and_parameters {
    sql: ;;
  relationship: one_to_one
  fields: [datasource_filter]
  }

  join: cc_agent_staffing_half_hourly {
    view_label: "Shifts"
    sql_on: ${cc_agent_staffing_half_hourly.block_starts_time}  = ${cc_headcount_forecast_performance.forecasted_time}
      and ${cc_agent_staffing_half_hourly.cc_team} = ${cc_headcount_forecast_performance.team} ;;
    relationship: many_to_many
    type: left_outer
  }
}
