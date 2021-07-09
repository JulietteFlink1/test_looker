include: "/explores/base_explores/base_orders.explore"
include: "/views/account_address.view.lkml"

explore: address {
  #group_label: "03) Vouchers"
  #label: "Address"
  description: "This is the clean version of user address"
  extends: [base_orders]
  #view_label: "Discount Vouchers Clean"
  # The additional things you want to add or change
  # in the new Explore
  join: discount_voucher {
    sql_on: ${discount_voucher.country_iso} = ${base_orders.country_iso} AND
      ${discount_voucher.id} = ${base_orders.voucher_id};;
    type: left_outer
    relationship: many_to_one
  }

  join: shipping_address {
    view_label: "* Customer Address (Shipping) *"
    from: account_address
    type: left_outer
    relationship: one_to_one
    sql_on: ${base_orders.country_iso} = ${shipping_address.country_iso} AND
      ${base_orders.shipping_address_id} = ${shipping_address.id} ;;
  }

  join: billing_address {
    view_label: "* Customer Address (Billing) *"
    from: account_address
    type: left_outer
    relationship: one_to_one
    sql_on: ${base_orders.country_iso} = ${billing_address.country_iso} AND
      ${base_orders.billing_address_id} = ${billing_address.id} ;;
  }
}
