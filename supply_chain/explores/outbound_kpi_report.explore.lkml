include: "/**/*.view"

# this explore is created based on the ticket:
# https://goflink.atlassian.net/browse/DATA-1577

explore: inbound_outbound_kpi_report {

  hidden: yes

  from: inventory_changes_daily
  view_name: inventory_changes_daily
  view_label: "* Inventory Changes Daily *"

  fields: [ALL_FIELDS*, -erp_product_hub_vendor_assignment_v2.pricing_fields_refined*]

  join: products {
    type: left_outer
    relationship: many_to_one
    sql_on: ${inventory_changes_daily.sku} = ${products.product_sku} ;;
  }

  join: lexbizz_item {

    view_label: "* Products (ERP)*"

    type: left_outer
    relationship: many_to_one
    sql_on: ${inventory_changes_daily.sku} = ${lexbizz_item.sku}  and
            ${lexbizz_item.ingestion_date} = current_date()
    ;;
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

  join: erp_product_hub_vendor_assignment_v2 {

    type: left_outer
    relationship: one_to_many

    view_label: "* ERP Master-Data *"

    sql_on:

      ${inventory_changes_daily.inventory_change_date} =  ${erp_product_hub_vendor_assignment_v2.report_date} and
      ${inventory_changes_daily.hub_code}              =  ${erp_product_hub_vendor_assignment_v2.hub_code}    and
      ${inventory_changes_daily.sku}                   =  ${erp_product_hub_vendor_assignment_v2.sku}

    ;;

  }

  join: top_5_category_inventory_change {

    view_label: "* Top 5 Categories by Inventory Change Type Daily [Hub-Level] *"

    type: left_outer
    relationship: many_to_one
    sql_on:
          date(${top_5_category_inventory_change.inventory_change_date}) = date(${inventory_changes_daily.inventory_change_date})
      and ${top_5_category_inventory_change.hub_code}                    = ${inventory_changes_daily.hub_code}
      and ${top_5_category_inventory_change.category}                    = ${sku_hub_day_level_orders.category}
    ;;
  }

}
