# Owner: Nazrin Guliyeva

# This explore provides employee-related data (worked hours, planned employees, etc.), order-related data (fulfillment time, number of orders, distance, etc.)
# and forecast data (missed orders, forecasted orders, forecasted employees, etc.)
# on a hub + 30-min slot level

include: "/**/staffing.view"
include: "/**/time_grid.view"
include: "/**/hubs_ct.view"
include: "/**/orders_with_ops_metrics.view"
include: "/**/forecasts.view"
include: "/**/inventory_changes_daily.view"
include: "/**/hub_monthly_orders.view"
include: "/**/order_backlog.view"
include: "/**/hub_attributes.view"
include: "/**/hub_turf_closures_30min.view"
include: "/**/hub_turf_closures_daily.view"
include: "/**/cr_dynamic_ops_metrics.view"
include: "/**/hub_uph_30min.view"
include: "/**/ops_associate_staffing.view"
include: "/**/hub_bottleneck_30min.view"


explore: ops {
  from: staffing
  group_label: "Rider Ops"
  view_label: "Staffing"
  label: "Ops"
  hidden: no

  always_filter: {
    filters:  [
      ops.position_parameter: "Rider",
      hubs.country: "",
      hubs.hub_name: "",
      time_grid.start_datetime_date: "yesterday"
    ]
  }


  access_filter: {
    field: hubs.country_iso
    user_attribute: country_iso
  }

  # Dimensional time grid table to have generic date filter
  join: time_grid {
    from: time_grid
    view_label: "Timeslot"
    sql_on: ${ops.start_timestamp_minute30} = ${time_grid.start_datetime_minute30} ;;
    relationship: one_to_one
    type: full_outer
    fields: [time_grid.start_datetime_date, time_grid.start_datetime_hour_of_day, time_grid.start_datetime_minute30,
      time_grid.start_datetime_month,time_grid.start_datetime_quarter,time_grid.start_datetime_raw,time_grid.start_datetime_time,
      time_grid.start_datetime_time_of_day,time_grid.start_datetime_week,time_grid.start_datetime_week_of_year, time_grid.start_datetime_year, time_grid.is_hour_before_now_hour,
      time_grid.is_date_before_today,time_grid.start_datetime_day_of_week, time_grid.date_granularity, time_grid.date_dynamic]
  }

  # Basic Hub data (e.g. name, city, creation date, etc. )
  join: hubs {
    from: hubs_ct
    view_label: "Hub Data"
    sql_on:
    lower(${ops.hub_code}) = lower(${hubs.hub_code}) ;;
    relationship: many_to_one
    type: left_outer
  }

  # Hub Attributes
  join: hub_attributes {
    from: hub_attributes
    view_label: "Hub Data"
    sql_on:
    lower(${ops.hub_code}) = lower(${hub_attributes.hub_code}) ;;
    relationship: many_to_one
    type: left_outer
  }

  # Orders data
  join: orders_with_ops_metrics {
    from: orders_with_ops_metrics
    view_label: "Orders"
    sql_on: ${orders_with_ops_metrics.created_minute30} = ${time_grid.start_datetime_minute30}
      and lower(${orders_with_ops_metrics.hub_code})=lower(${hubs.hub_code});;
    relationship: one_to_many
    type: left_outer
  }

  # Forecast data (e.g. forecasted orders, employee hours, etc.)
  join: forecasts {
    from: forecasts
    view_label: "Forecasts"
    sql_on: ${forecasts.start_timestamp_minute30} = ${time_grid.start_datetime_minute30}
      and lower(${forecasts.hub_code})=lower(${hubs.hub_code});;
    relationship: one_to_many
    type: left_outer
  }

  # Cross reference dependency from staffing view
  join: inventory_changes_daily {
    from: inventory_changes_daily
    view_label: ""
    sql_on: lower(${hubs.hub_code}) = lower(${inventory_changes_daily.hub_code})
      and ${time_grid.start_datetime_date}  = ${inventory_changes_daily.inventory_change_date} ;;
    relationship: many_to_many
    type: left_outer
    fields: [inventory_changes_daily.fields_for_utr_calculation*]
  }

  join: hub_monthly_orders {
    view_label: "Hub Data"
    sql_on:
      ${hubs.hub_code} = ${hub_monthly_orders.hub_code} and
      date_trunc(${time_grid.start_datetime_date},month) = ${hub_monthly_orders.created_month};;
    relationship: many_to_one
    type: left_outer
  }

  join: order_backlog {
    view_label: "Order Backlog"
    sql_on:
      ${hubs.hub_code} = ${order_backlog.hub_code}
      and ${time_grid.start_datetime_minute30}  = ${order_backlog.start_timestamp_minute30} ;;
    relationship: one_to_one
    type: left_outer
  }

  join: hub_turf_closures_30min {
    view_label: "Closures"
    sql_on: ${hub_turf_closures_30min.hub_code} =  ${hubs.hub_code}
      and ${time_grid.start_datetime_minute30} = ${hub_turf_closures_30min.report_minute30};;
    relationship: one_to_many
    type: left_outer
    fields: [hub_turf_closures_30min.sum_number_of_closed_hours,
      hub_turf_closures_30min.share_closed_hours_per_open_hours,
      hub_turf_closures_30min.sum_number_of_missed_orders_forced_closure,
      hub_turf_closures_30min.share_of_missed_orders_per_number_of_successful_non_external_orders,
      hub_turf_closures_30min.sum_number_of_last_mile_missed_orders_forced_closure,
      hub_turf_closures_30min.sum_number_of_last_mile_missed_orders_forced_closure_understaffing_auto_closure,
      hub_turf_closures_30min.share_of_last_mile_missed_orders_per_number_of_successful_non_external_orders,
      hub_turf_closures_30min.share_of_last_mile_missed_orders_understaffing_auto_closure_per_number_of_successful_non_external_orders,
      hub_turf_closures_30min.closure_reason]
  }

  join: hub_turf_closures_daily {
    view_label: "Closures"
    sql_on: ${hub_turf_closures_30min.hub_code}=${hub_turf_closures_daily.hub_code}
        and coalesce(${hub_turf_closures_30min.turf_id},'') = coalesce(${hub_turf_closures_daily.turf_id},'')
        and ${hub_turf_closures_30min.report_date}=${hub_turf_closures_daily.report_date}
        and ${hub_turf_closures_30min.closure_reason}=${hub_turf_closures_daily.closure_reason};;
    type: left_outer
    relationship: many_to_one
    fields: [hub_turf_closures_daily.closure_reason,
      hub_turf_closures_daily.turf_name]
  }

  join: hub_uph_30min {
    view_label: "Hub UPH"
    sql_on: ${hub_uph_30min.hub_code}=${ops.hub_code}
      and ${hub_uph_30min.block_starts_at_minute30}=${time_grid.start_datetime_minute30};;
    type: left_outer
    relationship: one_to_many
  }

  join: ops_associate_staffing {
    view_label: "Ops Associate Staffing"
    sql_on: ${ops_associate_staffing.hub_code}=${ops.hub_code}
      and ${ops_associate_staffing.block_starts_minute30}=${time_grid.start_datetime_minute30};;
    type: left_outer
    relationship: one_to_many
  }

  join: hub_bottleneck_30min {
    view_label: "Hub Bottleneck"
    sql_on: ${hub_bottleneck_30min.hub_code}=${ops.hub_code}
      and ${hub_bottleneck_30min.start_timestamp_minute30}=${time_grid.start_datetime_minute30};;
    type: left_outer
    relationship: one_to_many
  }

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #  - - - - - - - - - -    Cross-Referenced Metrics
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  join: cr_dynamic_ops_metrics {
    view_label: "Orders"
    relationship: one_to_one
    type: left_outer
    sql:  ;;
}

}
