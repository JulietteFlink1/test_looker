# Place in `flink_v3` model
include: "/commercial/explores/*"
explore: +current_inventory_updated_hourly {
  aggregate_table: current_inventory_updated_hourly_aggregates_test {
    query: {
      dimensions: [
        hubs.country_iso,
        hubs.hub_code,
        products.category,
        products.product_name,
        products.product_sku,
        products.subcategory
      ]
      measures: [inventory.sum_stock_quantity, order_lineitems.avg_daily_item_quantity_last_14d, order_lineitems.avg_daily_item_quantity_last_1d, order_lineitems.avg_daily_item_quantity_last_7d, order_lineitems.pct_stock_range_7d, order_lineitems.sum_item_quantity]
      filters: [
        global_filters_and_parameters.datasource_filter: "21 days",
        hubs.is_active_hub: "Yes",
        products.is_published: "Yes",
        products_hub_assignment.is_sku_assigned_to_hub: "Yes"
      ]
      timezone: "Europe/Berlin"
    }

    materialization: {
      datagroup_trigger: flink_hourly_datagroup
    }
  }
}
