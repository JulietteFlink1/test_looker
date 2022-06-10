include: "/views/**/*.view"
include: "/**/*.view"
include: "/**/*.explore"

explore: erp_buying_prices_raw {

  from: erp_buying_prices_raw
  label: "ERP Buying Prices"
  view_label: "* EPR Buying Prices *"
  group_label: "Commercial"
  required_access_grants: [can_view_buying_information]

  join: hubs {
    from: hubs_ct
    view_label: "* Hubs *"
    sql_on: lower(${erp_buying_prices_raw.hub_code}}) = ${hubs.hub_code} ;;
    relationship: many_to_one
    type: left_outer
  }

  join: products {
    sql_on: ${products.product_sku} = ${erp_buying_prices_raw.sku} ;;
    relationship: many_to_one
    type: left_outer
  }

}
