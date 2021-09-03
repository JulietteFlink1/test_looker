- dashboard: outdated__do_not_use_hub_cohorts
  title: "[Outdated - Do not use] Hub Cohorts"
  layout: newspaper
  preferred_viewer: dashboards-next
  elements:
  - name: Hub Cohorts (Customer Retention by Hub)
    title: Hub Cohorts (Customer Retention by Hub)
    model: flink_v3
    explore: orders_customers
    type: looker_grid
    fields: [customers_metrics.first_order_hub, weekly_cohorts.weeks_time_since_sign_up, orders_cl.cnt_orders,
      orders_cl.cnt_unique_customers]
    pivots: [weekly_cohorts.weeks_time_since_sign_up]
    filters:
      orders_cl.is_internal_order: 'no'
      orders_cl.is_successful_order: 'yes'
      orders_cl.created_date: after 2020/01/25
      customers_metrics.first_order_week: before 2 weeks ago
      customers_metrics.first_order_hub: ''
      customers_metrics.is_discount_acquisition: ''
    sorts: [weekly_cohorts.weeks_time_since_sign_up, orders_cl.cnt_unique_customers
        desc 0]
    limit: 500
    column_limit: 50
    total: true
    dynamic_fields: [{table_calculation: pcnt_of_cohort_still_active, label: Pcnt
          of Cohort still Active, expression: "${orders_cl.cnt_unique_customers}/pivot_index(${orders_cl.cnt_unique_customers},1)",
        value_format: !!null '', value_format_name: percent_1, _kind_hint: measure,
        _type_hint: number}, {table_calculation: order_frequency, label: Order Frequency,
        expression: "${orders_cl.cnt_orders}/${orders_cl.cnt_unique_customers}",
        value_format: !!null '', value_format_name: decimal_2, _kind_hint: measure,
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
    column_order: [customers_metrics.first_order_hub, 0|FIELD|2021-01-18_pcnt_of_cohort_still_active,
      0|FIELD|2021-01-25_pcnt_of_cohort_still_active, 0|FIELD|2021-02-01_pcnt_of_cohort_still_active,
      0|FIELD|2021-02-08_pcnt_of_cohort_still_active, 0|FIELD|2021-02-15_pcnt_of_cohort_still_active,
      0|FIELD|2021-02-22_pcnt_of_cohort_still_active, 0|FIELD|2021-03-01_pcnt_of_cohort_still_active,
      1|FIELD|2021-01-18_pcnt_of_cohort_still_active, 1|FIELD|2021-01-25_pcnt_of_cohort_still_active,
      1|FIELD|2021-02-01_pcnt_of_cohort_still_active, 1|FIELD|2021-02-08_pcnt_of_cohort_still_active,
      1|FIELD|2021-02-15_pcnt_of_cohort_still_active, 1|FIELD|2021-02-22_pcnt_of_cohort_still_active,
      1|FIELD|2021-03-01_pcnt_of_cohort_still_active]
    show_totals: true
    show_row_totals: true
    series_column_widths:
      customers_metrics.first_order_week: 178
      pcnt_of_cohort_still_active: 97
      weekly_cohorts_stable_base.cnt_unique_customers: 137
      customers_metrics.first_order_hub: 173
      orders_cl.cnt_unique_customers: 124
      order_frequency: 96
    series_cell_visualizations:
      pcnt_of_cohort_still_active:
        is_active: false
        value_display: true
        palette:
          palette_id: 56d0c358-10a0-4fd6-aa0b-b117bef527ab
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      orders_cl.cnt_unique_customers:
        is_active: true
        palette:
          palette_id: 4a00499b-c0fe-4b15-a304-4083c07ff4c4
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      order_frequency:
        is_active: false
    series_text_format:
      pcnt_of_cohort_still_active: {}
    header_font_color: ''
    conditional_formatting: [{type: along a scale..., value: !!null '', background_color: "#1A73E8",
        font_color: !!null '', color_application: {collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2,
          palette_id: 56d0c358-10a0-4fd6-aa0b-b117bef527ab}, bold: false, italic: false,
        strikethrough: false, fields: [pcnt_of_cohort_still_active]}, {type: along
          a scale..., value: !!null '', background_color: "#1A73E8", font_color: !!null '',
        color_application: {collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2, palette_id: 56d0c358-10a0-4fd6-aa0b-b117bef527ab,
          options: {steps: 5}}, bold: false, italic: false, strikethrough: false,
        fields: [order_frequency]}]
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
    hidden_fields: [orders_cl.cnt_orders]
    y_axes: []
    listen:
      Customers - Weeks Since Sign Up: weekly_cohorts.weeks_time_since_sign_up
      Customers - First Order: customers_metrics.first_order_date
      Country: customers_metrics.first_order_country
      City: customers_metrics.first_order_city
      Hub Name: customers_metrics.first_order_hub
    row: 42
    col: 0
    width: 24
    height: 10
  - name: Hub Cohorts (Weeks since Launch) - Weekly Orders
    title: Hub Cohorts (Weeks since Launch) - Weekly Orders
    model: flink_v3
    explore: orders_customers
    type: looker_line
    fields: [orders_cl.weeks_time_between_hub_launch_and_order, hubs.start_date,
      orders_cl.cnt_orders, hubs.hub_name]
    pivots: [hubs.hub_name, hubs.start_date]
    filters:
      orders_cl.is_internal_order: 'no'
      orders_cl.is_successful_order: 'yes'
      orders_cl.created_date: after 2021/01/25
      orders_cl.created_week: ''
    sorts: [orders_cl.weeks_time_between_hub_launch_and_order, hubs.hub_name 0,
      hubs.start_date]
    limit: 500
    query_timezone: Europe/Berlin
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
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
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: false
    interpolation: linear
    hidden_series: [DE - Berlin - Friedrichshain - orders_cl.cnt_orders]
    series_types: {}
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
      Hubs - Weeks Since Launch: orders_cl.weeks_time_between_hub_launch_and_order
      Hubs - First Order: hubs.start_date
    row: 2
    col: 0
    width: 24
    height: 9
  - name: Hub Cohorts (Weeks since Launch) - AVG Daily GMV
    title: Hub Cohorts (Weeks since Launch) - AVG Daily GMV
    model: flink_v3
    explore: orders_customers
    type: looker_line
    fields: [hubs.hub_name, orders_cl.weeks_time_between_hub_launch_and_order, orders_cl.cnt_orders,
      orders_cl.sum_gmv_gross, hubs.start_date]
    pivots: [hubs.hub_name, hubs.start_date]
    filters:
      orders_cl.is_internal_order: 'no'
      orders_cl.is_successful_order: 'yes'
      orders_cl.created_date: after 2021/01/25
      orders_cl.created_week: ''
    sorts: [orders_cl.weeks_time_between_hub_launch_and_order, hubs.hub_name 0,
      hubs.start_date]
    limit: 500
    dynamic_fields: [{table_calculation: avg_daily_gmv, label: AVG Daily GMV, expression: "${orders_cl.sum_gmv_gross}\
          \ / 6", value_format: !!null '', value_format_name: eur_0, _kind_hint: measure,
        _type_hint: number}]
    query_timezone: Europe/Berlin
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
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
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: false
    interpolation: linear
    hidden_series: [DE - München - Maxvorstadt - orders_cl.cnt_orders, DE - München
        - Schwabing Nord - orders_cl.cnt_orders]
    series_types: {}
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    hidden_fields: [orders_cl.sum_gmv_gross, orders_cl.cnt_orders]
    y_axes: []
    listen:
      Country: hubs.country
      City: hubs.city
      Hub Name: hubs.hub_name
      Hubs - Weeks Since Launch: orders_cl.weeks_time_between_hub_launch_and_order
      Hubs - First Order: hubs.start_date
    row: 11
    col: 0
    width: 24
    height: 9
  - name: ''
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: Here we define each Hub's first successful order as inception and measure
      rolling 7 days timeframes after that
    row: 0
    col: 0
    width: 24
    height: 2
  - name: Hub Cohorts (Days since Launch) - rolling 7 day average GMV
    title: Hub Cohorts (Days since Launch) - rolling 7 day average GMV
    model: flink_v3
    explore: orders_customers
    type: looker_line
    fields: [hubs.start_date, orders_cl.cnt_orders, hubs.hub_name,
      orders_cl.weeks_time_between_hub_launch_and_order, orders_cl.sum_gmv_gross]
    pivots: [hubs.hub_name, hubs.start_date]
    filters:
      orders_cl.is_internal_order: 'no'
      orders_cl.is_successful_order: 'yes'
      orders_cl.created_date: ''
      orders_cl.created_week: ''
    sorts: [hubs.hub_name 0, hubs.start_date 0, orders_cl.weeks_time_between_hub_launch_and_order]
    limit: 500
    column_limit: 50
    dynamic_fields: [{table_calculation: gmv_rolling_7d_avg, label: GMV (rolling 7d
          avg), expression: 'mean(offset_list(${orders_cl.sum_gmv_gross},-6,7))',
        value_format: !!null '', value_format_name: eur_0, _kind_hint: measure, _type_hint: number}]
    query_timezone: Europe/Berlin
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
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
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: false
    interpolation: linear
    hidden_series: [DE - Berlin - Friedrichshain - orders_cl.cnt_orders]
    series_types: {}
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    hidden_fields: [orders_cl.sum_gmv_gross, orders_cl.cnt_orders]
    y_axes: []
    listen:
      Country: hubs.country
      City: hubs.city
      Hub Name: hubs.hub_name
      Hubs - Weeks Since Launch: orders_cl.weeks_time_between_hub_launch_and_order
      Hubs - First Order: hubs.start_date
    row: 20
    col: 0
    width: 24
    height: 12
  - name: Hub Cohorts (Days since Launch) - rolling 7 day average Orders
    title: Hub Cohorts (Days since Launch) - rolling 7 day average Orders
    model: flink_v3
    explore: orders_customers
    type: looker_line
    fields: [hubs.start_date, hubs.hub_name, orders_cl.weeks_time_between_hub_launch_and_order,
      orders_cl.cnt_orders]
    pivots: [hubs.hub_name, hubs.start_date]
    filters:
      orders_cl.is_internal_order: 'no'
      orders_cl.is_successful_order: 'yes'
      orders_cl.created_date: ''
      orders_cl.created_week: ''
    sorts: [hubs.hub_name 0, hubs.start_date 0, orders_cl.weeks_time_between_hub_launch_and_order]
    limit: 500
    column_limit: 50
    dynamic_fields: [{table_calculation: daily_orders_rolling_7d_avg, label: Daily
          Orders (rolling 7d avg), expression: 'mean(offset_list(${orders_cl.cnt_orders},-6,7))',
        value_format: !!null '', value_format_name: decimal_0, _kind_hint: measure,
        _type_hint: number}]
    query_timezone: Europe/Berlin
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
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
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: false
    interpolation: linear
    hidden_series: [DE - Berlin - Friedrichshain - orders_cl.cnt_orders]
    series_types: {}
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    hidden_fields: [orders_cl.cnt_orders]
    y_axes: []
    listen:
      Country: hubs.country
      City: hubs.city
      Hub Name: hubs.hub_name
      Hubs - Weeks Since Launch: orders_cl.weeks_time_between_hub_launch_and_order
      Hubs - First Order: hubs.start_date
    row: 32
    col: 0
    width: 24
    height: 10
  - title: AVG Orders per Hub Weekly Cohorts
    name: AVG Orders per Hub Weekly Cohorts
    model: flink_v3
    explore: orders_cl
    type: looker_line
    fields: [orders_cl.avg_orders_per_hub, hubs.weeks_time_between_hub_launch_and_today,
      orders_cl.created_week]
    pivots: [hubs.weeks_time_between_hub_launch_and_today]
    fill_fields: [orders_cl.created_week]
    filters:
      orders_cl.is_successful_order: 'yes'
      orders_cl.created_date: after 2021/01/25
      hubs.country: ''
      hubs.hub_name: ''
    sorts: [orders_cl.created_week desc, hubs.weeks_time_between_hub_launch_and_today]
    limit: 500
    query_timezone: Europe/Berlin
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
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
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    hide_legend: false
    defaults_version: 1
    listen: {}
    row: 52
    col: 0
    width: 24
    height: 10
  - title: AVG Orders per Hub Monthly Cohort
    name: AVG Orders per Hub Monthly Cohort
    model: flink_v3
    explore: orders_cl
    type: looker_line
    fields: [orders_cl.avg_orders_per_hub, orders_cl.created_week, hubs.months_time_between_hub_launch_and_today]
    pivots: [hubs.months_time_between_hub_launch_and_today]
    fill_fields: [orders_cl.created_week]
    filters:
      orders_cl.is_successful_order: 'yes'
      orders_cl.created_date: after 2021/01/25
      hubs.country: ''
      hubs.hub_name: ''
    sorts: [orders_cl.created_week desc, hubs.months_time_between_hub_launch_and_today]
    limit: 500
    query_timezone: Europe/Berlin
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
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
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    hide_legend: false
    defaults_version: 1
    listen: {}
    row: 62
    col: 0
    width: 24
    height: 9
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
    explore: orders_customers
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
    explore: orders_customers
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
    explore: orders_customers
    listens_to_filters: []
    field: hubs.hub_name
  - name: Hubs - Weeks Since Launch
    title: Hubs - Weeks Since Launch
    type: field_filter
    default_value: "<=4"
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
      options: []
    model: flink_v3
    explore: orders_customers
    listens_to_filters: []
    field: orders_cl.weeks_time_between_hub_launch_and_order
  - name: Hubs - First Order
    title: Hubs - First Order
    type: field_filter
    default_value: before 5 week ago
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
      options: []
    model: flink_v3
    explore: orders_customers
    listens_to_filters: []
    field: hubs.start_date
  - name: Customers - Weeks Since Sign Up
    title: Customers - Weeks Since Sign Up
    type: field_filter
    default_value: "<=2"
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
      options: []
    model: flink_v3
    explore: orders_customers
    listens_to_filters: []
    field: weekly_cohorts.weeks_time_since_sign_up
  - name: Customers - First Order
    title: Customers - First Order
    type: field_filter
    default_value: before 3 week ago
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
      options: []
    model: flink_v3
    explore: orders_customers
    listens_to_filters: []
    field: customers_metrics.first_order_date
