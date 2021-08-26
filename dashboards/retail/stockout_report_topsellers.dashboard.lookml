- dashboard: stockout_report_topsellers_ct_migrated
  title: Stockout Report Topsellers (CT migrated)
  layout: newspaper
  preferred_viewer: dashboards-next
  refresh: 2147484 seconds
  elements:
  - title: Stock-Range per top 10 Products and Parent Category
    name: Stock-Range per top 10 Products and Parent Category
    model: flink_v3
    explore: retail_current_inventory
    type: looker_grid
    fields: [top_10_products_per_parent_category.parent_category_name, top_10_products_per_parent_category.rank_per_category_named,
      order_lineitems.pct_stock_range_7d, hubs.hub_code]
    pivots: [hubs.hub_code]
    filters:
      products.is_published: 'Yes'
      top_10_products_per_parent_category.apply_filter: 'Yes'
    sorts: [hubs.hub_code, top_10_products_per_parent_category.parent_category_name
        desc, top_10_products_per_parent_category.rank_per_category_named]
    limit: 500
    column_limit: 50
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
    header_font_size: '10'
    rows_font_size: '9'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    series_labels:
      order_orderline_facts.pct_stock_range_7d: Stock Range
      order_lineitems.pct_stock_range_7d: Stock Range 7d ø
    series_column_widths:
      warehouse_warehouse.name: 356
      order_orderline_facts.pct_stock_range_7d: 75
    series_cell_visualizations:
      order_orderline_facts.pct_stock_range_7d:
        is_active: false
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
    show_null_points: true
    hidden_fields: []
    y_axes: []
    listen:
      Sub-Category Name: products.subcategory
      Product SKU: products.product_sku
      Hub Name: hubs.hub_name
      Country: hubs.country
      City: hubs.city
      Parent Category Name: products.category
    row: 4
    col: 0
    width: 24
    height: 115
  - name: ''
    type: text
    title_text: ''
    body_text: |-
      <h2 style="color:#e21c79"><b> General Idea: </b></h2>
      For each parent category, we want to identify the top 10 in-demand products and show, how long the stock will last

      <span style="color:#919191"> <b>Limitations: </b> Currently, this chart only shows data for Germany </span>
    row: 0
    col: 0
    width: 7
    height: 4
  - name: " (2)"
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: |2-

      <h4 style="color:#e21c79"><b>  How is Top-10 demand defined? </b></h4>
      We use the gross revenue of a product summed up over the last 14 days to rank the top products per Parent Category

      <h4 style="color:#e21c79"><b> How is Stock-Range defined? </b></h4>
      This is an hourly updated chart: We check the current stock of a product and divide it by the average sales of the last 7 days.
    row: 0
    col: 9
    width: 15
    height: 4
  filters:
  - name: Sub-Category Name
    title: Sub-Category Name
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: popover
      options: []
    model: flink_v3
    explore: retail_current_inventory
    listens_to_filters: []
    field: products.subcategory
  - name: Parent Category Name
    title: Parent Category Name
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: popover
      options: []
    model: flink_v3
    explore: retail_current_inventory
    listens_to_filters: []
    field: products.category
  - name: Product SKU
    title: Product SKU
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: popover
      options: []
    model: flink_v3
    explore: retail_current_inventory
    listens_to_filters: []
    field: products.product_sku
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
    explore: retail_current_inventory
    listens_to_filters: []
    field: hubs.hub_name
  - name: Country
    title: Country
    type: field_filter
    default_value: Germany
    allow_multiple_values: true
    required: false
    ui_config:
      type: button_group
      display: inline
      options: []
    model: flink_v3
    explore: retail_current_inventory
    listens_to_filters: []
    field: hubs.country
  - name: City
    title: City
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: popover
      options: []
    model: flink_v3
    explore: retail_current_inventory
    listens_to_filters: []
    field: hubs.city
