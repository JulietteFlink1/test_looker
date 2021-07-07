include: "/views/**/*.view"
include: "/**/*.view"
include: "/**/*.explore"

explore: base_order_hub_level {
  extends: [base_orders]
  # view_name: base_order_hub_level
  extension: required
  fields: [
    ALL_FIELDS*,
    -base_orders.exclude_dims_as_that_cross_reference*
  ]

  join: hub_order_facts {
    view_label: "* Hubs *"
    type: left_outer
    relationship: many_to_one
    sql_on: ${base_orders.country_iso}    = ${hub_order_facts.country_iso} AND
            ${base_orders.warehouse_name} = ${hub_order_facts.warehouse_name} ;;
  }
  join: nps_after_order {
    view_label: "* NPS *"
    sql_on: ${base_orders.country_iso} = ${nps_after_order.country_iso} AND
            ${base_orders.id}          = ${nps_after_order.order_id} ;;
    relationship: one_to_many
    type: left_outer
  }

  join: shyftplan_riders_pickers_hours {
    view_label: "* Shifts *"
    sql_on: ${base_orders.created_date} = ${shyftplan_riders_pickers_hours.date} and
            ${hubs.hub_code}            = ${shyftplan_riders_pickers_hours.hub_name};;
    relationship: many_to_one
    type: left_outer
  }
  join: issue_rate_hub_level {
    view_label: "Order Issues on Hub-Level"
    sql_on: ${hubs.hub_code_lowercase} =  LOWER(${issue_rate_hub_level.hub_code}) and
            ${base_orders.date}        =  ${issue_rate_hub_level.date};;
    relationship: many_to_one # decided against one_to_many: on this level, many orders have hub-level issue-aggregates
    type: left_outer
  }
}
