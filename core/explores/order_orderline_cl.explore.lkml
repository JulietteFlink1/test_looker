include: "/**/*.view"
include: "/**/*.explore"


explore: order_orderline_cl {

  extends: [orders_cl]

  group_label: "01) Performance"
  label:       "Orders & Lineitems"
  description: "Orderline Items sold quantities, prices, gmv, etc."
  hidden: no

  # take all fields except those in the pricing_fields_refined set in erp_product_hub_vendor_assignment_v2_buying_prices.view
  fields: [ALL_FIELDS*,
           -erp_product_hub_vendor_assignment.pricing_fields_refined*,
           -erp_buying_prices.margin_metrics_customized*]

  join: orderline {

    view_label: "Order Lineitems"
    sql_on: ${orderline.country_iso} = ${orders_cl.country_iso} AND
            ${orderline.order_uuid}    = ${orders_cl.order_uuid} AND
            {% condition global_filters_and_parameters.datasource_filter %} ${orderline.created_date} {% endcondition %}

            ;;
    relationship: one_to_many
    type: left_outer
  }

  join: products {

    view_label: "Product Data (CT)"

    sql_on:
        ${products.product_sku} = ${orderline.product_sku} and
        ${products.country_iso} = ${orderline.country_iso}
        ;;
    relationship: many_to_one
    type: left_outer
  }

  join: lexbizz_item {

    view_label: ""
    from: erp_item

    type: left_outer
    relationship: many_to_one
    sql_on: ${lexbizz_item.sku}            = ${orderline.product_sku}
        and ${lexbizz_item.ingestion_date} = current_date()
    ;;
  }

  join: oracle_item_location_fact {
    view_label: "Product-Hub Data (as of today)"
    type: left_outer
    relationship: many_to_one
    sql_on:
        ${oracle_item_location_fact.hub_code} = ${orderline.hub_code}
    and ${oracle_item_location_fact.sku}      = ${orderline.product_sku}
    ;;
    fields: [oracle_item_location_fact.current_state__item_at_location_status]
  }

  join: customer_address {
    # can only be seen by people with related permissions
    sql_on: ${orders_cl.order_uuid} = ${customer_address.order_uuid} ;;
    type: left_outer
    relationship: one_to_one
  }

  join: erp_product_hub_vendor_assignment_unfiltered {
    view_label: "Product-Hub Data (historized)"
    sql_on:
        ${erp_product_hub_vendor_assignment_unfiltered.sku}            = ${orderline.product_sku}
    and ${erp_product_hub_vendor_assignment_unfiltered.hub_code}       = ${orderline.hub_code}
    and ${erp_product_hub_vendor_assignment_unfiltered.report_date}    = ${orderline.created_date}
    ;;
    type: left_outer
    relationship: one_to_many
    fields: [erp_product_hub_vendor_assignment_unfiltered.edi,
             erp_product_hub_vendor_assignment_unfiltered.item_at_location_status,
             erp_product_hub_vendor_assignment_unfiltered.supplier_site,
             erp_product_hub_vendor_assignment_unfiltered.supplier_parent_name,
             erp_product_hub_vendor_assignment_unfiltered.supplier_parent_id,
             erp_product_hub_vendor_assignment_unfiltered.supplier_name,
             erp_product_hub_vendor_assignment_unfiltered.supplier_id
            ]
  }

  join: erp_product_hub_vendor_assignment {

    # hiding this table, as it is filtered already by assigned SKUs, which also excludes information on No-Purchase items (we sell them, but do not replenish)
    # this will be deprecated in favour of the raw ERP data
    view_label: ""

    from: erp_product_hub_vendor_assignment

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

    view_label: ""

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

    view_label: ""
    from: erp_item_location

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

    view_label: ""
    from: erp_supplier

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
  join: product_prices_daily {
    relationship: one_to_one
    type: left_outer
    sql_on: ${product_prices_daily.sku}            = ${orderline.product_sku}
        and ${product_prices_daily.hub_code}       = ${orderline.hub_code}
        and ${product_prices_daily.reporting_date} = ${orderline.order_date_utc}
        and {% condition global_filters_and_parameters.datasource_filter %} ${product_prices_daily.reporting_date} {% endcondition %}
        ;;
  }


  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    Buying Price Data - Access Restricted
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  join: erp_buying_prices {
    # hiding this table in favor of the monetary cost values directly in orderline.view
    view_label: ""
    required_access_grants: [can_view_buying_information]

    type: left_outer
    # n orders have the same price
    relationship: many_to_one
    sql_on:
        ${erp_buying_prices.hub_code}         =  ${orderline.hub_code}           and
        ${erp_buying_prices.sku}              =  ${orderline.product_sku}        and
        -- a prive is valid in a certain time frame
        ${orderline.created_date}             = ${erp_buying_prices.report_date} and
        {% condition global_filters_and_parameters.datasource_filter %} ${erp_buying_prices.report_date} {% endcondition %}
    ;;
  }

  join: sales_weighted_avg_buying_prices {
    view_label: ""
    required_access_grants: [can_view_buying_information]

    type: left_outer
    relationship:many_to_one
    sql_on:
        ${sales_weighted_avg_buying_prices.order_lineitem_uuid} =  ${orderline.order_lineitem_uuid}                      and
        ${sales_weighted_avg_buying_prices.product_sku}         =  ${orderline.product_sku}                              and
        ${sales_weighted_avg_buying_prices.hub_code}            =  ${orderline.hub_code}                                 and
        ${sales_weighted_avg_buying_prices.created_date}        =  ${orderline.created_date}
    ;;
    fields: [sales_weighted_avg_buying_prices.weighted_buying_price]
  }

  join: inbound_outbound_kpi_report_ndt_waste_per_day_and_hub {
    required_access_grants: [can_view_buying_information]

    view_label: "Orders"

    type: full_outer
    relationship: many_to_one
    sql_on:
        ${orders_cl.created_date} = ${inbound_outbound_kpi_report_ndt_waste_per_day_and_hub.inventory_change_date} and
        ${orders_cl.hub_code}     = ${inbound_outbound_kpi_report_ndt_waste_per_day_and_hub.hub_code}
    ;;
  }

  join: assortment_puzzle_pieces {

    view_label: "Puzzle Pieces Logic"

    type: full_outer
    relationship: many_to_one
    sql_on:
          ${orderline.created_date} = ${assortment_puzzle_pieces.ingestion_date}
      and ${orderline.hub_code}     = ${assortment_puzzle_pieces.hub_code}
      and ${orderline.product_sku}  = ${assortment_puzzle_pieces.sku}
      and {% condition global_filters_and_parameters.datasource_filter %} ${assortment_puzzle_pieces.ingestion_date} {% endcondition %}
    ;;
  }

}
