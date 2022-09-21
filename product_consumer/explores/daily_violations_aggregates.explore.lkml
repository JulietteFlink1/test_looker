# Owner: Product Analytics, Flavia Alvarez
# Main Stakeholder:
# - Consumer Product
# - Hub Tech
# - Product Analytics
# Questions that can be answered
# - Questions around tracking events quality from Consumer apps and Hub One app
include: "/product_consumer/views/bigquery_reporting/daily_violations_aggregates.view"
include: "/product_consumer/views/bigquery_curated/daily_events.view"
include: "/**/global_filters_and_parameters.view.lkml"
explore: daily_violations_aggregates {
  from:  daily_violations_aggregates
  view_name: daily_violations_aggregates
  hidden: yes
  label: "Daily Violations Aggregates"
  description: "This explore provides info on the segment violations generated in Consumer apps and in Hub One app"
  group_label: "Product - Consumer"
  sql_always_where:{% condition global_filters_and_parameters.datasource_filter %} ${event_date} {% endcondition %};;
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
}
