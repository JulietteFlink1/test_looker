include: "/**/*.view"

# this explore is created based on the ticket:
# https://goflink.atlassian.net/browse/DATA-1577

explore: inbound_outbound_kpi_report {

  hidden: yes

  from: inventory_changes_daily
  view_name: inventory_changes_daily
  view_label: "* Inventory Changes Daily *"

  join: products {
    type: left_outer
    relationship: many_to_one
    sql_on: ${inventory_changes_daily.sku} = ${products.product_sku} ;;
  }

  join: hubs_ct {
    type: left_outer
    relationship: many_to_one
    sql_on:  ${hubs_ct.hub_code} = ${inventory_changes_daily.hub_code};;
  }

  join: sku_hub_day_level_orders {
    type: left_outer
    relationship: many_to_one
    view_label: "* Inventory Changes Daily *"

    sql_on:
        ${sku_hub_day_level_orders.product_sku}   =  ${inventory_changes_daily.sku} and
        ${sku_hub_day_level_orders.hub_code}      =  ${inventory_changes_daily.hub_code} and
        ${sku_hub_day_level_orders.created_date}  = ${inventory_changes_daily.inventory_change_date}
    ;;
  }


}
