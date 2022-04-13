# Owner: Patricia Mitterova

# Main Stakeholder:
# - Consumer Product
# - Retail / Commercial team

# Questions that can be answered
# - user based conversions

include: "/**/daily_user_aggregates.view"
include: "/**/global_filters_and_parameters.view.lkml"

explore: daily_user_aggregates {
  from:  daily_user_aggregates
  view_name: daily_user_aggregates
  hidden: no

  label: "Daily User Aggregates"
  description: "This explore provides an aggregated overview of Flink active users, including monetary values and conversion metrics (both App & Web)"
  group_label: "Consumer Product"

  sql_always_where:{% condition global_filters_and_parameters.datasource_filter %} ${event_date_at_date} {% endcondition %}
                    and ${event_date_at_date}<= CURRENT_DATE();;
#                   Adding event_date<= current_date to avoid displaying the future events

  access_filter: {
    field: country_iso
    user_attribute: country_iso
  }

  always_filter: {
    filters: [
      global_filters_and_parameters.datasource_filter: "last 7 days",
      daily_user_aggregates.country_iso: "",
      daily_user_aggregates.hub_code: ""
    ]
  }

  join: global_filters_and_parameters {
    sql_on: ${global_filters_and_parameters.generic_join_dim} = TRUE ;;
    type: left_outer
    relationship: many_to_one
  }
}
