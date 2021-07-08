include: "/explores/base_explores/base_orders.explore"
include: "/views/payment_payment.view.lkml"
include: "/views/payment_transaction.view.lkml"

explore: payment {
  #group_label: "01) Performance"
  #label: "Order Fulfillment"
  description: "This is the clean version of payment data"
  extends: [base_orders]
  #view_label: "Order Fulfillment Clean"
  # The additional things you want to add or change
  # in the new Explore
  join: payment_payment {
    view_label: "* Payments *"
    sql_on: ${base_orders.country_iso} = ${payment_payment.country_iso} and
      ${base_orders.id} = ${payment_payment.order_id};;
    relationship: one_to_many
    type: left_outer
  }

  join: payment_transaction {
    view_label: "* Payments *"
    sql_on: ${payment_payment.country_iso} = ${payment_transaction.country_iso} and
      ${payment_payment.id} = ${payment_transaction.payment_id};;
    relationship: one_to_many
    type: left_outer
  }
}
