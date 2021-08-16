- dashboard: nps_after_order_dashboard
  title: NPS (After Order) Dashboard CT
  layout: newspaper
  preferred_viewer: dashboards-next
  elements:
  - name: NPS by Hub
    title: NPS by Hub
    model: flink_v3
    explore: orders_customers
    type: looker_column
    fields: [nps_after_order.pct_passives, nps_after_order.pct_detractors, nps_after_order.pct_promoters,
      nps_after_order.cnt_responses, nps_after_order.nps_score, hubs.hub_name]
    filters:
      orders_cl.is_internal_order: ''
      orders_cl.is_successful_order: ''
      orders_cl.created_date: ''
    sorts: [nps_after_order.nps_score desc]
    limit: 500
    total: true
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
    y_axes: [{label: '', orientation: left, series: [{axisId: nps_after_order.nps_score,
            id: nps_after_order.nps_score, name: "% NPS"}], showLabels: true, showValues: true,
        unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear},
      {label: !!null '', orientation: left, series: [{axisId: nps_after_order.count,
            id: nps_after_order.count, name: NPS After Order}], showLabels: true,
        showValues: true, unpinAxis: false, tickDensity: default, tickDensityCustom: 5,
        type: linear}]
    series_types:
      nps_after_order.nps_score: line
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    hidden_fields: [nps_after_order.pct_promoters, nps_after_order.pct_detractors,
      nps_after_order.pct_passives]
    listen:
      Country: hubs.country
      Hub Name: hubs.hub_name
      City: hubs.city
      Submitted Date: nps_after_order.submitted_date
      Suggestion for improvement: nps_after_order.nps_comment
      Driver (Primary Reason for NPS): nps_after_order.nps_driver
      Customer Type: orders_cl.customer_type
    row: 16
    col: 0
    width: 12
    height: 8
  - name: NPS Timeseries
    title: NPS Timeseries
    model: flink_v3
    explore: orders_customers
    type: looker_line
    fields: [orders_cl.created_date, nps_after_order.pct_passives, nps_after_order.pct_detractors,
      nps_after_order.pct_promoters, nps_after_order.cnt_responses, nps_after_order.nps_score]
    filters:
      orders_cl.is_internal_order: ''
      orders_cl.is_successful_order: ''
      orders_cl.created_date: 28 days
    sorts: [orders_cl.created_date desc]
    limit: 500
    total: true
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
    y_axes: [{label: '', orientation: left, series: [{axisId: nps_after_order.cnt_responses,
            id: nps_after_order.cnt_responses, name: "# NPS Responses"}], showLabels: true,
        showValues: true, maxValue: !!null '', minValue: !!null '', unpinAxis: false,
        tickDensity: default, type: linear}, {label: '', orientation: right, series: [
          {axisId: nps_after_order.nps_score, id: nps_after_order.nps_score, name: "%\
              \ NPS"}], showLabels: true, showValues: true, maxValue: 1, minValue: 0,
        unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear}]
    series_types:
      nps_after_order.cnt_responses: column
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    hidden_fields: [nps_after_order.pct_promoters, nps_after_order.pct_detractors,
      nps_after_order.pct_passives]
    listen:
      Country: hubs.country
      Hub Name: hubs.hub_name
      City: hubs.city
      Submitted Date: nps_after_order.submitted_date
      Suggestion for improvement: nps_after_order.nps_comment
      Driver (Primary Reason for NPS): nps_after_order.nps_driver
      Customer Type: orders_cl.customer_type
    row: 0
    col: 12
    width: 12
    height: 8
  - name: NPS Comments
    title: NPS Comments
    model: flink_v3
    explore: orders_cl
    type: looker_grid
    fields: [orders_cl.created_date, nps_after_order.submitted_date, nps_after_order.order_id,
      nps_after_order.nps_driver, nps_after_order.nps_comment, hubs.hub_name, nps_after_order.score,
      nps_after_order.cnt_responses, orders_cl.avg_promised_eta, orders_cl.avg_fulfillment_time,
      orders_cl.delivery_delay_since_eta]
    filters:
      orders_cl.is_internal_order: ''
      orders_cl.is_successful_order: ''
      orders_cl.created_date: 28 days
      nps_after_order.score: NOT NULL
    sorts: [nps_after_order.submitted_date desc]
    limit: 5000
    total: true
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
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    column_order: ["$$$_row_numbers_$$$", nps_after_order.submitted_date, orders_cl.created_date,
      nps_after_order.order_id, hubs.hub_name, nps_after_order.score, nps_after_order.nps_driver,
      nps_after_order.nps_comment, orders_cl.avg_promised_eta, orders_cl.avg_fulfillment_time,
      orders_cl.delivery_delay_since_eta]
    show_totals: true
    show_row_totals: true
    series_column_widths:
      nps_after_order.submitted_date: 131
      nps_after_order.nps_driver: 408
      nps_after_order.score: 75
      orders_cl.created_date: 87
      nps_after_order.order_id: 88
      nps_after_order.nps_comment: 267
      hubs.hub_name: 99
      orders_cl.avg_promised_eta: 77
      orders_cl.avg_fulfillment_time: 112
      orders_cl.delivery_delay_since_eta: 98
      nps_after_order.pct_detractors: 100
      nps_after_order.nps_score: 75
      nps_after_order.pct_passives: 94
      nps_after_order.pct_promoters: 76
    series_cell_visualizations:
      nps_after_order.cnt_responses:
        is_active: true
      nps_after_order.score:
        is_active: true
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
    y_axes: [{label: '', orientation: left, series: [{axisId: nps_after_order.nps_score,
            id: nps_after_order.nps_score, name: "% NPS"}], showLabels: true, showValues: true,
        unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear},
      {label: !!null '', orientation: left, series: [{axisId: nps_after_order.count,
            id: nps_after_order.count, name: NPS After Order}], showLabels: true,
        showValues: true, unpinAxis: false, tickDensity: default, tickDensityCustom: 5,
        type: linear}]
    series_types: {}
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    hidden_fields: [nps_after_order.cnt_responses]
    listen:
      Country: hubs.country
      Hub Name: hubs.hub_name
      City: hubs.city
      Submitted Date: nps_after_order.submitted_date
      Suggestion for improvement: nps_after_order.nps_comment
      Driver (Primary Reason for NPS): nps_after_order.nps_driver
      Customer Type: orders_cl.customer_type
    row: 24
    col: 0
    width: 24
    height: 13
  - name: NPS by Delivery Delay
    title: NPS by Delivery Delay
    model: flink_v3
    explore: orders_customers
    type: looker_column
    fields: [nps_after_order.pct_passives, nps_after_order.pct_detractors, nps_after_order.pct_promoters,
      nps_after_order.cnt_responses, nps_after_order.nps_score, orders_cl.delivery_delay_since_eta]
    filters:
      orders_cl.is_internal_order: ''
      orders_cl.is_successful_order: ''
      orders_cl.created_date: ''
      orders_cl.delivery_delay_since_eta: "<=7 AND >= -7"
    sorts: [orders_cl.delivery_delay_since_eta]
    limit: 500
    total: true
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
    y_axes: [{label: '', orientation: left, series: [{axisId: nps_after_order.cnt_responses,
            id: nps_after_order.cnt_responses, name: "# NPS Responses"}], showLabels: true,
        showValues: true, unpinAxis: false, tickDensity: default, type: linear}, {
        label: '', orientation: right, series: [{axisId: nps_after_order.nps_score,
            id: nps_after_order.nps_score, name: "% NPS"}], showLabels: true, showValues: true,
        unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear}]
    series_types:
      nps_after_order.nps_score: line
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    hidden_fields: [nps_after_order.pct_promoters, nps_after_order.pct_detractors,
      nps_after_order.pct_passives]
    listen:
      Country: hubs.country
      Hub Name: hubs.hub_name
      City: hubs.city
      Submitted Date: nps_after_order.submitted_date
      Suggestion for improvement: nps_after_order.nps_comment
      Driver (Primary Reason for NPS): nps_after_order.nps_driver
      Customer Type: orders_cl.customer_type
    row: 8
    col: 12
    width: 12
    height: 8
  - title: NPS
    name: NPS
    model: flink_v3
    explore: orders_customers
    type: marketplace_viz_radial_gauge::radial_gauge-marketplace
    fields: [nps_after_order.nps_score]
    filters:
      orders_cl.is_internal_order: ''
      orders_cl.is_successful_order: ''
      orders_cl.created_date: 28 days
    limit: 500
    column_limit: 50
    total: true
    query_timezone: Europe/Berlin
    hidden_fields: []
    hidden_points_if_no: []
    series_labels: {}
    show_view_names: false
    arm_length: 9
    arm_weight: 48
    spinner_length: 153
    spinner_weight: 25
    target_length: 10
    target_gap: 10
    target_weight: 25
    range_min: 0
    range_max: 1
    value_label_type: both
    value_label_font: 12
    value_label_padding: 45
    target_source: 'off'
    target_label_type: both
    target_label_font: 3
    label_font_size: 5
    range_formatting: 0%
    spinner_type: needle
    fill_color: "#0092E5"
    background_color: "#CECECE"
    spinner_color: "#282828"
    range_color: "#282828"
    gauge_fill_type: segment
    fill_colors: ["#EE7772", "#ffed6f", "#7FCDAE"]
    viz_trellis_by: none
    trellis_rows: 2
    trellis_cols: 2
    angle: 90
    cutout: 30
    range_x: 1
    range_y: 1
    target_label_padding: 1.06
    custom_color_enabled: true
    show_single_value_title: false
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    custom_color: "#7CB342"
    single_value_title: ''
    conditional_formatting: [{type: equal to, value: !!null '', background_color: "#1A73E8",
        font_color: !!null '', color_application: {collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2,
          palette_id: 56d0c358-10a0-4fd6-aa0b-b117bef527ab}, bold: false, italic: false,
        strikethrough: false, fields: !!null ''}]
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
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    y_axes: [{label: '', orientation: left, series: [{axisId: nps_after_order.nps_score,
            id: nps_after_order.nps_score, name: "% NPS"}], showLabels: true, showValues: true,
        unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear},
      {label: !!null '', orientation: left, series: [{axisId: nps_after_order.count,
            id: nps_after_order.count, name: NPS After Order}], showLabels: true,
        showValues: true, unpinAxis: false, tickDensity: default, tickDensityCustom: 5,
        type: linear}]
    series_types: {}
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 0
    listen:
      Country: hubs.country
      Hub Name: hubs.hub_name
      City: hubs.city
      Submitted Date: nps_after_order.submitted_date
      Suggestion for improvement: nps_after_order.nps_comment
      Driver (Primary Reason for NPS): nps_after_order.nps_driver
      Customer Type: orders_cl.customer_type
    row: 0
    col: 0
    width: 12
    height: 8
  - name: NPS by Fulfillment Time
    title: NPS by Fulfillment Time
    model: flink_v3
    explore: orders_customers
    type: looker_column
    fields: [nps_after_order.pct_passives, nps_after_order.pct_detractors, nps_after_order.pct_promoters,
      nps_after_order.cnt_responses, nps_after_order.nps_score, orders_cl.fulfillment_time_tier]
    filters:
      orders_cl.is_internal_order: ''
      orders_cl.is_successful_order: ''
      orders_cl.created_date: ''
      orders_cl.fulfillment_time: "[1, 18]"
      orders_cl.fulfillment_time_tier: "-Undefined"
    sorts: [orders_cl.fulfillment_time_tier]
    limit: 500
    column_limit: 50
    total: true
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
    y_axes: [{label: '', orientation: left, series: [{axisId: nps_after_order.cnt_responses,
            id: nps_after_order.cnt_responses, name: "# NPS Responses"}], showLabels: true,
        showValues: true, unpinAxis: false, tickDensity: default, type: linear}, {
        label: '', orientation: right, series: [{axisId: nps_after_order.nps_score,
            id: nps_after_order.nps_score, name: "% NPS"}], showLabels: true, showValues: true,
        unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear}]
    series_types:
      nps_after_order.nps_score: line
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    hidden_fields: [nps_after_order.pct_promoters, nps_after_order.pct_detractors,
      nps_after_order.pct_passives]
    listen:
      Country: hubs.country
      Hub Name: hubs.hub_name
      City: hubs.city
      Submitted Date: nps_after_order.submitted_date
      Suggestion for improvement: nps_after_order.nps_comment
      Driver (Primary Reason for NPS): nps_after_order.nps_driver
      Customer Type: orders_cl.customer_type
    row: 8
    col: 0
    width: 12
    height: 8
  filters:
  - name: Country
    title: Country
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: button_group
      display: inline
      options: []
    model: flink_v3
    explore: orders_customers
    listens_to_filters: []
    field: hubs.country
  - name: Hub Name
    title: Hub Name
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
      options: []
    model: flink_v3
    explore: orders_customers
    listens_to_filters: []
    field: hubs.hub_name
  - name: City
    title: City
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
      options: []
    model: flink_v3
    explore: orders_customers
    listens_to_filters: []
    field: hubs.city
  - name: Submitted Date
    title: Submitted Date
    type: field_filter
    default_value: 90 day
    allow_multiple_values: true
    required: false
    ui_config:
      type: relative_timeframes
      display: inline
      options: []
    model: flink_v3
    explore: orders_customers
    listens_to_filters: []
    field: nps_after_order.submitted_date
  - name: Customer Type
    title: Customer Type
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: button_toggles
      display: popover
      options: []
    model: flink_v3
    explore: orders_customers
    listens_to_filters: []
    field: orders_cl.customer_type
  - name: Suggestion for improvement
    title: Suggestion for improvement
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
      options: []
    model: flink_v3
    explore: orders_customers
    listens_to_filters: []
    field: nps_after_order.nps_comment
  - name: Driver (Primary Reason for NPS)
    title: Driver (Primary Reason for NPS)
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
      options: []
    model: flink_v3
    explore: orders_customers
    listens_to_filters: []
    field: nps_after_order.nps_driver
