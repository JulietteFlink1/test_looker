- dashboard: noos_with_0_inventory
  title: NooS with 0 Inventory (CT migrated)
  layout: newspaper
  preferred_viewer: dashboards-next
  elements:
  - title: NooS with 0 Inventory
    name: NooS with 0 Inventory
    model: flink_v3
    explore: current_inventory_updated_hourly
    type: looker_grid
    fields: [hubs.hub_name, inventory.sum_stock_quantity, products.substitute_group]
    pivots: [products.substitute_group]
    filters:
      hubs.country: Germany
      inventory.sum_stock_quantity: '0'
      inventory.is_most_recent_record: 'Yes'
    sorts: [products.substitute_group, inventory.sum_stock_quantity desc 17]
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
    enable_conditional_formatting: true
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    series_labels:
      inventory.sum_stock_quantity: "#"
    series_cell_visualizations:
      inventory.sum_stock_quantity:
        is_active: false
    conditional_formatting: [{type: equal to, value: 0, background_color: "#fa1c25",
        font_color: "#ffffff", color_application: {collection_id: product-custom-collection,
          palette_id: product-custom-collection-diverging-0, options: {constraints: {
              min: {type: minimum}, mid: {type: number, value: 0}, max: {type: maximum}},
            mirror: true, reverse: false, stepped: false}}, bold: true, italic: false,
        strikethrough: false, fields: !!null ''}]
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
    listen:
      Hub Name: hubs.hub_name
      Substitute Group: products.substitute_group
      Is Noos Group (Yes / No): products.is_noos_group
    row: 0
    col: 0
    width: 24
    height: 39
  filters:
  - name: Hub Name
    title: Hub Name
    type: field_filter
    default_value: ''
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
  - name: Substitute Group
    title: Substitute Group
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: popover
      options: []
    model: flink_v3
    explore: current_inventory_updated_hourly
    listens_to_filters: []
    field: products.substitute_group
  - name: Is Noos Group (Yes / No)
    title: Is Noos Group (Yes / No)
    type: field_filter
    default_value: 'Yes'
    allow_multiple_values: true
    required: false
    ui_config:
      type: button_toggles
      display: inline
      options: []
    model: flink_v3
    explore: current_inventory_updated_hourly
    listens_to_filters: []
    field: products.is_noos_group
