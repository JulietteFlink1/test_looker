include: "/explores/base_explores/**/*.explore"
include: "/**/*.view"
include: "/views/native_derived_tables/retail/sub_category_performance/orders_country_level.view"
include: "/views/native_derived_tables/retail/sub_category_performance/orders_revenue_subcategory_level.view"
include: "/views/native_derived_tables/retail/sub_category_performance/orders_revenue_category_level.view"


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
    view_label: "* PoP - Country Level *"
    sql_on: ${orders_country_level.country_iso} = ${orders_cl.country_iso}
    and ${orders_country_level.date} = ${orders_cl.created_week};;
    relationship: many_to_one
  }

  join: orders_revenue_subcategory_level {
    view_label: "* PoP - Subcategory Level *"
    sql_on: ${orders_revenue_subcategory_level.date} = ${orders_cl.created_week}
      and ${orders_revenue_subcategory_level.country_iso} = ${orders_cl.country_iso}
      and ${orders_revenue_subcategory_level.subcategory} = ${orderline.product_subcategory_erp};;
    relationship: many_to_one
  }

  join: orders_revenue_category_level {
    view_label: "* PoP - Category Level *"
    sql_on: ${orders_revenue_category_level.date} = ${orders_cl.created_week}
      and ${orders_revenue_category_level.country_iso} = ${orders_cl.country_iso}
      and ${orders_revenue_category_level.category} = ${orderline.product_category_erp};;
    relationship: many_to_one
  }
}
