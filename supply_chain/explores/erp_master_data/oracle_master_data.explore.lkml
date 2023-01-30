# Oracle tables
include: "/**/oracle_item_location_fact.view"
include: "/**/oracle_buying_prices_fact.view"
include: "/**/oracle_hubs_fact.view"
include: "/**/oracle_item_supplier_fact.view"
include: "/**/oracle_items_fact.view"
include: "/**/oracle_supplier_fact.view"
# dim tables
include: "/**/hubs_ct.view"

# Owner: Andreas
# Content:
#    This Explore shows Oracle base data for the ERP team to check wrong/missing master-data.

explore: oracle_master_data {

  hidden: yes
  label: "Oracle Master-Data"
  description: "This Explore shows Oracle base data for the ERP team to check wrong/missing master-data"
  group_label: "Supply Chain"

  from: oracle_item_location_fact
  view_name: oracle_item_location_fact

  access_filter: {
    field: hubs_ct.country_iso
    user_attribute: country_iso
  }

  join: hubs_ct {
    relationship: many_to_one
    type: left_outer
    sql_on: ${hubs_ct.hub_code} = ${oracle_item_location_fact.hub_code} ;;
  }

  join: oracle_buying_prices_fact {
    relationship: one_to_one
    type: left_outer
    sql_on:
        ${oracle_buying_prices_fact.hub_code} = ${oracle_item_location_fact.hub_code} and
        ${oracle_buying_prices_fact.sku}      = ${oracle_item_location_fact.sku}
    ;;
  }

  join: oracle_hubs_fact {
    relationship: many_to_one
    type: left_outer
    sql_on: ${oracle_hubs_fact.hub_code} = ${oracle_item_location_fact.hub_code} ;;
  }

  join: oracle_item_supplier_fact {
    relationship: one_to_one
    type: left_outer
    sql_on:
        ${oracle_item_supplier_fact.supplier_id} = ${oracle_item_location_fact.current_state__primary_supplier_id} and
        ${oracle_item_supplier_fact.sku}         = ${oracle_item_location_fact.sku}
    ;;
  }

  join: oracle_items_fact {
    relationship: many_to_one
    type: left_outer
    sql_on:  ${oracle_items_fact.sku} = ${oracle_item_location_fact.sku};;
  }

  join: oracle_supplier_fact {
    relationship: many_to_one
    type: left_outer
    sql_on: ${oracle_item_supplier_fact.supplier_id} =  ${oracle_item_location_fact.current_state__primary_supplier_id} ;;
  }

}
