include: "/views/sql_derived_tables/orders_delivery_coordinates_match.view.lkml"

explore: orders_delivery_coordinates_match {
  hidden: no
  view_name:  orders_delivery_coordinates_match
  label: "Orders Delivery Coordinates Match"
  view_label: "Orders Delivery Coordinates Match"
  group_label: "Consumer Product"
  description: "Matches Backend Orders with Client Order Tracking Viewed Events To Check Coordinates"
}
