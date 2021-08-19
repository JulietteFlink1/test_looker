- dashboard: voucher_dashboard
  title: Voucher Dashboard (CT Migrated)
  layout: newspaper
  preferred_viewer: dashboards-next
  elements:

  - name: Voucher Redemptions
    title: Voucher Redemptions
    model: flink_v3
    explore: orders_discounts
    type: looker_grid
    fields: [
      discounts.discount_code,
      discounts.discount_group,
      discounts.cart_discount_type,
      orders_cl.cnt_orders,
      orders_cl.cnt_unique_orders_new_customers,
      orders_cl.sum_discount_amt,
      orders_cl.avg_order_value_gross,
      discounts.discount_value
      ]
    filters:
      orders_cl.is_successful_order: 'yes'
      orders_cl.is_voucher_order: 'Yes'
    sorts: [orders_cl.cnt_orders desc]
    limit: 5000
    total: true
    dynamic_fields: [{table_calculation: acquisition_share, label: "% Acquisition\
          \ Share", expression: " ${orders_cl.cnt_unique_orders_new_customers} /${orders_cl.cnt_orders}",
        value_format: !!null '', value_format_name: percent_0, _kind_hint: measure,
        _type_hint: number}]
    query_timezone: Europe/Berlin
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
    series_cell_visualizations:
      orders_cl.cnt_orders:
        is_active: true
      acquisition_share:
        is_active: true
        palette:
          palette_id: 56d0c358-10a0-4fd6-aa0b-b117bef527ab
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
    defaults_version: 1
    series_column_widths:
      orders_cl.avg_order_value_gross: 127
      discount_voucher.discount_value: 87
    column_order: [
      "$$$_row_numbers_$$$",
      discounts.discount_code,
      discounts.discount_group,
      discounts.discount_value,
      discounts.cart_discount_type,
      orders_cl.cnt_orders,
      orders_cl.cnt_unique_orders_new_customers,
      orders_cl.avg_order_value_gross,
      orders_cl.sum_discount_amt,
      acquisition_share]
    hidden_fields: []
    y_axes: []
    listen:
      Is Internal Order (Yes / No): orders_cl.is_internal_order
      Hub Name: hubs.hub_name
      Country: hubs.country
      Voucher Code: discounts.discount_code
      Voucher Type: discounts.cart_discount_type
      Voucher Use Case: discounts.use_case
      Order Date (Only applies to the top Look): orders_cl.created_date
    row: 0
    col: 0
    width: 24
    height: 11

  - title: Voucher Retention
    name: Voucher Retention
    model: flink_v3
    explore: voucher_retention
    type: looker_grid
    fields: [
      voucher_retention.discount_code,
      voucher_retention.cnt_base_7,
      voucher_retention.cnt_base_14,
      voucher_retention.cnt_base_30,
      voucher_retention.cnt_7_day_retention,
      voucher_retention.cnt_14_day_retention,
      voucher_retention.cnt_30_day_retention
      ]
    filters: {}
    sorts: [voucher_retention.cnt_base_7 desc]
    limit: 500
    dynamic_fields: [{table_calculation: 7d_reorder_rate, label: 7d Reorder Rate,
        expression: 'if(${voucher_retention.cnt_base_7} > 0, ${voucher_retention.cnt_7_day_retention}
          / ${voucher_retention.cnt_base_7}, null)', value_format: !!null '', value_format_name: percent_0,
        is_disabled: false, _kind_hint: measure, _type_hint: number}, {table_calculation: 14d_reorder_rate,
        label: 14d Reorder Rate, expression: 'if(${voucher_retention.cnt_base_14}
          > 0, ${voucher_retention.cnt_14_day_retention} / ${voucher_retention.cnt_base_14},
          null)', value_format: !!null '', value_format_name: percent_0, _kind_hint: measure,
        _type_hint: number}, {table_calculation: 30d_reorder_rate, label: 30d Reorder
          Rate, expression: 'if(${voucher_retention.cnt_base_30} > 0, ${voucher_retention.cnt_30_day_retention}
          / ${voucher_retention.cnt_base_30}, null)', value_format: !!null '', value_format_name: percent_0,
        _kind_hint: measure, _type_hint: number}]
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
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    series_labels:
      voucher_retention.base_7: 7 day Base
      voucher_retention.cnt_base_7: Cohort size 7d
      voucher_retention.cnt_base_14: Cohort size 14d
      voucher_retention.cnt_base_30: Cohort size 30d
    series_column_widths:
      voucher_retention.cnt_base_7: 107
      voucher_retention.cnt_base_14: 94
      voucher_retention.cnt_base_30: 90
      7d_reorder_rate: 163
      14d_reorder_rate: 178
      30d_reorder_rate: 199
    series_cell_visualizations:
      voucher_retention.cnt_base:
        is_active: true
      voucher_retention.base_7:
        is_active: true
      30d_reorder_rate:
        is_active: true
      14d_reorder_rate:
        is_active: true
      7d_reorder_rate:
        is_active: true
      voucher_retention.cnt_base_7:
        is_active: false
      voucher_retention.cnt_base_14:
        is_active: false
      voucher_retention.cnt_base_30:
        is_active: false
    limit_displayed_rows_values:
      show_hide: show
      first_last: first
      num_rows: '50'
    series_value_format:
      7d_reorder_rate:
        name: percent_0
        format_string: "#,##0%"
        label: Percent (0)
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
    hidden_fields: [voucher_retention.cnt_7_day_retention, voucher_retention.cnt_14_day_retention,
      voucher_retention.cnt_30_day_retention]
    y_axes: []
    listen:
      Hub Name: voucher_retention.hub_name
      Country: voucher_retention.country_name
      Voucher Code: voucher_retention.discount_code
    row: 14
    col: 0
    width: 18
    height: 13
  - name: Voucher Retention (2)
    type: text
    title_text: Voucher Retention
    subtitle_text: ''
    body_text: '### First order with a voucher is considered as the base. Thus, a
      user is only considered in a single voucher cohort depending on their "initial"
      voucher code.'
    row: 11
    col: 0
    width: 24
    height: 3


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
    explore: orders_discounts
    listens_to_filters: []
    field: hubs.country
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
    explore: orders_discounts
    listens_to_filters: []
    field: hubs.hub_name
  - name: Order Date (Only applies to the top Look)
    title: Order Date (Only applies to the top Look)
    type: field_filter
    default_value: 14 day
    allow_multiple_values: true
    required: false
    ui_config:
      type: relative_timeframes
      display: inline
      options: []
    model: flink_v3
    explore: orders_discounts
    listens_to_filters: []
    field: orders_cl.created_date
  - name: Is Internal Order (Yes / No)
    title: Is Internal Order (Yes / No)
    type: field_filter
    default_value: 'No'
    allow_multiple_values: true
    required: false
    ui_config:
      type: radio_buttons
      display: inline
      options: []
    model: flink_v3
    explore: orders_discounts
    listens_to_filters: []
    field: orders_cl.is_internal_order
  - name: Voucher Code
    title: Voucher Code
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
      options: []
    model: flink_v3
    explore: orders_discounts
    listens_to_filters: []
    field: discounts.discount_code
  - name: Voucher Type
    title: Voucher Type
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: button_group
      display: popover
      options: []
    model: flink_v3
    explore: orders_discounts
    listens_to_filters: []
    field: discounts.cart_discount_type
  - name: Voucher Use Case
    title: Voucher Use Case
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: checkboxes
      display: popover
      options: []
    model: flink_v3
    explore: orders_discounts
    listens_to_filters: []
    field: discounts.use_case
