# Owner:
# Lautaro Ruiz
#
# Main Stakeholder:
# - Supply Chain team
#
# Questions that can be answered
# - All questions around the most important SC KPIs


include: "/**/*.view"


explore: supply_chain_master {

  hidden: no

  label: "Master Explore"
  group_label: "Supply Chain"

  from: supply_chain_master_report

  always_filter: {filters: [global_filters_and_parameters.datasource_filter: "8 days ago for 7 days"]}
  access_filter: {
    field: country_iso
    user_attribute: country_iso

  }


  join: global_filters_and_parameters {
    view_label: "* Global *"
    sql_on: ${global_filters_and_parameters.generic_join_dim} = TRUE ;;
    type: left_outer
    relationship: one_to_one

  }

  }
