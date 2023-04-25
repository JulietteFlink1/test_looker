include: "/**/user_attributes_lifecycle_last28days.view.lkml"
include: "/**/global_filters_and_parameters.view.lkml"

explore: user_attributes_lifecycle_last28days {
  hidden: no
  view_name:  user_attributes_lifecycle_last28days
  label: "Customer Lifecycle Last 28 Days"
  view_label: "Customer Lifecycle Last 28 Days"
  group_label: "Product - Consumer"
  description: "Power User Curves Last 28 Days"


  sql_always_where:{% condition global_filters_and_parameters.datasource_filter %} ${execution_date} {% endcondition %}
    and ${execution_date}<= CURRENT_DATE();;
#                   Adding event_date<= current_date to avoid displaying the future events

  access_filter: {
    field: first_country_iso
    user_attribute: country_iso
  }

  always_filter: {
    filters: [
      global_filters_and_parameters.datasource_filter: "last 7 days",
      global_filters_and_parameters.timeframe_picker: "Date"
    ]
  }

  join: global_filters_and_parameters {
    sql: ;;
    relationship: one_to_one
  }
}
