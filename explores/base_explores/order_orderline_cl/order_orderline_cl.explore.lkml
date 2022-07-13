include: "/views/**/*.view"
include: "/**/*.view"
include: "/**/*.explore"


explore: order_orderline_cl {

  extends: [orders_cl]

  group_label: "01) Performance"
  label:       "Orders & Lineitems"
  description: "Orderline Items sold quantities, prices, gmv, etc."
  hidden: no

  # take all fields except those in the pricing_fields_refined set in erp_product_hub_vendor_assignment_v2_buying_prices.view
  fields: [ALL_FIELDS*, -erp_product_hub_vendor_assignment.pricing_fields_refined*]

  join: orderline {

    view_label: "* Order Lineitems *"
    sql_on: ${orderline.country_iso} = ${orders_cl.country_iso} AND
            ${orderline.order_uuid}    = ${orders_cl.order_uuid} AND
            {% condition global_filters_and_parameters.datasource_filter %} ${orderline.created_date} {% endcondition %}

            ;;
    relationship: one_to_many
    type: left_outer
  }

  join: products {

    view_label: "* Product Data (CT) *"

    sql_on: ${products.product_sku} = ${orderline.product_sku} ;;
    relationship: many_to_one
    type: left_outer
  }

  join: lexbizz_item {

    view_label: "* Product Data (ERP) *"

    type: left_outer
    relationship: many_to_one
    sql_on: ${lexbizz_item.sku}            = ${orderline.product_sku}
        and ${lexbizz_item.ingestion_date} = current_date()
    ;;
  }

  join: customer_address {
    # can only be seen by people with related permissions
    sql_on: ${orders_cl.order_uuid} = ${customer_address.order_uuid} ;;
    type: left_outer
    relationship: one_to_one
  }

  join: erp_product_hub_vendor_assignment {

    # hiding this table, as it is filtered already by assigned SKUs, which also excludes information on No-Purchase items (we sell them, but do not replenish)
    # this will be deprecated in favour of the raw ERP data
    view_label: ""

    from: erp_product_hub_vendor_assignment_v2

    sql_on:  ${erp_product_hub_vendor_assignment.sku}            = ${orderline.product_sku}
         and ${erp_product_hub_vendor_assignment.hub_code}       = ${orderline.hub_code}
         and ${erp_product_hub_vendor_assignment.report_date}    = ${orderline.created_date}
    ;;
    type: left_outer
    relationship: one_to_many
  }

  # ----------------------------------------
  # Join Lexbizz Raw-Data Model

  join: lexbizz_warehouse {

    view_label: "Lexbizz Master Data"

    type: left_outer
    relationship: many_to_one
    fields: [
             # lexbizz_warehouse.hub_code,
             # lexbizz_warehouse.ingestion_date,
             # lexbizz_warehouse.warehouse_id,
             lexbizz_warehouse.is_warehouse_active,
             # lexbizz_item_warehouse.country_iso
            ]

    sql_on:
          ${lexbizz_warehouse.hub_code}         =  ${orderline.hub_code}
      and ${lexbizz_warehouse.ingestion_date}   =  ${orderline.created_date}
      and ${lexbizz_warehouse.country_iso}      =  ${orderline.country_iso}

      -- remove the "* N" aka test warehouses, otherwise the join duplicates the data
      and ${lexbizz_warehouse.is_warehouse_active} is true
      --and SUBSTR(${lexbizz_warehouse.warehouse_id}, LENGTH(${lexbizz_warehouse.warehouse_id}) -1, LENGTH(${lexbizz_warehouse.warehouse_id})) = ' N'
    ;;
  }

  join: lexbizz_item_warehouse {

    view_label: "Lexbizz Master Data"

    type: left_outer
    relationship: many_to_one
    fields: [
      lexbizz_item_warehouse.ingestion_date,
      lexbizz_item_warehouse.warehouse_id,
      lexbizz_item_warehouse.sku,
      lexbizz_item_warehouse.item_status,
      lexbizz_item_warehouse.item_at_warehouse_status,
      lexbizz_item_warehouse.preferred_vendor_id,
      lexbizz_item_warehouse.preferred_vendor_location,
      # lexbizz_item_warehouse.country_iso
    ]

    sql_on:
           ${lexbizz_item_warehouse.ingestion_date} = ${orderline.created_date}
      and  ${lexbizz_item_warehouse.warehouse_id}   = ${lexbizz_warehouse.warehouse_id}
      and  ${lexbizz_item_warehouse.sku}            = ${orderline.product_sku}
      and  ${lexbizz_item_warehouse.country_iso}    = ${orderline.country_iso}
    ;;
  }

  join: lexbizz_vendor {

    view_label: "Lexbizz Master Data"

    type: left_outer
    relationship: many_to_one
    fields: [
      lexbizz_vendor.gln,
      lexbizz_vendor.vendor_status,
      lexbizz_vendor.vendor_class,
      lexbizz_vendor.vendor_name
    ]

    sql_on:
           ${lexbizz_vendor.vendor_id}      =  ${lexbizz_item_warehouse.preferred_vendor_id}
      and  ${lexbizz_vendor.ingestion_date} =  ${lexbizz_item_warehouse.ingestion_date}
      and  ${lexbizz_vendor.country_iso}    =  ${lexbizz_item_warehouse.country_iso}
    ;;
  }

  # Join Lexbizz Raw-Data Model
  # ----------------------------------------

}
