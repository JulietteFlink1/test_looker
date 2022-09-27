# Owner: Product Analytics, Patricia Mitterova

# Main Stakeholder:
# - Consumer Product
# - Retail / Commercial team

# Questions that can be answered
# - Questions around behavioural events with country and device drill downs

include: "/product_consumer/views/bigquery_curated/event_category_selected.view"
include: "/**/global_filters_and_parameters.view.lkml"

explore: event_category_selected {
  from:  event_category_selected
  view_name: event_category_selected
  hidden: no

  label: "Event Category Selected"
  description: "This explore provides an overview of all catgeories cliked by users across app & web (includes category, subcategory, collection and recipes)"
  group_label: "Product - Consumer"

  sql_always_where:{% condition global_filters_and_parameters.datasource_filter %} ${event_date} {% endcondition %};;

  access_filter: {
    field: event_category_selected.country_iso
    user_attribute: country_iso
  }

  always_filter: {
    filters: [
      global_filters_and_parameters.datasource_filter: "last 7 days",
      event_category_selected.country_iso: ""
    ]
  }

  join: global_filters_and_parameters {
    sql_on: ${global_filters_and_parameters.generic_join_dim} = TRUE ;;
    type: left_outer
    relationship: many_to_one
  }
}
