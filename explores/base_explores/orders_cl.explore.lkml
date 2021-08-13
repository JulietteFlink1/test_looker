include: "/views/bigquery_tables/curated_layer/orders.view"
include: "/views/projects/cleaning/hubs_clean.view"
include: "/views/projects/cleaning/shyftplan_riders_pickers_hours_clean.view"
include: "/views/bigquery_tables/nps_after_order.view"
include: "/views/projects/cleaning/issue_rates_clean.view"

include: "/views/bigquery_tables/curated_layer/hubs_ct.view"

include: "/explores/base_explores/orders_cl.explore"

explore: orders_cl {
  from: orders
  label: "Orders"
  view_label: "* Orders *"
  group_label: "01) Performance"
  description: "General Business Performance - Orders, Revenue, etc."
  view_name: orders_cl # needs to be set in order that the base_explore can be extended and referenced properly
  hidden: no

  always_filter: {
    filters:  [
      orders_cl.is_internal_order: "no",
      orders_cl.is_successful_order: "yes",
      orders_cl.created_date: "after 2021-01-25",
      hubs.country: "",
      hubs.hub_name: ""
    ]
  }
  access_filter: {
    field: orders_cl.country_iso
    user_attribute: country_iso
  }

  access_filter: {
    field: hubs.city
    user_attribute: city
  }

  #join: hubs {
  #  from: hubs_clean
  #  view_label: "* Hubs *"
  #  sql_on: ${orders_cl.country_iso}    = ${hubs.country_iso} AND
  #    ${orders_cl.hub_code} = ${hubs.hub_code} ;;
  #  relationship: many_to_many
  #  type: left_outer
  #}

  join: hubs {
    from: hubs_ct
    view_label: "* Hubs *"
    sql_on: lower(${orders_cl.hub_code}) = ${hubs.hub_code} ;;
    relationship: many_to_one
    type: left_outer
  }

  join: shyftplan_riders_pickers_hours {
    from: shyftplan_riders_pickers_hours_clean
    view_label: "* Shifts *"
    sql_on: ${orders_cl.created_date} = ${shyftplan_riders_pickers_hours.date} and
            ${hubs.hub_code}          = lower(${shyftplan_riders_pickers_hours.hub_name});;
    relationship: many_to_one
    type: left_outer
  }

  join: nps_after_order {
    view_label: "* NPS *"
    sql_on: ${orders_cl.country_iso}   = ${nps_after_order.country_iso} AND
            ${orders_cl.id}            = cast(${nps_after_order.order_id} as string) ;;
    relationship: one_to_many
    type: left_outer
  }

  join: issue_rates_clean {
    view_label: "* Order Issues on Hub-Level *"
    sql_on: ${hubs.hub_code}           =  ${issue_rates_clean.hub_code} and
            ${orders_cl.date}          =  ${issue_rates_clean.date_dynamic};;
    relationship: many_to_one # decided against one_to_many: on this level, many orders have hub-level issue-aggregates
    type: left_outer
  }

}
