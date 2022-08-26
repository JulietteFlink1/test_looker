# Owner: Product Analytics, Flavia Alvarez

# Main Stakeholder:
# - Hub Tech
# - Hub Operations

include: "/product_hub/views/bigquery_reporting/stock_management_progress_sku_aggregates.view.lkml"
include: "/**/global_filters_and_parameters.view.lkml"

explore: stock_management_progress_sku_aggregation {
  view_name: stock_management_progress_sku_aggregates
  hidden:  no
  label: "Stock Management Progress Aggregates"
  description: "This explore provides an overview of how inventory associates progress through the inventory tasks (inbound, outbound, correction)."
  group_label: "Consumer Hub"

  # implement both date filters:
  # reveived_at is due cost reduction given a table is partitioned by this dimensions
  # event_date filter will fitler for the desired time frame when events triggered

  sql_always_where:{% condition global_filters_and_parameters.datasource_filter %} stock_management_progress_sku_aggregates.event_date {% endcondition %}
    and {% condition global_filters_and_parameters.datasource_filter %} stock_management_progress_sku_aggregates.event_date {% endcondition %};;

  access_filter: {
    field: stock_management_progress_sku_aggregates.country_iso
    user_attribute: country_iso
  }

  always_filter: {
    filters: [
      global_filters_and_parameters.datasource_filter: "last 7 days",
      stock_management_progress_sku_aggregates.country_iso: "",
      stock_management_progress_sku_aggregates.hub_code: ""
    ]
  }

  join: global_filters_and_parameters {
    sql_on: ${global_filters_and_parameters.generic_join_dim} = TRUE ;;
    type: left_outer
    relationship: many_to_one
  }

}
