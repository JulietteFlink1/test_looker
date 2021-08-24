include: "/views/bigquery_tables/curated_layer/*.view"
include: "/**/*.explore"

explore: orders_discounts {
  extends: [orders_cl]
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

}
