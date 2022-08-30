include: "/views/bigquery_tables/curated_layer/orders.view"
include: "/views/extended_tables/orders_using_hubs.view"
include: "/views/projects/cleaning/shyftplan_riders_pickers_hours_clean.view"
include: "/views/bigquery_tables/curated_layer/hubs_ct.view"
include: "/views/bigquery_tables/curated_layer/nps_after_order_cl.view"
include: "/explores/base_explores/orders_cl.explore"
include: "/**/hub_monthly_orders.view"

include: "/**/global_filters_and_parameters.view.lkml"


explore: orders_cl {
  from: orders_using_hubs
  view_name: orders_cl  # needs to be set in order that the base_explore can be extended and referenced properly
  hidden: no

  group_label: "01) Performance"
  label: "Orders"
  description: "General Business Performance - Orders, Revenue, etc."

  view_label: "Orders"

  sql_always_where: {% condition global_filters_and_parameters.datasource_filter %} ${orders_cl.created_date} {% endcondition %} ;;

  always_filter: {
    filters:  [
      orders_cl.is_successful_order: "yes",
      global_filters_and_parameters.datasource_filter: "last 7 days",
      hubs.country: "",
      hubs.hub_name: ""
    ]
  }
  access_filter: {
    field: orders_cl.country_iso
    user_attribute: country_iso

    }

  join: global_filters_and_parameters {
    sql_on: ${global_filters_and_parameters.generic_join_dim} = TRUE ;;
    type: left_outer
    relationship: many_to_one
  }

  join: hubs {
    from: hubs_ct
    view_label: "Hubs"
    sql_on: lower(${orders_cl.hub_code}) = ${hubs.hub_code} ;;
    relationship: many_to_one
    type: left_outer
  }

  join: shyftplan_riders_pickers_hours {
    from: shyftplan_riders_pickers_hours_clean
    view_label: "Shifts"
    sql_on: ${orders_cl.created_date} = ${shyftplan_riders_pickers_hours.shift_date} and
      ${hubs.hub_code}          = lower(${shyftplan_riders_pickers_hours.hub_name});;
    relationship: many_to_many
    type: left_outer
  }

    # To get cleaned UTRs (based on Orders delivered just by riders)

  join: employee_level_kpis {
    from: employee_level_kpis
    view_label: ""
    sql_on: ${orders_cl.created_date} = ${employee_level_kpis.shift_date} and
      ${hubs.hub_code}          = lower(${employee_level_kpis.hub_code});;
    relationship: many_to_many
    type: left_outer
  }

  join: nps_after_order {
    from: nps_after_order_cl
    view_label: "NPS"
      sql_on: ${orders_cl.country_iso}   = ${nps_after_order.country_iso} AND
        ${orders_cl.order_number}  =       ${nps_after_order.order_number} ;;
      relationship: one_to_many
      type: left_outer
    }

  join: orderline_issue_rate_core_kpis {
    from: orderline
    view_label: "Orders"
    sql_on: ${orderline_issue_rate_core_kpis.country_iso} = ${orders_cl.country_iso} AND
        ${orderline_issue_rate_core_kpis.order_uuid}    = ${orders_cl.order_uuid} AND
        {% condition global_filters_and_parameters.datasource_filter %} ${orderline_issue_rate_core_kpis.created_date} {% endcondition %}
      ;;
    relationship: one_to_many
    type: left_outer
    fields: [orderline_issue_rate_core_kpis.orders_core_fields*]
  }

  join: orders_hub_staffing {
    sql:  ;;
    relationship: one_to_one
    view_label: "Orders"
  }

  join: hub_monthly_orders {
    view_label: "Hubs"
    sql_on:
      ${orders_cl.hub_code} = ${hub_monthly_orders.hub_code} and
      date_trunc(${orders_cl.order_date},month) = ${hub_monthly_orders.created_month} ;;
    relationship: many_to_one
    type: left_outer
  }

}
