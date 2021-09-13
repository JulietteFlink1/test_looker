include: "/**/order_orderline_cl.explore"
include: "/**/*.view"

explore: data_package_reports {
  extends: [order_orderline_cl]
  hidden: yes
  label: "Data Package Reports"
  # description: "see https://goflink.atlassian.net/browse/DATA-886"
  fields: [
    hubs.hub_name_anonymized,
    hubs.hub_code,
    hubs.hub_name,
    hubs.city,
    hubs.country,
    orders_cl.is_successful_order,
    orders_cl.cnt_unique_customers,
    orders_cl.country_iso,
    orders_cl.created_date,
    orders_cl.created_date,
    orders_cl.created_day_of_week,
    orders_cl.created_week,
    orders_cl.created_month,
    orders_cl.created_hour_of_day,
    products.product_name,
    products.category,
    products.subcategory,
    products.product_sku,
    products.product_brand,
    orderline.sum_item_quantity_fulfilled,
    orders_cl.cnt_orders,
  ]

  # join: retail_sku_attributes {
  #   sql_on: ${retail_sku_attributes.sku} =  ${products.product_sku} ;;
  #   type: left_outer
  #   relationship: many_to_one
  #   fields: [retail_sku_attributes.sku]
  # }


}
