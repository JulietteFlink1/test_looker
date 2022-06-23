include: "/views/bigquery_tables/reporting_layer/product/product_performance.view.lkml"

explore: product_performance {
  view_name: product_performance {
  label: "Product Performance"
  view_label: "Product Performance"
  group_label: "Consumer Product"
  description: "Product Performance Explore based on behavioural data. Please note: order_placed did not fire properly for iOS version 2.15.0 (2021/11/29 - ~2021/12/20)"
  hidden: yes
}

  always_filter: {
    filters:  [
      product_performance.event_at_date: "last 14 days",
      product_performance.country: "",
      product_performance.city: "",
      product_performance.app_version: ""
    ]
  }
}
