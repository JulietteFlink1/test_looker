- dashboard: products_dashboard_skus_performance
  title: Products Dashboard (SKUs, Performance)
  layout: newspaper
  preferred_viewer: dashboards-next
  elements:
  - name: Top Selling Products
    title: Top Selling Products
    model: flink_v3
    explore: order_orderline_cl
    type: looker_grid
    fields: [orders_cl.warehouse_name, orderline.product_sku, orderline.sum_item_quantity,
      orderline.name, orderline.tax_rate, orderline.unit_price_gross_amount,
      orderline.sum_item_price_gross, orderline.sum_item_price_net]
    filters:
      orders_cl.is_internal_order: 'No'
      orders_cl.is_successful_order: 'Yes'
    sorts: [orderline.sum_item_quantity desc]
    limit: 500
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
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    column_order: ["$$$_row_numbers_$$$", orders_cl.warehouse_name, orderline.name,
      orderline.product_sku, orderline.tax_rate, orderline.unit_price_gross_amount,
      orderline.unit_price_net_amount, orderline.sum_item_quantity]
    show_totals: true
    show_row_totals: true
    series_column_widths:
      orders_cl.warehouse_name: 167
      orderline.product_sku: 123
      orderline.name: 284
      orderline.tax_rate: 102
      orderline.unit_price_gross_amount: 187
      orderline.unit_price_net_amount: 175
      orderline.sum_item_quantity: 180
      orderline.sum_item_price_gross: 212
      orderline.sum_item_price_net: 199
    series_cell_visualizations:
      orderline.sum_item_quantity:
        is_active: true
        palette:
          palette_id: 56d0c358-10a0-4fd6-aa0b-b117bef527ab
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      orderline.sum_item_price_gross:
        is_active: true
        palette:
          palette_id: 56d0c358-10a0-4fd6-aa0b-b117bef527ab
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      orderline.sum_item_price_net:
        is_active: true
        palette:
          palette_id: 56d0c358-10a0-4fd6-aa0b-b117bef527ab
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
    series_text_format:
      orders_cl.warehouse_name:
        bold: true
        fg_color: "#1A73E8"
      orderline.name:
        bold: true
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
      Warehouse Name: orders_cl.warehouse_name
      Order Date: orders_cl.created_date
    row: 0
    col: 0
    width: 23
    height: 12
  filters:
  - name: Warehouse Name
    title: Warehouse Name
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: inline
    model: flink_v3
    explore: order_orderline_cl
    listens_to_filters: []
    field: orders_cl.warehouse_name
  - name: Order Date
    title: Order Date
    type: field_filter
    default_value: 7 day
    allow_multiple_values: true
    required: false
    ui_config:
      type: relative_timeframes
      display: inline
      options: []
    model: flink_v3
    explore: order_orderline_cl
    listens_to_filters: []
    field: orders_cl.created_date
