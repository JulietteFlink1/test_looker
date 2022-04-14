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


  join: erp_buying_prices {
    type: left_outer
    # n orders have the same price
    relationship: many_to_one
    sql_on:
        ${erp_buying_prices.hub_code}         =  ${orderline.hub_code}                                and
        ${erp_buying_prices.sku}              =  ${orderline.product_sku}                             and
        -- a prive is valid in a certain time frame
        ${orderline.created_date}             = ${erp_buying_prices.report_date}
    ;;
  }


}
