- dashboard: stockout_report
  title: "Stockout Report (CT migrated)"
  layout: newspaper
  preferred_viewer: dashboards-next
  refresh: 5 minutes
  elements:

  - title: Stockout by Hub
    name: Stockout by Hub
    model: flink_v3
    explore: retail_current_inventory
    type: looker_grid
    fields: [
      hubs.hub_name,
      inventory.pct_out_of_stock,
      inventory.pct_with_less_than_five_units_in_stock,
      inventory.quantity,
      inventory.sum_out_of_stock,
      order_lineitems.pct_stock_range_7d
      ]
    filters: {}
    sorts: [inventory.pct_out_of_stock desc]
    limit: 5000
    column_limit: 50
    query_timezone: Europe/Berlin
    show_view_names: false
    show_row_numbers: false
    transpose: false
    truncate_text: false
    hide_totals: false
    hide_row_totals: false
    size_to_fit: false
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    color_application:
      collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    series_column_widths:
      hubs.hub_name: 322
      inventory.pct_out_of_stock: 131
      inventory.pct_with_less_than_five_units_in_stock: 302
      order_lineitems.pct_stock_range_7d: 245
    series_cell_visualizations:
      inventory.pct_out_of_stock:
        is_active: false
        palette:
          palette_id: f0077e50-e03c-4a7e-930c-7321b2267283
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      inventory.pct_with_less_than_five_units_in_stock:
        is_active: false
        palette:
          palette_id: 4a00499b-c0fe-4b15-a304-4083c07ff4c4
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
    series_collapsed:
      hubs.hub_name: true
    series_value_format: {}
    hidden_fields: [inventory.quantity, inventory.sum_out_of_stock]
    series_types: {}
    defaults_version: 1
    column_order: [hubs.hub_name, inventory.pct_out_of_stock, inventory.pct_with_less_than_five_units_in_stock, order_lineitems.pct_stock_range_7d]
    y_axes: []
    listen:
      Filter Top X Products By 7d GMV (only Top X SKUs): top_100_products_by_gmv.filter_top_x_products_by_7d_gmv
      Hub Name: hubs.hub_name
      Category Name: products.category
      Subcategory Name: products.subcategory
      Is Published (Yes / No): products.is_published
      Slug: hubs.hub_code
    row: 132
    col: 1
    width: 23
    height: 23

  - title: "% Stockouts per Parent Category"
    name: "% Stockouts per Parent Category"
    model: flink_v3
    explore: retail_current_inventory
    type: looker_grid
    fields: [
      hubs.hub_name,
      products.category,
      inventory.pct_out_of_stock
      ]
    pivots: [products.category]
    filters: {}
    sorts: [inventory.pct_out_of_stock desc 0, products.category]
    limit: 5000
    column_limit: 50
    row_total: right
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
    color_application:
      collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
    show_sql_query_menu_options: false
    column_order: [hubs.hub_name, "$$$_row_total_$$$_inventory.pct_out_of_stock",
      Alkohol_inventory.pct_out_of_stock, Baby_inventory.pct_out_of_stock,
      Backen_inventory.pct_out_of_stock, 'Brötchen, Brot_inventory.pct_out_of_stock',
      'Eier, Milchprod._inventory.pct_out_of_stock', 'Eis, Tiefkühl_inventory.pct_out_of_stock',
      Event Drinks_inventory.pct_out_of_stock, Event Snacks_inventory.pct_out_of_stock,
      Fertiggerichte_inventory.pct_out_of_stock, Fitness_inventory.pct_out_of_stock,
      Frisch & Fertig_inventory.pct_out_of_stock, Frischfleisch_inventory.pct_out_of_stock,
      Frühstück_inventory.pct_out_of_stock, Getränke_inventory.pct_out_of_stock,
      'Health, Beauty_inventory.pct_out_of_stock', 'Kaffee, Tee, Kakao_inventory.pct_out_of_stock',
      'Käse, Wurst_inventory.pct_out_of_stock', 'Katze, Hund_inventory.pct_out_of_stock',
      Konserven_inventory.pct_out_of_stock, 'Küche, Haushalt_inventory.pct_out_of_stock',
      'Nudeln, Reis, Getreide_inventory.pct_out_of_stock', 'Obst, Gemüse_inventory.pct_out_of_stock',
      'Saucen, Gewürze_inventory.pct_out_of_stock', 'Süß, Salzig_inventory.pct_out_of_stock',
      'Veggie, Vegan_inventory.pct_out_of_stock']
    show_totals: true
    show_row_totals: true
    series_cell_visualizations:
      inventory.pct_out_of_stock:
        is_active: false
        palette:
          palette_id: f0077e50-e03c-4a7e-930c-7321b2267283
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
    series_collapsed:
      hubs.hub_name: true
    series_value_format: {}
    hidden_fields: []
    series_types: {}
    defaults_version: 1
    y_axes: []
    listen:
      Filter Top X Products By 7d GMV (only Top X SKUs): top_100_products_by_gmv.filter_top_x_products_by_7d_gmv
      Hub Name: hubs.hub_name
      Category Name: products.category
      Subcategory Name: products.subcategory
      Is Published (Yes / No): products.is_published
      Slug: hubs.hub_code
    row: 0
    col: 0
    width: 24
    height: 30


  - title: "% Stockouts per Sub-Category (or Substitute Group for Fruits and Vegetables)"
    name: "% Stockouts per Sub-Category (or Substitute Group for Fruits and Vegetables)"
    model: flink_v3
    explore: retail_current_inventory
    type: looker_grid
    fields: [hubs.hub_name, inventory.pct_out_of_stock, products.category,
      products.subcategory]
    pivots: [products.category, products.subcategory]
    filters: {}
    sorts: [inventory.pct_out_of_stock desc 0, products.category, products.subcategory]
    limit: 5000
    column_limit: 1000
    row_total: right
    dynamic_fields: [{dimension: sub_group_substitutes, _kind_hint: dimension, _type_hint: string,
        category: dimension, expression: "if(${products.subcategory} = \"Früchte\"\
          \ OR ${products.subcategory} = \"Gemüse\"\n  \n  ,${product_attribute_facts.substitute_group}\n\
          \  ,${products.subcategory}\n  )", label: Sub-Group + Substitutes, value_format: !!null '',
        value_format_name: !!null ''}]
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
    color_application:
      collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
    show_sql_query_menu_options: false
    column_order: [hubs.hub_name, "$$$_row_total_$$$_inventory.pct_out_of_stock",
      Alkohol_inventory.pct_out_of_stock, Baby_inventory.pct_out_of_stock,
      Backen_inventory.pct_out_of_stock, 'Brötchen, Brot_inventory.pct_out_of_stock',
      'Eier, Milchprod._inventory.pct_out_of_stock', 'Eis, Tiefkühl_inventory.pct_out_of_stock',
      Event Drinks_inventory.pct_out_of_stock, Event Snacks_inventory.pct_out_of_stock,
      Fertiggerichte_inventory.pct_out_of_stock, Fitness_inventory.pct_out_of_stock,
      Frisch & Fertig_inventory.pct_out_of_stock, Frischfleisch_inventory.pct_out_of_stock,
      Frühstück_inventory.pct_out_of_stock, Getränke_inventory.pct_out_of_stock,
      'Health, Beauty_inventory.pct_out_of_stock', 'Kaffee, Tee, Kakao_inventory.pct_out_of_stock',
      'Käse, Wurst_inventory.pct_out_of_stock', 'Katze, Hund_inventory.pct_out_of_stock',
      Konserven_inventory.pct_out_of_stock, 'Küche, Haushalt_inventory.pct_out_of_stock',
      'Nudeln, Reis, Getreide_inventory.pct_out_of_stock', 'Obst, Gemüse_inventory.pct_out_of_stock',
      'Saucen, Gewürze_inventory.pct_out_of_stock', 'Süß, Salzig_inventory.pct_out_of_stock',
      'Veggie, Vegan_inventory.pct_out_of_stock']
    show_totals: true
    show_row_totals: true
    series_cell_visualizations:
      inventory.pct_out_of_stock:
        is_active: false
        palette:
          palette_id: f0077e50-e03c-4a7e-930c-7321b2267283
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
    series_collapsed:
      hubs.hub_name: true
    series_value_format: {}
    hidden_fields: []
    series_types: {}
    defaults_version: 1
    y_axes: []
    listen:
      Filter Top X Products By 7d GMV (only Top X SKUs): top_100_products_by_gmv.filter_top_x_products_by_7d_gmv
      Hub Name: hubs.hub_name
      Category Name: products.category
      Subcategory Name: products.subcategory
      Is Published (Yes / No): products.is_published
      Slug: hubs.hub_code
    row: 30
    col: 0
    width: 24
    height: 30

  - title: Stock Range (ø 7d) per Parent Category
    name: Stock Range (ø 7d) per Parent Category
    model: flink_v3
    explore: retail_current_inventory
    type: looker_grid
    fields: [hubs.hub_name, products.category, order_lineitems.pct_stock_range_7d]
    pivots: [products.category]
    filters: {}
    sorts: [products.category, order_lineitems.pct_stock_range_7d desc 0]
    limit: 5000
    column_limit: 50
    row_total: right
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
    color_application:
      collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
    show_sql_query_menu_options: false
    column_order: [hubs.hub_name, "$$$_row_total_$$$_inventory.pct_out_of_stock",
      Alkohol_inventory.pct_out_of_stock, Baby_inventory.pct_out_of_stock,
      Backen_inventory.pct_out_of_stock, 'Brötchen, Brot_inventory.pct_out_of_stock',
      'Eier, Milchprod._inventory.pct_out_of_stock', 'Eis, Tiefkühl_inventory.pct_out_of_stock',
      Event Drinks_inventory.pct_out_of_stock, Event Snacks_inventory.pct_out_of_stock,
      Fertiggerichte_inventory.pct_out_of_stock, Fitness_inventory.pct_out_of_stock,
      Frisch & Fertig_inventory.pct_out_of_stock, Frischfleisch_inventory.pct_out_of_stock,
      Frühstück_inventory.pct_out_of_stock, Getränke_inventory.pct_out_of_stock,
      'Health, Beauty_inventory.pct_out_of_stock', 'Kaffee, Tee, Kakao_inventory.pct_out_of_stock',
      'Käse, Wurst_inventory.pct_out_of_stock', 'Katze, Hund_inventory.pct_out_of_stock',
      Konserven_inventory.pct_out_of_stock, 'Küche, Haushalt_inventory.pct_out_of_stock',
      'Nudeln, Reis, Getreide_inventory.pct_out_of_stock', 'Obst, Gemüse_inventory.pct_out_of_stock',
      'Saucen, Gewürze_inventory.pct_out_of_stock', 'Süß, Salzig_inventory.pct_out_of_stock',
      'Veggie, Vegan_inventory.pct_out_of_stock']
    show_totals: true
    show_row_totals: true
    series_labels:
      order_lineitems.pct_stock_range_7d: Stock Range 7d  AVG
    series_column_widths:
      hubs.hub_name: 354
      inventory.pct_out_of_stock: 131
      order_lineitems.pct_stock_range_7d: 165
    series_cell_visualizations:
      inventory.pct_out_of_stock:
        is_active: false
        palette:
          palette_id: f0077e50-e03c-4a7e-930c-7321b2267283
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      order_lineitems.pct_stock_range_7d:
        is_active: true
    series_collapsed:
      hubs.hub_name: true
    series_value_format: {}
    hidden_fields: []
    series_types: {}
    defaults_version: 1
    y_axes: []
    listen:
      Filter Top X Products By 7d GMV (only Top X SKUs): top_100_products_by_gmv.filter_top_x_products_by_7d_gmv
      Hub Name: hubs.hub_name
      Category Name: products.category
      Subcategory Name: products.subcategory
      Is Published (Yes / No): products.is_published
      Slug: hubs.hub_code
    row: 103
    col: 0
    width: 24
    height: 29


  - title: 7-Day Stock Range per Top X Products (as filtered)
    name: 7-Day Stock Range per Top X Products (as filtered)
    model: flink_v3
    explore: retail_current_inventory
    type: looker_grid
    fields: [hubs.hub_name,
    top_100_products_by_gmv.ranked_brand_with_tail,
      order_lineitems.pct_stock_range_7d]
    pivots: [top_100_products_by_gmv.ranked_brand_with_tail]
    filters: {}
    sorts: [top_100_products_by_gmv.ranked_brand_with_tail, order_lineitems.pct_stock_range_7d
        desc 0]
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
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    series_labels:
      order_lineitems.pct_stock_range_7d: _
    series_column_widths:
      hubs.hub_name: 356
      order_lineitems.pct_stock_range_7d: 75
    series_cell_visualizations:
      order_lineitems.pct_stock_range_7d:
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
    hidden_fields: []
    y_axes: []
    listen:
      Filter Top X Products By 7d GMV (only Top X SKUs): top_100_products_by_gmv.filter_top_x_products_by_7d_gmv
      Hub Name: hubs.hub_name
      Category Name: products.category
      Subcategory Name: products.subcategory
      Is Published (Yes / No): products.is_published
      Slug: hubs.hub_code
    row: 60
    col: 0
    width: 24
    height: 43


  filters:
  - name: Hub Name
    title: Hub Name
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
      options: []
    model: flink_v3
    explore: retail_current_inventory
    listens_to_filters: []
    field: hubs.hub_name

  - name: Category Name
    title: Category Name
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
      options: []
    model: flink_v3
    explore: retail_current_inventory
    listens_to_filters: []
    field: products.category

  - name: Subcategory Name
    title: Subcategory Name
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

  - name: Is Published (Yes / No)
    title: Is Published (Yes / No)
    type: field_filter
    default_value: 'Yes'
    allow_multiple_values: true
    required: false
    ui_config:
      type: button_toggles
      display: inline
      options: []
    model: flink_v3
    explore: retail_current_inventory
    listens_to_filters: []
    field: products.is_published

  - name: Filter Top X Products By 7d GMV (only Top X SKUs)
    title: Filter Top X Products By 7d GMV (only Top X SKUs)
    type: field_filter
    default_value: "<=30"
    allow_multiple_values: true
    required: true
    ui_config:
      type: advanced
      display: inline
      options: []
    model: flink_v3
    explore: retail_current_inventory
    listens_to_filters: []
    field: top_100_products_by_gmv.filter_top_x_products_by_7d_gmv

  - name: Slug
    title: Slug
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
      options: []
    model: flink_v3
    explore: retail_current_inventory
    listens_to_filters: []
    field: hubs.hub_code
