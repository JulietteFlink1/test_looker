- dashboard: current_stock_and_stock_ranges
  title: "[In progress] Current Stock and Stock ranges (CT migrated)"
  layout: newspaper
  preferred_viewer: dashboards-next
  elements:
  - name: Current Stock and Stock Ranges
    title: Current Stock and Stock Ranges
    model: flink_v3
    explore: product_product
    type: looker_grid
    fields: [warehouse_warehouse.slug, product_productvariant.sku, product_product.name,
      warehouse_stock.sum_stock_quantity, order_orderline_facts.pct_stock_range_1d,
      order_orderline_facts.pct_stock_range_3d, order_orderline_facts.pct_stock_range_7d,
      order_orderline_facts.avg_daily_item_quantity_last_1d, order_orderline_facts.avg_daily_item_quantity_last_3d,
      order_orderline_facts.avg_daily_item_quantity_last_7d]
    filters:
      product_product.is_published: 'yes'
      order_orderline_facts.pct_stock_range_7d: NOT NULL
      product_product.visible_in_listings: ''
      order_orderline_facts.is_internal_order: 'no'
      order_orderline_facts.is_successful_order: 'yes'
      order_orderline_facts.warehouse_name: ''
      warehouse_stock.sum_stock_quantity: ''
    sorts: [order_orderline_facts.avg_daily_item_quantity_last_3d desc]
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
    series_column_widths:
      warehouse_warehouse.slug: 164
      product_productvariant.sku: 85
      product_product.name: 310
      warehouse_stock.sum_stock_quantity: 163
      order_orderline_facts.avg_daily_item_quantity_last_1d: 235
      order_orderline_facts.avg_daily_item_quantity_last_3d: 235
      order_orderline_facts.avg_daily_item_quantity_last_7d: 235
      order_orderline_facts.pct_stock_range_1d: 160
      order_orderline_facts.pct_stock_range_3d: 160
      order_orderline_facts.pct_stock_range_7d: 184
    series_cell_visualizations:
      warehouse_stock.sum_stock_quantity:
        is_active: true
        palette:
          palette_id: 4620e8de-df7a-40e0-89d6-7401f6e64d96
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      order_orderline_facts.pct_stock_range_7d:
        is_active: true
      order_orderline_facts.pct_stock_range_3d:
        is_active: true
      order_orderline_facts.pct_stock_range_1d:
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
      Name: warehouse_warehouse.name
    row: 0
    col: 0
    width: 23
    height: 19
  filters:
  - name: Name
    title: Name
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: popover
      options: []
    model: flink_v3
    explore: product_product
    listens_to_filters: []
    field: warehouse_warehouse.name
