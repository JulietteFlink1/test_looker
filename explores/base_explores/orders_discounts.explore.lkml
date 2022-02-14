include: "/views/bigquery_tables/curated_layer/*.view"
include: "/views/bigquery_tables/reporting_layer/*.view"
include: "/views/sql_derived_tables/vat_order.view.lkml"

include: "/**/*.explore"

explore: orders_discounts {
  extends: [order_orderline_cl]
  hidden: no
  group_label: "03) Vouchers"
  label: "Order Vouchers"
  description: "Order data around Vouchers created in the backend"

  join: discounts {
    sql_on: ${orders_cl.voucher_id}   = ${discounts.discount_id}
       and ${orders_cl.discount_code} = ${discounts.discount_code}
    ;;
    type: left_outer
    relationship: one_to_many
  }

  join: influencer_vouchers_input {
    view_label: "* Voucher Mapping *"
    sql_on: ${orders_cl.country_iso} = ${influencer_vouchers_input.country_iso} AND
      ${orders_cl.discount_code} = ${influencer_vouchers_input.voucher_code} ;;
    relationship: many_to_one
    type: left_outer
  }

  join: vat_order {
    view_label: "* VAT *"
    sql_on: ${orders_cl.order_uuid} = ${vat_order.order_uuid} ;;
    relationship: one_to_one
    type: left_outer
    fields: [vat_order.discount_amount_net, vat_order.vat_discount_amount_total]
  }

}
