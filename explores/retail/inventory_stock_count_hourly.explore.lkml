include: "/**/*.view"

# ct table: inventory_stock_count_daily, before in saleor called daily_historical_stock_levels
explore: inventory_stock_count_hourly {
  hidden: no
  label: "Inventory Metrics (hourly granularity)"
  description: "This explores provdes information on inventory stock levels per hub and hour (historically) for the past 7 days. If you need data further in the past, use the (daily level)
                Inventory Metrics (daily granularity) !
  "
  group_label: "02) Inventory"
  # restrict this explore to the last complete week only (too big to be queried entirely)
  sql_always_where:

        ${inventory_tracking_timestamp_date} >= date_sub(current_date(), interval 7 day)

  and ${inventory_stock_count_hourly.inventory_tracking_timestamp_date} <= (case when ${hubs.termination_date} is null then date_add(current_date(), interval 3 year) else ${hubs.termination_date} end)
  ;;

  always_filter: {
    filters:  [
      inventory_stock_count_hourly.inventory_tracking_timestamp_date: "last 2 days",
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

  join: erp_product_hub_vendor_assignment {
    sql_on:
        ${erp_product_hub_vendor_assignment.country_iso}    = ${inventory_stock_count_hourly.country_iso}
    and ${erp_product_hub_vendor_assignment.sku}            = ${inventory_stock_count_hourly.sku}
    and ${erp_product_hub_vendor_assignment.hub_code}       = ${inventory_stock_count_hourly.hub_code}
    and ${erp_product_hub_vendor_assignment.ingestion_date} = ${inventory_stock_count_hourly.inventory_tracking_timestamp_date}
    ;;
    type: left_outer
    relationship: one_to_many
  }
}
