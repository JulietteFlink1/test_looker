include: "/views/projects/consumer_product/add_to_cart_rate_events.view.lkml"

explore: add_to_cart_rate_events {
  hidden: no
  view_name:  add_to_cart_rate_events
  label: "Add to Cart rate from Product Placement"
  view_label: "Add to Cart - event level"
  group_label: "Consumer Product"
  description: "Add to Cart with product placement granularity"
  always_filter: {
    filters:  [
      add_to_cart_rate_events.filter_event_date: "last 14 days",
      add_to_cart_rate_events.device_type: "",
      add_to_cart_rate_events.app_version: ""
    ]
  }
}
