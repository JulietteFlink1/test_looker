include: "/**/*.explore"
include: "/**/*.view"
include: "/**/orders_country_level.view"
include: "/**/orders_revenue_subcategory_level.view"
include: "/**/orders_revenue_category_level.view"
include: "/**/orders_country_level_monthly.view"
include: "/**/orders_revenue_subcategory_level_monthly.view"
include: "/**/orders_revenue_category_level_monthly.view"
include: "/**/commercial_department_names.view"
include: "/**/dynamically_filtered_measures.view"

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
      and ${orders_revenue_subcategory_level.category} = ${orderline.product_category_erp}
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
      and ${orders_revenue_subcategory_level_monthly.category} = ${orderline.product_category_erp}
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

  join: dynamically_filtered_measures {
    view_label: "* Dynamically Filtered Measures *"
    sql_on: ${dynamically_filtered_measures.country_iso} = ${orders_cl.country_iso}
      and ${dynamically_filtered_measures.created_hour} = ${orders_cl.created_hour}
      and ${dynamically_filtered_measures.sku} = ${products.product_sku}
      and ${dynamically_filtered_measures.hub_code} = ${hubs.hub_code};;
    relationship: many_to_one

  }

  join: erp_buying_prices {

    view_label: "* ERP Vendor Prices *"


    type: left_outer
    relationship: many_to_one

    sql_on:
        ${erp_buying_prices.hub_code}         =  ${orders_cl.hub_code}        and
        ${erp_buying_prices.sku}              =  ${products.product_sku}             and
        ${erp_buying_prices.report_date}      = ${orderline.created_date}
    ;;
    required_access_grants: [can_view_buying_information]
  }

}
