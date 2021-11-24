include: "/views/**/*.view"
include: "/**/*.view"
include: "/**/*.explore"

explore: psp_transactions {
  extends: [orders_cl]
  label: "PSP Transactions"
  view_label: "* Orders *"
  #view_name: orders_customers
  group_label: "Finance"
  description: "PSP and Transactions Data on Order Level"
  hidden: no
  # view_name: base_order_orderline
  #extension: required

  join: psp_transactions {
    view_label: "* PSP Transactions *"
    sql_on:
      ${psp_transactions.order_uuid} = ${orders_cl.order_uuid} ;;
    relationship: one_to_many
    type: full_outer
  }
}
