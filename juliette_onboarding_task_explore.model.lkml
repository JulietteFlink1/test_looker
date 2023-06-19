# Owned by: Juliette Hampton
# Main stakeholders: Juliette Hampton, Mustaf Ibishi, James Davies, Andreas Stueber
# Questions that can be answered: Am I fit to build views and Explores ¯\_(ツ)_/¯

connection: "bq_flat_rate_slots"

include: "juliette_onboarding_task.view.lkml"
include: "/**/global_filters_and_parameters.view"


explore: juliette_onboarding_task {

  from: juliette_onboarding_task
  view_name: juliette_onboarding_task
  hidden:  yes

  group_label: "Marketing"
  label: "Juliette Onboarding Task Explore"
  description: "This is my first Explore for my onboarding task."

  sql_always_where: ${order_date} > '2021-01-19' ;;

  always_filter: {
    filters:  [
      global_filters_and_parameters.datasource_filter: "last 7 days",
      country_iso: ""
    ]
  }

  join: global_filters_and_parameters {
    sql: ;;
  relationship: one_to_one
  }
  }
