include: "/**/*.view"
include: "/**/*.explore"

explore: order_comments{
  hidden: yes
  label: "Order Delivery Notes"
  view_label: "Order Delivery Notes"
  group_label: "Consumer Product"
  description: "Extends backend orders to count delivery notes"

  join: global_filters_and_parameters {
    sql: ;;
    # Use `sql` instead of `sql_on` and put some whitespace in it
    relationship: one_to_one
  }
}
