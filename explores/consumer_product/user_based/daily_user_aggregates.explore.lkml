# Owner: Patricia Mitterova

# Main Stakeholder:
# - Consumer Product
# - Retail / Commercial team

# Questions that can be answered
# - user based conversions

include: "/views/bigquery_tables/curated_layer/consumer_product/daily_user_aggregates.view"
include: "/**/global_filters_and_parameters.view.lkml"

explore: daily_user_aggregates {
  from:  daily_user_aggregates
  view_name: daily_user_aggregates
  hidden: yes

  label: "Daily User Aggregates"
  description: "This explore provides an overview of all behavioural events generated on Flink App and Web"
  group_label: "Consumer Product"

  sql_always_where:{% condition global_filters_and_parameters.datasource_filter %} ${event_date} {% endcondition %};;

  access_filter: {
    field: country_iso
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
