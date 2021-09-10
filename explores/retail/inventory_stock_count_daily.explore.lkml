include: "/**/*.view"

# ct table: inventory_stock_count_daily, before in saleor called daily_historical_stock_levels
explore: inventory_stock_count_daily {
  hidden: yes
  view_label: "* Daily Inventory Stock Level *"

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
}
