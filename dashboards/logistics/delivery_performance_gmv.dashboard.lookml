- dashboard: delivery_performance_based_on_gmv___items
  title: 'Delivery Performance Based on GMV & # Items'
  layout: newspaper
  preferred_viewer: dashboards-next
  elements:
  - title: Fulfilment Time & Delays depending on GMV
    name: Fulfilment Time & Delays depending on GMV
    model: flink_v3
    explore: orders_cl
    type: looker_line
    fields: [orders_cl.gmv_gross_tier, orders_cl.pct_delivery_late_over_5_min,
      orders_cl.avg_fulfillment_time, orders_cl.cnt_orders]
    filters:
      orders_cl.is_internal_order: 'no'
      orders_cl.is_successful_order: 'yes'
      hubs.hub_name: ''
      orders_cl.gmv_gross_tier: "-< 0.0,->= 0.0 and < 2.0"
    sorts: [orders_cl.gmv_gross_tier]
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
    y_axes: [{label: '', orientation: left, series: [{axisId: orders_cl.avg_promised_eta,
            id: orders_cl.avg_promised_eta, name: AVG PDT}], showLabels: true, showValues: true,
        unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear},
      {label: !!null '', orientation: left, series: [{axisId: orders_cl.avg_fulfillment_time,
            id: orders_cl.avg_fulfillment_time, name: AVG Fulfillment Time (decimal)}],
        showLabels: true, showValues: true, unpinAxis: false, tickDensity: default,
        tickDensityCustom: 5, type: linear}, {label: !!null '', orientation: left,
        series: [{axisId: orders_cl.pct_delivery_late_over_5_min, id: orders_cl.pct_delivery_late_over_5_min,
            name: "% Orders delayed >5min"}], showLabels: true, showValues: true,
        unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear},
      {label: !!null '', orientation: right, series: [{axisId: orders_cl.cnt_orders,
            id: orders_cl.cnt_orders, name: "# Orders"}], showLabels: true, showValues: true,
        unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear}]
    hidden_series: []
    series_types:
      orders_cl.cnt_orders: area
    series_colors:
      orders_cl.cnt_orders: "#eaf2d6"
      orders_cl.pct_delivery_late_over_5_min: "#c2434f"
      orders_cl.avg_fulfillment_time: "#FBB555"
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    hidden_fields: []
    listen:
      Country: hubs.country
      Order Date: orders_cl.created_date
    row: 0
    col: 0
    width: 23
    height: 10
  - title: 'Fulfilment Time & Delays depending on # Distinct SKUs in Order'
    name: 'Fulfilment Time & Delays depending on # Distinct SKUs in Order'
    model: flink_v3
    explore: orders_cl
    type: looker_column
    fields: [orders_cl.cnt_orders, orders_cl.avg_fulfillment_time, orders_cl.pct_delivery_late_over_5_min,
      orders_cl.no_distinct_skus]
    filters:
      orders_cl.is_internal_order: 'no'
      orders_cl.is_successful_order: 'yes'
      hubs.hub_name: ''
    sorts: [order_sku_count.no_distinct_skus]
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
    limit_displayed_rows: true
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
    y_axes: [{label: '', orientation: left, series: [{axisId: orders_cl.avg_promised_eta,
            id: orders_cl.avg_promised_eta, name: AVG PDT}, {axisId: orders_cl.avg_fulfillment_time,
            id: orders_cl.avg_fulfillment_time, name: AVG Fulfillment Time (decimal)}],
        showLabels: true, showValues: true, unpinAxis: false, tickDensity: default,
        tickDensityCustom: 5, type: linear}, {label: !!null '', orientation: left,
        series: [{axisId: orders_cl.pct_delivery_late_over_5_min, id: orders_cl.pct_delivery_late_over_5_min,
            name: "% Orders delayed >5min"}], showLabels: true, showValues: true,
        unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear},
      {label: !!null '', orientation: right, series: [{axisId: orders_cl.cnt_orders,
            id: orders_cl.cnt_orders, name: "# Orders"}], showLabels: true, showValues: true,
        unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear}]
    limit_displayed_rows_values:
      show_hide: show
      first_last: first
      num_rows: '32'
    font_size: ''
    label_value_format: "#,##0"
    series_types:
      orders_cl.avg_promised_eta: line
      orders_cl.avg_fulfillment_time: line
      orders_cl.pct_delivery_late_over_5_min: line
      orders_cl.cnt_orders: area
    series_colors:
      orders_cl.cnt_orders: "#eaf2d6"
      orders_cl.pct_delivery_late_over_5_min: "#c2434f"
      orders_cl.avg_fulfillment_time: "#FBB555"
      orders_cl.avg_promised_eta: "#7ce375"
    defaults_version: 1
    hidden_fields: []
    listen:
      Country: hubs.country
      Order Date: orders_cl.created_date
    row: 10
    col: 0
    width: 23
    height: 9
  - title: 'Fulfilment Time & Delays depending on # Items in Order'
    name: 'Fulfilment Time & Delays depending on # Items in Order'
    model: flink_v3
    explore: orders_cl
    type: looker_column
    fields: [orders_cl.cnt_orders, orders_cl.avg_fulfillment_time, orders_cl.pct_delivery_late_over_5_min,
      orders_cl.quantity_fulfilled]
    filters:
      orders_cl.is_internal_order: 'no'
      orders_cl.is_successful_order: 'yes'
      hubs.hub_name: ''
    sorts: [orders_cl.quantity_fulfilled]
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
    limit_displayed_rows: true
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
    y_axes: [{label: '', orientation: left, series: [{axisId: orders_cl.avg_promised_eta,
            id: orders_cl.avg_promised_eta, name: AVG PDT}, {axisId: orders_cl.avg_fulfillment_time,
            id: orders_cl.avg_fulfillment_time, name: AVG Fulfillment Time (decimal)}],
        showLabels: true, showValues: true, unpinAxis: false, tickDensity: default,
        tickDensityCustom: 5, type: linear}, {label: !!null '', orientation: left,
        series: [{axisId: orders_cl.pct_delivery_late_over_5_min, id: orders_cl.pct_delivery_late_over_5_min,
            name: "% Orders delayed >5min"}], showLabels: true, showValues: true,
        unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear},
      {label: !!null '', orientation: right, series: [{axisId: orders_cl.cnt_orders,
            id: orders_cl.cnt_orders, name: "# Orders"}], showLabels: true, showValues: true,
        unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear}]
    limit_displayed_rows_values:
      show_hide: show
      first_last: first
      num_rows: '40'
    series_types:
      orders_cl.avg_promised_eta: line
      orders_cl.avg_fulfillment_time: line
      orders_cl.pct_delivery_late_over_5_min: line
      orders_cl.cnt_orders: area
    series_colors:
      orders_cl.cnt_orders: "#eaf2d6"
      orders_cl.pct_delivery_late_over_5_min: "#c2434f"
      orders_cl.avg_fulfillment_time: "#FBB555"
      orders_cl.avg_promised_eta: "#72D16D"
    defaults_version: 1
    hidden_fields: []
    listen:
      Country: hubs.country
      Order Date: orders_cl.created_date
    row: 19
    col: 0
    width: 23
    height: 10
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
  - name: Order Date
    title: Order Date
    type: field_filter
    default_value: 30 day
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
