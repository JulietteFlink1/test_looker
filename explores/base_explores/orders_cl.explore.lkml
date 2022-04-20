include: "/views/bigquery_tables/curated_layer/orders.view"
include: "/views/extended_tables/orders_using_hubs.view"
include: "/views/projects/cleaning/shyftplan_riders_pickers_hours_clean.view"
# include: "/views/projects/cleaning/hub_stafing_test.view"

include: "/views/bigquery_tables/curated_layer/hubs_ct.view"
include: "/views/bigquery_tables/curated_layer/nps_after_order_cl.view"
include: "/views/bigquery_tables/curated_layer/cs_post_delivery_issues.view"
include: "/views/sql_derived_tables/bottom_10_hubs.view"
include: "/views/native_derived_tables/general/idle_time.view"
include: "/views/**/orderline.view"

include: "/views/bigquery_tables/reporting_layer/core/hub_level_kpis.view"

include: "/explores/base_explores/orders_cl.explore"

include: "/**/global_filters_and_parameters.view.lkml"

include: "/views/time_grid.view.lkml"


explore: orders_cl {
  hidden: no
  from: time_grid
  view_name: time_grid  # needs to be set in order that the base_explore can be extended and referenced properly

  group_label: "01) Performance"
  label: "Orders"
  description: "General Business Performance - Orders, Revenue, etc."

  sql_always_where: {% condition global_filters_and_parameters.datasource_filter %} ${time_grid.start_datetime_date} {% endcondition %} ;;

  always_join: [
    orders_cl, shyftplan_riders_pickers_hours
  ]

  access_filter: {
    field: orders_cl.country_iso
    user_attribute: country_iso
  }

  access_filter: {
    field: hubs.city
    user_attribute: city
  }

  always_filter: {
    filters:  [
      global_filters_and_parameters.datasource_filter: "last 60 days",
      orders_cl.is_successful_order: "",
      hubs.country: "",
      hubs.hub_name: ""
    ]
  }

  join: orders_cl {
    view_label: "* Orders *"
    from: orders_using_hubs
    sql_on: ${orders_cl.created_minute30} = ${time_grid.start_datetime_minute30}
    and lower(${orders_cl.hub_code})=${time_grid.hub_code};;
    type: left_outer
    relationship: one_to_many
  }

  join: global_filters_and_parameters {
    sql_on: ${global_filters_and_parameters.generic_join_dim} = TRUE ;;
    type: left_outer
    relationship: many_to_one
  }

  join: shyftplan_riders_pickers_hours {
    from: shyftplan_riders_pickers_hours_clean
    view_label: "* Shifts *"
    sql_on: ${time_grid.start_datetime_minute30} = ${shyftplan_riders_pickers_hours.block_starts_at_timestamp_minute30} and
     lower(${time_grid.hub_code})          = lower(${shyftplan_riders_pickers_hours.hub_name});;
    relationship: many_to_many
    type: left_outer
  }

  join: hubs {
    from: hubs_ct
    view_label: "* Hubs *"
    sql_on: lower(${time_grid.hub_code}) = ${hubs.hub_code} ;;
    relationship: many_to_one
    type: left_outer
  }

  join: hub_level_kpis {
    from: hub_level_kpis
    view_label: ""
    sql_on: lower(${orders_cl.hub_code}) = ${hub_level_kpis.hub_code} and
            ${orders_cl.created_date} = ${hub_level_kpis.order_date}  and
            ${orders_cl.is_successful_order} = ${hub_level_kpis.is_successful_order}

      ;;
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

  join: cs_post_delivery_issues {
    view_label: ""
    sql_on: ${orders_cl.country_iso} = ${cs_post_delivery_issues.country_iso} AND
      ${cs_post_delivery_issues.order_nr_} = ${orders_cl.order_number};;
    relationship: one_to_many
    type: left_outer
  }


  # add issue rate core metrics: https://goflink.atlassian.net/browse/DATA-1452
  join: orderline_issue_rate_core_kpis {
    from: orderline
    view_label: "* Orders *"
    sql_on: ${orderline_issue_rate_core_kpis.country_iso} = ${orders_cl.country_iso} AND
            ${orderline_issue_rate_core_kpis.order_uuid}    = ${orders_cl.order_uuid} AND
            {% condition global_filters_and_parameters.datasource_filter %} ${orderline_issue_rate_core_kpis.created_date} {% endcondition %} ;;

    relationship: one_to_many
    type: left_outer
    fields: [orderline_issue_rate_core_kpis.orders_core_fields*]
  }

}
