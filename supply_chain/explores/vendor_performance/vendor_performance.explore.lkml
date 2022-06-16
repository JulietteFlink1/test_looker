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

  label: "Vendor Performance Overivew"
  group_label: "Supply Chain"

  from: products_hub_assignment_v2
  view_name: products_hub_assignment
  view_label: "* Global *"

  fields: [
    products_hub_assignment.minimal_fields*,
    global_filters_and_parameters.datasource_filter,
    bulk_items.main_fields*, bulk_items.cross_referenced_fields*,
    inventory_changes_daily*,
    inventory_changes*,
    vendor_performance_ndt_desadv_fill_rates*,
    vendor_performance_ndt_percent_inbounded*,
    products*,
    purchase_orders.main_fields*,
    erp_product_hub_vendor_assignment_v2*,
    hubs*
  ]

  sql_always_where: {% condition global_filters_and_parameters.datasource_filter %} ${products_hub_assignment.report_date} {% endcondition %} ;;

  always_filter: {filters: [global_filters_and_parameters.datasource_filter: "8 days ago for 7 days"]}

  join: global_filters_and_parameters {
    view_label: "* Global *"
    sql_on: ${global_filters_and_parameters.generic_join_dim} = TRUE ;;
    type: left_outer
    relationship: one_to_one
  }




  join: bulk_items {

    from: dispatch_notifications

    view_label: "* DESADVs *"

    type: left_outer
    relationship: one_to_many
    sql_on:
            ${products_hub_assignment.report_date}                                = ${bulk_items.delivery_date}
        and ${products_hub_assignment.hub_code}                                   = ${bulk_items.hub_code}
        and ${products_hub_assignment.leading_sku_replenishment_substitute_group} = ${bulk_items.sku}
        and {% condition global_filters_and_parameters.datasource_filter %} ${bulk_items.delivery_date} {% endcondition %}
    ;;
    sql_where: ${bulk_items.sku} is not null -- excludes deposits (we don't have a SKU for those) ;;
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
      inventory_changes_daily.is_outbound_waste
    ]
  }

  join: inventory_changes {

    type: left_outer
    relationship: one_to_many
    sql_on:
            ${inventory_changes.inventory_change_timestamp_date} = ${products_hub_assignment.report_date}
        and ${inventory_changes.hub_code}                        = ${products_hub_assignment.hub_code}
        and ${inventory_changes.sku}                             = ${products_hub_assignment.sku}
        and {% condition global_filters_and_parameters.datasource_filter %} ${inventory_changes.inventory_change_timestamp_date} {% endcondition %}
    ;;

    fields: [
      inventory_changes.inventory_change_timestamp_time,
      inventory_changes.is_inbound,
      inventory_changes.sum_inbound_inventory,
      inventory_changes.sku
    ]
  }

  join: vendor_performance_ndt_desadv_fill_rates {

    view_label: "* DESADVs *"

    type: left_outer
    relationship: many_to_one
    sql_on: ${vendor_performance_ndt_desadv_fill_rates.dispatch_notification_id} =  ${bulk_items.dispatch_notification_id};;

    fields: [
      vendor_performance_ndt_desadv_fill_rates.is_desadv_inbounded_po_corrected
    ]
  }

  join: vendor_performance_ndt_percent_inbounded {

    view_label: "* DESADVs *"

    type: left_outer
    relationship: one_to_many
    sql_on:
          ${vendor_performance_ndt_percent_inbounded.dispatch_notification_id} = ${bulk_items.dispatch_notification_id}
      and ${vendor_performance_ndt_percent_inbounded.sku_desadv} = ${bulk_items.sku}
      and {% condition global_filters_and_parameters.datasource_filter %} date(${vendor_performance_ndt_percent_inbounded.estimated_delivery_timestamp}) {% endcondition %}
    ;;
  }

  join: products {

    type: left_outer
    relationship: many_to_one
    sql_on: ${products.product_sku} = ${products_hub_assignment.sku} ;;
  }

  join: purchase_orders {

    view_label: "* Purchase Orders (PO) *"

    from: replenishment_purchase_orders

    type: left_outer
    relationship: one_to_many
    sql_on:
            ${products_hub_assignment.report_date}                                = ${purchase_orders.delivery_date}
        and ${products_hub_assignment.hub_code}                                   = ${purchase_orders.hub_code}
        and ${products_hub_assignment.leading_sku_replenishment_substitute_group} = ${purchase_orders.sku}
        and {% condition global_filters_and_parameters.datasource_filter %} ${purchase_orders.delivery_date} {% endcondition %}
    ;;
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

  join: hubs {

    from:  hubs_ct
    type: left_outer
    relationship: many_to_one
    sql_on: ${hubs.hub_code} = ${products_hub_assignment.hub_code} ;;
    fields: [
      hubs.city_manager
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

}
