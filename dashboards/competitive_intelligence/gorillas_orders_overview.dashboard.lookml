- dashboard: gorillas_orders_dashboard
  title: Gorillas Orders Overview (v2)
  layout: newspaper
  preferred_viewer: dashboards-next
  elements:
  - name: ''
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: |+
      ### Disclaimer
      - Order Numbers are only **approximate values**
      - All **%-Growth measures** only include days where WoW data is available
      - New Hubs are added **manually** -> The Overview of Hubs Lags behind by a few days
      - We don't account for public holidays yet
      - There is no data for German hubs for Sundays, as they are automatically excluded
      - If Gorillas adds hubs that are placed in existing areas, they are not yet automatically detected. If there is a big drop in orders for a specific warehouse, it is very likely that a new hub has opened in the area
      - The data is scraped from the iOS-App from Gorillas on a **daily basis** (the dashboard is automatically updated and always shows the latest data available).




    row: 0
    col: 0
    width: 21
    height: 5
  - name: Gorillas Daily Orders & % WoW
    title: Gorillas Daily Orders & % WoW
    model: flink_v3
    explore: gorillas_orders
    type: single_value
    fields: [gorillas_orders.order_date, gorillas_orders.sum_orders, gorillas_orders.sum_orders_wow]
    fill_fields: [gorillas_orders.order_date]
    filters:
      gorillas_orders.data_for_both_days: 'Yes'
    sorts: [gorillas_orders.order_date desc]
    limit: 500
    dynamic_fields: [{_kind_hint: measure, table_calculation: wow, _type_hint: number,
        category: table_calculation, expression: "(${gorillas_orders.sum_orders}-\
          \ ${gorillas_orders.sum_orders_wow})/${gorillas_orders.sum_orders_wow}",
        label: WoW, value_format: !!null '', value_format_name: percent_0}]
    query_timezone: Europe/Berlin
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    single_value_title: Orders for selected Date
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    header_text_alignment: left
    header_font_size: 12
    rows_font_size: 12
    hidden_points_if_no: []
    defaults_version: 1
    series_types: {}
    hidden_fields: [gorillas_orders.sum_orders_wow]
    y_axes: []
    note_state: collapsed
    note_display: hover
    note_text: 'This metric shows the scraped orders for the selected timeframe and
      hubs

      '
    listen:
      Orders Date: gorillas_orders.order_date
      Country: gorillas_orders.country
      Hub City: gorillas_orders.city
      Hub Label: gorillas_orders.hub_label
    row: 5
    col: 0
    width: 4
    height: 3
  - name: Gorillas WoW Orders per Week
    title: Gorillas WoW Orders per Week
    model: flink_v3
    explore: gorillas_orders
    type: single_value
    fields: [gorillas_orders.sum_orders, gorillas_orders.sum_orders_wow, gorillas_orders.order_week]
    fill_fields: [gorillas_orders.order_week]
    filters:
      gorillas_orders.order_date: 1 weeks ago for 1 weeks
      gorillas_orders.data_for_both_days: 'Yes'
    sorts: [gorillas_orders.sum_orders_wow desc]
    limit: 500
    dynamic_fields: [{_kind_hint: measure, table_calculation: wow, _type_hint: number,
        category: table_calculation, expression: "(${gorillas_orders.sum_orders}-\
          \ ${gorillas_orders.sum_orders_wow})/${gorillas_orders.sum_orders_wow}",
        label: WoW, value_format: !!null '', value_format_name: percent_0}]
    query_timezone: Europe/Berlin
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: true
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    single_value_title: "% Change of Sum Orders last completed Week vs Previous Week"
    value_format: '"▲  "+0%; "▼  "-0%; 0'
    conditional_formatting: [{type: greater than, value: 0, background_color: '',
        font_color: "#72D16D", color_application: {collection_id: product-custom-collection,
          palette_id: product-custom-collection-sequential-0}, bold: false, italic: false,
        strikethrough: false, fields: !!null ''}, {type: equal to, value: 0, background_color: '',
        font_color: "#000000", color_application: {collection_id: product-custom-collection,
          palette_id: product-custom-collection-sequential-0}, bold: false, italic: false,
        strikethrough: false, fields: !!null ''}, {type: less than, value: 0, background_color: '',
        font_color: "#f98662", color_application: {collection_id: product-custom-collection,
          palette_id: product-custom-collection-sequential-0}, bold: false, italic: false,
        strikethrough: false, fields: !!null ''}]
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    header_text_alignment: left
    header_font_size: 12
    rows_font_size: 12
    hidden_points_if_no: []
    defaults_version: 1
    series_types: {}
    hidden_fields: [gorillas_orders.sum_orders_wow, gorillas_orders.sum_orders]
    y_axes: []
    note_state: collapsed
    note_display: hover
    note_text: |-
      This metric shows the %-change of the total orders for last full week compared to the previous week.
      Per Hub, only weekdays with order data available in both weeks are included in the calculation.
    listen:
      Country: gorillas_orders.country
      Hub City: gorillas_orders.city
      Hub Label: gorillas_orders.hub_label
    row: 5
    col: 4
    width: 4
    height: 3
  - name: Gorillas Days of Available Data
    title: Gorillas Days of Available Data
    model: flink_v3
    explore: gorillas_orders
    type: single_value
    fields: [gorillas_orders.order_data_available, count_of_order_date]
    filters:
      gorillas_orders.order_date: 2 weeks ago for 2 weeks
      gorillas_orders.order_data_available: 'Yes'
    sorts: [gorillas_orders.order_data_available desc]
    limit: 500
    dynamic_fields: [{_kind_hint: measure, table_calculation: wow, _type_hint: number,
        category: table_calculation, expression: "(${gorillas_orders.sum_orders}-\
          \ ${gorillas_orders.sum_orders_wow})/${gorillas_orders.sum_orders_wow}",
        label: WoW, value_format: !!null '', value_format_name: percent_0, is_disabled: true},
      {measure: count_of_order_date, based_on: gorillas_orders.order_date, expression: '',
        label: Count of Orders Date, type: count_distinct, _kind_hint: measure, _type_hint: number}]
    query_timezone: Europe/Berlin
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: true
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    single_value_title: "# Days with scraping data available"
    value_format: 0"/14  "
    conditional_formatting: [{type: equal to, value: 14, background_color: '', font_color: "#72D16D",
        color_application: {collection_id: product-custom-collection, palette_id: product-custom-collection-sequential-0},
        bold: false, italic: false, strikethrough: false, fields: !!null ''}, {type: equal
          to, value: 0, background_color: '', font_color: "#000000", color_application: {
          collection_id: product-custom-collection, palette_id: product-custom-collection-sequential-0},
        bold: false, italic: false, strikethrough: false, fields: !!null ''}, {type: less
          than, value: 12, background_color: '', font_color: "#f98662", color_application: {
          collection_id: product-custom-collection, palette_id: product-custom-collection-sequential-0},
        bold: false, italic: false, strikethrough: false, fields: !!null ''}]
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    header_text_alignment: left
    header_font_size: 12
    rows_font_size: 12
    hidden_points_if_no: []
    defaults_version: 1
    series_types: {}
    hidden_fields: [gorillas_orders.order_data_available]
    y_axes: []
    note_state: collapsed
    note_display: hover
    note_text: 'Shows the # of days that have scraping data available within the last
      2 full weeks.'
    listen:
      Country: gorillas_orders.country
      Hub City: gorillas_orders.city
      Hub Label: gorillas_orders.hub_label
    row: 5
    col: 8
    width: 3
    height: 3
  - name: Gorillas Orders Scraped Hubs
    title: Gorillas Orders Scraped Hubs
    model: flink_v3
    explore: gorillas_orders
    type: single_value
    fields: [count_of_hub_label]
    filters:
      gorillas_orders.order_data_available: 'Yes'
    limit: 500
    dynamic_fields: [{_kind_hint: measure, table_calculation: wow, _type_hint: number,
        category: table_calculation, expression: "(${gorillas_orders.sum_orders}-\
          \ ${gorillas_orders.sum_orders_wow})/${gorillas_orders.sum_orders_wow}",
        label: WoW, value_format: !!null '', value_format_name: percent_0, is_disabled: true},
      {measure: count_of_order_date, based_on: gorillas_orders.order_date, expression: '',
        label: Count of Orders Date, type: count_distinct, _kind_hint: measure, _type_hint: number},
      {measure: count_of_hub_label, based_on: gorillas_orders.hub_label, expression: '',
        label: Count of Hub Label, type: count_distinct, _kind_hint: measure, _type_hint: number}]
    query_timezone: Europe/Berlin
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: true
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    single_value_title: Scraped Hubs
    value_format: ''
    conditional_formatting: [{type: equal to, value: 14, background_color: '', font_color: "#72D16D",
        color_application: {collection_id: product-custom-collection, palette_id: product-custom-collection-sequential-0},
        bold: false, italic: false, strikethrough: false, fields: !!null ''}, {type: equal
          to, value: 0, background_color: '', font_color: "#000000", color_application: {
          collection_id: product-custom-collection, palette_id: product-custom-collection-sequential-0},
        bold: false, italic: false, strikethrough: false, fields: !!null ''}, {type: less
          than, value: 12, background_color: '', font_color: "#f98662", color_application: {
          collection_id: product-custom-collection, palette_id: product-custom-collection-sequential-0},
        bold: false, italic: false, strikethrough: false, fields: !!null ''}]
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    header_text_alignment: left
    header_font_size: 12
    rows_font_size: 12
    hidden_points_if_no: []
    defaults_version: 1
    series_types: {}
    hidden_fields: []
    y_axes: []
    note_state: collapsed
    note_display: hover
    note_text: Shows the number of hubs that are scraped based on the selected filters
    listen:
      Orders Date: gorillas_orders.order_date
      Country: gorillas_orders.country
      Hub City: gorillas_orders.city
      Hub Label: gorillas_orders.hub_label
    row: 5
    col: 11
    width: 2
    height: 3
  - name: Orders per Hub (in selected timeframe)
    title: Orders per Hub (in selected timeframe)
    model: flink_v3
    explore: gorillas_orders
    type: looker_grid
    fields: [gorillas_orders.hub_label, gorillas_orders.sum_orders]
    filters: {}
    sorts: [gorillas_orders.sum_orders desc]
    limit: 500
    dynamic_fields: [{_kind_hint: measure, table_calculation: wow, _type_hint: number,
        category: table_calculation, expression: "(${gorillas_orders.sum_orders}-\
          \ ${gorillas_orders.sum_orders_wow})/${gorillas_orders.sum_orders_wow}",
        label: WoW, value_format: !!null '', value_format_name: percent_0, is_disabled: true},
      {measure: count_of_order_date, based_on: gorillas_orders.order_date, expression: '',
        label: Count of Orders Date, type: count_distinct, _kind_hint: measure, _type_hint: number},
      {measure: count_of_hub_label, based_on: gorillas_orders.hub_label, expression: '',
        label: Count of Hub Label, type: count_distinct, _kind_hint: measure, _type_hint: number}]
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
    enable_conditional_formatting: true
    header_text_alignment: left
    header_font_size: 12
    rows_font_size: 12
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    single_value_title: Scraped Hubs
    value_format: ''
    conditional_formatting: [{type: equal to, value: 14, background_color: '', font_color: "#72D16D",
        color_application: {collection_id: product-custom-collection, palette_id: product-custom-collection-sequential-0},
        bold: false, italic: false, strikethrough: false, fields: !!null ''}, {type: equal
          to, value: 0, background_color: '', font_color: "#000000", color_application: {
          collection_id: product-custom-collection, palette_id: product-custom-collection-sequential-0},
        bold: false, italic: false, strikethrough: false, fields: !!null ''}, {type: less
          than, value: 12, background_color: '', font_color: "#f98662", color_application: {
          collection_id: product-custom-collection, palette_id: product-custom-collection-sequential-0},
        bold: false, italic: false, strikethrough: false, fields: !!null ''}]
    hidden_points_if_no: []
    defaults_version: 1
    series_types: {}
    hidden_fields: []
    y_axes: []
    note_state: collapsed
    note_display: hover
    note_text: 'This table shows the # of Orders per Hub for the selected timeframe.'
    listen:
      Orders Date: gorillas_orders.order_date
      Country: gorillas_orders.country
      Hub City: gorillas_orders.city
      Hub Label: gorillas_orders.hub_label
    row: 8
    col: 0
    width: 13
    height: 8
  - name: Gorillas Orders Hubs
    title: Gorillas Orders Hubs
    model: flink_v3
    explore: gorillas_orders
    type: looker_map
    fields: [gorillas_orders.hub_label, gorillas_orders.hub_location]
    filters: {}
    sorts: [gorillas_orders.hub_label]
    limit: 500
    dynamic_fields: [{_kind_hint: measure, table_calculation: wow, _type_hint: number,
        category: table_calculation, expression: "(${gorillas_orders.sum_orders}-\
          \ ${gorillas_orders.sum_orders_wow})/${gorillas_orders.sum_orders_wow}",
        label: WoW, value_format: !!null '', value_format_name: percent_0, is_disabled: true},
      {measure: count_of_order_date, based_on: gorillas_orders.order_date, expression: '',
        label: Count of Orders Date, type: count_distinct, _kind_hint: measure, _type_hint: number},
      {measure: count_of_hub_label, based_on: gorillas_orders.hub_label, expression: '',
        label: Count of Hub Label, type: count_distinct, _kind_hint: measure, _type_hint: number}]
    query_timezone: Europe/Berlin
    map_plot_mode: points
    heatmap_gridlines: false
    heatmap_gridlines_empty: false
    heatmap_opacity: 0.5
    show_region_field: true
    draw_map_labels_above_data: true
    map_tile_provider: light
    map_position: fit_data
    map_scale_indicator: 'off'
    map_pannable: false
    map_zoomable: false
    map_marker_type: icon
    map_marker_icon_name: default
    map_marker_radius_mode: proportional_value
    map_marker_units: meters
    map_marker_proportional_scale_type: linear
    map_marker_color_mode: fixed
    show_view_names: false
    show_legend: true
    quantize_map_value_colors: false
    reverse_map_value_colors: false
    map_marker_color: ['000000']
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: true
    header_text_alignment: left
    header_font_size: 12
    rows_font_size: 12
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    single_value_title: Scraped Hubs
    value_format: ''
    conditional_formatting: [{type: equal to, value: 14, background_color: '', font_color: "#72D16D",
        color_application: {collection_id: product-custom-collection, palette_id: product-custom-collection-sequential-0},
        bold: false, italic: false, strikethrough: false, fields: !!null ''}, {type: equal
          to, value: 0, background_color: '', font_color: "#000000", color_application: {
          collection_id: product-custom-collection, palette_id: product-custom-collection-sequential-0},
        bold: false, italic: false, strikethrough: false, fields: !!null ''}, {type: less
          than, value: 12, background_color: '', font_color: "#f98662", color_application: {
          collection_id: product-custom-collection, palette_id: product-custom-collection-sequential-0},
        bold: false, italic: false, strikethrough: false, fields: !!null ''}]
    hidden_points_if_no: []
    defaults_version: 1
    series_types: {}
    hidden_fields: []
    y_axes: []
    note_state: collapsed
    note_display: hover
    note_text: Hub Locations of the Scraped Gorillas Hubs
    listen:
      Orders Date: gorillas_orders.order_date
      Country: gorillas_orders.country
      Hub City: gorillas_orders.city
      Hub Label: gorillas_orders.hub_label
    row: 5
    col: 13
    width: 8
    height: 11
  - title: Weekly Orders per Hub
    name: Weekly Orders per Hub
    model: flink_v3
    explore: gorillas_orders
    type: looker_grid
    fields: [gorillas_orders.hub_label, gorillas_orders.sum_orders, gorillas_orders.sum_orders_wow]
    filters:
      gorillas_orders.order_date: 1 weeks ago for 1 weeks
      gorillas_orders.data_for_both_days: 'Yes'
    sorts: [gorillas_orders.sum_orders desc]
    limit: 500
    dynamic_fields: [{_kind_hint: measure, table_calculation: wow, _type_hint: number,
        category: table_calculation, expression: "(${gorillas_orders.sum_orders}-\
          \ ${gorillas_orders.sum_orders_wow})/${gorillas_orders.sum_orders_wow}",
        label: WoW, value_format: '"▲  "+0%; "▼  "-0%; 0', value_format_name: !!null ''},
      {measure: count_of_order_date, based_on: gorillas_orders.order_date, expression: '',
        label: Count of Orders Date, type: count_distinct, _kind_hint: measure, _type_hint: number},
      {measure: count_of_hub_label, based_on: gorillas_orders.hub_label, expression: '',
        label: Count of Hub Label, type: count_distinct, _kind_hint: measure, _type_hint: number}]
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
    enable_conditional_formatting: true
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    column_order: ["$$$_row_numbers_$$$", gorillas_orders.hub_label, gorillas_orders.sum_orders,
      gorillas_orders.sum_orders_wow, wow]
    show_totals: true
    show_row_totals: true
    series_labels:
      gorillas_orders.sum_orders: "# Orders last CW"
      gorillas_orders.sum_orders_wow: "# Orders 2 CW ago"
    series_column_widths:
      gorillas_orders.sum_orders_wow: 121
    series_cell_visualizations:
      gorillas_orders.sum_orders:
        is_active: true
    conditional_formatting: [{type: greater than, value: 0, background_color: '',
        font_color: "#72D16D", color_application: {collection_id: product-custom-collection,
          palette_id: product-custom-collection-sequential-0}, bold: false, italic: false,
        strikethrough: false, fields: [wow]}, {type: less than, value: 12, background_color: '',
        font_color: "#f98662", color_application: {collection_id: product-custom-collection,
          palette_id: product-custom-collection-sequential-0}, bold: false, italic: false,
        strikethrough: false, fields: [wow]}]
    map_plot_mode: points
    heatmap_gridlines: false
    heatmap_gridlines_empty: false
    heatmap_opacity: 0.5
    show_region_field: true
    draw_map_labels_above_data: true
    map_tile_provider: light
    map_position: fit_data
    map_scale_indicator: 'off'
    map_pannable: false
    map_zoomable: false
    map_marker_type: icon
    map_marker_icon_name: default
    map_marker_radius_mode: proportional_value
    map_marker_units: meters
    map_marker_proportional_scale_type: linear
    map_marker_color_mode: fixed
    show_legend: true
    quantize_map_value_colors: false
    reverse_map_value_colors: false
    map_marker_color: ['000000']
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    single_value_title: Scraped Hubs
    value_format: ''
    hidden_points_if_no: []
    defaults_version: 1
    series_types: {}
    hidden_fields: []
    y_axes: []
    note_state: collapsed
    note_display: hover
    note_text: This table shows the total weekly orders of the last full week, per
      Hub. It is compared to the previous full week.
    listen:
      Country: gorillas_orders.country
      Hub City: gorillas_orders.city
      Hub Label: gorillas_orders.hub_label
    row: 22
    col: 0
    width: 11
    height: 7
  - name: Total Weekly Orders for Selected Hubs
    title: Total Weekly Orders for Selected Hubs
    model: flink_v3
    explore: gorillas_orders
    type: looker_grid
    fields: [gorillas_orders.order_week, gorillas_orders.sum_orders, gorillas_orders.sum_orders_wow]
    fill_fields: [gorillas_orders.order_week]
    filters:
      gorillas_orders.order_date: 12 weeks ago for 12 weeks
      gorillas_orders.data_for_both_days: 'Yes'
    sorts: [gorillas_orders.sum_orders_wow desc]
    limit: 500
    dynamic_fields: [{_kind_hint: measure, table_calculation: wow, _type_hint: number,
        category: table_calculation, expression: "(${gorillas_orders.sum_orders}-\
          \ ${gorillas_orders.sum_orders_wow})/${gorillas_orders.sum_orders_wow}",
        label: WoW, value_format: '"▲  "+0%; "▼  "-0%; 0', value_format_name: !!null ''},
      {measure: count_of_order_date, based_on: gorillas_orders.order_date, expression: '',
        label: Count of Orders Date, type: count_distinct, _kind_hint: measure, _type_hint: number},
      {measure: count_of_hub_label, based_on: gorillas_orders.hub_label, expression: '',
        label: Count of Hub Label, type: count_distinct, _kind_hint: measure, _type_hint: number}]
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
    enable_conditional_formatting: true
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    column_order: ["$$$_row_numbers_$$$", gorillas_orders.order_week, gorillas_orders.sum_orders,
      gorillas_orders.sum_orders_wow, wow]
    show_totals: true
    show_row_totals: true
    series_column_widths:
      gorillas_orders.sum_orders_wow: 197
      gorillas_orders.order_week: 150
    series_cell_visualizations:
      gorillas_orders.sum_orders:
        is_active: true
    conditional_formatting: [{type: greater than, value: 0, background_color: '',
        font_color: "#72D16D", color_application: {collection_id: product-custom-collection,
          palette_id: product-custom-collection-sequential-0}, bold: false, italic: false,
        strikethrough: false, fields: [wow]}, {type: less than, value: 12, background_color: '',
        font_color: "#f98662", color_application: {collection_id: product-custom-collection,
          palette_id: product-custom-collection-sequential-0}, bold: false, italic: false,
        strikethrough: false, fields: [wow]}]
    map_plot_mode: points
    heatmap_gridlines: false
    heatmap_gridlines_empty: false
    heatmap_opacity: 0.5
    show_region_field: true
    draw_map_labels_above_data: true
    map_tile_provider: light
    map_position: fit_data
    map_scale_indicator: 'off'
    map_pannable: false
    map_zoomable: false
    map_marker_type: icon
    map_marker_icon_name: default
    map_marker_radius_mode: proportional_value
    map_marker_units: meters
    map_marker_proportional_scale_type: linear
    map_marker_color_mode: fixed
    show_legend: true
    quantize_map_value_colors: false
    reverse_map_value_colors: false
    map_marker_color: ['000000']
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    single_value_title: Scraped Hubs
    value_format: ''
    hidden_points_if_no: []
    defaults_version: 1
    series_types: {}
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
    show_null_points: true
    interpolation: linear
    y_axes: []
    note_state: collapsed
    note_display: hover
    note_text: This table shows the aggregated weekly orders across all hubs, compared
      to the previous week
    listen:
      Country: gorillas_orders.country
      Hub City: gorillas_orders.city
      Hub Label: gorillas_orders.hub_label
    row: 16
    col: 11
    width: 10
    height: 9
  - name: Total Daily Orders per Hub
    title: Total Daily Orders per Hub
    model: flink_v3
    explore: gorillas_orders
    type: looker_grid
    fields: [gorillas_orders.hub_label, gorillas_orders.sum_orders, gorillas_orders.sum_orders_wow]
    filters: {}
    sorts: [gorillas_orders.sum_orders desc]
    limit: 500
    dynamic_fields: [{_kind_hint: measure, table_calculation: wow, _type_hint: number,
        category: table_calculation, expression: "(${gorillas_orders.sum_orders}-\
          \ ${gorillas_orders.sum_orders_wow})/${gorillas_orders.sum_orders_wow}",
        label: WoW, value_format: '"▲  "+0%; "▼  "-0%; 0', value_format_name: !!null ''},
      {measure: count_of_order_date, based_on: gorillas_orders.order_date, expression: '',
        label: Count of Orders Date, type: count_distinct, _kind_hint: measure, _type_hint: number},
      {measure: count_of_hub_label, based_on: gorillas_orders.hub_label, expression: '',
        label: Count of Hub Label, type: count_distinct, _kind_hint: measure, _type_hint: number}]
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
    enable_conditional_formatting: true
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    column_order: ["$$$_row_numbers_$$$", gorillas_orders.hub_label, gorillas_orders.sum_orders,
      gorillas_orders.sum_orders_wow, wow]
    show_totals: true
    show_row_totals: true
    series_column_widths:
      gorillas_orders.sum_orders_wow: 121
    series_cell_visualizations:
      gorillas_orders.sum_orders:
        is_active: true
    conditional_formatting: [{type: greater than, value: 0, background_color: '',
        font_color: "#72D16D", color_application: {collection_id: product-custom-collection,
          palette_id: product-custom-collection-sequential-0}, bold: false, italic: false,
        strikethrough: false, fields: [wow]}, {type: less than, value: 12, background_color: '',
        font_color: "#f98662", color_application: {collection_id: product-custom-collection,
          palette_id: product-custom-collection-sequential-0}, bold: false, italic: false,
        strikethrough: false, fields: [wow]}]
    map_plot_mode: points
    heatmap_gridlines: false
    heatmap_gridlines_empty: false
    heatmap_opacity: 0.5
    show_region_field: true
    draw_map_labels_above_data: true
    map_tile_provider: light
    map_position: fit_data
    map_scale_indicator: 'off'
    map_pannable: false
    map_zoomable: false
    map_marker_type: icon
    map_marker_icon_name: default
    map_marker_radius_mode: proportional_value
    map_marker_units: meters
    map_marker_proportional_scale_type: linear
    map_marker_color_mode: fixed
    show_legend: true
    quantize_map_value_colors: false
    reverse_map_value_colors: false
    map_marker_color: ['000000']
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    single_value_title: Scraped Hubs
    value_format: ''
    hidden_points_if_no: []
    defaults_version: 1
    series_types: {}
    hidden_fields: []
    y_axes: []
    listen:
      Orders Date: gorillas_orders.order_date
      Hub Label: gorillas_orders.hub_label
    row: 16
    col: 0
    width: 11
    height: 6
  filters:
  - name: Orders Date
    title: Orders Date
    type: field_filter
    default_value: yesterday
    allow_multiple_values: true
    required: true
    ui_config:
      type: relative_timeframes
      display: inline
      options: []
    model: flink_v3
    explore: gorillas_orders
    listens_to_filters: []
    field: gorillas_orders.order_date
  - name: Country
    title: Country
    type: field_filter
    default_value: France,Germany,Netherlands
    allow_multiple_values: true
    required: false
    ui_config:
      type: button_group
      display: inline
      options:
      - France
      - Germany
      - Netherlands
    model: flink_v3
    explore: gorillas_orders
    listens_to_filters: []
    field: gorillas_orders.country
  - name: Hub City
    title: Hub City
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: popover
      options: []
    model: flink_v3
    explore: gorillas_orders
    listens_to_filters: [Country]
    field: gorillas_orders.city
  - name: Hub Label
    title: Hub Label
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: popover
      options: []
    model: flink_v3
    explore: gorillas_orders
    listens_to_filters: [Country, Hub City]
    field: gorillas_orders.hub_label
