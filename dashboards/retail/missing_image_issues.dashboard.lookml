- dashboard: missing_image_issues
  title: "[In Progress] Missing Image Issues (CT Migrated)"
  layout: newspaper
  preferred_viewer: dashboards-next
  refresh: 1 hour
  elements:

  - title: SKUs w/o images
    name: SKUs w/o images
    model: flink_v3
    explore: current_inventory
    type: looker_grid
    fields: [
      products.subcategory,
      products.product_name,
      products.meta_description,
      products.last_modified_time,
      products.is_published,
      inventory.created_date,
      products.amt_product_price_gross,
      products.product_sku,
      products.cnt_product_images,
      products.category,
      inventory.avg_quantity_available]
    filters:
      products.category: ''
    sorts: [inventory.avg_quantity_available desc]
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
      products.product_name: left
      current_timestamp: left
      products.product_sku: left
    column_order: [products.product_sku, products.product_name, products.category,
      products.subcategory, products.is_published, inventory.avg_quantity_available,
      products.cnt_product_images, products.amt_product_price_gross,
      products.meta_description, products.last_modified_time, inventory.created_date]
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
      hubs.hub_name: 255
      product_product.category_id: 118
      products.subcategory: 146
      products.product_name: 372
      products.meta_description: 168
      products.last_modified_time: 147
      products.is_published: 178
      inventory.created_date: 204
      products.amt_product_price_gross: 128
      products.product_sku: 102
      current_timestamp: 154
      products.cnt_product_images: 130
      products.category: 117
      inventory.avg_quantity_available: 169
    series_cell_visualizations:
      products.cnt_product_images:
        is_active: true
    defaults_version: 1
    hidden_fields: []
    y_axes: []
    listen:
      Is Published (Yes / No): products.is_published
      Product Images (#): products.cnt_product_images
      SUM Stock Quantity: inventory.avg_quantity_available
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
    model: flink_v3
    explore: current_inventory
    listens_to_filters: []
    field: products.category

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
    model: flink_v3
    explore: current_inventory
    listens_to_filters: []
    field: products.cnt_product_images

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
    model: flink_v3
    explore: current_inventory
    listens_to_filters: []
    field: products.is_published

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
    model: flink_v3
    explore: current_inventory
    listens_to_filters: []
    field: inventory.avg_quantity_available
