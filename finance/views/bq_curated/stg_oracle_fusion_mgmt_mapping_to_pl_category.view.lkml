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
    order_by_field: ordering_help_pl_category
    drill_fields: [oracle_fusion_general_ledger_mapping.mgmt_mapping,
      oracle_fusion_general_ledger_mapping.general_ledger_name,
      oracle_fusion_general_ledger_mapping.hub_code,
      oracle_fusion_general_ledger_mapping.cost_center_name,
      oracle_fusion_general_ledger_mapping.party_name]
  }

  # this field is used to order the pl_category to match the order they are looked at in the P&Ls
  dimension: ordering_help_pl_category {
    type: number
    hidden: no
    sql:
    case
      when ${stg_oracle_fusion_mgmt_mapping_to_pl_category.pl_category} = "Net revenue" then 1
      when ${stg_oracle_fusion_mgmt_mapping_to_pl_category.pl_category} = "Net revenue core business" then 2
      when ${stg_oracle_fusion_mgmt_mapping_to_pl_category.pl_category} = "Total net revenue" then 3
      when ${stg_oracle_fusion_mgmt_mapping_to_pl_category.pl_category} = "Cost Of Goods Sold Total" then 4
      when ${stg_oracle_fusion_mgmt_mapping_to_pl_category.pl_category} = "Waste" then 5
      when ${stg_oracle_fusion_mgmt_mapping_to_pl_category.pl_category} = "Gross Profit" then 6
      when ${stg_oracle_fusion_mgmt_mapping_to_pl_category.pl_category} = "Transaction fees" then 7
      when ${stg_oracle_fusion_mgmt_mapping_to_pl_category.pl_category} = "Rider personnel cost" then 8
      when ${stg_oracle_fusion_mgmt_mapping_to_pl_category.pl_category} = "Profit before store costs" then 9
      when ${stg_oracle_fusion_mgmt_mapping_to_pl_category.pl_category} = "Hub Staff personnel cost" then 10
      when ${stg_oracle_fusion_mgmt_mapping_to_pl_category.pl_category} = "Operational hub cost" then 11
      when ${stg_oracle_fusion_mgmt_mapping_to_pl_category.pl_category} = "Operating profit from hub operations" then 12
      when ${stg_oracle_fusion_mgmt_mapping_to_pl_category.pl_category} = "Logistics cost" then 13
      when ${stg_oracle_fusion_mgmt_mapping_to_pl_category.pl_category} = "Hub set-up cost" then 14
      when ${stg_oracle_fusion_mgmt_mapping_to_pl_category.pl_category} = "Net revenue supplier funding/ advertising" then 15
      when ${stg_oracle_fusion_mgmt_mapping_to_pl_category.pl_category} = "Total operating profit" then 16
      when ${stg_oracle_fusion_mgmt_mapping_to_pl_category.pl_category} = "Marketing" then 17
      when ${stg_oracle_fusion_mgmt_mapping_to_pl_category.pl_category} = "G&A cost" then 18
      when ${stg_oracle_fusion_mgmt_mapping_to_pl_category.pl_category} = "EBITDA" then 19
      when ${stg_oracle_fusion_mgmt_mapping_to_pl_category.pl_category} = "Intercompany" then 20
      when ${stg_oracle_fusion_mgmt_mapping_to_pl_category.pl_category} = "D&A" then 21
      when ${stg_oracle_fusion_mgmt_mapping_to_pl_category.pl_category} = "Interest" then 22
      when ${stg_oracle_fusion_mgmt_mapping_to_pl_category.pl_category} = "tbd" then 23
      else 24
  end  ;;
  }
}
