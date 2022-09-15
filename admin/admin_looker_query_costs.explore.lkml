# Owner:
# Andreas Stüber
#
# Main Stakeholder:
# - Data Team (internal)

#
# Questions that can be answered
# - what looks and dashboards are:
#    1. most often used
#    2. scanning the most gigabyges
#    2. generating the highest costs

include: "/**/*.view"


explore: admin_looker_query_costs  {


  from: looker_usage_exports
  hidden: yes

  always_filter: {
    filters: [
      global_filters_and_parameters.datasource_filter: "last 7 days"
    ]
  }

  sql_always_where:
  -- filter the time for all big tables of this explore
  {% condition global_filters_and_parameters.datasource_filter %} ${admin_looker_query_costs.created_date} {% endcondition %}

  ;;

  join: global_filters_and_parameters {
    view_label: "Global Settings"
    sql:  ;;
    relationship: one_to_one
    type: inner
  }


  join: gcp_logs_parsed_for_looker {
    view_label: "GCP Logs"
    type: left_outer
    relationship: one_to_many
    sql_on:
      ${gcp_logs_parsed_for_looker.looker_history_slug} = ${admin_looker_query_costs.history_slug}
      and
      -- filter the time for all big tables of this explore
  {% condition global_filters_and_parameters.datasource_filter %} ${gcp_logs_parsed_for_looker.job_started_timestamp_date} {% endcondition %}
      ;;
  }
}
