include: "/explores/**/*.explore"
include: "/views/**/*.view"

# explore created for Nima
# should only be needed for 1-2 month, starting 2021-10-11
explore: orders_cl_refunds_logs {
  extends: [orders_cl]
  hidden: yes

  join: refund_logs {
    view_label: "* Refunds Logs *"
    sql_on:  ${refund_logs.order_number} = ${orders_cl.order_number};;
    type: left_outer
    relationship: one_to_one
  }
}
