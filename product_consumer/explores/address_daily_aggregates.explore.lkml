include: "/product_consumer/views/address_daily_aggregates.view.lkml"

explore: address_daily_aggregates {
  view_name: address_daily_aggregates
  label: "Address Daily User Activity"
  view_label: "Address Daily User Activity"
  group_label: "Consumer Product"
  description: "Address-centered tracking events aggregated per day per user"
}
