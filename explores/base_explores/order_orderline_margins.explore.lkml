include: "/**/*.explore"
include: "/**/*.view"

explore: order_lineitems_margins {

  extends: [order_orderline_cl]

  # only for users in the group access_buying_prices
  required_access_grants: [can_view_buying_information]
  hidden: yes


  join: erp_buying_prices {
    type: left_outer
    # n orders have the same price
    relationship: one_to_one
    sql_on:
        ${erp_buying_prices.country_iso}      =  ${orderline.country_iso}                             and
        ${erp_buying_prices.erp_vendor_id}    =  ${erp_product_hub_vendor_assignment.erp_vendor_id}   and

        -- if    - there is a warehouse-specific price, take it
        -- else  - do not consider this join statement
        case  when ${erp_buying_prices.erp_warehouse_id} is not null
              then ${erp_buying_prices.erp_warehouse_id} = ${erp_product_hub_vendor_assignment.erp_warehouse_id}
              else true
        end and

        ${erp_buying_prices.hub_code}         =  ${orderline.hub_code}                                and
        ${erp_buying_prices.sku}              =  ${orderline.product_sku}                             and

        -- a prive is valid in a certain time frame
        ${orderline.created_date} between ${erp_buying_prices.valid_from} and ${erp_buying_prices.valid_to}
    ;;
  }


}
