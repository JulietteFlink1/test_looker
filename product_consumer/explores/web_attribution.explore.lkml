# Owner: Product Analytics, Natalia Wierzbowska

# Main Stakeholder:
# - Consumer Product

include: "/**/*/web_attribution.view.lkml"
include: "/**/global_filters_and_parameters.view.lkml"

explore: web_attribution {
  from:  web_attribution
  view_name: web_attribution
  hidden: yes

  label: "Web Attribution Model"
  description: "This explore provides web attribution model for a daily active user on Flink Web"
  group_label: "Product - Consumer"

  # implement both date filters:
  # received_at is due cost reduction given a table is partitioned by this dimensions
  # event_date filter will fitler for the desired time frame when events triggered

  # sql_always_where: {% condition global_filters_and_parameters.datasource_filter %} ${event_date} {% endcondition %};;

  always_filter: {
    filters: [
      web_attribution.event_date_date: "last 7 days"
    ]
  }

  # join: global_filters_and_parameters {
  #   sql_on: ${global_filters_and_parameters.generic_join_dim} = TRUE ;;
  #   type: left_outer
  #   relationship: many_to_one
  # }
}
