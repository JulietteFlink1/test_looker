include: "/**/*.view"

# ct table: inventory_stock_count_daily, before in saleor called daily_historical_stock_levels
explore: inventory_stock_count_daily {
  hidden: no
  view_label: "* Inventory Metrics (daily granularity) *"
  group_label: "02) Inventory"

  always_filter: {
    filters:  [
      inventory_stock_count_daily.tracking_date: "7 days",
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
    sql_on: ${hubs.hub_code} = ${inventory_stock_count_daily.hub_code} ;;
  }

  join: products {
    sql_on: ${inventory_stock_count_daily.sku}         = ${products.product_sku} ;;
    relationship: many_to_one
    type: left_outer
  }

  join: skus_fulfilled_per_hub_and_date {
    view_label: "* Daily Inventory Stock Level *"
    type: left_outer
    relationship: many_to_one
    sql_on: ${skus_fulfilled_per_hub_and_date.product_sku}       = ${inventory_stock_count_daily.sku}
       and  ${skus_fulfilled_per_hub_and_date.created_date}      = ${inventory_stock_count_daily.tracking_date}
       and ${skus_fulfilled_per_hub_and_date.hub_code_lowercase} = ${inventory_stock_count_daily.hub_code}
    ;;
    fields: [skus_fulfilled_per_hub_and_date.sum_item_quantity_fulfilled,
      skus_fulfilled_per_hub_and_date.sum_item_quantity]
  }

  join: orderline {
    sql_on: ${inventory_stock_count_daily.sku}           = ${orderline.product_sku}
        and ${inventory_stock_count_daily.tracking_date} = ${orderline.created_date}
        and ${inventory_stock_count_daily.hub_code}      = ${orderline.hub_code}
    ;;
    type: left_outer
    relationship: one_to_many
  }

  join: top_50_skus_per_gmv_inventory_daily_explore {
    sql_on: ${top_50_skus_per_gmv_inventory_daily_explore.sku}         = ${inventory_stock_count_daily.sku}
        and ${top_50_skus_per_gmv_inventory_daily_explore.country_iso} = ${inventory_stock_count_daily.country_iso}
    ;;
    type: left_outer
    relationship: many_to_one
  }



}
