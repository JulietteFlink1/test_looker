# Owner: Nazrin Guliyeva

# This explore provides employee-related data (worked hours, planned employees, etc.), order-related data (fulfillment time, number of orders, distance, etc.)
# and forecast data (missed orders, forecasted orders, forecasted employees, etc.)
# on a hub + 30-min slot level

include: "/views/bigquery_tables/curated_layer/hubs_ct.view"
include: "/views/bigquery_tables/curated_layer/orders.view"
include: "/views/extended_tables/orders_using_hubs.view"
include: "/views/bigquery_tables/reporting_layer/rider_ops/staffing.view"
include: "/views/bigquery_tables/curated_layer/forecasts.view"

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
      forecasts.start_timestamp_date: "yesterday",
      forecasts.forecast_horizon: "0"

    ]
  }

  fields: [ALL_FIELDS*,-orders_cl.cnt_orders_with_delivery_eta_available,-orders_cl.cnt_orders_with_targeted_eta_available]

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
    sql_on: ${orders_cl.created_minute30} = ${ops.start_timestamp_minute30}
      and lower(${orders_cl.hub_code})=lower(${ops.hub_code});;
    relationship: one_to_many
    type: left_outer
  }

  # Forecast data (e.g. forecasted orders, employee hours, etc.)
  join: forecasts {
    from: forecasts
    view_label: "Forecasts"
    sql_on: ${forecasts.start_timestamp_minute30} = ${ops.start_timestamp_minute30}
      and lower(${forecasts.hub_code})=lower(${ops.hub_code});;
    relationship: one_to_many
    type: left_outer
  }

  # Cross reference dependency from orders view
  join: shyftplan_riders_pickers_hours {
    from: shyftplan_riders_pickers_hours_clean
    view_label: ""
    sql_on: ${orders_cl.created_date} = ${shyftplan_riders_pickers_hours.shift_date}
      and ${hubs.hub_code} = lower(${shyftplan_riders_pickers_hours.hub_name});;
    relationship: many_to_many
    type: left_outer
  }
}
