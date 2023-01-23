## Owner: Victor Breda
## This explore provides closure information on hubs and turfs. It joins 2 main views that are on hub-turf-day-closure_reason
## granularity (contains all historical data), and hub-turf-30min-closure_reason granularity (contains the last 30days of data)

include: "/**/hub_turf_closures_30min.view.lkml"
include: "/**/hub_turf_closures_daily.view.lkml"
include: "/**/orders.view.lkml"
include: "/**/hubs_ct.view.lkml"
include: "/**/global_filters_and_parameters.view"

explore: hub_closures_reporting {
  view_name: hub_turf_closures_30min
  group_label: "Rider Ops"
  label: "Hub Closures"
  view_label: "Hub Closures (30min)"

  sql_always_where: {% condition global_filters_and_parameters.datasource_filter %} ${hub_turf_closures_30min.report_date} {% endcondition %} ;;

  always_filter: {
    filters:  [
      global_filters_and_parameters.datasource_filter: "last 7 days",
      hubs_ct.country_iso: "",
      hubs_ct.hub_code: ""
    ]
  }

  access_filter: {
    field: hubs_ct.country_iso
    user_attribute: country_iso
  }

  join: global_filters_and_parameters {
    sql: ;;
  relationship: one_to_one
}

  join: hub_turf_closures_daily {
    view_label: "Hub Closures (Daily)"
    sql_on: ${hub_turf_closures_30min.hub_code}=${hub_turf_closures_daily.hub_code}
        and coalesce(${hub_turf_closures_30min.turf_id},'') = coalesce(${hub_turf_closures_daily.turf_id},'')
        and ${hub_turf_closures_30min.report_date}=${hub_turf_closures_daily.report_date}
        and ${hub_turf_closures_30min.closure_reason}=${hub_turf_closures_daily.closure_reason}
        and {% condition global_filters_and_parameters.datasource_filter %} ${hub_turf_closures_daily.report_date} {% endcondition %};;
    type: left_outer
    relationship: many_to_many
  }

  join: orders {
    #This is done to hide the fields from the explore
    view_label: ""
    sql_on: ${hub_turf_closures_30min.hub_code} = ${orders.hub_code}
    and ${hub_turf_closures_30min.report_minute30} = ${orders.created_minute30};;
    type: left_outer
    relationship: many_to_many
    fields: [orders.number_of_succesful_non_external_orders,
      orders.is_external_order,
      orders.is_successful_order]
  }

  join: hubs_ct {
    view_label: "Hubs"
    sql_on: ${hubs_ct.hub_code}=${hub_turf_closures_daily.hub_code};;
    type: left_outer
    relationship: many_to_one
  }
}
