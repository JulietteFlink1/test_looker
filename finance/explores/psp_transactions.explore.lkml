include: "/views/**/*.view"
include: "/**/*.view"
include: "/**/*.explore"

explore: psp_transactions {
  from: psp_transactions
  view_label: "* PSP Transactions *"
  group_label: "Finance"
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
      orders.order_date: "",
      orders.is_successful_order: "",
      psp_transactions.merchant_account: "",
      psp_transactions.booking_date: "",
      psp_transactions.record_type: ""
    ]
  }

  join: global_filters_and_parameters {
    sql_on: ${global_filters_and_parameters.generic_join_dim} = TRUE ;;
    type: left_outer
    relationship: many_to_one
  }

join: orders {
  view_label: "* Orders *"
  from: orders
  sql_on: psp_transactions.order_uuid = orders.order_uuid ;;
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

  join: psp_reference_authorised_date {
    view_label: "* PSP Reference Authorised Date *"
    sql_on: ${psp_transactions.psp_reference} = ${psp_reference_authorised_date.psp_reference} ;;
    relationship: many_to_one
    type: left_outer
    fields: [psp_reference_authorised_date.psp_reference_authorised_booking_date,psp_reference_authorised_date.psp_reference_authorised_booking_month]
  }

  join: payment_transactions {
    view_label: "* CT Payment Transactions *"
    sql_on: ${payment_transactions.country_iso} = ${orders.country_iso} AND
      ${payment_transactions.order_uuid}    = ${orders.order_uuid} ;;
    relationship: many_to_many
    type: left_outer
    fields: [payment_transactions.interaction_id]
  }

  # join: payment_transactions {
  #   view_label: "* Payment Transaction *"
  #   sql_on: ${payment_transactions.order_uuid} = ${psp_transactions.order_uuid}
  #   and  ${payment_transactions.interaction_id} = ${psp_transactions.psp_reference} ;;
  #   relationship: many_to_many
  #   type: left_outer
  #   #fields: [psp_reference_authorised_date.psp_reference_authorised_booking_date,psp_reference_authorised_date.psp_reference_authorised_booking_month]
  # }

}
