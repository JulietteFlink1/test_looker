- dashboard: historic_staffing_evaluation_lookml_test
  title: Historic Staffing Evaluation
  layout: newspaper
  preferred_viewer: dashboards-next
  elements:
  - name: Historic Staffing Evaluation
    title: Historic Staffing Evaluation
    model: flink_v3
    explore: rider_staffing_report
    type: looker_area
    fields: [rider_staffing_report.block_starts_pivot, rider_staffing_report.sum_filled_rider_hours,
      rider_staffing_report.sum_punched_rider_hours, rider_staffing_report.sum_forecasted_rider_hours,
      rider_staffing_report.sum_planned_rider_hours, rider_staffing_report.sum_required_rider_hours,
      rider_staffing_report.pct_no_show, rider_staffing_report.delta_filled_required_hours,
      rider_staffing_report.delta_punched_required_hours]
    filters:
      rider_staffing_report.null_filter: 'No'
    sorts: [rider_staffing_report.block_starts_pivot]
    limit: 500
    query_timezone: Europe/Berlin
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
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
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    y_axes: [{label: '', orientation: left, series: [{axisId: rider_staffing_report.sum_filled_rider_hours,
            id: rider_staffing_report.sum_filled_rider_hours, name: "# Filled Rider\
              \ Hours"}, {axisId: rider_staffing_report.sum_punched_rider_hours,
            id: rider_staffing_report.sum_punched_rider_hours, name: "# Punched\
              \ Rider Hours"}, {axisId: rider_staffing_report.sum_forecasted_rider_hours,
            id: rider_staffing_report.sum_forecasted_rider_hours, name: "# Forecasted\
              \ Rider Hours"}, {axisId: rider_staffing_report.sum_planned_rider_hours,
            id: rider_staffing_report.sum_planned_rider_hours, name: "# Planned\
              \ Rider Hours"}, {axisId: rider_staffing_report.sum_required_rider_hours,
            id: rider_staffing_report.sum_required_rider_hours, name: "# Required\
              \ Rider Hours"}], showLabels: true, showValues: true, unpinAxis: false,
        tickDensity: default, tickDensityCustom: 5, type: linear}, {label: '', orientation: left,
        series: [{axisId: rider_staffing_report.delta_filled_required_hours, id: rider_staffing_report.delta_filled_required_hours,
            name: Delta Between Filled and Required Rider Hours}, {axisId: rider_staffing_report.delta_punched_required_hours,
            id: rider_staffing_report.delta_punched_required_hours, name: Delta
              Between Punched and Required Rider Hours}, {axisId: rider_staffing_report.root_mean_squared_error,
            id: rider_staffing_report.root_mean_squared_error, name: RMSE (Orders)}],
        showLabels: true, showValues: true, unpinAxis: false, tickDensity: default,
        type: linear}, {label: !!null '', orientation: right, series: [{axisId: rider_staffing_report.pct_no_show,
            id: rider_staffing_report.pct_no_show, name: "% No Show"}], showLabels: true,
        showValues: true, maxValue: 1, minValue: 0, unpinAxis: false, tickDensity: default,
        tickDensityCustom: 5, type: linear}]
    hidden_series: [rider_staffing_report.sum_planned_rider_hours, rider_staffing_report.sum_punched_rider_hours,
      rider_staffing_report.sum_required_rider_hours, rider_staffing_report.sum_forecasted_rider_hours,
      rider_staffing_report.sum_filled_rider_hours, rider_staffing_report.delta_filled_required_hours]
    trellis_rows: 2
    series_types:
      rider_staffing_report.pct_no_show: scatter
      rider_staffing_report.over_kpi: scatter
      rider_staffing_report.under_kpi: scatter
      rider_staffing_report.root_mean_squared_error: scatter
    series_colors:
      rider_staffing_report.sum_filled_rider_hours: "#72D16D"
      rider_staffing_report.sum_forecasted_rider_hours: "#c76b4e"
    series_labels:
      rider_staffing_report.root_mean_squared_error: RMSE (Orders)
    hidden_fields: []
    hidden_points_if_no: []
    arm_length: 9
    arm_weight: 48
    spinner_length: 153
    spinner_weight: 25
    target_length: 10
    target_gap: 10
    target_weight: 25
    range_min: 0
    range_max:
    value_label_type: both
    value_label_font: 12
    value_label_padding: 45
    target_source: 'off'
    target_label_type: both
    target_label_font: 3
    label_font_size: 3
    spinner_type: inner
    fill_color: "#0092E5"
    background_color: "#CECECE"
    spinner_color: "#282828"
    range_color: "#282828"
    gauge_fill_type: progress
    fill_colors: ["#7FCDAE", "#ffed6f", "#EE7772"]
    viz_trellis_by: none
    trellis_cols: 2
    angle: 104
    cutout: 40
    range_x: 1
    range_y: 1
    target_label_padding: 1.06
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 1
    listen:
      Country: hubs.country
      City: hubs.city
      Hub Name: hubs.hub_name
      Date: rider_staffing_report.date
    row: 10
    col: 0
    width: 24
    height: 12
  - name: Hubs Rider Staffing Evaluation
    title: Hubs Rider Staffing Evaluation
    model: flink_v3
    explore: rider_staffing_report
    type: looker_grid
    fields: [rider_staffing_report.pct_no_show, hubs.hub_name, rider_staffing_report.over_kpi_hours_punched,
      rider_staffing_report.under_kpi_hours_punched, rider_staffing_report.root_mean_squared_error]
    filters:
      rider_staffing_report.null_filter: 'No'
    sorts: [rider_staffing_report.pct_no_show desc, rider_staffing_report.under_kpi_hours
        desc]
    limit: 500
    query_timezone: Europe/Berlin
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    color_application:
      collection_id: 5591d8d1-6b49-4f8e-bafa-b874d82f8eb7
      palette_id: 18d0c733-1d87-42a9-934f-4ba8ef81d736
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    series_labels:
      rider_staffing_report.over_kpi_hours: "% Overstaffed Rider Hours"
      rider_staffing_report.under_kpi_hours: "% Understaffed Rider Hours"
      rider_staffing_report.root_mean_squared_error: Root-mean-square Deviation
    series_cell_visualizations:
      rider_staffing_report.pct_no_show:
        is_active: true
        palette:
          palette_id: 5378478f-6725-4b04-89cc-75fc42da804e
          collection_id: 5591d8d1-6b49-4f8e-bafa-b874d82f8eb7
      rider_staffing_report.over_kpi_hours:
        is_active: true
        palette:
          palette_id: 5378478f-6725-4b04-89cc-75fc42da804e
          collection_id: 5591d8d1-6b49-4f8e-bafa-b874d82f8eb7
      rider_staffing_report.under_kpi_hours:
        is_active: true
        palette:
          palette_id: 5378478f-6725-4b04-89cc-75fc42da804e
          collection_id: 5591d8d1-6b49-4f8e-bafa-b874d82f8eb7
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
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    y_axes: [{label: '', orientation: left, series: [{axisId: rider_staffing_report.sum_filled_rider_hours,
            id: rider_staffing_report.sum_filled_rider_hours, name: 'Orders and
              Riders Forecasting # Filled Rider Hours'}, {axisId: rider_staffing_report.sum_punched_rider_hours,
            id: rider_staffing_report.sum_punched_rider_hours, name: 'Orders and
              Riders Forecasting # Punched Rider Hours'}, {axisId: rider_staffing_report.sum_forecasted_rider_hours,
            id: rider_staffing_report.sum_forecasted_rider_hours, name: 'Orders
              and Riders Forecasting # Forecasted Rider Hours'}, {axisId: rider_staffing_report.sum_planned_rider_hours,
            id: rider_staffing_report.sum_planned_rider_hours, name: 'Orders and
              Riders Forecasting # Planned Rider Hours'}, {axisId: rider_staffing_report.sum_required_rider_hours,
            id: rider_staffing_report.sum_required_rider_hours, name: 'Orders and
              Riders Forecasting # Required Rider Hours'}], showLabels: true, showValues: true,
        unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear},
      {label: '', orientation: left, series: [{axisId: rider_staffing_report.delta_filled_required_hours,
            id: rider_staffing_report.delta_filled_required_hours, name: Orders
              and Riders Forecasting Delta Between Filled and Required Rider Hours}],
        showLabels: true, showValues: true, unpinAxis: false, tickDensity: default,
        type: linear}, {label: !!null '', orientation: right, series: [{axisId: rider_staffing_report.pct_no_show,
            id: rider_staffing_report.pct_no_show, name: Orders and Riders Forecasting
              % No Show}], showLabels: true, showValues: true, maxValue: 1, minValue: 0,
        unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear}]
    hidden_series: [rider_staffing_report.sum_planned_rider_hours, rider_staffing_report.sum_punched_rider_hours,
      rider_staffing_report.sum_required_rider_hours, rider_staffing_report.sum_forecasted_rider_hours,
      rider_staffing_report.sum_filled_rider_hours]
    trellis_rows: 2
    series_types: {}
    series_colors:
      rider_staffing_report.sum_filled_rider_hours: "#72D16D"
      rider_staffing_report.sum_forecasted_rider_hours: "#c76b4e"
    hidden_fields: []
    hidden_points_if_no: []
    arm_length: 9
    arm_weight: 48
    spinner_length: 153
    spinner_weight: 25
    target_length: 10
    target_gap: 10
    target_weight: 25
    range_min: 0
    range_max:
    value_label_type: both
    value_label_font: 12
    value_label_padding: 45
    target_source: 'off'
    target_label_type: both
    target_label_font: 3
    label_font_size: 3
    spinner_type: inner
    fill_color: "#0092E5"
    background_color: "#CECECE"
    spinner_color: "#282828"
    range_color: "#282828"
    gauge_fill_type: progress
    fill_colors: ["#7FCDAE", "#ffed6f", "#EE7772"]
    viz_trellis_by: none
    trellis_cols: 2
    angle: 104
    cutout: 40
    range_x: 1
    range_y: 1
    target_label_padding: 1.06
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    defaults_version: 1
    listen:
      Country: hubs.country
      City: hubs.city
      Hub Name: hubs.hub_name
      Date: rider_staffing_report.date
    row: 22
    col: 0
    width: 24
    height: 27
  - name: Observations
    type: text
    title_text: Observations
    subtitle_text: ''
    body_text: "##**Required hours** are estimated using the default rider UTR of\
      \ 2.5 orders/hour\n\n##**% Overstaffed Rider Hours**: # 30 min blocks with overstaffed\
      \ rider hours / Total blocks\n\n##**% Understaffed Rider Hours**: # 30 min blocks\
      \ with understaffed rider hours / Total blocks\n\n<img src=\"https://www.gstatic.com/education/formulas2/355397047/en/root_mean_square_deviation.svg\"\
      \ alt=\"\" />\n\n##With \n\n###N\t=\tNumber of non-missing data points\n\n###x_i\t\
      =\tActual observations \n\n###x_hat\t=\tEstimated  "
    row: 0
    col: 0
    width: 24
    height: 10
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
    explore: rider_staffing_report
    listens_to_filters: []
    field: hubs.country
  - name: City
    title: City
    type: field_filter
    default_value: Berlin
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: popover
      options: []
    model: flink_v3
    explore: rider_staffing_report
    listens_to_filters: []
    field: hubs.city
  - name: Hub Name
    title: Hub Name
    type: field_filter
    default_value: DE - Berlin - Kreuzberg
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: popover
      options: []
    model: flink_v3
    explore: rider_staffing_report
    listens_to_filters: []
    field: hubs.hub_name
  - name: Date
    title: Date
    type: field_filter
    default_value: yesterday
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
      options: []
    model: flink_v3
    explore: rider_staffing_report
    listens_to_filters: []
    field: rider_staffing_report.date
