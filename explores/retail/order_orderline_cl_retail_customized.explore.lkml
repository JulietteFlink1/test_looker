include: "/explores/base_explores/**/*.explore"
include: "/**/*.view"
include: "/views/native_derived_tables/retail/category_performance/weekly/orders_country_level.view"
include: "/views/native_derived_tables/retail/category_performance/weekly/orders_revenue_subcategory_level.view"
include: "/views/native_derived_tables/retail/category_performance/weekly/orders_revenue_category_level.view"
include: "/views/native_derived_tables/retail/category_performance/monthly/orders_country_level_monthly.view"
include: "/views/native_derived_tables/retail/category_performance/monthly/orders_revenue_subcategory_level_monthly.view"
include: "/views/native_derived_tables/retail/category_performance/monthly/orders_revenue_category_level_monthly.view"


explore: order_orderline_cl_retail_customized {
  extends: [order_orderline_cl]
  group_label: "Retail"
  label: "Orders & Items (Retail Version)"
  hidden: no

  join: sku_level_aggregated_metrics {
    sql_on:  ${sku_level_aggregated_metrics.sku} = ${products.product_sku};;
    type: left_outer
    relationship: many_to_one
  }

  join: orders_country_level {
    view_label: "* PoP *"
    sql_on: ${orders_country_level.country_iso} = ${orders_cl.country_iso}
    and ${orders_country_level.date} = ${orders_cl.created_week};;
    relationship: many_to_one
  }

  join: orders_revenue_subcategory_level {
    view_label: "* PoP *"
    sql_on: ${orders_revenue_subcategory_level.date} = ${orders_cl.created_week}
      and ${orders_revenue_subcategory_level.country_iso} = ${orders_cl.country_iso}
      and ${orders_revenue_subcategory_level.subcategory} = ${orderline.product_subcategory_erp};;
    relationship: many_to_one
  }

  join: orders_revenue_category_level {
    view_label: "* PoP *"
    sql_on: ${orders_revenue_category_level.date} = ${orders_cl.created_week}
      and ${orders_revenue_category_level.country_iso} = ${orders_cl.country_iso}
      and ${orders_revenue_category_level.category} = ${orderline.product_category_erp};;
    relationship: many_to_one
  }

  join: orders_country_level_monthly {
    view_label: "* PoP *"
    sql_on: ${orders_country_level_monthly.country_iso} = ${orders_cl.country_iso}
      and ${orders_country_level_monthly.date} = ${orders_cl.created_month};;
    relationship: many_to_one
  }

  join: orders_revenue_subcategory_level_monthly {
    view_label: "* PoP *"
    sql_on: ${orders_revenue_subcategory_level_monthly.date} = ${orders_cl.created_month}
      and ${orders_revenue_subcategory_level_monthly.country_iso} = ${orders_cl.country_iso}
      and ${orders_revenue_subcategory_level_monthly.subcategory} = ${orderline.product_subcategory_erp};;
    relationship: many_to_one
  }

  join: orders_revenue_category_level_monthly {
    view_label: "* PoP *"
    sql_on: ${orders_revenue_category_level_monthly.date} = ${orders_cl.created_month}
      and ${orders_revenue_category_level_monthly.country_iso} = ${orders_cl.country_iso}
      and ${orders_revenue_category_level_monthly.category} = ${orderline.product_category_erp};;
    relationship: many_to_one
  }


}
