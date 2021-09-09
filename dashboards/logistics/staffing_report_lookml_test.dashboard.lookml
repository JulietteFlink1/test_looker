- dashboard: staffing_report_lookml_test
  title: Staffing Report
  layout: newspaper
  preferred_viewer: dashboards-next
  crossfilter_enabled: true
  elements:
  - name: Staffing KPIs
    title: Staffing KPIs
    model: flink_v3
    explore: rider_staffing_report
    type: looker_area
    fields: [rider_staffing_report.block_starts_pivot, rider_staffing_report.KPI_filled,
      rider_staffing_report.KPI_forecasted, rider_staffing_report.KPI_planned]
    filters: {}
    sorts: [rider_staffing_report.block_starts_pivot desc]
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
    series_types: {}
    series_labels:
      rider_staffing_report.KPI_planned: Open
    defaults_version: 1
    hidden_fields: []
    y_axes: []
    listen:
      Country: hubs.country
      City: hubs.city
      Hub Name: hubs.hub_name
      Date: rider_staffing_report.date
      "* KPI Parameter *": rider_staffing_report.KPI_parameter
      Rider UTR: rider_staffing_report.rider_UTR
    row: 0
    col: 0
    width: 24
    height: 15
  - name: ''
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: |-
      **D (Delta) = Forecasted - Filled**

      **O (Overstaffed Ratio)= # Blocks Overstaffed / # Blocks**

      **U (Understaffed Ratio)= # Blocks Understaffed / # Blocks**

      **Notice that O + U does not necessarily add up to 1 since D (Forecasted - Filled) can be 0**
    row: 15
    col: 0
    width: 24
    height: 3
  - title: Shifts Table
    name: Shifts Table
    model: flink_v3
    explore: rider_staffing_report
    type: looker_grid
    fields: [rider_staffing_report.dynamic_timeline_base, rider_staffing_report.KPI_forecasted,
      rider_staffing_report.KPI_filled, rider_staffing_report.block_starts_pivot]
    pivots: [rider_staffing_report.block_starts_pivot]
    filters:
      rider_staffing_report.block_ends_pivot: after 2021/01/01 07:00
      rider_staffing_report.block_starts_pivot: after 2021/01/01 07:00
      rider_staffing_report.null_filter: 'No'
    sorts: [rider_staffing_report.block_starts_pivot, avg_under_staffing desc 0]
    limit: 5000
    column_limit: 50
    dynamic_fields: [{_kind_hint: measure, table_calculation: d, _type_hint: number,
        category: table_calculation, description: Forecasted - Filled, expression: "${rider_staffing_report.KPI_forecasted}\
          \ - ${rider_staffing_report.KPI_filled}", label: D, value_format: !!null '',
        value_format_name: id}, {_kind_hint: supermeasure, table_calculation: avg_over_staffing,
        _type_hint: number, category: table_calculation, expression: 'mean(pivot_row(if(${d}
          < 0, 1, 0)))', label: avg over staffing, value_format: !!null '', value_format_name: percent_0},
      {_kind_hint: supermeasure, table_calculation: avg_under_staffing, _type_hint: number,
        category: table_calculation, expression: 'mean(pivot_row(if(${d} > 0, 1, 0)))',
        label: avg under staffing, value_format: !!null '', value_format_name: percent_0}]
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
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    column_order: [rider_staffing_report.dynamic_timeline_base, avg_over_staffing,
      avg_under_staffing, '2021-01-01 07:30:00_d', '2021-01-01 08:00:00_d', '2021-01-01
        08:30:00_d', '2021-01-01 09:00:00_d', '2021-01-01 09:30:00_d', '2021-01-01
        10:00:00_d', '2021-01-01 10:30:00_d', '2021-01-01 11:00:00_d', '2021-01-01
        11:30:00_d', '2021-01-01 12:00:00_d', '2021-01-01 12:30:00_d', '2021-01-01
        13:00:00_d', '2021-01-01 13:30:00_d', '2021-01-01 14:00:00_d', '2021-01-01
        14:30:00_d', '2021-01-01 15:00:00_d', '2021-01-01 15:30:00_d', '2021-01-01
        16:00:00_d', '2021-01-01 16:30:00_d', '2021-01-01 17:00:00_d', '2021-01-01
        17:30:00_d', '2021-01-01 18:00:00_d', '2021-01-01 18:30:00_d', '2021-01-01
        19:00:00_d', '2021-01-01 19:30:00_d', '2021-01-01 20:00:00_d', '2021-01-01
        20:30:00_d', '2021-01-01 21:00:00_d', '2021-01-01 21:30:00_d', '2021-01-01
        22:00:00_d', '2021-01-01 22:30:00_d', '2021-01-01 23:00:00_d']
    show_totals: true
    show_row_totals: true
    series_labels:
      avg_over_staffing: O
      avg_under_staffing: U
    series_column_widths:
      rider_staffing_report_v2.dynamic_timeline_base: 203
      delta: 65
      forecasted_filled: 57
      d: 50
      rider_staffing_report.dynamic_timeline_base: 84
    conditional_formatting: [{type: along a scale..., value: !!null '', background_color: "#1A73E8",
        font_color: !!null '', color_application: {collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2,
          palette_id: 4a00499b-c0fe-4b15-a304-4083c07ff4c4, options: {steps: 5, constraints: {
              min: {type: minimum}, mid: {type: number, value: 0}, max: {type: maximum}},
            mirror: true, reverse: false, stepped: false}}, bold: false, italic: false,
        strikethrough: false, fields: [d]}, {type: greater than, value: 0.5, background_color: '',
        font_color: "#EA4335", color_application: {collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2,
          palette_id: 4a00499b-c0fe-4b15-a304-4083c07ff4c4, options: {constraints: {
              min: {type: minimum}, mid: {type: number, value: 0}, max: {type: maximum}},
            mirror: true, reverse: false, stepped: false}}, bold: false, italic: false,
        strikethrough: false, fields: [avg_over_staffing]}, {type: greater than, value: 0.5,
        background_color: '', font_color: "#1A73E8", color_application: {collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2,
          palette_id: 4a00499b-c0fe-4b15-a304-4083c07ff4c4, options: {constraints: {
              min: {type: minimum}, mid: {type: number, value: 0}, max: {type: maximum}},
            mirror: true, reverse: false, stepped: false}}, bold: false, italic: false,
        strikethrough: false, fields: [avg_under_staffing]}]
    groupBars: true
    labelSize: 10pt
    valueFormat: hh:mm
    showLegend: true
    hidden_fields: [rider_staffing_report.KPI_forecasted, rider_staffing_report.KPI_filled]
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
    y_axes: []
    listen:
      Timeline Base: rider_staffing_report.timeline_base
      Country: hubs.country
      City: hubs.city
      Hub Name: hubs.hub_name
      Date: rider_staffing_report.date
      "* KPI Parameter *": rider_staffing_report.KPI_parameter
      Rider UTR: rider_staffing_report.rider_UTR
    row: 18
    col: 0
    width: 24
    height: 60
  - title: Hubs Summary
    name: Hubs Summary
    model: flink_v3
    explore: rider_staffing_report
    type: looker_grid
    fields: [hubs.hub_name, rider_staffing_report.over_kpi, rider_staffing_report.under_kpi]
    filters:
      rider_staffing_report.block_starts_pivot: after 2021/01/01 07:00
      rider_staffing_report.block_ends_pivot: after 2021/01/01 07:00
      rider_staffing_report.null_filter: 'No'
    sorts: [rider_staffing_report.under_kpi desc]
    limit: 5000
    column_limit: 50
    dynamic_fields: [{_kind_hint: measure, table_calculation: d, _type_hint: number,
        category: table_calculation, description: Forecasted - Filled, expression: "${rider_staffing_report.KPI_forecasted}\
          \ - ${rider_staffing_report.KPI_filled}", label: D, value_format: !!null '',
        value_format_name: id, is_disabled: true}, {_kind_hint: supermeasure, table_calculation: avg_over_staffing,
        _type_hint: number, category: table_calculation, expression: 'mean(pivot_row(if(${d}
          < 0, 1, 0)))', label: avg over staffing, value_format: !!null '', value_format_name: percent_0,
        is_disabled: true}, {_kind_hint: supermeasure, table_calculation: avg_under_staffing,
        _type_hint: number, category: table_calculation, expression: 'mean(pivot_row(if(${d}
          > 0, 1, 0)))', label: avg under staffing, value_format: !!null '', value_format_name: percent_0,
        is_disabled: true}]
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
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    column_order: [rider_staffing_report.dynamic_timeline_base, avg_over_staffing,
      avg_under_staffing, '2021-01-01 07:30:00_d', '2021-01-01 08:00:00_d', '2021-01-01
        08:30:00_d', '2021-01-01 09:00:00_d', '2021-01-01 09:30:00_d', '2021-01-01
        10:00:00_d', '2021-01-01 10:30:00_d', '2021-01-01 11:00:00_d', '2021-01-01
        11:30:00_d', '2021-01-01 12:00:00_d', '2021-01-01 12:30:00_d', '2021-01-01
        13:00:00_d', '2021-01-01 13:30:00_d', '2021-01-01 14:00:00_d', '2021-01-01
        14:30:00_d', '2021-01-01 15:00:00_d', '2021-01-01 15:30:00_d', '2021-01-01
        16:00:00_d', '2021-01-01 16:30:00_d', '2021-01-01 17:00:00_d', '2021-01-01
        17:30:00_d', '2021-01-01 18:00:00_d', '2021-01-01 18:30:00_d', '2021-01-01
        19:00:00_d', '2021-01-01 19:30:00_d', '2021-01-01 20:00:00_d', '2021-01-01
        20:30:00_d', '2021-01-01 21:00:00_d', '2021-01-01 21:30:00_d', '2021-01-01
        22:00:00_d', '2021-01-01 22:30:00_d', '2021-01-01 23:00:00_d']
    show_totals: true
    show_row_totals: true
    series_labels:
      avg_over_staffing: O
      avg_under_staffing: U
    series_column_widths:
      rider_staffing_report_v2.dynamic_timeline_base: 203
      delta: 65
      forecasted_filled: 57
      d: 50
      rider_staffing_report.dynamic_timeline_base: 84
    series_cell_visualizations:
      rider_staffing_report.over_kpi:
        is_active: false
    series_text_format:
      rider_staffing_report.over_kpi:
        align: center
      rider_staffing_report.under_kpi:
        align: center
    conditional_formatting: [{type: along a scale..., value: !!null '', background_color: "#1A73E8",
        font_color: !!null '', color_application: {collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2,
          palette_id: 4a00499b-c0fe-4b15-a304-4083c07ff4c4, options: {steps: 5, constraints: {
              min: {type: minimum}, mid: {type: number, value: 0}, max: {type: maximum}},
            mirror: true, reverse: false, stepped: false}}, bold: false, italic: false,
        strikethrough: false, fields: []}, {type: greater than, value: 0.5, background_color: '',
        font_color: "#EA4335", color_application: {collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2,
          palette_id: 4a00499b-c0fe-4b15-a304-4083c07ff4c4, options: {constraints: {
              min: {type: minimum}, mid: {type: number, value: 0}, max: {type: maximum}},
            mirror: true, reverse: false, stepped: false}}, bold: false, italic: false,
        strikethrough: false, fields: [rider_staffing_report.over_kpi]}, {type: greater
          than, value: 0.5, background_color: '', font_color: "#1A73E8", color_application: {
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2, palette_id: 4a00499b-c0fe-4b15-a304-4083c07ff4c4,
          options: {constraints: {min: {type: minimum}, mid: {type: number, value: 0},
              max: {type: maximum}}, mirror: true, reverse: false, stepped: false}},
        bold: false, italic: false, strikethrough: false, fields: [rider_staffing_report.under_kpi]}]
    groupBars: true
    labelSize: 10pt
    valueFormat: hh:mm
    showLegend: true
    hidden_fields: []
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
    y_axes: []
    listen:
      Country: hubs.country
      City: hubs.city
      Hub Name: hubs.hub_name
      Date: rider_staffing_report.date
      "* KPI Parameter *": rider_staffing_report.KPI_parameter
      Rider UTR: rider_staffing_report.rider_UTR
    row: 80
    col: 0
    width: 24
    height: 28
  - name: " (2)"
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: "## The below table only displays correct data when selecting a specific\
      \ date. Does not work with a range of dates."
    row: 78
    col: 0
    width: 24
    height: 2
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
    default_value: ''
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
    default_value: ''
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
    default_value: tomorrow
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
  - name: "* KPI Parameter *"
    title: "* KPI Parameter *"
    type: field_filter
    default_value: riders
    allow_multiple_values: true
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
      options: []
    model: flink_v3
    explore: rider_staffing_report
    listens_to_filters: []
    field: rider_staffing_report.KPI_parameter
  - name: Rider UTR
    title: Rider UTR
    type: field_filter
    default_value: '2.5'
    allow_multiple_values: true
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
      options: []
    model: flink_v3
    explore: rider_staffing_report
    listens_to_filters: []
    field: rider_staffing_report.rider_UTR
  - name: Timeline Base
    title: Timeline Base
    type: field_filter
    default_value: Hub
    allow_multiple_values: true
    required: false
    ui_config:
      type: radio_buttons
      display: inline
      options: []
    model: flink_v3
    explore: rider_staffing_report
    listens_to_filters: []
    field: rider_staffing_report.timeline_base
