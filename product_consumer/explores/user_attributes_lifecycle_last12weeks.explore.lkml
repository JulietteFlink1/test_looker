include: "/product_consumer/views/bigquery_reporting/user_attributes_lifecycle_last12weeks.view.lkml"

explore: user_attributes_lifecycle_last12weeks {
  hidden: no
  view_name:  user_attributes_lifecycle_last12weeks
  label: "Customer Lifecycle Last 12 Weeks"
  view_label: "Customer Lifecycle Last 12 Weeks"
  group_label: "Product - Consumer"
  description: "Power User Curves Last 12 Weeks"

}
