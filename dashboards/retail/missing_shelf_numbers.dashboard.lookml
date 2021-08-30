- dashboard: missing_shelf_numbers
  title: "[In Progress] Missing Shelf Numbers (CT migrated)"
  layout: newspaper
  preferred_viewer: dashboards-next
  refresh: 1 hour
  elements:
  - name: Missing Shelf Numbers
    title: Missing Shelf Numbers
    model: flink_realtime
    explore: order_orderline_cl
    type: looker_grid
    fields: [product_category.name, product_product.name, product_product.metadata,
      product_product.updated_time, product_product.is_published, product_product.available_for_purchase_date,
      product_productvariant.price_amount, product_productvariant.sku, product_productimage.cnt_product_images,
      parent_category.name, warehouse_stock.sum_stock_quantity]
    filters:
      product_product.is_published: ''
    sorts: [warehouse_stock.sum_stock_quantity desc]
    limit: 1000
    column_limit: 50
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
    color_application:
      collection_id: aed851c8-b22d-4b01-8fff-4b02b91fe78d
      palette_id: c36094e3-d04d-4aa4-8ec7-bc9af9f851f4
    show_sql_query_menu_options: false
    pinned_columns:
      product_product.name: left
      current_timestamp: left
      product_productvariant.sku: left
    column_order: [product_productvariant.sku, product_product.name, parent_category.name,
      product_category.name, product_product.metadata, warehouse_stock.sum_stock_quantity,
      product_productimage.cnt_product_images, product_product.is_published, product_productvariant.price_amount,
      product_product.available_for_purchase_date, product_product.updated_time]
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
      product_product.name: 491
      product_product.metadata: 140
      product_product.publication_date: 168
      product_product.slug: 362
      product_product.updated_time: 146
      product_product.is_published: 179
      product_product.visible_in_listings: 207
      product_product.available_for_purchase_date: 204
      product_productvariant.id: 66
      product_productvariant.name: 87
      product_productvariant.metadata: 167
      product_productvariant.price_amount: 120
      product_productvariant.sku: 85
      product_productvariant.sort_order: 110
      warehouse_stock.id: 66
      warehouse_stock.warehouse_id: 263
      warehouse_stock.quantity: 101
      warehouse_warehouse.slug: 164
      product_product.cnt_product_images: 150
      current_timestamp: 154
      product_productimage.cnt_product_images: 106
      parent_category.name: 139
      warehouse_stock.sum_stock_quantity: 178
    series_cell_visualizations:
      product_productimage.cnt_product_images:
        is_active: false
    series_text_format:
      product_product.metadata:
        bold: true
        fg_color: "#D14242"
    conditional_formatting: [{type: equal to, value: !!null '', background_color: "#81BE56",
        font_color: !!null '', color_application: {collection_id: aed851c8-b22d-4b01-8fff-4b02b91fe78d,
          palette_id: a77d2b8b-ee06-4086-8459-cfff9cccb2d2, options: {constraints: {
              min: {type: minimum}, mid: {type: number, value: 0}, max: {type: maximum}},
            mirror: true, reverse: false, stepped: false}}, bold: false, italic: false,
        strikethrough: false, fields: []}]
    defaults_version: 1
    hidden_fields: []
    y_axes: []
    listen:
      Total Inventory: warehouse_stock.sum_stock_quantity
      Category: parent_category.name
      Metadata: product_product.metadata
    row: 0
    col: 0
    width: 24
    height: 15


  filters:
  - name: Total Inventory
    title: Total Inventory
    type: field_filter
    default_value: ">=1"
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
      options: []
    model: flink_realtime
    explore: order_orderline
    listens_to_filters: []
    field: warehouse_stock.sum_stock_quantity
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
  - name: Metadata
    title: Metadata
    type: string_filter
    default_value: '{},"{\"shelf_number\": \"\"}"'
    allow_multiple_values: true
    required: false
    ui_config:
      type: button_group
      display: inline
      options:
      - "{}"
      - '{"shelf_number": ""}'
