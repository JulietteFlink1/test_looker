# Owner: Product Analytics, Zhou Fang, Peter Kell, Natalia Wierzbowska

# Main Stakeholder:
# - Consumer Product
# - Retail / Commercial team
# - Marketing

# Questions that can be answered
# - What are the attributes of our customers?

include: "/**/user_attributes_jobs_to_be_done_last28days.view.lkml"
include: "/**/user_attributes_lifecycle_last28days.view.lkml"
include: "/**/user_attributes_lifecycle_first28days.view.lkml"
# include: "/**/customers_metrics.view.lkml"

explore: consumer_user_attributes {
  from: user_attributes_lifecycle_first28days
  view_name: user_attributes_lifecycle_first28days
  hidden: no
  label: "User Attributes"
  view_label: "* Customers First 28 Days *"
  description: "Explore user attributes and related metrics. See dbt docs for details on which data models are included and their fields: https://data-dbt-prod.pages.dev/#!/exposure/exposure.flink_data.looker_explore_user_attributes"
  group_label: "Product - Consumer"
  fields: [
    ALL_FIELDS*,
    -user_attributes_lifecycle_last28days.user_attributes*,
    -user_attributes_lifecycle_last28days.comparison_selector,
    -user_attributes_lifecycle_last28days.plotby,
    -user_attributes_lifecycle_last28days.first_visit_granularity,
    -user_attributes_lifecycle_last28days.customer_uuid,
    -user_attributes_lifecycle_last28days.timeframe_picker
    ]

# JTBD has a historical table where customers are duplicated per day, but the JTBD non-historical view only contains the customers' analysis from the previous day. Therefore unique on customer_uuid
  join: user_attributes_jobs_to_be_done_last28days {
    view_label: "* Customers JTBD  Last 28 Days *"
    sql_on: ${user_attributes_lifecycle_first28days.customer_uuid} = ${user_attributes_jobs_to_be_done_last28days.customer_uuid};;
    relationship: one_to_one
    type: left_outer
  }

# last28days is also run everyday and here we restrict to consider only data from the previous day as reference point, in order to simplify
# don't use sql_where for execution_date filter because it will restrict the entire set (WHERE the entire selection) to where execution_date is available
  join: user_attributes_lifecycle_last28days {
    view_label: "* Customers Last 28 Days *"
    sql_on: ${user_attributes_lifecycle_first28days.customer_uuid} = ${user_attributes_lifecycle_last28days.customer_uuid}
            and {% condition user_attributes_lifecycle_last28days.execution_date %} user_attributes_lifecycle_last28days.execution_date {% endcondition %};;
    relationship: one_to_one
    type: left_outer
  }

  access_filter: {
    field: user_attributes_lifecycle_first28days.first_country_iso
    user_attribute: country_iso
  }

  always_filter: {
    filters: [
      user_attributes_lifecycle_first28days.first_visit_date: "56 days ago for 28 days",
      user_attributes_lifecycle_last28days.execution_date: "yesterday",
      user_attributes_jobs_to_be_done_last28days.execution_date: "yesterday"

    ]
  }
}
