# Owner: Product Analytics, Flavia Alvarez

# Main Stakeholder:
# - Hub Tech

# Questions that can be answered
# - Questions around picking flow in hub one

include: "/**/global_filters_and_parameters.view.lkml"
include: "/**/hubs_ct.view.lkml"
include: "/**/hub_one_picking_aggregates.view.lkml"
include: "/**/orders.view.lkml"

explore: hub_one_picking_aggregates {
  from:  hub_one_picking_aggregates
  view_name: hub_one_picking_aggregates
  hidden: no

  label: "Hub One Picking Aggregates"
  description: "This explore provides an aggregated overview of behavioural events generated
  during the inbounding flow in Hub One.
  This explore is built on front-end data, and is subset to the limitations of front-end tracking.
  We can not, and do not, expect 100% accuracy compared to the back-end based explores.
  We consider the back-end based explores to be the source of truth."
  group_label: "Product - Hub Tech"


  sql_always_where:{% condition global_filters_and_parameters.datasource_filter %}
    ${event_date} {% endcondition %};;

  access_filter: {
    field: hub_one_picking_aggregates.country_iso
    user_attribute: country_iso
  }

  always_filter: {
    filters: [
      global_filters_and_parameters.datasource_filter: "last 7 days"
    ]
  }

  join: global_filters_and_parameters {
    sql: ;;
  relationship: one_to_one
}


join: hubs_ct {
  view_label: "2 Hub Dimensions"
  sql_on: ${hub_one_picking_aggregates.hub_code} = ${hubs_ct.hub_code} ;;
  type: left_outer
  relationship: many_to_one
}

join: orders {
  view_label: "3 Order Dimensions"
  sql_on: ${orders.id} = ${hub_one_picking_aggregates.order_id} ;;
  type: left_outer
  relationship: one_to_one
}

}
