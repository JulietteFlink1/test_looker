- dashboard: hubs_daily
  title: Hubs Daily (CT migrated)
  layout: newspaper
  preferred_viewer: dashboards-next
  elements:

  - title: Top 10 Hubs by Orders Delivered in Time
    name: Top 10 Hubs by Orders Delivered in Time
    model: flink_v3
    explore: hub_level_kpis
    type: looker_grid
    fields: [
      hubs.hub_name,
      hub_level_kpis.pct_delivery_in_time,
      hub_level_kpis.pct_delivery_late_over_5_min,
      # shyftplan_riders_pickers_hours.rider_utr,
      hub_level_kpis.percent_of_total_orders_col,
      hub_level_kpis.sum_number_of_orders
      ]
    filters:
      hub_level_kpis.is_successful_order: 'yes'
      is_hub_name_null: 'No'
    sorts: [hub_level_kpis.pct_delivery_in_time desc]
    limit: 500
    dynamic_fields: [{dimension: is_hub_name_null, _kind_hint: dimension, _type_hint: yesno,
        category: dimension, expression: 'if(is_null(${hubs.hub_name}), yes, no)',
        label: Is Hub Name Null, value_format: !!null '', value_format_name: !!null ''}]
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
      order_order.pct_delivery_in_time:
        is_active: true
        palette:
          palette_id: 67cc9932-da56-fa64-7c2e-d383dbfb4efb
          collection_id: product-custom-collection
          custom_colors:
          - "#DC2011"
          - "#FF9896"
          - "#439B66"
    limit_displayed_rows_values:
      show_hide: show
      first_last: first
      num_rows: '10'
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
      Hub Name: hubs.hub_name
      Order Date: hub_level_kpis.order_date
      Country: hubs.country
    row: 0
    col: 0
    width: 24
    height: 6

  - title: Bottom 10 Hubs by Orders Delivered in Time
    name: Bottom 10 Hubs by Orders Delivered in Time
    model: flink_v3
    explore: hub_level_kpis
    type: looker_grid
    fields: [
      hubs.hub_name,
      hub_level_kpis.pct_delivery_in_time,
      hub_level_kpis.pct_delivery_late_over_5_min,
      # shyftplan_riders_pickers_hours.rider_utr,
      hub_level_kpis.percent_of_total_orders_col,
      hub_level_kpis.sum_number_of_orders
      ]
    filters:
      hub_level_kpis.is_successful_order: 'yes'
    sorts: [hub_level_kpis.pct_delivery_in_time]
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
    limit_displayed_rows: true
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
      order_order.pct_delivery_in_time:
        is_active: true
        palette:
          palette_id: 42ea1871-c645-a886-92f4-562c03cfa2ae
          collection_id: product-custom-collection
          custom_colors:
          - "#DC2011"
          - "#FF9896"
          - "#439B66"
    limit_displayed_rows_values:
      show_hide: show
      first_last: first
      num_rows: '10'
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
      Hub Name: hubs.hub_name
      Order Date: hub_level_kpis.order_date
      Country: hubs.country
    row: 6
    col: 0
    width: 24
    height: 6

  - title: Top 10 Hubs by NPS
    name: Top 10 Hubs by NPS
    model: flink_v3
    explore: hub_level_kpis
    type: looker_grid
    fields: [
      hubs.hub_name,
      hub_level_kpis.nps_score,
      hub_level_kpis.sum_number_of_nps_responses,
      hub_level_kpis.order_date
      ]
    filters:
      hub_level_kpis.is_successful_order: 'yes'
      hub_level_kpis.sum_number_of_nps_responses: ">=2"
      hub_level_kpis.order_date: after 2021/01/25
    sorts: [hub_level_kpis.nps_score desc]
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
    limit_displayed_rows: true
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
      nps_after_order.nps_score:
        is_active: true
        palette:
          palette_id: e8f495e6-3dfb-8872-84b9-86a304fb217b
          collection_id: product-custom-collection
          custom_colors:
          - "#DC2011"
          - "#FF9896"
          - "#439B66"
    limit_displayed_rows_values:
      show_hide: show
      first_last: first
      num_rows: '10'
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
      Hub Name: hubs.hub_name
      # NPS Submitted Date: hub_level_kpis.order_date
      Country: hubs.country
    row: 15
    col: 0
    width: 12
    height: 6

  - title: Bottom 10 Hubs by NPS
    name: Bottom 10 Hubs by NPS
    model: flink_v3
    explore: order_order
    type: looker_grid
    fields: [hubs.hub_name, nps_after_order.nps_score, nps_after_order.submitted_date,
      nps_after_order.cnt_responses]
    filters:
      order_order.is_internal_order: 'no'
      order_order.is_successful_order: 'yes'
      order_order.created_date: after 2021/01/25
      nps_after_order.cnt_responses: ">=2"
    sorts: [nps_after_order.nps_score]
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
    limit_displayed_rows: true
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
      nps_after_order.nps_score:
        is_active: true
        palette:
          palette_id: 605f345c-2ed4-6af3-099e-de8e2ba99219
          collection_id: product-custom-collection
          custom_colors:
          - "#DC2011"
          - "#FF9896"
          - "#439B66"
    limit_displayed_rows_values:
      show_hide: show
      first_last: first
      num_rows: '10'
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
      Hub Name: hubs.hub_name
      NPS Submitted Date: nps_after_order.submitted_date
      Country: hubs.country
    row: 15
    col: 12
    width: 12
    height: 6
  - title: NPS Comments
    name: NPS Comments
    model: flink_v3
    explore: order_order
    type: looker_grid
    fields: [hubs.hub_name, nps_after_order.submitted_date, nps_after_order.nps_driver,
      nps_after_order.nps_comment, nps_after_order.score]
    filters:
      order_order.is_internal_order: 'no'
      order_order.is_successful_order: 'yes'
      order_order.created_date: after 2021/01/25
      nps_after_order.cnt_responses: ''
    sorts: [nps_after_order.submitted_date desc]
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
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    series_cell_visualizations:
      nps_after_order.nps_score:
        is_active: false
      nps_after_order.score:
        is_active: true
        palette:
          palette_id: 8089b298-5691-0629-654b-b16607f17068
          collection_id: product-custom-collection
          custom_colors:
          - "#DC2011"
          - "#FF9896"
          - "#439B66"
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
      Hub Name: hubs.hub_name
      NPS Submitted Date: nps_after_order.submitted_date
      Country: hubs.country
    row: 21
    col: 0
    width: 24
    height: 8
  - name: ''
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: "##### Use **\"NPS Submitted Date\" filter** for NPS views. \n\n#####\
      \ IMPORTANT: other Looker dashboards with NPS scores are based on Order Date,\
      \ therefore you can not compare them.\nNPS survey is usually sent 1 day after\
      \ the order date."
    row: 12
    col: 0
    width: 24
    height: 3
  - title: Top 10 Hubs by % Issue Rate
    name: Top 10 Hubs by % Issue Rate
    model: flink_v3
    explore: order_order
    type: looker_grid
    fields: [hubs.hub_name, issue_rate_hub_level.pct_orders_with_issues, issue_rate_hub_level.sum_orders_total,
      issue_rate_hub_level.pct_orders_perished_product, issue_rate_hub_level.pct_orders_damaged_product,
      issue_rate_hub_level.pct_orders_missing_product, issue_rate_hub_level.pct_orders_wrong_order,
      issue_rate_hub_level.pct_orders_wrong_product, order_order.created_date]
    filters:
      hubs.hub_name: "-NULL"
      order_order.is_internal_order: 'no'
      order_order.is_successful_order: 'yes'
    sorts: [issue_rate_hub_level.pct_orders_with_issues]
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
    limit_displayed_rows: true
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    series_column_widths:
      hubs.hub_name: 198
      issue_rate_hub_level.pct_orders_with_issues: 97
      issue_rate_hub_level.sum_orders_total: 104
      issue_rate_hub_level.pct_orders_perished_product: 192
      issue_rate_hub_level.pct_orders_damaged_product: 196
      issue_rate_hub_level.pct_orders_missing_product: 187
      issue_rate_hub_level.pct_orders_wrong_order: 167
      issue_rate_hub_level.pct_orders_wrong_product: 180
    series_cell_visualizations:
      issue_rate_hub_level.pct_orders_with_issues:
        is_active: true
        palette:
          palette_id: b412b2b6-fad6-45e6-f490-ef7428bef44d
          collection_id: product-custom-collection
          custom_colors:
          - "#439B66"
          - "#FF9896"
          - "#DC2011"
    limit_displayed_rows_values:
      show_hide: show
      first_last: first
      num_rows: '10'
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
    hidden_fields: []
    y_axes: []
    listen:
      Order Date: order_order.created_date
      Country: hubs.country
    row: 29
    col: 0
    width: 24
    height: 6
  - title: Bottom 10 Hubs by % Issue Rate
    name: Bottom 10 Hubs by % Issue Rate
    model: flink_v3
    explore: order_order
    type: looker_grid
    fields: [hubs.hub_name, issue_rate_hub_level.pct_orders_with_issues, issue_rate_hub_level.sum_orders_total,
      issue_rate_hub_level.pct_orders_perished_product, issue_rate_hub_level.pct_orders_damaged_product,
      issue_rate_hub_level.pct_orders_missing_product, issue_rate_hub_level.pct_orders_wrong_order,
      issue_rate_hub_level.pct_orders_wrong_product, order_order.created_date]
    filters:
      hubs.hub_name: "-NULL"
      order_order.is_internal_order: 'no'
      order_order.is_successful_order: 'yes'
    sorts: [issue_rate_hub_level.pct_orders_with_issues desc]
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
    limit_displayed_rows: true
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    series_column_widths:
      hubs.hub_name: 198
      issue_rate_hub_level.pct_orders_with_issues: 97
      issue_rate_hub_level.sum_orders_total: 104
      issue_rate_hub_level.pct_orders_perished_product: 192
      issue_rate_hub_level.pct_orders_damaged_product: 196
      issue_rate_hub_level.pct_orders_missing_product: 187
      issue_rate_hub_level.pct_orders_wrong_order: 167
      issue_rate_hub_level.pct_orders_wrong_product: 180
    series_cell_visualizations:
      issue_rate_hub_level.pct_orders_with_issues:
        is_active: true
        palette:
          palette_id: b412b2b6-fad6-45e6-f490-ef7428bef44d
          collection_id: product-custom-collection
          custom_colors:
          - "#439B66"
          - "#FF9896"
          - "#DC2011"
    limit_displayed_rows_values:
      show_hide: show
      first_last: first
      num_rows: '10'
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
    hidden_fields: []
    y_axes: []
    listen:
      Order Date: order_order.created_date
      Country: hubs.country
    row: 35
    col: 0
    width: 24
    height: 6
  filters:
  - name: Order Date
    title: Order Date
    type: field_filter
    default_value: yesterday
    allow_multiple_values: true
    required: false
    ui_config:
      type: relative_timeframes
      display: inline
      options: []
    model: flink_v3
    explore: order_order
    listens_to_filters: []
    field: order_order.created_date
  - name: NPS Submitted Date
    title: NPS Submitted Date
    type: field_filter
    default_value: yesterday
    allow_multiple_values: true
    required: false
    ui_config:
      type: relative_timeframes
      display: inline
      options: []
    model: flink_v3
    explore: order_order
    listens_to_filters: []
    field: nps_after_order.submitted_date
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
    explore: order_order
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
    explore: order_order
    listens_to_filters: []
    field: hubs.hub_name
