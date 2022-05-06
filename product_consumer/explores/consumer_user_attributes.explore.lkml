# Owner: Product Analytics

# Main Stakeholder:
# - Consumer Product
# - Retail / Commercial team
# - Marketing

# Questions that can be answered
# - What are the attributes of our users?

include: "/**/user_attributes_jobs_to_be_done.view"
include: "/**/global_filters_and_parameters.view.lkml"
include: "/**/orders_customers.explore.lkml"

explore: consumer_user_attributes {
  extends: [orders_customers]
  hidden: no
  label: "User Attributes"
  view_label: "* User Level *"
  description: "This explore provides an overview of user attributes"
  group_label: "Consumer Product"


  join: user_attributes_jobs_to_be_done {
    view_label: "* Jobs to be Done *"
    sql_on: ${customers_metrics.customer_uuid} = ${user_attributes_jobs_to_be_done.customer_uuid} ;;
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
