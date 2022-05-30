# Owner: Nazrin Guliyeva

# This explore provides employee-related data (worked hours, planned employees, etc.), order-related data (fulfillment time, number of orders, distance, etc.)
# and forecast data (missed orders, forecasted orders, forecasted employees, etc.)
# on a hub + 30-min slot level

include: "/views/bigquery_tables/curated_layer/hubs_ct.view"
include: "/views/bigquery_tables/curated_layer/orders.view"
include: "/views/extended_tables/orders_using_hubs.view"
include: "/views/bigquery_tables/reporting_layer/rider_ops/staffing.view"
include: "/views/bigquery_tables/curated_layer/forecasts.view"
include: "/supply_chain/views/bigquery_reporting/inventory_changes_daily.view"

explore: ops {
  from: staffing
  group_label: "Rider Ops"
  view_label: "Staffing"
  label: "Ops"
  hidden: yes

  always_filter: {
    filters:  [
      ops.position_parameter: "Rider",
      hubs.country: "",
      hubs.hub_name: "",
      time_grid.start_datetime_date: "yesterday",
      forecasts.forecast_horizon: "0",
      time_grid.start_datetime_hour_of_day: "[6,23]"
    ]
  }

  # To be consistent remove fileds with view labels formatted with *
  # Remove successful order filter, as we only take into account those only
  # Remove fields that use cross reference from shyftplan

  fields: [ALL_FIELDS*,-orders_cl.cnt_orders_with_delivery_eta_available,-orders_cl.cnt_orders_with_targeted_eta_available, -orders_cl.KPI,
        -orders_cl.sum_rider_hours]

  # Dimensional time grid table to have generic date filter
  join: time_grid {
    from: time_grid
    sql_on: ${ops.start_timestamp_minute30} = ${time_grid.start_datetime_minute30} ;;
    relationship: one_to_one
    type: full_outer
    fields: [time_grid.start_datetime_date, time_grid.start_datetime_hour_of_day, time_grid.start_datetime_minute30,
            time_grid.start_datetime_month,time_grid.start_datetime_quarter,time_grid.start_datetime_raw,time_grid.start_datetime_time,
            time_grid.start_datetime_time_of_day,time_grid.start_datetime_week, time_grid.start_datetime_year]
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

  # Orders data
  join: orders_cl {
    from: orders_using_hubs
    view_label: "Orders"
    sql_on: ${orders_cl.created_minute30} = ${time_grid.start_datetime_minute30}
      and lower(${orders_cl.hub_code})=lower(${hubs.hub_code}) and ${orders_cl.is_successful_order}= true;;
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
    sql_on: lower(${orders_cl.hub_code}) = lower(${inventory_changes_daily.hub_code})
      and ${orders_cl.created_date}  = ${inventory_changes_daily.inventory_change_date} ;;
    relationship: many_to_many
    type: left_outer
    fields: [inventory_changes_daily.fields_for_utr_calculation*]
  }

}
