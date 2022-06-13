include: "/**/*.view"

# THis is a explore that aims to be the more comprehensive version of vendor_performance
# and will replace vendor_performance once properly tested

explore: vendor_performance_overview {

  hidden: yes

  from: products_hub_assignment_v2
  view_name: products_hub_assignment
  view_label: "* Global *"

  fields: [
    products_hub_assignment.minimal_fields*,
    global_filters_and_parameters.datasource_filter,
    bulk_items.main_fields*, bulk_items.cross_referenced_fields*,
    inventory_changes_daily*,
    vendor_performance_fill_rate*,
    products*,
    vendor_performance_ndt_desadv_fill_rates*,
    purchase_orders.main_fields*
  ]

  sql_always_where: {% condition global_filters_and_parameters.datasource_filter %} ${products_hub_assignment.report_date} {% endcondition %} ;;

  always_filter: {filters: [global_filters_and_parameters.datasource_filter: "8 days ago for 7 days"]}

  join: global_filters_and_parameters {
    view_label: "* Global *"
    sql_on: ${global_filters_and_parameters.generic_join_dim} = TRUE ;;
    type: left_outer
    relationship: one_to_one
  }





  join: bulk_items{

    view_label: "* DESADV data *"

    type: left_outer
    relationship: one_to_many
    sql_on:
            ${products_hub_assignment.report_date}                                = ${bulk_items.delivery_date}
        and ${products_hub_assignment.hub_code}                                   = ${bulk_items.hub_code}
        and ${products_hub_assignment.leading_sku_replenishment_substitute_group} = ${bulk_items.sku}
        and {% condition global_filters_and_parameters.datasource_filter %} ${bulk_items.delivery_date} {% endcondition %}
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

    fields: [inventory_changes_daily.sum_inbound_inventory,
      inventory_changes_daily.sku,
      inventory_changes_daily.parent_sku,
      inventory_changes_daily.is_inbound
    ]
  }

  join: vendor_performance_ndt_desadv_fill_rates {

    view_label: "* DESADV data *"

    type: left_outer
    relationship: many_to_one
    sql_on: ${vendor_performance_ndt_desadv_fill_rates.dispatch_notification_id} =  ${bulk_items.dispatch_notification_id};;

    fields: [
      vendor_performance_ndt_desadv_fill_rates.is_desadv_inbounded_po_corrected
    ]
  }

  join: products {

    type: left_outer
    relationship: many_to_one
    sql_on: ${products.product_sku} = ${products_hub_assignment.sku} ;;
  }

  join: purchase_orders {

    view_label: "* Purchase Order (PO) data *"

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

}
