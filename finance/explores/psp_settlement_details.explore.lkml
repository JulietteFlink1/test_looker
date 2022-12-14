include: "/**/psp_settlement_details.view.lkml"
include: "/**/orders.view.lkml"
include: "/**/hubs_ct.view.lkml"
include: "/**/orderline.view.lkml"
include: "/**/customer_address.view.lkml"
include: "/**/vat_order.view.lkml"
include: "/**/global_filters_and_parameters.view"


include: "/**/*.view"

explore: psp_settlement_details {
  from: psp_settlement_details
  view_label: "* PSP Settlement Details *"
  group_label: "Finance"
  description: "This Explore contains all data coming from Adyen's Settlement Details Report starting from 2022-01-03. It is matched to CT Order data through PSP reference."
  access_filter: {
    field: hubs.country_iso
    user_attribute: country_iso
  }


  always_filter: {
    filters: [
      psp_settlement_details.booking_date: "last 7 days",
      orders.order_date: "",
      psp_settlement_details.country_iso: "",
      psp_settlement_details.merchant_account: "",
      psp_settlement_details.psp_reference: "",
      psp_settlement_details.type: "",
    ]
  }

  join: global_filters_and_parameters {
    sql: ;;
    # Use `sql` instead of `sql_on` and put some whitespace in it
    relationship: one_to_one
    fields: [global_filters_and_parameters.is_after_product_discounts]
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

  join: orderline {
    view_label: "* Order Lineitems *"
    sql_on: ${orderline.country_iso} = ${orders.country_iso} AND
      ${orderline.order_uuid}    = ${orders.order_uuid} ;;
    relationship: one_to_many
    type: left_outer
  }

  join: products {
    view_label: ""
    sql_on:
        ${products.product_sku} = ${orderline.product_sku} and
        ${products.country_iso} = ${orderline.country_iso}
        ;;
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
