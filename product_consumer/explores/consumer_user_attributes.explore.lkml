# Owner: Product Analytics

# Main Stakeholder:
# - Consumer Product
# - Retail / Commercial team
# - Marketing

# Questions that can be answered
# - What are the attributes of our users?

# based on doc:
# https://cloud.google.com/looker/docs/reference/param-field-filter
# https://cloud.google.com/looker/docs/reference/param-explore-join-sql-on

include: "/**/user_attributes_jobs_to_be_done.view"
include: "/**/user_attributes_lifecycle_last28days.view"
include: "/**/user_attributes_lifecycle_first28days.view"
include: "/**/global_filters_and_parameters.view.lkml"
# include: "/**/customers_metrics.view.lkml"

explore: consumer_user_attributes {
  from: user_attributes_lifecycle_first28days
  view_name: user_attributes_lifecycle_first28days
  hidden: no
  label: "User Attributes"
  view_label: "* Customer First 28 Days *"
  description: "Explore user attributes and related metrics"
  group_label: "Product - Consumer"
  fields: [
    ALL_FIELDS*
    ]

  join: user_attributes_jobs_to_be_done {
    view_label: "* Customers JTBD *"
    sql_on: ${user_attributes_lifecycle_first28days.customer_uuid} = ${user_attributes_jobs_to_be_done.customer_uuid};;
    relationship: one_to_one
    type: left_outer
  }

  join: user_attributes_lifecycle_last28days {
    view_label: "* Customer Last 28 Days *"
    sql_on: ${user_attributes_lifecycle_first28days.customer_uuid} = ${user_attributes_lifecycle_last28days.customer_uuid};;
    sql_where: ${user_attributes_lifecycle_last28days.execution_date}=CURRENT_DATE() ;;
    relationship: one_to_one
    type: left_outer
  }

  access_filter: {
    field: user_attributes_lifecycle_first28days.first_country_iso
    user_attribute: country_iso
  }

  always_filter: {
    filters: [
      global_filters_and_parameters.datasource_filter: "last 1 days",
      user_attributes_lifecycle_first28days.first_visit_date: "56 days ago for 28 days"
    ]
  }

  join: global_filters_and_parameters {
    sql_on: ${global_filters_and_parameters.generic_join_dim} = TRUE ;;
    type: left_outer
    relationship: many_to_one
  }
}
