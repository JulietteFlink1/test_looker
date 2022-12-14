# Owner: Product Analytics, Galina Larina

# Main Stakeholder:
# - Consumer Product

# Questions that can be answered
# - number of users with orders per hour

include: "/product_consumer/views/bigquery_reporting/daily_intraday_active_user_aggregates.view"
include: "/**/global_filters_and_parameters.view.lkml"
include: "/**/hubs_ct.view.lkml"


explore: daily_intraday_active_user_aggregates {
  from:  daily_intraday_active_user_aggregates
  view_name: daily_intraday_active_user_aggregates
  hidden: no

  label: "Daily Intraday Active User Aggregates"
  description: "This explore provided an aggregated number of active users and number of active users who placed the order per hour,
  for the current day and the same day in the previous week.
  This model is built on front-end behavioural tracking data, and is not filtered or cleaned in the same as our standard daily reporting.
  Please only use this model to track intra-day activity & CVR."
  group_label: "Product - Consumer"

  sql_always_where:{% condition global_filters_and_parameters.datasource_filter %} ${event_date_date} {% endcondition %}
    and ${country_iso} is not null;;

  access_filter: {
    field: country_iso
    user_attribute: country_iso
  }

  always_filter: {
    filters: [
      global_filters_and_parameters.datasource_filter: "last 8 days"
    ]
  }

  join: global_filters_and_parameters {
    sql: ;;
  relationship: one_to_one
  }

  join: hubs_ct {
    view_label: "8 Hub Dimensions"
    sql_on: ${daily_intraday_active_user_aggregates.hub_code} = ${hubs_ct.hub_code} ;;
    type: left_outer
    relationship: many_to_one
  }
}
