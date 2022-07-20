# Owner: Product Analytics, Flavia Alvarez

view: stock_management_movement_ids {
  derived_table: {
    explore_source: stock_management_progress_sku_aggregation {
      column: hub_code { field: stock_management_progress_sku_aggregates.hub_code }
      column: inventory_movement_id { field: stock_management_progress_sku_aggregates.inventory_movement_id }
      column: employee_id { field: stock_management_progress_sku_aggregates.employee_id }
      column: cart_to_drop_list_seconds { field: stock_management_progress_sku_aggregates.cart_to_drop_list_seconds }
      column: drop_list_created_to_finished_seconds { field: stock_management_progress_sku_aggregates.drop_list_created_to_finished_seconds }
      column: total_item_added_to_cart { field: stock_management_progress_sku_aggregates.total_item_added_to_cart }
      column: total_item_dropped { field: stock_management_progress_sku_aggregates.total_item_dropped }
      column: total_item_removed_from_cart { field: stock_management_progress_sku_aggregates.total_item_removed_from_cart }
      column: quantity { field: stock_management_progress_sku_aggregates.quantity }
      column: is_handling_unit { field: stock_management_progress_sku_aggregates.is_handling_unit }
      column: cart_to_finished_seconds { field: stock_management_progress_sku_aggregates.cart_to_finished_seconds }
      filters: {
        field: global_filters_and_parameters.datasource_filter
        value: ""
      }
      filters: {
        field: stock_management_progress_sku_aggregates.country_iso
        value: ""
      }
      filters: {
        field: stock_management_progress_sku_aggregates.hub_code
        value: ""
      }
      filters: {
        field: stock_management_progress_sku_aggregates.is_ean_available
        value: "Yes"
      }
    }
  }
  dimension: hub_code {
    description: ""
  }
  dimension: inventory_movement_id {
    description: ""
  }
  dimension: employee_id {
    description: ""
  }
  dimension: cart_to_drop_list_seconds {
    description: "Difference in seconds between time_to_cart_created and time_to_dropping_list timestamps"
    type: number
  }
  dimension: drop_list_created_to_finished_seconds {
    description: "Difference in seconds between time_to_dropping_list_created and time_to_dropping_list_finished timestamps"
    type: number
  }
  dimension: total_item_added_to_cart {
    label: "Stock Management Progress SKU Aggregates # Items Added To Cart"
    description: ""
    type: number
  }
  dimension: total_item_dropped {
    label: "Stock Management Progress SKU Aggregates # Items Dropped"
    description: ""
    type: number
  }
  dimension: total_item_removed_from_cart {
    label: "Stock Management Progress SKU Aggregates # Items Removed From Cart"
    description: ""
    type: number
  }
  dimension: quantity {
    description: ""
    type: number
  }
  dimension: is_handling_unit {
    label: "Stock Management Progress SKU Aggregates Is Handling Unit (Yes / No)"
    description: ""
    type: yesno
  }
  dimension: cart_to_finished_seconds {
    description: "Difference in seconds between time_to_cart_created and time_to_dropping_list_finished timestamps"
    type: number
  }
}
