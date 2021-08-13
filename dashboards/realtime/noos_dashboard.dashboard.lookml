- dashboard: noos_dashboard
  title: NOOS Dashboard
  layout: newspaper
  preferred_viewer: dashboards-next
  refresh: 1 hour
  elements:
  - title: NOOS - Substitute Groups (Group levels)
    name: NOOS - Substitute Groups (Group levels)
    model: flink_v3
    explore: current_inventory_updated_hourly
    type: looker_grid
    fields: [products.substitute_group, inventory.sum_stock_quantity,
      order_lineitems.sum_item_quantity_last_7d, order_lineitems.pct_stock_range_7d]
    filters:
      products.is_noos_group: 'Yes'
      products.substitute_group: ''
      hubs.hub_name: ''
      orders.is_successful_order: 'Yes'
      orders.is_internal_order: 'No'
    sorts: [order_lineitems.pct_stock_range_7d]
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
    series_cell_visualizations:
      inventory.sum_stock_quantity:
        is_active: true
        value_display: true
        palette:
          palette_id: c9a156ab-37d5-7750-d083-0a5d718d852d
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
          custom_colors:
          - "#9e9c9c"
          - "#9e9c9c"
      inventory.sum_stock_quantity_per_substitute_group:
        is_active: true
      order_lineitems.sum_item_quantity_last_7d:
        is_active: false
      order_lineitems.pct_stock_range_7d:
        is_active: true
        palette:
          palette_id: ee325299-f19d-7037-cfca-91a003fa7a7b
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
          custom_colors:
          - "#b21416"
          - "#31e621"
    defaults_version: 1
    hidden_fields: []
    y_axes: []
    listen:
      Hub: hubs.hub_name
    row: 0
    col: 0
    width: 15
    height: 19
  - title: NOOS - Substitute Groups (Group constituents)
    name: NOOS - Substitute Groups (Group constituents)
    model: flink_v3
    explore: current_inventory_updated_hourly
    type: looker_grid
    fields: [products.product_sku, products.substitute_group,
      products.product_name]
    filters:
      products.is_leading_product: ''
      products.is_noos_group: 'Yes'
      products.substitute_group: ''
      hubs.hub_name: ''
    sorts: [products.substitute_group]
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
    series_cell_visualizations:
      inventory.sum_stock_quantity:
        is_active: true
      inventory.sum_stock_quantity_per_substitute_group:
        is_active: true
      order_lineitems.sum_item_quantity_last_7d:
        is_active: true
    defaults_version: 1
    column_order: ["$$$_row_numbers_$$$",
      products.substitute_group,
      products.product_sku,
      products.product_name,
      inventory.sum_stock_quantity,
      inventory.sum_stock_quantity_per_substitute_group,
      order_lineitems.sum_item_quantity_last_7d]
    hidden_fields: []
    y_axes: []
    listen: {}
    row: 19
    col: 0
    width: 15
    height: 43
  filters:
  - name: Hub
    title: Hub
    type: field_filter
    default_value: '"de_ber_char"'
    allow_multiple_values: true
    required: true
    ui_config:
      type: dropdown_menu
      display: popover
      options: []
    model: flink_v3
    explore: current_inventory_updated_hourly
    listens_to_filters: []
    field: hubs.hub_name
