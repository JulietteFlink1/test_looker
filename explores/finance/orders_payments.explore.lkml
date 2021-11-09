include: "/views/**/*.view"
include: "/**/*.view"
include: "/**/*.explore"

explore: orders_payments {
  extends: [order_orderline_cl]
  label: "Orders Payments"
  view_label: "* Orders *"
  #view_name: orders_customers
  group_label: "Finance"
  description: "Payment and Transactions Data on Order Level"
  hidden: no
  # view_name: base_order_orderline
  #extension: required

  join: payment_transactions {
    view_label: "* Payment Transactions *"
    sql_on: ${payment_transactions.country_iso} = ${orders_cl.country_iso} AND
      ${payment_transactions.order_uuid}    = ${orders_cl.order_uuid} ;;
    relationship: many_to_many
    type: left_outer
  }
  }
