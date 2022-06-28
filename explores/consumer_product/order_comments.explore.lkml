include: "/**/*.view"

explore: order_comments{
  hidden: yes
  label: "Order Delivery Notes"
  view_label: "Order Delivery Notes"
  group_label: "Consumer Product"
  description: "Extends backend orders to count delivery notes"
  fields: [ALL_FIELDS*, -order_comments.pct_orders_delivered_by_riders]
}
