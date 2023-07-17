include: "/**/hub_staffing.view"
include: "/**/hubs_ct.view"

explore: hub_staffing {
  group_label: "Last Mile & WFM"
  view_label: "* Hub Staffing *"
  label: "Hub Staffing"
  description: "Hub Staffing KPIs such as # worked hours,# planned hours, # no_show etc ."
  hidden: no


  always_filter: {
    filters:  [
      hub_staffing.shift_date: "last 7 days",
      position_name:"rider",
      hubs.country: "",
      hubs.hub_name: ""
    ]
  }

  join: hubs {
    from: hubs_ct
    sql_on:
    lower(${hub_staffing.hub_code}) = lower(${hubs.hub_code}) ;;
    relationship: many_to_one
    type: left_outer
  }

  # join: forecasting_models {
  #   from: order_forecasting_models
  #   sql_on:
  #   lower(${hub_staffing.hub_code}) = lower(${forecasting_models.hub_code}) and
  #   ${hub_staffing.block_ends_at_timestamp_date} = ${forecasting_models.end_timestamp_date} and
  #   ${hub_staffing.block_start_time} = ${forecasting_models.local_start_time};;
  #   relationship: many_to_one
  #   type: left_outer
  # }

}
