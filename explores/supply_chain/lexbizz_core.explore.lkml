include: "/views/**/lexbizz_*.view"

explore: lexbizz_core {

  hidden: yes


  from: lexbizz_item_warehouse
  view_name: "item_warehouse"


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

  # -----------  join item_vendor_status  ------------------------------------------------------------------------------------------
  join: item_vendor_status {

    from: lexbizz_item_vendor

    type: left_outer
    relationship: many_to_one

    sql_on:
        ${item_warehouse.ingestion_date} = ${item_vendor_status.ingestion_date} and
        ${item_warehouse.sku}            = ${item_vendor_status.sku}
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

    from: lexbizz_hub

    type: left_outer
    relationship: many_to_one

    sql_on:
        ${hub.ingestion_date} = ${warehouse.ingestion_date} and
        ${hub.hub_id}         = ${warehouse.hub_id}
    ;;

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




}
