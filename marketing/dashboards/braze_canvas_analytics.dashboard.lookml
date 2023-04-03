- dashboard: braze_canvas_analytics
  title: "Braze Canvas Analytics"
  layout: newspaper
  preferred_viewer: dashboards-next
  description: ''
  preferred_slug: nF8eiUTpq8vjlvYhkK1I4l
  elements:
  - title: Global Overview
    name: Global Overview
    model: flink_v3
    explore: lifecycle_cohorts_reporting
    type: looker_grid
    fields: [braze_lifecycle_cohorts.canvas_name, braze_lifecycle_cohorts.canvas_variation_name,
      braze_lifecycle_cohorts.is_control_group, braze_lifecycle_cohorts.days_canvas_journey_duration,
      braze_lifecycle_cohorts.sum_of_number_of_unique_users, braze_lifecycle_cohorts.sum_of_number_of_unique_orders,
      braze_lifecycle_cohorts.share_of_discounted_orders, braze_lifecycle_cohorts.share_of_customers_ordered,
      braze_lifecycle_cohorts.share_of_customers_visited, braze_lifecycle_cohorts.sum_of_number_of_sent_emails,
      braze_lifecycle_cohorts.share_of_delivered_emails, braze_lifecycle_cohorts.share_of_bounced_emails,
      braze_lifecycle_cohorts.share_of_soft_bounced_emails, braze_lifecycle_cohorts.share_of_generally_opened_emails,
      braze_lifecycle_cohorts.share_of_clicked_emails, braze_lifecycle_cohorts.share_of_clicked_emails_among_opened_emails,
      braze_lifecycle_cohorts.share_of_unsubscribed_emails, braze_lifecycle_cohorts.sum_of_number_of_sent_pushes,
      braze_lifecycle_cohorts.share_of_tapped_pushes, braze_lifecycle_cohorts.share_of_bounced_pushes]
    filters:
      braze_lifecycle_cohorts.is_control_group: ''
    sorts: [braze_lifecycle_cohorts.canvas_name desc, braze_lifecycle_cohorts.canvas_variation_name
        desc]
    limit: 500
    column_limit: 50
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
    show_totals: true
    show_row_totals: true
    truncate_header: false
    series_cell_visualizations:
      braze_lifecycle_cohorts.sum_of_number_of_unique_users:
        is_active: false
    conditional_formatting: [{type: along a scale..., value: !!null '', background_color: "#002855",
        font_color: !!null '', color_application: {collection_id: flink-brand-color-palette,
          palette_id: flink-brand-color-palette-diverging-0, options: {constraints: {
              min: {type: minimum}, mid: {type: number, value: 0}, max: {type: maximum}},
            mirror: true, reverse: false, stepped: false}}, bold: false, italic: false,
        strikethrough: false, fields: !!null ''}]
    series_value_format:
      braze_lifecycle_cohorts.share_of_discounted_orders:
        name: percent_0
        decimals: '0'
        format_string: "#,##0%"
        label: Percent (0)
        label_prefix: Percent
      braze_lifecycle_cohorts.share_of_customers_ordered:
        name: percent_0
        decimals: '0'
        format_string: "#,##0%"
        label: Percent (0)
        label_prefix: Percent
      braze_lifecycle_cohorts.share_of_customers_visited:
        name: percent_0
        decimals: '0'
        format_string: "#,##0%"
        label: Percent (0)
        label_prefix: Percent
      braze_lifecycle_cohorts.share_of_delivered_emails:
        name: percent_0
        decimals: '0'
        format_string: "#,##0%"
        label: Percent (0)
        label_prefix: Percent
      braze_lifecycle_cohorts.share_of_bounced_emails:
        name: percent_0
        decimals: '0'
        format_string: "#,##0%"
        label: Percent (0)
        label_prefix: Percent
      braze_lifecycle_cohorts.share_of_soft_bounced_emails:
        name: percent_0
        decimals: '0'
        format_string: "#,##0%"
        label: Percent (0)
        label_prefix: Percent
      braze_lifecycle_cohorts.share_of_generally_opened_emails:
        name: percent_0
        decimals: '0'
        format_string: "#,##0%"
        label: Percent (0)
        label_prefix: Percent
      braze_lifecycle_cohorts.share_of_clicked_emails:
        name: percent_0
        decimals: '0'
        format_string: "#,##0%"
        label: Percent (0)
        label_prefix: Percent
      braze_lifecycle_cohorts.share_of_clicked_emails_among_opened_emails:
        name: percent_0
        decimals: '0'
        format_string: "#,##0%"
        label: Percent (0)
        label_prefix: Percent
      braze_lifecycle_cohorts.share_of_unsubscribed_emails:
        name: percent_0
        decimals: '0'
        format_string: "#,##0%"
        label: Percent (0)
        label_prefix: Percent
      braze_lifecycle_cohorts.share_of_tapped_pushes:
        name: percent_0
        decimals: '0'
        format_string: "#,##0%"
        label: Percent (0)
        label_prefix: Percent
      braze_lifecycle_cohorts.share_of_bounced_pushes:
        name: percent_0
        decimals: '0'
        format_string: "#,##0%"
        label: Percent (0)
        label_prefix: Percent
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
    x_axis_zoom: true
    y_axis_zoom: true
    trellis: ''
    stacking: normal
    legend_position: center
    series_types: {}
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: true
    show_silhouette: false
    totals_color: "#808080"
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    hidden_pivots: {}
    note_state: collapsed
    note_display: above
    note_text: " Overview on performance and engagement metrics actuals"
    listen:
      Cohort Entry Date: braze_lifecycle_cohorts.cohort_date
      Canvas Name: braze_lifecycle_cohorts.canvas_name
      Canvas Variation - Canvas Level Reporting: braze_lifecycle_cohorts.canvas_variation_name
      Days Canvas Duration: braze_lifecycle_cohorts.days_canvas_journey_duration
    row: 83
    col: 0
    width: 24
    height: 7
  - title: "% Users Ordered"
    name: "% Users Ordered"
    model: flink_v3
    explore: lifecycle_cohorts_reporting
    type: looker_column
    fields: [braze_lifecycle_cohorts.canvas_variation_name, braze_lifecycle_cohorts.share_of_customers_ordered,
      braze_lifecycle_cohorts.cohort_week]
    pivots: [braze_lifecycle_cohorts.canvas_variation_name]
    fill_fields: [braze_lifecycle_cohorts.cohort_week]
    filters:
      braze_lifecycle_cohorts.is_control_group: ''
    sorts: [braze_lifecycle_cohorts.canvas_variation_name, braze_lifecycle_cohorts.cohort_week
        desc]
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
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    y_axes: [{label: '', orientation: left, series: [{axisId: braze_lifecycle_cohorts.share_of_customers_ordered,
            id: 1PN - braze_lifecycle_cohorts.share_of_customers_ordered, name: 1PN},
          {axisId: braze_lifecycle_cohorts.share_of_customers_ordered, id: 2PN - braze_lifecycle_cohorts.share_of_customers_ordered,
            name: 2PN}, {axisId: braze_lifecycle_cohorts.share_of_customers_ordered,
            id: Aggressive - braze_lifecycle_cohorts.share_of_customers_ordered, name: Aggressive},
          {axisId: braze_lifecycle_cohorts.share_of_customers_ordered, id: Chill -
              braze_lifecycle_cohorts.share_of_customers_ordered, name: Chill}, {
            axisId: braze_lifecycle_cohorts.share_of_customers_ordered, id: CODEAPPEARS
              - braze_lifecycle_cohorts.share_of_customers_ordered, name: CODEAPPEARS},
          {axisId: braze_lifecycle_cohorts.share_of_customers_ordered, id: CODEDISPLAYED
              - braze_lifecycle_cohorts.share_of_customers_ordered, name: CODEDISPLAYED},
          {axisId: braze_lifecycle_cohorts.share_of_customers_ordered, id: Control
              - braze_lifecycle_cohorts.share_of_customers_ordered, name: Control},
          {axisId: braze_lifecycle_cohorts.share_of_customers_ordered, id: Evening
              - braze_lifecycle_cohorts.share_of_customers_ordered, name: Evening},
          {axisId: braze_lifecycle_cohorts.share_of_customers_ordered, id: EXISTING
              - braze_lifecycle_cohorts.share_of_customers_ordered, name: EXISTING},
          {axisId: braze_lifecycle_cohorts.share_of_customers_ordered, id: INVERSE
              - braze_lifecycle_cohorts.share_of_customers_ordered, name: INVERSE},
          {axisId: braze_lifecycle_cohorts.share_of_customers_ordered, id: Morning
              - braze_lifecycle_cohorts.share_of_customers_ordered, name: Morning},
          {axisId: braze_lifecycle_cohorts.share_of_customers_ordered, id: no_voucher
              - braze_lifecycle_cohorts.share_of_customers_ordered, name: no_voucher},
          {axisId: braze_lifecycle_cohorts.share_of_customers_ordered, id: NOCODE
              - braze_lifecycle_cohorts.share_of_customers_ordered, name: NOCODE},
          {axisId: braze_lifecycle_cohorts.share_of_customers_ordered, id: NOCODEAPPEARS
              - braze_lifecycle_cohorts.share_of_customers_ordered, name: NOCODEAPPEARS},
          {axisId: braze_lifecycle_cohorts.share_of_customers_ordered, id: Noon -
              braze_lifecycle_cohorts.share_of_customers_ordered, name: Noon}, {axisId: braze_lifecycle_cohorts.share_of_customers_ordered,
            id: VARIANT - braze_lifecycle_cohorts.share_of_customers_ordered, name: VARIANT},
          {axisId: braze_lifecycle_cohorts.share_of_customers_ordered, id: Variant
              1 - braze_lifecycle_cohorts.share_of_customers_ordered, name: Variant
              1}, {axisId: braze_lifecycle_cohorts.share_of_customers_ordered, id: Variant
              2 - braze_lifecycle_cohorts.share_of_customers_ordered, name: Variant
              2}, {axisId: braze_lifecycle_cohorts.share_of_customers_ordered, id: Variant_1
              - braze_lifecycle_cohorts.share_of_customers_ordered, name: Variant_1},
          {axisId: braze_lifecycle_cohorts.share_of_customers_ordered, id: Variant_1PN
              - braze_lifecycle_cohorts.share_of_customers_ordered, name: Variant_1PN},
          {axisId: braze_lifecycle_cohorts.share_of_customers_ordered, id: Variant_2PN
              - braze_lifecycle_cohorts.share_of_customers_ordered, name: Variant_2PN},
          {axisId: braze_lifecycle_cohorts.share_of_customers_ordered, id: Variant1
              - braze_lifecycle_cohorts.share_of_customers_ordered, name: Variant1},
          {axisId: braze_lifecycle_cohorts.share_of_customers_ordered, id: Voucher_up
              - braze_lifecycle_cohorts.share_of_customers_ordered, name: Voucher_up},
          {axisId: braze_lifecycle_cohorts.share_of_customers_ordered, id: WithoutCopy
              - braze_lifecycle_cohorts.share_of_customers_ordered, name: WithoutCopy},
          {axisId: braze_lifecycle_cohorts.share_of_customers_ordered, id: Variant
              3 - braze_lifecycle_cohorts.share_of_customers_ordered, name: Variant
              3}], showLabels: false, showValues: false, maxValue: 1, unpinAxis: false,
        tickDensity: default, tickDensityCustom: 5, type: linear}]
    x_axis_zoom: true
    y_axis_zoom: true
    label_value_format: "#%"
    series_types: {}
    series_colors:
      customers_with_orders_incrementality: "#69aae4"
    reference_lines: []
    trend_lines: []
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    hidden_pivots: {}
    note_state: collapsed
    note_display: above
    note_text: Share of users who placed an order among users that entered the cohort
    listen:
      Cohort Entry Date: braze_lifecycle_cohorts.cohort_date
      Canvas Name: braze_lifecycle_cohorts.canvas_name
      Canvas Variation - Canvas Level Reporting: braze_lifecycle_cohorts.canvas_variation_name
      Days Canvas Duration: braze_lifecycle_cohorts.days_canvas_journey_duration
    row: 45
    col: 0
    width: 12
    height: 7
  - title: "% Users Visited"
    name: "% Users Visited"
    model: flink_v3
    explore: lifecycle_cohorts_reporting
    type: looker_column
    fields: [braze_lifecycle_cohorts.canvas_variation_name, braze_lifecycle_cohorts.share_of_customers_visited,
      braze_lifecycle_cohorts.cohort_week]
    pivots: [braze_lifecycle_cohorts.canvas_variation_name]
    fill_fields: [braze_lifecycle_cohorts.cohort_week]
    filters:
      braze_lifecycle_cohorts.is_control_group: ''
    sorts: [braze_lifecycle_cohorts.canvas_variation_name, braze_lifecycle_cohorts.cohort_week
        desc]
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
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    y_axes: [{label: '', orientation: left, series: [{axisId: braze_lifecycle_cohorts.share_of_customers_visited,
            id: Control - braze_lifecycle_cohorts.share_of_customers_visited, name: Control},
          {axisId: braze_lifecycle_cohorts.share_of_customers_visited, id: INVERSE
              - braze_lifecycle_cohorts.share_of_customers_visited, name: INVERSE},
          {axisId: braze_lifecycle_cohorts.share_of_customers_visited, id: 1PN - braze_lifecycle_cohorts.share_of_customers_visited,
            name: 1PN}, {axisId: braze_lifecycle_cohorts.share_of_customers_visited,
            id: 2PN - braze_lifecycle_cohorts.share_of_customers_visited, name: 2PN},
          {axisId: braze_lifecycle_cohorts.share_of_customers_visited, id: Aggressive
              - braze_lifecycle_cohorts.share_of_customers_visited, name: Aggressive},
          {axisId: braze_lifecycle_cohorts.share_of_customers_visited, id: Chill -
              braze_lifecycle_cohorts.share_of_customers_visited, name: Chill}, {
            axisId: braze_lifecycle_cohorts.share_of_customers_visited, id: CODEAPPEARS
              - braze_lifecycle_cohorts.share_of_customers_visited, name: CODEAPPEARS},
          {axisId: braze_lifecycle_cohorts.share_of_customers_visited, id: CODEDISPLAYED
              - braze_lifecycle_cohorts.share_of_customers_visited, name: CODEDISPLAYED},
          {axisId: braze_lifecycle_cohorts.share_of_customers_visited, id: Evening
              - braze_lifecycle_cohorts.share_of_customers_visited, name: Evening},
          {axisId: braze_lifecycle_cohorts.share_of_customers_visited, id: EXISTING
              - braze_lifecycle_cohorts.share_of_customers_visited, name: EXISTING},
          {axisId: braze_lifecycle_cohorts.share_of_customers_visited, id: Morning
              - braze_lifecycle_cohorts.share_of_customers_visited, name: Morning},
          {axisId: braze_lifecycle_cohorts.share_of_customers_visited, id: no_voucher
              - braze_lifecycle_cohorts.share_of_customers_visited, name: no_voucher},
          {axisId: braze_lifecycle_cohorts.share_of_customers_visited, id: NOCODE
              - braze_lifecycle_cohorts.share_of_customers_visited, name: NOCODE},
          {axisId: braze_lifecycle_cohorts.share_of_customers_visited, id: NOCODEAPPEARS
              - braze_lifecycle_cohorts.share_of_customers_visited, name: NOCODEAPPEARS},
          {axisId: braze_lifecycle_cohorts.share_of_customers_visited, id: Noon -
              braze_lifecycle_cohorts.share_of_customers_visited, name: Noon}, {axisId: braze_lifecycle_cohorts.share_of_customers_visited,
            id: VARIANT - braze_lifecycle_cohorts.share_of_customers_visited, name: VARIANT},
          {axisId: braze_lifecycle_cohorts.share_of_customers_visited, id: Variant
              1 - braze_lifecycle_cohorts.share_of_customers_visited, name: Variant
              1}, {axisId: braze_lifecycle_cohorts.share_of_customers_visited, id: Variant
              2 - braze_lifecycle_cohorts.share_of_customers_visited, name: Variant
              2}, {axisId: braze_lifecycle_cohorts.share_of_customers_visited, id: Variant
              3 - braze_lifecycle_cohorts.share_of_customers_visited, name: Variant
              3}, {axisId: braze_lifecycle_cohorts.share_of_customers_visited, id: Variant_1
              - braze_lifecycle_cohorts.share_of_customers_visited, name: Variant_1},
          {axisId: braze_lifecycle_cohorts.share_of_customers_visited, id: Variant_1PN
              - braze_lifecycle_cohorts.share_of_customers_visited, name: Variant_1PN},
          {axisId: braze_lifecycle_cohorts.share_of_customers_visited, id: Variant_2PN
              - braze_lifecycle_cohorts.share_of_customers_visited, name: Variant_2PN},
          {axisId: braze_lifecycle_cohorts.share_of_customers_visited, id: Variant1
              - braze_lifecycle_cohorts.share_of_customers_visited, name: Variant1},
          {axisId: braze_lifecycle_cohorts.share_of_customers_visited, id: Voucher_up
              - braze_lifecycle_cohorts.share_of_customers_visited, name: Voucher_up},
          {axisId: braze_lifecycle_cohorts.share_of_customers_visited, id: WithoutCopy
              - braze_lifecycle_cohorts.share_of_customers_visited, name: WithoutCopy}],
        showLabels: false, showValues: false, maxValue: 1, unpinAxis: false, tickDensity: default,
        tickDensityCustom: 5, type: linear}]
    x_axis_zoom: true
    y_axis_zoom: true
    label_value_format: "#%"
    series_types: {}
    series_colors:
      Control - braze_lifecycle_cohorts.share_of_customers_visited: "#002855"
      INVERSE - braze_lifecycle_cohorts.share_of_customers_visited: "#e81f76"
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    hidden_pivots: {}
    note_state: collapsed
    note_display: above
    note_text: Share of users who visited the app or web within the cohort's journey
      among users that entered the cohort
    listen:
      Cohort Entry Date: braze_lifecycle_cohorts.cohort_date
      Canvas Name: braze_lifecycle_cohorts.canvas_name
      Canvas Variation - Canvas Level Reporting: braze_lifecycle_cohorts.canvas_variation_name
      Days Canvas Duration: braze_lifecycle_cohorts.days_canvas_journey_duration
    row: 45
    col: 12
    width: 12
    height: 7
  - title: "# Sent Messages"
    name: "# Sent Messages"
    model: flink_v3
    explore: lifecycle_cohorts_reporting
    type: looker_column
    fields: [braze_lifecycle_cohorts.sum_of_number_of_sent_messages, braze_lifecycle_cohorts.cohort_week,
      braze_lifecycle_cohorts.canvas_variation_name]
    pivots: [braze_lifecycle_cohorts.canvas_variation_name]
    fill_fields: [braze_lifecycle_cohorts.cohort_week]
    filters:
      braze_lifecycle_cohorts.is_control_group: 'No'
    sorts: [braze_lifecycle_cohorts.cohort_week, braze_lifecycle_cohorts.canvas_variation_name]
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
    stacking: normal
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: true
    show_silhouette: false
    totals_color: "#808080"
    y_axes: [{label: '', orientation: left, series: [{axisId: 1PN - braze_lifecycle_cohorts.sum_of_number_of_sent_messages,
            id: 1PN - braze_lifecycle_cohorts.sum_of_number_of_sent_messages, name: 1PN},
          {axisId: 2PN - braze_lifecycle_cohorts.sum_of_number_of_sent_messages, id: 2PN
              - braze_lifecycle_cohorts.sum_of_number_of_sent_messages, name: 2PN},
          {axisId: Aggressive - braze_lifecycle_cohorts.sum_of_number_of_sent_messages,
            id: Aggressive - braze_lifecycle_cohorts.sum_of_number_of_sent_messages,
            name: Aggressive}, {axisId: Chill - braze_lifecycle_cohorts.sum_of_number_of_sent_messages,
            id: Chill - braze_lifecycle_cohorts.sum_of_number_of_sent_messages, name: Chill},
          {axisId: CODEAPPEARS - braze_lifecycle_cohorts.sum_of_number_of_sent_messages,
            id: CODEAPPEARS - braze_lifecycle_cohorts.sum_of_number_of_sent_messages,
            name: CODEAPPEARS}, {axisId: CODEDISPLAYED - braze_lifecycle_cohorts.sum_of_number_of_sent_messages,
            id: CODEDISPLAYED - braze_lifecycle_cohorts.sum_of_number_of_sent_messages,
            name: CODEDISPLAYED}, {axisId: Control - braze_lifecycle_cohorts.sum_of_number_of_sent_messages,
            id: Control - braze_lifecycle_cohorts.sum_of_number_of_sent_messages,
            name: Control}, {axisId: Evening - braze_lifecycle_cohorts.sum_of_number_of_sent_messages,
            id: Evening - braze_lifecycle_cohorts.sum_of_number_of_sent_messages,
            name: Evening}, {axisId: EXISTING - braze_lifecycle_cohorts.sum_of_number_of_sent_messages,
            id: EXISTING - braze_lifecycle_cohorts.sum_of_number_of_sent_messages,
            name: EXISTING}, {axisId: INVERSE - braze_lifecycle_cohorts.sum_of_number_of_sent_messages,
            id: INVERSE - braze_lifecycle_cohorts.sum_of_number_of_sent_messages,
            name: INVERSE}, {axisId: Morning - braze_lifecycle_cohorts.sum_of_number_of_sent_messages,
            id: Morning - braze_lifecycle_cohorts.sum_of_number_of_sent_messages,
            name: Morning}, {axisId: no_voucher - braze_lifecycle_cohorts.sum_of_number_of_sent_messages,
            id: no_voucher - braze_lifecycle_cohorts.sum_of_number_of_sent_messages,
            name: no_voucher}, {axisId: NOCODE - braze_lifecycle_cohorts.sum_of_number_of_sent_messages,
            id: NOCODE - braze_lifecycle_cohorts.sum_of_number_of_sent_messages, name: NOCODE},
          {axisId: NOCODEAPPEARS - braze_lifecycle_cohorts.sum_of_number_of_sent_messages,
            id: NOCODEAPPEARS - braze_lifecycle_cohorts.sum_of_number_of_sent_messages,
            name: NOCODEAPPEARS}, {axisId: Noon - braze_lifecycle_cohorts.sum_of_number_of_sent_messages,
            id: Noon - braze_lifecycle_cohorts.sum_of_number_of_sent_messages, name: Noon},
          {axisId: VARIANT - braze_lifecycle_cohorts.sum_of_number_of_sent_messages,
            id: VARIANT - braze_lifecycle_cohorts.sum_of_number_of_sent_messages,
            name: VARIANT}, {axisId: Variant 1 - braze_lifecycle_cohorts.sum_of_number_of_sent_messages,
            id: Variant 1 - braze_lifecycle_cohorts.sum_of_number_of_sent_messages,
            name: Variant 1}, {axisId: Variant 2 - braze_lifecycle_cohorts.sum_of_number_of_sent_messages,
            id: Variant 2 - braze_lifecycle_cohorts.sum_of_number_of_sent_messages,
            name: Variant 2}, {axisId: Variant 3 - braze_lifecycle_cohorts.sum_of_number_of_sent_messages,
            id: Variant 3 - braze_lifecycle_cohorts.sum_of_number_of_sent_messages,
            name: Variant 3}, {axisId: Variant_1 - braze_lifecycle_cohorts.sum_of_number_of_sent_messages,
            id: Variant_1 - braze_lifecycle_cohorts.sum_of_number_of_sent_messages,
            name: Variant_1}, {axisId: Variant_1PN - braze_lifecycle_cohorts.sum_of_number_of_sent_messages,
            id: Variant_1PN - braze_lifecycle_cohorts.sum_of_number_of_sent_messages,
            name: Variant_1PN}, {axisId: Variant_2PN - braze_lifecycle_cohorts.sum_of_number_of_sent_messages,
            id: Variant_2PN - braze_lifecycle_cohorts.sum_of_number_of_sent_messages,
            name: Variant_2PN}, {axisId: Variant1 - braze_lifecycle_cohorts.sum_of_number_of_sent_messages,
            id: Variant1 - braze_lifecycle_cohorts.sum_of_number_of_sent_messages,
            name: Variant1}, {axisId: Voucher_up - braze_lifecycle_cohorts.sum_of_number_of_sent_messages,
            id: Voucher_up - braze_lifecycle_cohorts.sum_of_number_of_sent_messages,
            name: Voucher_up}, {axisId: WithoutCopy - braze_lifecycle_cohorts.sum_of_number_of_sent_messages,
            id: WithoutCopy - braze_lifecycle_cohorts.sum_of_number_of_sent_messages,
            name: WithoutCopy}], showLabels: false, showValues: false, maxValue: !!null '',
        unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear}]
    x_axis_zoom: true
    y_axis_zoom: true
    series_types:
      braze_lifecycle_cohorts.share_of_engaged_messages: line
    series_colors:
      braze_lifecycle_cohorts.number_of_sent_messages: "#fcb2d3"
      braze_lifecycle_cohorts.share_of_engaged_messages: "#002855"
    x_axis_datetime_label: "%b %d"
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    hidden_pivots: {}
    note_state: collapsed
    note_display: above
    note_text: Number of messages sent to variant group users within the cohort's
      journey
    listen:
      Cohort Entry Date: braze_lifecycle_cohorts.cohort_date
      Canvas Name: braze_lifecycle_cohorts.canvas_name
      Canvas Variation - Canvas Level Reporting: braze_lifecycle_cohorts.canvas_variation_name
      Days Canvas Duration: braze_lifecycle_cohorts.days_canvas_journey_duration
    row: 69
    col: 12
    width: 12
    height: 7
  - title: Incrementality (Relative, %) in Users Ordered
    name: Incrementality (Relative, %) in Users Ordered
    model: flink_v3
    explore: lifecycle_cohorts_reporting
    type: looker_line
    fields: [braze_lifecycle_cohorts.cohort_week, braze_lifecycle_cohorts.canvas_variation_name,
      braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_ordered]
    pivots: [braze_lifecycle_cohorts.canvas_variation_name]
    fill_fields: [braze_lifecycle_cohorts.cohort_week]
    filters:
      braze_lifecycle_cohorts.is_control_group: 'No'
    sorts: [braze_lifecycle_cohorts.cohort_week, braze_lifecycle_cohorts.canvas_variation_name]
    limit: 500
    column_limit: 50
    dynamic_fields: [{category: table_calculation, expression: "(pivot_index(${braze_lifecycle_cohorts.share_of_customers_visited},\
          \ 2) - pivot_index(${braze_lifecycle_cohorts.share_of_customers_visited},\
          \ 1))*100", label: Customers Visited Incrementality, value_format: !!null '',
        value_format_name: decimal_2, _kind_hint: supermeasure, table_calculation: customers_visited_incrementality,
        _type_hint: number, is_disabled: true}, {category: table_calculation, expression: "(pivot_index(${braze_lifecycle_cohorts.share_of_customers_ordered},\
          \ 2) - pivot_index(${braze_lifecycle_cohorts.share_of_customers_ordered},\
          \ 1))*100", label: Customers Ordered Incrementality, value_format: !!null '',
        value_format_name: decimal_2, _kind_hint: supermeasure, table_calculation: customers_ordered_incrementality,
        _type_hint: number, is_disabled: true}]
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
    y_axes: [{label: '', orientation: left, series: [{axisId: braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_ordered,
            id: 1PN - braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_ordered,
            name: 1PN}, {axisId: braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_ordered,
            id: 2PN - braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_ordered,
            name: 2PN}, {axisId: braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_ordered,
            id: Aggressive - braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_ordered,
            name: Aggressive}, {axisId: braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_ordered,
            id: Chill - braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_ordered,
            name: Chill}, {axisId: braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_ordered,
            id: CODEAPPEARS - braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_ordered,
            name: CODEAPPEARS}, {axisId: braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_ordered,
            id: CODEDISPLAYED - braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_ordered,
            name: CODEDISPLAYED}, {axisId: braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_ordered,
            id: Evening - braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_ordered,
            name: Evening}, {axisId: braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_ordered,
            id: EXISTING - braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_ordered,
            name: EXISTING}, {axisId: braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_ordered,
            id: INVERSE - braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_ordered,
            name: INVERSE}, {axisId: braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_ordered,
            id: Morning - braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_ordered,
            name: Morning}, {axisId: braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_ordered,
            id: no_voucher - braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_ordered,
            name: no_voucher}, {axisId: braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_ordered,
            id: NOCODE - braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_ordered,
            name: NOCODE}, {axisId: braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_ordered,
            id: NOCODEAPPEARS - braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_ordered,
            name: NOCODEAPPEARS}, {axisId: braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_ordered,
            id: Noon - braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_ordered,
            name: Noon}, {axisId: braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_ordered,
            id: VARIANT - braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_ordered,
            name: VARIANT}, {axisId: braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_ordered,
            id: Variant 1 - braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_ordered,
            name: Variant 1}, {axisId: braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_ordered,
            id: Variant 2 - braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_ordered,
            name: Variant 2}, {axisId: braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_ordered,
            id: Variant_1 - braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_ordered,
            name: Variant_1}, {axisId: braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_ordered,
            id: Variant_1PN - braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_ordered,
            name: Variant_1PN}, {axisId: braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_ordered,
            id: Variant_2PN - braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_ordered,
            name: Variant_2PN}, {axisId: braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_ordered,
            id: Variant1 - braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_ordered,
            name: Variant1}, {axisId: braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_ordered,
            id: Voucher_up - braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_ordered,
            name: Voucher_up}, {axisId: braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_ordered,
            id: WithoutCopy - braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_ordered,
            name: WithoutCopy}, {axisId: braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_ordered,
            id: Control - braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_ordered,
            name: Control}, {axisId: braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_ordered,
            id: Variant 3 - braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_ordered,
            name: Variant 3}], showLabels: false, showValues: false, unpinAxis: false,
        tickDensity: default, type: linear}]
    x_axis_zoom: true
    y_axis_zoom: true
    label_value_format: "#%"
    series_types:
      INVERSE - braze_lifecycle_cohorts.incrementality_of_share_of_customers_ordered: area
    series_colors:
      customers_with_orders_incrementality: "#69aae4"
      customers_visited_incrementality: "#69aae4"
      customers_ordered_incrementality: "#fcb2d3"
      braze_lifecycle_cohorts.incrementality_of_share_of_customers_ordered: "#69aae4"
      braze_lifecycle_cohorts.incrementality_of_share_of_customers_visited: "#ffb063"
    reference_lines: []
    trend_lines: []
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    hidden_pivots: {}
    note_state: collapsed
    note_display: above
    note_text: "% increase in share of users who placed an order in variant group\
      \ compared to control group"
    listen:
      Cohort Entry Date: braze_lifecycle_cohorts.cohort_date
      Canvas Name: braze_lifecycle_cohorts.canvas_name
      Canvas Variation - Canvas Level Reporting: braze_lifecycle_cohorts.canvas_variation_name
      Days Canvas Duration: braze_lifecycle_cohorts.days_canvas_journey_duration
    row: 55
    col: 0
    width: 12
    height: 7
  - title: "# Cohort Users"
    name: "# Cohort Users"
    model: flink_v3
    explore: lifecycle_cohorts_reporting
    type: looker_column
    fields: [braze_lifecycle_cohorts.cohort_date, braze_lifecycle_cohorts.sum_of_number_of_unique_users,
      braze_lifecycle_cohorts.canvas_variation_name]
    pivots: [braze_lifecycle_cohorts.canvas_variation_name]
    fill_fields: [braze_lifecycle_cohorts.cohort_date]
    filters:
      braze_lifecycle_cohorts.is_control_group: ''
    sorts: [braze_lifecycle_cohorts.cohort_date desc, braze_lifecycle_cohorts.canvas_variation_name]
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
    stacking: normal
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: true
    show_silhouette: false
    totals_color: "#808080"
    y_axes: [{label: '', orientation: left, series: [{axisId: 1PN - braze_lifecycle_cohorts.sum_of_number_of_unique_users,
            id: 1PN - braze_lifecycle_cohorts.sum_of_number_of_unique_users, name: 1PN},
          {axisId: 2PN - braze_lifecycle_cohorts.sum_of_number_of_unique_users, id: 2PN
              - braze_lifecycle_cohorts.sum_of_number_of_unique_users, name: 2PN},
          {axisId: Aggressive - braze_lifecycle_cohorts.sum_of_number_of_unique_users,
            id: Aggressive - braze_lifecycle_cohorts.sum_of_number_of_unique_users,
            name: Aggressive}, {axisId: Chill - braze_lifecycle_cohorts.sum_of_number_of_unique_users,
            id: Chill - braze_lifecycle_cohorts.sum_of_number_of_unique_users, name: Chill},
          {axisId: CODEAPPEARS - braze_lifecycle_cohorts.sum_of_number_of_unique_users,
            id: CODEAPPEARS - braze_lifecycle_cohorts.sum_of_number_of_unique_users,
            name: CODEAPPEARS}, {axisId: CODEDISPLAYED - braze_lifecycle_cohorts.sum_of_number_of_unique_users,
            id: CODEDISPLAYED - braze_lifecycle_cohorts.sum_of_number_of_unique_users,
            name: CODEDISPLAYED}, {axisId: Control - braze_lifecycle_cohorts.sum_of_number_of_unique_users,
            id: Control - braze_lifecycle_cohorts.sum_of_number_of_unique_users, name: Control},
          {axisId: Evening - braze_lifecycle_cohorts.sum_of_number_of_unique_users,
            id: Evening - braze_lifecycle_cohorts.sum_of_number_of_unique_users, name: Evening},
          {axisId: EXISTING - braze_lifecycle_cohorts.sum_of_number_of_unique_users,
            id: EXISTING - braze_lifecycle_cohorts.sum_of_number_of_unique_users,
            name: EXISTING}, {axisId: INVERSE - braze_lifecycle_cohorts.sum_of_number_of_unique_users,
            id: INVERSE - braze_lifecycle_cohorts.sum_of_number_of_unique_users, name: INVERSE},
          {axisId: Morning - braze_lifecycle_cohorts.sum_of_number_of_unique_users,
            id: Morning - braze_lifecycle_cohorts.sum_of_number_of_unique_users, name: Morning},
          {axisId: no_voucher - braze_lifecycle_cohorts.sum_of_number_of_unique_users,
            id: no_voucher - braze_lifecycle_cohorts.sum_of_number_of_unique_users,
            name: no_voucher}, {axisId: NOCODE - braze_lifecycle_cohorts.sum_of_number_of_unique_users,
            id: NOCODE - braze_lifecycle_cohorts.sum_of_number_of_unique_users, name: NOCODE},
          {axisId: NOCODEAPPEARS - braze_lifecycle_cohorts.sum_of_number_of_unique_users,
            id: NOCODEAPPEARS - braze_lifecycle_cohorts.sum_of_number_of_unique_users,
            name: NOCODEAPPEARS}, {axisId: Noon - braze_lifecycle_cohorts.sum_of_number_of_unique_users,
            id: Noon - braze_lifecycle_cohorts.sum_of_number_of_unique_users, name: Noon},
          {axisId: VARIANT - braze_lifecycle_cohorts.sum_of_number_of_unique_users,
            id: VARIANT - braze_lifecycle_cohorts.sum_of_number_of_unique_users, name: VARIANT},
          {axisId: Variant 1 - braze_lifecycle_cohorts.sum_of_number_of_unique_users,
            id: Variant 1 - braze_lifecycle_cohorts.sum_of_number_of_unique_users,
            name: Variant 1}, {axisId: Variant 2 - braze_lifecycle_cohorts.sum_of_number_of_unique_users,
            id: Variant 2 - braze_lifecycle_cohorts.sum_of_number_of_unique_users,
            name: Variant 2}, {axisId: Variant 3 - braze_lifecycle_cohorts.sum_of_number_of_unique_users,
            id: Variant 3 - braze_lifecycle_cohorts.sum_of_number_of_unique_users,
            name: Variant 3}, {axisId: Variant_1 - braze_lifecycle_cohorts.sum_of_number_of_unique_users,
            id: Variant_1 - braze_lifecycle_cohorts.sum_of_number_of_unique_users,
            name: Variant_1}, {axisId: Variant_1PN - braze_lifecycle_cohorts.sum_of_number_of_unique_users,
            id: Variant_1PN - braze_lifecycle_cohorts.sum_of_number_of_unique_users,
            name: Variant_1PN}, {axisId: Variant_2PN - braze_lifecycle_cohorts.sum_of_number_of_unique_users,
            id: Variant_2PN - braze_lifecycle_cohorts.sum_of_number_of_unique_users,
            name: Variant_2PN}, {axisId: Variant1 - braze_lifecycle_cohorts.sum_of_number_of_unique_users,
            id: Variant1 - braze_lifecycle_cohorts.sum_of_number_of_unique_users,
            name: Variant1}, {axisId: Voucher_up - braze_lifecycle_cohorts.sum_of_number_of_unique_users,
            id: Voucher_up - braze_lifecycle_cohorts.sum_of_number_of_unique_users,
            name: Voucher_up}, {axisId: WithoutCopy - braze_lifecycle_cohorts.sum_of_number_of_unique_users,
            id: WithoutCopy - braze_lifecycle_cohorts.sum_of_number_of_unique_users,
            name: WithoutCopy}], showLabels: true, showValues: false, unpinAxis: false,
        tickDensity: default, tickDensityCustom: 5, type: linear}]
    x_axis_zoom: true
    y_axis_zoom: true
    series_types: {}
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    hidden_pivots: {}
    note_state: collapsed
    note_display: above
    note_text: Number of Braze users who entered the canvas’s cohort aggregated by
      entry date
    listen:
      Cohort Entry Date: braze_lifecycle_cohorts.cohort_date
      Canvas Name: braze_lifecycle_cohorts.canvas_name
      Canvas Variation - Canvas Level Reporting: braze_lifecycle_cohorts.canvas_variation_name
      Days Canvas Duration: braze_lifecycle_cohorts.days_canvas_journey_duration
    row: 34
    col: 0
    width: 24
    height: 9
  - title: Incrementality (Relative, %) in Users Visited
    name: Incrementality (Relative, %) in Users Visited
    model: flink_v3
    explore: lifecycle_cohorts_reporting
    type: looker_line
    fields: [braze_lifecycle_cohorts.cohort_week, braze_lifecycle_cohorts.canvas_variation_name,
      braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_visited]
    pivots: [braze_lifecycle_cohorts.canvas_variation_name]
    fill_fields: [braze_lifecycle_cohorts.cohort_week]
    filters:
      braze_lifecycle_cohorts.is_control_group: 'No'
    sorts: [braze_lifecycle_cohorts.cohort_week, braze_lifecycle_cohorts.canvas_variation_name]
    limit: 500
    column_limit: 50
    dynamic_fields: [{category: table_calculation, expression: "(pivot_index(${braze_lifecycle_cohorts.share_of_customers_visited},\
          \ 2) - pivot_index(${braze_lifecycle_cohorts.share_of_customers_visited},\
          \ 1))*100", label: Customers Visited Incrementality, value_format: !!null '',
        value_format_name: decimal_2, _kind_hint: supermeasure, table_calculation: customers_visited_incrementality,
        _type_hint: number, is_disabled: true}, {category: table_calculation, expression: "(pivot_index(${braze_lifecycle_cohorts.share_of_customers_ordered},\
          \ 2) - pivot_index(${braze_lifecycle_cohorts.share_of_customers_ordered},\
          \ 1))*100", label: Customers Ordered Incrementality, value_format: !!null '',
        value_format_name: decimal_2, _kind_hint: supermeasure, table_calculation: customers_ordered_incrementality,
        _type_hint: number, is_disabled: true}]
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
    y_axes: [{label: '', orientation: right, series: [{axisId: braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_visited,
            id: 1PN - braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_visited,
            name: 1PN}, {axisId: braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_visited,
            id: 2PN - braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_visited,
            name: 2PN}, {axisId: braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_visited,
            id: Aggressive - braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_visited,
            name: Aggressive}, {axisId: braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_visited,
            id: Chill - braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_visited,
            name: Chill}, {axisId: braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_visited,
            id: CODEAPPEARS - braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_visited,
            name: CODEAPPEARS}, {axisId: braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_visited,
            id: CODEDISPLAYED - braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_visited,
            name: CODEDISPLAYED}, {axisId: braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_visited,
            id: Evening - braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_visited,
            name: Evening}, {axisId: braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_visited,
            id: EXISTING - braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_visited,
            name: EXISTING}, {axisId: braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_visited,
            id: INVERSE - braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_visited,
            name: INVERSE}, {axisId: braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_visited,
            id: Morning - braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_visited,
            name: Morning}, {axisId: braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_visited,
            id: no_voucher - braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_visited,
            name: no_voucher}, {axisId: braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_visited,
            id: NOCODE - braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_visited,
            name: NOCODE}, {axisId: braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_visited,
            id: NOCODEAPPEARS - braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_visited,
            name: NOCODEAPPEARS}, {axisId: braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_visited,
            id: Noon - braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_visited,
            name: Noon}, {axisId: braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_visited,
            id: VARIANT - braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_visited,
            name: VARIANT}, {axisId: braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_visited,
            id: Variant 1 - braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_visited,
            name: Variant 1}, {axisId: braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_visited,
            id: Variant 2 - braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_visited,
            name: Variant 2}, {axisId: braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_visited,
            id: Variant_1 - braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_visited,
            name: Variant_1}, {axisId: braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_visited,
            id: Variant_1PN - braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_visited,
            name: Variant_1PN}, {axisId: braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_visited,
            id: Variant_2PN - braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_visited,
            name: Variant_2PN}, {axisId: braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_visited,
            id: Variant1 - braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_visited,
            name: Variant1}, {axisId: braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_visited,
            id: Voucher_up - braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_visited,
            name: Voucher_up}, {axisId: braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_visited,
            id: WithoutCopy - braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_visited,
            name: WithoutCopy}, {axisId: braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_visited,
            id: Control - braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_visited,
            name: Control}, {axisId: braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_visited,
            id: Variant 3 - braze_lifecycle_cohorts.incremental_lift_of_share_of_customers_visited,
            name: Variant 3}], showLabels: false, showValues: false, unpinAxis: false,
        tickDensity: default, type: linear}]
    x_axis_zoom: true
    y_axis_zoom: true
    label_value_format: "#%"
    series_types:
      INVERSE - braze_lifecycle_cohorts.incrementality_of_share_of_customers_visited: area
    series_colors:
      customers_with_orders_incrementality: "#69aae4"
      customers_visited_incrementality: "#69aae4"
      customers_ordered_incrementality: "#fcb2d3"
      braze_lifecycle_cohorts.incrementality_of_share_of_customers_ordered: "#69aae4"
      braze_lifecycle_cohorts.incrementality_of_share_of_customers_visited: "#ffb063"
    reference_lines: []
    trend_lines: []
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    hidden_pivots: {}
    note_state: collapsed
    note_display: above
    note_text: "% increase in share of users who visited app or web in variant group\
      \ compared to control group"
    listen:
      Cohort Entry Date: braze_lifecycle_cohorts.cohort_date
      Canvas Name: braze_lifecycle_cohorts.canvas_name
      Canvas Variation - Canvas Level Reporting: braze_lifecycle_cohorts.canvas_variation_name
      Days Canvas Duration: braze_lifecycle_cohorts.days_canvas_journey_duration
    row: 62
    col: 0
    width: 12
    height: 7
  - title: "# Orders"
    name: "# Orders"
    model: flink_v3
    explore: lifecycle_cohorts_reporting
    type: looker_column
    fields: [braze_lifecycle_cohorts.cohort_week, braze_lifecycle_cohorts.sum_of_number_of_unique_orders,
      braze_lifecycle_cohorts.canvas_variation_name]
    pivots: [braze_lifecycle_cohorts.canvas_variation_name]
    fill_fields: [braze_lifecycle_cohorts.cohort_week]
    filters:
      braze_lifecycle_cohorts.is_control_group: ''
    sorts: [braze_lifecycle_cohorts.cohort_week desc, braze_lifecycle_cohorts.canvas_variation_name]
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
    stacking: normal
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: true
    show_silhouette: false
    totals_color: "#808080"
    y_axes: [{label: '', orientation: left, series: [{axisId: 1PN - braze_lifecycle_cohorts.sum_of_number_of_unique_orders,
            id: 1PN - braze_lifecycle_cohorts.sum_of_number_of_unique_orders, name: 1PN},
          {axisId: 2PN - braze_lifecycle_cohorts.sum_of_number_of_unique_orders, id: 2PN
              - braze_lifecycle_cohorts.sum_of_number_of_unique_orders, name: 2PN},
          {axisId: Aggressive - braze_lifecycle_cohorts.sum_of_number_of_unique_orders,
            id: Aggressive - braze_lifecycle_cohorts.sum_of_number_of_unique_orders,
            name: Aggressive}, {axisId: Chill - braze_lifecycle_cohorts.sum_of_number_of_unique_orders,
            id: Chill - braze_lifecycle_cohorts.sum_of_number_of_unique_orders, name: Chill},
          {axisId: CODEAPPEARS - braze_lifecycle_cohorts.sum_of_number_of_unique_orders,
            id: CODEAPPEARS - braze_lifecycle_cohorts.sum_of_number_of_unique_orders,
            name: CODEAPPEARS}, {axisId: CODEDISPLAYED - braze_lifecycle_cohorts.sum_of_number_of_unique_orders,
            id: CODEDISPLAYED - braze_lifecycle_cohorts.sum_of_number_of_unique_orders,
            name: CODEDISPLAYED}, {axisId: Control - braze_lifecycle_cohorts.sum_of_number_of_unique_orders,
            id: Control - braze_lifecycle_cohorts.sum_of_number_of_unique_orders,
            name: Control}, {axisId: Evening - braze_lifecycle_cohorts.sum_of_number_of_unique_orders,
            id: Evening - braze_lifecycle_cohorts.sum_of_number_of_unique_orders,
            name: Evening}, {axisId: EXISTING - braze_lifecycle_cohorts.sum_of_number_of_unique_orders,
            id: EXISTING - braze_lifecycle_cohorts.sum_of_number_of_unique_orders,
            name: EXISTING}, {axisId: INVERSE - braze_lifecycle_cohorts.sum_of_number_of_unique_orders,
            id: INVERSE - braze_lifecycle_cohorts.sum_of_number_of_unique_orders,
            name: INVERSE}, {axisId: Morning - braze_lifecycle_cohorts.sum_of_number_of_unique_orders,
            id: Morning - braze_lifecycle_cohorts.sum_of_number_of_unique_orders,
            name: Morning}, {axisId: no_voucher - braze_lifecycle_cohorts.sum_of_number_of_unique_orders,
            id: no_voucher - braze_lifecycle_cohorts.sum_of_number_of_unique_orders,
            name: no_voucher}, {axisId: NOCODE - braze_lifecycle_cohorts.sum_of_number_of_unique_orders,
            id: NOCODE - braze_lifecycle_cohorts.sum_of_number_of_unique_orders, name: NOCODE},
          {axisId: NOCODEAPPEARS - braze_lifecycle_cohorts.sum_of_number_of_unique_orders,
            id: NOCODEAPPEARS - braze_lifecycle_cohorts.sum_of_number_of_unique_orders,
            name: NOCODEAPPEARS}, {axisId: Noon - braze_lifecycle_cohorts.sum_of_number_of_unique_orders,
            id: Noon - braze_lifecycle_cohorts.sum_of_number_of_unique_orders, name: Noon},
          {axisId: VARIANT - braze_lifecycle_cohorts.sum_of_number_of_unique_orders,
            id: VARIANT - braze_lifecycle_cohorts.sum_of_number_of_unique_orders,
            name: VARIANT}, {axisId: Variant 1 - braze_lifecycle_cohorts.sum_of_number_of_unique_orders,
            id: Variant 1 - braze_lifecycle_cohorts.sum_of_number_of_unique_orders,
            name: Variant 1}, {axisId: Variant 2 - braze_lifecycle_cohorts.sum_of_number_of_unique_orders,
            id: Variant 2 - braze_lifecycle_cohorts.sum_of_number_of_unique_orders,
            name: Variant 2}, {axisId: Variant 3 - braze_lifecycle_cohorts.sum_of_number_of_unique_orders,
            id: Variant 3 - braze_lifecycle_cohorts.sum_of_number_of_unique_orders,
            name: Variant 3}, {axisId: Variant_1 - braze_lifecycle_cohorts.sum_of_number_of_unique_orders,
            id: Variant_1 - braze_lifecycle_cohorts.sum_of_number_of_unique_orders,
            name: Variant_1}, {axisId: Variant_1PN - braze_lifecycle_cohorts.sum_of_number_of_unique_orders,
            id: Variant_1PN - braze_lifecycle_cohorts.sum_of_number_of_unique_orders,
            name: Variant_1PN}, {axisId: Variant_2PN - braze_lifecycle_cohorts.sum_of_number_of_unique_orders,
            id: Variant_2PN - braze_lifecycle_cohorts.sum_of_number_of_unique_orders,
            name: Variant_2PN}, {axisId: Variant1 - braze_lifecycle_cohorts.sum_of_number_of_unique_orders,
            id: Variant1 - braze_lifecycle_cohorts.sum_of_number_of_unique_orders,
            name: Variant1}, {axisId: Voucher_up - braze_lifecycle_cohorts.sum_of_number_of_unique_orders,
            id: Voucher_up - braze_lifecycle_cohorts.sum_of_number_of_unique_orders,
            name: Voucher_up}, {axisId: WithoutCopy - braze_lifecycle_cohorts.sum_of_number_of_unique_orders,
            id: WithoutCopy - braze_lifecycle_cohorts.sum_of_number_of_unique_orders,
            name: WithoutCopy}], showLabels: false, showValues: false, maxValue: !!null '',
        unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear}]
    x_axis_zoom: true
    y_axis_zoom: true
    series_types:
      Control - braze_lifecycle_cohorts.share_of_discounted_orders: line
      INVERSE - braze_lifecycle_cohorts.share_of_discounted_orders: line
      braze_lifecycle_cohorts.share_of_discounted_orders: line
    series_colors:
      Control - braze_lifecycle_cohorts.number_of_orders: "#002855"
      INVERSE - braze_lifecycle_cohorts.number_of_orders: "#e81f76"
      Control - braze_lifecycle_cohorts.share_of_discounted_orders: "#add0f0"
      INVERSE - braze_lifecycle_cohorts.share_of_discounted_orders: "#fdd8e9"
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    hidden_pivots: {}
    note_state: collapsed
    note_display: above
    note_text: 'Number of orders placed by users within the cohort''s journey '
    listen:
      Cohort Entry Date: braze_lifecycle_cohorts.cohort_date
      Canvas Name: braze_lifecycle_cohorts.canvas_name
      Canvas Variation - Canvas Level Reporting: braze_lifecycle_cohorts.canvas_variation_name
      Days Canvas Duration: braze_lifecycle_cohorts.days_canvas_journey_duration
    row: 69
    col: 0
    width: 12
    height: 7
  - name: ''
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: '[{"type":"p","children":[{"text":"This dashboard provides reporting
      on performance of lifecycle canvases using cohorts. "},{"text":"(!)","color":"hsl(0,
      100%, 50%)","bold":true},{"text":" "},{"text":"It is designed to work with one
      selected canvas at a time.","bold":true,"color":"hsl(0, 100%, 50%)"}],"id":1673618333436},{"type":"p","id":1673595585821,"children":[{"text":"For
      more details about canvas concept, cohorts aggregation and logic behind measurement
      approach visit "},{"type":"a","url":"https://goflink.atlassian.net/wiki/spaces/DATA/pages/471498754/How+to+Measure+Performance+of+CRM+Campaigns+and+Canvases","children":[{"text":"this
      Confluence page with documentation"}],"id":1673595658260},{"text":"."}]},{"type":"p","id":1673618349633,"children":[{"text":"Cohort","bold":true},{"text":"
      is a group of users who entered the canvas on the same date. Entry date of the
      cohort is defined by the canvas setup. End date is defined as a date of the
      last contact of a customer within the cohort + 1 day. KPIs are measured within
      the time window between entry date and end date. "}]},{"type":"p","id":1673449843641,"children":[{"text":"“Variant
      1 - Variation Level Reporting” and “Variant 2 - Variation Level Reporting” filters
      do not apply to the first part of the dashboard and are only used to compare
      canvases with multiple variant groups."}]}]'
    rich_content_json: '{"format":"slate"}'
    row: 0
    col: 0
    width: 24
    height: 4
  - name: " (Copy)"
    type: text
    title_text: " (Copy)"
    subtitle_text: ''
    body_text: '[{"type":"p","id":1673431270514,"children":[{"text":"Measures in visuals
      below are aggregated by week of the cohort entry date to represent general trends
      in basic KPIs."}]}]'
    rich_content_json: '{"format":"slate"}'
    row: 43
    col: 0
    width: 24
    height: 2
  - name: " (Copy 2)"
    type: text
    title_text: " (Copy 2)"
    subtitle_text: ''
    body_text: '[{"type":"p","id":1673431270514,"children":[{"text":"Variation Level
      Reporting","fontSize":"14px","backgroundColor":"rgb(255, 255, 255)","color":"rgb(0,
      0, 0)","bold":true},{"fontSize":"14px","backgroundColor":"rgb(255, 255, 255)","color":"rgb(0,
      0, 0)","text":" - to be used when comparing canvases that have more than 1 variant"},{"text":"
      This is a particular case of variation-specific drilldown when canvas has 2
      variants. \n"}]},{"type":"p","id":1673449434326,"children":[{"bold":true,"text":"How
      to use it: "}]},{"type":"p","id":1673449437458,"children":[{"text":"1) Select
      canvas that you want to see in the Variation Level Reporting part using the
      “Canvas Name” filter"}]},{"type":"p","id":1673449443375,"children":[{"text":"2)
      Select variation that you want to see in the “Variant 1\" column using the “Variation
      Level Reporting - Variant 1” filter. You can choose only one value!"}]},{"type":"p","children":[{"text":"3)
      Select variation that you want to see in the “Variant 2\" column using the “Variation
      Level Reporting - Variant 2” filter. You can choose only one value!"}],"id":1673449421004},{"type":"p","children":[{"text":"Interaction
      with “Canvas Variation - Canvas Level Reporting” filter does not affect this
      part of the dashboard.","bold":true}],"id":1673450082710}]'
    rich_content_json: '{"format":"slate"}'
    row: 90
    col: 0
    width: 24
    height: 4
  - title: "% Discounted Orders"
    name: "% Discounted Orders"
    model: flink_v3
    explore: lifecycle_cohorts_reporting
    type: looker_line
    fields: [braze_lifecycle_cohorts.cohort_week, braze_lifecycle_cohorts.canvas_variation_name,
      braze_lifecycle_cohorts.share_of_discounted_orders]
    pivots: [braze_lifecycle_cohorts.canvas_variation_name]
    fill_fields: [braze_lifecycle_cohorts.cohort_week]
    filters:
      braze_lifecycle_cohorts.is_control_group: 'No'
    sorts: [braze_lifecycle_cohorts.cohort_week, braze_lifecycle_cohorts.canvas_variation_name]
    limit: 500
    column_limit: 50
    dynamic_fields: [{category: table_calculation, expression: "(pivot_index(${braze_lifecycle_cohorts.share_of_customers_visited},\
          \ 2) - pivot_index(${braze_lifecycle_cohorts.share_of_customers_visited},\
          \ 1))*100", label: Customers Visited Incrementality, value_format: !!null '',
        value_format_name: decimal_2, _kind_hint: supermeasure, table_calculation: customers_visited_incrementality,
        _type_hint: number, is_disabled: true}, {category: table_calculation, expression: "(pivot_index(${braze_lifecycle_cohorts.share_of_customers_ordered},\
          \ 2) - pivot_index(${braze_lifecycle_cohorts.share_of_customers_ordered},\
          \ 1))*100", label: Customers Ordered Incrementality, value_format: !!null '',
        value_format_name: decimal_2, _kind_hint: supermeasure, table_calculation: customers_ordered_incrementality,
        _type_hint: number, is_disabled: true}]
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
    y_axes: [{label: '', orientation: left, series: [{axisId: braze_lifecycle_cohorts.share_of_discounted_orders,
            id: 1PN - braze_lifecycle_cohorts.share_of_discounted_orders, name: 1PN},
          {axisId: braze_lifecycle_cohorts.share_of_discounted_orders, id: 2PN - braze_lifecycle_cohorts.share_of_discounted_orders,
            name: 2PN}, {axisId: braze_lifecycle_cohorts.share_of_discounted_orders,
            id: Aggressive - braze_lifecycle_cohorts.share_of_discounted_orders, name: Aggressive},
          {axisId: braze_lifecycle_cohorts.share_of_discounted_orders, id: Chill -
              braze_lifecycle_cohorts.share_of_discounted_orders, name: Chill}, {
            axisId: braze_lifecycle_cohorts.share_of_discounted_orders, id: CODEAPPEARS
              - braze_lifecycle_cohorts.share_of_discounted_orders, name: CODEAPPEARS},
          {axisId: braze_lifecycle_cohorts.share_of_discounted_orders, id: CODEDISPLAYED
              - braze_lifecycle_cohorts.share_of_discounted_orders, name: CODEDISPLAYED},
          {axisId: braze_lifecycle_cohorts.share_of_discounted_orders, id: Evening
              - braze_lifecycle_cohorts.share_of_discounted_orders, name: Evening},
          {axisId: braze_lifecycle_cohorts.share_of_discounted_orders, id: EXISTING
              - braze_lifecycle_cohorts.share_of_discounted_orders, name: EXISTING},
          {axisId: braze_lifecycle_cohorts.share_of_discounted_orders, id: INVERSE
              - braze_lifecycle_cohorts.share_of_discounted_orders, name: INVERSE},
          {axisId: braze_lifecycle_cohorts.share_of_discounted_orders, id: Morning
              - braze_lifecycle_cohorts.share_of_discounted_orders, name: Morning},
          {axisId: braze_lifecycle_cohorts.share_of_discounted_orders, id: no_voucher
              - braze_lifecycle_cohorts.share_of_discounted_orders, name: no_voucher},
          {axisId: braze_lifecycle_cohorts.share_of_discounted_orders, id: NOCODE
              - braze_lifecycle_cohorts.share_of_discounted_orders, name: NOCODE},
          {axisId: braze_lifecycle_cohorts.share_of_discounted_orders, id: NOCODEAPPEARS
              - braze_lifecycle_cohorts.share_of_discounted_orders, name: NOCODEAPPEARS},
          {axisId: braze_lifecycle_cohorts.share_of_discounted_orders, id: Noon -
              braze_lifecycle_cohorts.share_of_discounted_orders, name: Noon}, {axisId: braze_lifecycle_cohorts.share_of_discounted_orders,
            id: VARIANT - braze_lifecycle_cohorts.share_of_discounted_orders, name: VARIANT},
          {axisId: braze_lifecycle_cohorts.share_of_discounted_orders, id: Variant
              1 - braze_lifecycle_cohorts.share_of_discounted_orders, name: Variant
              1}, {axisId: braze_lifecycle_cohorts.share_of_discounted_orders, id: Variant
              2 - braze_lifecycle_cohorts.share_of_discounted_orders, name: Variant
              2}, {axisId: braze_lifecycle_cohorts.share_of_discounted_orders, id: Variant_1
              - braze_lifecycle_cohorts.share_of_discounted_orders, name: Variant_1},
          {axisId: braze_lifecycle_cohorts.share_of_discounted_orders, id: Variant_1PN
              - braze_lifecycle_cohorts.share_of_discounted_orders, name: Variant_1PN},
          {axisId: braze_lifecycle_cohorts.share_of_discounted_orders, id: Variant_2PN
              - braze_lifecycle_cohorts.share_of_discounted_orders, name: Variant_2PN},
          {axisId: braze_lifecycle_cohorts.share_of_discounted_orders, id: Variant1
              - braze_lifecycle_cohorts.share_of_discounted_orders, name: Variant1},
          {axisId: braze_lifecycle_cohorts.share_of_discounted_orders, id: Voucher_up
              - braze_lifecycle_cohorts.share_of_discounted_orders, name: Voucher_up},
          {axisId: braze_lifecycle_cohorts.share_of_discounted_orders, id: WithoutCopy
              - braze_lifecycle_cohorts.share_of_discounted_orders, name: WithoutCopy},
          {axisId: braze_lifecycle_cohorts.share_of_discounted_orders, id: Control
              - braze_lifecycle_cohorts.share_of_discounted_orders, name: Control},
          {axisId: braze_lifecycle_cohorts.share_of_discounted_orders, id: Variant
              3 - braze_lifecycle_cohorts.share_of_discounted_orders, name: Variant
              3}], showLabels: false, showValues: false, unpinAxis: false, tickDensity: default,
        type: linear}]
    x_axis_zoom: true
    y_axis_zoom: true
    label_value_format: "#%"
    series_types:
      INVERSE - braze_lifecycle_cohorts.incrementality_of_share_of_customers_ordered: area
    series_colors:
      customers_with_orders_incrementality: "#69aae4"
      customers_visited_incrementality: "#69aae4"
      customers_ordered_incrementality: "#fcb2d3"
      braze_lifecycle_cohorts.incrementality_of_share_of_customers_ordered: "#69aae4"
      braze_lifecycle_cohorts.incrementality_of_share_of_customers_visited: "#ffb063"
    reference_lines: []
    trend_lines: []
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    hidden_pivots: {}
    note_state: collapsed
    note_display: above
    note_text: Share of orders with discount codes among all orders placed by the
      users within the cohort
    listen:
      Cohort Entry Date: braze_lifecycle_cohorts.cohort_date
      Canvas Name: braze_lifecycle_cohorts.canvas_name
      Canvas Variation - Canvas Level Reporting: braze_lifecycle_cohorts.canvas_variation_name
      Days Canvas Duration: braze_lifecycle_cohorts.days_canvas_journey_duration
    row: 76
    col: 0
    width: 12
    height: 7
  - title: "% Engaged Messages"
    name: "% Engaged Messages"
    model: flink_v3
    explore: lifecycle_cohorts_reporting
    type: looker_line
    fields: [braze_lifecycle_cohorts.cohort_week, braze_lifecycle_cohorts.canvas_variation_name,
      braze_lifecycle_cohorts.share_of_engaged_messages]
    pivots: [braze_lifecycle_cohorts.canvas_variation_name]
    fill_fields: [braze_lifecycle_cohorts.cohort_week]
    filters:
      braze_lifecycle_cohorts.is_control_group: 'No'
    sorts: [braze_lifecycle_cohorts.cohort_week, braze_lifecycle_cohorts.canvas_variation_name]
    limit: 500
    dynamic_fields: [{category: table_calculation, expression: "(pivot_index(${braze_lifecycle_cohorts.share_of_customers_visited},\
          \ 2) - pivot_index(${braze_lifecycle_cohorts.share_of_customers_visited},\
          \ 1))*100", label: Customers Visited Incrementality, value_format: !!null '',
        value_format_name: decimal_2, _kind_hint: supermeasure, table_calculation: customers_visited_incrementality,
        _type_hint: number, is_disabled: true}, {category: table_calculation, expression: "(pivot_index(${braze_lifecycle_cohorts.share_of_customers_ordered},\
          \ 2) - pivot_index(${braze_lifecycle_cohorts.share_of_customers_ordered},\
          \ 1))*100", label: Customers Ordered Incrementality, value_format: !!null '',
        value_format_name: decimal_2, _kind_hint: supermeasure, table_calculation: customers_ordered_incrementality,
        _type_hint: number, is_disabled: true}]
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
    y_axes: [{label: '', orientation: left, series: [{axisId: braze_lifecycle_cohorts.share_of_engaged_messages,
            id: 1PN - braze_lifecycle_cohorts.share_of_engaged_messages, name: 1PN},
          {axisId: braze_lifecycle_cohorts.share_of_engaged_messages, id: 2PN - braze_lifecycle_cohorts.share_of_engaged_messages,
            name: 2PN}, {axisId: braze_lifecycle_cohorts.share_of_engaged_messages,
            id: Aggressive - braze_lifecycle_cohorts.share_of_engaged_messages, name: Aggressive},
          {axisId: braze_lifecycle_cohorts.share_of_engaged_messages, id: Chill -
              braze_lifecycle_cohorts.share_of_engaged_messages, name: Chill}, {axisId: braze_lifecycle_cohorts.share_of_engaged_messages,
            id: CODEAPPEARS - braze_lifecycle_cohorts.share_of_engaged_messages, name: CODEAPPEARS},
          {axisId: braze_lifecycle_cohorts.share_of_engaged_messages, id: CODEDISPLAYED
              - braze_lifecycle_cohorts.share_of_engaged_messages, name: CODEDISPLAYED},
          {axisId: braze_lifecycle_cohorts.share_of_engaged_messages, id: Evening
              - braze_lifecycle_cohorts.share_of_engaged_messages, name: Evening},
          {axisId: braze_lifecycle_cohorts.share_of_engaged_messages, id: EXISTING
              - braze_lifecycle_cohorts.share_of_engaged_messages, name: EXISTING},
          {axisId: braze_lifecycle_cohorts.share_of_engaged_messages, id: INVERSE
              - braze_lifecycle_cohorts.share_of_engaged_messages, name: INVERSE},
          {axisId: braze_lifecycle_cohorts.share_of_engaged_messages, id: Morning
              - braze_lifecycle_cohorts.share_of_engaged_messages, name: Morning},
          {axisId: braze_lifecycle_cohorts.share_of_engaged_messages, id: no_voucher
              - braze_lifecycle_cohorts.share_of_engaged_messages, name: no_voucher},
          {axisId: braze_lifecycle_cohorts.share_of_engaged_messages, id: NOCODE -
              braze_lifecycle_cohorts.share_of_engaged_messages, name: NOCODE}, {
            axisId: braze_lifecycle_cohorts.share_of_engaged_messages, id: NOCODEAPPEARS
              - braze_lifecycle_cohorts.share_of_engaged_messages, name: NOCODEAPPEARS},
          {axisId: braze_lifecycle_cohorts.share_of_engaged_messages, id: Noon - braze_lifecycle_cohorts.share_of_engaged_messages,
            name: Noon}, {axisId: braze_lifecycle_cohorts.share_of_engaged_messages,
            id: VARIANT - braze_lifecycle_cohorts.share_of_engaged_messages, name: VARIANT},
          {axisId: braze_lifecycle_cohorts.share_of_engaged_messages, id: Variant
              1 - braze_lifecycle_cohorts.share_of_engaged_messages, name: Variant
              1}, {axisId: braze_lifecycle_cohorts.share_of_engaged_messages, id: Variant
              2 - braze_lifecycle_cohorts.share_of_engaged_messages, name: Variant
              2}, {axisId: braze_lifecycle_cohorts.share_of_engaged_messages, id: Variant_1
              - braze_lifecycle_cohorts.share_of_engaged_messages, name: Variant_1},
          {axisId: braze_lifecycle_cohorts.share_of_engaged_messages, id: Variant_1PN
              - braze_lifecycle_cohorts.share_of_engaged_messages, name: Variant_1PN},
          {axisId: braze_lifecycle_cohorts.share_of_engaged_messages, id: Variant_2PN
              - braze_lifecycle_cohorts.share_of_engaged_messages, name: Variant_2PN},
          {axisId: braze_lifecycle_cohorts.share_of_engaged_messages, id: Variant1
              - braze_lifecycle_cohorts.share_of_engaged_messages, name: Variant1},
          {axisId: braze_lifecycle_cohorts.share_of_engaged_messages, id: Voucher_up
              - braze_lifecycle_cohorts.share_of_engaged_messages, name: Voucher_up},
          {axisId: braze_lifecycle_cohorts.share_of_engaged_messages, id: WithoutCopy
              - braze_lifecycle_cohorts.share_of_engaged_messages, name: WithoutCopy},
          {axisId: braze_lifecycle_cohorts.share_of_engaged_messages, id: Control
              - braze_lifecycle_cohorts.share_of_engaged_messages, name: Control},
          {axisId: braze_lifecycle_cohorts.share_of_engaged_messages, id: Variant
              3 - braze_lifecycle_cohorts.share_of_engaged_messages, name: Variant
              3}], showLabels: false, showValues: false, unpinAxis: false, tickDensity: default,
        type: linear}]
    x_axis_zoom: true
    y_axis_zoom: true
    series_types:
      INVERSE - braze_lifecycle_cohorts.incrementality_of_share_of_customers_visited: area
    series_colors:
      customers_with_orders_incrementality: "#69aae4"
      customers_visited_incrementality: "#69aae4"
      customers_ordered_incrementality: "#fcb2d3"
      braze_lifecycle_cohorts.incrementality_of_share_of_customers_ordered: "#69aae4"
      braze_lifecycle_cohorts.incrementality_of_share_of_customers_visited: "#ffb063"
    reference_lines: []
    trend_lines: []
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    hidden_pivots: {}
    note_state: collapsed
    note_display: above
    note_text: Share of either tapped or clicked messages among all messages sent
      to variant group
    listen:
      Cohort Entry Date: braze_lifecycle_cohorts.cohort_date
      Canvas Name: braze_lifecycle_cohorts.canvas_name
      Canvas Variation - Canvas Level Reporting: braze_lifecycle_cohorts.canvas_variation_name
      Days Canvas Duration: braze_lifecycle_cohorts.days_canvas_journey_duration
    row: 76
    col: 12
    width: 12
    height: 7
  - title: Incrementality (Absolute, pp) in Users Ordered
    name: Incrementality (Absolute, pp) in Users Ordered
    model: flink_v3
    explore: lifecycle_cohorts_reporting
    type: looker_line
    fields: [braze_lifecycle_cohorts.cohort_week, braze_lifecycle_cohorts.canvas_variation_name,
      braze_lifecycle_cohorts.incrementality_of_share_of_customers_ordered]
    pivots: [braze_lifecycle_cohorts.canvas_variation_name]
    fill_fields: [braze_lifecycle_cohorts.cohort_week]
    filters:
      braze_lifecycle_cohorts.is_control_group: 'No'
    sorts: [braze_lifecycle_cohorts.cohort_week, braze_lifecycle_cohorts.canvas_variation_name]
    limit: 500
    dynamic_fields: [{category: table_calculation, expression: "(pivot_index(${braze_lifecycle_cohorts.share_of_customers_visited},\
          \ 2) - pivot_index(${braze_lifecycle_cohorts.share_of_customers_visited},\
          \ 1))*100", label: Customers Visited Incrementality, value_format: !!null '',
        value_format_name: decimal_2, _kind_hint: supermeasure, table_calculation: customers_visited_incrementality,
        _type_hint: number, is_disabled: true}, {category: table_calculation, expression: "(pivot_index(${braze_lifecycle_cohorts.share_of_customers_ordered},\
          \ 2) - pivot_index(${braze_lifecycle_cohorts.share_of_customers_ordered},\
          \ 1))*100", label: Customers Ordered Incrementality, value_format: !!null '',
        value_format_name: decimal_2, _kind_hint: supermeasure, table_calculation: customers_ordered_incrementality,
        _type_hint: number, is_disabled: true}]
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
    y_axes: [{label: '', orientation: left, series: [{axisId: braze_lifecycle_cohorts.incrementality_of_share_of_customers_ordered,
            id: 1PN - braze_lifecycle_cohorts.incrementality_of_share_of_customers_ordered,
            name: 1PN}, {axisId: braze_lifecycle_cohorts.incrementality_of_share_of_customers_ordered,
            id: 2PN - braze_lifecycle_cohorts.incrementality_of_share_of_customers_ordered,
            name: 2PN}, {axisId: braze_lifecycle_cohorts.incrementality_of_share_of_customers_ordered,
            id: Aggressive - braze_lifecycle_cohorts.incrementality_of_share_of_customers_ordered,
            name: Aggressive}, {axisId: braze_lifecycle_cohorts.incrementality_of_share_of_customers_ordered,
            id: Chill - braze_lifecycle_cohorts.incrementality_of_share_of_customers_ordered,
            name: Chill}, {axisId: braze_lifecycle_cohorts.incrementality_of_share_of_customers_ordered,
            id: CODEAPPEARS - braze_lifecycle_cohorts.incrementality_of_share_of_customers_ordered,
            name: CODEAPPEARS}, {axisId: braze_lifecycle_cohorts.incrementality_of_share_of_customers_ordered,
            id: CODEDISPLAYED - braze_lifecycle_cohorts.incrementality_of_share_of_customers_ordered,
            name: CODEDISPLAYED}, {axisId: braze_lifecycle_cohorts.incrementality_of_share_of_customers_ordered,
            id: Evening - braze_lifecycle_cohorts.incrementality_of_share_of_customers_ordered,
            name: Evening}, {axisId: braze_lifecycle_cohorts.incrementality_of_share_of_customers_ordered,
            id: EXISTING - braze_lifecycle_cohorts.incrementality_of_share_of_customers_ordered,
            name: EXISTING}, {axisId: braze_lifecycle_cohorts.incrementality_of_share_of_customers_ordered,
            id: INVERSE - braze_lifecycle_cohorts.incrementality_of_share_of_customers_ordered,
            name: INVERSE}, {axisId: braze_lifecycle_cohorts.incrementality_of_share_of_customers_ordered,
            id: Morning - braze_lifecycle_cohorts.incrementality_of_share_of_customers_ordered,
            name: Morning}, {axisId: braze_lifecycle_cohorts.incrementality_of_share_of_customers_ordered,
            id: no_voucher - braze_lifecycle_cohorts.incrementality_of_share_of_customers_ordered,
            name: no_voucher}, {axisId: braze_lifecycle_cohorts.incrementality_of_share_of_customers_ordered,
            id: NOCODE - braze_lifecycle_cohorts.incrementality_of_share_of_customers_ordered,
            name: NOCODE}, {axisId: braze_lifecycle_cohorts.incrementality_of_share_of_customers_ordered,
            id: NOCODEAPPEARS - braze_lifecycle_cohorts.incrementality_of_share_of_customers_ordered,
            name: NOCODEAPPEARS}, {axisId: braze_lifecycle_cohorts.incrementality_of_share_of_customers_ordered,
            id: Noon - braze_lifecycle_cohorts.incrementality_of_share_of_customers_ordered,
            name: Noon}, {axisId: braze_lifecycle_cohorts.incrementality_of_share_of_customers_ordered,
            id: VARIANT - braze_lifecycle_cohorts.incrementality_of_share_of_customers_ordered,
            name: VARIANT}, {axisId: braze_lifecycle_cohorts.incrementality_of_share_of_customers_ordered,
            id: Variant 1 - braze_lifecycle_cohorts.incrementality_of_share_of_customers_ordered,
            name: Variant 1}, {axisId: braze_lifecycle_cohorts.incrementality_of_share_of_customers_ordered,
            id: Variant 2 - braze_lifecycle_cohorts.incrementality_of_share_of_customers_ordered,
            name: Variant 2}, {axisId: braze_lifecycle_cohorts.incrementality_of_share_of_customers_ordered,
            id: Variant_1 - braze_lifecycle_cohorts.incrementality_of_share_of_customers_ordered,
            name: Variant_1}, {axisId: braze_lifecycle_cohorts.incrementality_of_share_of_customers_ordered,
            id: Variant_1PN - braze_lifecycle_cohorts.incrementality_of_share_of_customers_ordered,
            name: Variant_1PN}, {axisId: braze_lifecycle_cohorts.incrementality_of_share_of_customers_ordered,
            id: Variant_2PN - braze_lifecycle_cohorts.incrementality_of_share_of_customers_ordered,
            name: Variant_2PN}, {axisId: braze_lifecycle_cohorts.incrementality_of_share_of_customers_ordered,
            id: Variant1 - braze_lifecycle_cohorts.incrementality_of_share_of_customers_ordered,
            name: Variant1}, {axisId: braze_lifecycle_cohorts.incrementality_of_share_of_customers_ordered,
            id: Voucher_up - braze_lifecycle_cohorts.incrementality_of_share_of_customers_ordered,
            name: Voucher_up}, {axisId: braze_lifecycle_cohorts.incrementality_of_share_of_customers_ordered,
            id: WithoutCopy - braze_lifecycle_cohorts.incrementality_of_share_of_customers_ordered,
            name: WithoutCopy}, {axisId: braze_lifecycle_cohorts.incrementality_of_share_of_customers_ordered,
            id: Control - braze_lifecycle_cohorts.incrementality_of_share_of_customers_ordered,
            name: Control}, {axisId: braze_lifecycle_cohorts.incrementality_of_share_of_customers_ordered,
            id: Variant 3 - braze_lifecycle_cohorts.incrementality_of_share_of_customers_ordered,
            name: Variant 3}], showLabels: false, showValues: false, unpinAxis: false,
        tickDensity: default, type: linear}]
    x_axis_zoom: true
    y_axis_zoom: true
    series_types:
      INVERSE - braze_lifecycle_cohorts.incrementality_of_share_of_customers_ordered: area
    series_colors:
      customers_with_orders_incrementality: "#69aae4"
      customers_visited_incrementality: "#69aae4"
      customers_ordered_incrementality: "#fcb2d3"
      braze_lifecycle_cohorts.incrementality_of_share_of_customers_ordered: "#69aae4"
      braze_lifecycle_cohorts.incrementality_of_share_of_customers_visited: "#ffb063"
    reference_lines: []
    trend_lines: []
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    hidden_pivots: {}
    note_state: collapsed
    note_display: above
    note_text: Difference in share of users who placed an order in variant group compared
      to control group
    listen:
      Cohort Entry Date: braze_lifecycle_cohorts.cohort_date
      Canvas Name: braze_lifecycle_cohorts.canvas_name
      Canvas Variation - Canvas Level Reporting: braze_lifecycle_cohorts.canvas_variation_name
      Days Canvas Duration: braze_lifecycle_cohorts.days_canvas_journey_duration
    row: 55
    col: 12
    width: 12
    height: 7
  - title: Incrementality (Absolute, pp) in Users Visited
    name: Incrementality (Absolute, pp) in Users Visited
    model: flink_v3
    explore: lifecycle_cohorts_reporting
    type: looker_line
    fields: [braze_lifecycle_cohorts.cohort_week, braze_lifecycle_cohorts.canvas_variation_name,
      braze_lifecycle_cohorts.incrementality_of_share_of_customers_visited]
    pivots: [braze_lifecycle_cohorts.canvas_variation_name]
    fill_fields: [braze_lifecycle_cohorts.cohort_week]
    filters:
      braze_lifecycle_cohorts.is_control_group: 'No'
    sorts: [braze_lifecycle_cohorts.cohort_week, braze_lifecycle_cohorts.canvas_variation_name]
    limit: 500
    dynamic_fields: [{category: table_calculation, expression: "(pivot_index(${braze_lifecycle_cohorts.share_of_customers_visited},\
          \ 2) - pivot_index(${braze_lifecycle_cohorts.share_of_customers_visited},\
          \ 1))*100", label: Customers Visited Incrementality, value_format: !!null '',
        value_format_name: decimal_2, _kind_hint: supermeasure, table_calculation: customers_visited_incrementality,
        _type_hint: number, is_disabled: true}, {category: table_calculation, expression: "(pivot_index(${braze_lifecycle_cohorts.share_of_customers_ordered},\
          \ 2) - pivot_index(${braze_lifecycle_cohorts.share_of_customers_ordered},\
          \ 1))*100", label: Customers Ordered Incrementality, value_format: !!null '',
        value_format_name: decimal_2, _kind_hint: supermeasure, table_calculation: customers_ordered_incrementality,
        _type_hint: number, is_disabled: true}]
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
    y_axes: [{label: '', orientation: left, series: [{axisId: braze_lifecycle_cohorts.incrementality_of_share_of_customers_visited,
            id: 1PN - braze_lifecycle_cohorts.incrementality_of_share_of_customers_visited,
            name: 1PN}, {axisId: braze_lifecycle_cohorts.incrementality_of_share_of_customers_visited,
            id: 2PN - braze_lifecycle_cohorts.incrementality_of_share_of_customers_visited,
            name: 2PN}, {axisId: braze_lifecycle_cohorts.incrementality_of_share_of_customers_visited,
            id: Aggressive - braze_lifecycle_cohorts.incrementality_of_share_of_customers_visited,
            name: Aggressive}, {axisId: braze_lifecycle_cohorts.incrementality_of_share_of_customers_visited,
            id: Chill - braze_lifecycle_cohorts.incrementality_of_share_of_customers_visited,
            name: Chill}, {axisId: braze_lifecycle_cohorts.incrementality_of_share_of_customers_visited,
            id: CODEAPPEARS - braze_lifecycle_cohorts.incrementality_of_share_of_customers_visited,
            name: CODEAPPEARS}, {axisId: braze_lifecycle_cohorts.incrementality_of_share_of_customers_visited,
            id: CODEDISPLAYED - braze_lifecycle_cohorts.incrementality_of_share_of_customers_visited,
            name: CODEDISPLAYED}, {axisId: braze_lifecycle_cohorts.incrementality_of_share_of_customers_visited,
            id: Evening - braze_lifecycle_cohorts.incrementality_of_share_of_customers_visited,
            name: Evening}, {axisId: braze_lifecycle_cohorts.incrementality_of_share_of_customers_visited,
            id: EXISTING - braze_lifecycle_cohorts.incrementality_of_share_of_customers_visited,
            name: EXISTING}, {axisId: braze_lifecycle_cohorts.incrementality_of_share_of_customers_visited,
            id: INVERSE - braze_lifecycle_cohorts.incrementality_of_share_of_customers_visited,
            name: INVERSE}, {axisId: braze_lifecycle_cohorts.incrementality_of_share_of_customers_visited,
            id: Morning - braze_lifecycle_cohorts.incrementality_of_share_of_customers_visited,
            name: Morning}, {axisId: braze_lifecycle_cohorts.incrementality_of_share_of_customers_visited,
            id: no_voucher - braze_lifecycle_cohorts.incrementality_of_share_of_customers_visited,
            name: no_voucher}, {axisId: braze_lifecycle_cohorts.incrementality_of_share_of_customers_visited,
            id: NOCODE - braze_lifecycle_cohorts.incrementality_of_share_of_customers_visited,
            name: NOCODE}, {axisId: braze_lifecycle_cohorts.incrementality_of_share_of_customers_visited,
            id: NOCODEAPPEARS - braze_lifecycle_cohorts.incrementality_of_share_of_customers_visited,
            name: NOCODEAPPEARS}, {axisId: braze_lifecycle_cohorts.incrementality_of_share_of_customers_visited,
            id: Noon - braze_lifecycle_cohorts.incrementality_of_share_of_customers_visited,
            name: Noon}, {axisId: braze_lifecycle_cohorts.incrementality_of_share_of_customers_visited,
            id: VARIANT - braze_lifecycle_cohorts.incrementality_of_share_of_customers_visited,
            name: VARIANT}, {axisId: braze_lifecycle_cohorts.incrementality_of_share_of_customers_visited,
            id: Variant 1 - braze_lifecycle_cohorts.incrementality_of_share_of_customers_visited,
            name: Variant 1}, {axisId: braze_lifecycle_cohorts.incrementality_of_share_of_customers_visited,
            id: Variant 2 - braze_lifecycle_cohorts.incrementality_of_share_of_customers_visited,
            name: Variant 2}, {axisId: braze_lifecycle_cohorts.incrementality_of_share_of_customers_visited,
            id: Variant_1 - braze_lifecycle_cohorts.incrementality_of_share_of_customers_visited,
            name: Variant_1}, {axisId: braze_lifecycle_cohorts.incrementality_of_share_of_customers_visited,
            id: Variant_1PN - braze_lifecycle_cohorts.incrementality_of_share_of_customers_visited,
            name: Variant_1PN}, {axisId: braze_lifecycle_cohorts.incrementality_of_share_of_customers_visited,
            id: Variant_2PN - braze_lifecycle_cohorts.incrementality_of_share_of_customers_visited,
            name: Variant_2PN}, {axisId: braze_lifecycle_cohorts.incrementality_of_share_of_customers_visited,
            id: Variant1 - braze_lifecycle_cohorts.incrementality_of_share_of_customers_visited,
            name: Variant1}, {axisId: braze_lifecycle_cohorts.incrementality_of_share_of_customers_visited,
            id: Voucher_up - braze_lifecycle_cohorts.incrementality_of_share_of_customers_visited,
            name: Voucher_up}, {axisId: braze_lifecycle_cohorts.incrementality_of_share_of_customers_visited,
            id: WithoutCopy - braze_lifecycle_cohorts.incrementality_of_share_of_customers_visited,
            name: WithoutCopy}, {axisId: braze_lifecycle_cohorts.incrementality_of_share_of_customers_visited,
            id: Control - braze_lifecycle_cohorts.incrementality_of_share_of_customers_visited,
            name: Control}, {axisId: braze_lifecycle_cohorts.incrementality_of_share_of_customers_visited,
            id: Variant 3 - braze_lifecycle_cohorts.incrementality_of_share_of_customers_visited,
            name: Variant 3}], showLabels: false, showValues: false, unpinAxis: false,
        tickDensity: default, type: linear}]
    x_axis_zoom: true
    y_axis_zoom: true
    series_types:
      INVERSE - braze_lifecycle_cohorts.incrementality_of_share_of_customers_visited: area
    series_colors:
      customers_with_orders_incrementality: "#69aae4"
      customers_visited_incrementality: "#69aae4"
      customers_ordered_incrementality: "#fcb2d3"
      braze_lifecycle_cohorts.incrementality_of_share_of_customers_ordered: "#69aae4"
      braze_lifecycle_cohorts.incrementality_of_share_of_customers_visited: "#ffb063"
    reference_lines: []
    trend_lines: []
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    hidden_pivots: {}
    note_state: collapsed
    note_display: above
    note_text: Difference in share of users who visited app or web in variant group
      compared to control group
    listen:
      Cohort Entry Date: braze_lifecycle_cohorts.cohort_date
      Canvas Name: braze_lifecycle_cohorts.canvas_name
      Canvas Variation - Canvas Level Reporting: braze_lifecycle_cohorts.canvas_variation_name
      Days Canvas Duration: braze_lifecycle_cohorts.days_canvas_journey_duration
    row: 62
    col: 12
    width: 12
    height: 7
  - name: " (Copy 3)"
    type: text
    title_text: " (Copy 3)"
    subtitle_text: ''
    body_text: '[{"type":"h2","id":1673431270514,"children":[{"text":"Section 2: Incremental
      Effect"}]},{"type":"p","id":1673436231683,"children":[{"text":""}]},{"type":"p","id":1673436484508,"children":[{"text":"This
      section evaluates the incremental effect of the canvas and answers two questions
      with the help of incrementality-based metrics."}]}]'
    rich_content_json: '{"format":"slate"}'
    row: 52
    col: 0
    width: 24
    height: 3
  - name: " (Copy 4)"
    type: text
    title_text: " (Copy 4)"
    subtitle_text: ''
    body_text: '[{"type":"h2","children":[{"text":"Section 1: User Engagement and
      Order Metrics"}]},{"type":"p","id":1673431270514,"children":[{"text":"\nThis
      section provides an overview on trends and basic stats within canvas."}]}]'
    rich_content_json: '{"format":"slate"}'
    row: 31
    col: 0
    width: 24
    height: 3
  - title: Orders Performance
    name: Orders Performance
    model: flink_v3
    explore: lifecycle_cohorts_reporting
    type: looker_column
    fields: [braze_lifecycle_cohorts.cohort_week, braze_lifecycle_cohorts.sum_of_number_of_unique_orders,
      braze_lifecycle_cohorts.share_of_discounted_orders]
    fill_fields: [braze_lifecycle_cohorts.cohort_week]
    filters:
      braze_lifecycle_cohorts.is_control_group: ''
    sorts: [braze_lifecycle_cohorts.cohort_week desc]
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
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    y_axes: [{label: '', orientation: left, series: [{axisId: braze_lifecycle_cohorts.sum_of_number_of_unique_orders,
            id: braze_lifecycle_cohorts.sum_of_number_of_unique_orders, name: "# Orders"}],
        showLabels: true, showValues: false, unpinAxis: false, tickDensity: default,
        type: linear}, {label: !!null '', orientation: right, series: [{axisId: braze_lifecycle_cohorts.share_of_discounted_orders,
            id: braze_lifecycle_cohorts.share_of_discounted_orders, name: "% Discounted\
              \ Orders"}], showLabels: false, showValues: false, maxValue: !!null '',
        unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear}]
    x_axis_zoom: true
    y_axis_zoom: true
    label_value_format: ''
    series_types:
      Control - braze_lifecycle_cohorts.share_of_discounted_orders: line
      INVERSE - braze_lifecycle_cohorts.share_of_discounted_orders: line
      braze_lifecycle_cohorts.share_of_discounted_orders: line
    series_colors:
      Control - braze_lifecycle_cohorts.number_of_orders: "#002855"
      INVERSE - braze_lifecycle_cohorts.number_of_orders: "#e81f76"
      Control - braze_lifecycle_cohorts.share_of_discounted_orders: "#add0f0"
      INVERSE - braze_lifecycle_cohorts.share_of_discounted_orders: "#fdd8e9"
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    hidden_pivots: {}
    note_state: collapsed
    note_display: above
    note_text: Number of orders placed by users within the cohort and % of discounted
      orders
    listen:
      Cohort Entry Date: braze_lifecycle_cohorts.cohort_date
      Canvas Name: braze_lifecycle_cohorts.canvas_name
      Variant 1 - Variation Level Reporting: braze_lifecycle_cohorts.canvas_variation_name
      Days Canvas Duration: braze_lifecycle_cohorts.days_canvas_journey_duration
    row: 102
    col: 0
    width: 12
    height: 7
  - title: Message engagement
    name: Message engagement
    model: flink_v3
    explore: lifecycle_cohorts_reporting
    type: looker_column
    fields: [braze_lifecycle_cohorts.sum_of_number_of_sent_messages, braze_lifecycle_cohorts.cohort_week,
      braze_lifecycle_cohorts.share_of_engaged_messages]
    fill_fields: [braze_lifecycle_cohorts.cohort_week]
    filters:
      braze_lifecycle_cohorts.is_control_group: 'No'
    sorts: [braze_lifecycle_cohorts.cohort_week]
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
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    y_axes: [{label: '', orientation: left, series: [{axisId: braze_lifecycle_cohorts.sum_of_number_of_sent_messages,
            id: braze_lifecycle_cohorts.sum_of_number_of_sent_messages, name: "# Sent\
              \ Messages"}], showLabels: true, showValues: false, unpinAxis: false,
        tickDensity: default, type: linear}, {label: !!null '', orientation: right,
        series: [{axisId: braze_lifecycle_cohorts.share_of_engaged_messages, id: braze_lifecycle_cohorts.share_of_engaged_messages,
            name: "% Engaged Messages"}], showLabels: false, showValues: false, maxValue: !!null '',
        unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear}]
    x_axis_zoom: true
    y_axis_zoom: true
    series_types:
      braze_lifecycle_cohorts.share_of_engaged_messages: line
      INVERSE - braze_lifecycle_cohorts.share_of_engaged_messages: line
    series_colors:
      braze_lifecycle_cohorts.number_of_sent_messages: "#fcb2d3"
      braze_lifecycle_cohorts.share_of_engaged_messages: "#e81f76"
    x_axis_datetime_label: "%b %d"
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    hidden_pivots: {}
    note_state: collapsed
    note_display: above
    note_text: Number of messages sent to variant group users within the cohort's
      journey and % of engaged messages
    listen:
      Cohort Entry Date: braze_lifecycle_cohorts.cohort_date
      Canvas Name: braze_lifecycle_cohorts.canvas_name
      " Variant 2 - Variation Level Reporting": braze_lifecycle_cohorts.canvas_variation_name
      Days Canvas Duration: braze_lifecycle_cohorts.days_canvas_journey_duration
    row: 95
    col: 12
    width: 12
    height: 7
  - title: Message engagement
    name: Message engagement (2)
    model: flink_v3
    explore: lifecycle_cohorts_reporting
    type: looker_column
    fields: [braze_lifecycle_cohorts.sum_of_number_of_sent_messages, braze_lifecycle_cohorts.cohort_week,
      braze_lifecycle_cohorts.share_of_engaged_messages]
    fill_fields: [braze_lifecycle_cohorts.cohort_week]
    filters:
      braze_lifecycle_cohorts.is_control_group: 'No'
    sorts: [braze_lifecycle_cohorts.cohort_week]
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
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    y_axes: [{label: '', orientation: left, series: [{axisId: braze_lifecycle_cohorts.sum_of_number_of_sent_messages,
            id: braze_lifecycle_cohorts.sum_of_number_of_sent_messages, name: "# Sent\
              \ Messages"}], showLabels: true, showValues: false, unpinAxis: false,
        tickDensity: default, type: linear}, {label: !!null '', orientation: right,
        series: [{axisId: braze_lifecycle_cohorts.share_of_engaged_messages, id: braze_lifecycle_cohorts.share_of_engaged_messages,
            name: "% Engaged Messages"}], showLabels: false, showValues: false, maxValue: !!null '',
        unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear}]
    x_axis_zoom: true
    y_axis_zoom: true
    series_types:
      braze_lifecycle_cohorts.share_of_engaged_messages: line
      INVERSE - braze_lifecycle_cohorts.share_of_engaged_messages: line
    series_colors:
      braze_lifecycle_cohorts.number_of_sent_messages: "#fcb2d3"
      braze_lifecycle_cohorts.share_of_engaged_messages: "#e81f76"
    x_axis_datetime_label: "%b %d"
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    hidden_pivots: {}
    note_state: collapsed
    note_display: above
    note_text: Number of messages sent to variant group users within the cohort's
      journey and % of engaged messages
    listen:
      Cohort Entry Date: braze_lifecycle_cohorts.cohort_date
      Canvas Name: braze_lifecycle_cohorts.canvas_name
      Variant 1 - Variation Level Reporting: braze_lifecycle_cohorts.canvas_variation_name
      Days Canvas Duration: braze_lifecycle_cohorts.days_canvas_journey_duration
    row: 95
    col: 0
    width: 12
    height: 7
  - name: " (Copy 5)"
    type: text
    title_text: " (Copy 5)"
    subtitle_text: ''
    body_text: '[{"type":"h2","children":[{"text":"Variant 1"}],"align":"center"}]'
    rich_content_json: '{"format":"slate"}'
    row: 94
    col: 0
    width: 12
    height: 1
  - title: Orders Performance
    name: Orders Performance (2)
    model: flink_v3
    explore: lifecycle_cohorts_reporting
    type: looker_column
    fields: [braze_lifecycle_cohorts.cohort_week, braze_lifecycle_cohorts.sum_of_number_of_unique_orders,
      braze_lifecycle_cohorts.share_of_discounted_orders]
    fill_fields: [braze_lifecycle_cohorts.cohort_week]
    filters:
      braze_lifecycle_cohorts.is_control_group: ''
    sorts: [braze_lifecycle_cohorts.cohort_week desc]
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
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    y_axes: [{label: '', orientation: left, series: [{axisId: braze_lifecycle_cohorts.sum_of_number_of_unique_orders,
            id: braze_lifecycle_cohorts.sum_of_number_of_unique_orders, name: "# Orders"}],
        showLabels: true, showValues: false, unpinAxis: false, tickDensity: default,
        type: linear}, {label: !!null '', orientation: right, series: [{axisId: braze_lifecycle_cohorts.share_of_discounted_orders,
            id: braze_lifecycle_cohorts.share_of_discounted_orders, name: "% Discounted\
              \ Orders"}], showLabels: false, showValues: false, maxValue: !!null '',
        unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear}]
    x_axis_zoom: true
    y_axis_zoom: true
    label_value_format: ''
    series_types:
      Control - braze_lifecycle_cohorts.share_of_discounted_orders: line
      INVERSE - braze_lifecycle_cohorts.share_of_discounted_orders: line
      braze_lifecycle_cohorts.share_of_discounted_orders: line
    series_colors:
      Control - braze_lifecycle_cohorts.number_of_orders: "#002855"
      INVERSE - braze_lifecycle_cohorts.number_of_orders: "#e81f76"
      Control - braze_lifecycle_cohorts.share_of_discounted_orders: "#add0f0"
      INVERSE - braze_lifecycle_cohorts.share_of_discounted_orders: "#fdd8e9"
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    hidden_pivots: {}
    note_state: collapsed
    note_display: above
    note_text: Number of orders placed by users within the cohort and % of discounted
      orders
    listen:
      Cohort Entry Date: braze_lifecycle_cohorts.cohort_date
      Canvas Name: braze_lifecycle_cohorts.canvas_name
      " Variant 2 - Variation Level Reporting": braze_lifecycle_cohorts.canvas_variation_name
      Days Canvas Duration: braze_lifecycle_cohorts.days_canvas_journey_duration
    row: 102
    col: 12
    width: 12
    height: 7
  - name: " (Copy 6)"
    type: text
    title_text: " (Copy 6)"
    subtitle_text: ''
    body_text: '[{"type":"h2","children":[{"text":"Variant 2"}],"align":"center"}]'
    rich_content_json: '{"format":"slate"}'
    row: 94
    col: 12
    width: 12
    height: 1
  - title: "# Orders"
    name: "# Orders (2)"
    model: flink_v3
    explore: lifecycle_cohorts_reporting
    type: single_value
    fields: [braze_lifecycle_cohorts.sum_of_number_of_unique_orders]
    filters:
      braze_lifecycle_cohorts.is_control_group: 'No'
    limit: 500
    column_limit: 50
    query_timezone: Europe/Berlin
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
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
    stacking: normal
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: true
    show_silhouette: false
    totals_color: "#808080"
    x_axis_zoom: true
    y_axis_zoom: true
    series_types: {}
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    hidden_pivots: {}
    note_state: collapsed
    note_display: above
    note_text: Overall number of orders placed by customers within variation cohorts
      during the measurement window
    listen:
      Cohort Entry Date: braze_lifecycle_cohorts.cohort_date
      Canvas Name: braze_lifecycle_cohorts.canvas_name
      Canvas Variation - Canvas Level Reporting: braze_lifecycle_cohorts.canvas_variation_name
      Days Canvas Duration: braze_lifecycle_cohorts.days_canvas_journey_duration
    row: 4
    col: 12
    width: 6
    height: 3
  - title: "# Orders Incrementality (Absolute, #)"
    name: "# Orders Incrementality (Absolute, #)"
    model: flink_v3
    explore: lifecycle_cohorts_reporting
    type: single_value
    fields: [braze_lifecycle_cohorts.absolute_incrementality_of_avg_number_of_orders_per_contacted_user]
    filters:
      braze_lifecycle_cohorts.is_control_group: 'No'
    limit: 500
    column_limit: 50
    query_timezone: Europe/Berlin
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
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
    stacking: normal
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: true
    show_silhouette: false
    totals_color: "#808080"
    x_axis_zoom: true
    y_axis_zoom: true
    series_types: {}
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    hidden_pivots: {}
    note_state: collapsed
    note_display: above
    note_text: Number of Braze users who entered the canvas’s cohort aggregated by
      entry date
    listen:
      Cohort Entry Date: braze_lifecycle_cohorts.cohort_date
      Canvas Name: braze_lifecycle_cohorts.canvas_name
      Canvas Variation - Canvas Level Reporting: braze_lifecycle_cohorts.canvas_variation_name
      Days Canvas Duration: braze_lifecycle_cohorts.days_canvas_journey_duration
    row: 7
    col: 6
    width: 6
    height: 3
  - title: "# Sent Messages"
    name: "# Sent Messages (2)"
    model: flink_v3
    explore: lifecycle_cohorts_reporting
    type: single_value
    fields: [braze_lifecycle_cohorts.sum_of_number_of_sent_messages]
    filters:
      braze_lifecycle_cohorts.is_control_group: 'No'
    limit: 500
    column_limit: 50
    query_timezone: Europe/Berlin
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
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
    stacking: normal
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: true
    show_silhouette: false
    totals_color: "#808080"
    x_axis_zoom: true
    y_axis_zoom: true
    series_types: {}
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    hidden_pivots: {}
    note_state: collapsed
    note_display: above
    note_text: Number of messages sent within canvas
    listen:
      Cohort Entry Date: braze_lifecycle_cohorts.cohort_date
      Canvas Name: braze_lifecycle_cohorts.canvas_name
      Canvas Variation - Canvas Level Reporting: braze_lifecycle_cohorts.canvas_variation_name
      Days Canvas Duration: braze_lifecycle_cohorts.days_canvas_journey_duration
    row: 4
    col: 0
    width: 6
    height: 3
  - title: AVG Commercial Profit Incrementality (Relative, %)
    name: AVG Commercial Profit Incrementality (Relative, %)
    model: flink_v3
    explore: lifecycle_cohorts_reporting
    type: single_value
    fields: [braze_lifecycle_cohorts.relative_incrementality_of_avg_amt_commercial_profit_per_user_contacted]
    filters:
      braze_lifecycle_cohorts.is_control_group: 'No'
    limit: 500
    column_limit: 50
    query_timezone: Europe/Berlin
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
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
    stacking: normal
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: true
    show_silhouette: false
    totals_color: "#808080"
    x_axis_zoom: true
    y_axis_zoom: true
    series_types: {}
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    hidden_pivots: {}
    note_state: collapsed
    note_display: above
    note_text: Overall difference in avg commercial profit per contacted user in variant
      group compared to control group
    listen:
      Cohort Entry Date: braze_lifecycle_cohorts.cohort_date
      Canvas Name: braze_lifecycle_cohorts.canvas_name
      Canvas Variation - Canvas Level Reporting: braze_lifecycle_cohorts.canvas_variation_name
      Days Canvas Duration: braze_lifecycle_cohorts.days_canvas_journey_duration
    row: 7
    col: 0
    width: 6
    height: 3
  - title: "# Discounted Orders"
    name: "# Discounted Orders"
    model: flink_v3
    explore: lifecycle_cohorts_reporting
    type: single_value
    fields: [braze_lifecycle_cohorts.sum_of_number_of_unique_discounted_orders]
    filters:
      braze_lifecycle_cohorts.is_control_group: 'No'
    limit: 500
    column_limit: 50
    query_timezone: Europe/Berlin
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
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
    stacking: normal
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: true
    show_silhouette: false
    totals_color: "#808080"
    x_axis_zoom: true
    y_axis_zoom: true
    series_types: {}
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    hidden_pivots: {}
    note_state: collapsed
    note_display: above
    note_text: Overall number of orders placed by customers within variation cohorts
      that were discounted by cart discounts
    listen:
      Cohort Entry Date: braze_lifecycle_cohorts.cohort_date
      Canvas Name: braze_lifecycle_cohorts.canvas_name
      Canvas Variation - Canvas Level Reporting: braze_lifecycle_cohorts.canvas_variation_name
      Days Canvas Duration: braze_lifecycle_cohorts.days_canvas_journey_duration
    row: 4
    col: 18
    width: 6
    height: 3
  - title: "% Engaged Messages"
    name: "% Engaged Messages (2)"
    model: flink_v3
    explore: lifecycle_cohorts_reporting
    type: single_value
    fields: [braze_lifecycle_cohorts.share_of_engaged_messages]
    filters:
      braze_lifecycle_cohorts.is_control_group: 'No'
    limit: 500
    column_limit: 50
    query_timezone: Europe/Berlin
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
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
    stacking: normal
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: true
    show_silhouette: false
    totals_color: "#808080"
    x_axis_zoom: true
    y_axis_zoom: true
    series_types: {}
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    hidden_pivots: {}
    note_state: collapsed
    note_display: above
    note_text: "% of sent messages with which customer engaged (clicked on an email\
      \ link or tapped on a push notification)"
    listen:
      Cohort Entry Date: braze_lifecycle_cohorts.cohort_date
      Canvas Name: braze_lifecycle_cohorts.canvas_name
      Canvas Variation - Canvas Level Reporting: braze_lifecycle_cohorts.canvas_variation_name
      Days Canvas Duration: braze_lifecycle_cohorts.days_canvas_journey_duration
    row: 4
    col: 6
    width: 6
    height: 3
  - title: "# Users Ordered Incrementality (Absolute, #)"
    name: "# Users Ordered Incrementality (Absolute, #)"
    model: flink_v3
    explore: lifecycle_cohorts_reporting
    type: single_value
    fields: [braze_lifecycle_cohorts.absolute_incrementality_of_share_of_customers_ordered]
    filters:
      braze_lifecycle_cohorts.is_control_group: 'No'
    limit: 500
    column_limit: 50
    query_timezone: Europe/Berlin
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
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
    stacking: normal
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: true
    show_silhouette: false
    totals_color: "#808080"
    x_axis_zoom: true
    y_axis_zoom: true
    series_types: {}
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    hidden_pivots: {}
    note_state: collapsed
    note_display: above
    note_text: Number of Braze users who entered the canvas’s cohort aggregated by
      entry date
    listen:
      Cohort Entry Date: braze_lifecycle_cohorts.cohort_date
      Canvas Name: braze_lifecycle_cohorts.canvas_name
      Canvas Variation - Canvas Level Reporting: braze_lifecycle_cohorts.canvas_variation_name
      Days Canvas Duration: braze_lifecycle_cohorts.days_canvas_journey_duration
    row: 7
    col: 12
    width: 6
    height: 3
  - title: Incrementality (Relative, %) in AVG Commercial Profit (per Contacted User)
    name: Incrementality (Relative, %) in AVG Commercial Profit (per Contacted User)
    model: flink_v3
    explore: lifecycle_cohorts_reporting
    type: looker_line
    fields: [braze_lifecycle_cohorts.cohort_week, braze_lifecycle_cohorts.canvas_variation_name,
      braze_lifecycle_cohorts.relative_incrementality_of_avg_amt_commercial_profit_per_user_contacted]
    pivots: [braze_lifecycle_cohorts.canvas_variation_name]
    fill_fields: [braze_lifecycle_cohorts.cohort_week]
    filters:
      braze_lifecycle_cohorts.is_control_group: 'No'
    sorts: [braze_lifecycle_cohorts.cohort_week, braze_lifecycle_cohorts.canvas_variation_name]
    limit: 500
    column_limit: 50
    dynamic_fields: [{category: table_calculation, expression: "(pivot_index(${braze_lifecycle_cohorts.share_of_customers_visited},\
          \ 2) - pivot_index(${braze_lifecycle_cohorts.share_of_customers_visited},\
          \ 1))*100", label: Customers Visited Incrementality, value_format: !!null '',
        value_format_name: decimal_2, _kind_hint: supermeasure, table_calculation: customers_visited_incrementality,
        _type_hint: number, is_disabled: true}, {category: table_calculation, expression: "(pivot_index(${braze_lifecycle_cohorts.share_of_customers_ordered},\
          \ 2) - pivot_index(${braze_lifecycle_cohorts.share_of_customers_ordered},\
          \ 1))*100", label: Customers Ordered Incrementality, value_format: !!null '',
        value_format_name: decimal_2, _kind_hint: supermeasure, table_calculation: customers_ordered_incrementality,
        _type_hint: number, is_disabled: true}]
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
    y_axes: [{label: '', orientation: left, series: [{axisId: braze_lifecycle_cohorts.relative_incrementality_of_avg_amt_commercial_profit_per_user_contacted,
            id: 1PN - braze_lifecycle_cohorts.relative_incrementality_of_avg_amt_commercial_profit_per_user_contacted,
            name: 1PN}, {axisId: braze_lifecycle_cohorts.relative_incrementality_of_avg_amt_commercial_profit_per_user_contacted,
            id: 2PN - braze_lifecycle_cohorts.relative_incrementality_of_avg_amt_commercial_profit_per_user_contacted,
            name: 2PN}, {axisId: braze_lifecycle_cohorts.relative_incrementality_of_avg_amt_commercial_profit_per_user_contacted,
            id: Aggressive - braze_lifecycle_cohorts.relative_incrementality_of_avg_amt_commercial_profit_per_user_contacted,
            name: Aggressive}, {axisId: braze_lifecycle_cohorts.relative_incrementality_of_avg_amt_commercial_profit_per_user_contacted,
            id: Chill - braze_lifecycle_cohorts.relative_incrementality_of_avg_amt_commercial_profit_per_user_contacted,
            name: Chill}, {axisId: braze_lifecycle_cohorts.relative_incrementality_of_avg_amt_commercial_profit_per_user_contacted,
            id: CODEAPPEARS - braze_lifecycle_cohorts.relative_incrementality_of_avg_amt_commercial_profit_per_user_contacted,
            name: CODEAPPEARS}, {axisId: braze_lifecycle_cohorts.relative_incrementality_of_avg_amt_commercial_profit_per_user_contacted,
            id: CODEDISPLAYED - braze_lifecycle_cohorts.relative_incrementality_of_avg_amt_commercial_profit_per_user_contacted,
            name: CODEDISPLAYED}, {axisId: braze_lifecycle_cohorts.relative_incrementality_of_avg_amt_commercial_profit_per_user_contacted,
            id: Evening - braze_lifecycle_cohorts.relative_incrementality_of_avg_amt_commercial_profit_per_user_contacted,
            name: Evening}, {axisId: braze_lifecycle_cohorts.relative_incrementality_of_avg_amt_commercial_profit_per_user_contacted,
            id: EXISTING - braze_lifecycle_cohorts.relative_incrementality_of_avg_amt_commercial_profit_per_user_contacted,
            name: EXISTING}, {axisId: braze_lifecycle_cohorts.relative_incrementality_of_avg_amt_commercial_profit_per_user_contacted,
            id: INVERSE - braze_lifecycle_cohorts.relative_incrementality_of_avg_amt_commercial_profit_per_user_contacted,
            name: INVERSE}, {axisId: braze_lifecycle_cohorts.relative_incrementality_of_avg_amt_commercial_profit_per_user_contacted,
            id: Morning - braze_lifecycle_cohorts.relative_incrementality_of_avg_amt_commercial_profit_per_user_contacted,
            name: Morning}, {axisId: braze_lifecycle_cohorts.relative_incrementality_of_avg_amt_commercial_profit_per_user_contacted,
            id: no_voucher - braze_lifecycle_cohorts.relative_incrementality_of_avg_amt_commercial_profit_per_user_contacted,
            name: no_voucher}, {axisId: braze_lifecycle_cohorts.relative_incrementality_of_avg_amt_commercial_profit_per_user_contacted,
            id: NOCODE - braze_lifecycle_cohorts.relative_incrementality_of_avg_amt_commercial_profit_per_user_contacted,
            name: NOCODE}, {axisId: braze_lifecycle_cohorts.relative_incrementality_of_avg_amt_commercial_profit_per_user_contacted,
            id: NOCODEAPPEARS - braze_lifecycle_cohorts.relative_incrementality_of_avg_amt_commercial_profit_per_user_contacted,
            name: NOCODEAPPEARS}, {axisId: braze_lifecycle_cohorts.relative_incrementality_of_avg_amt_commercial_profit_per_user_contacted,
            id: Noon - braze_lifecycle_cohorts.relative_incrementality_of_avg_amt_commercial_profit_per_user_contacted,
            name: Noon}, {axisId: braze_lifecycle_cohorts.relative_incrementality_of_avg_amt_commercial_profit_per_user_contacted,
            id: VARIANT - braze_lifecycle_cohorts.relative_incrementality_of_avg_amt_commercial_profit_per_user_contacted,
            name: VARIANT}, {axisId: braze_lifecycle_cohorts.relative_incrementality_of_avg_amt_commercial_profit_per_user_contacted,
            id: Variant 1 - braze_lifecycle_cohorts.relative_incrementality_of_avg_amt_commercial_profit_per_user_contacted,
            name: Variant 1}, {axisId: braze_lifecycle_cohorts.relative_incrementality_of_avg_amt_commercial_profit_per_user_contacted,
            id: Variant 2 - braze_lifecycle_cohorts.relative_incrementality_of_avg_amt_commercial_profit_per_user_contacted,
            name: Variant 2}, {axisId: braze_lifecycle_cohorts.relative_incrementality_of_avg_amt_commercial_profit_per_user_contacted,
            id: Variant 3 - braze_lifecycle_cohorts.relative_incrementality_of_avg_amt_commercial_profit_per_user_contacted,
            name: Variant 3}, {axisId: braze_lifecycle_cohorts.relative_incrementality_of_avg_amt_commercial_profit_per_user_contacted,
            id: Variant_1 - braze_lifecycle_cohorts.relative_incrementality_of_avg_amt_commercial_profit_per_user_contacted,
            name: Variant_1}, {axisId: braze_lifecycle_cohorts.relative_incrementality_of_avg_amt_commercial_profit_per_user_contacted,
            id: Variant_1PN - braze_lifecycle_cohorts.relative_incrementality_of_avg_amt_commercial_profit_per_user_contacted,
            name: Variant_1PN}, {axisId: braze_lifecycle_cohorts.relative_incrementality_of_avg_amt_commercial_profit_per_user_contacted,
            id: Variant_2PN - braze_lifecycle_cohorts.relative_incrementality_of_avg_amt_commercial_profit_per_user_contacted,
            name: Variant_2PN}, {axisId: braze_lifecycle_cohorts.relative_incrementality_of_avg_amt_commercial_profit_per_user_contacted,
            id: Variant1 - braze_lifecycle_cohorts.relative_incrementality_of_avg_amt_commercial_profit_per_user_contacted,
            name: Variant1}, {axisId: braze_lifecycle_cohorts.relative_incrementality_of_avg_amt_commercial_profit_per_user_contacted,
            id: Voucher_up - braze_lifecycle_cohorts.relative_incrementality_of_avg_amt_commercial_profit_per_user_contacted,
            name: Voucher_up}, {axisId: braze_lifecycle_cohorts.relative_incrementality_of_avg_amt_commercial_profit_per_user_contacted,
            id: WithoutCopy - braze_lifecycle_cohorts.relative_incrementality_of_avg_amt_commercial_profit_per_user_contacted,
            name: WithoutCopy}], showLabels: false, showValues: false, unpinAxis: false,
        tickDensity: default, type: linear}]
    x_axis_zoom: true
    y_axis_zoom: true
    series_types: {}
    series_colors:
      customers_with_orders_incrementality: "#69aae4"
      customers_visited_incrementality: "#69aae4"
      customers_ordered_incrementality: "#fcb2d3"
      braze_lifecycle_cohorts.incrementality_of_share_of_customers_ordered: "#69aae4"
      braze_lifecycle_cohorts.incrementality_of_share_of_customers_visited: "#ffb063"
    reference_lines: []
    trend_lines: []
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    hidden_pivots: {}
    note_state: collapsed
    note_display: above
    note_text: "% increase in average commercial profit generated by contacted customers\
      \ in variant group compared to control group"
    listen:
      Cohort Entry Date: braze_lifecycle_cohorts.cohort_date
      Canvas Name: braze_lifecycle_cohorts.canvas_name
      Canvas Variation - Canvas Level Reporting: braze_lifecycle_cohorts.canvas_variation_name
      Days Canvas Duration: braze_lifecycle_cohorts.days_canvas_journey_duration
    row: 24
    col: 12
    width: 12
    height: 7
  - title: "# Users Visited Incrementality (Absolute, #)"
    name: "# Users Visited Incrementality (Absolute, #)"
    model: flink_v3
    explore: lifecycle_cohorts_reporting
    type: single_value
    fields: [braze_lifecycle_cohorts.absolute_incrementality_of_share_of_customers_visited]
    filters:
      braze_lifecycle_cohorts.is_control_group: 'No'
    limit: 500
    column_limit: 50
    query_timezone: Europe/Berlin
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
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
    stacking: normal
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: true
    show_silhouette: false
    totals_color: "#808080"
    x_axis_zoom: true
    y_axis_zoom: true
    series_types: {}
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    hidden_pivots: {}
    note_state: collapsed
    note_display: above
    note_text: Number of Braze users who entered the canvas’s cohort aggregated by
      entry date
    listen:
      Cohort Entry Date: braze_lifecycle_cohorts.cohort_date
      Canvas Name: braze_lifecycle_cohorts.canvas_name
      Canvas Variation - Canvas Level Reporting: braze_lifecycle_cohorts.canvas_variation_name
      Days Canvas Duration: braze_lifecycle_cohorts.days_canvas_journey_duration
    row: 7
    col: 18
    width: 6
    height: 3
  - title: 'Incrementality (Absolute, #) in Orders'
    name: 'Incrementality (Absolute, #) in Orders'
    model: flink_v3
    explore: lifecycle_cohorts_reporting
    type: looker_column
    fields: [braze_lifecycle_cohorts.cohort_week, braze_lifecycle_cohorts.canvas_variation_name,
      braze_lifecycle_cohorts.absolute_incrementality_of_avg_number_of_orders_per_contacted_user]
    pivots: [braze_lifecycle_cohorts.canvas_variation_name]
    fill_fields: [braze_lifecycle_cohorts.cohort_week]
    filters:
      braze_lifecycle_cohorts.is_control_group: 'No'
    sorts: [braze_lifecycle_cohorts.cohort_week, braze_lifecycle_cohorts.canvas_variation_name]
    limit: 500
    column_limit: 50
    dynamic_fields: [{category: table_calculation, expression: "(pivot_index(${braze_lifecycle_cohorts.share_of_customers_visited},\
          \ 2) - pivot_index(${braze_lifecycle_cohorts.share_of_customers_visited},\
          \ 1))*100", label: Customers Visited Incrementality, value_format: !!null '',
        value_format_name: decimal_2, _kind_hint: supermeasure, table_calculation: customers_visited_incrementality,
        _type_hint: number, is_disabled: true}, {category: table_calculation, expression: "(pivot_index(${braze_lifecycle_cohorts.share_of_customers_ordered},\
          \ 2) - pivot_index(${braze_lifecycle_cohorts.share_of_customers_ordered},\
          \ 1))*100", label: Customers Ordered Incrementality, value_format: !!null '',
        value_format_name: decimal_2, _kind_hint: supermeasure, table_calculation: customers_ordered_incrementality,
        _type_hint: number, is_disabled: true}]
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
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    y_axes: [{label: '', orientation: left, series: [{axisId: braze_lifecycle_cohorts.absolute_incrementality_of_avg_number_of_orders_per_contacted_user,
            id: 1PN - braze_lifecycle_cohorts.absolute_incrementality_of_avg_number_of_orders_per_contacted_user,
            name: 1PN}, {axisId: braze_lifecycle_cohorts.absolute_incrementality_of_avg_number_of_orders_per_contacted_user,
            id: 2PN - braze_lifecycle_cohorts.absolute_incrementality_of_avg_number_of_orders_per_contacted_user,
            name: 2PN}, {axisId: braze_lifecycle_cohorts.absolute_incrementality_of_avg_number_of_orders_per_contacted_user,
            id: Aggressive - braze_lifecycle_cohorts.absolute_incrementality_of_avg_number_of_orders_per_contacted_user,
            name: Aggressive}, {axisId: braze_lifecycle_cohorts.absolute_incrementality_of_avg_number_of_orders_per_contacted_user,
            id: Chill - braze_lifecycle_cohorts.absolute_incrementality_of_avg_number_of_orders_per_contacted_user,
            name: Chill}, {axisId: braze_lifecycle_cohorts.absolute_incrementality_of_avg_number_of_orders_per_contacted_user,
            id: CODEAPPEARS - braze_lifecycle_cohorts.absolute_incrementality_of_avg_number_of_orders_per_contacted_user,
            name: CODEAPPEARS}, {axisId: braze_lifecycle_cohorts.absolute_incrementality_of_avg_number_of_orders_per_contacted_user,
            id: CODEDISPLAYED - braze_lifecycle_cohorts.absolute_incrementality_of_avg_number_of_orders_per_contacted_user,
            name: CODEDISPLAYED}, {axisId: braze_lifecycle_cohorts.absolute_incrementality_of_avg_number_of_orders_per_contacted_user,
            id: Evening - braze_lifecycle_cohorts.absolute_incrementality_of_avg_number_of_orders_per_contacted_user,
            name: Evening}, {axisId: braze_lifecycle_cohorts.absolute_incrementality_of_avg_number_of_orders_per_contacted_user,
            id: EXISTING - braze_lifecycle_cohorts.absolute_incrementality_of_avg_number_of_orders_per_contacted_user,
            name: EXISTING}, {axisId: braze_lifecycle_cohorts.absolute_incrementality_of_avg_number_of_orders_per_contacted_user,
            id: INVERSE - braze_lifecycle_cohorts.absolute_incrementality_of_avg_number_of_orders_per_contacted_user,
            name: INVERSE}, {axisId: braze_lifecycle_cohorts.absolute_incrementality_of_avg_number_of_orders_per_contacted_user,
            id: Morning - braze_lifecycle_cohorts.absolute_incrementality_of_avg_number_of_orders_per_contacted_user,
            name: Morning}, {axisId: braze_lifecycle_cohorts.absolute_incrementality_of_avg_number_of_orders_per_contacted_user,
            id: no_voucher - braze_lifecycle_cohorts.absolute_incrementality_of_avg_number_of_orders_per_contacted_user,
            name: no_voucher}, {axisId: braze_lifecycle_cohorts.absolute_incrementality_of_avg_number_of_orders_per_contacted_user,
            id: NOCODE - braze_lifecycle_cohorts.absolute_incrementality_of_avg_number_of_orders_per_contacted_user,
            name: NOCODE}, {axisId: braze_lifecycle_cohorts.absolute_incrementality_of_avg_number_of_orders_per_contacted_user,
            id: NOCODEAPPEARS - braze_lifecycle_cohorts.absolute_incrementality_of_avg_number_of_orders_per_contacted_user,
            name: NOCODEAPPEARS}, {axisId: braze_lifecycle_cohorts.absolute_incrementality_of_avg_number_of_orders_per_contacted_user,
            id: Noon - braze_lifecycle_cohorts.absolute_incrementality_of_avg_number_of_orders_per_contacted_user,
            name: Noon}, {axisId: braze_lifecycle_cohorts.absolute_incrementality_of_avg_number_of_orders_per_contacted_user,
            id: VARIANT - braze_lifecycle_cohorts.absolute_incrementality_of_avg_number_of_orders_per_contacted_user,
            name: VARIANT}, {axisId: braze_lifecycle_cohorts.absolute_incrementality_of_avg_number_of_orders_per_contacted_user,
            id: Variant 1 - braze_lifecycle_cohorts.absolute_incrementality_of_avg_number_of_orders_per_contacted_user,
            name: Variant 1}, {axisId: braze_lifecycle_cohorts.absolute_incrementality_of_avg_number_of_orders_per_contacted_user,
            id: Variant 2 - braze_lifecycle_cohorts.absolute_incrementality_of_avg_number_of_orders_per_contacted_user,
            name: Variant 2}, {axisId: braze_lifecycle_cohorts.absolute_incrementality_of_avg_number_of_orders_per_contacted_user,
            id: Variant 3 - braze_lifecycle_cohorts.absolute_incrementality_of_avg_number_of_orders_per_contacted_user,
            name: Variant 3}, {axisId: braze_lifecycle_cohorts.absolute_incrementality_of_avg_number_of_orders_per_contacted_user,
            id: Variant_1 - braze_lifecycle_cohorts.absolute_incrementality_of_avg_number_of_orders_per_contacted_user,
            name: Variant_1}, {axisId: braze_lifecycle_cohorts.absolute_incrementality_of_avg_number_of_orders_per_contacted_user,
            id: Variant_1PN - braze_lifecycle_cohorts.absolute_incrementality_of_avg_number_of_orders_per_contacted_user,
            name: Variant_1PN}, {axisId: braze_lifecycle_cohorts.absolute_incrementality_of_avg_number_of_orders_per_contacted_user,
            id: Variant_2PN - braze_lifecycle_cohorts.absolute_incrementality_of_avg_number_of_orders_per_contacted_user,
            name: Variant_2PN}, {axisId: braze_lifecycle_cohorts.absolute_incrementality_of_avg_number_of_orders_per_contacted_user,
            id: Variant1 - braze_lifecycle_cohorts.absolute_incrementality_of_avg_number_of_orders_per_contacted_user,
            name: Variant1}, {axisId: braze_lifecycle_cohorts.absolute_incrementality_of_avg_number_of_orders_per_contacted_user,
            id: Voucher_up - braze_lifecycle_cohorts.absolute_incrementality_of_avg_number_of_orders_per_contacted_user,
            name: Voucher_up}, {axisId: braze_lifecycle_cohorts.absolute_incrementality_of_avg_number_of_orders_per_contacted_user,
            id: WithoutCopy - braze_lifecycle_cohorts.absolute_incrementality_of_avg_number_of_orders_per_contacted_user,
            name: WithoutCopy}], showLabels: false, showValues: false, unpinAxis: false,
        tickDensity: default, type: linear}]
    x_axis_zoom: true
    y_axis_zoom: true
    series_types: {}
    series_colors:
      customers_with_orders_incrementality: "#69aae4"
      customers_visited_incrementality: "#69aae4"
      customers_ordered_incrementality: "#fcb2d3"
      braze_lifecycle_cohorts.incrementality_of_share_of_customers_ordered: "#69aae4"
      braze_lifecycle_cohorts.incrementality_of_share_of_customers_visited: "#ffb063"
    reference_lines: []
    trend_lines: []
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    hidden_pivots: {}
    note_state: collapsed
    note_display: above
    note_text: Absolute number of incremental orders resulted by Canvas
    listen:
      Cohort Entry Date: braze_lifecycle_cohorts.cohort_date
      Canvas Name: braze_lifecycle_cohorts.canvas_name
      Canvas Variation - Canvas Level Reporting: braze_lifecycle_cohorts.canvas_variation_name
      Days Canvas Duration: braze_lifecycle_cohorts.days_canvas_journey_duration
    row: 17
    col: 0
    width: 12
    height: 7
  - title: Incrementality (Relative, %) in AVG Orders (per Contacted User)
    name: Incrementality (Relative, %) in AVG Orders (per Contacted User)
    model: flink_v3
    explore: lifecycle_cohorts_reporting
    type: looker_column
    fields: [braze_lifecycle_cohorts.cohort_week, braze_lifecycle_cohorts.canvas_variation_name,
      braze_lifecycle_cohorts.relative_incrementality_of_avg_number_of_orders_per_contacted_user]
    pivots: [braze_lifecycle_cohorts.canvas_variation_name]
    fill_fields: [braze_lifecycle_cohorts.cohort_week]
    filters:
      braze_lifecycle_cohorts.is_control_group: 'No'
    sorts: [braze_lifecycle_cohorts.cohort_week, braze_lifecycle_cohorts.canvas_variation_name]
    limit: 500
    column_limit: 50
    dynamic_fields: [{category: table_calculation, expression: "(pivot_index(${braze_lifecycle_cohorts.share_of_customers_visited},\
          \ 2) - pivot_index(${braze_lifecycle_cohorts.share_of_customers_visited},\
          \ 1))*100", label: Customers Visited Incrementality, value_format: !!null '',
        value_format_name: decimal_2, _kind_hint: supermeasure, table_calculation: customers_visited_incrementality,
        _type_hint: number, is_disabled: true}, {category: table_calculation, expression: "(pivot_index(${braze_lifecycle_cohorts.share_of_customers_ordered},\
          \ 2) - pivot_index(${braze_lifecycle_cohorts.share_of_customers_ordered},\
          \ 1))*100", label: Customers Ordered Incrementality, value_format: !!null '',
        value_format_name: decimal_2, _kind_hint: supermeasure, table_calculation: customers_ordered_incrementality,
        _type_hint: number, is_disabled: true}]
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
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    y_axes: [{label: '', orientation: left, series: [{axisId: braze_lifecycle_cohorts.relative_incrementality_of_avg_number_of_orders_per_contacted_user,
            id: 1PN - braze_lifecycle_cohorts.relative_incrementality_of_avg_number_of_orders_per_contacted_user,
            name: 1PN}, {axisId: braze_lifecycle_cohorts.relative_incrementality_of_avg_number_of_orders_per_contacted_user,
            id: 2PN - braze_lifecycle_cohorts.relative_incrementality_of_avg_number_of_orders_per_contacted_user,
            name: 2PN}, {axisId: braze_lifecycle_cohorts.relative_incrementality_of_avg_number_of_orders_per_contacted_user,
            id: Aggressive - braze_lifecycle_cohorts.relative_incrementality_of_avg_number_of_orders_per_contacted_user,
            name: Aggressive}, {axisId: braze_lifecycle_cohorts.relative_incrementality_of_avg_number_of_orders_per_contacted_user,
            id: Chill - braze_lifecycle_cohorts.relative_incrementality_of_avg_number_of_orders_per_contacted_user,
            name: Chill}, {axisId: braze_lifecycle_cohorts.relative_incrementality_of_avg_number_of_orders_per_contacted_user,
            id: CODEAPPEARS - braze_lifecycle_cohorts.relative_incrementality_of_avg_number_of_orders_per_contacted_user,
            name: CODEAPPEARS}, {axisId: braze_lifecycle_cohorts.relative_incrementality_of_avg_number_of_orders_per_contacted_user,
            id: CODEDISPLAYED - braze_lifecycle_cohorts.relative_incrementality_of_avg_number_of_orders_per_contacted_user,
            name: CODEDISPLAYED}, {axisId: braze_lifecycle_cohorts.relative_incrementality_of_avg_number_of_orders_per_contacted_user,
            id: Evening - braze_lifecycle_cohorts.relative_incrementality_of_avg_number_of_orders_per_contacted_user,
            name: Evening}, {axisId: braze_lifecycle_cohorts.relative_incrementality_of_avg_number_of_orders_per_contacted_user,
            id: EXISTING - braze_lifecycle_cohorts.relative_incrementality_of_avg_number_of_orders_per_contacted_user,
            name: EXISTING}, {axisId: braze_lifecycle_cohorts.relative_incrementality_of_avg_number_of_orders_per_contacted_user,
            id: INVERSE - braze_lifecycle_cohorts.relative_incrementality_of_avg_number_of_orders_per_contacted_user,
            name: INVERSE}, {axisId: braze_lifecycle_cohorts.relative_incrementality_of_avg_number_of_orders_per_contacted_user,
            id: Morning - braze_lifecycle_cohorts.relative_incrementality_of_avg_number_of_orders_per_contacted_user,
            name: Morning}, {axisId: braze_lifecycle_cohorts.relative_incrementality_of_avg_number_of_orders_per_contacted_user,
            id: no_voucher - braze_lifecycle_cohorts.relative_incrementality_of_avg_number_of_orders_per_contacted_user,
            name: no_voucher}, {axisId: braze_lifecycle_cohorts.relative_incrementality_of_avg_number_of_orders_per_contacted_user,
            id: NOCODE - braze_lifecycle_cohorts.relative_incrementality_of_avg_number_of_orders_per_contacted_user,
            name: NOCODE}, {axisId: braze_lifecycle_cohorts.relative_incrementality_of_avg_number_of_orders_per_contacted_user,
            id: NOCODEAPPEARS - braze_lifecycle_cohorts.relative_incrementality_of_avg_number_of_orders_per_contacted_user,
            name: NOCODEAPPEARS}, {axisId: braze_lifecycle_cohorts.relative_incrementality_of_avg_number_of_orders_per_contacted_user,
            id: Noon - braze_lifecycle_cohorts.relative_incrementality_of_avg_number_of_orders_per_contacted_user,
            name: Noon}, {axisId: braze_lifecycle_cohorts.relative_incrementality_of_avg_number_of_orders_per_contacted_user,
            id: VARIANT - braze_lifecycle_cohorts.relative_incrementality_of_avg_number_of_orders_per_contacted_user,
            name: VARIANT}, {axisId: braze_lifecycle_cohorts.relative_incrementality_of_avg_number_of_orders_per_contacted_user,
            id: Variant 1 - braze_lifecycle_cohorts.relative_incrementality_of_avg_number_of_orders_per_contacted_user,
            name: Variant 1}, {axisId: braze_lifecycle_cohorts.relative_incrementality_of_avg_number_of_orders_per_contacted_user,
            id: Variant 2 - braze_lifecycle_cohorts.relative_incrementality_of_avg_number_of_orders_per_contacted_user,
            name: Variant 2}, {axisId: braze_lifecycle_cohorts.relative_incrementality_of_avg_number_of_orders_per_contacted_user,
            id: Variant 3 - braze_lifecycle_cohorts.relative_incrementality_of_avg_number_of_orders_per_contacted_user,
            name: Variant 3}, {axisId: braze_lifecycle_cohorts.relative_incrementality_of_avg_number_of_orders_per_contacted_user,
            id: Variant_1 - braze_lifecycle_cohorts.relative_incrementality_of_avg_number_of_orders_per_contacted_user,
            name: Variant_1}, {axisId: braze_lifecycle_cohorts.relative_incrementality_of_avg_number_of_orders_per_contacted_user,
            id: Variant_1PN - braze_lifecycle_cohorts.relative_incrementality_of_avg_number_of_orders_per_contacted_user,
            name: Variant_1PN}, {axisId: braze_lifecycle_cohorts.relative_incrementality_of_avg_number_of_orders_per_contacted_user,
            id: Variant_2PN - braze_lifecycle_cohorts.relative_incrementality_of_avg_number_of_orders_per_contacted_user,
            name: Variant_2PN}, {axisId: braze_lifecycle_cohorts.relative_incrementality_of_avg_number_of_orders_per_contacted_user,
            id: Variant1 - braze_lifecycle_cohorts.relative_incrementality_of_avg_number_of_orders_per_contacted_user,
            name: Variant1}, {axisId: braze_lifecycle_cohorts.relative_incrementality_of_avg_number_of_orders_per_contacted_user,
            id: Voucher_up - braze_lifecycle_cohorts.relative_incrementality_of_avg_number_of_orders_per_contacted_user,
            name: Voucher_up}, {axisId: braze_lifecycle_cohorts.relative_incrementality_of_avg_number_of_orders_per_contacted_user,
            id: WithoutCopy - braze_lifecycle_cohorts.relative_incrementality_of_avg_number_of_orders_per_contacted_user,
            name: WithoutCopy}], showLabels: false, showValues: false, unpinAxis: false,
        tickDensity: default, type: linear}]
    x_axis_zoom: true
    y_axis_zoom: true
    label_value_format: "#%"
    series_types: {}
    series_colors:
      customers_with_orders_incrementality: "#69aae4"
      customers_visited_incrementality: "#69aae4"
      customers_ordered_incrementality: "#fcb2d3"
      braze_lifecycle_cohorts.incrementality_of_share_of_customers_ordered: "#69aae4"
      braze_lifecycle_cohorts.incrementality_of_share_of_customers_visited: "#ffb063"
    reference_lines: []
    trend_lines: []
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    hidden_pivots: {}
    note_state: collapsed
    note_display: above
    note_text: "% increase in average number of orders placed by customers contacted\
      \ in variant group compared to control group"
    listen:
      Cohort Entry Date: braze_lifecycle_cohorts.cohort_date
      Canvas Name: braze_lifecycle_cohorts.canvas_name
      Canvas Variation - Canvas Level Reporting: braze_lifecycle_cohorts.canvas_variation_name
      Days Canvas Duration: braze_lifecycle_cohorts.days_canvas_journey_duration
    row: 17
    col: 12
    width: 12
    height: 7
  - title: 'Incrementality (Absolute, #) in Users Ordered'
    name: 'Incrementality (Absolute, #) in Users Ordered'
    model: flink_v3
    explore: lifecycle_cohorts_reporting
    type: looker_column
    fields: [braze_lifecycle_cohorts.cohort_week, braze_lifecycle_cohorts.canvas_variation_name,
      braze_lifecycle_cohorts.absolute_incrementality_of_share_of_customers_ordered]
    pivots: [braze_lifecycle_cohorts.canvas_variation_name]
    fill_fields: [braze_lifecycle_cohorts.cohort_week]
    filters:
      braze_lifecycle_cohorts.is_control_group: 'No'
    sorts: [braze_lifecycle_cohorts.cohort_week, braze_lifecycle_cohorts.canvas_variation_name]
    limit: 500
    column_limit: 50
    dynamic_fields: [{category: table_calculation, expression: "(pivot_index(${braze_lifecycle_cohorts.share_of_customers_visited},\
          \ 2) - pivot_index(${braze_lifecycle_cohorts.share_of_customers_visited},\
          \ 1))*100", label: Customers Visited Incrementality, value_format: !!null '',
        value_format_name: decimal_2, _kind_hint: supermeasure, table_calculation: customers_visited_incrementality,
        _type_hint: number, is_disabled: true}, {category: table_calculation, expression: "(pivot_index(${braze_lifecycle_cohorts.share_of_customers_ordered},\
          \ 2) - pivot_index(${braze_lifecycle_cohorts.share_of_customers_ordered},\
          \ 1))*100", label: Customers Ordered Incrementality, value_format: !!null '',
        value_format_name: decimal_2, _kind_hint: supermeasure, table_calculation: customers_ordered_incrementality,
        _type_hint: number, is_disabled: true}]
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
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    y_axes: [{label: '', orientation: left, series: [{axisId: braze_lifecycle_cohorts.absolute_incrementality_of_share_of_customers_ordered,
            id: 1PN - braze_lifecycle_cohorts.absolute_incrementality_of_share_of_customers_ordered,
            name: 1PN}, {axisId: braze_lifecycle_cohorts.absolute_incrementality_of_share_of_customers_ordered,
            id: 2PN - braze_lifecycle_cohorts.absolute_incrementality_of_share_of_customers_ordered,
            name: 2PN}, {axisId: braze_lifecycle_cohorts.absolute_incrementality_of_share_of_customers_ordered,
            id: Aggressive - braze_lifecycle_cohorts.absolute_incrementality_of_share_of_customers_ordered,
            name: Aggressive}, {axisId: braze_lifecycle_cohorts.absolute_incrementality_of_share_of_customers_ordered,
            id: Chill - braze_lifecycle_cohorts.absolute_incrementality_of_share_of_customers_ordered,
            name: Chill}, {axisId: braze_lifecycle_cohorts.absolute_incrementality_of_share_of_customers_ordered,
            id: CODEAPPEARS - braze_lifecycle_cohorts.absolute_incrementality_of_share_of_customers_ordered,
            name: CODEAPPEARS}, {axisId: braze_lifecycle_cohorts.absolute_incrementality_of_share_of_customers_ordered,
            id: CODEDISPLAYED - braze_lifecycle_cohorts.absolute_incrementality_of_share_of_customers_ordered,
            name: CODEDISPLAYED}, {axisId: braze_lifecycle_cohorts.absolute_incrementality_of_share_of_customers_ordered,
            id: Evening - braze_lifecycle_cohorts.absolute_incrementality_of_share_of_customers_ordered,
            name: Evening}, {axisId: braze_lifecycle_cohorts.absolute_incrementality_of_share_of_customers_ordered,
            id: EXISTING - braze_lifecycle_cohorts.absolute_incrementality_of_share_of_customers_ordered,
            name: EXISTING}, {axisId: braze_lifecycle_cohorts.absolute_incrementality_of_share_of_customers_ordered,
            id: INVERSE - braze_lifecycle_cohorts.absolute_incrementality_of_share_of_customers_ordered,
            name: INVERSE}, {axisId: braze_lifecycle_cohorts.absolute_incrementality_of_share_of_customers_ordered,
            id: Morning - braze_lifecycle_cohorts.absolute_incrementality_of_share_of_customers_ordered,
            name: Morning}, {axisId: braze_lifecycle_cohorts.absolute_incrementality_of_share_of_customers_ordered,
            id: no_voucher - braze_lifecycle_cohorts.absolute_incrementality_of_share_of_customers_ordered,
            name: no_voucher}, {axisId: braze_lifecycle_cohorts.absolute_incrementality_of_share_of_customers_ordered,
            id: NOCODE - braze_lifecycle_cohorts.absolute_incrementality_of_share_of_customers_ordered,
            name: NOCODE}, {axisId: braze_lifecycle_cohorts.absolute_incrementality_of_share_of_customers_ordered,
            id: NOCODEAPPEARS - braze_lifecycle_cohorts.absolute_incrementality_of_share_of_customers_ordered,
            name: NOCODEAPPEARS}, {axisId: braze_lifecycle_cohorts.absolute_incrementality_of_share_of_customers_ordered,
            id: Noon - braze_lifecycle_cohorts.absolute_incrementality_of_share_of_customers_ordered,
            name: Noon}, {axisId: braze_lifecycle_cohorts.absolute_incrementality_of_share_of_customers_ordered,
            id: VARIANT - braze_lifecycle_cohorts.absolute_incrementality_of_share_of_customers_ordered,
            name: VARIANT}, {axisId: braze_lifecycle_cohorts.absolute_incrementality_of_share_of_customers_ordered,
            id: Variant 1 - braze_lifecycle_cohorts.absolute_incrementality_of_share_of_customers_ordered,
            name: Variant 1}, {axisId: braze_lifecycle_cohorts.absolute_incrementality_of_share_of_customers_ordered,
            id: Variant 2 - braze_lifecycle_cohorts.absolute_incrementality_of_share_of_customers_ordered,
            name: Variant 2}, {axisId: braze_lifecycle_cohorts.absolute_incrementality_of_share_of_customers_ordered,
            id: Variant 3 - braze_lifecycle_cohorts.absolute_incrementality_of_share_of_customers_ordered,
            name: Variant 3}, {axisId: braze_lifecycle_cohorts.absolute_incrementality_of_share_of_customers_ordered,
            id: Variant_1 - braze_lifecycle_cohorts.absolute_incrementality_of_share_of_customers_ordered,
            name: Variant_1}, {axisId: braze_lifecycle_cohorts.absolute_incrementality_of_share_of_customers_ordered,
            id: Variant_1PN - braze_lifecycle_cohorts.absolute_incrementality_of_share_of_customers_ordered,
            name: Variant_1PN}, {axisId: braze_lifecycle_cohorts.absolute_incrementality_of_share_of_customers_ordered,
            id: Variant_2PN - braze_lifecycle_cohorts.absolute_incrementality_of_share_of_customers_ordered,
            name: Variant_2PN}, {axisId: braze_lifecycle_cohorts.absolute_incrementality_of_share_of_customers_ordered,
            id: Variant1 - braze_lifecycle_cohorts.absolute_incrementality_of_share_of_customers_ordered,
            name: Variant1}, {axisId: braze_lifecycle_cohorts.absolute_incrementality_of_share_of_customers_ordered,
            id: Voucher_up - braze_lifecycle_cohorts.absolute_incrementality_of_share_of_customers_ordered,
            name: Voucher_up}, {axisId: braze_lifecycle_cohorts.absolute_incrementality_of_share_of_customers_ordered,
            id: WithoutCopy - braze_lifecycle_cohorts.absolute_incrementality_of_share_of_customers_ordered,
            name: WithoutCopy}], showLabels: false, showValues: false, unpinAxis: false,
        tickDensity: default, type: linear}]
    x_axis_zoom: true
    y_axis_zoom: true
    series_types: {}
    series_colors:
      customers_with_orders_incrementality: "#69aae4"
      customers_visited_incrementality: "#69aae4"
      customers_ordered_incrementality: "#fcb2d3"
      braze_lifecycle_cohorts.incrementality_of_share_of_customers_ordered: "#69aae4"
      braze_lifecycle_cohorts.incrementality_of_share_of_customers_visited: "#ffb063"
    reference_lines: []
    trend_lines: []
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    hidden_pivots: {}
    note_state: collapsed
    note_display: above
    note_text: Absolute number of customers that placed an order resulted by Canvas
    listen:
      Cohort Entry Date: braze_lifecycle_cohorts.cohort_date
      Canvas Name: braze_lifecycle_cohorts.canvas_name
      Canvas Variation - Canvas Level Reporting: braze_lifecycle_cohorts.canvas_variation_name
      Days Canvas Duration: braze_lifecycle_cohorts.days_canvas_journey_duration
    row: 24
    col: 0
    width: 12
    height: 7
  - name: " (Copy 7)"
    type: text
    title_text: " (Copy 7)"
    subtitle_text: ''
    body_text: '[{"type":"h2","id":1673431270514,"children":[{"text":"Incrementality
      calculation"}]},{"type":"p","id":1673436484508,"children":[{"text":""}]},{"type":"p","id":1676912460573,"children":[{"text":"Incrementality
      calculation is not based on a proper A/B test, but rather on a simple comparison
      of variant and control groups. In this dashboard the check on statistical significance
      is not performed. ","color":"hsl(0, 100%, 50%)"}]},{"type":"p","id":1676913201013,"children":[{"text":"This
      is the description of logic behind calculation of incrementality metrics:"}]},{"type":"p","id":1673436693192,"children":[{"text":"a)
      "},{"text":"Incrementality (Relative, %) in Users Ordered or Visited ","bold":true},{"text":"-
      for what % does this canvas increase the share of customers that are activated
      (placed an order or made an app/web visit) because of the CRM contact. "}]},{"type":"p","id":1673594928680,"children":[{"text":"b)
      "},{"text":"Incrementality (Absolute, pp) in Users Ordered or Visited","bold":true},{"text":"
      - what % of customers that entered this canvas are activated (placed an order
      or made an app/web visit) thanks to the CRM contact"}]},{"type":"p","children":[{"text":"c)
      "},{"text":"Incrementality (Absolute, #) in Users Ordered or Visited","bold":true},{"text":"
      - what is the absolute number of customers that entered this canvas and were
      activated (placed an order or made an app/web visit) "},{"text":"purely","bold":true},{"text":"
      thanks to the CRM contact"}],"id":1676912521781},{"type":"p","id":1673594953662,"children":[{"text":"Example:"}]},{"type":"p","id":1673594957535,"children":[{"text":"Let''s
      assume that "},{"text":"% Users Ordered","bold":true},{"text":" is "},{"text":"10%","bold":true},{"text":"
      in "},{"text":"[Control]","bold":true},{"text":" group and "},{"text":"12%","bold":true},{"text":"
      in "},{"text":"[Variant]","bold":true},{"text":" group"}]},{"type":"p","children":[{"text":"Incrementality
      (Relative, %) in Users Ordered ","bold":true},{"text":"is calculated as ( "},{"text":"[Variant]
      - [Control] ) / [Control], ","bold":true},{"text":" in this case it is (0.12
      - 0.10)/0.10 = 0.20 = 20% "}],"id":1673595018858},{"type":"p","children":[{"text":"Incrementality
      (Absolute, pp) in Users Ordered ","bold":true},{"text":"is calculated as ( "},{"text":"[Variant]
      - [Control] ),","bold":true},{"text":" in this case is 0.12 - 0.10 = 0.02 =
      2 pp (percentage points)"}],"id":1673595082849},{"type":"p","children":[{"text":"Incrementality
      (Absolute, #) in Users Ordered ","bold":true},{"text":"is calculated as "},{"text":"[Number
      of Variant Users] x","bold":true},{"text":" ( "},{"text":"[Variant] - [Control]
      )","bold":true},{"text":" in this case is 100 x 0.02 = 2 users"}],"id":1676912596693}]'
    rich_content_json: '{"format":"slate"}'
    row: 10
    col: 0
    width: 24
    height: 7
  filters:
  - name: Cohort Entry Date
    title: Cohort Entry Date
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
      options: []
    model: flink_v3
    explore: lifecycle_cohorts_reporting
    listens_to_filters: []
    field: braze_lifecycle_cohorts.cohort_date
  - name: Canvas Name
    title: Canvas Name
    type: field_filter
    default_value: ''
    allow_multiple_values: false
    required: false
    ui_config:
      type: advanced
      display: popover
      options: []
    model: flink_v3
    explore: lifecycle_cohorts_reporting
    listens_to_filters: []
    field: braze_lifecycle_cohorts.canvas_name
  - name: Canvas Variation - Canvas Level Reporting
    title: Canvas Variation - Canvas Level Reporting
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
    model: flink_v3
    explore: lifecycle_cohorts_reporting
    listens_to_filters: [Canvas Name]
    field: braze_lifecycle_cohorts.canvas_variation_name
  - name: Variant 1 - Variation Level Reporting
    title: Variant 1 - Variation Level Reporting
    type: field_filter
    default_value: ''
    allow_multiple_values: false
    required: false
    ui_config:
      type: advanced
      display: popover
    model: flink_v3
    explore: lifecycle_cohorts_reporting
    listens_to_filters: [Canvas Name]
    field: braze_lifecycle_cohorts.canvas_variation_name
  - name: " Variant 2 - Variation Level Reporting"
    title: " Variant 2 - Variation Level Reporting"
    type: field_filter
    default_value: ''
    allow_multiple_values: false
    required: false
    ui_config:
      type: advanced
      display: popover
    model: flink_v3
    explore: lifecycle_cohorts_reporting
    listens_to_filters: [Canvas Name]
    field: braze_lifecycle_cohorts.canvas_variation_name
  - name: Days Canvas Duration
    title: Days Canvas Duration
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
      options: []
    model: flink_v3
    explore: lifecycle_cohorts_reporting
    listens_to_filters: []
    field: braze_lifecycle_cohorts.days_canvas_journey_duration
