include: "/explores/base_explores/base_orders.explore"
include: "/explores/base_explores/base_order_address.explore"
include: "/explores/base_explores/base_order_discount_order_vouchers.explore"
include: "/explores/base_explores/base_order_fulfillment.explore"
include: "/explores/base_explores/base_order_payment.explore"
include: "/explores/base_explores/base_order_user_order_facts.explore"
include: "/views/discount_voucher.view.lkml"

explore: base_order_order {
  group_label: "01) Performance"
  label: "Order test"
  description: "This is the clean version of orders explore"
  extends: [base_orders, base_order_address, base_order_discount_order_vouchers,
    base_order_fulfillment, base_order_payment, base_order_user_order_facts]
  #view_label: "Discount Vouchers Clean"
  # The additional things you want to add or change
  # in the new Explore

}
