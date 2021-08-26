- dashboard: monthly_cohorts_phone_number
  title: Monthly Cohorts Phone Number
  layout: newspaper
  preferred_viewer: dashboards-next
  tile_size: 100

  filters:

  elements:
  - name: ''
    type: text
    title_text: ''
    subtitle_text: ''
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
    subtitle_text: ''
    body_text: Here we only (!) look at customers that reordered and we check how
      often they reordered on average per time span
    row: 10
    col: 0
    width: 24
    height: 2
  - name: " (3)"
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: Here we consider the GMV generated in each returning time span and
      divide it over the GMV generated in month 0
    row: 20
    col: 0
    width: 24
    height: 2
  - name: " (4)"
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: Here we consider the Revenue (GMV minus discounts) generated in each
      returning time span and divide it over the Revenue generated in month 0
    row: 30
    col: 0
    width: 24
    height: 2
  - name: " (5)"
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: Here we look at customer retention but we disregard any reorders with
      a voucher. This means that reorders with a voucher are not considered at all
      (!)
    row: 41
    col: 0
    width: 24
    height: 2
  - title: Monthly Cohorts (Customer Retention)
    name: Monthly Cohorts (Customer Retention)
    model: flink_v3
    explore: orders_customers_cleaned
    type: looker_grid
    fields: [customers_metrics_cleaned.first_order_month, customers_metrics_cleaned.months_duration_between_first_order_month_and_now,
      orders_cl_cleaned.cnt_unique_customers, customers_metrics_cleaned.months_time_since_sign_up]
    pivots: [customers_metrics_cleaned.months_time_since_sign_up]
    filters:
      hubs.hub_name: ''
      orders_cl_cleaned.is_internal_order: 'no'
      orders_cl_cleaned.is_successful_order: 'yes'
      orders_cl_cleaned.created_date: after 2021/01/25
      hubs.country: ''
    sorts: [customers_metrics_cleaned.first_order_month, customers_metrics_cleaned.months_time_since_sign_up]
    limit: 500
    total: true
    dynamic_fields: [{category: table_calculation, expression: 'max(pivot_row(${orders_cl_cleaned.cnt_unique_customers}))',
        label: Cohort Size, value_format: !!null '', value_format_name: !!null '',
        _kind_hint: supermeasure, table_calculation: cohort_size, _type_hint: number},
      {category: table_calculation, expression: "${orders_cl_cleaned.cnt_unique_customers}/pivot_index(${orders_cl_cleaned.cnt_unique_customers},1)",
        label: Pcnt of Cohort still Active, value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: pcnt_of_cohort_still_active, _type_hint: number}]
    filter_expression: |-
      is_null(${customers_metrics_cleaned.first_order_month}) = no
      AND (${customers_metrics_cleaned.months_duration_between_first_order_month_and_now}>${customers_metrics_cleaned.months_time_since_sign_up}+1)
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
    column_order: [customers_metrics_cleaned.first_order_month, cohort_size, 0_pcnt_of_cohort_still_active,
      1_pcnt_of_cohort_still_active, 2_pcnt_of_cohort_still_active, 3_pcnt_of_cohort_still_active,
      4_pcnt_of_cohort_still_active, 5_pcnt_of_cohort_still_active]
    show_totals: false
    show_row_totals: true
    series_column_widths:
      customers_metrics_cleaned.first_order_month: 207
      orders_cl_cleaned.cnt_unique_customers: 151
      cohort_size: 96
      customers_metrics_cleaned.months_time_since_sign_up: 151
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
    hidden_fields: [customers_metrics_cleaned.months_duration_between_first_order_month_and_now,
      orders_cl_cleaned.cnt_unique_customers]
    listen:
      Country: customers_metrics_cleaned.country
      City: customers_metrics_cleaned.first_order_city
      Is Voucher Acquisition (Yes / No): customers_metrics_cleaned.is_discount_acquisition
      Hub Name: orders_cl_cleaned.warehouse_name
    row: 2
    col: 0
    width: 22
    height: 8
  - title: Monthly Cohorts (Order Frequency)
    name: Monthly Cohorts (Order Frequency)
    model: flink_v3
    explore: orders_customers_cleaned
    type: looker_grid
    fields: [customers_metrics_cleaned.first_order_month, customers_metrics_cleaned.months_duration_between_first_order_month_and_now,
      orders_cl_cleaned.cnt_unique_customers, customers_metrics_cleaned.months_time_since_sign_up,
      orders_cl_cleaned.cnt_orders]
    pivots: [customers_metrics_cleaned.months_time_since_sign_up]
    filters:
      hubs.hub_name: ''
      orders_cl_cleaned.is_internal_order: 'no'
      orders_cl_cleaned.is_successful_order: 'yes'
      orders_cl_cleaned.created_date: after 2021/01/25
      hubs.country: ''
    sorts: [customers_metrics_cleaned.first_order_month, customers_metrics_cleaned.months_time_since_sign_up]
    limit: 500
    total: true
    dynamic_fields: [{category: table_calculation, expression: 'max(pivot_row(${orders_cl_cleaned.cnt_unique_customers}))',
        label: Cohort Size, value_format: !!null '', value_format_name: !!null '',
        _kind_hint: supermeasure, table_calculation: cohort_size, _type_hint: number},
      {category: table_calculation, expression: "${orders_cl_cleaned.cnt_orders}/${orders_cl_cleaned.cnt_unique_customers}",
        label: Order Frequency, value_format: !!null '', value_format_name: decimal_2,
        _kind_hint: measure, table_calculation: order_frequency, _type_hint: number}]
    filter_expression: |-
      is_null(${customers_metrics_cleaned.first_order_month}) = no
      AND (${customers_metrics_cleaned.months_duration_between_first_order_month_and_now}>${customers_metrics_cleaned.months_time_since_sign_up}+1)
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
    column_order: [customers_metrics_cleaned.first_order_month, cohort_size, 0_pcnt_of_cohort_still_active,
      1_pcnt_of_cohort_still_active, 2_pcnt_of_cohort_still_active, 3_pcnt_of_cohort_still_active,
      4_pcnt_of_cohort_still_active, 5_pcnt_of_cohort_still_active]
    show_totals: false
    show_row_totals: true
    series_column_widths:
      customers_metrics_cleaned.first_order_month: 207
      orders_cl_cleaned.cnt_unique_customers: 151
      cohort_size: 96
      customers_metrics_cleaned.months_time_since_sign_up: 151
      pcnt_of_cohort_still_active: 133
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
    hidden_fields: [customers_metrics_cleaned.months_duration_between_first_order_month_and_now,
      orders_cl_cleaned.cnt_unique_customers, orders_cl_cleaned.cnt_orders]
    listen:
      Country: customers_metrics_cleaned.country
      City: customers_metrics_cleaned.first_order_city
      Is Voucher Acquisition (Yes / No): customers_metrics_cleaned.is_discount_acquisition
      Hub Name: orders_cl_cleaned.warehouse_name
    row: 12
    col: 0
    width: 22
    height: 8
  - title: Monthly Cohorts (GMV)
    name: Monthly Cohorts (GMV)
    model: flink_v3
    explore: orders_customers_cleaned
    type: looker_grid
    fields: [customers_metrics_cleaned.first_order_month, customers_metrics_cleaned.months_duration_between_first_order_month_and_now,
      orders_cl_cleaned.cnt_unique_customers, customers_metrics_cleaned.months_time_since_sign_up,
      orders_cl_cleaned.sum_gmv_gross]
    pivots: [customers_metrics_cleaned.months_time_since_sign_up]
    filters:
      hubs.hub_name: ''
      orders_cl_cleaned.is_internal_order: 'no'
      orders_cl_cleaned.is_successful_order: 'yes'
      orders_cl_cleaned.created_date: after 2021/01/25
      hubs.country: ''
    sorts: [customers_metrics_cleaned.first_order_month, customers_metrics_cleaned.months_time_since_sign_up]
    limit: 500
    total: true
    dynamic_fields: [{category: table_calculation, expression: 'max(pivot_row(${orders_cl_cleaned.sum_gmv_gross}))',
        label: GMV (gross), value_format: !!null '', value_format_name: eur_0, _kind_hint: supermeasure,
        table_calculation: gmv_gross, _type_hint: number}, {category: table_calculation,
        expression: "${orders_cl_cleaned.sum_gmv_gross}/pivot_index(${orders_cl_cleaned.sum_gmv_gross},1)",
        label: "% GMV Retention", value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: gmv_retention, _type_hint: number}]
    filter_expression: |-
      is_null(${customers_metrics_cleaned.first_order_month}) = no
      AND (${customers_metrics_cleaned.months_duration_between_first_order_month_and_now}>${customers_metrics_cleaned.months_time_since_sign_up}+1)
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
    column_order: [customers_metrics_cleaned.first_order_month, gmv_gross, 0_gmv_retention,
      1_gmv_retention, 2_gmv_retention, 3_gmv_retention, 4_gmv_retention, 5_gmv_retention]
    show_totals: false
    show_row_totals: true
    series_column_widths:
      customers_metrics_cleaned.first_order_month: 207
      orders_cl_cleaned.cnt_unique_customers: 151
      cohort_size: 96
      customers_metrics_cleaned.months_time_since_sign_up: 151
      pcnt_of_cohort_still_active: 133
    series_cell_visualizations:
      orders_cl_cleaned.cnt_unique_customers:
        is_active: false
    conditional_formatting: [{type: along a scale..., value: !!null '', background_color: "#c76b4e",
        font_color: !!null '', color_application: {collection_id: product-custom-collection,
          custom: {id: ab2575fe-690e-e62f-a137-90c6b0229ef0, label: Custom, type: continuous,
            stops: [{color: "#ffffff", offset: 0}, {color: "#1A73E8", offset: 100}]},
          options: {steps: 5}}, bold: false, italic: false, strikethrough: false,
        fields: [gmv_retention]}]
    defaults_version: 1
    hidden_fields: [customers_metrics_cleaned.months_duration_between_first_order_month_and_now,
      orders_cl_cleaned.cnt_unique_customers, orders_cl_cleaned.sum_gmv_gross]
    listen:
      Country: customers_metrics_cleaned.country
      City: customers_metrics_cleaned.first_order_city
      Is Voucher Acquisition (Yes / No): customers_metrics_cleaned.is_discount_acquisition
      Hub Name: orders_cl_cleaned.warehouse_name
    row: 22
    col: 0
    width: 22
    height: 8
  - title: Monthly Cohorts (Revenue / GMV net of discounts)
    name: Monthly Cohorts (Revenue / GMV net of discounts)
    model: flink_v3
    explore: orders_customers_cleaned
    type: looker_grid
    fields: [customers_metrics_cleaned.first_order_month, customers_metrics_cleaned.months_duration_between_first_order_month_and_now,
      customers_metrics_cleaned.months_time_since_sign_up, orders_cl_cleaned.sum_revenue_gross]
    pivots: [customers_metrics_cleaned.months_time_since_sign_up]
    filters:
      hubs.hub_name: ''
      orders_cl_cleaned.is_internal_order: 'no'
      orders_cl_cleaned.is_successful_order: 'yes'
      orders_cl_cleaned.created_date: after 2021/01/25
      hubs.country: ''
    sorts: [customers_metrics_cleaned.first_order_month, customers_metrics_cleaned.months_time_since_sign_up]
    limit: 500
    total: true
    dynamic_fields: [{category: table_calculation, expression: 'max(pivot_row(${orders_cl_cleaned.sum_revenue_gross}))',
        label: Revenue (gross), value_format: !!null '', value_format_name: eur_0,
        _kind_hint: supermeasure, table_calculation: revenue_gross, _type_hint: number},
      {category: table_calculation, expression: "${orders_cl_cleaned.sum_revenue_gross}/pivot_index(${orders_cl_cleaned.sum_revenue_gross},1)",
        label: "% Revenue Retention", value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: revenue_retention, _type_hint: number}]
    filter_expression: |-
      is_null(${customers_metrics_cleaned.first_order_month}) = no
      AND (${customers_metrics_cleaned.months_duration_between_first_order_month_and_now}>${customers_metrics_cleaned.months_time_since_sign_up}+1)
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
    column_order: [customers_metrics_cleaned.first_order_month, revenue_gross, 0_revenue_retention,
      1_revenue_retention, 2_revenue_retention, 3_revenue_retention, 4_revenue_retention,
      5_revenue_retention]
    show_totals: false
    show_row_totals: true
    series_column_widths:
      customers_metrics_cleaned.first_order_month: 207
      orders_cl_cleaned.cnt_unique_customers: 151
      cohort_size: 96
      customers_metrics_cleaned.months_time_since_sign_up: 151
      pcnt_of_cohort_still_active: 133
    series_cell_visualizations:
      orders_cl_cleaned.cnt_unique_customers:
        is_active: false
    conditional_formatting: [{type: along a scale..., value: !!null '', background_color: "#c76b4e",
        font_color: !!null '', color_application: {collection_id: product-custom-collection,
          custom: {id: ab2575fe-690e-e62f-a137-90c6b0229ef0, label: Custom, type: continuous,
            stops: [{color: "#ffffff", offset: 0}, {color: "#1A73E8", offset: 100}]},
          options: {steps: 5}}, bold: false, italic: false, strikethrough: false,
        fields: [revenue_retention]}]
    defaults_version: 1
    hidden_fields: [customers_metrics_cleaned.months_duration_between_first_order_month_and_now,
      orders_cl_cleaned.sum_revenue_gross]
    listen:
      Country: customers_metrics_cleaned.country
      City: customers_metrics_cleaned.first_order_city
      Is Voucher Acquisition (Yes / No): customers_metrics_cleaned.is_discount_acquisition
      Hub Name: orders_cl_cleaned.warehouse_name
    row: 32
    col: 0
    width: 22
    height: 9
  - title: Monthly Cohorts (Customer Retention w/o Voucher Reorders)
    name: Monthly Cohorts (Customer Retention w/o Voucher Reorders)
    model: flink_v3
    explore: orders_customers_cleaned
    type: looker_grid
    fields: [customers_metrics_cleaned.first_order_month, customers_metrics_cleaned.months_time_since_sign_up,
      customers_metrics_cleaned.months_duration_between_first_order_month_and_now, orders_cl_cleaned.cnt_unique_customers,
      orders_cl_cleaned.cnt_unique_customers_without_voucher]
    pivots: [customers_metrics_cleaned.months_time_since_sign_up]
    filters:
      hubs.country: ''
      hubs.hub_name: ''
      orders_cl_cleaned.is_internal_order: 'no'
      orders_cl_cleaned.is_successful_order: 'yes'
      orders_cl_cleaned.created_date: after 2021/01/25
    sorts: [customers_metrics_cleaned.first_order_month, customers_metrics_cleaned.months_time_since_sign_up]
    limit: 500
    dynamic_fields: [{category: table_calculation, expression: 'max(pivot_row(${orders_cl_cleaned.cnt_unique_customers}))',
        label: Cohort Size, value_format: !!null '', value_format_name: !!null '',
        _kind_hint: supermeasure, table_calculation: cohort_size, _type_hint: number},
      {category: table_calculation, expression: 'if(${customers_metrics_cleaned.months_time_since_sign_up}=0,1,${orders_cl_cleaned.cnt_unique_customers_without_voucher}/pivot_index(${orders_cl_cleaned.cnt_unique_customers},1))',
        label: Pcnt of Cohort still Active (excl voucher reorders), value_format: !!null '',
        value_format_name: percent_1, _kind_hint: measure, table_calculation: pcnt_of_cohort_still_active_excl_voucher_reorders,
        _type_hint: number}]
    filter_expression: |-
      is_null(${customers_metrics_cleaned.first_order_month}) = no
      AND (${customers_metrics_cleaned.months_duration_between_first_order_month_and_now}>${customers_metrics_cleaned.months_time_since_sign_up}+1)
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
    column_order: [customers_metrics_cleaned.first_order_month, cohort_size, 0_pcnt_of_cohort_still_active_excl_voucher_reorders,
      1_pcnt_of_cohort_still_active_excl_voucher_reorders, 2_pcnt_of_cohort_still_active_excl_voucher_reorders,
      3_pcnt_of_cohort_still_active_excl_voucher_reorders, 4_pcnt_of_cohort_still_active_excl_voucher_reorders,
      5_pcnt_of_cohort_still_active_excl_voucher_reorders]
    show_totals: true
    show_row_totals: true
    series_column_widths:
      customers_metrics_cleaned.first_order_month: 154
      cohort_size: 118
    series_cell_visualizations:
      orders_cl_cleaned.cnt_unique_customers:
        is_active: true
    conditional_formatting: [{type: along a scale..., value: !!null '', background_color: "#c76b4e",
        font_color: !!null '', color_application: {collection_id: product-custom-collection,
          custom: {id: 8465c273-c876-0b28-3be7-c2efe3156221, label: Custom, type: continuous,
            stops: [{color: "#ffffff", offset: 0}, {color: "#1A73E8", offset: 100}]},
          options: {steps: 5}}, bold: false, italic: false, strikethrough: false,
        fields: [pcnt_of_cohort_still_active_excl_voucher_reorders]}]
    hidden_fields: [customers_metrics_cleaned.months_duration_between_first_order_month_and_now,
      orders_cl_cleaned.cnt_unique_customers, orders_cl_cleaned.cnt_unique_customers_without_voucher]
    defaults_version: 1
    listen:
      Country: customers_metrics_cleaned.country
      City: customers_metrics_cleaned.first_order_city
      Is Voucher Acquisition (Yes / No): customers_metrics_cleaned.is_discount_acquisition
      Hub Name: orders_cl_cleaned.warehouse_name
    row: 43
    col: 0
    width: 22
    height: 10
  filters:
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
    explore: orders_customers_cleaned
    listens_to_filters: []
    field: customers_metrics_cleaned.country
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
