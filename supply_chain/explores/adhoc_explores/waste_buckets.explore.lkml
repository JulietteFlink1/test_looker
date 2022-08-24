# Owner:
# Lautaro Ruiz
#
# Main Stakeholder:
# - Supply Chain team
#
# Questions that can be answered
# - Bucketing logic for waste definitions
#
#
include: "/**/*.view"



explore: waste_buckets {

  label:       "Waste Buckets"
  description: "This explore covers all the necessary data coming from waste_waterfall_definition reporting model"

  from  :     waste_waterfall_definition
  view_label: " 01 Waste Buckets"
  group_label: "Supply Chain"
  hidden: yes



join: products {

  view_label: "03 Products (CT) "

  type: left_outer
  relationship: many_to_one
  sql_on: ${products.product_sku} = ${waste_buckets.sku} ;;

}

join: lexbizz_item {

  view_label: "04 Products (ERP) "

  type: left_outer
  relationship: many_to_one
  sql_on: ${lexbizz_item.sku}            = ${waste_buckets.sku}
        and ${lexbizz_item.ingestion_date} = current_date()
    ;;
}

  join: hubs_ct {

    view_label: "02 Hubs"

    type: left_outer
    relationship: many_to_one
    sql_on: ${hubs_ct.hub_code} = ${waste_buckets.hub_code} ;;
  }


  join: erp_master_data {

    from: erp_product_hub_vendor_assignment_v2
    view_label: "05 Supplier (ERP)"

    type: left_outer
    relationship: many_to_one

    sql_on:
        ${erp_master_data.report_date} = ${waste_buckets.inventory_change_date} and
        ${erp_master_data.hub_code}    = ${waste_buckets.hub_code}    and
        ${erp_master_data.sku}         = ${waste_buckets.sku}
    ;;

    fields: [erp_master_data.vendor_class, erp_master_data.vendor_id, erp_master_data.vendor_location, erp_master_data.vendor_name, erp_master_data.vendor_status]
  }


}
