# Owner: Product Analytics, Flavia Alvarez

# Main Stakeholder:
# - Hub Tech
# - Hub Operations

include: "/product_hub/views/sql_derived_tables/stock_management_movement_ids_aggregates.view.lkml"
include: "/**/global_filters_and_parameters.view.lkml"

explore: stock_management_movement_ids {
  view_name: stock_management_movement_ids
  hidden:  no
  label: "Stock Management Movement Ids"
  description: ""
  group_label: "Consumer Hub"

  # implement both date filters:
  # reveived_at is due cost reduction given a table is partitioned by this dimensions
  # event_date filter will fitler for the desired time frame when events triggered

  # sql_always_where:{% condition global_filters_and_parameters.datasource_filter %} stock_management_movement_ids.event_date {% endcondition %}
  #   and {% condition global_filters_and_parameters.datasource_filter %} stock_management_movement_ids.event_date {% endcondition %};;

  access_filter: {
    field: stock_management_movement_ids.country_iso
    user_attribute: country_iso
  }

  always_filter: {
    filters: [
      global_filters_and_parameters.datasource_filter: "last 7 days",
      stock_management_movement_ids.country_iso: "",
      stock_management_movement_ids.hub_code: ""
    ]
  }

  join: global_filters_and_parameters {
    sql_on: ${global_filters_and_parameters.generic_join_dim} = TRUE ;;
    type: left_outer
    relationship: many_to_one
  }

}
