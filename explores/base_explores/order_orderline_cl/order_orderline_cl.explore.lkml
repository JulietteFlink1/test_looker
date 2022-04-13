include: "/views/**/*.view"
include: "/**/*.view"
include: "/**/*.explore"


explore: order_orderline_cl {

  extends: [orders_cl]

  group_label: "01) Performance"
  label:       "Orders & Lineitems"
  description: "Orderline Items sold quantities, prices, gmv, etc."
  hidden: no

  # take all fields except those in the pricing_fields_refined set in erp_product_hub_vendor_assignment_v2_buying_prices.view
  fields: [ALL_FIELDS*, -erp_product_hub_vendor_assignment.pricing_fields_refined*]

  join: orderline {

    view_label: "* Order Lineitems *"
    sql_on: ${orderline.country_iso} = ${orders_cl.country_iso} AND
            ${orderline.order_uuid}    = ${orders_cl.order_uuid} AND
            {% condition global_filters_and_parameters.datasource_filter %} ${orderline.created_date} {% endcondition %}

            ;;
    relationship: one_to_many
    type: left_outer
  }

  join: products {
    sql_on: ${products.product_sku} = ${orderline.product_sku} ;;
    relationship: many_to_one
    type: left_outer
  }

  join: customer_address {
    # can only be seen by people with related permissions
    sql_on: ${orders_cl.order_uuid} = ${customer_address.order_uuid} ;;
    type: left_outer
    relationship: one_to_one
  }

  join: erp_product_hub_vendor_assignment {

    from: erp_product_hub_vendor_assignment_v2

    sql_on:  ${erp_product_hub_vendor_assignment.sku}            = ${orderline.product_sku}
         and ${erp_product_hub_vendor_assignment.hub_code}       = ${orderline.hub_code}
         and ${erp_product_hub_vendor_assignment.report_date}    = ${orderline.created_date}
    ;;
    type: left_outer
    relationship: one_to_many
  }
}
