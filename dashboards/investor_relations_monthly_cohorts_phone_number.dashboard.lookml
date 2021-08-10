- dashboard: temp_phone_number_basis_4_monthly_cohorts
  title: "[TEMP - PHONE NUMBER BASIS] (4) Monthly Cohorts"
  layout: newspaper
  preferred_viewer: dashboards-next
  elements:
  - name: ''
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: |-
      Here we consider monthly acquisitions and the percentage of those new customers who reordered in following 30 day time spans.
      It is binary per each customer, it does not matter how often they reordered in the time period (KPI is agnostic to order frequency)
    row: 0
    col: 0
    width: 23
    height: 2
  - name: " (2)"
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: Here we only (!) look at customers that reordered and we check how
      often they reordered on average per time span
    row: 11
    col: 0
    width: 23
    height: 2
  - name: " (3)"
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: Here we consider the GMV generated in each returning time span and
      divide it over the GMV generated in month 0
    row: 22
    col: 0
    width: 23
    height: 2
  - title: Monthly Cohorts (Customer Retention)
    name: Monthly Cohorts (Customer Retention)
    model: flink_v3
    explore: order_order
    type: looker_grid
    fields: [order_order.cnt_unique_customers, user_order_facts_phone_number.first_order_month,
      order_order.months_time_since_sign_up, user_order_facts_phone_number.months_duration_between_first_order_month_and_now]
    pivots: [order_order.months_time_since_sign_up]
    filters:
      order_order.is_internal_order: 'no'
      order_order.is_successful_order: 'yes'
      order_order.created_date: after 2020/01/25
      first_order_facts.warehouse_name: ''
      hubs.country: ''
      hubs.hub_name: ''
    sorts: [user_order_facts_phone_number.first_order_month 0, order_order.months_time_since_sign_up]
    limit: 500
    column_limit: 50
    total: true
    dynamic_fields: [{table_calculation: pcnt_of_cohort_still_active, label: Pcnt
          of Cohort still Active, expression: "${order_order.cnt_unique_customers}/pivot_index(${order_order.cnt_unique_customers},1)",
        value_format: !!null '', value_format_name: percent_1, _kind_hint: measure,
        _type_hint: number}, {table_calculation: cohort_size, label: Cohort Size,
        expression: 'max(pivot_row(${order_order.cnt_unique_customers}))', value_format: !!null '',
        value_format_name: !!null '', _kind_hint: supermeasure, _type_hint: number}]
    filter_expression: |-
      is_null(${user_order_facts_phone_number.first_order_month}) = no
      AND (${user_order_facts_phone_number.months_duration_between_first_order_month_and_now}>${order_order.months_time_since_sign_up}+1)
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
    column_order: [user_order_facts_phone_number.first_order_month, user_order_facts_phone_number.months_duration_between_first_order_month_and_now,
      cohort_size, 0_pcnt_of_cohort_still_active, 1_pcnt_of_cohort_still_active, 2_pcnt_of_cohort_still_active,
      3_pcnt_of_cohort_still_active, 4_pcnt_of_cohort_still_active, 5_pcnt_of_cohort_still_active]
    show_totals: false
    show_row_totals: true
    series_column_widths:
      user_order_facts_phone_number.first_order_week: 178
      pcnt_of_cohort_still_active: 151
      weekly_cohorts_stable_base.cnt_unique_customers: 137
      user_order_facts_phone_number.first_order_month: 207
      monthly_cohorts_stable_base.cnt_unique_customers: 193
      cohort_size: 150
      user_order_facts_phone_number.months_duration_between_first_order_month_and_now: 266
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
    hidden_fields: [order_order.cnt_unique_customers, user_order_facts_phone_number.months_duration_between_first_order_month_and_now]
    y_axes: []
    listen:
      Country: first_order_hub.country
      City: first_order_hub.city
      Hub Name: first_order_hub.hub_name
      Is Voucher Acquisition (Yes / No): first_order_facts.is_voucher_order
    row: 2
    col: 0
    width: 23
    height: 9
  - title: Monthly Cohorts (Order Frequency)
    name: Monthly Cohorts (Order Frequency)
    model: flink_v3
    explore: order_order
    type: looker_grid
    fields: [user_order_facts_phone_number.first_order_month, order_order.cnt_unique_customers,
      order_order.cnt_orders, order_order.months_time_since_sign_up]
    pivots: [order_order.months_time_since_sign_up]
    fill_fields: [user_order_facts_phone_number.first_order_month]
    filters:
      order_order.is_internal_order: 'no'
      order_order.is_successful_order: 'yes'
      order_order.created_date: after 2020/01/25
      first_order_facts.warehouse_name: ''
      order_order.months_time_since_sign_up: ''
      hubs.country: ''
      hubs.hub_name: ''
    sorts: [user_order_facts_phone_number.first_order_month 0, order_order.months_time_since_sign_up]
    limit: 500
    column_limit: 50
    total: true
    dynamic_fields: [{table_calculation: order_frequency, label: Order Frequency,
        expression: "${order_order.cnt_orders}/${order_order.cnt_unique_customers}",
        value_format: !!null '', value_format_name: decimal_2, _kind_hint: measure,
        _type_hint: number}, {table_calculation: cohort_size, label: Cohort Size,
        expression: 'max(pivot_row(${order_order.cnt_unique_customers}))', value_format: !!null '',
        value_format_name: !!null '', _kind_hint: supermeasure, _type_hint: number}]
    filter_expression: |-
      is_null(${user_order_facts_phone_number.first_order_month}) = no
      AND (${user_order_facts_phone_number.months_duration_between_first_order_month_and_now}>${order_order.months_time_since_sign_up}+1)
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
    column_order: [user_order_facts_phone_number.first_order_month, cohort_size, 0_order_frequency,
      1_order_frequency, 2_order_frequency, 3_order_frequency]
    show_totals: false
    show_row_totals: true
    series_column_widths:
      user_order_facts_phone_number.first_order_week: 178
      pcnt_of_cohort_still_active: 193
      weekly_cohorts_stable_base.cnt_unique_customers: 137
      user_order_facts_phone_number.first_order_month: 207
      monthly_cohorts_stable_base.cnt_unique_customers: 202
      order_frequency: 122
      cohort_size: 138
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
    hidden_fields: [order_order.cnt_unique_customers, order_order.cnt_orders]
    y_axes: []
    listen:
      Country: first_order_hub.country
      City: first_order_hub.city
      Hub Name: first_order_hub.hub_name
      Is Voucher Acquisition (Yes / No): first_order_facts.is_voucher_order
    row: 13
    col: 0
    width: 23
    height: 9
  - title: Monthly Cohorts (GMV)
    name: Monthly Cohorts (GMV)
    model: flink_v3
    explore: order_order
    type: looker_grid
    fields: [user_order_facts_phone_number.first_order_month, order_order.cnt_unique_customers,
      order_order.sum_gmv_gross, order_order.months_time_since_sign_up]
    pivots: [order_order.months_time_since_sign_up]
    fill_fields: [user_order_facts_phone_number.first_order_month]
    filters:
      order_order.is_internal_order: 'no'
      order_order.is_successful_order: 'yes'
      order_order.created_date: after 2020/01/25
      first_order_facts.warehouse_name: ''
      order_order.user_email: ''
      hubs.country: ''
      hubs.hub_name: ''
    sorts: [order_order.months_time_since_sign_up, user_order_facts_phone_number.first_order_month
        0]
    limit: 500
    column_limit: 50
    total: true
    dynamic_fields: [{table_calculation: gmv_retention, label: "% GMV Retention",
        expression: "${order_order.sum_gmv_gross}/pivot_index(${order_order.sum_gmv_gross},1)",
        value_format: !!null '', value_format_name: percent_1, _kind_hint: measure,
        _type_hint: number}, {table_calculation: gmv_gross, label: GMV (gross), expression: 'max(pivot_row(${order_order.sum_gmv_gross}))',
        value_format: !!null '', value_format_name: eur_0, _kind_hint: supermeasure,
        _type_hint: number}]
    filter_expression: |-
      is_null(${user_order_facts_phone_number.first_order_month}) = no
      AND (${user_order_facts_phone_number.months_duration_between_first_order_month_and_now}>${order_order.months_time_since_sign_up}+1)
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
    column_order: [user_order_facts_phone_number.first_order_month, gmv_gross, 0_gmv_retention,
      1_gmv_retention, 2_gmv_retention, 3_gmv_retention]
    show_totals: false
    show_row_totals: true
    series_column_widths:
      user_order_facts_phone_number.first_order_week: 178
      pcnt_of_cohort_still_active: 193
      weekly_cohorts_stable_base.cnt_unique_customers: 137
      user_order_facts_phone_number.first_order_month: 207
      monthly_cohorts_stable_base.cnt_unique_customers: 309
      monthly_cohorts_stable_base.sum_gmv_gross: 188
      gmv_retention: 139
      gmv_gross: 174
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
    hidden_fields: [order_order.cnt_unique_customers, order_order.sum_gmv_gross]
    y_axes: []
    listen:
      Country: first_order_hub.country
      City: first_order_hub.city
      Hub Name: first_order_hub.hub_name
      Is Voucher Acquisition (Yes / No): first_order_facts.is_voucher_order
    row: 24
    col: 0
    width: 23
    height: 8
  - title: Monthly Cohorts (Customer Retention w/o Voucher Reorders)
    name: Monthly Cohorts (Customer Retention w/o Voucher Reorders)
    model: flink_v3
    explore: order_order
    type: looker_grid
    fields: [order_order.cnt_unique_customers, user_order_facts_phone_number.first_order_month,
      order_order.months_time_since_sign_up, user_order_facts_phone_number.months_duration_between_first_order_month_and_now,
      order_order.cnt_unique_customers_without_voucher]
    pivots: [order_order.months_time_since_sign_up]
    filters:
      order_order.is_internal_order: 'no'
      order_order.is_successful_order: 'yes'
      order_order.created_date: after 2020/01/25
      first_order_facts.warehouse_name: ''
      hubs.country: ''
      hubs.hub_name: ''
    sorts: [user_order_facts_phone_number.first_order_month 0, order_order.months_time_since_sign_up]
    limit: 500
    column_limit: 50
    total: true
    dynamic_fields: [{_kind_hint: measure, table_calculation: pcnt_of_cohort_still_active_excl_voucher_reorders,
        _type_hint: number, category: table_calculation, expression: 'if(${order_order.months_time_since_sign_up}=0,1,${order_order.cnt_unique_customers_without_voucher}/pivot_index(${order_order.cnt_unique_customers},1))',
        label: Pcnt of Cohort still Active (excl voucher reorders), value_format: !!null '',
        value_format_name: percent_1}, {table_calculation: cohort_size, label: Cohort
          Size, expression: 'max(pivot_row(${order_order.cnt_unique_customers}))',
        value_format: !!null '', value_format_name: !!null '', _kind_hint: supermeasure,
        _type_hint: number}]
    filter_expression: |-
      is_null(${user_order_facts_phone_number.first_order_month}) = no
      AND (${user_order_facts_phone_number.months_duration_between_first_order_month_and_now}>${order_order.months_time_since_sign_up}+1)
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
    column_order: [user_order_facts_phone_number.first_order_month, user_order_facts_phone_number.months_duration_between_first_order_month_and_now,
      cohort_size, 0_pcnt_of_cohort_still_active, 1_pcnt_of_cohort_still_active, 2_pcnt_of_cohort_still_active,
      3_pcnt_of_cohort_still_active, 4_pcnt_of_cohort_still_active, 5_pcnt_of_cohort_still_active]
    show_totals: false
    show_row_totals: true
    series_column_widths:
      user_order_facts_phone_number.first_order_week: 178
      pcnt_of_cohort_still_active: 193
      weekly_cohorts_stable_base.cnt_unique_customers: 137
      user_order_facts_phone_number.first_order_month: 207
      monthly_cohorts_stable_base.cnt_unique_customers: 193
      cohort_size: 127
      user_order_facts_phone_number.months_duration_between_first_order_month_and_now: 266
      pcnt_of_cohort_still_active_excl_voucher_reorders: 123
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
    hidden_fields: [order_order.cnt_unique_customers, user_order_facts_phone_number.months_duration_between_first_order_month_and_now,
      order_order.cnt_unique_customers_without_voucher]
    y_axes: []
    listen:
      Country: first_order_hub.country
      City: first_order_hub.city
      Hub Name: first_order_hub.hub_name
      Is Voucher Acquisition (Yes / No): first_order_facts.is_voucher_order
    row: 47
    col: 0
    width: 23
    height: 11
  - name: " (4)"
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: Here we look at customer retention but we disregard any reorders with
      a voucher. This means that reorders with a voucher are not considered at all
      (!)
    row: 45
    col: 0
    width: 23
    height: 2
  - title: Monthly Cohorts (Revenue / GMV net of discounts)
    name: Monthly Cohorts (Revenue / GMV net of discounts)
    model: flink_v3
    explore: order_order
    type: looker_grid
    fields: [user_order_facts_phone_number.first_order_month, order_order.months_time_since_sign_up,
      order_order.sum_revenue_gross]
    pivots: [order_order.months_time_since_sign_up]
    fill_fields: [user_order_facts_phone_number.first_order_month]
    filters:
      order_order.is_internal_order: 'no'
      order_order.is_successful_order: 'yes'
      order_order.created_date: after 2020/01/25
      first_order_facts.warehouse_name: ''
      order_order.user_email: ''
      hubs.country: ''
      hubs.hub_name: ''
    sorts: [order_order.months_time_since_sign_up, user_order_facts_phone_number.first_order_month
        0]
    limit: 500
    column_limit: 50
    total: true
    dynamic_fields: [{_kind_hint: measure, table_calculation: revenue_retention, _type_hint: number,
        category: table_calculation, expression: "${order_order.sum_revenue_gross}/pivot_index(${order_order.sum_revenue_gross},1)",
        label: "% Revenue Retention", value_format: !!null '', value_format_name: percent_1},
      {_kind_hint: supermeasure, table_calculation: revenue_gross, _type_hint: number,
        category: table_calculation, expression: 'max(pivot_row(${order_order.sum_revenue_gross}))',
        label: Revenue (gross), value_format: !!null '', value_format_name: eur_0}]
    filter_expression: |-
      is_null(${user_order_facts_phone_number.first_order_month}) = no
      AND (${user_order_facts_phone_number.months_duration_between_first_order_month_and_now}>${order_order.months_time_since_sign_up}+1)
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
    column_order: [user_order_facts_phone_number.first_order_month, revenue_gross, 0_revenue_retention,
      1_revenue_retention, 2_revenue_retention, 3_revenue_retention, 4_revenue_retention]
    show_totals: false
    show_row_totals: true
    series_column_widths:
      user_order_facts_phone_number.first_order_week: 178
      pcnt_of_cohort_still_active: 193
      weekly_cohorts_stable_base.cnt_unique_customers: 137
      user_order_facts_phone_number.first_order_month: 207
      monthly_cohorts_stable_base.cnt_unique_customers: 309
      monthly_cohorts_stable_base.sum_gmv_gross: 188
      gmv_retention: 139
      gmv_gross: 134
      gmv_net_of_discounts_retention: 122
      revenue_gross: 143
      revenue_retention: 102
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
    hidden_fields: [order_order.sum_revenue_gross]
    y_axes: []
    listen:
      Country: first_order_hub.country
      City: first_order_hub.city
      Hub Name: first_order_hub.hub_name
      Is Voucher Acquisition (Yes / No): first_order_facts.is_voucher_order
    row: 34
    col: 0
    width: 23
    height: 11
  - name: " (5)"
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: Here we consider the Revenue (GMV minus discounts) generated in each
      returning time span and divide it over the Revenue generated in month 0
    row: 32
    col: 0
    width: 23
    height: 2
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
    explore: order_order
    listens_to_filters: []
    field: first_order_hub.country
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
    explore: order_order
    listens_to_filters: []
    field: first_order_hub.city
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
    explore: order_order
    listens_to_filters: []
    field: first_order_hub.hub_name
  - name: Is Voucher Acquisition (Yes / No)
    title: Is Voucher Acquisition (Yes / No)
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: radio_buttons
      display: inline
      options: []
    model: flink_v3
    explore: order_order
    listens_to_filters: []
    field: first_order_facts.is_voucher_order
