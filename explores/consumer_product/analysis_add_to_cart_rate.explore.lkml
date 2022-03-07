include: "/views/projects/consumer_product/analysis_add_to_cart_rate.view.lkml"

explore: analysis_add_to_cart_rate {
  hidden: yes
  view_name:  analysis_add_to_cart_rate
  label: "Analysis on add-to-cart rate for users with products in basket"
  view_label: "Add to Cart - event level"
  group_label: "Consumer Product"
  description: "Add to Cart with product placement granularity"
  always_filter: {
    filters:  [
      analysis_add_to_cart_rate.filter_event_date: "last 14 days",
      analysis_add_to_cart_rate.device_type: "",
      analysis_add_to_cart_rate.app_version: "",
      analysis_add_to_cart_rate.user_has_items_in_cart: "yes"
    ]
  }
}
