# Owner: Product Analytics, Flavia Alvarez

# Main Stakeholder:
# - Hub Tech
# - Hub Operations

include: "/**/stock_management_movement_ids_aggregates.view.lkml"
include: "/**/global_filters_and_parameters.view.lkml"
include: "/**/hubs_ct.view.lkml"

explore: stock_management_movement_ids {
  view_name: stock_management_movement_ids
  hidden:  no
  label: "Stock Management Movement Ids"
  description: ""
  group_label: "Product - Hub Tech"

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
    sql: ;;
    relationship: one_to_one
  }

  join: hubs_ct {
    sql_on: ${stock_management_movement_ids.hub_code} = ${hubs_ct.hub_code} ;;
    type: left_outer
    relationship: many_to_one
  }

}
