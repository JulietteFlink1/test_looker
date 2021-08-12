- dashboard: 2_city_overview_migrated
  title: "(2) City Overview"
  layout: newspaper
  preferred_viewer: dashboards-next
  elements:
  - title: Total Hubs
    name: Total Hubs
    model: flink_v3
    explore: order_order
    type: single_value
    fields: [order_order.created_date, order_order.cnt_unique_hubs]
    filters:
      order_order.is_internal_order: 'no'
      order_order.is_successful_order: 'yes'
      order_order.created_date: 2 weeks ago for 2 weeks
      hubs.live: ''
      hubs.country: Germany,France,Netherlands
      hubs.hub_name: ''
      hubs.city: ''
    sorts: [order_order.created_date desc]
    limit: 500
    column_limit: 50
    dynamic_fields: [{table_calculation: hubs_live, label: "# Hubs Live", expression: 'max(offset_list(${order_order.cnt_unique_hubs},0,3))',
        value_format: !!null '', value_format_name: !!null '', _kind_hint: measure,
        _type_hint: number}, {table_calculation: wow, label: WoW, expression: "(${hubs_live}\
          \ - offset(${hubs_live}, 7)) / offset(${hubs_live}, 7)", value_format: !!null '',
        value_format_name: percent_0, is_disabled: false, _kind_hint: measure, _type_hint: number}]
    query_timezone: Europe/Berlin
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    color_application:
      collection_id: product-custom-collection
      palette_id: product-custom-collection-categorical-0
    custom_color: "#e5508e"
    single_value_title: Total Hubs
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
    show_x_axis_ticks: false
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
    y_axes: [{label: '', orientation: left, series: [{axisId: hubs.cnt_distinct_hubs,
            id: hubs.cnt_distinct_hubs, name: Cnt Distinct Hubs}], showLabels: false,
        showValues: false, unpinAxis: false, tickDensity: default, tickDensityCustom: 5,
        type: linear}]
    series_types: {}
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    header_text_alignment: left
    header_font_size: 12
    rows_font_size: 12
    defaults_version: 1
    hidden_fields: [order_order.cnt_unique_hubs]
    listen: {}
    row: 0
    col: 3
    width: 3
    height: 3
  - name: 'Flink # Hubs:'
    type: text
    title_text: 'Flink # Hubs:'
    subtitle_text: ''
    body_text: ''
    row: 0
    col: 0
    width: 3
    height: 3
  - title: DE Hubs
    name: DE Hubs
    model: flink_v3
    explore: order_order
    type: single_value
    fields: [order_order.created_date, order_order.cnt_unique_hubs]
    filters:
      order_order.is_internal_order: 'no'
      order_order.is_successful_order: 'yes'
      order_order.created_date: 2 weeks ago for 2 weeks
      hubs.live: ''
      hubs.country: Germany
      hubs.hub_name: ''
      hubs.city: ''
    sorts: [order_order.created_date desc]
    limit: 500
    column_limit: 50
    dynamic_fields: [{table_calculation: hubs_live, label: "# Hubs Live", expression: 'max(offset_list(${order_order.cnt_unique_hubs},0,3))',
        value_format: !!null '', value_format_name: !!null '', _kind_hint: measure,
        _type_hint: number}, {table_calculation: wow, label: WoW, expression: "(${hubs_live}\
          \ - offset(${hubs_live}, 7)) / offset(${hubs_live}, 7)", value_format: !!null '',
        value_format_name: percent_0, is_disabled: false, _kind_hint: measure, _type_hint: number}]
    query_timezone: Europe/Berlin
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    color_application:
      collection_id: product-custom-collection
      palette_id: product-custom-collection-categorical-0
    custom_color: "#e5508e"
    single_value_title: DE
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
    show_x_axis_ticks: false
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
    y_axes: [{label: '', orientation: left, series: [{axisId: hubs.cnt_distinct_hubs,
            id: hubs.cnt_distinct_hubs, name: Cnt Distinct Hubs}], showLabels: false,
        showValues: false, unpinAxis: false, tickDensity: default, tickDensityCustom: 5,
        type: linear}]
    series_types: {}
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    header_text_alignment: left
    header_font_size: 12
    rows_font_size: 12
    defaults_version: 1
    hidden_fields: [order_order.cnt_unique_hubs]
    listen: {}
    row: 0
    col: 6
    width: 2
    height: 3
  - title: FR Hubs
    name: FR Hubs
    model: flink_v3
    explore: order_order
    type: single_value
    fields: [order_order.created_date, order_order.cnt_unique_hubs]
    filters:
      order_order.is_internal_order: 'no'
      order_order.is_successful_order: 'yes'
      order_order.created_date: 2 weeks ago for 2 weeks
      hubs.live: ''
      hubs.country: France
      hubs.hub_name: ''
      hubs.city: ''
    sorts: [order_order.created_date desc]
    limit: 500
    column_limit: 50
    dynamic_fields: [{table_calculation: hubs_live, label: "# Hubs Live", expression: 'max(offset_list(${order_order.cnt_unique_hubs},0,3))',
        value_format: !!null '', value_format_name: !!null '', _kind_hint: measure,
        _type_hint: number}, {table_calculation: wow, label: WoW, expression: "(${hubs_live}\
          \ - offset(${hubs_live}, 7)) / offset(${hubs_live}, 7)", value_format: !!null '',
        value_format_name: percent_0, is_disabled: false, _kind_hint: measure, _type_hint: number}]
    query_timezone: Europe/Berlin
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    color_application:
      collection_id: product-custom-collection
      palette_id: product-custom-collection-categorical-0
    custom_color: "#e5508e"
    single_value_title: FR
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
    show_x_axis_ticks: false
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
    y_axes: [{label: '', orientation: left, series: [{axisId: hubs.cnt_distinct_hubs,
            id: hubs.cnt_distinct_hubs, name: Cnt Distinct Hubs}], showLabels: false,
        showValues: false, unpinAxis: false, tickDensity: default, tickDensityCustom: 5,
        type: linear}]
    series_types: {}
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    header_text_alignment: left
    header_font_size: 12
    rows_font_size: 12
    defaults_version: 1
    hidden_fields: [order_order.cnt_unique_hubs]
    listen: {}
    row: 0
    col: 10
    width: 2
    height: 3
  - title: NL Hubs
    name: NL Hubs
    model: flink_v3
    explore: order_order
    type: single_value
    fields: [order_order.created_date, order_order.cnt_unique_hubs]
    filters:
      order_order.is_internal_order: 'no'
      order_order.is_successful_order: 'yes'
      order_order.created_date: 2 weeks ago for 2 weeks
      hubs.live: ''
      hubs.country: Netherlands
      hubs.hub_name: ''
      hubs.city: ''
    sorts: [order_order.created_date desc]
    limit: 500
    column_limit: 50
    dynamic_fields: [{table_calculation: hubs_live, label: "# Hubs Live", expression: 'max(offset_list(${order_order.cnt_unique_hubs},0,3))',
        value_format: !!null '', value_format_name: !!null '', _kind_hint: measure,
        _type_hint: number}, {table_calculation: wow, label: WoW, expression: "(${hubs_live}\
          \ - offset(${hubs_live}, 7)) / offset(${hubs_live}, 7)", value_format: !!null '',
        value_format_name: percent_0, is_disabled: false, _kind_hint: measure, _type_hint: number}]
    query_timezone: Europe/Berlin
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    color_application:
      collection_id: product-custom-collection
      palette_id: product-custom-collection-categorical-0
    custom_color: "#e5508e"
    single_value_title: NL
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
    show_x_axis_ticks: false
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
    y_axes: [{label: '', orientation: left, series: [{axisId: hubs.cnt_distinct_hubs,
            id: hubs.cnt_distinct_hubs, name: Cnt Distinct Hubs}], showLabels: false,
        showValues: false, unpinAxis: false, tickDensity: default, tickDensityCustom: 5,
        type: linear}]
    series_types: {}
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    header_text_alignment: left
    header_font_size: 12
    rows_font_size: 12
    defaults_version: 1
    hidden_fields: [order_order.cnt_unique_hubs]
    listen: {}
    row: 0
    col: 8
    width: 2
    height: 3
  - title: Gorillas Hubs Total (same markets)
    name: Gorillas Hubs Total (same markets)
    model: flink_v3
    explore: gorillas_hub_counts
    type: single_value
    fields: [gorillas_hub_counts.date, gorillas_hub_counts.gorillas_hub_count]
    filters:
      gorillas_hub_counts.country_iso: DE,NL,FR
    sorts: [gorillas_hub_counts.date desc]
    limit: 1
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    custom_color: "#000000"
    single_value_title: Total Hubs
    conditional_formatting: [{type: equal to, value: !!null '', background_color: "#c76b4e",
        font_color: !!null '', color_application: {collection_id: product-custom-collection,
          palette_id: product-custom-collection-sequential-0}, bold: false, italic: false,
        strikethrough: false, fields: !!null ''}]
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
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    series_types: {}
    hidden_fields: []
    y_axes: []
    listen: {}
    row: 3
    col: 3
    width: 3
    height: 3
  - title: Gorillas Hubs DE
    name: Gorillas Hubs DE
    model: flink_v3
    explore: gorillas_hub_counts
    type: single_value
    fields: [gorillas_hub_counts.date, gorillas_hub_counts.gorillas_hub_count]
    filters:
      gorillas_hub_counts.country_iso: DE
    sorts: [gorillas_hub_counts.date desc]
    limit: 1
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    custom_color: "#000000"
    single_value_title: DE
    conditional_formatting: [{type: equal to, value: !!null '', background_color: "#c76b4e",
        font_color: !!null '', color_application: {collection_id: product-custom-collection,
          palette_id: product-custom-collection-sequential-0}, bold: false, italic: false,
        strikethrough: false, fields: !!null ''}]
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
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    series_types: {}
    hidden_fields: []
    y_axes: []
    listen: {}
    row: 3
    col: 6
    width: 2
    height: 3
  - title: Gorillas Hubs FR
    name: Gorillas Hubs FR
    model: flink_v3
    explore: gorillas_hub_counts
    type: single_value
    fields: [gorillas_hub_counts.date, gorillas_hub_counts.gorillas_hub_count]
    filters:
      gorillas_hub_counts.country_iso: FR
    sorts: [gorillas_hub_counts.date desc]
    limit: 1
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    custom_color: "#000000"
    single_value_title: FR
    conditional_formatting: [{type: equal to, value: !!null '', background_color: "#c76b4e",
        font_color: !!null '', color_application: {collection_id: product-custom-collection,
          palette_id: product-custom-collection-sequential-0}, bold: false, italic: false,
        strikethrough: false, fields: !!null ''}]
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
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    series_types: {}
    hidden_fields: []
    y_axes: []
    listen: {}
    row: 3
    col: 10
    width: 2
    height: 3
  - title: New Tile
    name: New Tile
    model: flink_v3
    explore: gorillas_hub_counts
    type: single_value
    fields: [gorillas_hub_counts.date, gorillas_hub_counts.gorillas_hub_count]
    filters:
      gorillas_hub_counts.country_iso: NL
    sorts: [gorillas_hub_counts.date desc]
    limit: 1
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    custom_color: "#000000"
    single_value_title: NL
    conditional_formatting: [{type: equal to, value: !!null '', background_color: "#c76b4e",
        font_color: !!null '', color_application: {collection_id: product-custom-collection,
          palette_id: product-custom-collection-sequential-0}, bold: false, italic: false,
        strikethrough: false, fields: !!null ''}]
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
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    series_types: {}
    hidden_fields: []
    y_axes: []
    listen: {}
    row: 3
    col: 8
    width: 2
    height: 3
  - name: 'Gorillas # Hubs:'
    type: text
    title_text: 'Gorillas # Hubs:'
    subtitle_text: ''
    body_text: ''
    row: 3
    col: 0
    width: 3
    height: 3
  - title: City Performance
    name: City Performance
    model: flink_v3
    explore: order_order
    type: looker_grid
    fields: [order_order.cnt_orders, order_order.cnt_unique_orders_new_customers,
      order_order.cnt_unique_customers, order_order.sum_gmv_gross, order_order.avg_order_value_gross,
      order_order.pct_discount_order_share, order_order.avg_fulfillment_time_mm_ss,
      order_order.pct_discount_value_of_gross_total, order_order.avg_delivery_fee_gross,
      order_order.pct_delivery_late_over_5_min, order_order.pct_delivery_late_over_10_min,
      order_order.pct_delivery_in_time, hubs.city, order_order.cnt_unique_hubs, shyftplan_riders_pickers_hours.rider_utr]
    filters:
      hubs.hub_name: ''
      order_order.is_internal_order: 'no'
      order_order.is_successful_order: 'yes'
      order_order.created_week: before 0 weeks ago
      order_order.warehouse_name: "-EMPTY"
    sorts: [order_order.cnt_orders desc]
    limit: 500
    column_limit: 50
    total: true
    dynamic_fields: [{table_calculation: wow, label: WoW, expression: "( ${order_order.cnt_orders}\
          \ - offset(${order_order.cnt_orders}, 7) ) / offset(${order_order.cnt_orders},\
          \ 7)", value_format: '"▲  "+0%; "▼  "-0%; 0', value_format_name: !!null '',
        _kind_hint: measure, _type_hint: number, is_disabled: true}]
    query_timezone: Europe/Berlin
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: false
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: gray
    limit_displayed_rows: false
    enable_conditional_formatting: true
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    color_application:
      collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
    show_sql_query_menu_options: false
    pinned_columns:
      "$$$_row_numbers_$$$": left
      hubs.city: left
      order_order.cnt_orders: left
      order_order.cnt_unique_hubs: left
    column_order: ["$$$_row_numbers_$$$", hubs.city, order_order.cnt_orders, order_order.cnt_unique_hubs,
      order_order.avg_order_value_gross, order_order.avg_fulfillment_time_mm_ss, order_order.pct_delivery_in_time,
      order_order.pct_delivery_late_over_5_min, order_order.pct_delivery_late_over_10_min,
      order_order.sum_gmv_gross, order_order.cnt_unique_customers, order_order.cnt_unique_orders_new_customers,
      order_order.pct_discount_order_share, order_order.pct_discount_value_of_gross_total,
      shyftplan_riders_pickers_hours.rider_utr, order_order.avg_delivery_fee_gross]
    show_totals: true
    show_row_totals: true
    series_labels:
      order_order.cnt_unique_hubs: "# Hubs"
    series_column_widths:
      order_order.created_date: 125
      order_order.cnt_unique_orders: 101
      order_order.cnt_unique_orders_new_customers: 103
      order_order.cnt_unique_orders_existing_customers: 147
      order_order.cnt_unique_customers: 93
      order_order.avg_basket_size_gross: 211
      order_order.sum_revenue_gross: 173
      order_order.avg_reaction_time: 115
      order_order.avg_picking_time: 106
      order_order.avg_fulfillment_time: 169
      order_order.avg_delivery_time: 154
      order_order.cnt_orders: 126
      order_order.pct_discount_order_share: 94
      order_order.sum_discount_amt: 124
      order_order.pct_discount_value_of_gross_total: 102
      order_order.avg_delivery_fee_gross: 103
      order_order.avg_acceptance_time: 175
      order_order.sum_gmv_gross: 99
      order_order.avg_order_value_gross: 110
      order_order.pct_delivery_late_over_5_min: 97
      order_order.pct_delivery_late_over_10_min: 96
      wow: 74
      order_order.date: 162
      order_order.avg_fulfillment_time_mm_ss: 129
      order_order.warehouse_name: 150
      order_order.pct_delivery_in_time: 102
      hubs.hub_name: 197
      hubs.city: 106
      order_order.cnt_unique_hubs: 80
      shyftplan_riders_pickers_hours.rider_utr: 77
    series_cell_visualizations:
      order_order.cnt_unique_orders:
        is_active: true
        palette:
          palette_id: 56d0c358-10a0-4fd6-aa0b-b117bef527ab
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      order_order.avg_basket_size_gross:
        is_active: true
        palette:
          palette_id: 56d0c358-10a0-4fd6-aa0b-b117bef527ab
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      order_order.avg_fulfillment_time:
        is_active: true
        palette:
          palette_id: 84802bdf-40bc-c721-2694-55c5eaeb8519
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
          custom_colors:
          - "#b1e84d"
          - "#ffffff"
          - "#ff393f"
      order_order.cnt_orders:
        is_active: true
        palette:
          palette_id: 56d0c358-10a0-4fd6-aa0b-b117bef527ab
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      order_order.avg_order_value_gross:
        is_active: true
        palette:
          palette_id: 56d0c358-10a0-4fd6-aa0b-b117bef527ab
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      order_order.pct_delivery_late_over_5_min:
        is_active: true
        palette:
          palette_id: cb3356e4-15f7-f4ff-a08f-b6fc17b5c145
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
          custom_colors:
          - "#b1e84d"
          - "#ffffff"
          - "#ff393f"
      wow:
        is_active: false
        palette:
          palette_id: fca4d068-6149-4d2a-cf71-eea5bb78182a
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
          custom_colors:
          - "#e8230a"
          - "#ffffff"
          - "#67e813"
        value_display: true
      order_order.pct_delivery_late_over_10_min:
        is_active: true
        palette:
          palette_id: e6c3ca7a-03b3-3cfd-2024-978aa98edb14
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
          custom_colors:
          - "#b1e84d"
          - "#ffffff"
          - "#ff393f"
      order_order.avg_fulfillment_time_mm_ss:
        is_active: true
        palette:
          palette_id: 9c1cb5e8-d69e-f228-a723-6fdb29dde6b0
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
          custom_colors:
          - "#b1e84d"
          - "#ffffff"
          - "#f2180f"
      order_order.pct_delivery_in_time:
        is_active: true
        palette:
          palette_id: f50c3cde-51ec-380e-bd2c-de3375adfd32
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
          custom_colors:
          - "#ffffff"
          - "#8be631"
      order_order.cnt_unique_hubs:
        is_active: true
    series_text_format:
      wow:
        italic: true
        align: center
    header_font_color: ''
    conditional_formatting: [{type: greater than, value: 0, background_color: !!null '',
        font_color: "#16bf20", color_application: {collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2,
          custom: {id: 875cd87e-c531-33ad-d63e-49281cc2ca1f, label: Custom, type: continuous,
            stops: [{color: "#e61c14", offset: 0}, {color: "#FFFFFF", offset: 50},
              {color: "#27e81e", offset: 100}]}, options: {steps: 5, mirror: false,
            constraints: {min: {type: number, value: -1}, mid: {type: number, value: 0},
              max: {type: number, value: 1}}}}, bold: true, italic: false, strikethrough: false,
        fields: []}, {type: less than, value: 0, background_color: !!null '', font_color: "#EA4335",
        color_application: {collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2, palette_id: 4a00499b-c0fe-4b15-a304-4083c07ff4c4},
        bold: true, italic: false, strikethrough: false, fields: []}]
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
      Order Date: order_order.created_date
      Country: hubs.country
      City: hubs.city
    row: 6
    col: 0
    width: 24
    height: 30
  - title: City Growth Evolution (WoW)
    name: City Growth Evolution (WoW)
    model: flink_v3
    explore: order_order
    type: looker_grid
    fields: [hubs.city, order_order.created_week, order_order.cnt_orders, order_order.sum_gmv_gross]
    pivots: [order_order.created_week]
    fill_fields: [order_order.created_week]
    filters:
      hubs.hub_name: ''
      order_order.is_internal_order: 'no'
      order_order.is_successful_order: 'yes'
      order_order.created_date: 5 weeks ago for 5 weeks
    sorts: [order_order.created_week desc, order_order.cnt_orders desc 0]
    limit: 500
    column_limit: 50
    total: true
    dynamic_fields: [{_kind_hint: measure, table_calculation: wow_orders, _type_hint: number,
        category: table_calculation, expression: "( ${order_order.cnt_orders} - pivot_offset(${order_order.cnt_orders},\
          \ 1) ) / pivot_offset(${order_order.cnt_orders}, 1)", label: "% WoW Orders",
        value_format: '"▲  "+0%; "▼  "-0%; 0', value_format_name: !!null ''}, {_kind_hint: measure,
        table_calculation: wow_gmv, _type_hint: number, category: table_calculation,
        expression: "( ${order_order.sum_gmv_gross} - pivot_offset(${order_order.sum_gmv_gross},\
          \ 1) ) / pivot_offset(${order_order.sum_gmv_gross}, 1)", label: "% WoW GMV",
        value_format: '"▲  "+0%; "▼  "-0%; 0', value_format_name: !!null ''}]
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
    enable_conditional_formatting: true
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    column_order: []
    show_totals: true
    show_row_totals: true
    series_column_widths:
      hubs.city: 101
      wow_orders: 86
      wow_gmv: 82
    conditional_formatting: [{type: greater than, value: 0, background_color: '',
        font_color: "#72D16D", color_application: {collection_id: product-custom-collection,
          palette_id: product-custom-collection-diverging-0, options: {constraints: {
              min: {type: minimum}, mid: {type: number, value: 0}, max: {type: maximum}},
            mirror: true, reverse: false, stepped: false}}, bold: true, italic: false,
        strikethrough: false, fields: !!null ''}, {type: less than, value: 0, background_color: '',
        font_color: "#e61a22", color_application: {collection_id: product-custom-collection,
          palette_id: product-custom-collection-diverging-0, options: {constraints: {
              min: {type: minimum}, mid: {type: number, value: 0}, max: {type: maximum}},
            mirror: true, reverse: false, stepped: false}}, bold: true, italic: false,
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
    legend_position: center
    series_types: {}
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    swap_axes: false
    show_null_points: true
    interpolation: linear
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    hidden_fields: [order_order.cnt_orders, order_order.sum_gmv_gross]
    listen:
      Country: hubs.country
      City: hubs.city
    row: 36
    col: 0
    width: 24
    height: 31
  filters:
  - name: Country
    title: Country
    type: field_filter
    default_value: France,Germany,Netherlands
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
    explore: order_order
    listens_to_filters: []
    field: hubs.city
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
    explore: order_order
    listens_to_filters: []
    field: order_order.created_date
