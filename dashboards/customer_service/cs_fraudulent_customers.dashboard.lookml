- dashboard: fraudulent_customers_cs_contact
  title: Fraudulent Customers (CS Contact)
  layout: newspaper
  preferred_viewer: dashboards-next
  elements:

  - title: Customers with the highest Contact Rate
    name: Customers with the highest Contact Rate
    model: flink_v3
    explore: orders_cl
    type: looker_grid
    fields: [orders_cl.user_email, cs_post_delivery_issues.total_issues_from_parameter,
      cs_post_delivery_issues.unique_orders_wih_issue_from_parameter, orders_cl.cnt_orders,
      orders_cl.cnt_unique_hubs, cs_post_delivery_issues.pct_total_issues_from_parameter]
    filters:
      orders_cl.is_internal_order: 'no'
      orders_cl.is_successful_order: 'yes'
      orders_cl.created_date: after 2021/01/25
      hubs.hub_name: ''
      hubs.country: ''
      orders_cl.cnt_orders: ">=3"
    sorts: [cs_post_delivery_issues.pct_total_issues_from_parameter desc]
    limit: 1000
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
    series_cell_visualizations:
      cs_post_delivery_issues.cnt_issues:
        is_active: false
    conditional_formatting: [{type: along a scale..., value: !!null '', background_color: "#c76b4e",
        font_color: !!null '', color_application: {collection_id: product-custom-collection,
          custom: {id: 5d9bc895-6713-ff3f-5ea8-5ec81f0cb64d, label: Custom, type: continuous,
            stops: [{color: "#ffffff", offset: 0}, {color: "#e0a5a0", offset: 33.333333333333336},
              {color: "#ff3c43", offset: 66.66666666666667}, {color: "#ff3c43", offset: 100}]},
          options: {steps: 8, stepped: true}}, bold: false, italic: false, strikethrough: false,
        fields: [cs_post_delivery_issues.pct_total_issues_from_parameter]}]
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
      Problem Group: cs_post_delivery_issues.problem_group_parameter
      "# Unique Orders with Post-Delivery Issue": cs_post_delivery_issues.cnt_unique_orders
    row: 14
    col: 0
    width: 24
    height: 16
  - title: New Tile
    name: New Tile
    model: flink_v3
    explore: cs_fraudulent_customers_email
    type: looker_grid
    fields: [orders_cl.user_email, cs_post_delivery_issues.total_issues_from_parameter,
      cs_post_delivery_issues.unique_orders_wih_issue_from_parameter, orders_cl.cnt_orders,
      orders_cl.cnt_unique_hubs, cs_post_delivery_issues.pct_total_issues_from_parameter,
      products.sum_amt_product_price_gross, orders_cl.sum_gmv_gross]
    filters:
      orders_cl.is_successful_order: 'yes'
      orders_cl.created_date: after 2021/01/25
      hubs.country: ''
      hubs.hub_name: ''
      cs_post_delivery_issues.problem_group_parameter: all
      cs_post_delivery_issues.cnt_unique_orders: ">=2"
      orders_cl.cnt_orders: ">=3"
    sorts: [cs_post_delivery_issues.pct_total_issues_from_parameter desc]
    limit: 500
    column_limit: 50
    dynamic_fields: [{category: table_calculation, expression: "${products.sum_amt_product_price_gross}",
        label: Claimed Value, value_format: !!null '', value_format_name: eur, _kind_hint: measure,
        table_calculation: claimed_value, _type_hint: number}, {category: table_calculation,
        expression: "${products.sum_amt_product_price_gross}/${orders_cl.sum_gmv_gross}",
        label: "% Claimed Value", value_format: !!null '', value_format_name: percent_0,
        _kind_hint: measure, table_calculation: claimed_value_1, _type_hint: number}]
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
    series_cell_visualizations:
      cs_post_delivery_issues.total_issues_from_parameter:
        is_active: false
    conditional_formatting: [{type: along a scale..., value: !!null '', background_color: "#c76b4e",
        font_color: !!null '', color_application: {collection_id: product-custom-collection,
          custom: {id: b84e5def-062d-1681-1044-d75c6c093ef4, label: Custom, type: continuous,
            stops: [{color: "#ffffff", offset: 0}, {color: "#fab8b5", offset: 33.333333333333336},
              {color: "#d6635e", offset: 66.66666666666667}, {color: "#bf2f28", offset: 100}]},
          options: {steps: 5, constraints: {min: {type: number, value: 0}, mid: {
                type: average}, max: {type: maximum}}, mirror: false, reverse: false,
            stepped: false}}, bold: false, italic: false, strikethrough: false, fields: [
          cs_post_delivery_issues.pct_total_issues_from_parameter]}]
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
    hidden_fields: [products.sum_amt_product_price_gross]
    row:
    col:
    width:
    height:
  filters:
  - name: "# Orders"
    title: "# Orders"
    type: field_filter
    default_value: ">=3"
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
      options: []
    model: flink_v3
    explore: orders_cl
    listens_to_filters: []
    field: orders_cl.cnt_orders
  - name: "# Unique Orders with Post-Delivery Issue"
    title: "# Unique Orders with Post-Delivery Issue"
    type: field_filter
    default_value: ">=2"
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: inline
      options: []
    model: flink_v3
    explore: orders_cl
    listens_to_filters: []
    field: cs_post_delivery_issues.cnt_unique_orders
  - name: Problem Group
    title: Problem Group
    type: field_filter
    default_value: all
    allow_multiple_values: true
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
      options: []
    model: flink_v3
    explore: orders_cl
    listens_to_filters: []
    field: cs_post_delivery_issues.problem_group_parameter
