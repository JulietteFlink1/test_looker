include: "/*/**/oracle_fusion_general_ledger_mapping.view.lkml"
include: "/**/hubs_ct.view"
include: "/**/global_filters_and_parameters.view.lkml"

# This explore provides information about the profits and losses. Most of the data comes from Oracle Fusion.
# Author: Victor Breda
# Created: 2023-06-21

explore: financial_pl {
  view_name: oracle_fusion_general_ledger_mapping
  group_label: "Finance"
  label: "P&L"
  view_label: "Oracle Fusion"
  description: "This explore provides information on Flink expenses."

  required_access_grants: [can_access_pl]

always_filter: {
  filters: [
    oracle_fusion_general_ledger_mapping.period_start_date: "last 1 month"
  ]
}

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
