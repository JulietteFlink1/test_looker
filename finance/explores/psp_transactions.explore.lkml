include: "/**/psp_transactions.view"
include: "/**/orders.view"
include: "/**/hubs_ct.view"
include: "/**/psp_settlement_details.view"
include: "/**/orderline.view"
include: "/**/payment_transactions.view"
include: "/**/psp_settlement_details.view"
include: "/**/psp_reference_authorised_date.view"
include: "/**/vat_order.view"
include: "/**/global_filters_and_parameters.view"
include: "/**/products.view"
include: "/**/customer_address.view"
include: "/**/ndt_psp_transactions__order_aggregated.view"

explore: psp_transactions {
  from: psp_transactions
  view_label: "PSP Transactions"
  group_label: "Finance"

  access_filter: {
    field: hubs.country_iso
    user_attribute: country_iso
  }

  always_filter: {
    filters: [
      global_filters_and_parameters.datasource_filter: "",
      orders.order_date: "",
      orders.is_successful_order: "",
      psp_transactions.merchant_account: "",
      psp_transactions.booking_date: "",
      psp_transactions.record_type: ""
    ]
  }

  sql_always_where:
  -- filter the time for all big tables of this explore
  {% condition global_filters_and_parameters.datasource_filter %} ${psp_transactions.booking_date} {% endcondition %}
  ;;

  join: global_filters_and_parameters {
    sql_on: ${global_filters_and_parameters.generic_join_dim} = TRUE ;;
    view_label: "Global Filters"
    type: left_outer
    relationship: many_to_one
  }

  join: orders {
    view_label: "Orders"
    from: orders
    sql_on: psp_transactions.order_uuid = orders.order_uuid
    and  {% condition global_filters_and_parameters.datasource_filter %} ${orders.created_date} {% endcondition %};;
    type: left_outer
    relationship: many_to_one
  }

  join: hubs {
    from: hubs_ct
    view_label: "Hubs"
    sql_on: lower(${orders.hub_code}) = ${hubs.hub_code} ;;
    relationship: many_to_one
    type: left_outer
  }

  join: orderline {
    view_label: "Order Lineitems"
    sql_on:  ${orderline.country_iso} = ${orders.country_iso} AND
             ${orderline.order_uuid}    = ${orders.order_uuid} AND
            {% condition global_filters_and_parameters.datasource_filter %} ${orderline.created_date} {% endcondition %} ;;

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
    view_label: "Customer Address"
    sql_on: ${orders.order_uuid} = ${customer_address.order_uuid} ;;
    relationship: one_to_one
    type: left_outer
  }

  join: vat_order {
    view_label: "VAT on Order Level"
    sql_on: ${orders.order_uuid} = ${vat_order.order_uuid}
       and {% condition global_filters_and_parameters.datasource_filter %} ${vat_order.order_date} {% endcondition %} ;;
    relationship: one_to_one
    type: left_outer
  }

  join: psp_reference_authorised_date {
    view_label: "PSP Transactions"
    sql_on: ${psp_transactions.psp_reference} = ${psp_reference_authorised_date.psp_reference};;
    relationship: many_to_one
    type: left_outer
    fields: [psp_reference_authorised_date.psp_reference_authorised_booking_date,psp_reference_authorised_date.psp_reference_authorised_booking_month]
  }

  join: payment_transactions {
    view_label: "CT Payment Transactions"
    sql_on: ${payment_transactions.country_iso} = ${orders.country_iso} AND
      ${payment_transactions.order_uuid}    = ${orders.order_uuid} ;;
    relationship: many_to_many
    type: left_outer
    fields: [payment_transactions.interaction_id]
  }

  join: psp_settlement_details {
    view_label: "PSP Settlement"
    sql_on: ${psp_transactions.psp_reference}  = ${psp_settlement_details.psp_reference}
        and {% condition global_filters_and_parameters.datasource_filter %} ${psp_settlement_details.booking_date} {% endcondition %} ;;

    relationship: many_to_many
    ## Full Outer Join to cover potential cases where psp_reference is missing in one or the other table.
    type: full_outer
  }

  join: ndt_psp_transactions__order_aggregated {
    view_label: "PSP Transactions"
    sql_on: ${psp_transactions.order_uuid}  = ${ndt_psp_transactions__order_aggregated.order_uuid}
         and {% condition global_filters_and_parameters.datasource_filter %} ${ndt_psp_transactions__order_aggregated.psp_transactions_booking_date} {% endcondition %}
         and {% condition global_filters_and_parameters.datasource_filter %} ${ndt_psp_transactions__order_aggregated.psp_settlement_booking_date} {% endcondition %}
         and {% condition global_filters_and_parameters.datasource_filter %} ${ndt_psp_transactions__order_aggregated.order_date} {% endcondition %}
      ;;
    relationship: many_to_one
    type: left_outer
  }


}
