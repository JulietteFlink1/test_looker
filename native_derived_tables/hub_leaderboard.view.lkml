# If necessary, uncomment the line below to include explore_source.
# include: "flink_v3.model.lkml"

view: hub_leaderboard {
  derived_table: {
    # datagroup_trigger: flink_default_datagroup
    # persist_for: "24 hours"
    explore_source: order_order {
      column: sum_filled_ext_picker_hours     { field: hub_leaderboard_shift_metrics.sum_filled_ext_picker_hours }
      column: sum_filled_ext_rider_hours      { field: hub_leaderboard_shift_metrics.sum_filled_ext_rider_hours }
      column: sum_filled_picker_hours         { field: hub_leaderboard_shift_metrics.sum_filled_picker_hours }
      column: sum_filled_rider_hours          { field: hub_leaderboard_shift_metrics.sum_filled_rider_hours }
      column: sum_filled_no_show_picker_hours { field: hub_leaderboard_shift_metrics.sum_filled_no_show_picker_hours }
      column: sum_filled_no_show_rider_hours  { field: hub_leaderboard_shift_metrics.sum_filled_no_show_rider_hours }
      column: sum_planned_picker_hours        { field: hub_leaderboard_shift_metrics.sum_planned_picker_hours }
      column: sum_planned_rider_hours         { field: hub_leaderboard_shift_metrics.sum_planned_rider_hours }
      column: sum_unfilled_picker_hours       { field: hub_leaderboard_shift_metrics.sum_unfilled_picker_hours }
      column: sum_unfilled_rider_hours        { field: hub_leaderboard_shift_metrics.sum_unfilled_rider_hours }
      column: hub_code_lowercase              { field: hubs.hub_code_lowercase }
      column: created_date                    { field: order_order.created_date}
      column: cnt_orders_delayed_under_0_min  { field: order_order.cnt_orders_delayed_under_0_min}
      column: cnt_orders_delayed_over_5_min   { field: order_order.cnt_orders_delayed_over_5_min}
      column: cnt_orders_with_delivery_eta_available {field: order_order.cnt_orders_with_delivery_eta_available}
      column: cnt_responses                   { field: nps_after_order.cnt_responses }
      column: cnt_detractors                  { field: nps_after_order.cnt_detractors }
      column: cnt_passives                    { field: nps_after_order.cnt_passives }
      column: cnt_promoters                   { field: nps_after_order.cnt_promoters }
      column: sum_orders_total                { field: issue_rate_hub_level.sum_orders_total }
      column: sum_orders_with_issues          { field: issue_rate_hub_level.sum_orders_with_issues }
      filters: {
        field: order_order.is_internal_order
        value: "no"
      }
      filters: {
        field: order_order.is_successful_order
        value: "yes"
      }
      filters: {
        field: order_order.created_date
        value: "after 2021/01/25"
      }
    }
  }

  dimension: hub_code_lowercase {
    label: "* Hubs * Hub Code Lowercase"
    type: string
    hidden: yes
  }
  dimension: created_date {
    label: "* Orders * Order Date"
    description: "Order Placement Date/Time"
    type: date
    hidden: yes
  }
  dimension: unique_id {
    primary_key: yes
    hidden: yes
    type: string
    sql: concat( CAST(${created_date} as string), ${hub_code_lowercase})  ;;
  }


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #   MEASURES
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  measure: sum_filled_ext_picker_hours {
    label: "Hours: Filled Ext. Picker"
    value_format_name: decimal_1
    sql: ${TABLE}.sum_filled_ext_picker_hours ;;
    type: sum
    hidden: yes
  }
  measure: sum_filled_ext_rider_hours {
    label: "Hours: Filled Ext. Rider"
    value_format_name: decimal_1
    sql: ${TABLE}.sum_filled_ext_rider_hours ;;
    type: sum
    hidden: yes
  }
  measure: sum_filled_picker_hours {
    label: "Hours: Filled Picker"
    value_format_name: decimal_1
    sql: ${TABLE}.sum_filled_picker_hours ;;
    type: sum
    hidden: yes
  }
  measure: sum_filled_rider_hours {
    label: "Hours: Filled Rider"
    value_format_name: decimal_1
    sql: ${TABLE}.sum_filled_rider_hours ;;
    type: sum
    hidden: yes
  }
  measure: sum_filled_no_show_picker_hours {
    label: "Hours: No Show Picker"
    value_format_name: decimal_1
    sql: ${TABLE}.sum_filled_no_show_picker_hours ;;
    type: sum
    hidden: yes
  }
  measure: sum_filled_no_show_rider_hours {
    label: "Hours: No Show Rider"
    value_format_name: decimal_1
    sql: ${TABLE}.sum_filled_no_show_rider_hours ;;
    type: sum
    hidden: yes
  }
  measure: sum_planned_picker_hours {
    label: "Hours: Planned Picker"
    value_format_name: decimal_1
    sql: ${TABLE}.sum_planned_picker_hours ;;
    type: sum
    hidden: yes
  }
  measure: sum_planned_rider_hours {
    label: "Hours: Planned Rider"
    value_format_name: decimal_1
    sql: ${TABLE}.sum_planned_rider_hours ;;
    type: sum
    hidden: yes
  }
  measure: sum_unfilled_picker_hours {
    label: "Hours: Unfilled Picker"
    value_format_name: decimal_1
    sql: ${TABLE}.sum_unfilled_picker_hours ;;
    type: sum
    hidden: yes
  }
  measure: sum_unfilled_rider_hours {
    label: "Hours: Unfilled Rider"
    value_format_name: decimal_1
    sql: ${TABLE}.sum_unfilled_rider_hours ;;
    type: sum
    hidden: yes
  }
  measure: cnt_orders_delayed_under_0_min {
    label: "# Orders delivered in time"
    description: "Count of Orders delivered no later than promised ETA"
    value_format_name: decimal_1
    sql: ${TABLE}.cnt_orders_delayed_under_0_min ;;
    type: sum
    hidden: yes
  }
  measure: cnt_orders_delayed_over_5_min {
    label: "# Orders delivered late >5min"
    description: "Count of Orders delivered >5min later than promised ETA"
    value_format_name: decimal_1
    sql: ${TABLE}.cnt_orders_delayed_over_5_min ;;
    type: sum
    hidden: yes
  }
  measure: cnt_orders_with_delivery_eta_available {
    label: "# Orders with Delivery ETA available"
    description: "Count of Orders where a promised ETA is available"
    value_format_name: decimal_1
    sql: ${TABLE}.cnt_orders_with_delivery_eta_available ;;
    type: sum
    hidden: yes
  }
  measure: cnt_responses {
    label: "# NPS Responses"
    value_format_name: decimal_1
    sql: ${TABLE}.cnt_responses ;;
    type: sum
    hidden: yes
  }
  measure: cnt_detractors {
    label: "Cnt Detractors"
    value_format_name: decimal_1
    sql: ${TABLE}.cnt_detractors ;;
    type: sum
    hidden: yes
  }
  measure: cnt_passives {
    label: "Cnt Passives"
    value_format_name: decimal_1
    sql: ${TABLE}.cnt_passives ;;
    type: sum
    hidden: yes
  }
  measure: cnt_promoters {
    label: "Cnt Promoters"
    value_format_name: decimal_1
    sql: ${TABLE}.cnt_promoters ;;
    type: sum
    hidden: yes
  }
  measure: sum_orders_total {
    label: "Order Issues on Hub-Level # Total Orders"
    description: "The total number of orders"
    value_format_name: decimal_1
    sql: ${TABLE}.sum_orders_total ;;
    type: sum
    hidden: yes
  }
  measure: sum_orders_with_issues {
    label: "Order Issues on Hub-Level # Orders with Issues"
    description: "The sum of orders that have issues (the sum of: Wrong Product, Wrong Order, Perished Product, Missing Product and Damaged Product)"
    value_format_name: decimal_1
    sql: ${TABLE}.sum_orders_with_issues ;;
    type: sum
    hidden: yes
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #   PERCENTAGES
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  measure: pct_delivery_in_time{
    group_label: "Hub Leaderboard - Percentages"
    label: "% Orders delivered in time"
    description: "Share of orders delivered no later than promised ETA (only orders with valid ETA time considered)"
    hidden:  no
    type: number
    sql: ${cnt_orders_delayed_under_0_min} / NULLIF(${cnt_orders_with_delivery_eta_available}, 0);;
    value_format_name: percent_1
  }

  measure: pct_delivery_late_over_5_min{
    group_label: "Hub Leaderboard - Percentages"
    label: "% Orders delayed >5min"
    description: "Share of orders delivered >5min later than promised ETA (only orders with valid ETA time considered)"
    hidden:  no
    type: number
    sql: ${cnt_orders_delayed_over_5_min} / NULLIF(${cnt_orders_with_delivery_eta_available}, 0);;
    value_format: "0%"
  }

  measure: pct_detractors{
    group_label: "Hub Leaderboard - Percentages"
    label: "% Detractors"
    description: "Share of Detractors over total Responses"
    hidden:  no
    type: number
    sql: ${cnt_detractors} / NULLIF(${cnt_responses}, 0);;
    value_format: "0%"
  }
  measure: pct_passives{
    group_label: "Hub Leaderboard - Percentages"
    label: "% Passives"
    description: "Share of Passives over total Responses"
    hidden:  no
    type: number
    sql: ${cnt_passives} / NULLIF(${cnt_responses}, 0);;
    value_format: "0%"
  }
  measure: pct_promoters{
    group_label: "Hub Leaderboard - Percentages"
    label: "% Promoters"
    description: "Share of Promoters over total Responses"
    hidden:  no
    type: number
    sql: ${cnt_promoters} / NULLIF(${cnt_responses}, 0);;
    value_format: "0%"
  }
  measure: nps_score{
    group_label: "Hub Leaderboard - Percentages"
    label: "% NPS"
    description: "NPS Score (After Order)"
    hidden:  no
    type: number
    sql: ${pct_promoters} - ${pct_detractors};;
    value_format: "0%"
  }

  measure: pct_orders_with_issues {
    group_label: "Hub Leaderboard - Percentages"
    label: "% Issue Rate"
    description: "The number of orders that have issues (the sum of: Wrong Product, Wrong Order, Perished Product, Missing Product and Damaged Product) divided by the total number of orders."
    type: number
    sql: (1.0 * ${sum_orders_with_issues}) / NULLIF(${sum_orders_total}, 0) ;;
    value_format_name: percent_1
  }

  measure: pct_no_show {
    group_label: "Hub Leaderboard - Percentages"
    label: "% No Show Shift Hours"
    description: "The percentage of planned and filled shift hours with employees not showing up"
    type: number
    sql: (${sum_filled_no_show_rider_hours} + ${sum_filled_no_show_picker_hours}) / nullif((${sum_filled_picker_hours} + ${sum_filled_rider_hours}), 0) ;;
    value_format_name: percent_1
  }

  measure: pct_open_shifts {
    group_label: "Hub Leaderboard - Percentages"
    label: "% Open Shift Hours"
    description: "The percentage of planned shift hours, that could not be filled with employees"
    type: number
    sql: (${sum_unfilled_picker_hours} + ${sum_unfilled_rider_hours}) / nullif((${sum_planned_picker_hours} + ${sum_planned_rider_hours}) ,0) ;;
    value_format_name: percent_1
  }

  measure: pct_ext_shifts {
    group_label: "Hub Leaderboard - Percentages"
    label: "% External Shift Hours"
    description: "The percentage of actual shift hours, that were performed by external employees"
    type: number
    sql: (${sum_filled_ext_picker_hours} + ${sum_filled_ext_rider_hours}) / nullif((${sum_filled_picker_hours} + ${sum_filled_rider_hours}), 0) ;;
    value_format_name: percent_1
  }

  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  #   SCORING
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  measure: score_delivery_in_time {
    group_label: "Hub Leaderboard - Scores"
    label: "Score: Delivered in Time"
    sql: if(
            (2 * ${pct_delivery_in_time}*100 -100) < 0
            , 0
            , 2 * ${pct_delivery_in_time}*100 -100
            ) ;;
    type: number
    value_format_name: decimal_0
  }

  measure: score_delivery_late_over_5_min {
    group_label: "Hub Leaderboard - Scores"
    label: "Score: Delivered late over 5min"
    sql: if(
            ( -10 * ${pct_delivery_late_over_5_min}*100 +100) < 0
            , 0
            , -10 * ${pct_delivery_late_over_5_min}*100 +100
            );;
    type: number
    value_format_name: decimal_0
  }

  measure: score_nps_score {
    group_label: "Hub Leaderboard - Scores"
    label: "Score: NPS"
    sql: if(
            (50/17 * ${nps_score}*100 +(-3300/17)) < 0
            , 0
            , 50/17 * ${nps_score}*100 +(-3300/17)
            );;
    type: number
    value_format_name: decimal_0
  }

  measure: score_orders_with_issues {
    group_label: "Hub Leaderboard - Scores"
    label: "Score: Order Issues"
    sql: if(
            (-40 * ${pct_orders_with_issues}*100 +100) < 0
            , 0
            , -40 * ${pct_orders_with_issues}*100 +100
            );;
    type: number
    value_format_name: decimal_0
  }

  measure: score_no_show {
    group_label: "Hub Leaderboard - Scores"
    label: "Score: No Show Shift Hours"
    sql: if(
            (-5 * ${pct_no_show}*100 +100) < 0
            , 0
            , -5 * ${pct_no_show}*100 +100
            );;
    type: number
    value_format_name: decimal_0
  }

  measure: score_open_shifts {
    group_label: "Hub Leaderboard - Scores"
    label: "Score: Open Shift Hours"
    sql: if(
            (-5 * ${pct_open_shifts}*100 +100) < 0
            , 0
            , -5 * ${pct_open_shifts}*100 +100
            );;
    type: number
    value_format_name: decimal_0
  }

  measure: score_ext_shifts {
    group_label: "Hub Leaderboard - Scores"
    label: "Score: External Shift Hours"
    sql: if(
            (-5 * ${pct_ext_shifts}*100 +100) < 0
            , 0
            , -5 * ${pct_ext_shifts}*100 +100
            );;
    type: number
    value_format_name: decimal_0
  }

  measure: score_hub_leaderboard {
    group_label: "Hub Leaderboard - Scores"
    label: "Hub Leaderboard Score"
    sql: 0.20 * ${score_delivery_in_time} +
         0.10 * ${score_delivery_late_over_5_min} +
         0.15 * ${score_orders_with_issues} +
         0.25 * ${score_nps_score} +
         0.10 * ${score_ext_shifts} +
         0.10 * ${score_open_shifts} +
         0.10 * ${score_no_show}
        ;;
    type: number
    value_format_name: decimal_0
  }








}
