include: "/supply_chain/views/bigquery_curated/erp_buying_prices.view.lkml"
include: "/pricing/views/bigquery_reporting/product_prices_daily.view.lkml"
include: "/core/views/config/global_filters_and_parameters.view.lkml"
include: "/core/views/bq_curated/products.view.lkml"
include: "/core/views/bq_curated/hubs_ct.view.lkml"

explore: spot_cost_margins {

  from:  erp_buying_prices
  view_name: erp_buying_prices
  view_label: "ERP Buying Prices"
  description: "This Explore contains spot cost data and selling price data (unrelated to orders, inventory, etc.) to calculate spot margins."

  fields: [
    erp_buying_prices.erp_buying_prices_base*,
    product_prices_daily*,
    global_filters_and_parameters*,
    hubs_ct*,
    products*
  ]

  sql_always_where:
  -- filter the time for all big tables of this explore
  {% condition global_filters_and_parameters.datasource_filter %} ${erp_buying_prices.report_date} {% endcondition %}
  ;;


  always_filter: {
    filters: [
      global_filters_and_parameters.datasource_filter: "last 7 days"
    ]
  }

  join: global_filters_and_parameters {
    sql: ;;
  relationship: one_to_one
}


join: product_prices_daily {
  relationship: one_to_one
  type: left_outer
  sql_on:
        ${erp_buying_prices.report_date} = ${product_prices_daily.reporting_date}
    and ${erp_buying_prices.hub_code}    = ${product_prices_daily.hub_code}
    and ${erp_buying_prices.sku}         = ${product_prices_daily.sku}
    and {% condition global_filters_and_parameters.datasource_filter %} ${product_prices_daily.reporting_date} {% endcondition %}
    ;;
}

join: hubs_ct {
  view_label: "Hub Data"
  relationship: many_to_one
  type: left_outer
  sql_on: ${hubs_ct.hub_code} = ${erp_buying_prices.hub_code} ;;
}

join: products {
  view_label: "Product Data"
  relationship: many_to_one
  type: left_outer
  sql_on:
        ${products.product_sku} = ${erp_buying_prices.sku}
    and ${products.country_iso} = ${erp_buying_prices.country_iso}
    ;;
}
}
