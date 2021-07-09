
include: "/explores/base_explores/base_orders.explore"
include: "/views/discount_voucher.view.lkml"

explore: base_order_discount_order_vouchers {
  #group_label: "03) Vouchers"
  #label: "Discount Vouchers"
  description: "This is the clean version of discount vouchers"
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
}
