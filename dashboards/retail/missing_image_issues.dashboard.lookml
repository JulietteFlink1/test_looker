- dashboard: missing_image_issues
  title: "[In Progress] Missing Image Issues (CT Migrated)"
  layout: newspaper
  preferred_viewer: dashboards-next
  refresh: 1 hour
  elements:
  - title: SKUs w/o images
    name: SKUs w/o images
    model: flink_realtime
    explore: product_product
    type: looker_grid
    fields: [product_category.name, product_product.name, product_product.metadata,
      product_product.updated_time, product_product.is_published, product_product.available_for_purchase_date,
      product_productvariant.price_amount, product_productvariant.sku, product_productimage.cnt_product_images,
      parent_category.name, warehouse_stock.sum_stock_quantity]
    filters:
      parent_category.name: ''
      warehouse_warehouse.name: "-UNFULFILLABLE"
    sorts: [warehouse_stock.sum_stock_quantity desc]
    limit: 1000
    dynamic_fields: [{table_calculation: current_timestamp, label: current timestamp,
        expression: now(), value_format: !!null '', value_format_name: !!null '',
        _kind_hint: dimension, _type_hint: date, is_disabled: true}]
    query_timezone: Europe/Berlin
    show_view_names: false
    show_row_numbers: false
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: editable
    limit_displayed_rows: false
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    pinned_columns:
      product_product.name: left
      current_timestamp: left
      product_productvariant.sku: left
    column_order: [product_productvariant.sku, product_product.name, parent_category.name,
      product_category.name, product_product.is_published, warehouse_stock.sum_stock_quantity,
      product_productimage.cnt_product_images, product_productvariant.price_amount,
      product_product.metadata, product_product.updated_time, product_product.available_for_purchase_date]
    show_totals: true
    show_row_totals: true
    series_labels:
      parent_category.name: Category
      product_category.name: Sub_Category
      product_productimage.cnt_product_images: "# Images"
      warehouse_stock.sum_stock_quantity: Total Inventory (#)
      product_product.metadata: Shelf
      product_productvariant.price_amount: Price p. unit
    series_column_widths:
      warehouse_warehouse.address_id: 114
      warehouse_warehouse.name: 255
      product_product.category_id: 118
      product_category.name: 146
      product_product.id: 66
      product_product.name: 372
      product_product.metadata: 168
      product_product.publication_date: 168
      product_product.slug: 362
      product_product.updated_time: 147
      product_product.is_published: 178
      product_product.visible_in_listings: 207
      product_product.available_for_purchase_date: 204
      product_productvariant.id: 66
      product_productvariant.name: 87
      product_productvariant.metadata: 167
      product_productvariant.price_amount: 128
      product_productvariant.sku: 102
      product_productvariant.sort_order: 110
      warehouse_stock.id: 66
      warehouse_stock.warehouse_id: 263
      warehouse_stock.quantity: 101
      warehouse_warehouse.slug: 164
      product_product.cnt_product_images: 150
      current_timestamp: 154
      product_productimage.cnt_product_images: 130
      parent_category.name: 117
      warehouse_stock.sum_stock_quantity: 169
    series_cell_visualizations:
      product_productimage.cnt_product_images:
        is_active: true
    defaults_version: 1
    hidden_fields: []
    y_axes: []
    listen:
      Is Published (Yes / No): product_product.is_published
      Product Images (#): product_productimage.cnt_product_images
      SUM Stock Quantity: warehouse_stock.sum_stock_quantity
    row: 0
    col: 0
    width: 19
    height: 22
  filters:
  - name: Category
    title: Category
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: popover
      options: []
    model: flink_realtime
    explore: product_product
    listens_to_filters: []
    field: parent_category.name
  - name: Product Images (#)
    title: Product Images (#)
    type: field_filter
    default_value: '0'
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
      options: []
    model: flink_realtime
    explore: product_product
    listens_to_filters: []
    field: product_productimage.cnt_product_images
  - name: Is Published (Yes / No)
    title: Is Published (Yes / No)
    type: field_filter
    default_value: No,Yes
    allow_multiple_values: true
    required: false
    ui_config:
      type: button_group
      display: inline
      options: []
    model: flink_realtime
    explore: product_product
    listens_to_filters: []
    field: product_product.is_published
  - name: SUM Stock Quantity
    title: SUM Stock Quantity
    type: field_filter
    default_value: ">=1"
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
      options: []
    model: flink_realtime
    explore: product_product
    listens_to_filters: []
    field: warehouse_stock.sum_stock_quantity
