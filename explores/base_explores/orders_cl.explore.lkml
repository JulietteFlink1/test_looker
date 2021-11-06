include: "/views/bigquery_tables/curated_layer/orders.view"
include: "/views/extended_tables/orders_using_hubs.view"
include: "/views/projects/cleaning/shyftplan_riders_pickers_hours_clean.view"
include: "/views/projects/cleaning/issue_rates_clean.view"

include: "/views/bigquery_tables/curated_layer/hubs_ct.view"
include: "/views/bigquery_tables/curated_layer/nps_after_order_cl.view"
include: "/views/bigquery_tables/curated_layer/cs_post_delivery_issues.view"
include: "/views/sql_derived_tables/bottom_10_hubs.view"

include: "/views/bigquery_tables/reporting_layer/core/hub_level_kpis.view"

include: "/explores/base_explores/orders_cl.explore"

include: "/**/global_filters_and_parameters.view.lkml"


explore: orders_cl {
  from: orders_using_hubs
  view_name: orders_cl  # needs to be set in order that the base_explore can be extended and referenced properly
  hidden: no

  group_label: "01) Performance"
  label: "Orders"
  description: "General Business Performance - Orders, Revenue, etc."

  view_label: "* Orders *"

  sql_always_where: {% condition global_filters_and_parameters.datasource_filter %} ${orders_cl.created_date} {% endcondition %} ;;

  always_filter: {
    filters:  [
      orders_cl.is_successful_order: "yes",
      global_filters_and_parameters.datasource_filter: "last 60 days",
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

  join: global_filters_and_parameters {
    sql_on: ${global_filters_and_parameters.generic_join_dim} = TRUE ;;
    type: left_outer
    relationship: many_to_one
  }

  join: hub_level_kpis {
    from: hub_level_kpis
    view_label: "* Hub Level KPIs *"
    sql_on: lower(${orders_cl.hub_code}) = ${hub_level_kpis.hub_code} and
            ${orders_cl.created_date} = ${hub_level_kpis.order_date}  ;;
    relationship: one_to_many
    type: left_outer
  }


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
    from: nps_after_order_cl
    view_label: "* NPS *"
    sql_on: ${orders_cl.country_iso}   = ${nps_after_order.country_iso} AND
      ${orders_cl.order_number}  =       ${nps_after_order.order_number} ;;
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

  join: cs_post_delivery_issues {
    view_label: "* Post Delivery Issues on Order-Level *"
    sql_on: ${orders_cl.country_iso} = ${cs_post_delivery_issues.country_iso} AND
      ${cs_post_delivery_issues.order_nr_} = ${orders_cl.order_number};;
    relationship: one_to_many
    type: left_outer
  }


}
