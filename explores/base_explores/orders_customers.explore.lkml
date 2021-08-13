include: "/views/**/*.view"
include: "/**/*.view"
include: "/views/native_derived_tables/cohorts/monthly_cohorts.view"
include: "/**/*.explore"

explore: orders_customers {
  extends: [orders_cl]
  label: "User Metrics"
  view_label: "* User Metrics *"
  #view_name: orders_customers
  group_label: "15) Ad-Hoc"
  description: "General Business Performance - Orders, Revenue, etc."
  hidden: no
  # view_name: base_order_orderline
  #extension: required

  join: customers_metrics {
    sql_on: ${customers_metrics.country_iso} = ${orders_cl.country_iso} AND
      ${customers_metrics.user_email}    = ${orders_cl.user_email} ;;
    relationship: many_to_one
    type: left_outer
  }

  join: monthly_cohorts {
    sql_on: ${customers_metrics.country_iso} = ${monthly_cohorts.country_iso} AND
    ${customers_metrics.first_order_month} = ${customers_metrics.first_order_month};;
    relationship: many_to_one
    type: left_outer
  }

  join: weekly_cohorts {
    sql_on: ${customers_metrics.country_iso} = ${weekly_cohorts.country_iso} AND
    ${customers_metrics.first_order_week} = ${customers_metrics.first_order_week};;
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
