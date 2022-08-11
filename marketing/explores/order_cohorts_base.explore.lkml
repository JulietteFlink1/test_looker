#include: "/views/bigquery_tables/reporting_layer/cohorts/order_cohorts_base.view.lkml"
include: "/marketing/views/bigquery_reporting/customer_cohorts_base.view.lkml"
include: "/views/bigquery_tables/curated_layer/hubs_ct.view.lkml"
include: "/views/bigquery_tables/curated_layer/discounts.view"
include: "/views/bigquery_tables/curated_layer/orders.view"

# # Select the views that should be a part of this model,
# # and define the joins that connect them together.
#
explore: order_cohorts_base {
  label: "Customer Cohorts"
  description: "Customer UUID Logic"
  view_label: "* Orders *"
  from: orders
  hidden: yes
  always_filter: {
    filters: [is_external_order: "No"]
  }

  join: customer_cohorts_base {
    view_label: "*.Customers *"
    from: customer_cohorts_base
    sql_on:
    ${order_cohorts_base.customer_uuid} =  ${customer_cohorts_base.customer_id_mapped};;
    type: left_outer
    relationship: many_to_one
  }

  join: hubs_ct {
    view_label: "*.Hubs *"
    sql_on: ${customer_cohorts_base.first_order_hub_code} = ${hubs_ct.hub_code} ;;
    type: left_outer
    relationship: many_to_one
  }

  join: discounts {
    sql_on: ${order_cohorts_base.voucher_id} = ${discounts.discount_id}
       and ${order_cohorts_base.discount_code} = ${discounts.discount_code}
    ;;
    type: left_outer
    relationship: one_to_one
  }

}
