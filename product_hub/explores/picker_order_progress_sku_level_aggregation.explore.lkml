# Owner: Product Analytics, Pete Kell, Flavia Alvarez

# Main Stakeholder:
# - Hub Tech
# - Hub Operations

# Questions that can be answered
# - How pickers progress through picking items

include: "/product_hub/views/bigquery_reporting/picker_order_progress_sku_aggregates.view.lkml"
include: "/**/global_filters_and_parameters.view.lkml"
include: "/product_hub/views/sql_derived_tables/picker_order_times.view.lkml"

explore: picker_order_progress_sku_level_aggregation {
  view_name: picker_order_progress_sku_aggregates
  hidden:  no
  label: "Picker Order Progress Aggregates"
  description: "This explore provides an overview of how prickers progress through picking items."
  group_label: "Product - Hub Tech"

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
      global_filters_and_parameters.datasource_filter: "last 7 days",
      picker_order_progress_sku_aggregates.country_iso: "",
      picker_order_progress_sku_aggregates.hub_code: ""
    ]
  }

  join: global_filters_and_parameters {
    sql: ;;
    relationship: one_to_one
  }

  join: picker_order_times {
    sql_on: ${picker_order_times.order_id} = ${picker_order_progress_sku_aggregates.order_id} ;;
    type: left_outer
    relationship: many_to_one
  }
}
