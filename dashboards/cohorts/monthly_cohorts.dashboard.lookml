- dashboard: test2_4_order_cohorts_base__dbt_tables
  title: Migrated Monthly Cohorts - DBT prod tables
  layout: newspaper
  preferred_viewer: dashboards-next
  description: ''
  elements:
  - name: ''
    type: text
    title_text: ''
    body_text: Here we consider monthly acquisitions and the percentage of those new
      customers who reordered in following 30 day time spans. It is binary per each
      customer, it does not matter how often they reordered in the time period (KPI
      is agnostic to order frequency)
    row: 0
    col: 0
    width: 22
    height: 2
  - name: " (2)"
    type: text
    title_text: ''
    body_text: Here we only (!) look at customers that reordered and we check how
      often they reordered on average per time span
    row: 10
    col: 0
    width: 24
    height: 2
  - title: Monthly Cohorts (Customer Retention)
    name: Monthly Cohorts (Customer Retention)
    model: flink_v3
    explore: order_cohorts_base
    type: looker_grid
    fields: [customer_cohorts_base.first_order_month, customer_cohorts_base.months_duration_between_first_order_month_and_now,
      order_cohorts_base.cnt_unique_customers, customer_cohorts_base.months_time_since_sign_up]
    pivots: [customer_cohorts_base.months_time_since_sign_up]
    sorts: [customer_cohorts_base.first_order_month, customer_cohorts_base.months_time_since_sign_up]
    limit: 500
    total: true
    dynamic_fields: [{category: table_calculation, expression: 'max(pivot_row(${order_cohorts_base.cnt_unique_customers}))',
        label: Cohort Size, value_format: !!null '', value_format_name: !!null '',
        _kind_hint: supermeasure, table_calculation: cohort_size, _type_hint: number},
      {category: table_calculation, expression: "${order_cohorts_base.cnt_unique_customers}/pivot_index(${order_cohorts_base.cnt_unique_customers},1)",
        label: Pcnt of Cohort still Active, value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: pcnt_of_cohort_still_active, _type_hint: number}]
    filter_expression: |-
      is_null(${customer_cohorts_base.first_order_month}) = no
      AND (${customer_cohorts_base.months_duration_between_first_order_month_and_now}>${customer_cohorts_base.months_time_since_sign_up}+1)
    query_timezone: Europe/Berlin
    show_view_names: false
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
    column_order: [customer_cohorts_base.first_order_month, cohort_size, 0_pcnt_of_cohort_still_active,
      1_pcnt_of_cohort_still_active, 2_pcnt_of_cohort_still_active, 3_pcnt_of_cohort_still_active,
      4_pcnt_of_cohort_still_active, 5_pcnt_of_cohort_still_active]
    show_totals: false
    show_row_totals: true
    series_column_widths:
      customer_cohorts_base.first_order_month: 207
      order_cohorts_base.cnt_unique_customers: 151
      cohort_size: 96
      customer_cohorts_base.months_time_since_sign_up: 151
      pcnt_of_cohort_still_active: 133
    series_cell_visualizations:
      order_cohorts_base.cnt_unique_customers:
        is_active: false
    conditional_formatting: [{type: along a scale..., value: !!null '', background_color: "#c76b4e",
        font_color: !!null '', color_application: {collection_id: product-custom-collection,
          custom: {id: ab2575fe-690e-e62f-a137-90c6b0229ef0, label: Custom, type: continuous,
            stops: [{color: "#ffffff", offset: 0}, {color: "#1A73E8", offset: 100}]},
          options: {steps: 5}}, bold: false, italic: false, strikethrough: false,
        fields: [pcnt_of_cohort_still_active]}]
    defaults_version: 1
    hidden_fields: [customer_cohorts_base.months_duration_between_first_order_month_and_now,
      order_cohorts_base.cnt_unique_customers]
    y_axes: []
    listen:
      Is Successful Order (Yes / No): order_cohorts_base.is_successful_order
      Months Time Since Sign Up: customer_cohorts_base.months_time_since_sign_up
    row: 2
    col: 0
    width: 22
    height: 8
  - title: Monthly Cohorts (Order Frequency)
    name: Monthly Cohorts (Order Frequency)
    model: flink_v3
    explore: order_cohorts_base
    type: looker_grid
    fields: [customer_cohorts_base.first_order_month, customer_cohorts_base.months_duration_between_first_order_month_and_now,
      order_cohorts_base.cnt_unique_customers, customer_cohorts_base.months_time_since_sign_up,
      order_cohorts_base.cnt_orders]
    pivots: [customer_cohorts_base.months_time_since_sign_up]
    sorts: [customer_cohorts_base.first_order_month, customer_cohorts_base.months_time_since_sign_up]
    limit: 500
    total: true
    dynamic_fields: [{category: table_calculation, expression: 'max(pivot_row(${order_cohorts_base.cnt_unique_customers}))',
        label: Cohort Size, value_format: !!null '', value_format_name: !!null '',
        _kind_hint: supermeasure, table_calculation: cohort_size, _type_hint: number},
      {category: table_calculation, expression: "${order_cohorts_base.cnt_orders}/${order_cohorts_base.cnt_unique_customers}",
        label: Order Frequency, value_format: !!null '', value_format_name: decimal_2,
        _kind_hint: measure, table_calculation: order_frequency, _type_hint: number}]
    filter_expression: |-
      is_null(${customer_cohorts_base.first_order_month}) = no
      AND (${customer_cohorts_base.months_duration_between_first_order_month_and_now}>${customer_cohorts_base.months_time_since_sign_up}+1)
    query_timezone: Europe/Berlin
    show_view_names: false
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
    column_order: [customer_cohorts_base.first_order_month, cohort_size, 0_pcnt_of_cohort_still_active,
      1_pcnt_of_cohort_still_active, 2_pcnt_of_cohort_still_active, 3_pcnt_of_cohort_still_active,
      4_pcnt_of_cohort_still_active, 5_pcnt_of_cohort_still_active]
    show_totals: false
    show_row_totals: true
    series_column_widths:
      customer_cohorts_base.first_order_month: 207
      order_cohorts_base.cnt_unique_customers: 151
      cohort_size: 96
      customer_cohorts_base.months_time_since_sign_up: 151
      pcnt_of_cohort_still_active: 133
      order_frequency: 134.67000000000007
    series_cell_visualizations:
      order_cohorts_base.cnt_unique_customers:
        is_active: false
    conditional_formatting: [{type: along a scale..., value: !!null '', background_color: "#c76b4e",
        font_color: !!null '', color_application: {collection_id: product-custom-collection,
          custom: {id: ab2575fe-690e-e62f-a137-90c6b0229ef0, label: Custom, type: continuous,
            stops: [{color: "#ffffff", offset: 0}, {color: "#1A73E8", offset: 100}]},
          options: {steps: 5}}, bold: false, italic: false, strikethrough: false,
        fields: [order_frequency]}]
    defaults_version: 1
    hidden_fields: [customer_cohorts_base.months_duration_between_first_order_month_and_now,
      order_cohorts_base.cnt_unique_customers, order_cohorts_base.cnt_orders]
    y_axes: []
    listen:
      Is Successful Order (Yes / No): order_cohorts_base.is_successful_order
      Months Time Since Sign Up: customer_cohorts_base.months_time_since_sign_up
    row: 12
    col: 0
    width: 22
    height: 8
  - title: "% GMV / Active Customer Retention"
    name: "% GMV / Active Customer Retention"
    model: flink_v3
    explore: order_cohorts_base
    type: looker_grid
    fields: [customer_cohorts_base.first_order_month, customer_cohorts_base.months_duration_between_first_order_month_and_now,
      order_cohorts_base.cnt_unique_customers, customer_cohorts_base.months_time_since_sign_up,
      order_cohorts_base.sum_gmv_gross]
    pivots: [customer_cohorts_base.months_time_since_sign_up]
    sorts: [customer_cohorts_base.first_order_month, customer_cohorts_base.months_time_since_sign_up]
    limit: 500
    total: true
    dynamic_fields: [{category: table_calculation, expression: 'max(pivot_row(${order_cohorts_base.sum_gmv_gross}))',
        label: GMV (gross), value_format: !!null '', value_format_name: eur_0, _kind_hint: supermeasure,
        table_calculation: gmv_gross, _type_hint: number}, {category: table_calculation,
        expression: "${order_cohorts_base.sum_gmv_gross}/${order_cohorts_base.cnt_unique_customers}",
        label: GMV / Active Customer, value_format: !!null '', value_format_name: euro_accounting_1_precision,
        _kind_hint: measure, table_calculation: gmv_active_customer, _type_hint: number},
      {category: table_calculation, expression: " ${gmv_active_customer} / pivot_index(${gmv_active_customer},1)",
        label: "% GMV / Active Customer Retention", value_format: !!null '', value_format_name: percent_0,
        _kind_hint: measure, table_calculation: gmv_active_customer_retention, _type_hint: number}]
    filter_expression: |-
      is_null(${customer_cohorts_base.first_order_month}) = no
      AND (${customer_cohorts_base.months_duration_between_first_order_month_and_now}>${customer_cohorts_base.months_time_since_sign_up}+1)
    query_timezone: Europe/Berlin
    show_view_names: false
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
    column_order: [customer_cohorts_base.first_order_month, gmv_gross, 0_gmv_retention,
      1_gmv_retention, 2_gmv_retention, 3_gmv_retention, 4_gmv_retention, 5_gmv_retention]
    show_totals: false
    show_row_totals: true
    series_column_widths:
      customer_cohorts_base.first_order_month: 207
      order_cohorts_base.cnt_unique_customers: 151
      cohort_size: 96
      customer_cohorts_base.months_time_since_sign_up: 151
      pcnt_of_cohort_still_active: 133
      gmv_gross: 140.67000000000007
      gmv_active_customer: 103
      gmv_active_customer_retention: 127.67000000000007
    series_cell_visualizations:
      order_cohorts_base.cnt_unique_customers:
        is_active: false
    conditional_formatting: [{type: along a scale..., value: !!null '', background_color: "#c76b4e",
        font_color: !!null '', color_application: {collection_id: product-custom-collection,
          custom: {id: ab2575fe-690e-e62f-a137-90c6b0229ef0, label: Custom, type: continuous,
            stops: [{color: "#ffffff", offset: 0}, {color: "#1A73E8", offset: 100}]},
          options: {steps: 5, reverse: false}}, bold: false, italic: false, strikethrough: false,
        fields: [gmv_active_customer_retention]}]
    defaults_version: 1
    hidden_fields: [customer_cohorts_base.months_duration_between_first_order_month_and_now,
      order_cohorts_base.cnt_unique_customers, order_cohorts_base.sum_gmv_gross, gmv_gross,
      gmv_active_customer]
    y_axes: []
    listen:
      Is Successful Order (Yes / No): order_cohorts_base.is_successful_order
      Months Time Since Sign Up: customer_cohorts_base.months_time_since_sign_up
    row: 34
    col: 0
    width: 22
    height: 9
  - title: GMV / Active Customer
    name: GMV / Active Customer
    model: flink_v3
    explore: order_cohorts_base
    type: looker_grid
    fields: [customer_cohorts_base.first_order_month, customer_cohorts_base.months_duration_between_first_order_month_and_now,
      order_cohorts_base.cnt_unique_customers, order_cohorts_base.sum_gmv_gross, customer_cohorts_base.months_time_since_sign_up]
    pivots: [customer_cohorts_base.months_time_since_sign_up]
    sorts: [customer_cohorts_base.first_order_month, customer_cohorts_base.months_time_since_sign_up]
    limit: 500
    total: true
    dynamic_fields: [{category: table_calculation, expression: "${order_cohorts_base.sum_gmv_gross}/${order_cohorts_base.cnt_unique_customers}",
        label: GMV / Active Customer, value_format: !!null '', value_format_name: euro_accounting_1_precision,
        _kind_hint: measure, table_calculation: gmv_active_customer, _type_hint: number},
      {category: table_calculation, expression: " ${gmv_active_customer} / pivot_index(${gmv_active_customer},1)",
        label: "% GMV / Active Customer Retention", value_format: !!null '', value_format_name: percent_0,
        _kind_hint: measure, table_calculation: gmv_active_customer_retention, _type_hint: number},
      {category: table_calculation, expression: 'max(pivot_row(${order_cohorts_base.sum_gmv_gross}))',
        label: GMV (gross), value_format: !!null '', value_format_name: eur_0, _kind_hint: supermeasure,
        table_calculation: gmv_gross, _type_hint: number}]
    filter_expression: |-
      is_null(${customer_cohorts_base.first_order_month}) = no
      AND (${customer_cohorts_base.months_duration_between_first_order_month_and_now}>${customer_cohorts_base.months_time_since_sign_up}+1)
    query_timezone: Europe/Berlin
    show_view_names: false
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
    column_order: [customer_cohorts_base.first_order_month, gmv_gross, 0_gmv_retention,
      1_gmv_retention, 2_gmv_retention, 3_gmv_retention, 4_gmv_retention, 5_gmv_retention]
    show_totals: false
    show_row_totals: true
    series_column_widths:
      customer_cohorts_base.first_order_month: 203
      order_cohorts_base.cnt_unique_customers: 151
      cohort_size: 96
      customer_cohorts_base.months_time_since_sign_up: 151
      pcnt_of_cohort_still_active: 133
      gmv_gross: 140.67000000000007
      gmv_active_customer: 103
      gmv_active_customer_retention: 155.67000000000007
    series_cell_visualizations:
      order_cohorts_base.cnt_unique_customers:
        is_active: false
    conditional_formatting: [{type: along a scale..., value: !!null '', background_color: "#c76b4e",
        font_color: !!null '', color_application: {collection_id: product-custom-collection,
          custom: {id: ab2575fe-690e-e62f-a137-90c6b0229ef0, label: Custom, type: continuous,
            stops: [{color: "#ffffff", offset: 0}, {color: "#1A73E8", offset: 100}]},
          options: {steps: 5}}, bold: false, italic: false, strikethrough: false,
        fields: [gmv_active_customer]}]
    defaults_version: 1
    hidden_fields: [customer_cohorts_base.months_duration_between_first_order_month_and_now,
      order_cohorts_base.cnt_unique_customers, order_cohorts_base.sum_gmv_gross, gmv_gross,
      gmv_active_customer_retention]
    y_axes: []
    listen:
      Is Successful Order (Yes / No): order_cohorts_base.is_successful_order
      Months Time Since Sign Up: customer_cohorts_base.months_time_since_sign_up
    row: 22
    col: 0
    width: 22
    height: 10
  - name: " (3)"
    type: text
    title_text: ''
    body_text: Here we divide the GMV / Active Customer in each return period over
      the GMV / Active Customer of the initial period (M0)
    row: 32
    col: 0
    width: 22
    height: 2
  - name: " (4)"
    type: text
    title_text: ''
    body_text: Here we report the GMV generated per each active customer in the respective
      period
    row: 20
    col: 0
    width: 22
    height: 2
  filters:
  - name: Is Successful Order (Yes / No)
    title: Is Successful Order (Yes / No)
    type: field_filter
    default_value: 'Yes'
    allow_multiple_values: true
    required: false
    ui_config:
      type: button_toggles
      display: inline
      options: []
    model: flink_v3
    explore: order_cohorts_base
    listens_to_filters: []
    field: order_cohorts_base.is_successful_order
  - name: Months Time Since Sign Up
    title: Months Time Since Sign Up
    type: field_filter
    default_value: ">=0"
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: inline
      options: []
    model: flink_v3
    explore: order_cohorts_base
    listens_to_filters: []
    field: customer_cohorts_base.months_time_since_sign_up
