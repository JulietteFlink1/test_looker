
view: top_5_category_inventory_change {
  view_label: "* Top 5 Categories by Inventory Change Daily Hub-Level *"

  derived_table: {
    explore_source: inbound_outbound_kpi_report {

      column: country_iso              { field: inventory_changes_daily.country_iso }
      column: category                 { field: products.category }
      column: hub_code                 { field: inventory_changes_daily.hub_code }
      column: inventory_change_date    { field: inventory_changes_daily.inventory_change_date }

      column: sum_inventory_correction_reduced    { field: inventory_changes_daily.sum_inventory_correction_reduced }
      column: sum_inventory_correction_increased  { field: inventory_changes_daily.sum_inventory_correction_increased }
      column: sum_outbound_waste                  { field: inventory_changes_daily.sum_outbound_waste }

      derived_column: rank_negative     { sql: row_number() over (partition by country_iso, hub_code, inventory_change_date order by sum_inventory_correction_reduced ) ;; }
      derived_column: rank_positive     { sql: row_number() over (partition by country_iso, hub_code, inventory_change_date order by sum_inventory_correction_increased desc) ;; }
      derived_column: rank_outbounded   { sql: row_number() over (partition by country_iso, hub_code, inventory_change_date order by sum_outbound_waste desc) ;; }

      bind_all_filters: yes
    }
  }

  dimension: primary_key {
    hidden: yes
    primary_key: yes
    sql: concat(${hub_code}, ${category},${inventory_change_date}) ;;
  }


  measure: sum_outbound_waste {
    label: "# Outbound (Waste)"
    description: "The sum of all inventory changes, that are related to waste"
    type: sum
    value_format_name: decimal_0
  }

  measure: sum_inventory_correction_increased {
    label: "# Inventory Correction (Increased)"
    description: "The sum of inventory changes related to inventory corrections that increased the inventory"
    type: sum
    value_format_name: decimal_0
  }

  measure: sum_inventory_correction_reduced {
    label: "# Inventory Correction (Reduced)"
    description: "The sum of inventory changes related to inventory corrections that reduced the inventory"
    type: sum
    value_format_name: decimal_0
  }

  dimension: country_iso {
    label: "Country Iso"
    hidden: yes
  }

  dimension: hub_code {
    label: "Hub Code"
    hidden: no
  }

  dimension: category {
    label: "Category"
    hidden: no
  }

  dimension: inventory_change_date {
    label: "Inventory Change Date"
    type: date
    hidden: no
  }

  dimension: rank_negative {
    label: "Category Rank for Inventory Reduction"
    group_label: "> Category Ranks"
    type: number
  }

  dimension: rank_positive {
    label: "Category Rank for Inventory Increase"
    group_label: "> Category Ranks"
    type: number
  }

  dimension: rank_outbounded {
    label: "Category Rank for Inventory Outbound (Waste)"
    group_label: "> Category Ranks"
    type: number
  }



}
