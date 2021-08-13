- dashboard: intraday_hourly_orders__gmv
  title: Intraday Hourly Orders / GMV
  layout: newspaper
  preferred_viewer: dashboards-next
  elements:
  - name: Hourly orders real-time comparison
    title: Hourly orders real-time comparison
    model: flink_v3
    explore: orders_cl
    type: looker_line
    fields: [orders_cl.hour, orders_cl.created_date, orders_cl.count]
    pivots: [orders_cl.created_date]
    filters:
      orders_cl.created_date: today, 7 days ago
      orders_cl.status: fulfilled,partially fulfilled
      orders_cl.is_successful_order: Yes
      orders_cl.country_iso: DE
    sorts: [orders_cl.created_date desc, orders_cl.hour]
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
    show_null_points: false
    interpolation: linear
    hide_legend: true
    defaults_version: 1
    hidden_fields: []
    y_axes: []
    listen:
      Warehouse - DE: hubs.hub_name
      Hour: orders_cl.hour
    row: 2
    col: 0
    width: 12
    height: 6
  - name: Hourly GMV real-time comparison
    title: Hourly GMV real-time comparison
    model: flink_v3
    explore: orders_cl
    type: looker_line
    fields: [orders_cl.hour, orders_cl.created_date, orders_cl.sum_gmv_gross]
    pivots: [orders_cl.created_date]
    fill_fields: [orders_cl.created_date]
    filters:
      orders_cl.created_date: today, 7 days ago
      orders_cl.status: fulfilled,partially fulfilled
      orders_cl.is_successful_order: Yes
      orders_cl.country_iso: DE
    sorts: [orders_cl.created_date desc, orders_cl.hour]
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
    show_null_points: false
    interpolation: linear
    hide_legend: true
    defaults_version: 1
    hidden_fields: []
    y_axes: []
    listen:
      Warehouse - DE: hubs.hub_name
      Hour: orders_cl.hour
    row: 2
    col: 12
    width: 12
    height: 6
  - name: Germany
    type: text
    title_text: Germany
    subtitle_text: ''
    body_text: ''
    row: 0
    col: 0
    width: 24
    height: 2
  - name: Hourly GMV real-time comparison - NL
    title: Hourly GMV real-time comparison - NL
    model: flink_v3
    explore: orders_cl
    type: looker_line
    fields: [orders_cl.hour, orders_cl.created_date, orders_cl.sum_gmv_gross]
    pivots: [orders_cl.created_date]
    fill_fields: [orders_cl.created_date]
    filters:
      orders_cl.created_date: today, 7 days ago
      orders_cl.status: fulfilled,partially fulfilled
      orders_cl.is_successful_order: Yes
      orders_cl.country_iso: NL
    sorts: [orders_cl.created_date desc 0, orders_cl.hour]
    limit: 500
    dynamic_fields: [{table_calculation: wow, label: WoW, expression: "(${orders_cl.count}\
          \ - pivot_offset(${orders_cl.count}, 7)) / pivot_offset(${orders_cl.count},\
          \ 7)", value_format: '"▲  "+0%; "▼  "-0%; 0', value_format_name: !!null '',
        _kind_hint: measure, _type_hint: number, is_disabled: true}]
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
    show_null_points: false
    interpolation: linear
    y_axes: [{label: '', orientation: left, series: [{axisId: orders_cl.count, id: 2021-04-09
              - orders_cl.count, name: '2021-04-09 - Order Order # Orders'}, {axisId: orders_cl.count,
            id: 2021-04-08 - orders_cl.count, name: '2021-04-08 - Order Order #
              Orders'}, {axisId: orders_cl.count, id: 2021-04-07 - orders_cl.count,
            name: '2021-04-07 - Order Order # Orders'}, {axisId: orders_cl.count,
            id: 2021-04-06 - orders_cl.count, name: '2021-04-06 - Order Order #
              Orders'}, {axisId: orders_cl.count, id: 2021-04-05 - orders_cl.count,
            name: '2021-04-05 - Order Order # Orders'}, {axisId: orders_cl.count,
            id: 2021-04-04 - orders_cl.count, name: '2021-04-04 - Order Order #
              Orders'}, {axisId: orders_cl.count, id: 2021-04-03 - orders_cl.count,
            name: '2021-04-03 - Order Order # Orders'}, {axisId: orders_cl.count,
            id: 2021-04-02 - orders_cl.count, name: '2021-04-02 - Order Order #
              Orders'}], showLabels: true, showValues: true, unpinAxis: false, tickDensity: default,
        tickDensityCustom: 5, type: linear}, {label: !!null '', orientation: right,
        series: [{axisId: wow, id: 2021-04-09 - wow, name: 2021-04-09 - WoW}, {axisId: wow,
            id: 2021-04-08 - wow, name: 2021-04-08 - WoW}, {axisId: wow, id: 2021-04-07
              - wow, name: 2021-04-07 - WoW}, {axisId: wow, id: 2021-04-06 - wow,
            name: 2021-04-06 - WoW}, {axisId: wow, id: 2021-04-05 - wow, name: 2021-04-05
              - WoW}, {axisId: wow, id: 2021-04-04 - wow, name: 2021-04-04 - WoW},
          {axisId: wow, id: 2021-04-03 - wow, name: 2021-04-03 - WoW}, {axisId: wow,
            id: 2021-04-02 - wow, name: 2021-04-02 - WoW}], showLabels: true, showValues: true,
        unpinAxis: true, tickDensity: default, tickDensityCustom: 5, type: linear}]
    hide_legend: true
    defaults_version: 1
    hidden_fields: []
    listen:
      Warehouse - NL: hubs.hub_name
      Warehouse - DE: hubs.hub_name
      Hour: orders_cl.hour
    row: 22
    col: 12
    width: 12
    height: 6
  - name: Hourly orders real-time comparison - NL
    title: Hourly orders real-time comparison - NL
    model: flink_v3
    explore: orders_cl
    type: looker_line
    fields: [orders_cl.hour, orders_cl.created_date, orders_cl.count]
    pivots: [orders_cl.created_date]
    fill_fields: [orders_cl.created_date]
    filters:
      orders_cl.created_date: today, 7 days ago
      orders_cl.status: fulfilled,partially fulfilled
      orders_cl.is_successful_order: Yes
      orders_cl.country_iso: NL
    sorts: [orders_cl.created_date desc 0, orders_cl.hour]
    limit: 500
    dynamic_fields: [{table_calculation: wow, label: WoW, expression: "(${orders_cl.count}\
          \ - pivot_offset(${orders_cl.count}, 7)) / pivot_offset(${orders_cl.count},\
          \ 7)", value_format: '"▲  "+0%; "▼  "-0%; 0', value_format_name: !!null '',
        _kind_hint: measure, _type_hint: number, is_disabled: true}]
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
    show_null_points: false
    interpolation: linear
    y_axes: [{label: '', orientation: left, series: [{axisId: orders_cl.count, id: 2021-04-09
              - orders_cl.count, name: '2021-04-09 - Order Order # Orders'}, {axisId: orders_cl.count,
            id: 2021-04-08 - orders_cl.count, name: '2021-04-08 - Order Order #
              Orders'}, {axisId: orders_cl.count, id: 2021-04-07 - orders_cl.count,
            name: '2021-04-07 - Order Order # Orders'}, {axisId: orders_cl.count,
            id: 2021-04-06 - orders_cl.count, name: '2021-04-06 - Order Order #
              Orders'}, {axisId: orders_cl.count, id: 2021-04-05 - orders_cl.count,
            name: '2021-04-05 - Order Order # Orders'}, {axisId: orders_cl.count,
            id: 2021-04-04 - orders_cl.count, name: '2021-04-04 - Order Order #
              Orders'}, {axisId: orders_cl.count, id: 2021-04-03 - orders_cl.count,
            name: '2021-04-03 - Order Order # Orders'}, {axisId: orders_cl.count,
            id: 2021-04-02 - orders_cl.count, name: '2021-04-02 - Order Order #
              Orders'}], showLabels: true, showValues: true, unpinAxis: false, tickDensity: default,
        tickDensityCustom: 5, type: linear}, {label: !!null '', orientation: right,
        series: [{axisId: wow, id: 2021-04-09 - wow, name: 2021-04-09 - WoW}, {axisId: wow,
            id: 2021-04-08 - wow, name: 2021-04-08 - WoW}, {axisId: wow, id: 2021-04-07
              - wow, name: 2021-04-07 - WoW}, {axisId: wow, id: 2021-04-06 - wow,
            name: 2021-04-06 - WoW}, {axisId: wow, id: 2021-04-05 - wow, name: 2021-04-05
              - WoW}, {axisId: wow, id: 2021-04-04 - wow, name: 2021-04-04 - WoW},
          {axisId: wow, id: 2021-04-03 - wow, name: 2021-04-03 - WoW}, {axisId: wow,
            id: 2021-04-02 - wow, name: 2021-04-02 - WoW}], showLabels: true, showValues: true,
        unpinAxis: true, tickDensity: default, tickDensityCustom: 5, type: linear}]
    hide_legend: true
    defaults_version: 1
    hidden_fields: []
    listen:
      Warehouse - NL: hubs.hub_name
      Warehouse - DE: hubs.hub_name
      Hour: orders_cl.hour
    row: 22
    col: 0
    width: 12
    height: 6
  - name: Hourly real-time comparison (Tabular) - NL
    title: Hourly real-time comparison (Tabular) - NL
    model: flink_v3
    explore: orders_cl
    type: looker_grid
    fields: [orders_cl.hour, orders_cl.count, orders_cl.created_date, orders_cl.sum_gmv_gross]
    pivots: [orders_cl.created_date]
    filters:
      orders_cl.status: partially fulfilled,fulfilled
      orders_cl.created_date: today, 7 days ago, 14 days ago, 21 days ago
      orders_cl.is_successful_order: Yes
      orders_cl.country_iso: NL
      orders_cl.is_order_hour_before_now_hour: Yes
    sorts: [orders_cl.created_date desc 0, orders_cl.hour]
    limit: 500
    total: true
    dynamic_fields: [{table_calculation: wow_orders, label: WoW - Orders, expression: "(${orders_cl.count}\
          \ - pivot_offset(${orders_cl.count}, 1)) / pivot_offset(${orders_cl.count},\
          \ 1)", value_format: '"▲  "+0%; "▼  "-0%; 0', value_format_name: !!null '',
        _kind_hint: measure, _type_hint: number}, {table_calculation: wow_gmv, label: WoW
          -GMV, expression: "(${orders_cl.sum_gmv_gross} - pivot_offset(${orders_cl.sum_gmv_gross},\
          \ 1)) / pivot_offset(${orders_cl.sum_gmv_gross}, 1)", value_format: '"▲  "+0%;
          "▼  "-0%; 0', value_format_name: !!null '', _kind_hint: measure, _type_hint: number}]
    query_timezone: Europe/Berlin
    show_view_names: false
    show_row_numbers: false
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
    conditional_formatting_include_totals: true
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    series_column_widths:
      orders_cl.hour: 120
      orders_cl.count: 86
      wow_orders: 96
      orders_cl.sum_gmv_gross: 106
      wow_gmv: 92
    series_cell_visualizations:
      orders_cl.count:
        is_active: false
    conditional_formatting: [{type: greater than, value: 0, background_color: '',
        font_color: "#7CB342", color_application: {collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2,
          palette_id: 56d0c358-10a0-4fd6-aa0b-b117bef527ab}, bold: false, italic: false,
        strikethrough: false, fields: [wow_orders, wow_gmv]}, {type: less than, value: 0,
        background_color: '', font_color: "#EA4335", color_application: {collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2,
          palette_id: 56d0c358-10a0-4fd6-aa0b-b117bef527ab}, bold: false, italic: false,
        strikethrough: false, fields: [wow_orders, wow_gmv]}]
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
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    series_types: {}
    hidden_fields: []
    y_axes: []
    listen:
      Warehouse - NL: hubs.hub_name
      Warehouse - DE: hubs.hub_name
      Hour: orders_cl.hour
    row: 28
    col: 0
    width: 24
    height: 10
  - name: Netherlands
    type: text
    title_text: Netherlands
    subtitle_text: ''
    body_text: ''
    row: 20
    col: 0
    width: 24
    height: 2
  - name: Hourly real-time comparison (Tabular)
    title: Hourly real-time comparison (Tabular)
    model: flink_v3
    explore: orders_cl
    type: looker_grid
    fields: [orders_cl.hour, orders_cl.created_date, orders_cl.count, orders_cl.sum_gmv_gross]
    pivots: [orders_cl.created_date]
    filters:
      orders_cl.created_date: today, 7 days ago, 14 days ago, 21 days ago
      orders_cl.status: fulfilled,partially fulfilled
      orders_cl.is_successful_order: Yes
      orders_cl.country_iso: DE
      orders_cl.is_order_hour_before_now_hour: Yes
    sorts: [orders_cl.created_date desc, orders_cl.hour 0]
    limit: 500
    column_limit: 50
    total: true
    dynamic_fields: [{table_calculation: wow_gmv, label: WoW - GMV, expression: "(${orders_cl.sum_gmv_gross}\
          \ - pivot_offset(${orders_cl.sum_gmv_gross}, 1)) / pivot_offset(${orders_cl.sum_gmv_gross},\
          \ 1)", value_format: '"▲  "+0%; "▼  "-0%; 0', value_format_name: !!null '',
        _kind_hint: measure, _type_hint: number}, {table_calculation: wow_orders,
        label: WoW - Orders, expression: "(${orders_cl.count} - pivot_offset(${orders_cl.count},\
          \ 1)) / pivot_offset(${orders_cl.count}, 1)", value_format: '"▲  "+0%;
          "▼  "-0%; 0', value_format_name: !!null '', _kind_hint: measure, _type_hint: number}]
    query_timezone: Europe/Berlin
    show_view_names: false
    show_row_numbers: false
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
    conditional_formatting_include_totals: true
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    series_column_widths:
      orders_cl.hour: 120
      orders_cl.count: 81
      orders_cl.sum_gmv_gross: 85
      wow_gmv: 90
      wow_orders: 83
    series_cell_visualizations:
      orders_cl.sum_gmv_gross:
        is_active: false
    conditional_formatting: [{type: greater than, value: 0, background_color: '',
        font_color: "#7CB342", color_application: {collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2,
          palette_id: 4a00499b-c0fe-4b15-a304-4083c07ff4c4, options: {constraints: {
              min: {type: minimum}, mid: {type: number, value: 0}, max: {type: maximum}},
            mirror: true, reverse: false, stepped: false}}, bold: false, italic: false,
        strikethrough: false, fields: [wow_gmv, wow_orders]}, {type: less than, value: 0,
        background_color: '', font_color: "#EA4335", color_application: {collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2,
          palette_id: 4a00499b-c0fe-4b15-a304-4083c07ff4c4, options: {constraints: {
              min: {type: minimum}, mid: {type: number, value: 0}, max: {type: maximum}},
            mirror: true, reverse: false, stepped: false}}, bold: false, italic: false,
        strikethrough: false, fields: [wow_orders, wow_gmv]}]
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
    y_axes: [{label: '', orientation: left, series: [{axisId: orders_cl.count, id: 2021-04-08
              - orders_cl.count, name: 2021-04-08 - Order Order Count}, {axisId: orders_cl.count,
            id: 2021-04-07 - orders_cl.count, name: 2021-04-07 - Order Order Count},
          {axisId: orders_cl.count, id: 2021-04-06 - orders_cl.count, name: 2021-04-06
              - Order Order Count}, {axisId: orders_cl.count, id: 2021-04-05 - orders_cl.count,
            name: 2021-04-05 - Order Order Count}, {axisId: orders_cl.count, id: 2021-04-04
              - orders_cl.count, name: 2021-04-04 - Order Order Count}, {axisId: orders_cl.count,
            id: 2021-04-03 - orders_cl.count, name: 2021-04-03 - Order Order Count},
          {axisId: orders_cl.count, id: 2021-04-02 - orders_cl.count, name: 2021-04-02
              - Order Order Count}, {axisId: orders_cl.count, id: 2021-04-01 - orders_cl.count,
            name: 2021-04-01 - Order Order Count}], showLabels: true, showValues: true,
        unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear},
      {label: !!null '', orientation: right, series: [{axisId: wow, id: 2021-04-08
              - wow, name: 2021-04-08 - WoW}, {axisId: wow, id: 2021-04-07 - wow,
            name: 2021-04-07 - WoW}, {axisId: wow, id: 2021-04-06 - wow, name: 2021-04-06
              - WoW}, {axisId: wow, id: 2021-04-05 - wow, name: 2021-04-05 - WoW},
          {axisId: wow, id: 2021-04-04 - wow, name: 2021-04-04 - WoW}, {axisId: wow,
            id: 2021-04-03 - wow, name: 2021-04-03 - WoW}, {axisId: wow, id: 2021-04-02
              - wow, name: 2021-04-02 - WoW}, {axisId: wow, id: 2021-04-01 - wow,
            name: 2021-04-01 - WoW}], showLabels: true, showValues: true, unpinAxis: false,
        tickDensity: default, tickDensityCustom: 5, type: linear}]
    hidden_series: [2021-04-07 - orders_cl.count, 2021-04-07 - wow, 2021-04-06 -
        orders_cl.count, 2021-04-06 - wow, 2021-04-05 - orders_cl.count, 2021-04-05
        - wow, 2021-04-04 - orders_cl.count, 2021-04-04 - wow, 2021-04-03 - orders_cl.count,
      2021-04-03 - wow, 2021-04-02 - orders_cl.count, 2021-04-02 - wow, 2021-04-01
        - wow, 2021-04-07 - orders_cl.sum_gmv_gross, 2021-04-03 - orders_cl.sum_gmv_gross,
      2021-04-06 - orders_cl.sum_gmv_gross, 2021-04-02 - orders_cl.sum_gmv_gross,
      2021-04-05 - orders_cl.sum_gmv_gross, 2021-04-04 - orders_cl.sum_gmv_gross]
    series_types: {}
    series_point_styles:
      2021-04-08 - wow: diamond
    defaults_version: 1
    hidden_fields: []
    column_order: []
    listen:
      Warehouse - DE: hubs.hub_name
      Hour: orders_cl.hour
    row: 8
    col: 0
    width: 24
    height: 12
  - name: Hourly orders real-time comparison - FR
    title: Hourly orders real-time comparison - FR
    model: flink_v3
    explore: orders_cl
    type: looker_line
    fields: [orders_cl.created_date, orders_cl.hour, orders_cl.count]
    pivots: [orders_cl.created_date]
    fill_fields: [orders_cl.created_date]
    filters:
      orders_cl.status: fulfilled
      orders_cl.created_date: today, 7 days ago
      orders_cl.is_successful_order: Yes
      orders_cl.country_iso: FR
    sorts: [orders_cl.created_date desc, orders_cl.hour]
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
    hide_legend: true
    defaults_version: 1
    hidden_fields: []
    y_axes: []
    listen:
      Warehouse - FR: hubs.hub_name
      Hour: orders_cl.hour
    row: 40
    col: 0
    width: 12
    height: 7
  - name: Hourly real-time comparison (Tabular) - FR
    title: Hourly real-time comparison (Tabular) - FR
    model: flink_v3
    explore: orders_cl
    type: looker_grid
    fields: [orders_cl.created_date, orders_cl.hour, orders_cl.count, orders_cl.sum_gmv_gross]
    pivots: [orders_cl.created_date]
    filters:
      orders_cl.status: fulfilled
      orders_cl.created_date: today, 7 days ago, 14 days ago, 21 days ago
      orders_cl.is_successful_order: Yes
      orders_cl.country_iso: FR
    sorts: [orders_cl.created_date desc, orders_cl.hour]
    limit: 500
    dynamic_fields: [{_kind_hint: measure, table_calculation: wow_gmv, _type_hint: number,
        category: table_calculation, expression: "(${orders_cl.sum_gmv_gross} -\
          \ pivot_offset(${orders_cl.sum_gmv_gross}, 1)) / pivot_offset(${orders_cl.sum_gmv_gross},\
          \ 1)", label: WoW - GMV, value_format: '"▲  "+0%; "▼  "-0%; 0', value_format_name: !!null ''},
      {_kind_hint: measure, table_calculation: wow_orders, _type_hint: number, category: table_calculation,
        expression: "(${orders_cl.count} - pivot_offset(${orders_cl.count}, 1))\
          \ / pivot_offset(${orders_cl.count}, 1)", label: WoW - Orders, value_format: '"▲  "+0%;
          "▼  "-0%; 0', value_format_name: !!null ''}]
    query_timezone: Europe/Berlin
    show_view_names: false
    show_row_numbers: false
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
    conditional_formatting_include_totals: true
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    series_column_widths:
      orders_cl.count: 90
      orders_cl.hour: 118
      orders_cl.sum_gmv_gross: 86
      wow_gmv: 82
      wow_orders: 81
    series_cell_visualizations:
      orders_cl.count:
        is_active: false
    conditional_formatting: [{type: greater than, value: 0, background_color: '',
        font_color: "#7CB342", color_application: {collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2,
          palette_id: 56d0c358-10a0-4fd6-aa0b-b117bef527ab}, bold: false, italic: false,
        strikethrough: false, fields: [wow_gmv, wow_orders]}, {type: less than, value: 0,
        background_color: '', font_color: "#EA4335", color_application: {collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2,
          palette_id: 56d0c358-10a0-4fd6-aa0b-b117bef527ab}, bold: false, italic: false,
        strikethrough: false, fields: [wow_gmv, wow_orders]}]
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
    hide_legend: true
    legend_position: center
    series_types: {}
    point_style: none
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    column_order: [orders_cl.hour, 2021-05-20_orders_cl.count, 2021-05-20_orders_cl.sum_gmv_gross,
      2021-05-20_wow_orders, 2021-05-20_wow_gmv, 2021-05-13_orders_cl.count, 2021-05-13_orders_cl.sum_gmv_gross,
      2021-05-13_wow_orders, 2021-05-13_wow_gmv]
    hidden_fields: []
    y_axes: []
    listen:
      Warehouse - FR: hubs.hub_name
      Hour: orders_cl.hour
    row: 47
    col: 0
    width: 24
    height: 10
  - name: Hourly GMV real-time comparison - FR
    title: Hourly GMV real-time comparison - FR
    model: flink_v3
    explore: orders_cl
    type: looker_line
    fields: [orders_cl.created_date, orders_cl.sum_gmv_gross, orders_cl.hour]
    pivots: [orders_cl.created_date]
    fill_fields: [orders_cl.created_date]
    filters:
      orders_cl.status: fulfilled
      orders_cl.created_date: today, 7 days ago
      orders_cl.is_successful_order: Yes
      orders_cl.country_iso: FR
    sorts: [orders_cl.created_date desc, orders_cl.hour]
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
    hide_legend: true
    defaults_version: 1
    hidden_fields: []
    y_axes: []
    listen:
      Warehouse - FR: hubs.hub_name
      Hour: orders_cl.hour
    row: 40
    col: 12
    width: 12
    height: 7
  - name: France
    type: text
    title_text: France
    subtitle_text: ''
    body_text: ''
    row: 38
    col: 0
    width: 24
    height: 2
  filters:
  - name: Warehouse - DE
    title: Warehouse - DE
    type: field_filter
    default_value: ''
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
  - name: Warehouse - NL
    title: Warehouse - NL
    type: field_filter
    default_value: ''
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
  - name: Warehouse - FR
    title: Warehouse - FR
    type: field_filter
    default_value: ''
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
  - name: Hour
    title: Hour
    type: field_filter
    default_value: '1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24'
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: popover
      options:
      - '1'
      - '2'
      - '3'
      - '4'
      - '5'
      - '6'
      - '7'
      - '8'
      - '9'
      - '10'
      - '11'
      - '12'
      - '13'
      - '14'
      - '15'
      - '16'
      - '17'
      - '18'
      - '19'
      - '20'
      - '21'
      - '22'
      - '23'
      - '24'
    model: flink_v3
    explore: orders_cl
    listens_to_filters: []
    field: orders_cl.hour
