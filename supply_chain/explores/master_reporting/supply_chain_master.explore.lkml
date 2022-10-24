# Owner:
# Lautaro Ruiz
#
# Main Stakeholder:
# - Supply Chain team
#
# Questions that can be answered
# - This explore shows the most important KPIs for Supply Chain team combined in the same place.
# In here we can see:
         # Availability
         # Waste
         # Fill Rate
         # GMV


include: "/supply_chain/explores/master_reporting/supply_chain_master_report.view"
include: "/core/views/config/global_filters_and_parameters.view"



explore: supply_chain_master {

  hidden: no

  persist_with: flink_daily_datagroup

  label: "Supply Chain Master Explore"
  group_label: "Supply Chain"

  from: supply_chain_master_report

  sql_always_where: {% condition global_filters_and_parameters.datasource_filter %} ${supply_chain_master.report_date} {% endcondition %} ;;

  always_filter: {filters: [global_filters_and_parameters.datasource_filter: "8 days ago for 7 days"]}

  access_filter: {
    field: country_iso
    user_attribute: country_iso

  }

  join: global_filters_and_parameters {
    view_label: "Global"
    sql_on: ${global_filters_and_parameters.generic_join_dim} = TRUE ;;
    type: left_outer
    relationship: one_to_one
  }
}
