include: "/**/*.explore"
include: "/**/*.view"

explore: avg_order_basket_per_category {
  extends: [order_orderline_cl]
  label: "Test"
  view_label: "* Test *"
  group_label: "15) Ad-Hoc"
  hidden: no

  join: avg_order_month_category_grouped {
    sql_on: (${orders_cl.order_date}) = (${avg_order_month_category_grouped.created_date}) ;;
    relationship: many_to_one
    type: left_outer
  }
}
