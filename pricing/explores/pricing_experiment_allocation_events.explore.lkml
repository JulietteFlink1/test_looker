# Owner: Pricing, Kristina Voloshina

# Questions that can be answered
# - pricing experiment performance (user based conversions and order value)

include: "/**/orders_cl.explore"
include: "/**/product_consumer/views/bigquery_reporting/daily_user_aggregates.view"
include: "/**/global_filters_and_parameters.view.lkml"
include: "/core/views/bq_curated/orders.view.lkml"

explore: pricing_experiment_allocation_events {

  extends: [daily_user_aggregates]

  group_label: "Pricing"
  label: "Pricing Experiments"
  hidden: no

  sql_always_where:{% condition global_filters_and_parameters.datasource_filter %} ${daily_user_aggregates.event_date_at_date} {% endcondition %};;

  access_filter: {
    field: pricing_experiment_allocation_events.country_iso
    user_attribute: country_iso
  }

  always_filter: {
    filters: [
      global_filters_and_parameters.datasource_filter: "last 7 days",
      pricing_experiment_allocation_events.country_iso: ""
    ]
  }

  join: global_filters_and_parameters {
    sql: ;;
  relationship: one_to_one
  }

  join: pricing_experiment_allocation_events {
    sql_on:${pricing_experiment_allocation_events.event_date} = ${daily_user_aggregates.event_date_at_date}
      and ${pricing_experiment_allocation_events.anonymous_id} = ${daily_user_aggregates.user_uuid}
       and {% condition global_filters_and_parameters.datasource_filter %} ${daily_user_aggregates.event_date_at_date} {% endcondition %};;
    type: full_outer
    relationship:  one_to_many  ##in pricing_experiment_allocation_events for one event date we can have several rows if customer placed more than one order
  }

  join: orders {
    sql_on: ${pricing_experiment_allocation_events.order_uuid} = ${orders.order_uuid} ;;
    type: left_outer
    relationship: one_to_one
  }

  }
