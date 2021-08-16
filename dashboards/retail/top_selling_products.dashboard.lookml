- dashboard: top_selling_products
  title: Top Selling Products
  layout: newspaper
  preferred_viewer: dashboards-next
  elements:
  - name: Top 200 products by quantity
    title: Top 200 products by quantity
    model: flink_v3
    explore: order_orderline_cl
    type: looker_grid
    fields: [products.product_name, orderline.sum_item_quantity, orderline.sum_item_price_gross]
    filters:
      orders_cl.is_internal_order: 'no'
      orders_cl.is_successful_order: 'yes'
    sorts: [orderline.sum_item_quantity desc]
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
    limit_displayed_rows: true
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    series_column_widths:
      products.product_name: 250
      orderline.sum_item_quantity: 200
      orderline.sum_item_price_gross: 200
      parent_category.name: 175
    series_cell_visualizations:
      orderline.sum_item_quantity:
        is_active: true
      orderline.sum_item_price_gross:
        is_active: true
    limit_displayed_rows_values:
      show_hide: show
      first_last: first
      num_rows: '200'
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
    series_types: {}
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
    hidden_fields: []
    y_axes: []
    listen:
      Country: hubs.country
      City: hubs.city
      Hub Name: hubs.hub_name
      Order Date: orders_cl.created_date
    row: 2
    col: 0
    width: 10
    height: 22
  - title: Top 200 products by GMV
    name: Top 200 products by GMV
    model: flink_v3
    explore: order_orderline_cl
    type: looker_grid
    fields: [products.product_name, orderline.sum_item_quantity, orderline.sum_item_price_gross]
    filters:
      orders_cl.is_internal_order: 'no'
      orders_cl.is_successful_order: 'yes'
    sorts: [orderline.sum_item_price_gross desc]
    limit: 500
    column_limit: 50
    query_timezone: Europe/Berlin
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: true
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    series_column_widths:
      products.product_name: 250
      orderline.sum_item_quantity: 200
      orderline.sum_item_price_gross: 200
      parent_category.name: 175
    series_cell_visualizations:
      orderline.sum_item_quantity:
        is_active: true
      orderline.sum_item_price_gross:
        is_active: true
    limit_displayed_rows_values:
      show_hide: show
      first_last: first
      num_rows: '200'
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
    series_types: {}
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
    hidden_fields: []
    y_axes: []
    listen:
      Country: hubs.country
      City: hubs.city
      Hub Name: hubs.hub_name
      Order Date: orders_cl.created_date
    row: 2
    col: 10
    width: 10
    height: 22
  - title: Top 200 substitute groups by quantity
    name: Top 200 substitute groups by quantity
    model: flink_v3
    explore: order_orderline_cl
    type: looker_grid
    fields: [orderline.sum_item_quantity, orderline.sum_item_price_gross,
      substitute_groups_or_product_name]
    filters:
      orders_cl.is_internal_order: 'no'
      orders_cl.is_successful_order: 'yes'
      products.substitute_group: ''
    sorts: [orderline.sum_item_quantity desc]
    limit: 500
    column_limit: 50
    dynamic_fields: [{_kind_hint: dimension, table_calculation: substitute_group_complete,
        _type_hint: string, category: table_calculation, expression: 'coalesce(${products.substitute_group},
          ${products.product_name})', label: Substitute Group Complete, value_format: !!null '',
        value_format_name: !!null '', is_disabled: true}, {dimension: substitute_groups_or_product_name,
        _kind_hint: dimension, _type_hint: string, category: dimension, expression: 'coalesce(${products.substitute_group},${products.product_name})',
        label: Substitute Groups (or Product Name), value_format: !!null '', value_format_name: !!null ''}]
    query_timezone: Europe/Berlin
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: true
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    series_column_widths:
      products.product_name: 225
      orderline.sum_item_quantity: 200
      orderline.sum_item_price_gross: 200
      parent_category.name: 175
      substitute_group_complete: 251
      product_attribute_facts.substitue_group_complete: 250
    series_cell_visualizations:
      orderline.sum_item_quantity:
        is_active: true
      orderline.sum_item_price_gross:
        is_active: true
    limit_displayed_rows_values:
      show_hide: show
      first_last: first
      num_rows: '200'
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
    series_types: {}
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
    hidden_fields: []
    y_axes: []
    listen:
      Country: hubs.country
      City: hubs.city
      Hub Name: hubs.hub_name
      Order Date: orders_cl.created_date
    row: 26
    col: 0
    width: 10
    height: 22
  - title: Top 200 substitute groups by GMV
    name: Top 200 substitute groups by GMV
    model: flink_v3
    explore: order_orderline_cl
    type: looker_grid
    fields: [orderline.sum_item_quantity, orderline.sum_item_price_gross,
      substitue_groups_or_product_name]
    filters:
      orders_cl.is_internal_order: 'no'
      orders_cl.is_successful_order: 'yes'
    sorts: [orderline.sum_item_price_gross desc]
    limit: 500
    column_limit: 50
    dynamic_fields: [{dimension: substitue_groups_or_product_name, _kind_hint: dimension,
        _type_hint: string, category: dimension, expression: 'coalesce(${products.substitute_group},${products.product_name})',
        label: Substitue Groups (or Product Name), value_format: !!null '', value_format_name: !!null ''}]
    query_timezone: Europe/Berlin
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: true
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    series_column_widths:
      products.product_name: 170
      orderline.sum_item_quantity: 200
      orderline.sum_item_price_gross: 200
      parent_category.name: 175
      product_attribute_facts.substitue_group_complete: 250
    series_cell_visualizations:
      orderline.sum_item_quantity:
        is_active: true
      orderline.sum_item_price_gross:
        is_active: true
    limit_displayed_rows_values:
      show_hide: show
      first_last: first
      num_rows: '200'
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
    series_types: {}
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
    hidden_fields: []
    y_axes: []
    listen:
      Country: hubs.country
      City: hubs.city
      Hub Name: hubs.hub_name
      Order Date: orders_cl.created_date
    row: 26
    col: 10
    width: 10
    height: 22
  - name: Ranking of SKUs
    type: text
    title_text: Ranking of SKUs
    subtitle_text: ''
    body_text: ''
    row: 0
    col: 0
    width: 22
    height: 2
  - name: Ranking of Substitute Groups
    type: text
    title_text: Ranking of Substitute Groups
    subtitle_text: if no substitute group is assigned, then SKU name is shown instead
    body_text: ''
    row: 24
    col: 0
    width: 22
    height: 2
  filters:
  - name: Country
    title: Country
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: button_group
      display: inline
      options: []
    model: flink_v3
    explore: order_orderline_cl
    listens_to_filters: []
    field: hubs.country
  - name: City
    title: City
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: checkboxes
      display: popover
      options: []
    model: flink_v3
    explore: order_orderline_cl
    listens_to_filters: []
    field: hubs.city
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
    explore: order_orderline_cl
    listens_to_filters: []
    field: hubs.hub_name
  - name: Order Date
    title: Order Date
    type: field_filter
    default_value: yesterday
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
