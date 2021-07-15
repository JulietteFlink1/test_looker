
view: hub_leaderboard_shift_metrics {
  derived_table: {
    # datagroup_trigger: flink_default_datagroup
    # persist_for: "24 hours"

    explore_source: riders_forecast_staffing {
      # dimensions
      column: hub_code_lowercase { field: hubs.hub_code_lowercase }
      column: date               { field: riders_forecast_staffing.date}
      # measures
      column: sum_filled_ext_picker_hours     { field: riders_forecast_staffing.sum_filled_ext_picker_hours}
      column: sum_filled_ext_rider_hours      { field: riders_forecast_staffing.sum_filled_ext_rider_hours}
      column: sum_unfilled_rider_hours        { field: riders_forecast_staffing.sum_unfilled_rider_hours}
      column: sum_unfilled_picker_hours       { field: riders_forecast_staffing.sum_unfilled_picker_hours}
      column: sum_filled_no_show_picker_hours { field: riders_forecast_staffing.sum_filled_no_show_picker_hours}
      column: sum_filled_no_show_rider_hours  { field: riders_forecast_staffing.sum_filled_no_show_rider_hours}
      column: sum_filled_picker_hours         { field: riders_forecast_staffing.sum_filled_picker_hours}
      column: sum_planned_picker_hours        { field: riders_forecast_staffing.sum_planned_picker_hours}
      column: sum_filled_rider_hours          { field: riders_forecast_staffing.sum_filled_rider_hours}
      column: sum_planned_rider_hours         { field: riders_forecast_staffing.sum_planned_rider_hours}
    }
  }

  dimension: hub_code_lowercase {
    type: string
    hidden: yes
  }
  dimension: date {
    label: "Date"
    type: date
    hidden: yes
  }
  dimension: unique_id {
    primary_key: yes
    hidden: yes
    type: string
    sql: concat( CAST(${date} as string), ${hub_code_lowercase})  ;;
  }


  measure: sum_filled_ext_picker_hours {
    label: "Hours: Filled Ext. Picker"
    group_label: "Hub Leaderboard - Shift Metrics"
    sql: ${TABLE}.sum_filled_ext_picker_hours ;;
    value_format_name: decimal_1
    type: sum
  }
  measure: sum_filled_ext_rider_hours {
    label: "Hours: Filled Ext. Rider"
    group_label: "Hub Leaderboard - Shift Metrics"
    sql: ${TABLE}.sum_filled_ext_rider_hours ;;
    value_format_name: decimal_1
    type: sum
  }
  measure: sum_filled_ext_hours_total {
    label: "Hours: Filled Ext. Total"
    group_label: "Hub Leaderboard - Shift Metrics"
    value_format_name: decimal_1
    type: number
    sql: ${sum_filled_ext_picker_hours} + ${sum_filled_ext_rider_hours} ;;
  }

  measure: sum_unfilled_rider_hours {
    label: "Hours: Unfilled Rider"
    group_label: "Hub Leaderboard - Shift Metrics"
    sql: ${TABLE}.sum_unfilled_rider_hours ;;
    value_format_name: decimal_1
    type: sum
  }
  measure: sum_unfilled_picker_hours {
    label: "Hours: Unfilled Picker"
    group_label: "Hub Leaderboard - Shift Metrics"
    sql: ${TABLE}.sum_unfilled_picker_hours ;;
    value_format_name: decimal_1
    type: sum
  }
  measure: sum_unfilled_hours_total {
    label: "Hours: Unfilled Total"
    group_label: "Hub Leaderboard - Shift Metrics"
    type: number
    value_format_name: decimal_1
    sql: ${sum_unfilled_picker_hours} + ${sum_unfilled_rider_hours} ;;

  }
  measure: sum_filled_no_show_picker_hours {
    label: "Hours: No Show Picker"
    group_label: "Hub Leaderboard - Shift Metrics"
    sql: ${TABLE}.sum_filled_no_show_picker_hours ;;
    value_format_name: decimal_1
    type: sum
  }
  measure: sum_filled_no_show_rider_hours {
    label: "Hours: No Show Rider"
    group_label: "Hub Leaderboard - Shift Metrics"
    sql: ${TABLE}.sum_filled_no_show_rider_hours ;;
    value_format_name: decimal_1
    type: sum
  }
  measure: sum_filled_no_show_hours_total {
    label: "Hours: No Show Total"
    group_label: "Hub Leaderboard - Shift Metrics"
    value_format_name: decimal_1
    type: number
    sql: ${sum_filled_no_show_picker_hours} + ${sum_filled_no_show_rider_hours} ;;
  }

  measure: sum_filled_picker_hours {
    label: "Hours: Filled Picker"
    group_label: "Hub Leaderboard - Shift Metrics"
    sql: ${TABLE}.sum_filled_picker_hours ;;
    value_format_name: decimal_1
    type: sum
  }
  measure: sum_planned_picker_hours {
    label: "Hours: Planned Picker"
    group_label: "Hub Leaderboard - Shift Metrics"
    sql: ${TABLE}.sum_planned_picker_hours ;;
    value_format_name: decimal_1
    type: sum
  }
  measure: sum_filled_rider_hours {
    label: "Hours: Filled Rider"
    group_label: "Hub Leaderboard - Shift Metrics"
    sql: ${TABLE}.sum_filled_rider_hours ;;
    value_format_name: decimal_1
    type: sum
  }
  measure: sum_planned_rider_hours {
    label: "Hours: Planned Rider"
    group_label: "Hub Leaderboard - Shift Metrics"
    sql: ${TABLE}.sum_planned_rider_hours ;;
    value_format_name: decimal_1
    type: sum
  }
}
