- dashboard: b2bbrand_data_packages
  title: B2B-Brand Data Packages
  layout: newspaper
  preferred_viewer: dashboards-next
  elements:
  - title: Product Performance per SKU
    name: Product Performance per SKU
    model: brand_data_packages_v1
    explore: brand_data_packages_v1
    type: looker_grid
    fields: [products.category, products.subcategory, products.product_brand, products.product_name,
      orders.date, order_lineitems.sum_item_quantity_fulfilled, orders.cnt_orders,
      orders.sales_per_order, orders.cnt_unique_customers, orders.order_frequency]
    filters: {}
    sorts: [products.category, products.subcategory, products.product_brand, products.product_name,
      orders.date, order_lineitems.sum_item_quantity_fulfilled desc]
    limit: 500
    query_timezone: Europe/Berlin
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: false
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
      order_lineitems.sum_item_quantity_fulfilled:
        is_active: true
      orders.cnt_orders:
        is_active: true
        palette:
          palette_id: product-custom-collection-sequential-0
          collection_id: product-custom-collection
      orders.cnt_unique_customers:
        is_active: true
      orders.order_frequency:
        is_active: true
      orders.sales_per_order:
        is_active: true
    map_plot_mode: points
    heatmap_gridlines: false
    heatmap_gridlines_empty: false
    heatmap_opacity: 0.5
    show_region_field: true
    draw_map_labels_above_data: true
    map_tile_provider: light
    map_position: fit_data
    map_scale_indicator: 'off'
    map_pannable: true
    map_zoomable: true
    map_marker_type: circle
    map_marker_icon_name: default
    map_marker_radius_mode: proportional_value
    map_marker_units: meters
    map_marker_proportional_scale_type: linear
    map_marker_color_mode: fixed
    show_legend: true
    quantize_map_value_colors: false
    reverse_map_value_colors: false
    defaults_version: 1
    series_types: {}
    series_column_widths:
      orders.sales_per_order: 119
    note_state: collapsed
    note_display: above
    listen:
      City: hubs.city
      Parent Category: products.category
      Sub-Category: products.subcategory
      SKU + Name: products.product_sku_name
      Date Granularity: orders.date_granularity
      Order Date: orders.created_date
      "> Select Metric": orders.KPI_parameter
      Brand: products.product_brand
      Country: hubs.country
    row: 21
    col: 0
    width: 24
    height: 14
  - title: New Tile
    name: New Tile
    model: brand_data_packages_v1
    explore: brand_data_packages_v1
    type: single_value
    fields: [order_lineitems.sum_item_quantity_fulfilled]
    limit: 500
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: true
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    single_value_title: "# Sales"
    value_format: "#,###"
    conditional_formatting: [{type: not null, value: !!null '', background_color: '',
        font_color: "#e5508e", color_application: {collection_id: product-custom-collection,
          palette_id: product-custom-collection-sequential-0}, bold: false, italic: false,
        strikethrough: false, fields: !!null ''}]
    series_types: {}
    defaults_version: 1
    listen:
      City: hubs.city
      Parent Category: products.category
      Sub-Category: products.subcategory
      SKU + Name: products.product_sku_name
      Date Granularity: orders.date_granularity
      Order Date: orders.created_date
      "> Select Metric": orders.KPI_parameter
      Brand: products.product_brand
      Country: hubs.country
    row: 5
    col: 0
    width: 4
    height: 2
  - title: New Tile
    name: New Tile (2)
    model: brand_data_packages_v1
    explore: brand_data_packages_v1
    type: single_value
    fields: [orders.cnt_orders]
    limit: 500
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: true
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    single_value_title: "# Orders"
    value_format: "#,###"
    conditional_formatting: [{type: not null, value: !!null '', background_color: '',
        font_color: "#e5508e", color_application: {collection_id: product-custom-collection,
          palette_id: product-custom-collection-sequential-0}, bold: false, italic: false,
        strikethrough: false, fields: !!null ''}]
    series_types: {}
    defaults_version: 1
    listen:
      City: hubs.city
      Parent Category: products.category
      Sub-Category: products.subcategory
      SKU + Name: products.product_sku_name
      Date Granularity: orders.date_granularity
      Order Date: orders.created_date
      "> Select Metric": orders.KPI_parameter
      Brand: products.product_brand
      Country: hubs.country
    row: 5
    col: 4
    width: 4
    height: 2
  - title: New Tile
    name: New Tile (3)
    model: brand_data_packages_v1
    explore: brand_data_packages_v1
    type: single_value
    fields: [orders.sales_per_order]
    limit: 500
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: true
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    single_value_title: "# Items per Order"
    value_format: "#0.##"
    conditional_formatting: [{type: not null, value: !!null '', background_color: '',
        font_color: "#e5508e", color_application: {collection_id: product-custom-collection,
          palette_id: product-custom-collection-sequential-0}, bold: false, italic: false,
        strikethrough: false, fields: !!null ''}]
    series_types: {}
    defaults_version: 1
    listen:
      City: hubs.city
      Parent Category: products.category
      Sub-Category: products.subcategory
      SKU + Name: products.product_sku_name
      Date Granularity: orders.date_granularity
      Order Date: orders.created_date
      "> Select Metric": orders.KPI_parameter
      Brand: products.product_brand
      Country: hubs.country
    row: 5
    col: 8
    width: 4
    height: 2
  - title: New Tile
    name: New Tile (4)
    model: brand_data_packages_v1
    explore: brand_data_packages_v1
    type: single_value
    fields: [orders.cnt_unique_customers]
    limit: 500
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: true
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    single_value_title: "# Unique Customers"
    value_format: "#,##0"
    conditional_formatting: [{type: not null, value: !!null '', background_color: '',
        font_color: "#e5508e", color_application: {collection_id: product-custom-collection,
          palette_id: product-custom-collection-sequential-0}, bold: false, italic: false,
        strikethrough: false, fields: !!null ''}]
    series_types: {}
    defaults_version: 1
    listen:
      City: hubs.city
      Parent Category: products.category
      Sub-Category: products.subcategory
      SKU + Name: products.product_sku_name
      Date Granularity: orders.date_granularity
      Order Date: orders.created_date
      "> Select Metric": orders.KPI_parameter
      Brand: products.product_brand
      Country: hubs.country
    row: 5
    col: 12
    width: 4
    height: 2
  - title: New Tile
    name: New Tile (5)
    model: brand_data_packages_v1
    explore: brand_data_packages_v1
    type: single_value
    fields: [orders.order_frequency]
    limit: 500
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: true
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    single_value_title: Order Frequency
    value_format: "#0.##"
    conditional_formatting: [{type: not null, value: !!null '', background_color: '',
        font_color: "#e5508e", color_application: {collection_id: product-custom-collection,
          palette_id: product-custom-collection-sequential-0}, bold: false, italic: false,
        strikethrough: false, fields: !!null ''}]
    series_types: {}
    defaults_version: 1
    listen:
      City: hubs.city
      Parent Category: products.category
      Sub-Category: products.subcategory
      SKU + Name: products.product_sku_name
      Date Granularity: orders.date_granularity
      Order Date: orders.created_date
      "> Select Metric": orders.KPI_parameter
      Brand: products.product_brand
      Country: hubs.country
    row: 5
    col: 20
    width: 4
    height: 2
  - title: New Tile
    name: New Tile (6)
    model: brand_data_packages_v1
    explore: brand_data_packages_v1
    type: single_value
    fields: [orders.cnt_unique_orders_new_customers]
    limit: 500
    column_limit: 50
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: true
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    single_value_title: "# New Customers"
    value_format: "#,##0"
    conditional_formatting: [{type: not null, value: !!null '', background_color: '',
        font_color: "#e5508e", color_application: {collection_id: product-custom-collection,
          palette_id: product-custom-collection-sequential-0}, bold: false, italic: false,
        strikethrough: false, fields: !!null ''}]
    series_types: {}
    defaults_version: 1
    listen:
      City: hubs.city
      Parent Category: products.category
      Sub-Category: products.subcategory
      SKU + Name: products.product_sku_name
      Date Granularity: orders.date_granularity
      Order Date: orders.created_date
      "> Select Metric": orders.KPI_parameter
      Brand: products.product_brand
      Country: hubs.country
    row: 5
    col: 16
    width: 4
    height: 2
  - title: Evolution over Time
    name: Evolution over Time
    model: brand_data_packages_v1
    explore: brand_data_packages_v1
    type: looker_column
    fields: [orders.KPI, orders.date, percent_change_from_previous_orders_selected_metric]
    filters:
      orders.KPI: ">1"
    sorts: [orders.date desc]
    limit: 500
    column_limit: 50
    dynamic_fields: [{args: [orders.KPI], calculation_type: percent_of_previous, category: table_calculation,
        based_on: orders.KPI, label: Percent of previous - * Orders * > Selected Metric,
        source_field: orders.KPI, table_calculation: percent_of_previous_orders_selected_metric,
        value_format: !!null '', value_format_name: percent_0, _kind_hint: measure,
        _type_hint: number, is_disabled: true}, {args: [percent_of_previous_orders_selected_metric],
        calculation_type: percent_difference_from_previous, category: table_calculation,
        based_on: percent_of_previous_orders_selected_metric, label: Percent change
          from previous -  Percent of previous - * Orders * > Selected Metric, source_field: percent_of_previous_orders_selected_metric,
        table_calculation: percent_change_from_previous_percent_of_previous_orders_selected_metric,
        value_format: !!null '', value_format_name: percent_0, _kind_hint: measure,
        _type_hint: number, is_disabled: true}, {args: [orders.KPI], calculation_type: percent_difference_from_previous,
        category: table_calculation, based_on: orders.KPI, label: Percent change from
          previous - * Orders * > Selected Metric, source_field: orders.KPI, table_calculation: percent_change_from_previous_orders_selected_metric,
        value_format: !!null '', value_format_name: percent_0, _kind_hint: measure,
        _type_hint: number}]
    x_axis_gridlines: false
    y_axis_gridlines: false
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: true
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: circle
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    y_axes: [{label: '', orientation: left, series: [{axisId: orders.KPI, id: orders.KPI,
            name: "# Orders"}], showLabels: true, showValues: true, unpinAxis: false,
        tickDensity: default, tickDensityCustom: 20, type: linear}, {label: '', orientation: right,
        series: [{axisId: percent_change_from_previous_orders_selected_metric, id: percent_change_from_previous_orders_selected_metric,
            name: "% Change"}], showLabels: true, showValues: true, unpinAxis: true,
        tickDensity: default, type: linear}]
    hide_legend: true
    series_types:
      percent_of_previous_orders_selected_metric: line
      percent_change_from_previous_orders_selected_metric: line
    series_colors:
      percent_change_from_previous_orders_selected_metric: "#7a9fd1"
      orders.KPI: "#e5508e"
    series_labels:
      percent_change_from_previous_orders_selected_metric: "% Change"
    show_dropoff: false
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: true
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    single_value_title: "# New Customer"
    value_format: "#,##0"
    conditional_formatting: [{type: not null, value: !!null '', background_color: '',
        font_color: "#4276BE", color_application: {collection_id: product-custom-collection,
          palette_id: product-custom-collection-sequential-0}, bold: false, italic: false,
        strikethrough: false, fields: !!null ''}]
    defaults_version: 1
    show_null_points: true
    interpolation: linear
    note_state: collapsed
    note_display: above
    note_text: For selected brand and timeframe
    listen:
      City: hubs.city
      Parent Category: products.category
      Sub-Category: products.subcategory
      SKU + Name: products.product_sku_name
      Date Granularity: orders.date_granularity
      Order Date: orders.created_date
      "> Select Metric": orders.KPI_parameter
      Brand: products.product_brand
      Country: hubs.country
    row: 7
    col: 0
    width: 12
    height: 6
  - title: per Brand
    name: per Brand
    model: brand_data_packages_v1
    explore: brand_data_packages_v1
    type: looker_line
    fields: [orders.KPI, orders.date, products.product_brand]
    pivots: [products.product_brand]
    sorts: [orders.date desc, products.product_brand]
    limit: 500
    column_limit: 50
    dynamic_fields: [{args: [orders.KPI], calculation_type: percent_of_previous, category: table_calculation,
        based_on: orders.KPI, label: Percent of previous - * Orders * > Selected Metric,
        source_field: orders.KPI, table_calculation: percent_of_previous_orders_selected_metric,
        value_format: !!null '', value_format_name: percent_0, _kind_hint: measure,
        _type_hint: number, is_disabled: true}, {args: [percent_of_previous_orders_selected_metric],
        calculation_type: percent_difference_from_previous, category: table_calculation,
        based_on: percent_of_previous_orders_selected_metric, label: Percent change
          from previous -  Percent of previous - * Orders * > Selected Metric, source_field: percent_of_previous_orders_selected_metric,
        table_calculation: percent_change_from_previous_percent_of_previous_orders_selected_metric,
        value_format: !!null '', value_format_name: percent_0, _kind_hint: measure,
        _type_hint: number, is_disabled: true}, {args: [orders.KPI], calculation_type: percent_difference_from_previous,
        category: table_calculation, based_on: orders.KPI, label: Percent change from
          previous - * Orders * > Selected Metric, source_field: orders.KPI, table_calculation: percent_change_from_previous_orders_selected_metric,
        value_format: !!null '', value_format_name: percent_0, _kind_hint: measure,
        _type_hint: number, is_disabled: true}, {args: [orders.KPI], calculation_type: percent_difference_from_previous,
        category: table_calculation, based_on: orders.KPI, label: Percent change from
          previous - * Orders * > Selected Metric, source_field: orders.KPI, table_calculation: percent_change_from_previous_orders_selected_metric_2,
        value_format: !!null '', value_format_name: percent_0, _kind_hint: measure,
        _type_hint: number, is_disabled: true}]
    x_axis_gridlines: false
    y_axis_gridlines: false
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: true
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: normal
    limit_displayed_rows: false
    legend_position: center
    point_style: circle
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    color_application:
      collection_id: legacy
      palette_id: looker_classic
      options:
        steps: 5
    y_axes: [{label: '', orientation: left, series: [{axisId: orders.KPI, id: Augustiner
              - orders.KPI, name: 'Augustiner - # Sales'}, {axisId: orders.KPI, id: Club
              Mate - orders.KPI, name: 'Club Mate - # Sales'}], showLabels: true,
        showValues: true, unpinAxis: false, tickDensity: default, type: linear}, {
        label: '', orientation: right, series: [{axisId: percent_change_from_previous_orders_selected_metric,
            id: Augustiner - percent_change_from_previous_orders_selected_metric,
            name: Augustiner - Percent change from previous - * Orders * > Selected
              Metric}, {axisId: percent_change_from_previous_orders_selected_metric,
            id: Club Mate - percent_change_from_previous_orders_selected_metric, name: Club
              Mate - Percent change from previous - * Orders * > Selected Metric}],
        showLabels: true, showValues: true, unpinAxis: false, tickDensity: default,
        type: linear}]
    hide_legend: false
    font_size: 10px
    series_types: {}
    series_colors: {}
    series_labels:
      percent_change_from_previous_orders_selected_metric: "% Change"
    label_color: []
    ordering: none
    show_null_labels: false
    show_dropoff: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: true
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    single_value_title: "# New Customer"
    value_format: "#,##0"
    conditional_formatting: [{type: not null, value: !!null '', background_color: '',
        font_color: "#4276BE", color_application: {collection_id: product-custom-collection,
          palette_id: product-custom-collection-sequential-0}, bold: false, italic: false,
        strikethrough: false, fields: !!null ''}]
    defaults_version: 1
    listen:
      City: hubs.city
      Parent Category: products.category
      Sub-Category: products.subcategory
      SKU + Name: products.product_sku_name
      Date Granularity: orders.date_granularity
      Order Date: orders.created_date
      "> Select Metric": orders.KPI_parameter
      Brand: products.product_brand
      Country: hubs.country
    row: 15
    col: 16
    width: 8
    height: 6
  - title: per Sub-Category
    name: per Sub-Category
    model: brand_data_packages_v1
    explore: brand_data_packages_v1
    type: looker_line
    fields: [orders.KPI, orders.date, products.subcategory]
    pivots: [products.subcategory]
    sorts: [orders.date desc, products.subcategory]
    limit: 500
    column_limit: 50
    dynamic_fields: [{args: [orders.KPI], calculation_type: percent_of_previous, category: table_calculation,
        based_on: orders.KPI, label: Percent of previous - * Orders * > Selected Metric,
        source_field: orders.KPI, table_calculation: percent_of_previous_orders_selected_metric,
        value_format: !!null '', value_format_name: percent_0, _kind_hint: measure,
        _type_hint: number, is_disabled: true}, {args: [percent_of_previous_orders_selected_metric],
        calculation_type: percent_difference_from_previous, category: table_calculation,
        based_on: percent_of_previous_orders_selected_metric, label: Percent change
          from previous -  Percent of previous - * Orders * > Selected Metric, source_field: percent_of_previous_orders_selected_metric,
        table_calculation: percent_change_from_previous_percent_of_previous_orders_selected_metric,
        value_format: !!null '', value_format_name: percent_0, _kind_hint: measure,
        _type_hint: number, is_disabled: true}, {args: [orders.KPI], calculation_type: percent_difference_from_previous,
        category: table_calculation, based_on: orders.KPI, label: Percent change from
          previous - * Orders * > Selected Metric, source_field: orders.KPI, table_calculation: percent_change_from_previous_orders_selected_metric,
        value_format: !!null '', value_format_name: percent_0, _kind_hint: measure,
        _type_hint: number, is_disabled: true}, {args: [orders.KPI], calculation_type: percent_difference_from_previous,
        category: table_calculation, based_on: orders.KPI, label: Percent change from
          previous - * Orders * > Selected Metric, source_field: orders.KPI, table_calculation: percent_change_from_previous_orders_selected_metric_2,
        value_format: !!null '', value_format_name: percent_0, _kind_hint: measure,
        _type_hint: number, is_disabled: true}]
    x_axis_gridlines: false
    y_axis_gridlines: false
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: true
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: normal
    limit_displayed_rows: false
    legend_position: center
    point_style: circle
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    color_application:
      collection_id: d754397b-2c05-4470-bbbb-05eb4c2b15cd
      palette_id: a0f97728-49ea-4123-b57e-ec4c57803f8b
      options:
        steps: 5
    y_axes: [{label: '', orientation: left, series: [{axisId: orders.KPI, id: Augustiner
              - orders.KPI, name: 'Augustiner - # Sales'}, {axisId: orders.KPI, id: Club
              Mate - orders.KPI, name: 'Club Mate - # Sales'}], showLabels: true,
        showValues: true, unpinAxis: false, tickDensity: default, type: linear}, {
        label: '', orientation: right, series: [{axisId: percent_change_from_previous_orders_selected_metric,
            id: Augustiner - percent_change_from_previous_orders_selected_metric,
            name: Augustiner - Percent change from previous - * Orders * > Selected
              Metric}, {axisId: percent_change_from_previous_orders_selected_metric,
            id: Club Mate - percent_change_from_previous_orders_selected_metric, name: Club
              Mate - Percent change from previous - * Orders * > Selected Metric}],
        showLabels: true, showValues: true, unpinAxis: false, tickDensity: default,
        type: linear}]
    hide_legend: false
    font_size: 10px
    series_types: {}
    series_colors: {}
    series_labels:
      percent_change_from_previous_orders_selected_metric: "% Change"
    label_color: []
    ordering: none
    show_null_labels: false
    show_dropoff: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: true
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    single_value_title: "# New Customer"
    value_format: "#,##0"
    conditional_formatting: [{type: not null, value: !!null '', background_color: '',
        font_color: "#4276BE", color_application: {collection_id: product-custom-collection,
          palette_id: product-custom-collection-sequential-0}, bold: false, italic: false,
        strikethrough: false, fields: !!null ''}]
    defaults_version: 1
    listen:
      City: hubs.city
      Parent Category: products.category
      Sub-Category: products.subcategory
      SKU + Name: products.product_sku_name
      Date Granularity: orders.date_granularity
      Order Date: orders.created_date
      "> Select Metric": orders.KPI_parameter
      Brand: products.product_brand
      Country: hubs.country
    row: 15
    col: 8
    width: 8
    height: 6
  - title: per Parent Category
    name: per Parent Category
    model: brand_data_packages_v1
    explore: brand_data_packages_v1
    type: looker_line
    fields: [orders.KPI, orders.date, products.category]
    pivots: [products.category]
    sorts: [orders.date desc, products.category]
    limit: 500
    column_limit: 50
    dynamic_fields: [{args: [orders.KPI], calculation_type: percent_of_previous, category: table_calculation,
        based_on: orders.KPI, label: Percent of previous - * Orders * > Selected Metric,
        source_field: orders.KPI, table_calculation: percent_of_previous_orders_selected_metric,
        value_format: !!null '', value_format_name: percent_0, _kind_hint: measure,
        _type_hint: number, is_disabled: true}, {args: [percent_of_previous_orders_selected_metric],
        calculation_type: percent_difference_from_previous, category: table_calculation,
        based_on: percent_of_previous_orders_selected_metric, label: Percent change
          from previous -  Percent of previous - * Orders * > Selected Metric, source_field: percent_of_previous_orders_selected_metric,
        table_calculation: percent_change_from_previous_percent_of_previous_orders_selected_metric,
        value_format: !!null '', value_format_name: percent_0, _kind_hint: measure,
        _type_hint: number, is_disabled: true}, {args: [orders.KPI], calculation_type: percent_difference_from_previous,
        category: table_calculation, based_on: orders.KPI, label: Percent change from
          previous - * Orders * > Selected Metric, source_field: orders.KPI, table_calculation: percent_change_from_previous_orders_selected_metric,
        value_format: !!null '', value_format_name: percent_0, _kind_hint: measure,
        _type_hint: number, is_disabled: true}, {args: [orders.KPI], calculation_type: percent_difference_from_previous,
        category: table_calculation, based_on: orders.KPI, label: Percent change from
          previous - * Orders * > Selected Metric, source_field: orders.KPI, table_calculation: percent_change_from_previous_orders_selected_metric_2,
        value_format: !!null '', value_format_name: percent_0, _kind_hint: measure,
        _type_hint: number, is_disabled: true}]
    x_axis_gridlines: false
    y_axis_gridlines: false
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: true
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: normal
    limit_displayed_rows: false
    legend_position: center
    point_style: circle
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    color_application:
      collection_id: 1bc1f1d8-7461-4bfd-8c3b-424b924287b5
      palette_id: dd87bc4e-d86f-47b1-b0fd-44110dc0b469
      options:
        steps: 5
    y_axes: [{label: '', orientation: left, series: [{axisId: orders.KPI, id: Augustiner
              - orders.KPI, name: 'Augustiner - # Sales'}, {axisId: orders.KPI, id: Club
              Mate - orders.KPI, name: 'Club Mate - # Sales'}], showLabels: true,
        showValues: true, unpinAxis: false, tickDensity: default, type: linear}, {
        label: '', orientation: right, series: [{axisId: percent_change_from_previous_orders_selected_metric,
            id: Augustiner - percent_change_from_previous_orders_selected_metric,
            name: Augustiner - Percent change from previous - * Orders * > Selected
              Metric}, {axisId: percent_change_from_previous_orders_selected_metric,
            id: Club Mate - percent_change_from_previous_orders_selected_metric, name: Club
              Mate - Percent change from previous - * Orders * > Selected Metric}],
        showLabels: true, showValues: true, unpinAxis: false, tickDensity: default,
        type: linear}]
    hide_legend: false
    font_size: 10px
    series_types: {}
    series_colors: {}
    series_labels:
      percent_change_from_previous_orders_selected_metric: "% Change"
    label_color: []
    ordering: none
    show_null_labels: false
    show_dropoff: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: true
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    single_value_title: "# New Customer"
    value_format: "#,##0"
    conditional_formatting: [{type: not null, value: !!null '', background_color: '',
        font_color: "#4276BE", color_application: {collection_id: product-custom-collection,
          palette_id: product-custom-collection-sequential-0}, bold: false, italic: false,
        strikethrough: false, fields: !!null ''}]
    defaults_version: 1
    listen:
      City: hubs.city
      Parent Category: products.category
      Sub-Category: products.subcategory
      SKU + Name: products.product_sku_name
      Date Granularity: orders.date_granularity
      Order Date: orders.created_date
      "> Select Metric": orders.KPI_parameter
      Brand: products.product_brand
      Country: hubs.country
    row: 15
    col: 0
    width: 8
    height: 6
  - name: Performance evolution per dimension
    type: text
    title_text: Performance evolution per dimension
    subtitle_text: ''
    body_text: Your brand's performance evolution broken down per parent-category
      / sub-category. Break down per brand available for supplier with multiple brands
      sold on Flink.
    row: 13
    col: 0
    width: 24
    height: 2
  - title: Evolution over Time
    name: Evolution over Time (2)
    model: brand_data_packages_v1
    explore: brand_data_packages_v1
    type: looker_column
    fields: [orders.KPI, comparison_subcategory.KPI, orders.date]
    sorts: [orders.date]
    limit: 500
    column_limit: 50
    dynamic_fields: [{category: table_calculation, expression: "if(\n  (${comparison_subcategory.KPI}\
          \ - ${orders.KPI}) < 0, 0,\n   (${comparison_subcategory.KPI} - ${orders.KPI})\n\
          \  )", label: Sub-Category (excl. Brand), value_format: !!null '', value_format_name: !!null '',
        _kind_hint: measure, table_calculation: sub_category_excl_brand, _type_hint: number,
        is_disabled: true}, {category: table_calculation, expression: "${orders.KPI}\n\
          /\nif(\n  ${comparison_subcategory.KPI} = 0,\n  null,\n  ${comparison_subcategory.KPI}\n\
          )", label: "% of Sub-Category", value_format: !!null '', value_format_name: percent_0,
        _kind_hint: measure, table_calculation: of_sub_category, _type_hint: number}]
    x_axis_gridlines: false
    y_axis_gridlines: false
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
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    y_axes: [{label: '', orientation: left, series: [{axisId: orders.KPI, id: orders.KPI,
            name: Brand}, {axisId: comparison_subcategory.KPI, id: comparison_subcategory.KPI,
            name: Sub-Category}], showLabels: true, showValues: true, unpinAxis: false,
        tickDensity: default, tickDensityCustom: 5, type: linear}, {label: '', orientation: right,
        series: [{axisId: of_sub_category, id: of_sub_category, name: "% of Sub-Category"}],
        showLabels: false, showValues: true, unpinAxis: true, tickDensity: default,
        type: linear}]
    series_types:
      new_calculation: line
      of_sub_category: line
    series_colors:
      comparison_subcategory.KPI: "#f7cadd"
      orders.KPI: "#e5508e"
      sub_category_excl_brand: "#f7cadd"
      of_sub_category: "#7a9fd1"
    series_labels:
      orders.KPI: Brand
      comparison_subcategory.KPI: Sub-Category
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    hidden_fields:
    note_state: collapsed
    note_display: above
    note_text: Selected brand against its sub-category
    listen:
      City: hubs.city
      Parent Category: products.category
      Sub-Category: products.subcategory
      SKU + Name: products.product_sku_name
      Date Granularity: orders.date_granularity
      Order Date: orders.created_date
      "> Select Metric": orders.KPI_parameter
      Brand: products.product_brand
      Country: hubs.country
    row: 7
    col: 12
    width: 12
    height: 6
  - name: Performance Overview
    type: text
    title_text: Performance Overview
    subtitle_text: ''
    body_text: |
      Index:

      * **# Sales**: number of items sold for selected brand during selected timeframe
      * **# Orders**: number of orders including selected brand during selected timeframe
      * **# Items per order**: average number of items from selected brand per order during selected timeframe
      * **# Unique customers**: number of Flink customers who bought the selected brand at least once during selected timeframe
      * **# New customers**: number of Flink customers who bought the selected brand for the 1st time during selected timeframe
      * **Order Frequency**: number of orders per customer including selected brand during selected timeframe
    row: 0
    col: 0
    width: 24
    height: 5
  filters:
  - name: Brand
    title: Brand
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: popover
      options: []
    model: brand_data_packages_v1
    explore: brand_data_packages_v1
    listens_to_filters: []
    field: products.product_brand
  - name: Country
    title: Country
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: popover
      options: []
    model: brand_data_packages_v1
    explore: brand_data_packages_v1
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
    model: brand_data_packages_v1
    explore: brand_data_packages_v1
    listens_to_filters: []
    field: hubs.city
  - name: Parent Category
    title: Parent Category
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: popover
      options: []
    model: brand_data_packages_v1
    explore: brand_data_packages_v1
    listens_to_filters: []
    field: products.category
  - name: Sub-Category
    title: Sub-Category
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: popover
      options: []
    model: brand_data_packages_v1
    explore: brand_data_packages_v1
    listens_to_filters: []
    field: products.subcategory
  - name: SKU + Name
    title: SKU + Name
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: checkboxes
      display: popover
      options: []
    model: brand_data_packages_v1
    explore: brand_data_packages_v1
    listens_to_filters: []
    field: products.product_sku_name
  - name: Date Granularity
    title: Date Granularity
    type: field_filter
    default_value: week
    allow_multiple_values: true
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
      options: []
    model: brand_data_packages_v1
    explore: brand_data_packages_v1
    listens_to_filters: []
    field: orders.date_granularity
  - name: Order Date
    title: Order Date
    type: field_filter
    default_value: 7 week ago for 7 week
    allow_multiple_values: true
    required: true
    ui_config:
      type: advanced
      display: popover
      options: []
    model: brand_data_packages_v1
    explore: brand_data_packages_v1
    listens_to_filters: []
    field: orders.created_date
  - name: "> Select Metric"
    title: "> Select Metric"
    type: field_filter
    default_value: sales
    allow_multiple_values: true
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
      options: []
    model: brand_data_packages_v1
    explore: brand_data_packages_v1
    listens_to_filters: []
    field: orders.KPI_parameter
