include: "/**/*.view"



####### HUB LEADERBOARD ORDER EXPLORE #######
explore: hub_leaderboard_raw_order_order {
  from: order_order
  label: "Orders - Hub Leaderboard"
  view_label: "* Orders *"
  group_label: "01) Performance"
  description: "General Business Performance - Orders, Revenue, etc."
  hidden: yes
  always_filter: {
    filters:  [
      hubs.country: "",
      hubs.hub_name: "",
      hub_leaderboard_raw_order_order.is_internal_order: "no",
      hub_leaderboard_raw_order_order.is_successful_order: "yes",
      hub_leaderboard_raw_order_order.created_date: "after 2021-01-25"
    ]
  }


  fields: [
    hub_leaderboard_raw_order_order.created_date,
    hub_leaderboard_raw_order_order.cnt_orders_delayed_under_0_min,
    hub_leaderboard_raw_order_order.cnt_orders_delayed_over_5_min,
    hub_leaderboard_raw_order_order.cnt_orders_with_delivery_eta_available,
    hub_leaderboard_raw_order_order.country_iso,
    hub_leaderboard_raw_order_order.warehouse_name,
    hub_leaderboard_raw_order_order.is_delivery_eta_available,
    hub_leaderboard_raw_order_order.delivery_delay_since_eta,
    hub_leaderboard_raw_order_order.is_internal_order,
    hub_leaderboard_raw_order_order.is_successful_order,
    hub_leaderboard_raw_order_order.date_granularity,


    hubs.hub_code_lowercase,
    hubs.hub_code,
    hubs.country,
    hubs.city,
    hubs.hub_name,
    hubs.city_manager,


    hub_leaderboard_shift_metrics.sum_filled_ext_picker_hours,
    hub_leaderboard_shift_metrics.sum_filled_ext_rider_hours,
    hub_leaderboard_shift_metrics.sum_filled_picker_hours,
    hub_leaderboard_shift_metrics.sum_filled_rider_hours,
    hub_leaderboard_shift_metrics.sum_filled_no_show_picker_hours,
    hub_leaderboard_shift_metrics.sum_filled_no_show_rider_hours,
    hub_leaderboard_shift_metrics.sum_planned_picker_hours,
    hub_leaderboard_shift_metrics.sum_planned_rider_hours,
    hub_leaderboard_shift_metrics.sum_unfilled_picker_hours,
    hub_leaderboard_shift_metrics.sum_unfilled_rider_hours,

    hub_leaderboard_shift_metrics.sum_filled_ext_hours_total,
    hub_leaderboard_shift_metrics.sum_filled_no_show_hours_total,
    hub_leaderboard_shift_metrics.sum_unfilled_hours_total,


    nps_after_order.cnt_responses,
    nps_after_order.cnt_detractors,
    nps_after_order.cnt_passives,
    nps_after_order.cnt_promoters,
    nps_after_order.score,

    shyftplan_riders_pickers_hours.rider_hours,
    shyftplan_riders_pickers_hours.picker_hours,
    shyftplan_riders_pickers_hours.adjusted_orders_riders,
    shyftplan_riders_pickers_hours.adjusted_orders_pickers,

    issue_rate_hub_level.sum_orders_total,
    issue_rate_hub_level.sum_orders_with_issues,

    hub_leaderboard.pct_delivery_in_time,
    hub_leaderboard.pct_delivery_late_over_5_min,
    hub_leaderboard.pct_detractors,
    hub_leaderboard.pct_passives,
    hub_leaderboard.pct_promoters,
    hub_leaderboard.nps_score,
    hub_leaderboard.pct_orders_with_issues,
    hub_leaderboard.pct_no_show,
    hub_leaderboard.pct_open_shifts,
    hub_leaderboard.pct_ext_shifts,
    hub_leaderboard.rider_utr,
    hub_leaderboard.picker_utr,
    hub_leaderboard.score_delivery_in_time,
    hub_leaderboard.score_delivery_late_over_5_min,
    hub_leaderboard.score_nps_score,
    hub_leaderboard.score_orders_with_issues,
    hub_leaderboard.score_no_show,
    hub_leaderboard.score_open_shifts,
    hub_leaderboard.score_ext_shifts,
    hub_leaderboard.score_rider_utr,
    hub_leaderboard.score_picker_utr,
    hub_leaderboard.score_hub_leaderboard,
    hub_leaderboard.is_current_7d,
    hub_leaderboard.is_previous_7d,

    hub_leaderboard_current.score_hub_leaderboard,

    hub_leaderboard_previous.score_hub_leaderboard
  ]

  access_filter: {
    field: hub_leaderboard_raw_order_order.country_iso
    user_attribute: country_iso
  }

  access_filter: {
    field: hubs.city
    user_attribute: city
  }

  #filter Investor user so they can only see completed calendar weeks data and not week to date
  sql_always_where: CASE WHEN ({{ _user_attributes['id'] }}) = 28 THEN ${hub_leaderboard_raw_order_order.created_week} < ${now_week} ELSE 1=1 END;;


  join: hubs {
    view_label: "* Hubs *"
    sql_on: ${hub_leaderboard_raw_order_order.country_iso} = ${hubs.country_iso} AND
      ${hub_leaderboard_raw_order_order.warehouse_name} = ${hubs.hub_code_lowercase} ;;
    relationship: one_to_one
    type: left_outer
  }

  join: hub_leaderboard_shift_metrics {
    view_label: "* Hubs *"
    sql_on: ${hub_leaderboard_raw_order_order.warehouse_name} = ${hub_leaderboard_shift_metrics.hub_code_lowercase} and
      ${hub_leaderboard_raw_order_order.created_date}   = ${hub_leaderboard_shift_metrics.date};;
    relationship: many_to_one
    type: left_outer
  }


  join: nps_after_order {
    view_label: "* NPS *"
    sql_on: ${hub_leaderboard_raw_order_order.country_iso} = ${nps_after_order.country_iso} AND
      ${hub_leaderboard_raw_order_order.id} = ${nps_after_order.order_id} ;;
    relationship: one_to_many
    type: left_outer
  }

  join: shyftplan_riders_pickers_hours {
    view_label: "* Shifts *"
    sql_on: ${hub_leaderboard_raw_order_order.created_date} = ${shyftplan_riders_pickers_hours.date} and
      ${hubs.hub_code} = ${shyftplan_riders_pickers_hours.hub_name};;
    relationship: many_to_one
    type: left_outer
  }

  join: issue_rate_hub_level {
    view_label: "Order Issues on Hub-Level"
    sql_on: ${hubs.hub_code_lowercase} =  LOWER(${issue_rate_hub_level.hub_code}) and
      ${hub_leaderboard_raw_order_order.date}        =  ${issue_rate_hub_level.date};;
    relationship: many_to_one # decided against one_to_many: on this level, many orders have hub-level issue-aggregates
    type: left_outer
  }

  join: hub_leaderboard {
    view_label: "* Hubs *"
    sql_on: ${hub_leaderboard_raw_order_order.warehouse_name} = ${hub_leaderboard.hub_code_lowercase} and
      ${hub_leaderboard_raw_order_order.created_date}   = ${hub_leaderboard.created_date};;
    relationship: many_to_one
    type: left_outer
  }

  join: hub_leaderboard_current {
    view_label: "* Hubs *"
    sql_on: ${hub_leaderboard_raw_order_order.warehouse_name} = ${hub_leaderboard_current.hub_code_lowercase} ;;
    relationship: many_to_one
    type: left_outer
  }

  join: hub_leaderboard_previous {
    view_label: "* Hubs *"
    sql_on: ${hub_leaderboard_raw_order_order.warehouse_name} = ${hub_leaderboard_previous.hub_code_lowercase} ;;
    relationship: many_to_one
    type: left_outer
  }

}

explore: hub_leaderboard {
  hidden: yes
}
