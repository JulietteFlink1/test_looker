#include: "/views/bigquery_tables/reporting_layer/cohorts/order_cohorts_base.view.lkml"
include: "/**/customer_cohorts_base.view.lkml"
include: "/**/hubs_ct.view.lkml"
include: "/**/discounts.view"
include: "/**/orders.view"
include: "/**/global_filters_and_parameters.view"


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

  join: global_filters_and_parameters {
    sql: ;;
    # Use `sql` instead of `sql_on` and put some whitespace in it
    relationship: one_to_one
    fields: [global_filters_and_parameters.is_after_product_discounts]
  }

  join: customer_cohorts_base {
    view_label: "* Customers *"
    from: customer_cohorts_base
    sql_on:
    ${order_cohorts_base.customer_uuid} =  ${customer_cohorts_base.customer_id_mapped};;
    type: left_outer
    relationship: many_to_one
  }

  join: hubs_ct {
    view_label: "* Hubs *"
    sql_on: ${customer_cohorts_base.first_order_hub_code} = ${hubs_ct.hub_code} ;;
    type: left_outer
    relationship: many_to_one
  }

  join: discounts {
    # For T1 the discount id is null and we join only on the discount code.
    sql_on: coalesce(${order_cohorts_base.voucher_id},'') = coalesce(${discounts.discount_id},'')
       and ${order_cohorts_base.discount_code} = ${discounts.discount_code}
    ;;
    type: left_outer
    relationship: many_to_one
  }

}
