# If necessary, uncomment the line below to include explore_source.
# include: "lexbizz_core.explore.lkml"

view: lexbizz_core_ndt_9er_status {
  derived_table: {
    explore_source: lexbizz_core {
      column: is_active                      { field: item_vendor_status.is_active }
      column: vendor_id                      { field: item_vendor_status.vendor_id }
      column: vendor_name                    { field: item_vendor_status.vendor_name }
      column: sku                            { field: item_vendor_status.sku }
      column: replenishment_substitute_group { field: products_hub_assignment.replenishment_substitute_group }


      filters: {
        field: item_vendor_status.ingestion_date
        value: "today"
      }
      filters: {
        field: products_hub_assignment.replenishment_substitute_group
        value: "-NULL"
      }
      filters: {
        field: item_vendor_status.sku
        value: "9%"
      }
    }
  }
  dimension: is_active {
    label: "Item Vendor Status Is Active (Yes / No)"
    type: yesno
  }
  dimension: vendor_id {}
  dimension: vendor_name {}
  dimension: sku {}
  dimension: replenishment_substitute_group {}
}
