#include: "/views/bigquery_tables/reporting_layer/cohorts/order_cohorts_base.view.lkml"
include: "/marketing/views/bigquery_reporting/customer_cohorts_base.view.lkml"
include: "/views/bigquery_tables/curated_layer/hubs_ct.view.lkml"
include: "/views/bigquery_tables/curated_layer/discounts.view"
include: "/views/bigquery_tables/curated_layer/orders.view"
include: "/views/projects/cleaning/shyftplan_riders_pickers_hours_clean.view"

# # Select the views that should be a part of this model,
# # and define the joins that connect them together.
#
explore: order_cohorts_base {
  label: "Phone-Based Customer Cohorts"
  description: "Phone-Based Logic"
  view_label: "* Orders *"
  from: orders
  hidden: yes

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
# has to do this join because of the circular reference in orders.view that is using shyftplan_riders_pickers_hours
# hiding it with a view_lavel: ""
  join: shyftplan_riders_pickers_hours {
    from: shyftplan_riders_pickers_hours_clean
    view_label: ""
    sql_on: ${order_cohorts_base.created_date} = ${shyftplan_riders_pickers_hours.shift_date} and
      ${hubs_ct.hub_code}          = lower(${shyftplan_riders_pickers_hours.hub_name});;
    relationship: many_to_many
    type: left_outer
  }
}
