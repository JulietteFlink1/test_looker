include: "/product_consumer/views/bigquery_reporting/user_attributes_lifecycle_last28days.view.lkml"

explore: user_attributes_lifecycle_last28days {
  hidden: no
  view_name:  user_attributes_lifecycle_last28days
  label: "Customer Lifecycle Last 28 Days"
  view_label: "Customer Lifecycle Last 28 Days"
  group_label: "Consumer Product"
  description: "Power User Curves Last 28 Days"

}
