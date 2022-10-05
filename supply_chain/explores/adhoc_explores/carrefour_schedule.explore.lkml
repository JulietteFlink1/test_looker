# Owner:
# Lautaro Ruiz
#
# Main Stakeholder:
# - FR Team (Supply Chain and Commercial)
#
#
include: "/**/*.view"



explore: carrefour_schedule {

  label:       "Carrefour Schedule"
  description: "This explore covers all the necessary data coming Carrefour Schedule"
  group_label: "Supply Chain"

  from  :     carrefour_schedule
  view_name:  carrefour_schedule
  view_label: "Carrefour Schedule"
  hidden: yes

### FILTERS

  fields: [ALL_FIELDS*]

  always_filter: {
    filters: [
      carrefour_schedule.day_date: "last 7 days",

    ]
  }



### JOINS
  join: global_filters_and_parameters {
    view_label: "* Global *"
    sql_on: ${global_filters_and_parameters.generic_join_dim} = TRUE ;;
    type: left_outer
    relationship: one_to_one

  }



}
