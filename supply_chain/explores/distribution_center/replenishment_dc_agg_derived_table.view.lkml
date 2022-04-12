# If necessary, uncomment the line below to include explore_source.
# include: "distribution_center.explore.lkml"

view: replenishment_dc_agg_derived_table {
  derived_table: {
    explore_source: distribution_center {
      column: dc_code { field: replenishment_dc_batchbalance.dc_code }
      column: sku { field: replenishment_dc_batchbalance.sku }
      column: stock_balance_date_date { field: replenishment_dc_batchbalance.stock_balance_date_date }
      column: total_stock_available { field: replenishment_dc_batchbalance.total_stock_available }
    bind_all_filters: yes
    }
  }
  dimension: table_uuid {
    hidden: yes
    primary_key: yes
    sql: concat(${stock_balance_date_date},${dc_code},${sku}) ;;

  }
  dimension: dc_code {
    label: " 01 Distribution Center Inventory  Distribution Center Code"
    hidden: yes
    description: ""
  }
  dimension: sku {
    hidden: yes
    label: " 01 Distribution Center Inventory  SKU"
    description: ""
  }
  dimension: stock_balance_date_date {
    hidden: yes
    label: " 01 Distribution Center Inventory  Balance Date"
    description: "Inventory balance date"
    type: date
  }
  dimension: total_stock_available {
    hidden: yes
    label: " 01 Distribution Center Inventory  # Total Stock Available"
    description: "Use this metric when checking the current stock"
    type: number
  }
}
