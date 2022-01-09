include: "/views/projects/consumer_product/product_events.view.lkml"

explore: product_events {
  view_name: product_events
  label: "Product Events"
  view_label: "Product Events"
  group_label: "Consumer Product"
  description: "Events which pass information about products, including: add-to-cart, remove-from-cart, add-to-favourites, PDP, cart-viewed"
  hidden: no

  always_filter: {
    filters:  [
      product_events.filter_event_date: "last 14 days",
      product_events.country: "",
      product_events.city: "",
      product_events.app_version: "",
      product_events.event_name: ""
    ]
  }
}
