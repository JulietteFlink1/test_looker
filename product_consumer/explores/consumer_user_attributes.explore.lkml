# Owner: Product Analytics

# Main Stakeholder:
# - Consumer Product
# - Retail / Commercial team
# - Marketing

# Questions that can be answered
# - What are the attributes of our users?

include: "/product_consumer/views/bigquery_reporting/user_attributes_jobs_to_be_done.view"
include: "/**/global_filters_and_parameters.view.lkml"
include: "/**/customers_metrics.view.lkml"
include: "/**/orders_cl.explore.lkml"

explore: consumer_user_attributes {
  from: user_attributes_jobs_to_be_done
  view_name: user_attributes_jobs_to_be_done
  hidden: no
  label: "User Attributes"
  view_label: "* User Level JTBD *"
  description: "This explore provides an overview of user attributes"
  group_label: "Consumer Product"
  sql_always_where: ${customers_metrics.first_order_month} > '2021-09-30';;
  fields: [
    ALL_FIELDS*,
    -customers_metrics.years_time_since_sign_up,
    -customers_metrics.quarters_time_since_sign_up,
    -customers_metrics.months_time_since_sign_up,
    -customers_metrics.weeks_time_since_sign_up,
    -customers_metrics.days_time_since_sign_up,
    -customers_metrics.hours_time_since_sign_up,
    -customers_metrics.minutes_time_since_sign_up,
    -customers_metrics.seconds_time_since_sign_up,
    -customers_metrics.weeks_time_since_sign_up_number,
    -orders.sum_rider_hours,
    -orders.KPI
    ]


  join: customers_metrics {
    view_label: "* Customer Metrics *"
    sql_on: ${customers_metrics.customer_uuid} = ${user_attributes_jobs_to_be_done.customer_uuid} ;;
    relationship: one_to_one
    type: left_outer
  }

  join: orders {
    view_label: "* Orders *"
    sql_on: ${user_attributes_jobs_to_be_done.customer_uuid} = ${orders.customer_uuid} ;;
    relationship: one_to_many
    type: left_outer
  }

  join: user_attributes_order_classification {
    view_label: "* Order Classifications *"
    sql_on: ${user_attributes_order_classification.order_uuid} = ${orders.order_uuid} ;;
    relationship: one_to_one
    type: left_outer
  }

  access_filter: {
    field: user_attributes_jobs_to_be_done.country_iso
    user_attribute: country_iso
  }

  always_filter: {
    filters: [
      global_filters_and_parameters.datasource_filter: "last 1 days"
    ]
  }

  join: global_filters_and_parameters {
    sql_on: ${global_filters_and_parameters.generic_join_dim} = TRUE ;;
    type: left_outer
    relationship: many_to_one
  }
}
