- dashboard: 4_monthly_cohorts_test2
  title: "TEST2 (4) Monthly Cohorts"
  layout: newspaper
  preferred_viewer: dashboards-next
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
    explore: orders_cleaned_dev
    type: looker_grid
    fields: [customer_metrics_cleaned_dev.first_order_month, customer_metrics_cleaned_dev.months_duration_between_first_order_month_and_now,
      orders_cleaned_dev.cnt_unique_customers, customer_metrics_cleaned_dev.months_time_since_sign_up]
    pivots: [customer_metrics_cleaned_dev.months_time_since_sign_up]

    sorts: [customer_metrics_cleaned_dev.first_order_month, customer_metrics_cleaned_dev.months_time_since_sign_up]
    limit: 500
    total: true
    dynamic_fields: [{category: table_calculation, expression: 'max(pivot_row(${orders_cleaned_dev.cnt_unique_customers}))',
        label: Cohort Size, value_format: !!null '', value_format_name: !!null '',
        _kind_hint: supermeasure, table_calculation: cohort_size, _type_hint: number},
      {category: table_calculation, expression: "${orders_cleaned_dev.cnt_unique_customers}/pivot_index(${orders_cleaned_dev.cnt_unique_customers},1)",
        label: Pcnt of Cohort still Active, value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: pcnt_of_cohort_still_active, _type_hint: number}]
    filter_expression: |-
      is_null(${customer_metrics_cleaned_dev.first_order_month}) = no
      AND (${customer_metrics_cleaned_dev.months_duration_between_first_order_month_and_now}>${customer_metrics_cleaned_dev.months_time_since_sign_up}+1)
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
    column_order: [customer_metrics_cleaned_dev.first_order_month, cohort_size, 0_pcnt_of_cohort_still_active,
      1_pcnt_of_cohort_still_active, 2_pcnt_of_cohort_still_active, 3_pcnt_of_cohort_still_active,
      4_pcnt_of_cohort_still_active, 5_pcnt_of_cohort_still_active]
    show_totals: false
    show_row_totals: true
    series_column_widths:
      customer_metrics_cleaned_dev.first_order_month: 207
      orders_cleaned_dev.cnt_unique_customers: 151
      cohort_size: 96
      customer_metrics_cleaned_dev.months_time_since_sign_up: 151
      pcnt_of_cohort_still_active: 133
    series_cell_visualizations:
      orders_cleaned_dev.cnt_unique_customers:
        is_active: false
    conditional_formatting: [{type: along a scale..., value: !!null '', background_color: "#c76b4e",
        font_color: !!null '', color_application: {collection_id: product-custom-collection,
          custom: {id: ab2575fe-690e-e62f-a137-90c6b0229ef0, label: Custom, type: continuous,
            stops: [{color: "#ffffff", offset: 0}, {color: "#1A73E8", offset: 100}]},
          options: {steps: 5}}, bold: false, italic: false, strikethrough: false,
        fields: [pcnt_of_cohort_still_active]}]
    defaults_version: 1
    hidden_fields: [customer_metrics_cleaned_dev.months_duration_between_first_order_month_and_now,
      orders_cleaned_dev.cnt_unique_customers]
    y_axes: []

    row: 2
    col: 0
    width: 22
    height: 8
  - title: Monthly Cohorts (Order Frequency)
    name: Monthly Cohorts (Order Frequency)
    model: flink_v3
    explore: orders_cleaned_dev
    type: looker_grid
    fields: [customer_metrics_cleaned_dev.first_order_month, customer_metrics_cleaned_dev.months_duration_between_first_order_month_and_now,
      orders_cleaned_dev.cnt_unique_customers, customer_metrics_cleaned_dev.months_time_since_sign_up,
      orders_cleaned_dev.cnt_orders]
    pivots: [customer_metrics_cleaned_dev.months_time_since_sign_up]

    sorts: [customer_metrics_cleaned_dev.first_order_month, customer_metrics_cleaned_dev.months_time_since_sign_up]
    limit: 500
    total: true
    dynamic_fields: [{category: table_calculation, expression: 'max(pivot_row(${orders_cleaned_dev.cnt_unique_customers}))',
        label: Cohort Size, value_format: !!null '', value_format_name: !!null '',
        _kind_hint: supermeasure, table_calculation: cohort_size, _type_hint: number},
      {category: table_calculation, expression: "${orders_cleaned_dev.cnt_orders}/${orders_cleaned_dev.cnt_unique_customers}",
        label: Order Frequency, value_format: !!null '', value_format_name: decimal_2,
        _kind_hint: measure, table_calculation: order_frequency, _type_hint: number}]
    filter_expression: |-
      is_null(${customer_metrics_cleaned_dev.first_order_month}) = no
      AND (${customer_metrics_cleaned_dev.months_duration_between_first_order_month_and_now}>${customer_metrics_cleaned_dev.months_time_since_sign_up}+1)
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
    column_order: [customer_metrics_cleaned_dev.first_order_month, cohort_size, 0_pcnt_of_cohort_still_active,
      1_pcnt_of_cohort_still_active, 2_pcnt_of_cohort_still_active, 3_pcnt_of_cohort_still_active,
      4_pcnt_of_cohort_still_active, 5_pcnt_of_cohort_still_active]
    show_totals: false
    show_row_totals: true
    series_column_widths:
      customer_metrics_cleaned_dev.first_order_month: 207
      orders_cleaned_dev.cnt_unique_customers: 151
      cohort_size: 96
      customer_metrics_cleaned_dev.months_time_since_sign_up: 151
      pcnt_of_cohort_still_active: 133
      order_frequency: 134.67000000000007
    series_cell_visualizations:
      orders_cleaned_dev.cnt_unique_customers:
        is_active: false
    conditional_formatting: [{type: along a scale..., value: !!null '', background_color: "#c76b4e",
        font_color: !!null '', color_application: {collection_id: product-custom-collection,
          custom: {id: ab2575fe-690e-e62f-a137-90c6b0229ef0, label: Custom, type: continuous,
            stops: [{color: "#ffffff", offset: 0}, {color: "#1A73E8", offset: 100}]},
          options: {steps: 5}}, bold: false, italic: false, strikethrough: false,
        fields: [order_frequency]}]
    defaults_version: 1
    hidden_fields: [customer_metrics_cleaned_dev.months_duration_between_first_order_month_and_now,
      orders_cleaned_dev.cnt_unique_customers, orders_cleaned_dev.cnt_orders]
    y_axes: []

    row: 12
    col: 0
    width: 22
    height: 8
  - title: "% GMV / Active Customer Retention"
    name: "% GMV / Active Customer Retention"
    model: flink_v3
    explore: orders_cleaned_dev
    type: looker_grid
    fields: [customer_metrics_cleaned_dev.first_order_month, customer_metrics_cleaned_dev.months_duration_between_first_order_month_and_now,
      orders_cleaned_dev.cnt_unique_customers, customer_metrics_cleaned_dev.months_time_since_sign_up,
      orders_cleaned_dev.sum_gmv_gross]
    pivots: [customer_metrics_cleaned_dev.months_time_since_sign_up]

    sorts: [customer_metrics_cleaned_dev.first_order_month, customer_metrics_cleaned_dev.months_time_since_sign_up]
    limit: 500
    total: true
    dynamic_fields: [{category: table_calculation, expression: 'max(pivot_row(${orders_cleaned_dev.sum_gmv_gross}))',
        label: GMV (gross), value_format: !!null '', value_format_name: eur_0, _kind_hint: supermeasure,
        table_calculation: gmv_gross, _type_hint: number}, {category: table_calculation,
        expression: "${orders_cleaned_dev.sum_gmv_gross}/${orders_cleaned_dev.cnt_unique_customers}",
        label: GMV / Active Customer, value_format: !!null '', value_format_name: euro_accounting_1_precision,
        _kind_hint: measure, table_calculation: gmv_active_customer, _type_hint: number},
      {category: table_calculation, expression: " ${gmv_active_customer} / pivot_index(${gmv_active_customer},1)",
        label: "% GMV / Active Customer Retention", value_format: !!null '', value_format_name: percent_0,
        _kind_hint: measure, table_calculation: gmv_active_customer_retention, _type_hint: number}]
    filter_expression: |-
      is_null(${customer_metrics_cleaned_dev.first_order_month}) = no
      AND (${customer_metrics_cleaned_dev.months_duration_between_first_order_month_and_now}>${customer_metrics_cleaned_dev.months_time_since_sign_up}+1)
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
    column_order: [customer_metrics_cleaned_dev.first_order_month, gmv_gross, 0_gmv_retention,
      1_gmv_retention, 2_gmv_retention, 3_gmv_retention, 4_gmv_retention, 5_gmv_retention]
    show_totals: false
    show_row_totals: true
    series_column_widths:
      customer_metrics_cleaned_dev.first_order_month: 207
      orders_cleaned_dev.cnt_unique_customers: 151
      cohort_size: 96
      customer_metrics_cleaned_dev.months_time_since_sign_up: 151
      pcnt_of_cohort_still_active: 133
      gmv_gross: 140.67000000000007
      gmv_active_customer: 103
      gmv_active_customer_retention: 127.67000000000007
    series_cell_visualizations:
      orders_cleaned_dev.cnt_unique_customers:
        is_active: false
    conditional_formatting: [{type: along a scale..., value: !!null '', background_color: "#c76b4e",
        font_color: !!null '', color_application: {collection_id: product-custom-collection,
          custom: {id: ab2575fe-690e-e62f-a137-90c6b0229ef0, label: Custom, type: continuous,
            stops: [{color: "#ffffff", offset: 0}, {color: "#1A73E8", offset: 100}]},
          options: {steps: 5, reverse: false}}, bold: false, italic: false, strikethrough: false,
        fields: [gmv_active_customer_retention]}]
    defaults_version: 1
    hidden_fields: [customer_metrics_cleaned_dev.months_duration_between_first_order_month_and_now,
      orders_cleaned_dev.cnt_unique_customers, orders_cleaned_dev.sum_gmv_gross, gmv_gross,
      gmv_active_customer]
    y_axes: []

    row: 34
    col: 0
    width: 22
    height: 9
  - title: GMV / Active Customer
    name: GMV / Active Customer
    model: flink_v3
    explore: orders_cleaned_dev
    type: looker_grid
    fields: [customer_metrics_cleaned_dev.first_order_month, customer_metrics_cleaned_dev.months_duration_between_first_order_month_and_now,
      orders_cleaned_dev.cnt_unique_customers, orders_cleaned_dev.sum_gmv_gross, customer_metrics_cleaned_dev.months_time_since_sign_up]
    pivots: [customer_metrics_cleaned_dev.months_time_since_sign_up]

    sorts: [customer_metrics_cleaned_dev.first_order_month, customer_metrics_cleaned_dev.months_time_since_sign_up]
    limit: 500
    total: true
    dynamic_fields: [{category: table_calculation, expression: "${orders_cleaned_dev.sum_gmv_gross}/${orders_cleaned_dev.cnt_unique_customers}",
        label: GMV / Active Customer, value_format: !!null '', value_format_name: euro_accounting_1_precision,
        _kind_hint: measure, table_calculation: gmv_active_customer, _type_hint: number},
      {category: table_calculation, expression: " ${gmv_active_customer} / pivot_index(${gmv_active_customer},1)",
        label: "% GMV / Active Customer Retention", value_format: !!null '', value_format_name: percent_0,
        _kind_hint: measure, table_calculation: gmv_active_customer_retention, _type_hint: number},
      {category: table_calculation, expression: 'max(pivot_row(${orders_cleaned_dev.sum_gmv_gross}))',
        label: GMV (gross), value_format: !!null '', value_format_name: eur_0, _kind_hint: supermeasure,
        table_calculation: gmv_gross, _type_hint: number}]
    filter_expression: |-
      is_null(${customer_metrics_cleaned_dev.first_order_month}) = no
      AND (${customer_metrics_cleaned_dev.months_duration_between_first_order_month_and_now}>${customer_metrics_cleaned_dev.months_time_since_sign_up}+1)
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
    column_order: [customer_metrics_cleaned_dev.first_order_month, gmv_gross, 0_gmv_retention,
      1_gmv_retention, 2_gmv_retention, 3_gmv_retention, 4_gmv_retention, 5_gmv_retention]
    show_totals: false
    show_row_totals: true
    series_column_widths:
      customer_metrics_cleaned_dev.first_order_month: 203
      orders_cleaned_dev.cnt_unique_customers: 151
      cohort_size: 96
      customer_metrics_cleaned_dev.months_time_since_sign_up: 151
      pcnt_of_cohort_still_active: 133
      gmv_gross: 140.67000000000007
      gmv_active_customer: 103
      gmv_active_customer_retention: 155.67000000000007
    series_cell_visualizations:
      orders_cleaned_dev.cnt_unique_customers:
        is_active: false
    conditional_formatting: [{type: along a scale..., value: !!null '', background_color: "#c76b4e",
        font_color: !!null '', color_application: {collection_id: product-custom-collection,
          custom: {id: ab2575fe-690e-e62f-a137-90c6b0229ef0, label: Custom, type: continuous,
            stops: [{color: "#ffffff", offset: 0}, {color: "#1A73E8", offset: 100}]},
          options: {steps: 5}}, bold: false, italic: false, strikethrough: false,
        fields: [gmv_active_customer]}]
    defaults_version: 1
    hidden_fields: [customer_metrics_cleaned_dev.months_duration_between_first_order_month_and_now,
      orders_cleaned_dev.cnt_unique_customers, orders_cleaned_dev.sum_gmv_gross, gmv_gross,
      gmv_active_customer_retention]
    y_axes: []

    row: 22
    col: 0
    width: 22
    height: 10
  - name: " (3)"
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: Here we divide the GMV / Active Customer in each return period over
      the GMV / Active Customer of the initial period (M0)
    row: 32
    col: 0
    width: 22
    height: 2
  - name: " (4)"
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: Here we report the GMV generated per each active customer in the respective
      period
    row: 20
    col: 0
    width: 22
    height: 2
