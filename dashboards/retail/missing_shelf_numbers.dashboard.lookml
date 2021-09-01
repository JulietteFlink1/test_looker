- dashboard: missing_shelf_numbers
  title: Missing Shelf Numbers (CT Migrated)
  layout: newspaper
  preferred_viewer: dashboards-next
  refresh: 2147484 seconds
  elements:
  - title: Missing Shelf Numbers
    name: Missing Shelf Numbers
    model: flink_v3
    explore: current_inventory
    type: looker_grid
    fields: [products.subcategory, products.product_name, products.product_shelf_no,
      products.meta_description, products.last_modified_time, products.is_published,
      inventory.created_date, products.amt_product_price_gross, products.product_sku,
      products.category, products.cnt_product_images, inventory.avg_quantity_available]
    filters:
      products.is_published: ''
    sorts: [inventory.avg_quantity_available desc]
    limit: 1000
    column_limit: 50
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
      products.product_name: left
      current_timestamp: left
      products.product_sku: left
    column_order: [products.product_sku, products.product_name, products.category,
      products.subcategory, products.meta_description, inventory.avg_quantity_available,
      products.cnt_product_images, products.is_published, products.amt_product_price_gross,
      inventory.created_date, products.last_modified_time]
    show_totals: true
    show_row_totals: true
    series_labels:
      products.category: Category
      products.subcategory: Sub_Category
      products.cnt_product_images: "# Images"
      inventory.avg_quantity_available: Total Inventory (#)
      products.meta_description: Shelf
      products.amt_product_price_gross: Price p. unit
    series_column_widths:
      products.subcategory: 146
      products.product_name: 491
      products.meta_description: 140
      products.last_modified_time: 146
      products.is_published: 179
      inventory.created_date: 204
      products.amt_product_price_gross: 120
      products.product_sku: 85
      products.cnt_product_images: 106
      current_timestamp: 154
      products.category: 139
      inventory.avg_quantity_available: 178
    series_cell_visualizations:
      products.cnt_product_images:
        is_active: false
    series_text_format:
      products.meta_description:
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
      Total Inventory: inventory.avg_quantity_available
      Category: products.category
      Product Shelf No: products.product_shelf_no
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
    model: flink_v3
    explore: current_inventory
    listens_to_filters: []
    field: inventory.avg_quantity_available
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
    model: flink_v3
    explore: current_inventory
    listens_to_filters: []
    field: products.category
  - name: Product Shelf No
    title: Product Shelf No
    type: field_filter
    default_value: 'NULL'
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
      options: []
    model: flink_v3
    explore: current_inventory
    listens_to_filters: []
    field: products.product_shelf_no
