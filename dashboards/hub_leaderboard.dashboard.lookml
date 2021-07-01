- dashboard: hub_leaderboard
  title: Hub Leaderboard
  layout: newspaper
  preferred_viewer: dashboards-next
  refresh: 2147484 seconds
  elements:
  - title: Top 10 - Hub Score
    name: Top 10 - Hub Score
    model: flink_v3
    explore: hub_leaderboard_raw_order_order
    type: looker_bar
    fields: [hub_leaderboard.score_hub_leaderboard, hubs.hub_name]
    filters:
      hub_leaderboard_raw_order_order.is_internal_order: 'no'
      hub_leaderboard_raw_order_order.is_successful_order: 'yes'
      hubs.hub_code: ''
      hub_leaderboard_raw_order_order.created_date: after 2021/01/25
      hub_leaderboard.is_current_7d: 'Yes'
    sorts: [hub_leaderboard.score_hub_leaderboard desc]
    limit: 500
    query_timezone: Europe/Berlin
    x_axis_gridlines: false
    y_axis_gridlines: false
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: true
    legend_position: center
    point_style: circle
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    y_axes: [{label: '', orientation: bottom, series: [{axisId: hub_leaderboard.score_hub_leaderboard,
            id: hub_leaderboard.score_hub_leaderboard, name: Hub Leaderboard Score}],
        showLabels: false, showValues: false, unpinAxis: false, tickDensity: default,
        tickDensityCustom: 5, type: linear}]
    limit_displayed_rows_values:
      show_hide: show
      first_last: first
      num_rows: '10'
    series_types: {}
    series_colors:
      hub_leaderboard.score_hub_leaderboard: "#9eeaea"
    series_point_styles:
      hub_leaderboard.score_hub_leaderboard: triangle
    label_color: []
    column_spacing_ratio:
    column_group_spacing_ratio: 0.3
    defaults_version: 1
    hidden_fields: []
    listen:
      Country: hubs.country
      City: hubs.city
      Hub Name: hubs.hub_name
    row: 14
    col: 0
    width: 9
    height: 12
  - title: Overview KPI Scores
    name: Overview KPI Scores
    model: flink_v3
    explore: hub_leaderboard_raw_order_order
    type: looker_grid
    fields: [hubs.hub_name, hub_leaderboard.score_hub_leaderboard, hub_leaderboard.pct_delivery_in_time,
      hub_leaderboard.score_delivery_in_time, hub_leaderboard.pct_delivery_late_over_5_min,
      hub_leaderboard.score_delivery_late_over_5_min, hub_leaderboard.nps_score, hub_leaderboard.score_nps_score,
      hub_leaderboard.pct_orders_with_issues, hub_leaderboard.score_orders_with_issues,
      hub_leaderboard.pct_ext_shifts, hub_leaderboard.score_ext_shifts, hub_leaderboard.pct_no_show,
      hub_leaderboard.score_no_show, hub_leaderboard.pct_open_shifts, hub_leaderboard.score_open_shifts,
      hub_leaderboard.rider_utr, hub_leaderboard.score_rider_utr, hub_leaderboard.picker_utr,
      hub_leaderboard.score_picker_utr]
    filters:
      hub_leaderboard_raw_order_order.is_internal_order: 'no'
      hub_leaderboard_raw_order_order.is_successful_order: 'yes'
      hubs.hub_code: ''
      hub_leaderboard_raw_order_order.created_date: after 2021/01/25
      hub_leaderboard.is_current_7d: 'Yes'
    sorts: [hub_leaderboard.score_hub_leaderboard desc]
    limit: 500
    query_timezone: Europe/Berlin
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: false
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: unstyled
    limit_displayed_rows: false
    enable_conditional_formatting: true
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    series_column_widths:
      hub_leaderboard.score_hub_leaderboard: 177
      hubs.hub_name: 209
      hub_leaderboard.score_delivery_in_time: 88
      hub_leaderboard.pct_delivery_in_time: 91
      hub_leaderboard.score_delivery_late_over_5_min: 94
      hub_leaderboard.pct_delivery_late_over_5_min: 81
      hub_leaderboard.score_nps_score: 68
      hub_leaderboard.nps_score: 64
      hub_leaderboard.score_orders_with_issues: 81
      hub_leaderboard.pct_orders_with_issues: 71
      hub_leaderboard.score_ext_shifts: 90
      hub_leaderboard.pct_ext_shifts: 85
      hub_leaderboard.score_no_show: 79
      hub_leaderboard.pct_no_show: 79
      hub_leaderboard.score_open_shifts: 79
      hub_leaderboard.pct_open_shifts: 71
      hub_leaderboard.rider_utr: 72
      hub_leaderboard.score_rider_utr: 73
      hub_leaderboard.picker_utr: 75
      hub_leaderboard.score_picker_utr: 76
    series_cell_visualizations:
      hub_leaderboard.score_hub_leaderboard:
        is_active: true
      hub_leaderboard.score_delivery_in_time:
        is_active: false
        value_display: true
    limit_displayed_rows_values:
      show_hide: show
      first_last: last
      num_rows: '20'
    conditional_formatting: []
    x_axis_gridlines: false
    y_axis_gridlines: false
    y_axes: [{label: '', orientation: bottom, series: [{axisId: hub_leaderboard.score_hub_leaderboard,
            id: hub_leaderboard.score_hub_leaderboard, name: Hub Leaderboard Score}],
        showLabels: true, showValues: false, unpinAxis: false, tickDensity: default,
        tickDensityCustom: 5, type: linear}]
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    legend_position: center
    series_types: {}
    point_style: circle
    series_colors:
      hub_leaderboard.score_hub_leaderboard: "#f98662"
    series_point_styles:
      hub_leaderboard.score_hub_leaderboard: triangle
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    column_group_spacing_ratio: 0.8
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    hidden_fields: []
    listen:
      Country: hubs.country
      City: hubs.city
      Hub Name: hubs.hub_name
    row: 81
    col: 0
    width: 24
    height: 26
  - title: Top 10 - NPS Score
    name: Top 10 - NPS Score
    model: flink_v3
    explore: hub_leaderboard_raw_order_order
    type: looker_bar
    fields: [hubs.hub_name, hub_leaderboard.nps_score]
    filters:
      hub_leaderboard_raw_order_order.is_internal_order: 'no'
      hub_leaderboard_raw_order_order.is_successful_order: 'yes'
      hubs.hub_code: ''
      hub_leaderboard_raw_order_order.created_date: after 2021/01/25
      hub_leaderboard.is_current_7d: 'Yes'
    sorts: [hub_leaderboard.nps_score desc]
    limit: 500
    column_limit: 50
    query_timezone: Europe/Berlin
    x_axis_gridlines: false
    y_axis_gridlines: false
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: true
    legend_position: center
    point_style: circle
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    y_axes: [{label: '', orientation: bottom, series: [{axisId: hub_leaderboard.nps_score,
            id: hub_leaderboard.nps_score, name: "% NPS"}], showLabels: false, showValues: false,
        unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear}]
    limit_displayed_rows_values:
      show_hide: show
      first_last: first
      num_rows: '10'
    series_types: {}
    series_colors:
      hub_leaderboard.nps_score: "#C2DD67"
    series_point_styles:
      hub_leaderboard.score_hub_leaderboard: triangle
    column_group_spacing_ratio: 0.8
    defaults_version: 1
    hidden_fields: []
    listen:
      Country: hubs.country
      City: hubs.city
      Hub Name: hubs.hub_name
    row: 20
    col: 16
    width: 7
    height: 6
  - title: Top 10 - Issue Rate
    name: Top 10 - Issue Rate
    model: flink_v3
    explore: hub_leaderboard_raw_order_order
    type: looker_bar
    fields: [hubs.hub_name, hub_leaderboard.pct_orders_with_issues]
    filters:
      hub_leaderboard_raw_order_order.is_internal_order: 'no'
      hub_leaderboard_raw_order_order.is_successful_order: 'yes'
      hubs.hub_code: ''
      hub_leaderboard_raw_order_order.created_date: after 2021/01/25
      hub_leaderboard.is_current_7d: 'Yes'
    sorts: [hub_leaderboard.pct_orders_with_issues]
    limit: 500
    column_limit: 50
    query_timezone: Europe/Berlin
    x_axis_gridlines: false
    y_axis_gridlines: false
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: true
    legend_position: center
    point_style: circle
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    y_axes: [{label: '', orientation: bottom, series: [{axisId: hub_leaderboard.pct_orders_with_issues,
            id: hub_leaderboard.pct_orders_with_issues, name: "% Issue Rate"}], showLabels: false,
        showValues: false, unpinAxis: false, tickDensity: default, tickDensityCustom: 5,
        type: linear}]
    limit_displayed_rows_values:
      show_hide: show
      first_last: first
      num_rows: '10'
    series_types: {}
    series_colors:
      hub_leaderboard.pct_orders_with_issues: "#FBB555"
    series_point_styles:
      hub_leaderboard.score_hub_leaderboard: triangle
    column_group_spacing_ratio: 0.8
    defaults_version: 1
    hidden_fields: []
    listen:
      Country: hubs.country
      City: hubs.city
      Hub Name: hubs.hub_name
    row: 14
    col: 16
    width: 7
    height: 6
  - title: Top 10 - Delivered in Time
    name: Top 10 - Delivered in Time
    model: flink_v3
    explore: hub_leaderboard_raw_order_order
    type: looker_bar
    fields: [hubs.hub_name, hub_leaderboard.pct_delivery_in_time]
    filters:
      hub_leaderboard_raw_order_order.is_internal_order: 'no'
      hub_leaderboard_raw_order_order.is_successful_order: 'yes'
      hubs.hub_code: ''
      hub_leaderboard_raw_order_order.created_date: after 2021/01/25
      hub_leaderboard.is_current_7d: 'Yes'
    sorts: [hub_leaderboard.pct_delivery_in_time desc]
    limit: 500
    column_limit: 50
    query_timezone: Europe/Berlin
    x_axis_gridlines: false
    y_axis_gridlines: false
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: true
    legend_position: center
    point_style: circle
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    y_axes: [{label: '', orientation: bottom, series: [{axisId: hub_leaderboard.pct_delivery_in_time,
            id: hub_leaderboard.pct_delivery_in_time, name: "% Orders delivered in\
              \ time"}], showLabels: false, showValues: false, unpinAxis: false, tickDensity: default,
        tickDensityCustom: 5, type: linear}]
    limit_displayed_rows_values:
      show_hide: show
      first_last: first
      num_rows: '10'
    series_types: {}
    series_colors:
      hub_leaderboard.pct_delivery_in_time: "#72D16D"
    series_point_styles:
      hub_leaderboard.score_hub_leaderboard: triangle
    column_group_spacing_ratio: 0.8
    defaults_version: 1
    hidden_fields: []
    listen:
      Country: hubs.country
      City: hubs.city
      Hub Name: hubs.hub_name
    row: 14
    col: 9
    width: 7
    height: 6
  - title: Top 10 - Delivered 5 min late
    name: Top 10 - Delivered 5 min late
    model: flink_v3
    explore: hub_leaderboard_raw_order_order
    type: looker_bar
    fields: [hubs.hub_name, hub_leaderboard.pct_delivery_late_over_5_min]
    filters:
      hub_leaderboard_raw_order_order.is_internal_order: 'no'
      hub_leaderboard_raw_order_order.is_successful_order: 'yes'
      hubs.hub_code: ''
      hub_leaderboard_raw_order_order.created_date: after 2021/01/25
      hub_leaderboard.is_current_7d: 'Yes'
    sorts: [hub_leaderboard.pct_delivery_late_over_5_min]
    limit: 500
    column_limit: 50
    query_timezone: Europe/Berlin
    x_axis_gridlines: false
    y_axis_gridlines: false
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: true
    legend_position: center
    point_style: circle
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    y_axes: [{label: '', orientation: bottom, series: [{axisId: hub_leaderboard.pct_delivery_late_over_5_min,
            id: hub_leaderboard.pct_delivery_late_over_5_min, name: "% Orders delayed\
              \ >5min"}], showLabels: false, showValues: false, unpinAxis: false,
        tickDensity: default, tickDensityCustom: 5, type: linear}]
    limit_displayed_rows_values:
      show_hide: show
      first_last: first
      num_rows: '10'
    series_types: {}
    series_colors:
      hub_leaderboard.pct_delivery_late_over_5_min: "#604fc1"
    series_point_styles:
      hub_leaderboard.score_hub_leaderboard: triangle
    column_group_spacing_ratio: 0.8
    defaults_version: 1
    hidden_fields: []
    listen:
      Country: hubs.country
      City: hubs.city
      Hub Name: hubs.hub_name
    row: 20
    col: 9
    width: 7
    height: 6
  - name: Hub Leaderboard Scoring - How it works
    type: text
    title_text: Hub Leaderboard Scoring - How it works
    body_text: "### Step 1  - Define the KPIs\nThe following KPIs are used to calculate\
      \ the hub_score:\n\n| KPI        | | Definition           | \n|:-------------\
      \ |-------------:||:-------------|\n| % Orders delivered in time    |  | How\
      \ many of all delivered orders were <= estimated delivery time | \n| % Orders\
      \ delayed > 5min   |  | How many of all orders were delivered <= 5min later\
      \ then the estimated delivery time | \n| NPS Score   |  | Customer satisfaction\
      \ measure | \n| % Issue Rate   |  | How many of all delivered orders have issues\
      \ such as damaged, perished, missing or wrong products | \n| % External Shift\
      \ Hours   |  | Based on the actual (assigned) shift-hours, how many of those\
      \ were performed though externals (from e.g. Zenjobs) | \n| % No Show Shift\
      \ Hours   |  | Based on the actual (assigned) shift-hours, how many of those\
      \ assigned hours were not started (based on no shows) | \n| % Open Shift Hours\
      \   |  | Based on the planned shift hours (in Shyftplan), how many could be\
      \ filled. | \n| AVG Rider UTR   |  | The average rider utilization-rate - interpret\
      \ as: how many orders are delivered per hour per one rider | \n| AVG Picker\
      \ UTR   |  | The average picker utilization-rate - interpret as: how many orders\
      \ are packed per hour per one picker | \n\n### Step 2  - Define the related\
      \ Scores\nBased on the defined 7 KPIs, a mapping is performed to calculate the\
      \ 7 scores. The mapping was defined by the leadership team in *[this Google-Sheet](https://docs.google.com/spreadsheets/d/1TcwF45hQkJ6wFj4peXKXogdM2cozvEEw4omwi-nL_MY/edit#gid=2029101973)*.\n\
      \n### Step 3  - Define the final Hub-Score\nBased on the 7 scores (e.g. Score\
      \ NPS, Score Delivered in time etc.) a final weighted KPI is calculated. The\
      \ rule is:\n\n**Hub-Score =** \n\n-         20% * Score Delivered in Time\n\
      - \\+ 10% * Score Delivered late <5min\n- \\+ 25% * Score NPS Score\n- \\+ 22%\
      \ * Score Order Issues\n- \\+ 10% * AVG Rider UTR\n- \\+ 10% * AVG Picker UTR\n\
      - \\+ 1% * Score External Shift Hours\n- \\+ 1% * Score No Show Shift Hours\n\
      - \\+ 1% * Score Open Shift Hours\n\n**Reference:** see ticket [DATA-362](https://goflink.atlassian.net/browse/DATA-362)\
      \ and [DATA-508](https://goflink.atlassian.net/browse/DATA-508)"
    row: 0
    col: 0
    width: 24
    height: 12
  - name: Detailed Views
    type: text
    title_text: Detailed Views
    body_text: ''
    row: 53
    col: 0
    width: 24
    height: 2
  - title: Overview of Hub KPIs
    name: Overview of Hub KPIs
    model: flink_v3
    explore: hub_leaderboard_raw_order_order
    type: looker_grid
    fields: [hubs.hub_name, hub_leaderboard.score_hub_leaderboard, hub_leaderboard.pct_delivery_in_time,
      hub_leaderboard_raw_order_order.cnt_orders_delayed_under_0_min, hub_leaderboard.pct_delivery_late_over_5_min,
      hub_leaderboard_raw_order_order.cnt_orders_delayed_over_5_min, hub_leaderboard.nps_score,
      nps_after_order.cnt_responses, hub_leaderboard.pct_orders_with_issues, issue_rate_hub_level.sum_orders_with_issues,
      hub_leaderboard.pct_ext_shifts, hub_leaderboard_shift_metrics.sum_filled_ext_hours_total,
      hub_leaderboard.pct_no_show, hub_leaderboard_shift_metrics.sum_filled_no_show_hours_total,
      hub_leaderboard.pct_open_shifts, hub_leaderboard_shift_metrics.sum_unfilled_hours_total,
      hub_leaderboard.rider_utr, hub_leaderboard.picker_utr]
    filters:
      hub_leaderboard_raw_order_order.is_internal_order: 'no'
      hub_leaderboard_raw_order_order.is_successful_order: 'yes'
      hubs.hub_code: ''
      hub_leaderboard_raw_order_order.created_date: after 2021/01/25
      hub_leaderboard.is_current_7d: 'Yes'
    sorts: [hub_leaderboard.score_hub_leaderboard desc]
    limit: 500
    column_limit: 50
    query_timezone: Europe/Berlin
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: false
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: true
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    color_application:
      collection_id: legacy
      palette_id: looker_classic
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    series_labels:
      hub_leaderboard_raw_order_order.cnt_orders_delayed_over_5_min: "#"
      hub_leaderboard_raw_order_order.cnt_orders_delayed_under_0_min: "#"
      nps_after_order.cnt_responses: "#"
      issue_rate_hub_level.sum_orders_with_issues: "#"
      hub_leaderboard_shift_metrics.sum_unfilled_hours_total: "#"
      hub_leaderboard_shift_metrics.sum_filled_no_show_hours_total: "#"
      hub_leaderboard_shift_metrics.sum_filled_ext_hours_total: "#"
    series_column_widths:
      hub_leaderboard.score_hub_leaderboard: 177
      hubs.hub_name: 209
      hub_leaderboard.score_delivery_in_time: 88
      hub_leaderboard.pct_delivery_in_time: 91
      hub_leaderboard.score_delivery_late_over_5_min: 94
      hub_leaderboard.pct_delivery_late_over_5_min: 81
      hub_leaderboard.score_nps_score: 68
      hub_leaderboard.nps_score: 64
      hub_leaderboard.score_orders_with_issues: 81
      hub_leaderboard.pct_orders_with_issues: 71
      hub_leaderboard.score_ext_shifts: 90
      hub_leaderboard.pct_ext_shifts: 85
      hub_leaderboard.score_no_show: 79
      hub_leaderboard.pct_no_show: 79
      hub_leaderboard.score_open_shifts: 79
      hub_leaderboard.pct_open_shifts: 71
      hub_leaderboard.rider_utr: 69
      hub_leaderboard.picker_utr: 74
    series_cell_visualizations:
      hub_leaderboard.score_hub_leaderboard:
        is_active: true
      hub_leaderboard.score_delivery_in_time:
        is_active: false
        value_display: true
      hub_leaderboard_raw_order_order.cnt_orders_delayed_over_5_min:
        is_active: false
        value_display: true
      hub_leaderboard_raw_order_order.cnt_orders_delayed_under_0_min:
        is_active: false
        palette:
          palette_id: bc71f0c1-02f1-6bcf-d454-eed5ad70fef7
          collection_id: legacy
          custom_colors:
          - "#D5D8DC"
          - "#4FBC89"
        value_display: false
    series_text_format:
      hub_leaderboard_raw_order_order.cnt_orders_delayed_under_0_min:
        align: left
        fg_color: "#929292"
        bg_color: "#e7e7e7"
      hub_leaderboard_raw_order_order.cnt_orders_delayed_over_5_min:
        align: left
        fg_color: "#929292"
        bg_color: "#e7e7e7"
      nps_after_order.cnt_responses:
        align: left
        fg_color: "#929292"
        bg_color: "#e7e7e7"
      issue_rate_hub_level.sum_orders_with_issues:
        align: left
        fg_color: "#929292"
        bg_color: "#e7e7e7"
      hub_leaderboard_shift_metrics.sum_unfilled_hours_total:
        fg_color: "#929292"
        bg_color: "#e7e7e7"
        align: left
      hub_leaderboard_shift_metrics.sum_filled_no_show_hours_total:
        fg_color: "#929292"
        bg_color: "#e7e7e7"
        align: left
      hub_leaderboard_shift_metrics.sum_filled_ext_hours_total:
        fg_color: "#929292"
        bg_color: "#e7e7e7"
        align: left
    limit_displayed_rows_values:
      show_hide: show
      first_last: last
      num_rows: '20'
    conditional_formatting: [{type: along a scale..., value: !!null '', background_color: "#62bad4",
        font_color: !!null '', color_application: {collection_id: legacy, custom: {
            id: 583268c0-f3ec-08ec-3c27-0d2f1d4ccba5, label: Custom, type: continuous,
            stops: [{color: "#F5B7B1", offset: 0}, {color: "#ffffff", offset: 50},
              {color: "#82E0AA", offset: 100}]}, options: {steps: 5, constraints: {
              min: {type: number, value: 0.4}, mid: {type: median}, max: {type: number,
                value: 1}}, mirror: false, reverse: false, stepped: false}}, bold: false,
        italic: false, strikethrough: false, fields: [hub_leaderboard.nps_score, hub_leaderboard.pct_delivery_in_time]},
      {type: along a scale..., value: !!null '', background_color: !!null '', font_color: !!null '',
        color_application: {collection_id: legacy, custom: {id: 03b793df-9f87-1427-53c4-ed9fd83b4828,
            label: Custom, type: continuous, stops: [{color: "#82E0AA", offset: 0},
              {color: "#ffffff", offset: 50}, {color: "#F5B7B1", offset: 100}]}, options: {
            steps: 5, constraints: {min: {type: number, value: 0}, max: {type: number,
                value: 0.1}, mid: {type: middle}}}}, bold: false, italic: false, strikethrough: false,
        fields: [hub_leaderboard.pct_delivery_late_over_5_min, hub_leaderboard.pct_ext_shifts,
          hub_leaderboard.pct_no_show, hub_leaderboard.pct_open_shifts]}, {type: along
          a scale..., value: !!null '', background_color: !!null '', font_color: !!null '',
        color_application: {collection_id: legacy, custom: {id: ae15939c-7c1d-0732-4379-eb2273737a98,
            label: Custom, type: continuous, stops: [{color: "#82E0AA", offset: 0},
              {color: "#ffffff", offset: 50}, {color: "#F5B7B1", offset: 100}]}, options: {
            steps: 5, constraints: {max: {type: number, value: 0.03}, min: {type: number,
                value: 0}}}}, bold: false, italic: false, strikethrough: false, fields: [
          hub_leaderboard.pct_orders_with_issues]}, {type: along a scale..., value: !!null '',
        background_color: !!null '', font_color: !!null '', color_application: {collection_id: legacy,
          custom: {id: d86f9dc3-53ee-b02d-c111-149535c7dd4e, label: Custom, type: continuous,
            stops: [{color: "#F5B7B1", offset: 0}, {color: "#ffffff", offset: 50},
              {color: "#82E0AA", offset: 100}]}, options: {steps: 5, constraints: {
              min: {type: number, value: 1}, max: {type: number, value: 3}}}}, bold: false,
        italic: false, strikethrough: false, fields: [hub_leaderboard.rider_utr]},
      {type: along a scale..., value: !!null '', background_color: !!null '', font_color: !!null '',
        color_application: {collection_id: legacy, custom: {id: '0349f44b-d243-c994-77a9-654d2c92ab12',
            label: Custom, type: continuous, stops: [{color: "#F5B7B1", offset: 0},
              {color: "#ffffff", offset: 50}, {color: "#82E0AA", offset: 100}]}, options: {
            steps: 5, constraints: {min: {type: number, value: 5}, max: {type: number,
                value: 15}}}}, bold: false, italic: false, strikethrough: false, fields: [
          hub_leaderboard.picker_utr]}]
    x_axis_gridlines: false
    y_axis_gridlines: false
    y_axes: [{label: '', orientation: bottom, series: [{axisId: hub_leaderboard.score_hub_leaderboard,
            id: hub_leaderboard.score_hub_leaderboard, name: Hub Leaderboard Score}],
        showLabels: true, showValues: false, unpinAxis: false, tickDensity: default,
        tickDensityCustom: 5, type: linear}]
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    legend_position: center
    series_types: {}
    point_style: circle
    series_colors:
      hub_leaderboard.score_hub_leaderboard: "#f98662"
    series_point_styles:
      hub_leaderboard.score_hub_leaderboard: triangle
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    column_group_spacing_ratio: 0.8
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    hidden_fields: []
    column_order: ["$$$_row_numbers_$$$", hubs.hub_name, hub_leaderboard.score_hub_leaderboard,
      hub_leaderboard.pct_delivery_in_time, hub_leaderboard_raw_order_order.cnt_orders_delayed_under_0_min,
      hub_leaderboard.pct_delivery_late_over_5_min, hub_leaderboard_raw_order_order.cnt_orders_delayed_over_5_min,
      hub_leaderboard.nps_score, nps_after_order.cnt_responses, hub_leaderboard.pct_orders_with_issues,
      issue_rate_hub_level.sum_orders_with_issues, hub_leaderboard.rider_utr, hub_leaderboard.picker_utr,
      hub_leaderboard.pct_ext_shifts, hub_leaderboard_shift_metrics.sum_filled_ext_hours_total,
      hub_leaderboard.pct_no_show, hub_leaderboard_shift_metrics.sum_filled_no_show_hours_total,
      hub_leaderboard.pct_open_shifts, hub_leaderboard_shift_metrics.sum_unfilled_hours_total]
    listen:
      Country: hubs.country
      City: hubs.city
      Hub Name: hubs.hub_name
    row: 55
    col: 0
    width: 24
    height: 26
  - name: Top 10 Hubs
    type: text
    title_text: Top 10 Hubs
    body_text: ''
    row: 12
    col: 0
    width: 23
    height: 2
  - title: Bottom 10 - Hub Score
    name: Bottom 10 - Hub Score
    model: flink_v3
    explore: hub_leaderboard_raw_order_order
    type: looker_bar
    fields: [hub_leaderboard.score_hub_leaderboard, hubs.hub_name]
    filters:
      hubs.hub_code: ''
      hub_leaderboard.is_current_7d: 'Yes'
      hub_leaderboard_raw_order_order.is_internal_order: 'no'
      hub_leaderboard_raw_order_order.is_successful_order: 'yes'
      hub_leaderboard_raw_order_order.created_date: after 2021/01/25
    sorts: [hub_leaderboard.score_hub_leaderboard]
    limit: 500
    column_limit: 50
    query_timezone: Europe/Berlin
    x_axis_gridlines: false
    y_axis_gridlines: false
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: true
    legend_position: center
    point_style: circle
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    y_axes: [{label: '', orientation: bottom, series: [{axisId: hub_leaderboard.score_hub_leaderboard,
            id: hub_leaderboard.score_hub_leaderboard, name: Hub Leaderboard Score}],
        showLabels: false, showValues: false, unpinAxis: false, tickDensity: default,
        tickDensityCustom: 5, type: linear}]
    limit_displayed_rows_values:
      show_hide: show
      first_last: first
      num_rows: '10'
    series_types: {}
    series_colors:
      hub_leaderboard.score_hub_leaderboard: "#9eeaea"
    series_point_styles:
      hub_leaderboard.score_hub_leaderboard: triangle
    label_color: []
    column_spacing_ratio:
    column_group_spacing_ratio: 0.3
    defaults_version: 1
    hidden_fields: []
    listen:
      Country: hubs.country
      City: hubs.city
      Hub Name: hubs.hub_name
    row: 34
    col: 0
    width: 9
    height: 12
  - title: Bottom 10 - Delivered in Time
    name: Bottom 10 - Delivered in Time
    model: flink_v3
    explore: hub_leaderboard_raw_order_order
    type: looker_bar
    fields: [hubs.hub_name, hub_leaderboard.pct_delivery_in_time]
    filters:
      hubs.hub_code: ''
      hub_leaderboard.is_current_7d: 'Yes'
      hub_leaderboard_raw_order_order.is_internal_order: 'no'
      hub_leaderboard_raw_order_order.is_successful_order: 'yes'
      hub_leaderboard_raw_order_order.created_date: after 2021/01/25
    sorts: [hub_leaderboard.pct_delivery_in_time]
    limit: 500
    column_limit: 50
    query_timezone: Europe/Berlin
    x_axis_gridlines: false
    y_axis_gridlines: false
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: true
    legend_position: center
    point_style: circle
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    y_axes: [{label: '', orientation: bottom, series: [{axisId: hub_leaderboard.pct_delivery_in_time,
            id: hub_leaderboard.pct_delivery_in_time, name: "% Orders delivered in\
              \ time"}], showLabels: false, showValues: false, unpinAxis: false, tickDensity: default,
        tickDensityCustom: 5, type: linear}]
    limit_displayed_rows_values:
      show_hide: show
      first_last: first
      num_rows: '10'
    series_types: {}
    series_colors:
      hub_leaderboard.pct_delivery_in_time: "#72D16D"
    series_point_styles:
      hub_leaderboard.score_hub_leaderboard: triangle
    column_group_spacing_ratio: 0.8
    defaults_version: 1
    hidden_fields: []
    listen:
      Country: hubs.country
      City: hubs.city
      Hub Name: hubs.hub_name
    row: 34
    col: 9
    width: 7
    height: 6
  - title: Bottom 10 - Issue Rate
    name: Bottom 10 - Issue Rate
    model: flink_v3
    explore: hub_leaderboard_raw_order_order
    type: looker_bar
    fields: [hubs.hub_name, hub_leaderboard.pct_orders_with_issues]
    filters:
      hubs.hub_code: ''
      hub_leaderboard.is_current_7d: 'Yes'
      hub_leaderboard_raw_order_order.is_internal_order: 'no'
      hub_leaderboard_raw_order_order.is_successful_order: 'yes'
      hub_leaderboard_raw_order_order.created_date: after 2021/01/25
    sorts: [hub_leaderboard.pct_orders_with_issues desc]
    limit: 500
    column_limit: 50
    query_timezone: Europe/Berlin
    x_axis_gridlines: false
    y_axis_gridlines: false
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: true
    legend_position: center
    point_style: circle
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    y_axes: [{label: '', orientation: bottom, series: [{axisId: hub_leaderboard.pct_orders_with_issues,
            id: hub_leaderboard.pct_orders_with_issues, name: "% Issue Rate"}], showLabels: false,
        showValues: false, unpinAxis: false, tickDensity: default, tickDensityCustom: 5,
        type: linear}]
    limit_displayed_rows_values:
      show_hide: show
      first_last: first
      num_rows: '10'
    series_types: {}
    series_colors:
      hub_leaderboard.pct_orders_with_issues: "#FBB555"
    series_point_styles:
      hub_leaderboard.score_hub_leaderboard: triangle
    column_group_spacing_ratio: 0.8
    defaults_version: 1
    hidden_fields: []
    listen:
      Country: hubs.country
      City: hubs.city
      Hub Name: hubs.hub_name
    row: 34
    col: 16
    width: 7
    height: 6
  - title: Bottom 10 - Delivered 5 min late
    name: Bottom 10 - Delivered 5 min late
    model: flink_v3
    explore: hub_leaderboard_raw_order_order
    type: looker_bar
    fields: [hubs.hub_name, hub_leaderboard.pct_delivery_late_over_5_min]
    filters:
      hubs.hub_code: ''
      hub_leaderboard.is_current_7d: 'Yes'
      hub_leaderboard_raw_order_order.is_internal_order: 'no'
      hub_leaderboard_raw_order_order.is_successful_order: 'yes'
      hub_leaderboard_raw_order_order.created_date: after 2021/01/25
    sorts: [hub_leaderboard.pct_delivery_late_over_5_min desc]
    limit: 500
    column_limit: 50
    query_timezone: Europe/Berlin
    x_axis_gridlines: false
    y_axis_gridlines: false
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: true
    legend_position: center
    point_style: circle
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    y_axes: [{label: '', orientation: bottom, series: [{axisId: hub_leaderboard.pct_delivery_late_over_5_min,
            id: hub_leaderboard.pct_delivery_late_over_5_min, name: "% Orders delayed\
              \ >5min"}], showLabels: false, showValues: false, unpinAxis: false,
        tickDensity: default, tickDensityCustom: 5, type: linear}]
    limit_displayed_rows_values:
      show_hide: show
      first_last: first
      num_rows: '10'
    series_types: {}
    series_colors:
      hub_leaderboard.pct_delivery_late_over_5_min: "#604fc1"
    series_point_styles:
      hub_leaderboard.score_hub_leaderboard: triangle
    column_group_spacing_ratio: 0.8
    defaults_version: 1
    hidden_fields: []
    listen:
      Country: hubs.country
      City: hubs.city
      Hub Name: hubs.hub_name
    row: 40
    col: 9
    width: 7
    height: 6
  - title: Bottom 10 - NPS Score
    name: Bottom 10 - NPS Score
    model: flink_v3
    explore: hub_leaderboard_raw_order_order
    type: looker_bar
    fields: [hubs.hub_name, hub_leaderboard.nps_score]
    filters:
      hubs.hub_code: ''
      hub_leaderboard.is_current_7d: 'Yes'
      hub_leaderboard_raw_order_order.is_internal_order: 'no'
      hub_leaderboard_raw_order_order.is_successful_order: 'yes'
      hub_leaderboard_raw_order_order.created_date: after 2021/01/25
    sorts: [hub_leaderboard.nps_score]
    limit: 500
    column_limit: 50
    query_timezone: Europe/Berlin
    x_axis_gridlines: false
    y_axis_gridlines: false
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: true
    legend_position: center
    point_style: circle
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    y_axes: [{label: '', orientation: bottom, series: [{axisId: hub_leaderboard.nps_score,
            id: hub_leaderboard.nps_score, name: "% NPS"}], showLabels: false, showValues: false,
        unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear}]
    limit_displayed_rows_values:
      show_hide: show
      first_last: first
      num_rows: '10'
    series_types: {}
    series_colors:
      hub_leaderboard.nps_score: "#C2DD67"
    series_point_styles:
      hub_leaderboard.score_hub_leaderboard: triangle
    column_group_spacing_ratio: 0.8
    defaults_version: 1
    hidden_fields: []
    listen:
      Country: hubs.country
      City: hubs.city
      Hub Name: hubs.hub_name
    row: 40
    col: 16
    width: 7
    height: 6
  - name: Bottom 10 Hubs
    type: text
    title_text: Bottom 10 Hubs
    body_text: ''
    row: 32
    col: 0
    width: 24
    height: 2
  - title: New Top 10 - Hub Score
    name: New Top 10 - Hub Score
    model: flink_v3
    explore: hub_leaderboard_raw_order_order
    type: looker_grid
    fields: [hubs.hub_name, hub_leaderboard_current.score_hub_leaderboard, hub_leaderboard_previous.score_hub_leaderboard]
    filters:
      hub_leaderboard_raw_order_order.is_internal_order: 'no'
      hub_leaderboard_raw_order_order.is_successful_order: 'yes'
      hub_leaderboard_raw_order_order.created_date: after 2021/01/25
    sorts: [hub_leaderboard_current.score_hub_leaderboard desc]
    limit: 500
    dynamic_fields: [{_kind_hint: measure, table_calculation: wow, _type_hint: number,
        category: table_calculation, expression: "(${hub_leaderboard_current.score_hub_leaderboard}\
          \ - ${hub_leaderboard_previous.score_hub_leaderboard})\n/\nif(\n  ${hub_leaderboard_previous.score_hub_leaderboard}\
          \ = 0,\n  null,\n  ${hub_leaderboard_previous.score_hub_leaderboard}\n \
          \ \n)", label: "% WoW", value_format: !!null '', value_format_name: percent_0}]
    query_timezone: Europe/Berlin
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: true
    enable_conditional_formatting: true
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    column_order: ["$$$_row_numbers_$$$", hubs.hub_name, wow, hub_leaderboard_current.score_hub_leaderboard]
    show_totals: true
    show_row_totals: true
    series_column_widths:
      wow: 75
      hubs.hub_name: 233.02999999999997
    series_cell_visualizations:
      hub_leaderboard_current.score_hub_leaderboard:
        is_active: true
        palette:
          palette_id: a5fba563-811c-760e-b936-553b776dd69e
          collection_id: product-custom-collection
          custom_colors:
          - "#ffffff"
          - "#3EB0D5"
          - "#36b4bf"
    limit_displayed_rows_values:
      show_hide: show
      first_last: first
      num_rows: '10'
    conditional_formatting: [{type: along a scale..., value: !!null '', background_color: "#3EB0D5",
        font_color: !!null '', color_application: {collection_id: product-custom-collection,
          custom: {id: ae1e6af9-c562-55aa-6c94-ca0fb8521c23, label: Custom, type: continuous,
            stops: [{color: "#E74C3C", offset: 0}, {color: "#FADBD8", offset: 25},
              {color: "#ffffff", offset: 50}, {color: "#D5F5E3", offset: 75}, {color: "#2ECC71",
                offset: 100}]}, options: {steps: 5, constraints: {min: {type: minimum},
              mid: {type: number, value: 0}, max: {type: maximum}}, mirror: true,
            reverse: false, stepped: false}}, bold: false, italic: false, strikethrough: false,
        fields: [wow]}]
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    hidden_fields: [hub_leaderboard_previous.score_hub_leaderboard]
    series_types: {}
    listen:
      Country: hubs.country
      City: hubs.city
      Hub Name: hubs.hub_name
    row: 26
    col: 0
    width: 8
    height: 6
  - title: New Bottom 10 - Hub Score
    name: New Bottom 10 - Hub Score
    model: flink_v3
    explore: hub_leaderboard_raw_order_order
    type: looker_grid
    fields: [hubs.hub_name, hub_leaderboard_current.score_hub_leaderboard, hub_leaderboard_previous.score_hub_leaderboard]
    filters:
      hub_leaderboard_raw_order_order.is_internal_order: 'no'
      hub_leaderboard_raw_order_order.is_successful_order: 'yes'
      hub_leaderboard_raw_order_order.created_date: after 2021/01/25
    sorts: [hub_leaderboard_current.score_hub_leaderboard]
    limit: 500
    dynamic_fields: [{_kind_hint: measure, table_calculation: wow, _type_hint: number,
        category: table_calculation, expression: "(${hub_leaderboard_current.score_hub_leaderboard}\
          \ - ${hub_leaderboard_previous.score_hub_leaderboard})\n/\nif(\n  ${hub_leaderboard_previous.score_hub_leaderboard}\
          \ = 0,\n  null,\n  ${hub_leaderboard_previous.score_hub_leaderboard}\n \
          \ \n)", label: "% WoW", value_format: !!null '', value_format_name: percent_0}]
    query_timezone: Europe/Berlin
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: true
    enable_conditional_formatting: true
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    column_order: ["$$$_row_numbers_$$$", hubs.hub_name, wow, hub_leaderboard_current.score_hub_leaderboard]
    show_totals: true
    show_row_totals: true
    series_column_widths:
      wow: 75
      hubs.hub_name: 233.02999999999997
    series_cell_visualizations:
      hub_leaderboard_current.score_hub_leaderboard:
        is_active: true
        palette:
          palette_id: a5fba563-811c-760e-b936-553b776dd69e
          collection_id: product-custom-collection
          custom_colors:
          - "#ffffff"
          - "#3EB0D5"
          - "#36b4bf"
    limit_displayed_rows_values:
      show_hide: show
      first_last: first
      num_rows: '10'
    conditional_formatting: [{type: along a scale..., value: !!null '', background_color: "#3EB0D5",
        font_color: !!null '', color_application: {collection_id: product-custom-collection,
          custom: {id: ae1e6af9-c562-55aa-6c94-ca0fb8521c23, label: Custom, type: continuous,
            stops: [{color: "#E74C3C", offset: 0}, {color: "#FADBD8", offset: 25},
              {color: "#ffffff", offset: 50}, {color: "#D5F5E3", offset: 75}, {color: "#2ECC71",
                offset: 100}]}, options: {steps: 5, constraints: {min: {type: minimum},
              mid: {type: number, value: 0}, max: {type: maximum}}, mirror: true,
            reverse: false, stepped: false}}, bold: false, italic: false, strikethrough: false,
        fields: [wow]}]
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    hidden_fields: [hub_leaderboard_previous.score_hub_leaderboard]
    series_types: {}
    listen:
      Country: hubs.country
      City: hubs.city
      Hub Name: hubs.hub_name
    row: 46
    col: 0
    width: 9
    height: 7
  filters:
  - name: Country
    title: Country
    type: field_filter
    default_value: Germany
    allow_multiple_values: true
    required: false
    ui_config:
      type: button_group
      display: inline
      options: []
    model: flink_v3
    explore: hub_leaderboard_raw_order_order
    listens_to_filters: []
    field: hubs.country
  - name: City
    title: City
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: popover
      options: []
    model: flink_v3
    explore: hub_leaderboard_raw_order_order
    listens_to_filters: []
    field: hubs.city
  - name: Hub Name
    title: Hub Name
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: popover
      options: []
    model: flink_v3
    explore: hub_leaderboard_raw_order_order
    listens_to_filters: []
    field: hubs.hub_name
