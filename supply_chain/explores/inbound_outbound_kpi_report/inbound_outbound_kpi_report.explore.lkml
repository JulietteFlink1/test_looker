include: "/**/*.view"

# this explore is created based on the ticket:
# https://goflink.atlassian.net/browse/DATA-1577

explore: inbound_outbound_kpi_report {

  hidden: yes

  from: inventory_changes_daily_extended
  view_name: inventory_changes_daily
  view_label: "* Inventory Changes Daily *"

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    FILTER & SETTINGS
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  sql_always_where:
    -- filter the time for all big tables of this explore
    {% condition global_filters_and_parameters.datasource_filter %} ${inventory_changes_daily.inventory_change_date} {% endcondition %}  ;;

  always_filter: {
    filters: [
      global_filters_and_parameters.datasource_filter: "last 7 days"
      ]
  }

  access_filter: {
    field: hubs_ct.country_iso
    user_attribute: country_iso

  }
  access_filter: {
    field: hubs_ct.city
    user_attribute: city
  }

  fields: [ALL_FIELDS*, -erp_product_hub_vendor_assignment_v2.pricing_fields_refined*]

  join: global_filters_and_parameters {
    view_label: "* Global *"
    sql_on: ${global_filters_and_parameters.generic_join_dim} = TRUE ;;
    type: left_outer
    relationship: one_to_one
  }




  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    JOINED TABLES
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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
      ${inventory_changes_daily.sku}                   =  ${erp_product_hub_vendor_assignment_v2.sku}         and
      {% condition global_filters_and_parameters.datasource_filter %} ${erp_product_hub_vendor_assignment_v2.report_date} {% endcondition %}


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

  join: product_prices_daily {

    view_label: ""

    type: left_outer
    relationship: many_to_one
    sql_on:

    ${inventory_changes_daily.inventory_change_date} =  ${product_prices_daily.reporting_date} and
    ${inventory_changes_daily.hub_code}              =  ${product_prices_daily.hub_code}       and
    ${inventory_changes_daily.sku}                   =  ${product_prices_daily.sku}            and
    {% condition global_filters_and_parameters.datasource_filter %} ${product_prices_daily.reporting_date} {% endcondition %}

    ;;
  }

}
