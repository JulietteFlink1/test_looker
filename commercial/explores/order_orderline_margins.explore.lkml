include: "/**/*.explore"
include: "/**/*.view"

explore: order_lineitems_margins {

  extends: [order_orderline_cl]

  group_label: "Commercial"
  label: "RESTRICTED: Orders, Lineitems & Margins"
  description: "Orderline Items sold quantities, prices, gmv, etc. as well as buying prices and margin data"

  # only for users in the group access_buying_prices
  required_access_grants: [can_view_buying_information]
  hidden: no






}
