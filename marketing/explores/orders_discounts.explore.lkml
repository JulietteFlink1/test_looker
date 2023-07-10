include: "/**/*.view"
include: "/*/**/vat_order.view.lkml"

include: "/**/*.explore"

explore: orders_discounts {
  extends: [order_orderline_cl]
  hidden: yes
  group_label: "Cart Discounts"
  label: "Order Cart Discounts"
  description: "Order data around Discount Codes created in the backend"

  join: discounts {
    sql_on:
        -- For T1 the discount id is null and we join only on the discount code.
        ${orders_cl.discount_code} = ${discounts.discount_code}
        and coalesce(${orders_cl.voucher_id},'') = coalesce(${discounts.discount_id},'')
    ;;
    type: left_outer
    relationship: many_to_one
  }

  join: influencer_vouchers_input {
    view_label: "* Discount Code Mapping *"
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
    fields: [vat_order.sum_vat_discount_amount_total,vat_order.sum_discount_amount_net]
  }

}
