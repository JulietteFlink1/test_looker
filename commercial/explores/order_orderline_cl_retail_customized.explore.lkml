include: "/explores/base_explores/**/*.explore"
include: "/**/*.view"
include: "/views/native_derived_tables/retail/category_performance/weekly/orders_country_level.view"
include: "/views/native_derived_tables/retail/category_performance/weekly/orders_revenue_subcategory_level.view"
include: "/views/native_derived_tables/retail/category_performance/weekly/orders_revenue_category_level.view"
include: "/views/native_derived_tables/retail/category_performance/monthly/orders_country_level_monthly.view"
include: "/views/native_derived_tables/retail/category_performance/monthly/orders_revenue_subcategory_level_monthly.view"
include: "/views/native_derived_tables/retail/category_performance/monthly/orders_revenue_category_level_monthly.view"
include: "/views/bigquery_tables/gsheets/commercial_department_names.view"

explore: order_orderline_cl_retail_customized {
  extends: [order_orderline_cl]
  group_label: "Commercial"
  label: "Orders & Items (Commercial Dept. Version)"
  hidden: no

  join: sku_level_aggregated_metrics {

    # hiding this field, as the metrics generated with this table, can actually be derived with the orderline core data
    # see here: https://goflink.cloud.looker.com/explore/flink_v3/order_orderline_cl_retail_customized?qid=tIISqYLHbe9rlCjMF08Vvq&toggle=fil
    view_label: ""


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

  join: commercial_department_names {
    view_label: "* Order Lineitems *"
    sql_on: lower(${commercial_department_names.category}) = lower(${products.category})
      and lower(${commercial_department_names.subcategory}) = lower(${products.subcategory})
      and lower(${commercial_department_names.country_iso}) = lower(${products.country_iso});;
    relationship: many_to_one

  }

}
