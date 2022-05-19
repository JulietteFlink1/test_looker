# If necessary, uncomment the line below to include explore_source.
include: "spc_2.explore.lkml"

view: spc_2_ranks {
  derived_table: {
    explore_source: spc_2 {
      column: hub_code { field: sku_performance_base.hub_code }
      column: sku { field: sku_performance_base.sku }
      column: direct_sku_performance { field: sku_performance_base.direct_sku_performance }
      column: indirect_sku_performance { field: sku_performance_base.indirect_sku_performance }
      column: main_pct_margin { field: sku_performance_base.main_pct_margin }

      derived_column: rank_direct_sku_performance {
        sql: rank() over (partition by hub_code order by direct_sku_performance desc) ;;
      }

      derived_column: rank_indirect_sku_performance {
        sql: rank() over (partition by hub_code order by indirect_sku_performance desc) ;;
      }

      derived_column: rank_margin {
        sql: rank() over (partition by hub_code order by main_pct_margin desc) ;;
      }

      bind_all_filters: yes
    }
  }


  dimension: primary_key {

    hidden: yes
    primary_key: yes
    sql: concat(${hub_code}, ${sku}) ;;
  }

  dimension: rank_direct_sku_performance {

    label: "Rank: Direct SKU Contribution"
    description: "The direct comtribution of an SKU towards the company success measured as:
    take the higher value of
    - % Items Sold vs. Total
    - % Item Revenue vs. Total  "
    group_label: "Proposed Decision Metrics"

    type: number
    value_format_name: decimal_0

  }

  dimension: rank_indirect_sku_performance {

    label: "Rank: Indirect SKU Contribution"
    description: "The indirect contribution of an SKU defined by its cross-selling potential. The KPI is defined as
    (# Item-Connections) / (# Unique SKUs)"
    group_label: "Proposed Decision Metrics"

    type: number
    value_format_name: decimal_0

  }

  dimension: rank_margin {

    label: "Rank: Margin"
    description: "The absolute margin of the reporting period compared to the selling price per unit"
    group_label: "Proposed Decision Metrics"

    type: number
    value_format_name: decimal_0

  }


  dimension: hub_code {
    label: "SPC 2.0 Core Data Hub Code"
    description: ""
    hidden: yes
  }
  dimension: sku {
    label: "SPC 2.0 Core Data SKU"
    description: ""
    hidden: yes
  }
  dimension: direct_sku_performance {
    label: "SPC 2.0 Core Data Direct SKU Contribution"
    description: "The direct comtribution of an SKU towards the company success measured as:
    take the higher value of
    - % Items Sold vs. Total
    - % Item Revenue vs. Total  "
    value_format: "#,##0.0000%"
    type: number
    hidden: yes
  }
  dimension: indirect_sku_performance {
    label: "SPC 2.0 Core Data Indirect SKU Contribution"
    description: "The indirect contribution of an SKU defined by its cross-selling potential. The KPI is defined as
    (# Item-Connections) / (# Unique SKUs)"
    value_format: "#,##0.00%"
    type: number
    hidden: yes
  }
  dimension: main_pct_margin {
    label: "SPC 2.0 Core Data % Margin - Reporting Period"
    description: "The absolute margin of the reporting period compared to the selling price per unit"
    value_format: "#,##0%"
    type: number
    hidden: yes
  }
}
