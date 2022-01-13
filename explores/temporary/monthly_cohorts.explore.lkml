include: "/views/bigquery_tables/reporting_layer/cohorts/order_cohorts_base.view.lkml"
include: "/views/bigquery_tables/reporting_layer/cohorts/customer_cohorts_base.view.lkml"
# include all views in the views/ folder in this project
# include: "/**/*.view.lkml"                 # include all views in this project
# include: "my_dashboard.dashboard.lookml"   # include a LookML dashboard called my_dashboard

# # Select the views that should be a part of this model,
# # and define the joins that connect them together.
#
explore: order_cohorts_base {
  label: "Phone-Based Customer Cohorts"
  description: "Phone-Based Logic"
  view_label: "* Orders *"
  from: order_cohorts_base

  join: customer_cohorts_base {
    view_label: "*.Customers *"
    from: customer_cohorts_base
    sql_on:
    ${order_cohorts_base.customer_id_mapped} =  ${customer_cohorts_base.customer_id_mapped};;
    type: left_outer
    relationship: many_to_one
  }

}
