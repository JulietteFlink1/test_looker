# Owner: Victor Breda
# 2023-07-13
# This view simply contains a mapping between mgmt_mapping and to which P&L category they belong to
# It is joined to oracle_fusion_general_ledger_mapping in the financial_pl explore
view: stg_oracle_fusion_mgmt_mapping_to_pl_category {
  sql_table_name: `flink-data-prod.curated.oracle_fusion_mgmt_mapping_to_pl_category` ;;

  dimension: mgmt_mapping {
    hidden: yes
    type: string
    sql: ${TABLE}.mgmt_mapping ;;
  }

  dimension: pl_category {
    type: string
    label: "P&L Category"
    description: "P&L Category the transaction belongs to. Based on MGMT Mapping.
    It may be that a transactions belongs to multiple categories. E.g. transactions with MGMT Mapping = Hub Set-up Cost are part of the Operating Profit,
    which in turn is part of the EBITDA calculation."
    sql: ${TABLE}.pl_category ;;
    drill_fields: [oracle_fusion_general_ledger_mapping.mgmt_mapping,
      oracle_fusion_general_ledger_mapping.general_ledger_name,
      oracle_fusion_general_ledger_mapping.hub_code,
      oracle_fusion_general_ledger_mapping.cost_center_name,
      oracle_fusion_general_ledger_mapping.party_name]
  }
}
