- dashboard: stock_dashboard_realtime
  title: Stock Dashboard (Hourly Updated) (Migrated)
  layout: newspaper
  preferred_viewer: dashboards-next
  elements:
  - name: SKUs - Stock Range Table
    title: SKUs - Stock Range Table
    model: flink_v3
    explore: current_inventory_updated_hourly
    type: looker_grid
    fields: [
      products.product_sku,
      products.category,
      products.subcategory,
      products.product_name,
      inventory.sum_stock_quantity,
      order_lineitems.avg_daily_item_quantity_last_7d,
      order_lineitems.pct_stock_range_7d,
      hubs.hub_code,
      order_lineitems.avg_daily_item_quantity_last_1d,
      order_lineitems.sum_item_quantity
      ]
    filters:
      hubs.hub_code: ''
    sorts: [order_lineitems.pct_stock_range_7d]
    limit: 5000
    query_timezone: Europe/Berlin
    show_view_names: false
    show_row_numbers: false
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
    show_totals: true
    show_row_totals: true
    series_labels:
      products.subcategory: Sub-Category
      order_lineitems.sum_item_quantity: Total Sales YTD
      hubs.hub_code: Hub
    series_column_widths:
      hubs.hub_code: 231
      products.product_name: 320
      order_lineitems.pct_stock_range_7d: 129
      products.product_sku: 75
      products.category: 139
      products.subcategory: 101
      hubs.hub_code: 103
      inventory.sum_stock_quantity: 90
      order_lineitems.avg_daily_item_quantity_last_7d: 113
      order_lineitems.avg_daily_item_quantity_last_1d: 118
      order_lineitems.sum_item_quantity: 118
    series_cell_visualizations:
      inventory.sum_stock_quantity:
        is_active: true
        palette:
          palette_id: 4620e8de-df7a-40e0-89d6-7401f6e64d96
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      order_lineitems.avg_daily_item_quantity_today:
        is_active: true
        palette:
          palette_id: 4620e8de-df7a-40e0-89d6-7401f6e64d96
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      order_lineitems.avg_daily_item_quantity_last_7d:
        is_active: true
        palette:
          palette_id: 4620e8de-df7a-40e0-89d6-7401f6e64d96
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      order_lineitems.pct_stock_range_7d:
        is_active: true
    series_value_format:
      order_lineitems.pct_stock_range_7d:
        name: decimal_1
        format_string: "#,##0.0"
        label: Decimals (1)
    defaults_version: 1
    hidden_fields: []
    y_axes: []
    refresh: 2 hours
    listen:
      Is Published (Yes / No): products.is_published
      SUM Stock Quantity: inventory.sum_stock_quantity
      SUM Item Quantity sold: order_lineitems.sum_item_quantity
      'Category ': products.category
      Is Internal Order (Yes / No): orders.is_internal_order
      Is Successful Order (Yes / No): orders.is_successful_order
      SKU: products.product_sku
      SKU Name: products.product_name
      Warehouse Name: hubs.hub_name
    row: 0
    col: 0
    width: 24
    height: 16
  filters:
  - name: SKU Name
    title: SKU Name
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
      options: []
    model: flink_v3
    explore: current_inventory_updated_hourly
    listens_to_filters: []
    field: products.product_name
  - name: Warehouse Name
    title: Warehouse Name
    type: field_filter
    default_value: '"Aachen Kasinostraße (DE_AAH_BURT)"'
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: popover
      options: []
    model: flink_v3
    explore: current_inventory_updated_hourly
    listens_to_filters: []
    field: hubs.hub_name
  - name: 'Category '
    title: 'Category '
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
      options: []
    model: flink_v3
    explore: current_inventory_updated_hourly
    listens_to_filters: []
    field: products.category
  - name: SUM Item Quantity sold
    title: SUM Item Quantity sold
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
      options: []
    model: flink_v3
    explore: current_inventory_updated_hourly
    listens_to_filters: []
    field: order_lineitems.sum_item_quantity
  - name: Is Published (Yes / No)
    title: Is Published (Yes / No)
    type: field_filter
    default_value: 'Yes'
    allow_multiple_values: true
    required: false
    ui_config:
      type: button_group
      display: inline
      options: []
    model: flink_v3
    explore: current_inventory_updated_hourly
    listens_to_filters: []
    field: products.is_published
  - name: SUM Stock Quantity
    title: SUM Stock Quantity
    type: field_filter
    default_value: "[0,9999999]"
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
      options: []
    model: flink_v3
    explore: current_inventory_updated_hourly
    listens_to_filters: []
    field: inventory.sum_stock_quantity
  - name: Is Internal Order (Yes / No)
    title: Is Internal Order (Yes / No)
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: button_group
      display: inline
      options: []
    model: flink_v3
    explore: current_inventory_updated_hourly
    listens_to_filters: []
    field: orders.is_internal_order
  - name: Is Successful Order (Yes / No)
    title: Is Successful Order (Yes / No)
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: button_group
      display: inline
      options: []
    model: flink_v3
    explore: current_inventory_updated_hourly
    listens_to_filters: []
    field: orders.is_successful_order
  - name: SKU
    title: SKU
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
      options: []
    model: flink_v3
    explore: current_inventory_updated_hourly
    listens_to_filters: []
    field: products.product_sku
