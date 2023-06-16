# Owned by: Juliette Hampton
# Main stakeholders: Juliette Hampton, Mustaf Ibishi, James Davies, Andreas Stueber
# Questions that can be answered: Am I fit to build views and Explores ¯\_(ツ)_/¯

connection: "bq_flat_rate_slots"

include: "juliette_onboarding_task.view.lkml"


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
      country_iso: ""
    ]
  }
  }
