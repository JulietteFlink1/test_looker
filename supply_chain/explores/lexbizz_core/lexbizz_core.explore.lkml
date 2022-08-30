include: "/**/lexbizz_*.view"
include: "/**/products_hub_assignment_v2.view"
include: "/**/products.view"
include: "/**/hubs_ct.view"
include: "/**/lexbizz_core_ndt_9er_status.view"

explore: lexbizz_core {

  hidden: yes


  from: lexbizz_item_warehouse
  view_name: "item_warehouse"

  access_filter: {
    field: hubs_ct.country_iso
    user_attribute: country_iso

  }


  # -----------  join stock_item  ------------------------------------------------------------------------------------------
  join: stock_item {

    from: lexbizz_item

    type: left_outer
    relationship: many_to_one

    sql_on:
        ${item_warehouse.ingestion_date} = ${stock_item.ingestion_date} and
        ${item_warehouse.sku}            = ${stock_item.sku}
    ;;

  }
      join: products {
        type: full_outer
        relationship: many_to_one
        sql_on:  ${products.product_sku} = ${stock_item.sku};;
      }

      join: lexbizz_core_ndt_similar_rsg {
        type: left_outer
        relationship: many_to_one
        sql_on: ${lexbizz_core_ndt_similar_rsg.similar_rsg} = ${stock_item.similar_rsg} ;;
      }

  # -----------  join item_vendor_status  ------------------------------------------------------------------------------------------
  join: item_vendor_status {

    from: lexbizz_item_vendor

    type: left_outer
    relationship: many_to_one

    sql_on:
        ${item_warehouse.ingestion_date} = ${item_vendor_status.ingestion_date} and
        ${item_warehouse.sku}            = ${item_vendor_status.sku} and
        ${item_warehouse.preferred_vendor_id} = ${item_vendor_status.vendor_id}
    ;;

  }
    join: lexbizz_core_ndt_9er_status {

      type: left_outer
      relationship: many_to_one
      sql_on: ${item_vendor_status.vendor_id} = ${lexbizz_core_ndt_9er_status.vendor_id} and
              ${stock_item.item_replenishment_substitute_group} = ${lexbizz_core_ndt_9er_status.replenishment_substitute_group}
      ;;
    }

  # -----------  join warehouse ------------------------------------------------------------------------------------------
  join: warehouse {

    from: lexbizz_warehouse

    type: left_outer
    relationship: many_to_one

    sql_on:
        ${item_warehouse.ingestion_date} = ${warehouse.ingestion_date} and
        ${item_warehouse.warehouse_id}   = ${warehouse.warehouse_id}
    ;;

  }


  # -----------  join hub ------------------------------------------------------------------------------------------
  join: hub {
    view_label: "Hubs ERP"

    from: lexbizz_hub

    type: left_outer
    relationship: many_to_one

    sql_on:
        ${hub.ingestion_date} = ${warehouse.ingestion_date} and
        ${hub.hub_id}         = ${warehouse.hub_id}
    ;;

  }
      join: hubs_ct {
        view_label: "Hubs CommerceTools"
        type: full_outer
        relationship: many_to_one
        sql_on: ${hub.hub_code} = ${hubs_ct.hub_code} ;;
      }

  # -----------  join vendor  ------------------------------------------------------------------------------------------
  join: vendor {

    from: lexbizz_vendor

    type: left_outer
    relationship: many_to_one

    sql_on:
        ${vendor.ingestion_date} = ${item_warehouse.ingestion_date}      and
        ${vendor.vendor_id}      = ${item_warehouse.preferred_vendor_id}
    ;;

  }

  # -----------  join vendor-location  ------------------------------------------------------------------------------------------
  join: vendor_location {

    from: lexbizz_vendor_location

    type: left_outer
    relationship: many_to_one

    sql_on:
        ${vendor_location.ingestion_date}  = ${item_warehouse.ingestion_date}             and
        ${vendor_location.vendor_location} = ${item_warehouse.preferred_vendor_location}
    ;;

  }

  # -----------  join buying-prices  ------------------------------------------------------------------------------------------
  join: buying_price {

    from: lexbizz_buying_price

    type: left_outer
    relationship: many_to_one

    sql_on:
        ${buying_price.ingestion_date}  = ${item_warehouse.ingestion_date}      and
        ${buying_price.vendor_id}       = ${item_warehouse.preferred_vendor_id} and
        ${buying_price.sku}             = ${item_warehouse.sku}
    ;;

    }


  # -----------  assignment data  ------------------------------------------------------------------------------------------
  join: products_hub_assignment {

    from: products_hub_assignment_v2

    type: left_outer
    relationship: many_to_one

    sql_on:
        ${products_hub_assignment.report_date}     = ${item_warehouse.ingestion_date} and
        ${products_hub_assignment.hub_code}        = ${warehouse.hub_code}            and
        ${products_hub_assignment.sku}             = ${item_warehouse.sku}
    ;;

    }




}
