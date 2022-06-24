include: "/**/psp_settlement_details.view.lkml"
include: "/**/orders.view.lkml"
include: "/**/hubs_ct.view.lkml"
include: "/**/shyftplan_riders_pickers_hours.view.lkml"
include: "/**/orderline.view.lkml"
include: "/**/customer_address.view.lkml"
include: "/**/vat_order.view.lkml"

include: "/**/*.view"

explore: psp_settlement_details {
  from: psp_settlement_details
  view_label: "* PSP Settlement Details *"
  group_label: "Finance"
  description: "This Explore contains all data coming from Adyen's Settlement Details Report starting from 2022-01-03. It is matched to CT Order data through PSP reference."
  fields: [ALL_FIELDS*,-shyftplan_riders_pickers_hours.rider_utr_cleaned, -orders.pct_orders_delivered_by_riders]
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
      psp_settlement_details.booking_date: "28 days ago for 28 days",
      orders.order_date: "",
      psp_settlement_details.country_iso: "",
      psp_settlement_details.merchant_account: "",
      psp_settlement_details.psp_reference: "",
      psp_settlement_details.type: "",
    ]
  }

  join: orders {
    view_label: "* Orders *"
    from: orders
    sql_on: psp_settlement_details.order_uuid = orders.order_uuid ;;
    type: left_outer
    relationship: many_to_one
  }

  join: hubs {
    from: hubs_ct
    view_label: "* Hubs *"
    sql_on: lower(${orders.hub_code}) = ${hubs.hub_code} ;;
    relationship: many_to_one
    type: left_outer
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
    view_label: "* Order Lineitems *"
    sql_on: ${orderline.country_iso} = ${orders.country_iso} AND
      ${orderline.order_uuid}    = ${orders.order_uuid} ;;
    relationship: one_to_many
    type: left_outer
  }

  join: products {
    view_label: ""
    sql_on: ${products.product_sku} = ${orderline.product_sku} ;;
    relationship: many_to_one
    type: left_outer
  }

  join: customer_address {
    view_label: "* Customer Address *"
    sql_on: ${orders.order_uuid} = ${customer_address.order_uuid} ;;
    relationship: one_to_one
    type: left_outer
  }

  join: vat_order {
    view_label: "* VAT on Order Level *"
    sql_on: ${orders.order_uuid} = ${vat_order.order_uuid} ;;
    relationship: one_to_one
    type: left_outer
  }

}
