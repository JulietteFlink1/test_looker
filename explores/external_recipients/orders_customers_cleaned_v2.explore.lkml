include: "/views/**/*.view"
include: "/**/*.view"
include: "/views/native_derived_tables/cohorts/monthly_cohorts_cleaned_v2.view"
include: "/views/native_derived_tables/cohorts/weekly_cohorts_cleaned_v2.view"
# include: "/explores/**/orders_customers_cleaned_v2.explore"
include: "/**/*.explore"

explore: orders_customers_cleaned_v2 {
  extends: [orders_cl_cleaned_v2]
  label: "User Metrics"
  view_label: "* User Metrics *"
  #view_name: orders_customers
  group_label: "15) Ad-Hoc"
  description: "General Business Performance - Orders, Revenue, etc."
  hidden: yes
  # view_name: base_order_orderline
  #extension: required

  join: customers_metrics_cleaned_v2 {
    view_label: "* Customers *"
    sql_on: ${customers_metrics_cleaned_v2.country_iso} = ${orders_cl_cleaned_v2.country_iso} AND
      ${customers_metrics_cleaned_v2.customer_id_mapped}    = ${orders_cl_cleaned_v2.customer_id_mapped} ;;
    relationship: many_to_one
    type: left_outer
  }

  join: monthly_cohorts_cleaned_v2 {
    view_label: "Cohorts - Monthly"
    sql_on: ${customers_metrics_cleaned_v2.country_iso} = ${monthly_cohorts_cleaned_v2.country_iso} AND
      ${customers_metrics_cleaned_v2.first_order_month} = ${customers_metrics_cleaned_v2.first_order_month};;
    relationship: many_to_one
    type: left_outer
  }

  join: weekly_cohorts_cleaned_v2 {
    view_label: "Cohorts - Weekly"
    sql_on: ${customers_metrics_cleaned_v2.country_iso} = ${weekly_cohorts_cleaned_v2.country_iso} AND
      ${customers_metrics_cleaned_v2.first_order_week} = ${customers_metrics_cleaned_v2.first_order_week};;
    relationship: many_to_one
    type: left_outer
  }

  #join: product_facts {
  #  type: left_outer
  #  relationship: many_to_one
  #  sql_on: ${order_orderline.country_iso} = ${product_facts.country_iso}
  #     and  ${order_orderline.product_sku} = ${product_facts.sku}
  #  ;;
  #}
}
