include: "/*/**/cc_headcount_forecast_performance.view.lkml"
include: "/*/**/cc_agent_staffing_daily.view.lkml"
include: "/**/global_filters_and_parameters.view.lkml"



explore: cc_staffing {
  from: cc_headcount_forecast_performance
  view_name: cc_headcount_forecast_performance
  group_label: "Customer Care"
  view_label: "Headcount Forecast"
  label: "Agent Staffing"
  description: "This explore provides information on customer care agents staffing."

  sql_always_where: {% condition global_filters_and_parameters.datasource_filter %} ${cc_agent_staffing_daily.shift_date} {% endcondition %} ;;

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

  join: cc_agent_staffing_daily {
    view_label: "Shifts"
    sql_on: ${cc_agent_staffing_daily.block_starts_time}  = ${cc_headcount_forecast_performance.forecasted_time}
      and ${cc_agent_staffing_daily.cc_team} = ${cc_headcount_forecast_performance.team} ;;
    relationship: many_to_many
    type: left_outer
  }
}
