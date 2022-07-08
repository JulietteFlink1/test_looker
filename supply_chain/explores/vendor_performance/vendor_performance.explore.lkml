# Owner:
# Andreas Stüber
#
# Main Stakeholder:
# - Supply Chain team
# - Hub-Ops team
#
# Questions that can be answered
# - All questions around vendor delivery performance
# - questions concerning how well Flink inbounds arriving deliveries

include: "/**/*.view"




explore: vendor_performance {

  hidden: no

  label: "Vendor Performance"
  group_label: "Supply Chain"

  from: products_hub_assignment_v2
  view_name: products_hub_assignment
  view_label: "* Global *"

  fields: [
    products_hub_assignment.minimal_fields*,
    global_filters_and_parameters.datasource_filter,
    global_filters_and_parameters.timeframe_picker,
    global_filters_and_parameters.show_info,
    bulk_items.main_fields*, bulk_items.cross_referenced_fields*,
    inventory_changes_daily*,
    vendor_performance_ndt_desadv_fill_rates*,
    vendor_performance_ndt_date_hub_sku_metrics_desadv*,
    vendor_performance_ndt_date_hub_sku_metrics_po*,
    hub_ops_inbounding_kpis*,
    vendor_performance_po_to_desadv*,
    products*,
    purchase_orders.main_fields*, purchase_orders.cross_references_inventory_changes_daily*,
    lexbizz_vendor*,
    vendor_performance_ndt_po_fill_rate*,
    erp_product_hub_vendor_assignment_v2*,
    hubs*
  ]

  sql_always_where: {% condition global_filters_and_parameters.datasource_filter %} ${products_hub_assignment.report_date} {% endcondition %} ;;

  always_filter: {filters: [global_filters_and_parameters.datasource_filter: "8 days ago for 7 days"]}
  access_filter: {
    field: hubs.country_iso
    user_attribute: country_iso

  }
  access_filter: {
    field: hubs.city
    user_attribute: city
  }

  join: global_filters_and_parameters {
    view_label: "* Global *"
    sql_on: ${global_filters_and_parameters.generic_join_dim} = TRUE ;;
    type: left_outer
    relationship: one_to_one

  }


  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    Main Tables
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  join: bulk_items {

    from: dispatch_notifications

    view_label: "* DESADVs *"

    type: left_outer
    relationship: one_to_many
    sql_on:
            ${products_hub_assignment.report_date}                                = ${bulk_items.delivery_date}
        and ${products_hub_assignment.hub_code}                                   = ${bulk_items.hub_code}
        and ${products_hub_assignment.leading_sku_replenishment_substitute_group} = ${bulk_items.sku}
        -- filters when joining
        and {% condition global_filters_and_parameters.datasource_filter %} ${bulk_items.delivery_date} {% endcondition %}
        and ${bulk_items.sku} is not null -- excludes deposits (we don't have a SKU for those)
    ;;
  }

  join: inventory_changes_daily {

    type: left_outer
    relationship: one_to_many
    sql_on:
           ${products_hub_assignment.report_date} = ${inventory_changes_daily.inventory_change_date}
       and ${products_hub_assignment.hub_code}    = ${inventory_changes_daily.hub_code}
       and ${products_hub_assignment.sku}         = ${inventory_changes_daily.sku}
       and {% condition global_filters_and_parameters.datasource_filter %} ${inventory_changes_daily.inventory_change_date} {% endcondition %}
    ;;

    fields: [
      inventory_changes_daily.sum_inbound_inventory,
      inventory_changes_daily.sum_outbound_orders,
      inventory_changes_daily.sum_outbound_waste,
      inventory_changes_daily.sum_inventory_correction_increased,
      inventory_changes_daily.sum_inventory_correction_reduced,
      inventory_changes_daily.sum_correction_order_cancelled,
      inventory_changes_daily.sum_correction_product_damaged,
      inventory_changes_daily.sum_correction_product_delivery_damaged,
      inventory_changes_daily.sum_correction_product_expired,
      inventory_changes_daily.sum_correction_product_delivery_expired,
      inventory_changes_daily.sum_outbound_too_good_to_go,
      inventory_changes_daily.sku,
      inventory_changes_daily.parent_sku,
      inventory_changes_daily.is_inbound,
      inventory_changes_daily.change_reason,
      inventory_changes_daily.is_outbound_waste,
      inventory_changes_daily.pct_product_delivery_damaged_to_inbounds,
      inventory_changes_daily.dynamic_inventory_change_date,
      inventory_changes_daily.quantity_change_inbounded
    ]
  }


  join: purchase_orders {

    view_label: "* Purchase Orders (PO) *"

    from: replenishment_purchase_orders

    type: left_outer
    relationship: many_to_one
    sql_on:
            ${products_hub_assignment.report_date}                                = ${purchase_orders.delivery_date}
        and ${products_hub_assignment.hub_code}                                   = ${purchase_orders.hub_code}
        and ${products_hub_assignment.leading_sku_replenishment_substitute_group} = ${purchase_orders.sku}
        -- only include purchase orders, that were actually sent to the suppliers
        -- and ${purchase_orders.status} = 'Sent'
        and {% condition global_filters_and_parameters.datasource_filter %} ${purchase_orders.delivery_date} {% endcondition %}
    ;;
  }

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    Aggregated Reporting Dataset Tables
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  join: hub_ops_inbounding_kpis {
    view_label: "* DESADVs *"

    type: left_outer
    relationship: many_to_one
    sql_on:
      ${bulk_items.dispatch_notification_id} = ${hub_ops_inbounding_kpis.dispatch_notification_id};;
  }

  join: vendor_performance_po_to_desadv {

    view_label: "* Purchase Orders (PO) *"
    # view_label: ""

    type: left_outer
    # not working properly
    relationship: one_to_one
    sql_on:
            safe_cast(${purchase_orders.order_number} as int64) = ${vendor_performance_po_to_desadv.order_number}
        and ${purchase_orders.sku} = ${vendor_performance_po_to_desadv.sku}
    ;;
  }



  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    Native Derived Tables
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  join: vendor_performance_ndt_desadv_fill_rates {

    view_label: "* DESADVs *"

    type: left_outer
    relationship: many_to_one
    sql_on: ${vendor_performance_ndt_desadv_fill_rates.dispatch_notification_id} =  ${bulk_items.dispatch_notification_id};;

  }

  join: vendor_performance_ndt_date_hub_sku_metrics_desadv {

    view_label: "* DESADVs *"

    type: left_outer
    relationship: one_to_one
    sql_on:
            ${vendor_performance_ndt_date_hub_sku_metrics_desadv.report_date} = ${products_hub_assignment.report_date}
        and ${vendor_performance_ndt_date_hub_sku_metrics_desadv.hub_code}    = ${products_hub_assignment.hub_code}
        and ${vendor_performance_ndt_date_hub_sku_metrics_desadv.leading_sku_replenishment_substitute_group} = ${products_hub_assignment.leading_sku_replenishment_substitute_group}
    ;;
  }


  join: vendor_performance_ndt_po_fill_rate {

    view_label: "* Purchase Orders (PO) *"

    type: left_outer
    relationship: many_to_one
    sql_on:
      ${purchase_orders.order_number} = ${vendor_performance_ndt_po_fill_rate.order_number}
    ;;
  }

  join: vendor_performance_ndt_date_hub_sku_metrics_po {

    view_label: "* Purchase Orders (PO) *"

    type: left_outer
    relationship: one_to_one
    sql_on:
            ${vendor_performance_ndt_date_hub_sku_metrics_po.report_date} = ${products_hub_assignment.report_date}
        and ${vendor_performance_ndt_date_hub_sku_metrics_po.hub_code}    = ${products_hub_assignment.hub_code}
        and ${vendor_performance_ndt_date_hub_sku_metrics_po.leading_sku_replenishment_substitute_group} = ${products_hub_assignment.leading_sku_replenishment_substitute_group}
    ;;
  }



  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    Master Data
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  join: hubs {

    from:  hubs_ct
    type: left_outer
    relationship: many_to_one
    sql_on: ${hubs.hub_code} = ${products_hub_assignment.hub_code} ;;
    fields: [
      hubs.city_manager,
      hubs.city,
      hubs.country_iso
    ]
  }

  join: erp_product_hub_vendor_assignment_v2 {

    view_label: "* Global *"

    type: left_outer
    relationship: one_to_one
    sql_on:
        ${erp_product_hub_vendor_assignment_v2.report_date} = ${products_hub_assignment.report_date}
    and ${erp_product_hub_vendor_assignment_v2.hub_code}    = ${products_hub_assignment.hub_code}
    and ${erp_product_hub_vendor_assignment_v2.sku}         = ${products_hub_assignment.sku}
    and {% condition global_filters_and_parameters.datasource_filter %} ${erp_product_hub_vendor_assignment_v2.report_date} {% endcondition %}
    ;;

    fields: [
      erp_product_hub_vendor_assignment_v2.vendor_id,
      erp_product_hub_vendor_assignment_v2.vendor_name
    ]
  }

  join: lexbizz_vendor {

    view_label: "* Purchase Orders (PO) *"

    type: left_outer
    relationship: many_to_one
    sql_on:
          ${lexbizz_vendor.vendor_id} = ${purchase_orders.vendor_id}
      and ${lexbizz_vendor.ingestion_date} = current_date()-1
    ;;

    fields: [lexbizz_vendor.vendor_name]
  }



  # joined to account for erp_buying_price dependency in purchase_orders
  join: erp_buying_prices {

    view_label: ""
    type: left_outer
    relationship: one_to_one
    sql_on:
            ${erp_buying_prices.report_date} = ${products_hub_assignment.report_date}
        and ${erp_buying_prices.hub_code} = ${products_hub_assignment.hub_code}
        and ${erp_buying_prices.sku} = ${products_hub_assignment.sku}
    ;;
  }

  join: products {

    type: left_outer
    relationship: many_to_one
    sql_on: ${products.product_sku} = ${products_hub_assignment.sku} ;;
  }

}
