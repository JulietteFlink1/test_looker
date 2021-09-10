include: "/**/*.view"

# ct table: inventory_stock_count_daily, before in saleor called daily_historical_stock_levels
explore: inventory_stock_count_hourly {
  hidden: yes
  view_label: "* Hourly Inventory Stock Level *"

  always_filter: {
    filters:  [
      inventory_stock_count_hourly.partition_timestamp_date: "last 2 days",
      hubs.country_iso: "DE",
      hubs.hub_name: ""
    ]
  }
  access_filter: {
    field: hubs.country_iso
    user_attribute: country_iso
  }

  access_filter: {
    field: hubs.city
    user_attribute: city
  }

  join: hubs {
    from:  hubs_ct
    view_label: "* Hubs *"
    type: left_outer
    relationship: many_to_one
    sql_on: ${hubs.hub_code} = ${inventory_stock_count_hourly.hub_code} ;;
  }

  join: products {
    sql_on: ${inventory_stock_count_hourly.sku}         = ${products.product_sku} ;;
    relationship: many_to_one
    type: left_outer
  }
}
