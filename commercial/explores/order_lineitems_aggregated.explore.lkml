include: "/commercial/views/bigquery_reporting/order_lineitems_hourly.view"
include: "/core/views/bq_curated/hubs_ct.view"
include: "/core/views/bq_curated/products.view"
include: "/core/views/config/global_filters_and_parameters.view"

explore: order_lineitems_agg {
  view_name: order_lineitems_hourly

  hidden: yes

  sql_always_where: {% condition global_filters_and_parameters.datasource_filter %} ${order_lineitems_hourly.order_date} {% endcondition %} ;;
  join: global_filters_and_parameters {
    sql: ;;
  relationship: one_to_one
}

  join: hubs_ct {
    type: left_outer
    relationship: many_to_one
    sql_on: ${hubs_ct.hub_code} = ${order_lineitems_hourly.hub_code} ;;
  }

  join: products {
    type: left_outer
    relationship: many_to_one
    sql_on:
        ${products.product_sku} = ${order_lineitems_hourly.sku}
    and ${products.country_iso} = ${order_lineitems_hourly.country_iso}
    ;;
  }
}
