- dashboard: product_placement_performance
  title: Product Placement Level Performance
  layout: newspaper
  preferred_viewer: dashboards-next
  description: ''
  elements:
  - title: Placement and Category and Product
    name: Placement and Category and Product
    model: flink_v3
    explore: product_placement_performance_excluding_impressions
    type: looker_grid
    fields: [product_placement_performance_excluding_impressions.category_name, product_placement_performance_excluding_impressions.subcategory_name,
      product_placement_performance_excluding_impressions.product_placement, product_placement_performance_excluding_impressions.product_name, product_placement_performance_excluding_impressions.product_sku,
      product_placement_performance_excluding_impressions.add_to_carts, product_placement_performance_excluding_impressions.orders]
    filters:
      product_placement_performance_excluding_impressions.app_version: ''
    sorts: [product_placement_performance_excluding_impressions.add_to_carts desc]
    limit: 500
    total: true
    dynamic_fields: [{measure: list_of_country_iso, based_on: product_placement_performance_excluding_impressions.country_iso,
        expression: '', label: List of country_iso, type: list, _kind_hint: measure, _type_hint: list}]
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
    header_font_size: 12
    rows_font_size: 12
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
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
      Product SKU: product_placement_performance_excluding_impressions.product_sku
      Event Date: product_placement_performance_excluding_impressions.event_date
      Category Name: product_placement_performance_excluding_impressions.category_name
      Subcategory Name: product_placement_performance_excluding_impressions.subcategory_name
      Product Name: product_placement_performance_excluding_impressions.product_name
      country_iso: product_placement_performance_excluding_impressions.country_iso
      Hub Code: product_placement_performance_excluding_impressions.hub_code
      Product Placement: product_placement_performance_excluding_impressions.product_placement
    row: 86
    col: 0
    width: 24
    height: 11
  - title: Placement
    name: Placement
    model: flink_v3
    explore: product_placement_performance_excluding_impressions
    type: looker_grid
    fields: [product_placement_performance_excluding_impressions.add_to_carts,
      product_placement_performance_excluding_impressions.orders, product_placement_performance_excluding_impressions.pdps,
      product_placement_performance_excluding_impressions.product_placement]
    filters:
      product_placement_performance_excluding_impressions.app_version: ''
    sorts: [product_placement_performance_excluding_impressions.add_to_carts desc]
    limit: 5000
    total: true
    dynamic_fields: [{measure: list_of_country_iso, based_on: product_placement_performance_excluding_impressions.country_iso,
        expression: '', label: List of country_iso, type: list, _kind_hint: measure, _type_hint: list},
      {category: table_calculation, label: Add to basket in %, value_format: !!null '',
        value_format_name: percent_1, calculation_type: percent_of_column_sum, table_calculation: add_to_basket_in,
        args: [product_placement_performance_excluding_impressions.add_to_carts], _kind_hint: measure,
        _type_hint: number}]
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
    column_order: ["$$$_row_numbers_$$$", product_placement_performance_excluding_impressions.product_placement, product_placement_performance_excluding_impressions.add_to_carts,
      add_to_basket_in, product_placement_performance_excluding_impressions.orders,
      product_placement_performance_excluding_impressions.pdps]
    show_totals: true
    show_row_totals: true
    series_cell_visualizations:
      product_placement_performance_excluding_impressions.add_to_carts:
        is_active: true
    series_value_format:
      product_placement_performance_excluding_impressions.orders:
        name: decimal_0
        decimals: '0'
        format_string: "#,##0"
        label: Decimals (0)
        label_prefix: Decimals
      product_placement_performance_excluding_impressions.pdps:
        name: decimal_0
        decimals: '0'
        format_string: "#,##0"
        label: Decimals (0)
        label_prefix: Decimals
      product_placement_performance_excluding_impressions.add_to_carts:
        name: decimal_0
        decimals: '0'
        format_string: "#,##0"
        label: Decimals (0)
        label_prefix: Decimals
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
      Product SKU: product_placement_performance_excluding_impressions.product_sku
      Event Date: product_placement_performance_excluding_impressions.event_date
      Category Name: product_placement_performance_excluding_impressions.category_name
      Subcategory Name: product_placement_performance_excluding_impressions.subcategory_name
      Product Name: product_placement_performance_excluding_impressions.product_name
      country_iso: product_placement_performance_excluding_impressions.country_iso
      Hub Code: product_placement_performance_excluding_impressions.hub_code
      Product Placement: product_placement_performance_excluding_impressions.product_placement
    row: 3
    col: 0
    width: 24
    height: 6
  - title: Category and Subcategory
    name: Category and Subcategory
    model: flink_v3
    explore: product_placement_performance_excluding_impressions
    type: looker_grid
    fields: [product_placement_performance_excluding_impressions.category_name, product_placement_performance_excluding_impressions.add_to_carts,
      product_placement_performance_excluding_impressions.subcategory_name,
      product_placement_performance_excluding_impressions.orders, product_placement_performance_excluding_impressions.pdps]
    filters:
      product_placement_performance_excluding_impressions.app_version: ''
    sorts: [product_placement_performance_excluding_impressions.category_name, product_placement_performance_excluding_impressions.add_to_carts
        desc]
    subtotals: [product_placement_performance_excluding_impressions.category_name]
    limit: 5000
    total: true
    dynamic_fields: [{measure: list_of_country_iso, based_on: product_placement_performance_excluding_impressions.country_iso,
        expression: '', label: List of country_iso, type: list, _kind_hint: measure, _type_hint: list}]
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
      product_placement_performance_excluding_impressions.add_to_carts:
        is_active: true
    series_collapsed:
      product_placement_performance_excluding_impressions.category_name: true
    series_value_format:
      product_placement_performance_excluding_impressions.add_to_carts:
        format_string:
      product_placement_performance_excluding_impressions.orders:
        format_string:
      product_placement_performance_excluding_impressions.pdps:
        format_string:
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
      Product SKU: product_placement_performance_excluding_impressions.product_sku
      Event Date: product_placement_performance_excluding_impressions.event_date
      Category Name: product_placement_performance_excluding_impressions.category_name
      Subcategory Name: product_placement_performance_excluding_impressions.subcategory_name
      Product Name: product_placement_performance_excluding_impressions.product_name
      country_iso: product_placement_performance_excluding_impressions.country_iso
      Hub Code: product_placement_performance_excluding_impressions.hub_code
      Product Placement: product_placement_performance_excluding_impressions.product_placement
    row: 9
    col: 0
    width: 24
    height: 9
  - title: Category Split per Week
    name: Category Split per Week
    model: flink_v3
    explore: product_placement_performance_excluding_impressions
    type: looker_column
    fields: [product_placement_performance_excluding_impressions.orders, product_placement_performance_excluding_impressions.category_name,
      product_placement_performance_excluding_impressions.event_week]
    pivots: [product_placement_performance_excluding_impressions.category_name]
    fill_fields: [product_placement_performance_excluding_impressions.event_week]
    filters:
      product_placement_performance_excluding_impressions.app_version: ''
    sorts: [product_placement_performance_excluding_impressions.orders desc 0, product_placement_performance_excluding_impressions.category_name]
    limit: 5000
    column_limit: 5000
    total: true
    dynamic_fields: [{measure: list_of_country_iso, based_on: product_placement_performance_excluding_impressions.country_iso,
        expression: '', label: List of country_iso, type: list, _kind_hint: measure, _type_hint: list}]
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
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: 12
    rows_font_size: 12
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 1
    hidden_fields: []
    y_axes: []
    listen:
      Product SKU: product_placement_performance_excluding_impressions.product_sku
      Event Date: product_placement_performance_excluding_impressions.event_date
      Category Name: product_placement_performance_excluding_impressions.category_name
      Subcategory Name: product_placement_performance_excluding_impressions.subcategory_name
      Product Name: product_placement_performance_excluding_impressions.product_name
      country_iso: product_placement_performance_excluding_impressions.country_iso
      Hub Code: product_placement_performance_excluding_impressions.hub_code
      Product Placement: product_placement_performance_excluding_impressions.product_placement
    row: 18
    col: 0
    width: 24
    height: 11
  - title: Category and Subcategory Split per Week
    name: Category and Subcategory Split per Week
    model: flink_v3
    explore: product_placement_performance_excluding_impressions
    type: looker_grid
    fields: [product_placement_performance_excluding_impressions.orders, product_placement_performance_excluding_impressions.category_name,
      product_placement_performance_excluding_impressions.subcategory_name, product_placement_performance_excluding_impressions.event_week]
    pivots: [product_placement_performance_excluding_impressions.event_week]
    fill_fields: [product_placement_performance_excluding_impressions.event_week]
    filters:
      product_placement_performance_excluding_impressions.app_version: ''
    sorts: [product_placement_performance_excluding_impressions.orders desc 0, product_placement_performance_excluding_impressions.category_name]
    limit: 5000
    total: true
    dynamic_fields: [{measure: list_of_country_iso, based_on: product_placement_performance_excluding_impressions.country_iso,
        expression: '', label: List of country_iso, type: list, _kind_hint: measure, _type_hint: list}]
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
    header_font_size: 12
    rows_font_size: 12
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
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
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    hidden_fields: []
    y_axes: []
    listen:
      Product SKU: product_placement_performance_excluding_impressions.product_sku
      Event Date: product_placement_performance_excluding_impressions.event_date
      Category Name: product_placement_performance_excluding_impressions.category_name
      Subcategory Name: product_placement_performance_excluding_impressions.subcategory_name
      Product Name: product_placement_performance_excluding_impressions.product_name
      country_iso: product_placement_performance_excluding_impressions.country_iso
      Hub Code: product_placement_performance_excluding_impressions.hub_code
      Product Placement: product_placement_performance_excluding_impressions.product_placement
    row: 29
    col: 0
    width: 24
    height: 10
  - title: Placement Split per Week
    name: Placement Split per Week
    model: flink_v3
    explore: product_placement_performance_excluding_impressions
    type: looker_column
    fields: [product_placement_performance_excluding_impressions.orders, product_placement_performance_excluding_impressions.product_placement,
      product_placement_performance_excluding_impressions.event_week]
    pivots: [product_placement_performance_excluding_impressions.product_placement]
    fill_fields: [product_placement_performance_excluding_impressions.event_week]
    filters:
      product_placement_performance_excluding_impressions.app_version: ''
    sorts: [product_placement_performance_excluding_impressions.orders desc 0]
    limit: 5000
    total: true
    dynamic_fields: [{measure: list_of_country_iso, based_on: product_placement_performance_excluding_impressions.country_iso,
        expression: '', label: List of country_iso, type: list, _kind_hint: measure, _type_hint: list}]
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
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: 12
    rows_font_size: 12
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 1
    hidden_fields: []
    y_axes: []
    listen:
      Product SKU: product_placement_performance_excluding_impressions.product_sku
      Event Date: product_placement_performance_excluding_impressions.event_date
      Category Name: product_placement_performance_excluding_impressions.category_name
      Subcategory Name: product_placement_performance_excluding_impressions.subcategory_name
      Product Name: product_placement_performance_excluding_impressions.product_name
      country_iso: product_placement_performance_excluding_impressions.country_iso
      Hub Code: product_placement_performance_excluding_impressions.hub_code
      Product Placement: product_placement_performance_excluding_impressions.product_placement
    row: 39
    col: 0
    width: 24
    height: 11
  - title: Placement per Week
    name: Placement per Week
    model: flink_v3
    explore: product_placement_performance_excluding_impressions
    type: looker_grid
    fields: [product_placement_performance_excluding_impressions.product_placement, product_placement_performance_excluding_impressions.orders,
      product_placement_performance_excluding_impressions.category_name, product_placement_performance_excluding_impressions.subcategory_name, product_placement_performance_excluding_impressions.event_week]
    pivots: [product_placement_performance_excluding_impressions.event_week]
    fill_fields: [product_placement_performance_excluding_impressions.event_week]
    filters:
      product_placement_performance_excluding_impressions.app_version: ''
    sorts: [product_placement_performance_excluding_impressions.product_placement, product_placement_performance_excluding_impressions.category_name,
      product_placement_performance_excluding_impressions.subcategory_name, product_placement_performance_excluding_impressions.orders
        desc 0]
    subtotals: [product_placement_performance_excluding_impressions.product_placement, product_placement_performance_excluding_impressions.category_name]
    limit: 5000
    total: true
    dynamic_fields: [{measure: list_of_country_iso, based_on: product_placement_performance_excluding_impressions.country_iso,
        expression: '', label: List of country_iso, type: list, _kind_hint: measure, _type_hint: list},
      {category: table_calculation, label: Add to basket in %, value_format: !!null '',
        value_format_name: percent_1, calculation_type: percent_of_column_sum, table_calculation: add_to_basket_in,
        args: [product_placement_performance_excluding_impressions.add_to_carts], _kind_hint: measure,
        _type_hint: number, is_disabled: true}, {category: table_calculation, label: "%\
          \ of Products purchased", value_format: !!null '', value_format_name: percent_2,
        calculation_type: percent_of_column_sum, table_calculation: of_products_purchased,
        args: [product_placement_performance_excluding_impressions.orders], _kind_hint: measure,
        _type_hint: number}]
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
    column_order: ["$$$_row_numbers_$$$", product_placement_performance_excluding_impressions.product_placement, product_placement_performance_excluding_impressions.add_to_carts,
      add_to_basket_in, product_placement_performance_excluding_impressions.orders,
      product_placement_performance_excluding_impressions.pdps]
    show_totals: true
    show_row_totals: true
    series_cell_visualizations:
      product_placement_performance_excluding_impressions.orders:
        is_active: true
    series_collapsed:
      product_placement_performance_excluding_impressions.product_placement: true
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
      Product SKU: product_placement_performance_excluding_impressions.product_sku
      Event Date: product_placement_performance_excluding_impressions.event_date
      Category Name: product_placement_performance_excluding_impressions.category_name
      Subcategory Name: product_placement_performance_excluding_impressions.subcategory_name
      Product Name: product_placement_performance_excluding_impressions.product_name
      country_iso: product_placement_performance_excluding_impressions.country_iso
      Hub Code: product_placement_performance_excluding_impressions.hub_code
      Product Placement: product_placement_performance_excluding_impressions.product_placement
    row: 50
    col: 0
    width: 24
    height: 8
  - title: Placement per month
    name: Placement per month
    model: flink_v3
    explore: product_placement_performance_excluding_impressions
    type: looker_grid
    fields: [product_placement_performance_excluding_impressions.product_placement, product_placement_performance_excluding_impressions.orders,
      product_placement_performance_excluding_impressions.category_name, product_placement_performance_excluding_impressions.subcategory_name, product_placement_performance_excluding_impressions.event_month]
    pivots: [product_placement_performance_excluding_impressions.event_month]
    fill_fields: [product_placement_performance_excluding_impressions.event_month]
    filters:
      product_placement_performance_excluding_impressions.app_version: ''
    sorts: [product_placement_performance_excluding_impressions.product_placement, product_placement_performance_excluding_impressions.category_name,
      product_placement_performance_excluding_impressions.subcategory_name, product_placement_performance_excluding_impressions.orders
        desc]
    subtotals: [product_placement_performance_excluding_impressions.product_placement, product_placement_performance_excluding_impressions.category_name,
      product_placement_performance_excluding_impressions.event_week]
    limit: 5000
    total: true
    dynamic_fields: [{measure: list_of_country_iso, based_on: product_placement_performance_excluding_impressions.country_iso,
        expression: '', label: List of country_iso, type: list, _kind_hint: measure, _type_hint: list},
      {category: table_calculation, label: Add to basket in %, value_format: !!null '',
        value_format_name: percent_1, calculation_type: percent_of_column_sum, table_calculation: add_to_basket_in,
        args: [product_placement_performance_excluding_impressions.add_to_carts], _kind_hint: measure,
        _type_hint: number, is_disabled: true}, {category: table_calculation, label: "%\
          \ of Products purchased", value_format: !!null '', value_format_name: percent_2,
        calculation_type: percent_of_column_sum, table_calculation: of_products_purchased,
        args: [product_placement_performance_excluding_impressions.orders], _kind_hint: measure,
        _type_hint: number}]
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
    column_order: ["$$$_row_numbers_$$$", product_placement_performance_excluding_impressions.product_placement, product_placement_performance_excluding_impressions.add_to_carts,
      add_to_basket_in, product_placement_performance_excluding_impressions.orders,
      product_placement_performance_excluding_impressions.pdps]
    show_totals: true
    show_row_totals: true
    series_cell_visualizations:
      product_placement_performance_excluding_impressions.orders:
        is_active: true
    series_collapsed:
      product_placement_performance_excluding_impressions.product_placement: true
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
      Product SKU: product_placement_performance_excluding_impressions.product_sku
      Event Date: product_placement_performance_excluding_impressions.event_date
      Category Name: product_placement_performance_excluding_impressions.category_name
      Subcategory Name: product_placement_performance_excluding_impressions.subcategory_name
      Product Name: product_placement_performance_excluding_impressions.product_name
      country_iso: product_placement_performance_excluding_impressions.country_iso
      Hub Code: product_placement_performance_excluding_impressions.hub_code
      Product Placement: product_placement_performance_excluding_impressions.product_placement
    row: 67
    col: 0
    width: 24
    height: 9
  - title: Placement per day
    name: Placement per day
    model: flink_v3
    explore: product_placement_performance_excluding_impressions
    type: looker_grid
    fields: [product_placement_performance_excluding_impressions.orders, product_placement_performance_excluding_impressions.category_name,
      product_placement_performance_excluding_impressions.event_date]
    pivots: [product_placement_performance_excluding_impressions.event_date]
    fill_fields: [product_placement_performance_excluding_impressions.event_date]
    filters:
      product_placement_performance_excluding_impressions.app_version: ''
    sorts: [product_placement_performance_excluding_impressions.category_name, product_placement_performance_excluding_impressions.orders
        desc 0, product_placement_performance_excluding_impressions.event_date]
    limit: 5000
    total: true
    dynamic_fields: [{measure: list_of_country_iso, based_on: product_placement_performance_excluding_impressions.country_iso,
        expression: '', label: List of country_iso, type: list, _kind_hint: measure, _type_hint: list},
      {category: table_calculation, label: Add to basket in %, value_format: !!null '',
        value_format_name: percent_1, calculation_type: percent_of_column_sum, table_calculation: add_to_basket_in,
        args: [product_placement_performance_excluding_impressions.add_to_carts], _kind_hint: measure,
        _type_hint: number, is_disabled: true}, {category: table_calculation, label: "%\
          \ of Products purchased", value_format: !!null '', value_format_name: percent_2,
        calculation_type: percent_of_column_sum, table_calculation: of_products_purchased,
        args: [product_placement_performance_excluding_impressions.orders], _kind_hint: measure,
        _type_hint: number, is_disabled: true}]
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
    column_order: ["$$$_row_numbers_$$$", product_placement_performance_excluding_impressions.product_placement, product_placement_performance_excluding_impressions.add_to_carts,
      add_to_basket_in, product_placement_performance_excluding_impressions.orders,
      product_placement_performance_excluding_impressions.pdps]
    show_totals: true
    show_row_totals: true
    series_cell_visualizations:
      product_placement_performance_excluding_impressions.orders:
        is_active: true
    series_collapsed:
      product_placement_performance_excluding_impressions.product_placement: true
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
      Product SKU: product_placement_performance_excluding_impressions.product_sku
      Event Date: product_placement_performance_excluding_impressions.event_date
      Category Name: product_placement_performance_excluding_impressions.category_name
      Subcategory Name: product_placement_performance_excluding_impressions.subcategory_name
      Product Name: product_placement_performance_excluding_impressions.product_name
      country_iso: product_placement_performance_excluding_impressions.country_iso
      Hub Code: product_placement_performance_excluding_impressions.hub_code
      Product Placement: product_placement_performance_excluding_impressions.product_placement
    row: 76
    col: 0
    width: 24
    height: 10
  - title: Placement per Week (Copy)
    name: Placement per Week (Copy)
    model: flink_v3
    explore: product_placement_performance_excluding_impressions
    type: looker_column
    fields: [product_placement_performance_excluding_impressions.product_placement, product_placement_performance_excluding_impressions.orders,
      product_placement_performance_excluding_impressions.event_week]
    pivots: [product_placement_performance_excluding_impressions.product_placement]
    fill_fields: [product_placement_performance_excluding_impressions.event_week]
    filters:
      product_placement_performance_excluding_impressions.app_version: ''
    sorts: [product_placement_performance_excluding_impressions.product_placement, product_placement_performance_excluding_impressions.orders
        desc 0, product_placement_performance_excluding_impressions.event_week]
    limit: 5000
    total: true
    dynamic_fields: [{measure: list_of_country_iso, based_on: product_placement_performance_excluding_impressions.country_iso,
        expression: '', label: List of country_iso, type: list, _kind_hint: measure, _type_hint: list},
      {category: table_calculation, label: Add to basket in %, value_format: !!null '',
        value_format_name: percent_1, calculation_type: percent_of_column_sum, table_calculation: add_to_basket_in,
        args: [product_placement_performance_excluding_impressions.add_to_carts], _kind_hint: measure,
        _type_hint: number, is_disabled: true}, {category: table_calculation, label: "%\
          \ of Products purchased", value_format: !!null '', value_format_name: percent_2,
        calculation_type: percent_of_column_sum, table_calculation: of_products_purchased,
        args: [product_placement_performance_excluding_impressions.orders], _kind_hint: measure,
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
    stacking: percent
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
    series_types: {}
    show_null_points: true
    interpolation: linear
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    column_order: ["$$$_row_numbers_$$$", product_placement_performance_excluding_impressions.product_placement, product_placement_performance_excluding_impressions.add_to_carts,
      add_to_basket_in, product_placement_performance_excluding_impressions.orders,
      product_placement_performance_excluding_impressions.pdps]
    show_totals: true
    show_row_totals: true
    series_cell_visualizations:
      product_placement_performance_excluding_impressions.orders:
        is_active: true
    series_collapsed:
      product_placement_performance_excluding_impressions.product_placement: true
    defaults_version: 1
    hidden_fields: []
    y_axes: []
    listen:
      Product SKU: product_placement_performance_excluding_impressions.product_sku
      Event Date: product_placement_performance_excluding_impressions.event_date
      Category Name: product_placement_performance_excluding_impressions.category_name
      Subcategory Name: product_placement_performance_excluding_impressions.subcategory_name
      Product Name: product_placement_performance_excluding_impressions.product_name
      country_iso: product_placement_performance_excluding_impressions.country_iso
      Hub Code: product_placement_performance_excluding_impressions.hub_code
      Product Placement: product_placement_performance_excluding_impressions.product_placement
    row: 58
    col: 0
    width: 24
    height: 9
  - title: Placement and Category and Product (Copy)
    name: Placement and Category and Product (Copy)
    model: flink_v3
    explore: product_placement_performance_excluding_impressions
    type: looker_grid
    fields: [product_placement_performance_excluding_impressions.product_placement, product_placement_performance_excluding_impressions.product_name,
      product_placement_performance_excluding_impressions.product_sku, product_placement_performance_excluding_impressions.add_to_carts]
    pivots: [product_placement_performance_excluding_impressions.product_placement]
    filters:
      product_placement_performance_excluding_impressions.app_version: ''
    sorts: [product_placement_performance_excluding_impressions.add_to_carts desc 0]
    limit: 5000
    total: true
    dynamic_fields: [{measure: list_of_country_iso, based_on: product_placement_performance_excluding_impressions.country_iso,
        expression: '', label: List of country_iso, type: list, _kind_hint: measure, _type_hint: list}]
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
    header_font_size: 12
    rows_font_size: 12
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
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
      Product SKU: product_placement_performance_excluding_impressions.product_sku
      Event Date: product_placement_performance_excluding_impressions.event_date
      Category Name: product_placement_performance_excluding_impressions.category_name
      Subcategory Name: product_placement_performance_excluding_impressions.subcategory_name
      Product Name: product_placement_performance_excluding_impressions.product_name
      country_iso: product_placement_performance_excluding_impressions.country_iso
      Hub Code: product_placement_performance_excluding_impressions.hub_code
      Product Placement: product_placement_performance_excluding_impressions.product_placement
    row: 97
    col: 0
    width: 24
    height: 15
  - title: Category Split per Week
    name: Category Split per Week (2)
    model: flink_v3
    explore: product_placement_performance_excluding_impressions
    type: looker_column
    fields: [product_placement_performance_excluding_impressions.orders, product_placement_performance_excluding_impressions.subcategory_name,
      product_placement_performance_excluding_impressions.event_date]
    pivots: [product_placement_performance_excluding_impressions.subcategory_name]
    fill_fields: [product_placement_performance_excluding_impressions.event_date]
    filters:
      product_placement_performance_excluding_impressions.app_version: ''
    sorts: [product_placement_performance_excluding_impressions.orders desc 0, product_placement_performance_excluding_impressions.subcategory_name]
    limit: 5000
    column_limit: 50
    total: true
    dynamic_fields: [{measure: list_of_country_iso, based_on: product_placement_performance_excluding_impressions.country_iso,
        expression: '', label: List of country_iso, type: list, _kind_hint: measure, _type_hint: list}]
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
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: 12
    rows_font_size: 12
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 1
    hidden_fields: []
    y_axes: []
    listen:
      Product SKU: product_placement_performance_excluding_impressions.product_sku
      Event Date: product_placement_performance_excluding_impressions.event_date
      Category Name: product_placement_performance_excluding_impressions.category_name
      Subcategory Name: product_placement_performance_excluding_impressions.subcategory_name
      Product Name: product_placement_performance_excluding_impressions.product_name
      country_iso: product_placement_performance_excluding_impressions.country_iso
      Hub Code: product_placement_performance_excluding_impressions.hub_code
      Product Placement: product_placement_performance_excluding_impressions.product_placement
    row: 112
    col: 0
    width: 24
    height: 17
  - name: Disclaimer
    type: text
    title_text: Disclaimer
    subtitle_text: ''
    body_text: "The model that this dashboard relies on was depreciated on March 29th\
      \ 2022, and the numbers shown have not been updated since then. \n\nWe will\
      \ share a new explore & view shortly. "
    row: 0
    col: 0
    width: 18
    height: 3
  filters:
  - name: Product SKU
    title: Product SKU
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
      options: []
    model: flink_v3
    explore: product_placement_performance_excluding_impressions
    listens_to_filters: []
    field: product_placement_performance_excluding_impressions.product_sku
  - name: Product Name
    title: Product Name
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
      options: []
    model: flink_v3
    explore: product_placement_performance_excluding_impressions
    listens_to_filters: []
    field: product_placement_performance_excluding_impressions.product_name
  - name: Category Name
    title: Category Name
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: popover
      options: []
    model: flink_v3
    explore: product_placement_performance_excluding_impressions
    listens_to_filters: []
    field: product_placement_performance_excluding_impressions.category_name
  - name: Subcategory Name
    title: Subcategory Name
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: popover
      options: []
    model: flink_v3
    explore: product_placement_performance_excluding_impressions
    listens_to_filters: []
    field: product_placement_performance_excluding_impressions.subcategory_name
  - name: Event Date
    title: Event Date
    type: field_filter
    default_value: 7 day
    allow_multiple_values: true
    required: false
    ui_config:
      type: relative_timeframes
      display: inline
      options: []
    model: flink_v3
    explore: product_placement_performance_excluding_impressions
    listens_to_filters: []
    field: product_placement_performance_excluding_impressions.event_date
  - name: Hub Code
    title: Hub Code
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: popover
      options: []
    model: flink_v3
    explore: product_placement_performance_excluding_impressions
    listens_to_filters: []
    field: product_placement_performance_excluding_impressions.hub_code
  - name: country_iso
    title: country_iso
    type: field_filter
    default_value: DE
    allow_multiple_values: true
    required: false
    ui_config:
      type: checkboxes
      display: popover
      options: []
    model: flink_v3
    explore: product_placement_performance_excluding_impressions
    listens_to_filters: []
    field: product_placement_performance_excluding_impressions.country_iso
  - name: Product Placement
    title: Product Placement
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: checkboxes
      display: popover
      options: []
    model: flink_v3
    explore: product_placement_performance_excluding_impressions
    listens_to_filters: []
    field: product_placement_performance_excluding_impressions.product_placement
