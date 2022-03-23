# Owner: Pete Kell

# Main Stakeholder:
# - Hub Tech
# - Hub Operations

# Questions that can be answered
# - How pickers progress through picking items

include: "/views/bigquery_tables/reporting_layer/product/picker_order_progress_sku_aggregates.view.lkml"
include: "/**/global_filters_and_parameters.view.lkml"

explore: picker_order_progress_sku_level_aggregation {
  from:  picker_order_progress_sku_aggregates
  view_name: picker_order_progress_sku_aggregates

  label: "Picker Order Progress Aggregates"
  description: "This explore provides an overview of how prickers progress through picking items."
  group_label: "Consumer Product"

  # implement both date filters:
  # reveived_at is due cost reduction given a table is partitioned by this dimensions
  # event_date filter will fitler for the desired time frame when events triggered

  sql_always_where:{% condition global_filters_and_parameters.datasource_filter %} picker_order_progress_sku_aggregates.date {% endcondition %}
    and {% condition global_filters_and_parameters.datasource_filter %} picker_order_progress_sku_aggregates.date {% endcondition %};;

  access_filter: {
    field: picker_order_progress_sku_aggregates.country_iso
    user_attribute: country_iso
  }

  always_filter: {
    filters: [
      global_filters_and_parameters.datasource_filter: "last 21 days"
    ]
  }

  join: global_filters_and_parameters {
    sql_on: ${global_filters_and_parameters.generic_join_dim} = TRUE ;;
    type: left_outer
    relationship: many_to_one
  }
}
