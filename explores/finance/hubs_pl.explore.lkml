include: "/views/**/*.view"
include: "/**/*.view"
include: "/**/*.explore"


explore: hubs_pl {
  label: "Hubs P&Ls"
  view_name:  hub_pl_data
  view_label: "* Gsheet P&L Input *"
  group_label: "Finance"

  required_access_grants: [can_view_buying_information]

  access_filter: {
    field: hubs.country_iso
    user_attribute: country_iso
  }

  access_filter: {
    field: hubs.city
    user_attribute: city
  }

  always_filter: {
    filters: [
      orders.is_successful_order: "Yes",
    ]
  }

  join: orders {
    sql_on: ${hub_pl_data.hub_code} = ${orders.hub_code} and cast(${orders.order_month} as string) = ${hub_pl_data.month_string};;
    relationship: many_to_many
    view_label: "* Orders - GMV & Delivery Fees *"
    type: left_outer
    fields: [orders.sum_gmv_gross,
             orders.sum_delivery_fee_gross,
             orders.sum_gmv_net,
             orders.sum_delivery_fee_net,
             orders.is_successful_order
          ]
  }

  join: hubs {
    from: hubs_ct
    view_label: "* Hubs *"
    sql_on: lower(${orders.hub_code}) = ${hubs.hub_code} ;;
    relationship: many_to_one
    type: left_outer
    fields: [hubs.cost_center,
            hubs.country_iso,
            hubs.hub_code,
            hubs.city]
  }

  join: shyftplan_riders_pickers_hours {
    from: shyftplan_riders_pickers_hours_clean
    view_label: ""
    sql_on: ${orders.created_date} = ${shyftplan_riders_pickers_hours.date} and
      ${hubs.hub_code}          = lower(${shyftplan_riders_pickers_hours.hub_name});;
    relationship: many_to_one
    type: left_outer
  }

  join: orderline {
    view_label: "* Deposit *"
    sql_on: ${orderline.country_iso} = ${orders.country_iso} AND
      ${orderline.order_uuid}    = ${orders.order_uuid} ;;
    relationship: one_to_many
    type: left_outer
    fields: [orderline.amt_total_deposit]

  }

  join: products {
    view_label: ""
    sql_on: ${products.product_sku} = ${orderline.product_sku} ;;
    relationship: many_to_one
    type: left_outer
  }

  join: vat_order {
    view_label: "* VAT, Refunds & Discounts *"
    sql_on: ${orders.order_uuid} = ${vat_order.order_uuid} ;;
    relationship: one_to_one
    type: left_outer
    fields: [vat_order.sum_discount_amount_gross,
             vat_order.sum_discount_amount_net,
             vat_order.sum_refund_amount_gross,
             vat_order.sum_refund_amount_net,
             vat_order.sum_total_vat,
             vat_order.sum_items_price_gross]
  }

  join: global_filters_and_parameters {
    sql_on: ${global_filters_and_parameters.generic_join_dim} = TRUE ;;
    type: left_outer
    relationship: many_to_one
  }

  join: psp_transactions {
    view_label: "* Transaction Fees *"
    sql_on: ${psp_transactions.order_uuid} = ${orders.order_uuid} ;;
    type: left_outer
    relationship: many_to_one
    fields: [psp_transactions.sum_processing_fee_fc,
             psp_transactions.sum_scheme_fees_sc,
             psp_transactions.sum_interchange_sc
            ]
  }

  join: inventory_changes {
    view_label: "* Waste *"
    sql_on: ${inventory_changes.hub_code} = ${hub_pl_data.hub_code}
    and cast(${inventory_changes.inventory_change_timestamp_month} as string) = ${hub_pl_data.month_string} ;;
    type: left_outer
    relationship: many_to_many
    fields: [inventory_changes.sum_outbound_waste_eur,
             inventory_changes.is_outbound_waste,


            ]
  }

}
