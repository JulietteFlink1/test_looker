include: "/views/**/*.view"
include: "/**/*.view"
include: "/views/native_derived_tables/cohorts/monthly_cohorts.view"
include: "/**/*.explore"

explore: orders_customers_dev {
  extends: [orders_cl]
  label: "Customer Metrics"
  view_label: "* Customer Metrics *"
  #view_name: orders_customers
  group_label: "Customer Metrics"
  description: "General Business Performance - Orders, Revenue, etc."
  hidden: no
  # view_name: base_order_orderline
  #extension: required

  join: crm_customer_feed {
    view_label: "* Customers *"
    sql_on: ${crm_customer_feed.country_iso} = ${orders_cl.country_iso} AND
      ${crm_customer_feed.user_email}    = ${orders_cl.user_email} ;;
    relationship: many_to_one
    type: left_outer
  }

  join: monthly_cohorts {
    view_label: "Cohorts - Monthly"
    sql_on: ${crm_customer_feed.country_iso} = ${monthly_cohorts.country_iso} AND
      ${monthly_cohorts.first_order_month} = ${crm_customer_feed.first_order_month};;
    relationship: many_to_one
    type: left_outer
  }

  join: weekly_cohorts {
    view_label: "Cohorts - Weekly"
    sql_on: ${crm_customer_feed.country_iso} = ${weekly_cohorts.country_iso} AND
      ${weekly_cohorts.first_order_week} = ${crm_customer_feed.first_order_week};;
    relationship: many_to_one
    type: left_outer
  }

  join: customer_address {
    sql_on: ${orders_cl.order_uuid} = ${customer_address.order_uuid};;
    type: left_outer
    relationship: one_to_one
  }

  join: pdt_customer_retention {
    view_label: " Customer Retention vs PDT "
    sql_on: ${crm_customer_feed.country_iso} = ${pdt_customer_retention.country_iso} AND
      ${crm_customer_feed.user_email}    = ${pdt_customer_retention.customer_email} ;;
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
