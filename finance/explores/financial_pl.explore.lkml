include: "/*/**/oracle_fusion_general_ledger_mapping.view.lkml"
include: "/**/hubs_ct.view"
include: "/**/stg_oracle_fusion_mgmt_mapping_to_pl_category.view.lkml"

# This explore provides information about the profits and losses. As of 2023-06-22, all of the data comes from Oracle Fusion.
# Author: Victor Breda
# Created: 2023-06-21

explore: financial_pl {
  view_name: oracle_fusion_general_ledger_mapping
  group_label: "Finance"
  label: "P&L"
  view_label: "Oracle Fusion"
  description: "This explore provides information on Flink expenses."

  # excluding hub_code and country_iso from the hubs table as oracle_fusion_general_ledger_mapping
  # contains values that are not included - e.g. de_ber_hq
  fields: [
    ALL_FIELDS*,
    -hubs.hub_code,
    -hubs.country_iso
  ]

  required_access_grants: [can_access_pl]

  always_filter: {
    filters: [
      oracle_fusion_general_ledger_mapping.period_month: "last 1 month",
      oracle_fusion_general_ledger_mapping.country_iso: "",
      oracle_fusion_general_ledger_mapping.hub_code: ""
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

join: stg_oracle_fusion_mgmt_mapping_to_pl_category {
  view_label: "Oracle Fusion"
  sql_on: lower(${stg_oracle_fusion_mgmt_mapping_to_pl_category.mgmt_mapping}) = lower(${oracle_fusion_general_ledger_mapping.mgmt_mapping}) ;;
  relationship: one_to_many
  type: left_outer
}


}
