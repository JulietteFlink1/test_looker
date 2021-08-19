include: "/views/bigquery_tables/curated_layer/*.view"
include: "/**/*.explore"

explore: orders_discounts {
  extends: [orders_cl]
  hidden: yes

  join: discounts {
    sql_on: ${orders_cl.voucher_id}   = ${discounts.discount_id}
       and ${orders_cl.discount_code} = ${discounts.discount_code}
    ;;
    type: left_outer
    relationship: one_to_many
  }

}
