- dashboard: weekly_cohorts_ct_migrated
  title: Weekly Cohorts (CT Migrated)
  layout: newspaper
  preferred_viewer: dashboards-next
  elements:
  - title: Weekly Cohorts (Customer Retention)
    name: Weekly Cohorts (Customer Retention)
    model: flink_v3
    explore: orders_customers
    type: looker_grid
    fields: [customers_metrics.first_order_week, orders_cl.cnt_unique_customers, customers_metrics.weeks_time_since_sign_up]
    pivots: [customers_metrics.weeks_time_since_sign_up]
    fill_fields: [customers_metrics.first_order_week]
    filters:
      orders_cl.is_internal_order: 'no'
      orders_cl.is_successful_order: 'yes'
      orders_cl.created_date: after 2020/01/25
      customers_metrics.first_order_week: after 2021/01/25
      hubs.country: ''
      hubs.hub_name: ''
    sorts: [customers_metrics.first_order_week, order_cl.weeks_time_since_sign_up]
    limit: 500
    column_limit: 50
    total: true
    dynamic_fields: [{table_calculation: pcnt_of_cohort_still_active, label: Pcnt
          of Cohort still Active, expression: "${orders_cl.cnt_unique_customers}/pivot_index(${orders_cl.cnt_unique_customers},1)",
        value_format: !!null '', value_format_name: percent_1, _kind_hint: measure,
        _type_hint: number}, {table_calculation: cohort_size, label: Cohort Size,
        expression: 'max(pivot_row(${orders_cl.cnt_unique_customers}))', value_format: !!null '',
        value_format_name: !!null '', _kind_hint: supermeasure, _type_hint: number}]
    show_view_names: true
    show_row_numbers: false
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: editable
    limit_displayed_rows: false
    enable_conditional_formatting: true
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    column_order: [customers_metrics.first_order_week, cohort_size, 0_pcnt_of_cohort_still_active,
      1_pcnt_of_cohort_still_active, 2_pcnt_of_cohort_still_active, 3_pcnt_of_cohort_still_active,
      4_pcnt_of_cohort_still_active, 5_pcnt_of_cohort_still_active, 6_pcnt_of_cohort_still_active,
      7_pcnt_of_cohort_still_active, 8_pcnt_of_cohort_still_active, 9_pcnt_of_cohort_still_active,
      10_pcnt_of_cohort_still_active, 11_pcnt_of_cohort_still_active, 12_pcnt_of_cohort_still_active,
      13_pcnt_of_cohort_still_active]
    show_totals: true
    show_row_totals: true
    series_column_widths:
      user_order_facts.first_order_week: 196
      pcnt_of_cohort_still_active: 82
      weekly_cohorts_stable_base.cnt_unique_customers: 137
      cohort_size: 90
    series_cell_visualizations:
      pcnt_of_cohort_still_active:
        is_active: false
        value_display: true
        palette:
          palette_id: 56d0c358-10a0-4fd6-aa0b-b117bef527ab
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
    series_text_format:
      pcnt_of_cohort_still_active: {}
    conditional_formatting: [{type: along a scale..., value: !!null '', background_color: "#1A73E8",
        font_color: !!null '', color_application: {collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2,
          palette_id: 56d0c358-10a0-4fd6-aa0b-b117bef527ab}, bold: false, italic: false,
        strikethrough: false, fields: [pcnt_of_cohort_still_active]}]
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
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    series_types: {}
    hidden_fields: [orders_cl.cnt_unique_customers]
    y_axes: []
    listen:
      Hub Name: customers_metrics.first_order_hub
      Voucher Code: customers_metrics.first_order_discount_code
      City: customers_metrics.first_order_city
      Country: customers_metrics.country
      Is Voucher Order (Yes / No): customers_metrics.is_discount_acquisition
    row: 2
    col: 0
    width: 24
    height: 9
  - title: Weekly Cohorts (Order Frequency)
    name: Weekly Cohorts (Order Frequency)
    model: flink_v3
    explore: orders_customers
    type: looker_grid
    fields: [customers_metrics.first_order_week, customers_metrics.weeks_time_since_sign_up,
      orders_cl.cnt_unique_customers, orders_cl.cnt_orders]
    pivots: [customers_metrics.weeks_time_since_sign_up]
    fill_fields: [customers_metrics.first_order_week]
    filters:
      orders_cl.is_internal_order: 'no'
      orders_cl.is_successful_order: 'yes'
      orders_cl.created_date: after 2020/01/25
      customers_metrics.first_order_week: after 2021/01/25
      hubs.country: ''
      hubs.hub_name: ''
    sorts: [customers_metrics.first_order_week, customers_metrics.weeks_time_since_sign_up]
    limit: 500
    column_limit: 50
    total: true
    dynamic_fields: [{table_calculation: order_frequency, label: Order Frequency,
        expression: "${orders_cl.cnt_orders}/${orders_cl.cnt_unique_customers}", value_format: !!null '',
        value_format_name: decimal_2, _kind_hint: measure, _type_hint: number}, {
        table_calculation: cohort_size, label: Cohort Size, expression: 'max(pivot_row(${orders_cl.cnt_unique_customers}))',
        value_format: !!null '', value_format_name: !!null '', _kind_hint: supermeasure,
        _type_hint: number}]
    show_view_names: true
    show_row_numbers: false
    transpose: false
    truncate_text: false
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: editable
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
    series_column_widths:
      customers_metrics.first_order_week: 178
      pcnt_of_cohort_still_active: 193
      customers_metrics.cnt_unique_customers: 137
      cohort_size: 78
      order_frequency: 94
    series_cell_visualizations:
      pcnt_of_cohort_still_active:
        is_active: false
        value_display: true
        palette:
          palette_id: 56d0c358-10a0-4fd6-aa0b-b117bef527ab
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
    series_text_format:
      pcnt_of_cohort_still_active: {}
    conditional_formatting: [{type: along a scale..., value: !!null '', background_color: "#1A73E8",
        font_color: !!null '', color_application: {collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2,
          palette_id: 56d0c358-10a0-4fd6-aa0b-b117bef527ab}, bold: false, italic: false,
        strikethrough: false, fields: [order_frequency]}]
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
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    series_types: {}
    hidden_fields: [orders_cl.cnt_unique_customers, orders_cl.cnt_orders]
    column_order: [customers_metrics.first_order_week, cohort_size, 0_order_frequency,
      1_order_frequency, 2_order_frequency, 3_order_frequency, 4_order_frequency,
      5_order_frequency, 6_order_frequency, 7_order_frequency, 8_order_frequency,
      9_order_frequency, 10_order_frequency, 11_order_frequency, 12_order_frequency,
      13_order_frequency]
    y_axes: []
    listen:
      Hub Name: customers_metrics.first_order_hub
      Voucher Code: customers_metrics.first_order_discount_code
      City: customers_metrics.first_order_city
      Country: customers_metrics.country
      Is Voucher Order (Yes / No): customers_metrics.is_discount_acquisition
    row: 13
    col: 0
    width: 24
    height: 11
  - title: Weekly Cohorts (GMV)
    name: Weekly Cohorts (GMV)
    model: flink_v3
    explore: orders_customers
    type: looker_grid
    fields: [customers_metrics.first_order_week, orders_cl.cnt_unique_customers, orders_cl.sum_gmv_gross,
      customers_metrics.weeks_time_since_sign_up]
    pivots: [customers_metrics.weeks_time_since_sign_up]
    fill_fields: [customers_metrics.first_order_week]
    filters:
      orders_cl.is_internal_order: 'no'
      orders_cl.is_successful_order: 'yes'
      orders_cl.created_date: after 2020/01/25
      customers_metrics.first_order_week: after 2021/01/25
      hubs.country: ''
      hubs.hub_name: ''
    sorts: [customers_metrics.weeks_time_since_sign_up, customers_metrics.first_order_week
        0]
    limit: 500
    column_limit: 50
    total: true
    dynamic_fields: [{table_calculation: gmv_retention, label: "% GMV Retention",
        expression: "${orders_cl.sum_gmv_gross}/pivot_index(${orders_cl.sum_gmv_gross},1)",
        value_format: !!null '', value_format_name: percent_1, _kind_hint: measure,
        _type_hint: number}, {table_calculation: gmv_gross, label: GMV (Gross), expression: 'max(pivot_row(${orders_cl.sum_gmv_gross}))',
        value_format: !!null '', value_format_name: eur_0, _kind_hint: supermeasure,
        _type_hint: number}]
    show_view_names: true
    show_row_numbers: false
    transpose: false
    truncate_text: false
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: editable
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
    series_column_widths:
      customers_metrics.first_order_week: 178
      pcnt_of_cohort_still_active: 193
      weekly_cohorts.cnt_unique_customers: 137
      orders_cl.sum_gmv_gross: 90
      weekly_cohorts.sum_gmv_gross: 146
      weekly_gmv_gross: 88
      gmv_retention: 90
      gmv_gross: 87
    series_cell_visualizations:
      pcnt_of_cohort_still_active:
        is_active: false
        value_display: true
        palette:
          palette_id: 56d0c358-10a0-4fd6-aa0b-b117bef527ab
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
    series_text_format:
      pcnt_of_cohort_still_active: {}
    conditional_formatting: [{type: along a scale..., value: !!null '', background_color: "#1A73E8",
        font_color: !!null '', color_application: {collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2,
          palette_id: 56d0c358-10a0-4fd6-aa0b-b117bef527ab}, bold: false, italic: false,
        strikethrough: false, fields: [gmv_retention]}]
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
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    series_types: {}
    hidden_fields: [orders_cl.cnt_unique_customers, orders_cl.sum_gmv_gross]
    column_order: [customers_metrics.first_order_week, gmv_gross, 0_gmv_retention,
      1_gmv_retention, 2_gmv_retention, 3_gmv_retention, 4_gmv_retention, 5_gmv_retention,
      6_gmv_retention, 7_gmv_retention, 8_gmv_retention, 9_gmv_retention, 10_gmv_retention,
      11_gmv_retention, 12_gmv_retention, 13_gmv_retention]
    y_axes: []
    listen:
      Hub Name: customers_metrics.first_order_hub
      Voucher Code: customers_metrics.first_order_discount_code
      City: customers_metrics.first_order_city
      Country: customers_metrics.country
      Is Voucher Order (Yes / No): customers_metrics.is_discount_acquisition
    row: 26
    col: 0
    width: 24
    height: 12
  - name: ''
    type: text
    title_text: ''
    body_text: Here we only (!) look at customers that reordered and we check how
      often they reordered on average per time span
    row: 11
    col: 0
    width: 24
    height: 2
  - name: " (2)"
    type: text
    title_text: ''
    body_text: Here we consider weekly acquisitions and the percentage of those new
      customers who reordered in following 7 day time spans. It is binary per each
      customer, it does not matter how often they reordered in the time period (KPI
      is agnostic to order frequency)
    row: 0
    col: 0
    width: 24
    height: 2
  - name: " (3)"
    type: text
    title_text: ''
    body_text: Here we consider the GMV generated in each returning time span and
      divide it over the GMV generated in week 0
    row: 24
    col: 0
    width: 24
    height: 2
  - title: Monthly Cohorts (Revenue / GMV net of discounts)
    name: Monthly Cohorts (Revenue / GMV net of discounts)
    model: flink_v3
    explore: orders_customers
    type: looker_grid
    fields: [customers_metrics.first_order_week, orders_cl.cnt_unique_customers, orders_cl.sum_discount_amt,
      orders_cl.sum_revenue_gross, customers_metrics.weeks_time_since_sign_up]
    pivots: [customers_metrics.weeks_time_since_sign_up]
    fill_fields: [customers_metrics.first_order_week]
    filters:
      orders_cl.is_internal_order: 'no'
      orders_cl.is_successful_order: 'yes'
      orders_cl.created_date: after 2020/01/25
      customers_metrics.first_order_week: after 2021/01/25
      hubs.country: ''
      hubs.hub_name: ''
    sorts: [customers_metrics.weeks_time_since_sign_up, customers_metrics.first_order_week
        0]
    limit: 500
    column_limit: 50
    total: true
    dynamic_fields: [{_kind_hint: measure, table_calculation: revenue_retention, _type_hint: number,
        category: table_calculation, expression: "${orders_cl.sum_revenue_gross}/pivot_index(${orders_cl.sum_revenue_gross},1)",
        label: "% Revenue Retention", value_format: !!null '', value_format_name: percent_1},
      {_kind_hint: supermeasure, table_calculation: revenue, _type_hint: number, category: table_calculation,
        expression: 'max(pivot_row(${orders_cl.sum_revenue_gross}))', label: Revenue,
        value_format: !!null '', value_format_name: eur_0}]
    show_view_names: true
    show_row_numbers: false
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: editable
    limit_displayed_rows: false
    enable_conditional_formatting: true
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    column_order: [customers_metrics.first_order_week, revenue, revenue_retention]
    show_totals: true
    show_row_totals: true
    series_column_widths:
      customers_metrics.first_order_week: 178
      pcnt_of_cohort_still_active: 193
      weekly_cohorts.cnt_unique_customers: 137
      orders_cl.sum_gmv_gross: 90
      weekly_cohorts.sum_gmv_gross: 146
      weekly_cohorts.sum_discount_amt: 150
      discount_retention: 99
      weekly_discount_value: 120
      discount_value: 110
      revenue_retention: 128
    series_cell_visualizations:
      pcnt_of_cohort_still_active:
        is_active: false
        value_display: true
        palette:
          palette_id: 56d0c358-10a0-4fd6-aa0b-b117bef527ab
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
    series_text_format:
      pcnt_of_cohort_still_active: {}
    conditional_formatting: [{type: along a scale..., value: !!null '', background_color: "#1A73E8",
        font_color: !!null '', color_application: {collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2,
          palette_id: 56d0c358-10a0-4fd6-aa0b-b117bef527ab}, bold: false, italic: false,
        strikethrough: false, fields: [revenue_retention]}]
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
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    series_types: {}
    hidden_fields: [orders_cl.cnt_unique_customers, orders_cl.sum_discount_amt, orders_cl.sum_revenue_gross]
    y_axes: []
    listen:
      Hub Name: customers_metrics.first_order_hub
      Voucher Code: customers_metrics.first_order_discount_code
      City: customers_metrics.first_order_city
      Country: customers_metrics.country
      Is Voucher Order (Yes / No): customers_metrics.is_discount_acquisition
    row: 40
    col: 0
    width: 24
    height: 11
  - name: " (4)"
    type: text
    title_text: ''
    body_text: Here we consider the Revenue (GMV minus discounts) generated in each
      returning time span and divide it over the Revenue generated in week 0
    row: 38
    col: 0
    width: 24
    height: 2
  - name: " (5)"
    type: text
    title_text: ''
    body_text: 'Here we look at customer retention but we disregard any reorders with
      a voucher. This means that reorders with a voucher are not considered at all
      (!)

      '
    row: 51
    col: 0
    width: 24
    height: 2
  - title: Weekly Cohorts (Customer Retention w/o Voucher Reorders)
    name: Weekly Cohorts (Customer Retention w/o Voucher Reorders)
    model: flink_v3
    explore: orders_customers
    type: looker_grid
    fields: [orders_cl.cnt_unique_customers, customers_metrics.weeks_time_since_sign_up,
      orders_cl.cnt_unique_customers_without_voucher, orders_cl.cnt_unique_customers_with_voucher,
      customers_metrics.first_order_week]
    pivots: [customers_metrics.weeks_time_since_sign_up]
    fill_fields: [customers_metrics.first_order_week]
    filters:
      orders_cl.is_internal_order: 'no'
      orders_cl.is_successful_order: 'yes'
      orders_cl.created_date: after 2020/01/25
      customers_metrics.first_order_week: after 2021/01/25
      customers_metrics.first_order_hub: ''
      hubs.country: ''
      hubs.hub_name: ''
      customers_metrics.first_order_discount_code: ''
      customers_metrics.first_order_city: ''
      customers_metrics.country: Germany
    sorts: [customers_metrics.weeks_time_since_sign_up, customers_metrics.first_order_week]
    limit: 500
    column_limit: 50
    total: true
    dynamic_fields: [{category: table_calculation, expression: 'if(${customers_metrics.weeks_time_since_sign_up}=0,1,${orders_cl.cnt_unique_customers_without_voucher}/pivot_index(${orders_cl.cnt_unique_customers},1))',
        label: Pcnt of Cohort still Active (excl voucher reorders), value_format: !!null '',
        value_format_name: percent_1, _kind_hint: measure, table_calculation: pcnt_of_cohort_still_active_excl_voucher_reorders,
        _type_hint: number}, {table_calculation: cohort_size, label: Cohort Size,
        expression: 'max(pivot_row(${orders_cl.cnt_unique_customers}))', value_format: !!null '',
        value_format_name: !!null '', _kind_hint: supermeasure, _type_hint: number}]
    show_view_names: true
    show_row_numbers: false
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: editable
    limit_displayed_rows: false
    enable_conditional_formatting: true
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    column_order: [customers_metrics.first_order_week, cohort_size, 0_pcnt_of_cohort_still_active,
      1_pcnt_of_cohort_still_active, 2_pcnt_of_cohort_still_active, 3_pcnt_of_cohort_still_active,
      4_pcnt_of_cohort_still_active, 5_pcnt_of_cohort_still_active, 6_pcnt_of_cohort_still_active,
      7_pcnt_of_cohort_still_active, 8_pcnt_of_cohort_still_active, 9_pcnt_of_cohort_still_active,
      10_pcnt_of_cohort_still_active, 11_pcnt_of_cohort_still_active, 12_pcnt_of_cohort_still_active,
      13_pcnt_of_cohort_still_active]
    show_totals: true
    show_row_totals: true
    series_column_widths:
      customers_metrics.first_order_week: 196
      pcnt_of_cohort_still_active: 82
      weekly_cohorts.cnt_unique_customers: 137
      cohort_size: 90
      pcnt_of_cohort_still_active_excl_voucher_reorders: 176
    series_cell_visualizations:
      pcnt_of_cohort_still_active:
        is_active: false
        value_display: true
        palette:
          palette_id: 56d0c358-10a0-4fd6-aa0b-b117bef527ab
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
    series_text_format:
      pcnt_of_cohort_still_active: {}
    conditional_formatting: [{type: along a scale..., value: !!null '', background_color: "#1A73E8",
        font_color: !!null '', color_application: {collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2,
          palette_id: 56d0c358-10a0-4fd6-aa0b-b117bef527ab}, bold: false, italic: false,
        strikethrough: false, fields: [pcnt_of_cohort_still_active_excl_voucher_reorders]}]
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
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    series_types: {}
    hidden_fields: [orders_cl.cnt_unique_customers, orders_cl.cnt_unique_customers_without_voucher,
      orders_cl.cnt_unique_customers_with_voucher]
    y_axes: []
    listen:
      Is Voucher Order (Yes / No): customers_metrics.is_discount_acquisition
    row: 53
    col: 0
    width: 24
    height: 15
  filters:
  - name: Country
    title: Country
    type: field_filter
    default_value: Germany
    allow_multiple_values: true
    required: true
    ui_config:
      type: button_group
      display: inline
      options: []
    model: flink_v3
    explore: orders_customers
    listens_to_filters: []
    field: customers_metrics.country
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
    explore: orders_customers
    listens_to_filters: []
    field: customers_metrics.first_order_city
  - name: Hub Name
    title: Hub Name
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
      options: []
    model: flink_v3
    explore: orders_customers
    listens_to_filters: []
    field: customers_metrics.first_order_hub
  - name: Is Voucher Order (Yes / No)
    title: Is Voucher Order (Yes / No)
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: radio_buttons
      display: inline
      options: []
    model: flink_v3
    explore: orders_customers
    listens_to_filters: []
    field: customers_metrics.is_discount_acquisition
  - name: Voucher Code
    title: Voucher Code
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
      options: []
    model: flink_v3
    explore: orders_customers
    listens_to_filters: []
    field: customers_metrics.first_order_discount_code
