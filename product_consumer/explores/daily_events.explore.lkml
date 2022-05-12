# Owner: Product Analytics, Patricia Mitterova

# Main Stakeholder:
# - Consumer Product
# - Retail / Commercial team

# Questions that can be answered
# - Questions around behavioural events with country and device drill downs

include: "/product_consumer/views/bigquery_curated/daily_events.view.lkml"
include: "/**/global_filters_and_parameters.view.lkml"

explore: daily_events {
  from:  daily_events
  view_name: daily_events
  hidden: no

  label: "Daily Events"
  description: "This explore provides an overview of all behavioural events generated on Flink App and Web"
  group_label: "Consumer Product"

  # implement both date filters:
    # received_at is due cost reduction given a table is partitioned by this dimensions
    # event_date filter will fitler for the desired time frame when events triggered

  sql_always_where:{% condition global_filters_and_parameters.datasource_filter %} ${event_date} {% endcondition %};;

  access_filter: {
    field: daily_events.country_iso
    user_attribute: country_iso
  }

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
