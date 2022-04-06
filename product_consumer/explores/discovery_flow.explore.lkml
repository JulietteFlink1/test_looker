# Owner: Patricia Mitterova

# Main Stakeholder:
# - Consumer Product
# - Retail / Commercial team

# Questions that can be answered
# - Questions around behavioural events with country and device drill downs

include: "/**/discovery_flow.view"
include: "/**/global_filters_and_parameters.view.lkml"

explore: discovery_flow {
  from:  discovery_flow
  view_name: discovery_flow
  hidden: yes

  label: "Discovery Flow"
  description: "This explore provides an overview of all behavioural events generated on Flink App and Web"
  group_label: "Consumer Product"

  # implement both date filters:
  # received_at is due cost reduction given a table is partitioned by this dimensions
  # event_date filter will fitler for the desired time frame when events triggered

  sql_always_where:{% condition global_filters_and_parameters.datasource_filter %} ${received_at_date_date} {% endcondition %}
    and {% condition global_filters_and_parameters.datasource_filter %} ${event_date} {% endcondition %};;

  access_filter: {
    field: discovery_flow.country_iso
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
