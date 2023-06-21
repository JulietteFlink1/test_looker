include: "/*/**/oracle_fusion_general_ledger_mapping.view.lkml"
include: "/**/hubs_ct.view"
include: "/**/global_filters_and_parameters.view.lkml"

# This explore provides information about the budget, orders and invoices of hubs.
# Author: Victor Breda
# Created: 2022-11-22

explore: financial_pl {
  view_name: oracle_fusion_general_ledger_mapping
  group_label: "Finance"
  view_label: "P&L - Oracle Fusion"
  description: "This explore provides information on Flink expenses."

  # sql_always_where: {% condition global_filters_and_parameters.datasource_filter %} ${oracle_fusion_general_ledger_mapping.period_start_date} {% endcondition %} ;;

  # always_filter: {
  #   filters: [
  #     global_filters_and_parameters.datasource_filter: "last 7 days"
  #   ]
  # }

#   join: global_filters_and_parameters {
#     sql: ;;
#   relationship: one_to_one
#   fields: [datasource_filter]
# }

access_filter: {
  field: oracle_fusion_general_ledger_mapping.country_iso
  user_attribute: country_iso
}

join: hubs {
  from: hubs_ct
  view_label: "Hubs"
  sql_on: ${oracle_fusion_general_ledger_mapping.hub_code} = ${hubs.hub_code} ;;
  relationship: many_to_one
  type: left_outer
}


}
