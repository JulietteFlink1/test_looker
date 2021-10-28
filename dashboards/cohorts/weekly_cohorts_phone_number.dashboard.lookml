- dashboard: _weekly_cohorts_new_phonebased_logic
  title: " Weekly Cohorts [new phone-based logic]"
  layout: newspaper
  preferred_viewer: dashboards-next
  elements:
  - name: ''
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: Here we consider Weekly acquisitions and the percentage of those new
      customers who reordered in following 7 day time spans. It is binary per each
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
  - title: Weekly Cohorts (Customer Retention)
    name: Weekly Cohorts (Customer Retention)
    model: flink_v3
    explore: orders_customers_cleaned
    type: looker_grid
    fields: [customers_metrics_cleaned.first_order_week, orders_cl_cleaned.cnt_unique_customers,
      customers_metrics_cleaned.weeks_time_since_sign_up]
    pivots: [customers_metrics_cleaned.weeks_time_since_sign_up]
    fill_fields: [customers_metrics_cleaned.first_order_week]
    filters:
      customers_metrics_cleaned.first_order_week: after 2021/01/25
      hubs.country: ''
      hubs.hub_name: ''
      orders_cl_cleaned.is_successful_order: 'yes'
      orders_cl_cleaned.created_date: after 2021/01/25
    sorts: [customers_metrics_cleaned.first_order_week, customers_metrics_cleaned.weeks_time_since_sign_up]
    limit: 500
    total: true
    dynamic_fields: [{category: table_calculation, expression: 'max(pivot_row(${orders_cl_cleaned.cnt_unique_customers}))',
        label: Cohort Size, value_format: !!null '', value_format_name: !!null '',
        _kind_hint: supermeasure, table_calculation: cohort_size, _type_hint: number},
      {category: table_calculation, expression: "${orders_cl_cleaned.cnt_unique_customers}/pivot_index(${orders_cl_cleaned.cnt_unique_customers},1)",
        label: Pcnt of Cohort still Active, value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: pcnt_of_cohort_still_active, _type_hint: number}]
    filter_expression: |-
      is_null(${customers_metrics_cleaned.first_order_week}) = no
      AND (${customers_metrics_cleaned.weeks_duration_between_first_order_week_and_now}>${customers_metrics_cleaned.weeks_time_since_sign_up}+1)
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
    column_order: [customers_metrics_cleaned.first_order_week, cohort_size, 0_pcnt_of_cohort_still_active,
      1_pcnt_of_cohort_still_active, 2_pcnt_of_cohort_still_active, 3_pcnt_of_cohort_still_active,
      4_pcnt_of_cohort_still_active, 5_pcnt_of_cohort_still_active]
    show_totals: false
    show_row_totals: true
    series_column_widths:
      customers_metrics_cleaned.first_order_week: 207
      orders_cl_cleaned.cnt_unique_customers: 151
      cohort_size: 96
      customers_metrics_cleaned.weeks_time_since_sign_up: 151
      pcnt_of_cohort_still_active: 133
    series_cell_visualizations:
      orders_cl_cleaned.cnt_unique_customers:
        is_active: false
    conditional_formatting: [{type: along a scale..., value: !!null '', background_color: "#c76b4e",
        font_color: !!null '', color_application: {collection_id: product-custom-collection,
          custom: {id: ab2575fe-690e-e62f-a137-90c6b0229ef0, label: Custom, type: continuous,
            stops: [{color: "#ffffff", offset: 0}, {color: "#1A73E8", offset: 100}]},
          options: {steps: 5}}, bold: false, italic: false, strikethrough: false,
        fields: [pcnt_of_cohort_still_active]}]
    defaults_version: 1
    hidden_fields: [orders_cl_cleaned.cnt_unique_customers]
    listen:
      City: customers_metrics_cleaned.first_order_city
      Is Voucher Acquisition (Yes / No): customers_metrics_cleaned.is_discount_acquisition
      Hub Name: orders_cl_cleaned.warehouse_name
      Country Iso: customers_metrics_cleaned.country_iso
    row: 2
    col: 0
    width: 22
    height: 8
  - title: Weekly Cohorts (Order Frequency)
    name: Weekly Cohorts (Order Frequency)
    model: flink_v3
    explore: orders_customers_cleaned
    type: looker_grid
    fields: [customers_metrics_cleaned.first_order_week, orders_cl_cleaned.cnt_unique_customers,
      customers_metrics_cleaned.weeks_time_since_sign_up, orders_cl_cleaned.cnt_orders]
    pivots: [customers_metrics_cleaned.weeks_time_since_sign_up]
    fill_fields: [customers_metrics_cleaned.first_order_week]
    filters:
      customers_metrics_cleaned.first_order_week: after 2021/01/25
      hubs.country: ''
      hubs.hub_name: ''
      orders_cl_cleaned.is_successful_order: 'yes'
      orders_cl_cleaned.created_date: after 2021/01/25
    sorts: [customers_metrics_cleaned.first_order_week, customers_metrics_cleaned.weeks_time_since_sign_up]
    limit: 500
    total: true
    dynamic_fields: [{category: table_calculation, expression: 'max(pivot_row(${orders_cl_cleaned.cnt_unique_customers}))',
        label: Cohort Size, value_format: !!null '', value_format_name: !!null '',
        _kind_hint: supermeasure, table_calculation: cohort_size, _type_hint: number},
      {category: table_calculation, expression: "${orders_cl_cleaned.cnt_orders}/${orders_cl_cleaned.cnt_unique_customers}",
        label: Order Frequency, value_format: !!null '', value_format_name: decimal_2,
        _kind_hint: measure, table_calculation: order_frequency, _type_hint: number}]
    filter_expression: |-
      is_null(${customers_metrics_cleaned.first_order_week}) = no
      AND (${customers_metrics_cleaned.weeks_duration_between_first_order_week_and_now}>${customers_metrics_cleaned.weeks_time_since_sign_up}+1)
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
    column_order: [customers_metrics_cleaned.first_order_week, cohort_size, 0_pcnt_of_cohort_still_active,
      1_pcnt_of_cohort_still_active, 2_pcnt_of_cohort_still_active, 3_pcnt_of_cohort_still_active,
      4_pcnt_of_cohort_still_active, 5_pcnt_of_cohort_still_active]
    show_totals: false
    show_row_totals: true
    series_column_widths:
      customers_metrics_cleaned.first_order_week: 207
      orders_cl_cleaned.cnt_unique_customers: 151
      cohort_size: 96
      customers_metrics_cleaned.weeks_time_since_sign_up: 151
      pcnt_of_cohort_still_active: 133
      order_frequency: 134.67000000000007
    series_cell_visualizations:
      orders_cl_cleaned.cnt_unique_customers:
        is_active: false
    conditional_formatting: [{type: along a scale..., value: !!null '', background_color: "#c76b4e",
        font_color: !!null '', color_application: {collection_id: product-custom-collection,
          custom: {id: ab2575fe-690e-e62f-a137-90c6b0229ef0, label: Custom, type: continuous,
            stops: [{color: "#ffffff", offset: 0}, {color: "#1A73E8", offset: 100}]},
          options: {steps: 5}}, bold: false, italic: false, strikethrough: false,
        fields: [order_frequency]}]
    defaults_version: 1
    hidden_fields: [orders_cl_cleaned.cnt_unique_customers, orders_cl_cleaned.cnt_orders]
    listen:
      City: customers_metrics_cleaned.first_order_city
      Is Voucher Acquisition (Yes / No): customers_metrics_cleaned.is_discount_acquisition
      Hub Name: orders_cl_cleaned.warehouse_name
      Country Iso: customers_metrics_cleaned.country_iso
    row: 12
    col: 0
    width: 22
    height: 8
  - title: "% GMV / Active Customer Retention"
    name: "% GMV / Active Customer Retention"
    model: flink_v3
    explore: orders_customers_cleaned
    type: looker_grid
    fields: [customers_metrics_cleaned.first_order_week, orders_cl_cleaned.cnt_unique_customers,
      customers_metrics_cleaned.weeks_time_since_sign_up, orders_cl_cleaned.sum_gmv_gross]
    pivots: [customers_metrics_cleaned.weeks_time_since_sign_up]
    fill_fields: [customers_metrics_cleaned.first_order_week]
    filters:
      customers_metrics_cleaned.country: ''
      customers_metrics_cleaned.first_order_week: after 2021/01/25
      hubs.country: ''
      hubs.hub_name: ''
      orders_cl_cleaned.is_successful_order: 'yes'
      orders_cl_cleaned.created_date: after 2021/01/25
    sorts: [customers_metrics_cleaned.first_order_week 0]
    limit: 500
    total: true
    dynamic_fields: [{category: table_calculation, expression: 'max(pivot_row(${orders_cl_cleaned.sum_gmv_gross}))',
        label: GMV (gross), value_format: !!null '', value_format_name: eur_0, _kind_hint: supermeasure,
        table_calculation: gmv_gross, _type_hint: number}, {category: table_calculation,
        expression: "${orders_cl_cleaned.sum_gmv_gross}/${orders_cl_cleaned.cnt_unique_customers}",
        label: GMV / Active Customer, value_format: !!null '', value_format_name: euro_accounting_1_precision,
        _kind_hint: measure, table_calculation: gmv_active_customer, _type_hint: number},
      {category: table_calculation, expression: " ${gmv_active_customer} / pivot_index(${gmv_active_customer},1)",
        label: "% GMV / Active Customer Retention", value_format: !!null '', value_format_name: percent_0,
        _kind_hint: measure, table_calculation: gmv_active_customer_retention, _type_hint: number}]
    filter_expression: |-
      is_null(${customers_metrics_cleaned.first_order_week}) = no
      AND (${customers_metrics_cleaned.weeks_duration_between_first_order_week_and_now}>${customers_metrics_cleaned.weeks_time_since_sign_up}+1)
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
    column_order: [customers_metrics_cleaned.first_order_week, gmv_gross, 0_gmv_retention,
      1_gmv_retention, 2_gmv_retention, 3_gmv_retention, 4_gmv_retention, 5_gmv_retention]
    show_totals: false
    show_row_totals: true
    series_column_widths:
      customers_metrics_cleaned.first_order_week: 207
      orders_cl_cleaned.cnt_unique_customers: 151
      cohort_size: 96
      customers_metrics_cleaned.weeks_time_since_sign_up: 151
      pcnt_of_cohort_still_active: 133
      gmv_gross: 140.67000000000007
      gmv_active_customer: 103
      gmv_active_customer_retention: 127.67000000000007
    series_cell_visualizations:
      orders_cl_cleaned.cnt_unique_customers:
        is_active: false
    conditional_formatting: [{type: along a scale..., value: !!null '', background_color: "#c76b4e",
        font_color: !!null '', color_application: {collection_id: product-custom-collection,
          custom: {id: ab2575fe-690e-e62f-a137-90c6b0229ef0, label: Custom, type: continuous,
            stops: [{color: "#ffffff", offset: 0}, {color: "#1A73E8", offset: 100}]},
          options: {steps: 5, reverse: false}}, bold: false, italic: false, strikethrough: false,
        fields: [gmv_active_customer_retention]}]
    defaults_version: 1
    hidden_fields: [orders_cl_cleaned.cnt_unique_customers, orders_cl_cleaned.sum_gmv_gross,
      gmv_gross, gmv_active_customer]
    listen:
      City: customers_metrics_cleaned.first_order_city
      Is Voucher Acquisition (Yes / No): customers_metrics_cleaned.is_discount_acquisition
      Hub Name: orders_cl_cleaned.warehouse_name
      Country Iso: customers_metrics_cleaned.country_iso
    row: 34
    col: 0
    width: 22
    height: 9
  - title: GMV / Active Customer
    name: GMV / Active Customer
    model: flink_v3
    explore: orders_customers_cleaned
    type: looker_grid
    fields: [customers_metrics_cleaned.first_order_week, orders_cl_cleaned.cnt_unique_customers,
      orders_cl_cleaned.sum_gmv_gross, customers_metrics_cleaned.weeks_time_since_sign_up]
    pivots: [customers_metrics_cleaned.weeks_time_since_sign_up]
    fill_fields: [customers_metrics_cleaned.first_order_week]
    filters:
      customers_metrics_cleaned.country: ''
      customers_metrics_cleaned.first_order_week: after 2021/01/25
      hubs.country: ''
      hubs.hub_name: ''
      orders_cl_cleaned.is_successful_order: 'yes'
      orders_cl_cleaned.created_date: after 2021/01/25
    sorts: [customers_metrics_cleaned.first_order_week, customers_metrics_cleaned.weeks_time_since_sign_up]
    limit: 500
    total: true
    dynamic_fields: [{category: table_calculation, expression: "${orders_cl_cleaned.sum_gmv_gross}/${orders_cl_cleaned.cnt_unique_customers}",
        label: GMV / Active Customer, value_format: !!null '', value_format_name: euro_accounting_1_precision,
        _kind_hint: measure, table_calculation: gmv_active_customer, _type_hint: number},
      {category: table_calculation, expression: " ${gmv_active_customer} / pivot_index(${gmv_active_customer},1)",
        label: "% GMV / Active Customer Retention", value_format: !!null '', value_format_name: percent_0,
        _kind_hint: measure, table_calculation: gmv_active_customer_retention, _type_hint: number},
      {category: table_calculation, expression: 'max(pivot_row(${orders_cl_cleaned.sum_gmv_gross}))',
        label: GMV (gross), value_format: !!null '', value_format_name: eur_0, _kind_hint: supermeasure,
        table_calculation: gmv_gross, _type_hint: number}]
    filter_expression: |-
      is_null(${customers_metrics_cleaned.first_order_week}) = no
      AND (${customers_metrics_cleaned.weeks_duration_between_first_order_week_and_now}>${customers_metrics_cleaned.weeks_time_since_sign_up}+1)
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
    column_order: [customers_metrics_cleaned.first_order_week, gmv_gross, 0_gmv_retention,
      1_gmv_retention, 2_gmv_retention, 3_gmv_retention, 4_gmv_retention, 5_gmv_retention]
    show_totals: false
    show_row_totals: true
    series_column_widths:
      customers_metrics_cleaned.first_order_week: 203
      orders_cl_cleaned.cnt_unique_customers: 151
      cohort_size: 96
      customers_metrics_cleaned.weeks_time_since_sign_up: 151
      pcnt_of_cohort_still_active: 133
      gmv_gross: 140.67000000000007
      gmv_active_customer: 103
      gmv_active_customer_retention: 155.67000000000007
    series_cell_visualizations:
      orders_cl_cleaned.cnt_unique_customers:
        is_active: false
    conditional_formatting: [{type: along a scale..., value: !!null '', background_color: "#c76b4e",
        font_color: !!null '', color_application: {collection_id: product-custom-collection,
          custom: {id: ab2575fe-690e-e62f-a137-90c6b0229ef0, label: Custom, type: continuous,
            stops: [{color: "#ffffff", offset: 0}, {color: "#1A73E8", offset: 100}]},
          options: {steps: 5}}, bold: false, italic: false, strikethrough: false,
        fields: [gmv_active_customer]}]
    defaults_version: 1
    hidden_fields: [orders_cl_cleaned.cnt_unique_customers, orders_cl_cleaned.sum_gmv_gross,
      gmv_gross, gmv_active_customer_retention]
    listen:
      City: customers_metrics_cleaned.first_order_city
      Is Voucher Acquisition (Yes / No): customers_metrics_cleaned.is_discount_acquisition
      Hub Name: orders_cl_cleaned.warehouse_name
      Country Iso: customers_metrics_cleaned.country_iso
    row: 22
    col: 0
    width: 22
    height: 10
  - name: " (3)"
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: Here we divide the GMV / Active Customer in each return period over
      the GMV / Active Customer of the initial period (W0)
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
  - name: Country Iso
    title: Country Iso
    type: field_filter
    default_value: DE
    allow_multiple_values: true
    required: true
    ui_config:
      type: button_group
      display: inline
      options: []
    model: flink_v3
    explore: orders_customers_cleaned
    listens_to_filters: []
    field: customers_metrics_cleaned.country_iso
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
    explore: orders_customers_cleaned
    listens_to_filters: []
    field: customers_metrics_cleaned.first_order_city
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
    explore: orders_customers_cleaned
    listens_to_filters: []
    field: customers_metrics_cleaned.is_discount_acquisition
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
    explore: orders_customers_cleaned
    listens_to_filters: []
    field: orders_cl_cleaned.warehouse_name
