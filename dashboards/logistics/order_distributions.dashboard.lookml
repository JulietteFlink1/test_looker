- dashboard: order_distributions_time_of_day_day_of_week
  title: Order Distributions (Time of Day, Day of Week)
  layout: newspaper
  preferred_viewer: dashboards-next
  elements:
  - name: Time of Day
    title: Time of Day
    model: flink_v3
    explore: orders_cl
    type: looker_area
    fields: [orders_cl.cnt_orders, orders_cl.order_date_30_min_bins, orders_cl.avg_order_value_gross]
    filters:
      orders_cl.is_internal_order: 'no'
      orders_cl.is_successful_order: 'yes'
      orders_cl.order_date_30_min_bins: "-00:30,-01:00,-01:30,-02:00,-04:00,-04:30"
    sorts: [orders_cl.order_date_30_min_bins]
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
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    y_axes: [{label: '', orientation: left, series: [{axisId: orders_cl.cnt_orders,
            id: orders_cl.cnt_orders, name: "# Orders"}], showLabels: true, showValues: true,
        unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear},
      {label: !!null '', orientation: right, series: [{axisId: orders_cl.avg_order_value_gross,
            id: orders_cl.avg_order_value_gross, name: AVG Order Value (Gross)}],
        showLabels: true, showValues: true, unpinAxis: false, tickDensity: default,
        tickDensityCustom: 5, type: linear}]
    series_types:
      orders_cl.avg_order_value_gross: line
    ordering: none
    show_null_labels: false
    defaults_version: 1
    hidden_fields: []
    listen:
      Order Date: orders_cl.created_date
      Order Day of Week: orders_cl.created_day_of_week
      Hub Name: hubs.hub_name
      Country: hubs.country
    row: 10
    col: 0
    width: 24
    height: 6
  - title: Orders per Hour per DOW (columns add up to 100%)
    name: Orders per Hour per DOW (columns add up to 100%)
    model: flink_v3
    explore: orders_cl
    type: looker_grid
    fields: [orders_cl.created_hour_of_day, orders_cl.percent_of_total_orders,
      orders_cl.created_day_of_week]
    pivots: [orders_cl.created_day_of_week]
    fill_fields: [orders_cl.created_day_of_week, orders_cl.created_hour_of_day]
    filters:
      orders_cl.is_internal_order: 'no'
      orders_cl.is_successful_order: 'yes'
    sorts: [orders_cl.created_day_of_week, orders_cl.created_hour_of_day]
    limit: 500
    total: true
    row_total: right
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
    header_font_size: 12
    rows_font_size: 12
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
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
    series_types: {}
    hidden_fields: []
    y_axes: []
    listen:
      Order Date: orders_cl.created_date
      Order Day of Week: orders_cl.created_day_of_week
      Hub Name: hubs.hub_name
      Country: hubs.country
    row: 16
    col: 0
    width: 24
    height: 14
  - name: Orders per Hour per DOW (% of overall total)
    title: Orders per Hour per DOW (% of overall total)
    model: flink_v3
    explore: orders_cl
    type: looker_grid
    fields: [orders_cl.created_hour_of_day, orders_cl.percent_of_total_orders,
      orders_cl.cnt_orders, orders_cl.created_day_of_week]
    pivots: [orders_cl.created_day_of_week]
    fill_fields: [orders_cl.created_day_of_week, orders_cl.created_hour_of_day]
    filters:
      orders_cl.is_internal_order: 'no'
      orders_cl.is_successful_order: 'yes'
    sorts: [orders_cl.created_day_of_week 0, orders_cl.created_hour_of_day 0]
    limit: 500
    total: true
    row_total: right
    dynamic_fields: [{table_calculation: percent_of_overall_total, label: Percent
          of Overall Total, expression: "${orders_cl.cnt_orders}/ ( sum(sum(pivot_row(${orders_cl.cnt_orders})))\
          \ )", value_format: !!null '', value_format_name: percent_2, _kind_hint: measure,
        _type_hint: number}]
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
    show_sql_query_menu_options: false
    show_totals: false
    show_row_totals: false
    series_cell_visualizations:
      orders_cl.percent_of_total_orders:
        is_active: true
      percent_of_overall_total:
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
    series_types: {}
    hidden_fields: [column_total, row_total, orders_cl.percent_of_total_orders,
      orders_cl.cnt_orders]
    series_column_widths:
      orders_cl.percent_of_total_orders: 86
      orders_cl.created_hour_of_day: 176
      percent_of_overall_total: 180
    y_axes: []
    listen:
      Order Date: orders_cl.created_date
      Order Day of Week: orders_cl.created_day_of_week
      Hub Name: hubs.hub_name
      Country: hubs.country
    row: 0
    col: 0
    width: 24
    height: 10
  - name: Order Timings per time of day
    title: Order Timings per time of day
    model: flink_v3
    explore: orders_cl
    type: looker_line
    fields: [orders_cl.cnt_orders, orders_cl.avg_fulfillment_time, orders_cl.order_date_30_min_bins,
      orders_cl.avg_picking_time, orders_cl.avg_delivery_time, orders_cl.avg_promised_eta,
      orders_cl.pct_delivery_in_time]
    filters:
      orders_cl.is_internal_order: 'no'
      orders_cl.is_successful_order: 'yes'
      orders_cl.warehouse_name: ''
    sorts: [orders_cl.order_date_30_min_bins]
    limit: 500
    column_limit: 50
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
    y_axes: [{label: '', orientation: left, series: [{axisId: orders_cl.cnt_orders,
            id: orders_cl.cnt_orders, name: "# Orders"}], showLabels: true, showValues: true,
        unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear},
      {label: !!null '', orientation: right, series: [{axisId: orders_cl.avg_promised_eta,
            id: orders_cl.avg_promised_eta, name: AVG Promised ETA}, {axisId: orders_cl.avg_fulfillment_time,
            id: orders_cl.avg_fulfillment_time, name: AVG Fulfillment Time (decimal)},
          {axisId: orders_cl.avg_picking_time, id: orders_cl.avg_picking_time,
            name: AVG Picking Time}, {axisId: orders_cl.avg_delivery_time, id: orders_cl.avg_delivery_time,
            name: AVG Delivery Time}], showLabels: true, showValues: true, unpinAxis: false,
        tickDensity: default, tickDensityCustom: 5, type: linear}, {label: !!null '',
        orientation: right, series: [{axisId: orders_cl.pct_delivery_in_time, id: orders_cl.pct_delivery_in_time,
            name: "% Orders delivered in time"}], showLabels: true, showValues: true,
        unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear}]
    hidden_series: []
    series_types:
      orders_cl.cnt_orders: column
    series_colors:
      orders_cl.cnt_orders: "#78949c"
      orders_cl.avg_fulfillment_time: "#1A73E8"
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    hidden_fields: []
    listen:
      Order Date: orders_cl.created_date
      Order Day of Week: orders_cl.created_day_of_week
      Hub Name: hubs.hub_name
      Country: hubs.country
    row: 36
    col: 0
    width: 24
    height: 8
  - name: Orders and Fulfillment Time per time of day (table)
    title: Orders and Fulfillment Time per time of day (table)
    model: flink_v3
    explore: orders_cl
    type: looker_grid
    fields: [orders_cl.order_date_30_min_bins, orders_cl.cnt_orders, orders_cl.avg_promised_eta,
      orders_cl.avg_fulfillment_time, orders_cl.avg_picking_time, orders_cl.avg_delivery_time,
      orders_cl.pct_delivery_in_time, orders_cl.pct_delivery_late_over_5_min,
      orders_cl.pct_delivery_late_over_10_min, orders_cl.pct_delivery_late_over_15_min,
      orders_cl.avg_delivery_distance_km]
    filters:
      orders_cl.is_internal_order: 'no'
      orders_cl.is_successful_order: 'yes'
      orders_cl.warehouse_name: ''
    sorts: [orders_cl.order_date_30_min_bins]
    limit: 500
    column_limit: 50
    query_timezone: Europe/Berlin
    show_view_names: false
    show_row_numbers: true
    transpose: true
    truncate_text: false
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: '10'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    series_column_widths:
      '08:00': 81
      '08:30': 81
      measure: 202
      '09:00': 81
      '09:30': 81
      '10:00': 81
      '10:30': 81
      '11:00': 81
      '11:30': 81
      '12:00': 81
      '12:30': 81
      '13:00': 81
      '13:30': 81
      '14:00': 81
      '14:30': 81
      '15:00': 81
      '15:30': 81
      '16:00': 81
      '16:30': 81
      '17:00': 81
      '17:30': 81
      '18:00': 81
      '18:30': 81
      '19:00': 81
      '19:30': 81
      '20:00': 81
      '20:30': 81
      '21:00': 81
      '21:30': 81
      '22:00': 81
      '22:30': 81
      '23:00': 81
    series_cell_visualizations:
      orders_cl.cnt_orders:
        is_active: true
      orders_cl.avg_fulfillment_time:
        is_active: true
        palette:
          palette_id: f0077e50-e03c-4a7e-930c-7321b2267283
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      orders_cl.pct_delivery_in_time:
        is_active: true
        palette:
          palette_id: 97051b6a-93c9-0dfc-e218-e1cdf6cf0f0e
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
          custom_colors:
          - "#ffffff"
          - "#75e66a"
      orders_cl.pct_delivery_late_over_5_min:
        is_active: true
        palette:
          palette_id: f0077e50-e03c-4a7e-930c-7321b2267283
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      orders_cl.pct_delivery_late_over_10_min:
        is_active: true
        palette:
          palette_id: f0077e50-e03c-4a7e-930c-7321b2267283
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      orders_cl.pct_delivery_late_over_15_min:
        is_active: true
        palette:
          palette_id: f0077e50-e03c-4a7e-930c-7321b2267283
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      orders_cl.avg_delivery_distance_km:
        is_active: true
        palette:
          palette_id: 56d0c358-10a0-4fd6-aa0b-b117bef527ab
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
    limit_displayed_rows_values:
      show_hide: hide
      first_last: first
      num_rows: 0
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
    y_axes: [{label: '', orientation: left, series: [{axisId: orders_cl.cnt_orders,
            id: orders_cl.cnt_orders, name: "# Orders"}], showLabels: true, showValues: true,
        unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear},
      {label: !!null '', orientation: right, series: [{axisId: orders_cl.avg_fulfillment_time,
            id: orders_cl.avg_fulfillment_time, name: AVG Fulfillment Time}], showLabels: true,
        showValues: true, unpinAxis: false, tickDensity: default, tickDensityCustom: 5,
        type: linear}]
    series_types: {}
    series_colors:
      orders_cl.cnt_orders: "#F9AB00"
      orders_cl.avg_fulfillment_time: "#1A73E8"
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    hidden_fields: []
    listen:
      Order Date: orders_cl.created_date
      Order Day of Week: orders_cl.created_day_of_week
      Hub Name: hubs.hub_name
      Country: hubs.country
    row: 30
    col: 0
    width: 24
    height: 6
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
    explore: orders_cl
    listens_to_filters: []
    field: hubs.country
  - name: Hub Name
    title: Hub Name
    type: field_filter
    default_value: FR - Paris - Rue de Reaumur
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: popover
      options: []
    model: flink_v3
    explore: orders_cl
    listens_to_filters: []
    field: hubs.hub_name
  - name: Order Day of Week
    title: Order Day of Week
    type: field_filter
    default_value: Monday,Tuesday,Wednesday,Thursday,Saturday,Friday
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: popover
      options: []
    model: flink_v3
    explore: orders_cl
    listens_to_filters: []
    field: orders_cl.created_day_of_week
  - name: Order Date
    title: Order Date
    type: field_filter
    default_value: last week
    allow_multiple_values: true
    required: false
    ui_config:
      type: relative_timeframes
      display: inline
      options: []
    model: flink_v3
    explore: orders_cl
    listens_to_filters: []
    field: orders_cl.created_date
