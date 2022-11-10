# Owner: Product Analytics, Galina Larina, Zhou Fang

# Main Stakeholder:
# - Consumer Product (Addresses)

# Questions that can be answered
# - how many orders have delivery notes?


include: "/**/*.view"

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
    fields: [global_filters_and_parameters.is_after_product_discounts]
  }
}
