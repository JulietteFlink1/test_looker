- dashboard: nps_comments_analysis
  title: NPS Comments Analysis
  layout: newspaper
  preferred_viewer: dashboards-next
  elements:
  - title: "# NPS Responses"
    name: "# NPS Responses"
    model: flink_v3
    explore: nps_comments
    type: single_value
    fields: [nps_comments_labeled.num_responses]
    limit: 500
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
    defaults_version: 1
    listen:
      Group: nps_comments_labeled.customer_group
      "# Word Occurrences": nps_comments_words_count.num_occurrences
    row: 0
    col: 6
    width: 7
    height: 3
  - title: Global NPS
    name: Global NPS
    model: flink_v3
    explore: nps_comments
    type: single_value
    fields: [nps_comments_labeled.avg_nps]
    limit: 500
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
    custom_color: "#E31C79"
    defaults_version: 1
    listen:
      Group: nps_comments_labeled.customer_group
      "# Word Occurrences": nps_comments_words_count.num_occurrences
    row: 0
    col: 0
    width: 6
    height: 3
  - title: Most Popular Words
    name: Most Popular Words
    model: flink_v3
    explore: nps_comments
    type: looker_grid
    fields: [nps_comments_words_count.word, nps_comments_words_count.num_occurrences]
    filters:
      nps_comments_words_count.is_bigram: '0'
    sorts: [nps_comments_words_count.num_occurrences desc]
    limit: 500
    column_limit: 50
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
    series_cell_visualizations:
      nps_comments_words_count.num_occurrences:
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
    series_types: {}
    point_style: none
    series_colors:
      nps_comments_words_count.num_occurrences: "#4276BE"
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    show_null_points: true
    defaults_version: 1
    listen:
      Group: nps_comments_labeled.customer_group
      "# Word Occurrences": nps_comments_words_count.num_occurrences
    row: 3
    col: 0
    width: 12
    height: 8
  - title: Most Popular Bigrams
    name: Most Popular Bigrams
    model: flink_v3
    explore: nps_comments
    type: looker_grid
    fields: [nps_comments_words_count.word, nps_comments_words_count.num_occurrences]
    filters:
      nps_comments_words_count.is_bigram: '1'
    sorts: [nps_comments_words_count.num_occurrences desc]
    limit: 500
    column_limit: 50
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
    series_cell_visualizations:
      nps_comments_words_count.num_occurrences:
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
    series_types: {}
    point_style: none
    series_colors:
      nps_comments_words_count.num_occurrences: "#4276BE"
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    show_null_points: true
    defaults_version: 1
    listen:
      Group: nps_comments_labeled.customer_group
      "# Word Occurrences": nps_comments_words_count.num_occurrences
    row: 3
    col: 12
    width: 12
    height: 8
  filters:
  - name: Group
    title: Group
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: button_group
      display: inline
      options: []
    model: flink_v3
    explore: nps_comments
    listens_to_filters: []
    field: nps_comments_labeled.customer_group
  - name: "# Word Occurrences"
    title: "# Word Occurrences"
    type: field_filter
    default_value: ">=25"
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
      options:
      - '1'
      - '2'
      - '3'
    model: flink_v3
    explore: nps_comments
    listens_to_filters: []
    field: nps_comments_words_count.num_occurrences
