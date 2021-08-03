- dashboard: 3_nps_migrated
  title: "(3) NPS"
  layout: newspaper
  preferred_viewer: dashboards-next
  elements:
  - title: DE NPS
    name: DE NPS
    model: flink_v3
    explore: orders_cl
    type: marketplace_viz_radial_gauge::radial_gauge-marketplace
    fields: [nps_after_order.nps_score]
    filters:
      hubs.city: ''
      hubs.country: Germany
      orders_cl.is_internal_order: ''
      orders_cl.is_successful_order: ''
      orders_cl.created_day_of_week: ''
      orders_cl.created_week: before 0 weeks ago
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
    range_x: 1.6
    range_y: 1.4
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
      Hub Name: hubs.hub_name
      Order Date: orders_cl.created_date
    row: 0
    col: 0
    width: 8
    height: 6
  - title: NL NPS
    name: NL NPS
    model: flink_v3
    explore: orders_cl
    type: marketplace_viz_radial_gauge::radial_gauge-marketplace
    fields: [nps_after_order.nps_score]
    filters:
      hubs.city: ''
      hubs.country: Netherlands
      orders_cl.is_internal_order: ''
      orders_cl.is_successful_order: ''
      orders_cl.created_day_of_week: ''
      orders_cl.created_week: before 0 weeks ago
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
    range_x: 1.6
    range_y: 1.4
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
      Hub Name: hubs.hub_name
      Order Date: orders_cl.created_date
    row: 0
    col: 8
    width: 8
    height: 6
  - title: FR NPS
    name: FR NPS
    model: flink_v3
    explore: orders_cl
    type: marketplace_viz_radial_gauge::radial_gauge-marketplace
    fields: [nps_after_order.nps_score]
    filters:
      hubs.city: ''
      hubs.country: France
      orders_cl.is_internal_order: ''
      orders_cl.is_successful_order: ''
      orders_cl.created_day_of_week: ''
      orders_cl.created_week: before 0 weeks ago
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
    range_x: 1.6
    range_y: 1.4
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
      Hub Name: hubs.hub_name
      Order Date: orders_cl.created_date
    row: 0
    col: 16
    width: 8
    height: 6
  - title: NPS Timeseries
    name: NPS Timeseries
    model: flink_v3
    explore: orders_cl
    type: looker_line
    fields: [nps_after_order.pct_passives, nps_after_order.pct_detractors, nps_after_order.pct_promoters,
      nps_after_order.cnt_responses, nps_after_order.nps_score, orders_cl.created_week]
    fill_fields: [orders_cl.created_week]
    filters:
      orders_cl.is_internal_order: ''
      orders_cl.is_successful_order: ''
      orders_cl.created_week: before 0 weeks ago
    sorts: [orders_cl.created_week desc]
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
      Hub Name: hubs.hub_name
      Order Date: orders_cl.created_date
      Country: hubs.country
    row: 6
    col: 0
    width: 12
    height: 8
  - title: NPS by Delivery Delay
    name: NPS by Delivery Delay
    model: flink_v3
    explore: orders_cl
    type: looker_column
    fields: [nps_after_order.pct_passives, nps_after_order.pct_detractors, nps_after_order.pct_promoters,
      nps_after_order.cnt_responses, nps_after_order.nps_score, orders_cl.delivery_delay_since_eta]
    filters:
      orders_cl.delivery_delay_since_eta: "<=7 AND >= -7"
      orders_cl.is_internal_order: ''
      orders_cl.is_successful_order: ''
      orders_cl.created_week: before 0 weeks ago
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
      Hub Name: hubs.hub_name
      Order Date: orders_cl.created_date
      Country: hubs.country
    row: 6
    col: 12
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
    explore: orders_cl
    listens_to_filters: []
    field: hubs.country
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
    explore: orders_cl
    listens_to_filters: []
    field: hubs.hub_name
  - name: Order Date
    title: Order Date
    type: field_filter
    default_value: 12 week ago for 12 week
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: inline
      options: []
    model: flink_v3
    explore: orders_cl
    listens_to_filters: []
    field: orders_cl.created_date
