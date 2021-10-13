- dashboard: product_conversions
  title: Product Conversions
  layout: newspaper
  preferred_viewer: dashboards-next
  crossfilter_enabled: true
  elements:
  - name: ''
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: |-
      <h6> AVG (m)CVRs

      (Selected Dates):
    row: 4
    col: 0
    width: 3
    height: 2
  - title: Sessions Per Platform
    name: Sessions Per Platform
    model: flink_v3
    explore: app_sessions
    type: looker_pie
    fields: [app_sessions.cnt_purchase, app_sessions.overall_conversion_rate,
      app_sessions.device_type, app_sessions.count]
    filters: {}
    sorts: [app_sessions.cnt_purchase desc]
    limit: 500
    query_timezone: Europe/Berlin
    value_labels: legend
    label_type: labPer
    inner_radius: 50
    color_application:
      collection_id: product-custom-collection
      palette_id: product-custom-collection-categorical-0
      options:
        steps: 5
        reverse: true
    series_colors:
      android: "#737373"
      ios: "#d9d9d9"
    series_labels: {}
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
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    hidden_fields: [app_sessions.overall_conversion_rate, app_sessions.cnt_purchase]
    series_types: {}
    font_size: 12
    hidden_points_if_no: []
    y_axes: []
    note_state: expanded
    note_display: above
    note_text: Session Share per Platform
    title_hidden: true
    listen:
      Platform: app_sessions.device_type
      Session Start Date: app_sessions.session_start_at_date
      Is New User: app_sessions.is_new_user
      Country: app_sessions.country
      Hub: app_sessions.hub_code
      Session Day of Week: app_sessions.session_start_at_day_of_week
    row: 0
    col: 20
    width: 4
    height: 4
  - title: mcvr2
    name: mcvr2
    model: flink_v3
    explore: app_sessions
    type: single_value
    fields: [app_sessions.mcvr2]
    filters: {}
    limit: 500
    column_limit: 50
    dynamic_fields: [{category: table_calculation, expression: 'sum(offset_list(${app_sessions.cnt_add_to_cart},0,7))/sum(offset_list(${app_sessions.cnt_has_address},0,7))',
        label: mcvr2 this week, value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: mcvr2_this_week, _type_hint: number,
        is_disabled: true}, {category: table_calculation, expression: 'sum(offset_list(${app_sessions.cnt_add_to_cart},7,7))/sum(offset_list(${app_sessions.cnt_has_address},7,7))',
        label: mcvr2 last week, value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: mcvr2_last_week, _type_hint: number,
        is_disabled: true}, {_kind_hint: measure, table_calculation: mcvr2_diff, _type_hint: number,
        category: table_calculation, expression: "${mcvr2_this_week}-${mcvr2_last_week}",
        label: mcvr2 diff, value_format: !!null '', value_format_name: percent_1,
        is_disabled: true}]
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    color_application:
      collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7
      palette_id: fb7bb53e-b77b-4ab6-8274-9d420d3d73f3
    custom_color: "#e21c79"
    single_value_title: mCVR2
    comparison_label: From Prior
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
    defaults_version: 1
    hidden_fields: [mcvr1_last_week]
    series_types: {}
    y_axes: []
    note_state: collapsed
    note_display: hover
    note_text: mCVR2 = Sessions with product added to cart / Sessions with address
    listen:
      Platform: app_sessions.device_type
      Session Start Date: app_sessions.session_start_at_date
      Is New User: app_sessions.is_new_user
      Country: app_sessions.country
      Hub: app_sessions.hub_code
      Session Day of Week: app_sessions.session_start_at_day_of_week
    row: 4
    col: 11
    width: 3
    height: 2
  - title: mcvr3
    name: mcvr3
    model: flink_v3
    explore: app_sessions
    type: single_value
    fields: [app_sessions.mcvr3]
    filters: {}
    limit: 500
    column_limit: 50
    dynamic_fields: [{_kind_hint: measure, table_calculation: mcvr3_this_week, _type_hint: number,
        category: table_calculation, expression: 'sum(offset_list(${app_sessions.cnt_checkout_started},0,7))/sum(offset_list(${app_sessions.cnt_add_to_cart},0,7))',
        label: mcvr3 this week, value_format: !!null '', value_format_name: percent_1,
        is_disabled: true}, {_kind_hint: measure, table_calculation: mcvr3_last_week,
        _type_hint: number, category: table_calculation, expression: 'sum(offset_list(${app_sessions.cnt_checkout_started},7,7))/sum(offset_list(${app_sessions.cnt_add_to_cart},7,7))',
        label: mcvr3 last week, value_format: !!null '', value_format_name: percent_1,
        is_disabled: true}, {_kind_hint: measure, table_calculation: mcvr3_diff, _type_hint: number,
        category: table_calculation, expression: "${mcvr3_this_week}-${mcvr3_last_week}",
        label: mcvr3 diff, value_format: !!null '', value_format_name: percent_1,
        is_disabled: true}]
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    color_application:
      collection_id: product-custom-collection
      palette_id: product-custom-collection-categorical-0
    custom_color: "#e5508e"
    single_value_title: mCVR3
    comparison_label: From Prior
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
    defaults_version: 1
    hidden_fields: [mcvr1_last_week, mcvr2_last_week]
    series_types: {}
    y_axes: []
    note_state: collapsed
    note_display: hover
    note_text: mCVR3 = Sessions with checkout started / Sessions with product added
      to cart
    listen:
      Platform: app_sessions.device_type
      Session Start Date: app_sessions.session_start_at_date
      Is New User: app_sessions.is_new_user
      Country: app_sessions.country
      Hub: app_sessions.hub_code
      Session Day of Week: app_sessions.session_start_at_day_of_week
    row: 4
    col: 14
    width: 3
    height: 2
  - title: mcvr4
    name: mcvr4
    model: flink_v3
    explore: app_sessions
    type: single_value
    fields: [app_sessions.mcvr4]
    filters: {}
    limit: 500
    column_limit: 50
    dynamic_fields: [{_kind_hint: measure, table_calculation: mcvr4_this_week, _type_hint: number,
        category: table_calculation, expression: 'sum(offset_list(${app_sessions.cnt_payment_started},0,7))/sum(offset_list(${app_sessions.cnt_checkout_started},0,7))',
        label: mcvr4 this week, value_format: !!null '', value_format_name: percent_1,
        is_disabled: true}, {_kind_hint: measure, table_calculation: mcvr4_last_week,
        _type_hint: number, category: table_calculation, expression: 'sum(offset_list(${app_sessions.cnt_payment_started},7,7))/sum(offset_list(${app_sessions.cnt_checkout_started},7,7))',
        label: mcvr4 last week, value_format: !!null '', value_format_name: percent_1,
        is_disabled: true}, {_kind_hint: measure, table_calculation: mcvr4_diff, _type_hint: number,
        category: table_calculation, expression: "${mcvr4_this_week}-${mcvr4_last_week}",
        label: mcvr4 diff, value_format: !!null '', value_format_name: percent_1,
        is_disabled: true}]
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    color_application:
      collection_id: product-custom-collection
      palette_id: product-custom-collection-categorical-0
    custom_color: "#e21c79"
    single_value_title: mCVR4
    comparison_label: From Prior
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
    defaults_version: 1
    hidden_fields: [mcvr1_last_week, mcvr2_last_week, mcvr3_last_week]
    series_types: {}
    y_axes: []
    note_state: collapsed
    note_display: hover
    note_text: mCVR4 = Sessions with payment started / Sessions with checkout started
    listen:
      Platform: app_sessions.device_type
      Session Start Date: app_sessions.session_start_at_date
      Is New User: app_sessions.is_new_user
      Country: app_sessions.country
      Hub: app_sessions.hub_code
      Session Day of Week: app_sessions.session_start_at_day_of_week
    row: 4
    col: 17
    width: 3
    height: 2
  - title: Conversion Rate
    name: Conversion Rate
    model: flink_v3
    explore: app_sessions
    type: single_value
    fields: [app_sessions.overall_conversion_rate]
    filters: {}
    limit: 500
    column_limit: 50
    dynamic_fields: [{_kind_hint: measure, table_calculation: overall_conversion_this_week,
        _type_hint: number, category: table_calculation, expression: 'sum(offset_list(${app_sessions.cnt_purchase},0,7))/sum(offset_list(${app_sessions.count},0,7))',
        label: overall conversion this week, value_format: !!null '', value_format_name: percent_1,
        is_disabled: true}, {_kind_hint: measure, table_calculation: overall_conversion_last_week,
        _type_hint: number, category: table_calculation, expression: 'sum(offset_list(${app_sessions.cnt_purchase},7,7))/sum(offset_list(${app_sessions.count},7,7))',
        label: overall conversion last week, value_format: !!null '', value_format_name: percent_1,
        is_disabled: true}, {_kind_hint: measure, table_calculation: overall_conversion_diff,
        _type_hint: number, category: table_calculation, expression: "${overall_conversion_this_week}-${overall_conversion_last_week}",
        label: overall conversion diff, value_format: !!null '', value_format_name: percent_1,
        is_disabled: true}]
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    color_application:
      collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7
      palette_id: fb7bb53e-b77b-4ab6-8274-9d420d3d73f3
    custom_color: "#000"
    single_value_title: CVR
    value_format: ''
    comparison_label: From Prior
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
    defaults_version: 1
    hidden_fields: [mcvr1_last_week, mcvr2_last_week, mcvr3_last_week, mcvr4_last_week]
    series_types: {}
    y_axes: []
    hidden_points_if_no: []
    series_labels: {}
    note_state: collapsed
    note_display: hover
    note_text: CVR = Sessions with order placed / All sessions
    listen:
      Platform: app_sessions.device_type
      Session Start Date: app_sessions.session_start_at_date
      Is New User: app_sessions.is_new_user
      Country: app_sessions.country
      Hub: app_sessions.hub_code
      Session Day of Week: app_sessions.session_start_at_day_of_week
    row: 4
    col: 3
    width: 5
    height: 2
  - title: Conversion Funnel
    name: Conversion Funnel
    model: flink_v3
    explore: app_sessions
    type: looker_funnel
    fields: [app_sessions.count, app_sessions.cnt_has_address,
      app_sessions.cnt_add_to_cart, app_sessions.cnt_checkout_started,
      app_sessions.cnt_payment_started, app_sessions.cnt_purchase]
    sorts: [app_sessions.cnt_add_to_cart desc]
    limit: 500
    column_limit: 50
    dynamic_fields: [{_kind_hint: measure, table_calculation: session_started_30_min,
        _type_hint: number, category: table_calculation, expression: "${app_sessions.count}",
        label: Session Started (30 min.), value_format: !!null '', value_format_name: !!null ''},
      {category: table_calculation, expression: "${app_sessions.cnt_has_address}",
        label: Has Address, value_format: !!null '', value_format_name: !!null '',
        _kind_hint: measure, table_calculation: has_address, _type_hint: number},
     {_kind_hint: measure,
        table_calculation: product_added_to_cart, _type_hint: number, category: table_calculation,
        expression: "${app_sessions.cnt_add_to_cart}", label: Product
          Added To Cart, value_format: !!null '', value_format_name: !!null ''}, {
        _kind_hint: measure, table_calculation: cart_viewed, _type_hint: number, category: table_calculation,
        expression: "${app_sessions.cnt_checkout_started}", label: Checkout
          Started, value_format: !!null '', value_format_name: !!null ''}, {_kind_hint: measure,
        table_calculation: payment_started, _type_hint: number, category: table_calculation,
        expression: "${app_sessions.cnt_payment_started}", label: Payment
          Started, value_format: !!null '', value_format_name: !!null ''}, {_kind_hint: measure,
        table_calculation: order_placed, _type_hint: number, category: table_calculation,
        expression: "${app_sessions.cnt_purchase}", label: Order Placed,
        value_format: !!null '', value_format_name: !!null ''}]
    leftAxisLabelVisible: false
    leftAxisLabel: ''
    rightAxisLabelVisible: false
    rightAxisLabel: ''
    smoothedBars: true
    orientation: automatic
    labelPosition: left
    percentType: total
    percentPosition: inline
    valuePosition: right
    labelColorEnabled: false
    labelColor: "#FFF"
    color_application:
      collection_id: flink
      palette_id: flink-diverging-0
      options:
        steps: 5
        reverse: true
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 1
    series_types: {}
    hidden_fields: [app_sessions.count, app_sessions.cnt_add_to_cart,
      app_sessions.cnt_checkout_started, app_sessions.cnt_payment_started,
      app_sessions.cnt_purchase, app_sessions.cnt_has_address]
    y_axes: []
    listen:
      Platform: app_sessions.device_type
      Session Start Date: app_sessions.session_start_at_date
      Is New User: app_sessions.is_new_user
      Country: app_sessions.country
      Hub: app_sessions.hub_code
      Session Day of Week: app_sessions.session_start_at_day_of_week
    row: 40
    col: 0
    width: 12
    height: 7
  - title: CVR per Platform
    name: CVR per Platform
    model: flink_v3
    explore: app_sessions
    type: looker_column
    fields: [app_sessions.count, app_sessions.overall_conversion_rate,
      app_sessions.device_type, app_sessions.session_start_date_granularity]
    pivots: [app_sessions.device_type]
    sorts: [app_sessions.device_type, app_sessions.session_start_date_granularity]
    limit: 500
    column_limit: 50
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
    stacking: normal
    limit_displayed_rows: false
    legend_position: center
    point_style: circle
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    color_application:
      collection_id: product-custom-collection
      palette_id: product-custom-collection-categorical-0
      options:
        steps: 5
    y_axes: [{label: "# Sessions", orientation: left, series: [{axisId: android -
              app_sessions.count, id: android - app_sessions.count,
            name: Android Number Of Sessions}, {axisId: ios - app_sessions.count,
            id: ios - app_sessions.count, name: iOS Number Of Sessions}],
        showLabels: true, showValues: true, unpinAxis: false, tickDensity: default,
        type: linear}, {label: Conversion Rate, orientation: right, series: [{axisId: android
              - app_sessions.overall_conversion_rate, id: android -
              app_sessions.overall_conversion_rate, name: Android Conversion
              Rate}, {axisId: ios - app_sessions.overall_conversion_rate,
            id: ios - app_sessions.overall_conversion_rate, name: iOS
              Conversion Rate}], showLabels: true, showValues: true, maxValue: !!null '',
        minValue: 0, unpinAxis: false, tickDensity: default, type: linear}]
    x_axis_label: Session Start Date
    series_types:
      app_sessions.cnt_purchase: line
      app_sessions.overall_conversion_rate: line
      android - app_sessions.overall_conversion_rate: line
      ios - app_sessions.overall_conversion_rate: line
    series_colors:
      app_sessions.overall_conversion_rate: "#FBB555"
      app_sessions.count: "#75E2E2"
      android - app_sessions.count: "#d4d4d4"
      android - app_sessions.overall_conversion_rate: "#9f71f0"
      ios - app_sessions.overall_conversion_rate: "#e21c79"
      ios - app_sessions.count: "#ababab"
    series_labels:
      app_sessions.count: Number Of Sessions (30 min.)
      app_sessions.overall_conversion_rate: Conversion Rate
      android - app_sessions.count: Android Number Of Sessions
      ios - app_sessions.count: iOS Number Of Sessions
      android - app_sessions.overall_conversion_rate: Android Conversion
        Rate
      ios - app_sessions.overall_conversion_rate: iOS Conversion Rate
    series_point_styles:
      android - app_sessions.overall_conversion_rate: square
      ios - app_sessions.overall_conversion_rate: diamond
    defaults_version: 1
    hidden_fields: []
    note_state: collapsed
    note_display: below
    note_text: Max Session Duration is defined as 30 mins
    listen:
      Session Start Date: app_sessions.session_start_at_date
      Granularity: app_sessions.timeframe_picker
      Is New User: app_sessions.is_new_user
      Country: app_sessions.country
      Hub: app_sessions.hub_code
      Session Day of Week: app_sessions.session_start_at_day_of_week
    row: 6
    col: 12
    width: 12
    height: 7
  - title: Conversion Per App Version (top 10)
    name: Conversion Per App Version (top 10)
    model: flink_v3
    explore: app_sessions
    type: looker_grid
    fields: [app_sessions.full_app_version, app_sessions.count,
      app_sessions.overall_conversion_rate, app_sessions.mcvr1,
      app_sessions.mcvr2, app_sessions.mcvr3, app_sessions.mcvr4]
    sorts: [app_sessions.count desc]
    limit: 10
    column_limit: 50
    dynamic_fields: [{_kind_hint: measure, table_calculation: percent_of_total, _type_hint: number,
        category: table_calculation, expression: "${app_sessions.count}/sum(${app_sessions.count})",
        label: Percent of Total, value_format: !!null '', value_format_name: percent_1}]
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
    color_application:
      collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7
      palette_id: fb7bb53e-b77b-4ab6-8274-9d420d3d73f3
    show_sql_query_menu_options: false
    column_order: ["$$$_row_numbers_$$$", app_sessions.full_app_version,
      app_sessions.count, percent_of_total, app_sessions.overall_conversion_rate,
      app_sessions.mcvr1, app_sessions.mcvr2, app_sessions.mcvr3,
      app_sessions.mcvr4]
    show_totals: true
    show_row_totals: true
    series_labels:
      app_sessions.overall_conversion_rate: Conversion Rate
      app_sessions.count: Number Of Sessions
      app_sessions.full_app_version: App Version
      app_sessions.mcvr1: 'mCVR1: Address Confirmed'
      app_sessions.mcvr2: 'mCVR2: Product Added'
      app_sessions.mcvr3: 'mCVR3: Checkout Started'
      app_sessions.mcvr4: 'mCVR4: Payment Started'
    series_column_widths:
      percent_of_total: 132
    series_cell_visualizations:
      app_sessions.count:
        is_active: true
        palette:
          palette_id: c7d0abd1-0f77-de62-bde8-aceaa9d5f836
          collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7
          custom_colors:
          - "#ffffff"
          - "#e21c79"
    series_text_format:
      app_sessions.full_app_version: {}
    conditional_formatting: [{type: along a scale..., value: !!null '', background_color: !!null '',
        font_color: !!null '', color_application: {collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7,
          custom: {id: ba8befe4-79b7-5070-3b6e-0ff051601827, label: Custom, type: continuous,
            stops: [{color: "#e32a30", offset: 0}, {color: "#ffffff", offset: 100}]},
          options: {steps: 5, constraints: {min: {type: percentile, value: 10}, max: {
                type: percentile, value: 90}, mid: {type: middle}}, mirror: false,
            stepped: false, reverse: false}}, bold: false, italic: false, strikethrough: false,
        fields: [app_sessions.overall_conversion_rate]}, {type: along
          a scale..., value: !!null '', background_color: !!null '', font_color: !!null '',
        color_application: {collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7, custom: {
            id: a45b426e-1713-c1cb-8264-dc628825d43a, label: Custom, type: continuous,
            stops: [{color: "#ffffff", offset: 0}, {color: "#e32a30", offset: 100}]},
          options: {steps: 5, reverse: true, constraints: {min: {type: number, value: 0.1},
              max: {type: number, value: 0.5}}}}, bold: false, italic: false, strikethrough: false,
        fields: [app_sessions.mcvr1]}, {type: along a scale..., value: !!null '',
        background_color: !!null '', font_color: !!null '', color_application: {collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7,
          custom: {id: 43974cef-9d77-e5e1-0753-23b3a512ee7e, label: Custom, type: continuous,
            stops: [{color: "#ffffff", offset: 0}, {color: "#e32a30", offset: 100}]},
          options: {steps: 5, reverse: true, constraints: {max: {type: number, value: 0.5},
              min: {type: number, value: 0.1}, mid: {type: middle}}}}, bold: false,
        italic: false, strikethrough: false, fields: [app_sessions.mcvr2]},
      {type: along a scale..., value: !!null '', background_color: !!null '', font_color: !!null '',
        color_application: {collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7, custom: {
            id: a7b0a8f9-142e-ecc1-46a3-07ea6eefea78, label: Custom, type: continuous,
            stops: [{color: "#ffffff", offset: 0}, {color: "#e32a30", offset: 100}]},
          options: {steps: 5, reverse: true, constraints: {min: {type: number, value: 0.1},
              max: {type: number, value: 0.8}}}}, bold: false, italic: false, strikethrough: false,
        fields: [app_sessions.mcvr3]}, {type: along a scale..., value: !!null '',
        background_color: !!null '', font_color: !!null '', color_application: {collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7,
          custom: {id: b0fb27cb-d1d0-4e0f-b401-13aa03ffd4cc, label: Custom, type: continuous,
            stops: [{color: "#ffffff", offset: 0}, {color: "#e32a30", offset: 100}]},
          options: {steps: 5, reverse: true, constraints: {min: {type: number, value: 0.1},
              max: {type: number, value: 0.8}}}}, bold: false, italic: false, strikethrough: false,
        fields: [app_sessions.mcvr4]}]
    series_types: {}
    defaults_version: 1
    hidden_fields: []
    y_axes: []
    listen:
      Platform: app_sessions.device_type
      Session Start Date: app_sessions.session_start_at_date
      Is New User: app_sessions.is_new_user
      Country: app_sessions.country
      Hub: app_sessions.hub_code
      Session Day of Week: app_sessions.session_start_at_day_of_week
    row: 40
    col: 12
    width: 12
    height: 6
  - title: mCVR1 per Platform
    name: mCVR1 per Platform
    model: flink_v3
    explore: app_sessions
    type: looker_column
    fields: [app_sessions.count, app_sessions.mcvr1,
      app_sessions.device_type, app_sessions.session_start_date_granularity]
    pivots: [app_sessions.device_type]
    sorts: [app_sessions.device_type, app_sessions.session_start_date_granularity]
    limit: 500
    column_limit: 50
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
    stacking: normal
    limit_displayed_rows: false
    legend_position: center
    point_style: circle
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    color_application:
      collection_id: product-custom-collection
      palette_id: product-custom-collection-categorical-0
      options:
        steps: 5
    y_axes: [{label: "# Sessions", orientation: left, series: [{axisId: android -
              app_sessions.count, id: android - app_sessions.count,
            name: Sessions Started (Android)}, {axisId: ios - app_sessions.count,
            id: ios - app_sessions.count, name: Sessions Started (iOS)}],
        showLabels: true, showValues: true, unpinAxis: false, tickDensity: default,
        type: linear}, {label: '', orientation: right, series: [{axisId: android -
              app_sessions.mcvr1, id: android - app_sessions.mcvr1,
            name: 'mCVR1: Has Address (Android)'}, {axisId: ios - app_sessions.mcvr1,
            id: ios - app_sessions.mcvr1, name: 'mCVR1: Has Address
              (iOS)'}], showLabels: true, showValues: true, unpinAxis: false, tickDensity: default,
        type: linear}]
    x_axis_label: Session Start Date
    series_types:
      app_sessions.cnt_purchase: line
      app_sessions.overall_conversion_rate: line
      app_sessions.mcvr1: line
      android - app_sessions.mcvr1: line
      ios - app_sessions.mcvr1: line
    series_colors:
      app_sessions.overall_conversion_rate: "#FBB555"
      app_sessions.count: "#75E2E2"
      app_sessions.mcvr1: "#4276BE"
      android - app_sessions.count: "#d4d4d4"
      android - app_sessions.mcvr1: "#9f71f0"
      ios - app_sessions.mcvr1: "#e21c79"
      ios - app_sessions.count: "#ababab"
    series_labels:
      app_sessions.count: Number Of Sessions (30 min.)
      app_sessions.overall_conversion_rate: Conversion Rate
      app_sessions.mcvr1: 'mCVR1: Address Confirmed'
      android - app_sessions.count: Sessions Started (Android)
      ios - app_sessions.count: Sessions Started (iOS)
      android - app_sessions.mcvr1: 'mCVR1: Has Address (Android)'
      ios - app_sessions.mcvr1: 'mCVR1: Has Address (iOS)'
    series_point_styles:
      android - app_sessions.mcvr1: square
      ios - app_sessions.mcvr1: diamond
    defaults_version: 1
    hidden_fields: []
    listen:
      Session Start Date: app_sessions.session_start_at_date
      Granularity: app_sessions.timeframe_picker
      Is New User: app_sessions.is_new_user
      Country: app_sessions.country
      Hub: app_sessions.hub_code
      Session Day of Week: app_sessions.session_start_at_day_of_week
    row: 13
    col: 12
    width: 12
    height: 7
    title: mCVR2 per Platform
    name: mCVR2 per Platform
    model: flink_v3
    explore: app_sessions
    type: looker_column
    fields: [app_sessions.session_start_date_granularity, app_sessions.cnt_has_address,
      app_sessions.mcvr2, app_sessions.device_type]
    pivots: [app_sessions.device_type]
    filters: {}
    sorts: [app_sessions.device_type, app_sessions.session_start_date_granularity]
    limit: 500
    column_limit: 50
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
    stacking: normal
    limit_displayed_rows: false
    legend_position: center
    point_style: circle
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    color_application:
      collection_id: product-custom-collection
      palette_id: product-custom-collection-categorical-0
      options:
        steps: 5
    y_axes: [{label: "# Sessions with address", orientation: left, series: [{axisId: android
              - app_sessions.cnt_has_address, id: android - app_sessions.cnt_has_address,
            name: Sessions With Address (Android)}, {axisId: ios - app_sessions.cnt_has_address,
            id: ios - app_sessions.cnt_has_address, name: Sessions
              With Address (iOS)}], showLabels: true, showValues: true, unpinAxis: false,
        tickDensity: default, type: linear}, {label: '', orientation: right, series: [
          {axisId: android - app_sessions.mcvr2, id: android - app_sessions.mcvr2,
            name: 'mCVR2: Product Added To Cart (Android)'}, {axisId: ios - app_sessions.mcvr2,
            id: ios - app_sessions.mcvr2, name: 'mCVR2: Product Added
              To Cart (iOS)'}], showLabels: true, showValues: true, unpinAxis: false,
        tickDensity: default, type: linear}]
    x_axis_label: Session Start Date
    series_types:
      app_sessions.cnt_purchase: line
      app_sessions.overall_conversion_rate: line
      app_sessions.mcvr1: line
      app_sessions.mcvr2: line
      android - app_sessions.mcvr2: line
      ios - app_sessions.mcvr2: line
    series_colors:
      app_sessions.overall_conversion_rate: "#FBB555"
      app_sessions.count: "#75E2E2"
      app_sessions.mcvr1: "#FBB555"
      app_sessions.mcvr2: "#9174F0"
      android - app_sessions.mcvr2: "#9f71f0"
      ios - app_sessions.mcvr2: "#e21c79"
      android - app_sessions.cnt_has_address: "#d4d4d4"
      ios - app_sessions.cnt_has_address: "#ababab"
    series_labels:
      app_sessions.count: Number Of Sessions (30 min.)
      app_sessions.overall_conversion_rate: Conversion Rate
      app_sessions.mcvr1: 'mCVR1: Address Confirmed'
      app_sessions.mcvr2: 'mCVR2: Product Added To Cart'
      android - app_sessions.mcvr2: 'mCVR2: Product Added To Cart (Android)'
      ios - app_sessions.mcvr2: 'mCVR2: Product Added To Cart (iOS)'
      android - app_sessions.cnt_has_address: Sessions With Address
        (Android)
      ios - app_sessions.cnt_has_address: Sessions With Address (iOS)
    series_point_styles:
      android - app_sessions.mcvr2: square
      ios - app_sessions.mcvr2: diamond
    defaults_version: 1
    hidden_fields: []
    listen:
      Session Start Date: app_sessions.session_start_at_date
      Granularity: app_sessions.timeframe_picker
      Is New User: app_sessions.is_new_user
      Country: app_sessions.country
      Hub: app_sessions.hub_code
      Session Day of Week: app_sessions.session_start_at_day_of_week
    row: 20
    col: 12
    width: 12
    height: 6
  - title: mcvr1
    name: mcvr1
    model: flink_v3
    explore: app_sessions
    type: single_value
    fields: [app_sessions.mcvr1]
    filters: {}
    limit: 500
    column_limit: 50
    dynamic_fields: [{category: table_calculation, expression: 'sum(offset_list(${app_sessions.cnt_has_address},0,7))/sum(offset_list(${app_sessions.count},0,7))',
        label: overall conversion this week, value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: overall_conversion_this_week, _type_hint: number,
        is_disabled: true}, {category: table_calculation, expression: 'sum(offset_list(${app_sessions.cnt_has_address},7,7))/sum(offset_list(${app_sessions.count},7,7))',
        label: overall conversion last week, value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: overall_conversion_last_week, _type_hint: number,
        is_disabled: true}, {_kind_hint: measure, table_calculation: overall_conversion_diff,
        _type_hint: number, category: table_calculation, expression: "${overall_conversion_this_week}-${overall_conversion_last_week}",
        label: overall conversion diff, value_format: !!null '', value_format_name: percent_1,
        is_disabled: true}]
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    color_application:
      collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7
      palette_id: fb7bb53e-b77b-4ab6-8274-9d420d3d73f3
    custom_color: "#e21c79"
    single_value_title: mCVR1
    comparison_label: From Prior
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
    defaults_version: 1
    hidden_fields: [mcvr1_last_week, mcvr2_last_week, mcvr3_last_week, mcvr4_last_week]
    series_types: {}
    y_axes: []
    note_state: expanded
    note_display: hover
    note_text: mCVR1 = Sessions with address / All sessions
    listen:
      Platform: app_sessions.device_type
      Session Start Date: app_sessions.session_start_at_date
      Is New User: app_sessions.is_new_user
      Country: app_sessions.country
      Hub: app_sessions.hub_code
      Session Day of Week: app_sessions.session_start_at_day_of_week
    row: 4
    col: 8
    width: 3
    height: 2
  - title: mCVR3 per Platform
    name: mCVR3 per Platform
    model: flink_v3
    explore: app_sessions
    type: looker_column
    fields: [app_sessions.cnt_add_to_cart, app_sessions.mcvr3,
      app_sessions.device_type, app_sessions.session_start_date_granularity]
    pivots: [app_sessions.device_type]
    filters: {}
    sorts: [app_sessions.device_type, app_sessions.session_start_date_granularity]
    limit: 500
    column_limit: 50
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
    stacking: normal
    limit_displayed_rows: false
    legend_position: center
    point_style: circle
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    color_application:
      collection_id: product-custom-collection
      palette_id: product-custom-collection-categorical-0
      options:
        steps: 5
    y_axes: [{label: "# Sessions With Product Added To Cart", orientation: left, series: [
          {axisId: android - app_sessions.cnt_add_to_cart, id: android
              - app_sessions.cnt_add_to_cart, name: Sessions with Product
              Added To Cart (Android)}, {axisId: ios - app_sessions.cnt_add_to_cart,
            id: ios - app_sessions.cnt_add_to_cart, name: Sessions
              with Product Added To Cart (iOS)}], showLabels: true, showValues: true,
        unpinAxis: false, tickDensity: default, type: linear}, {label: !!null '',
        orientation: right, series: [{axisId: android - app_sessions.mcvr3,
            id: android - app_sessions.mcvr3, name: 'mCVR3: Checkout
              Started (Android)'}, {axisId: ios - app_sessions.mcvr3,
            id: ios - app_sessions.mcvr3, name: 'mCVR3: Checkout Started
              (iOS)'}], showLabels: true, showValues: true, unpinAxis: false, tickDensity: default,
        type: linear}]
    x_axis_label: Session Start Date
    series_types:
      app_sessions.cnt_purchase: line
      app_sessions.overall_conversion_rate: line
      app_sessions.mcvr1: line
      app_sessions.mcvr2: line
      app_sessions.mcvr3: line
      android - app_sessions.mcvr3: line
      ios - app_sessions.mcvr3: line
    series_colors:
      app_sessions.overall_conversion_rate: "#FBB555"
      app_sessions.count: "#75E2E2"
      app_sessions.mcvr1: "#FBB555"
      app_sessions.mcvr2: "#9174F0"
      app_sessions.mcvr3: "#B32F37"
      app_sessions.cnt_add_to_cart: "#9174F0"
      android - app_sessions.cnt_add_to_cart: "#d4d4d4"
      ios - app_sessions.cnt_add_to_cart: "#ababab"
      android - app_sessions.mcvr3: "#9f71f0"
      ios - app_sessions.mcvr3: "#e21c79"
    series_labels:
      app_sessions.count: Number Of Sessions (30 min.)
      app_sessions.overall_conversion_rate: Conversion Rate
      app_sessions.mcvr1: 'mCVR1: Address Confirmed'
      app_sessions.mcvr2: 'mCVR2: Product Added To Cart'
      app_sessions.cnt_add_to_cart: Sessions including Product Added
        To Cart
      app_sessions.mcvr3: 'mCVR3: Checkout Started'
      android - app_sessions.cnt_add_to_cart: Sessions with Product
        Added To Cart (Android)
      ios - app_sessions.cnt_add_to_cart: Sessions with Product Added
        To Cart (iOS)
      android - app_sessions.mcvr3: 'mCVR3: Checkout Started (Android)'
      ios - app_sessions.mcvr3: 'mCVR3: Checkout Started (iOS)'
    series_point_styles:
      android - app_sessions.mcvr3: square
      ios - app_sessions.mcvr3: diamond
    defaults_version: 1
    hidden_fields: []
    listen:
      Session Start Date: app_sessions.session_start_at_date
      Granularity: app_sessions.timeframe_picker
      Is New User: app_sessions.is_new_user
      Country: app_sessions.country
      Hub: app_sessions.hub_code
      Session Day of Week: app_sessions.session_start_at_day_of_week
    row: 26
    col: 12
    width: 12
    height: 7
  - title: mCVR4 per Platform
    name: mCVR4 per Platform
    model: flink_v3
    explore: app_sessions
    type: looker_column
    fields: [app_sessions.cnt_checkout_started, app_sessions.mcvr4,
      app_sessions.device_type, app_sessions.session_start_date_granularity]
    pivots: [app_sessions.device_type]
    filters: {}
    sorts: [app_sessions.device_type, app_sessions.session_start_date_granularity]
    limit: 500
    column_limit: 50
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
    stacking: normal
    limit_displayed_rows: false
    legend_position: center
    point_style: circle
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    color_application:
      collection_id: product-custom-collection
      palette_id: product-custom-collection-categorical-0
      options:
        steps: 5
    y_axes: [{label: "# Sessions With Checkout Started", orientation: left, series: [
          {axisId: android - app_sessions.cnt_checkout_started, id: android
              - app_sessions.cnt_checkout_started, name: Sessions with
              Checkout Started (Android)}, {axisId: ios - app_sessions.cnt_checkout_started,
            id: ios - app_sessions.cnt_checkout_started, name: Sessions
              with Checkout Started (iOS)}], showLabels: true, showValues: true, unpinAxis: false,
        tickDensity: default, type: linear}, {label: '', orientation: right, series: [
          {axisId: android - app_sessions.mcvr4, id: android - app_sessions.mcvr4,
            name: 'mCVR4: Payment Started (Android)'}, {axisId: ios - app_sessions.mcvr4,
            id: ios - app_sessions.mcvr4, name: 'mCVR4: Payment Started
              (iOS)'}], showLabels: true, showValues: true, unpinAxis: false, tickDensity: default,
        type: linear}]
    x_axis_label: Session Start Date
    series_types:
      app_sessions.cnt_purchase: line
      app_sessions.overall_conversion_rate: line
      app_sessions.mcvr1: line
      app_sessions.mcvr2: line
      app_sessions.mcvr3: line
      app_sessions.mcvr4: line
      android - app_sessions.mcvr4: line
      ios - app_sessions.mcvr4: line
    series_colors:
      app_sessions.overall_conversion_rate: "#FBB555"
      app_sessions.count: "#75E2E2"
      app_sessions.mcvr1: "#FBB555"
      app_sessions.mcvr2: "#9174F0"
      app_sessions.mcvr3: "#B32F37"
      app_sessions.cnt_add_to_cart: "#9174F0"
      app_sessions.mcvr4: "#E57947"
      app_sessions.cnt_checkout_started: "#B32F37"
      android - app_sessions.cnt_checkout_started: "#d4d4d4"
      ios - app_sessions.cnt_checkout_started: "#ababab"
      android - app_sessions.mcvr4: "#9f71f0"
      ios - app_sessions.mcvr4: "#e21c79"
    series_labels:
      app_sessions.count: Number Of Sessions (30 min.)
      app_sessions.overall_conversion_rate: Conversion Rate
      app_sessions.mcvr1: 'mCVR1: Address Confirmed'
      app_sessions.mcvr2: 'mCVR2: Product Added To Cart'
      app_sessions.cnt_add_to_cart: Sessions including Product Added
        To Cart
      app_sessions.mcvr3: 'mCVR3: Checkout Started'
      app_sessions.mcvr4: 'mCVR4: Payment Started'
      app_sessions.cnt_checkout_started: Sessions Including Checkout
        Started
      android - app_sessions.cnt_checkout_started: Sessions with Checkout
        Started (Android)
      ios - app_sessions.cnt_checkout_started: Sessions with Checkout
        Started (iOS)
      android - app_sessions.mcvr4: 'mCVR4: Payment Started (Android)'
      ios - app_sessions.mcvr4: 'mCVR4: Payment Started (iOS)'
    series_point_styles:
      android - app_sessions.mcvr4: square
      ios - app_sessions.mcvr4: diamond
    defaults_version: 1
    hidden_fields: []
    listen:
      Session Start Date: app_sessions.session_start_at_date
      Granularity: app_sessions.timeframe_picker
      Is New User: app_sessions.is_new_user
      Country: app_sessions.country
      Hub: app_sessions.hub_code
      Session Day of Week: app_sessions.session_start_at_day_of_week
    row: 33
    col: 12
    width: 12
    height: 7
  - name: " (2)"
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: '<img src="https://i.imgur.com/KcWQwrB.png" width="100%"> '
    row: 0
    col: 0
    width: 3
    height: 4
  - title: New Tile
    name: New Tile
    model: flink_v3
    explore: app_sessions
    type: single_value
    fields: [app_sessions.cnt_payment_started, app_sessions.cnt_purchase]
    filters:
      app_sessions.returning_customer: ''
    limit: 500
    column_limit: 50
    dynamic_fields: [{category: table_calculation, expression: "${app_sessions.cnt_purchase}/${app_sessions.cnt_payment_started}",
        label: mCVR5, value_format: !!null '', value_format_name: percent_1, _kind_hint: measure,
        table_calculation: mcvr5, _type_hint: number}, {_kind_hint: measure, table_calculation: mcvr5_last_week,
        _type_hint: number, category: table_calculation, expression: 'sum(offset_list(${app_sessions.cnt_purchase},7,7))/sum(offset_list(${app_sessions.cnt_payment_started},7,7))',
        label: mcvr5 last week, value_format: !!null '', value_format_name: percent_1,
        is_disabled: true}, {_kind_hint: measure, table_calculation: mcvr5_diff, _type_hint: number,
        category: table_calculation, expression: "${mcvr5_this_week}-${mcvr5_last_week}",
        label: mcvr5 diff, value_format: !!null '', value_format_name: percent_1,
        is_disabled: true}]
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    color_application:
      collection_id: product-custom-collection
      palette_id: product-custom-collection-categorical-0
    custom_color: ''
    single_value_title: Payment Completed
    comparison_label: From Prior
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
    defaults_version: 1
    hidden_fields: [mcvr1_last_week, mcvr2_last_week, mcvr3_last_week, mcvr4_last_week,
      app_sessions.cnt_payment_started, app_sessions.cnt_purchase]
    series_types: {}
    y_axes: []
    note_state: collapsed
    note_display: hover
    note_text: mCVR5 = Sessions with payment started / Sessions with order placed
    listen:
      Platform: app_sessions.device_type
      Session Start Date: app_sessions.session_start_at_date
      Is New User: app_sessions.is_new_user
      Country: app_sessions.country
      Hub: app_sessions.hub_code
      Session Day of Week: app_sessions.session_start_at_day_of_week
    row: 4
    col: 20
    width: 4
    height: 2
  - title: 'CVR & # Sessions'
    name: 'CVR & # Sessions'
    model: flink_v3
    explore: app_sessions
    type: looker_column
    fields: [app_sessions.count, app_sessions.overall_conversion_rate,
      app_sessions.session_start_date_granularity]
    sorts: [app_sessions.session_start_date_granularity]
    limit: 500
    column_limit: 50
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
    point_style: circle
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    color_application:
      collection_id: product-custom-collection
      palette_id: product-custom-collection-categorical-0
      options:
        steps: 5
    y_axes: [{label: "# Sessions", orientation: left, series: [{axisId: app_sessions.count,
            id: app_sessions.count, name: Number Of Sessions (30 min.)}],
        showLabels: true, showValues: true, valueFormat: '', unpinAxis: false, tickDensity: default,
        type: linear}, {label: '', orientation: left, series: [{axisId: app_sessions.overall_conversion_rate,
            id: app_sessions.overall_conversion_rate, name: Conversion
              Rate}], showLabels: true, showValues: true, unpinAxis: false, tickDensity: default,
        type: linear}]
    x_axis_label: Session Start Date
    series_types:
      app_sessions.cnt_purchase: line
      app_sessions.overall_conversion_rate: line
      android - app_sessions.overall_conversion_rate: line
      ios - app_sessions.overall_conversion_rate: line
      app_sessions.count: area
    series_colors:
      app_sessions.overall_conversion_rate: "#e21c79"
      app_sessions.count: "#c2c2c2"
      android - app_sessions.count: "#9eeaea"
      android - app_sessions.overall_conversion_rate: "#FBB555"
      ios - app_sessions.overall_conversion_rate: "#ffe48f"
      ios - app_sessions.count: "#d5f6f6"
    series_labels:
      app_sessions.count: Number Of Sessions (30 min.)
      app_sessions.overall_conversion_rate: Conversion Rate
      android - app_sessions.count: Android Number Of Sessions
      ios - app_sessions.count: iOS Number Of Sessions
      android - app_sessions.overall_conversion_rate: Android Conversion
        Rate
      ios - app_sessions.overall_conversion_rate: iOS Conversion Rate
    series_point_styles:
      android - app_sessions.overall_conversion_rate: square
      app_sessions.overall_conversion_rate: diamond
    defaults_version: 1
    hidden_fields: []
    note_state: collapsed
    note_display: below
    note_text: Max Session Duration is defined as 30 mins
    listen:
      Platform: app_sessions.device_type
      Session Start Date: app_sessions.session_start_at_date
      Granularity: app_sessions.timeframe_picker
      Is New User: app_sessions.is_new_user
      Country: app_sessions.country
      Hub: app_sessions.hub_code
      Session Day of Week: app_sessions.session_start_at_day_of_week
    row: 6
    col: 0
    width: 12
    height: 7
  - name: " (3)"
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: |-
      ><a href="https://docs.google.com/spreadsheets/d/1iN3CkrM8cYLnp6UEce-34c_ziF9p_sxhfEW3oDyfD_k/edit#gid=0"> KPI Glossary</a> <br>
      <b>CVR</b> = Sessions with order placed / All sessions <br>
      <b>mCVR1</b> = Sessions with address / All sessions<br>
      <b>mCVR2</b> = Sessions with product added to cart / Sessions with address<br>
      <b>mCVR3</b> = Sessions with checkout started / Sessions with product added to cart<br>
      <b>mCVR4</b> = Sessions with payment started / Sessions with checkout started<br>
      <b>Payment Completed</b> = Sessions with payment started / Sessions with order placed
    row: 0
    col: 3
    width: 15
    height: 4
  - title: mCVR1
    name: mCVR1
    model: flink_v3
    explore: app_sessions
    type: looker_column
    fields: [app_sessions.count, app_sessions.mcvr1,
      app_sessions.session_start_date_granularity]
    sorts: [app_sessions.session_start_date_granularity]
    limit: 500
    column_limit: 50
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
    stacking: normal
    limit_displayed_rows: false
    legend_position: center
    point_style: circle
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    color_application:
      collection_id: product-custom-collection
      palette_id: product-custom-collection-categorical-0
      options:
        steps: 5
    y_axes: [{label: Sessions Started, orientation: left, series: [{axisId: android
              - app_sessions.count, id: android - app_sessions.count,
            name: Sessions Started (Android)}, {axisId: ios - app_sessions.count,
            id: ios - app_sessions.count, name: Sessions Started (iOS)}],
        showLabels: true, showValues: true, unpinAxis: false, tickDensity: default,
        type: linear}, {label: '', orientation: right, series: [{axisId: android -
              app_sessions.mcvr1, id: android - app_sessions.mcvr1,
            name: 'mCVR1: Address Confirmed (Android)'}, {axisId: ios - app_sessions.mcvr1,
            id: ios - app_sessions.mcvr1, name: 'mCVR1: Address Confirmed
              (iOS)'}], showLabels: true, showValues: true, unpinAxis: false, tickDensity: default,
        type: linear}]
    x_axis_label: Session Start Date
    series_types:
      app_sessions.cnt_purchase: line
      app_sessions.overall_conversion_rate: line
      app_sessions.mcvr1: line
      android - app_sessions.mcvr1: line
      ios - app_sessions.mcvr1: line
      app_sessions.count: area
    series_colors:
      app_sessions.overall_conversion_rate: "#FBB555"
      app_sessions.count: "#c2c2c2"
      app_sessions.mcvr1: "#e21c79"
      android - app_sessions.count: "#9eeaea"
      android - app_sessions.mcvr1: "#4276BE"
      ios - app_sessions.mcvr1: "#7a9fd1"
      ios - app_sessions.count: "#d5f6f6"
    series_labels:
      app_sessions.count: "# Sessions"
      app_sessions.overall_conversion_rate: Conversion Rate
      app_sessions.mcvr1: 'mCVR1: Address Confirmed'
      android - app_sessions.count: Sessions Started (Android)
      ios - app_sessions.count: Sessions Started (iOS)
      android - app_sessions.mcvr1: 'mCVR1: Has Address (Android)'
      ios - app_sessions.mcvr1: 'mCVR1: Has Address (iOS)'
    series_point_styles:
      android - app_sessions.mcvr1: square
      app_sessions.mcvr1: diamond
    defaults_version: 1
    hidden_fields: []
    listen:
      Platform: app_sessions.device_type
      Session Start Date: app_sessions.session_start_at_date
      Granularity: app_sessions.timeframe_picker
      Is New User: app_sessions.is_new_user
      Country: app_sessions.country
      Hub: app_sessions.hub_code
      Session Day of Week: app_sessions.session_start_at_day_of_week
    row: 13
    col: 0
    width: 12
    height: 7
  - title: mCVR2
    name: mCVR2
    model: flink_v3
    explore: app_sessions
    type: looker_column
    fields: [app_sessions.session_start_date_granularity, app_sessions.cnt_has_address,
      app_sessions.mcvr2]
    sorts: [app_sessions.session_start_date_granularity]
    limit: 500
    column_limit: 50
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
    stacking: normal
    limit_displayed_rows: false
    legend_position: center
    point_style: circle
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    color_application:
      collection_id: product-custom-collection
      palette_id: product-custom-collection-categorical-0
      options:
        steps: 5
    y_axes: [{label: Sessions With Address, orientation: left, series: [{axisId: android
              - app_sessions.cnt_has_address, id: android - app_sessions.cnt_has_address,
            name: Sessions with Home Viewed (Android)}, {axisId: ios - app_sessions.cnt_has_address,
            id: ios - app_sessions.cnt_has_address, name: Sessions
              with Home Viewed (iOS)}], showLabels: true, showValues: true, unpinAxis: false,
        tickDensity: default, type: linear}, {label: '', orientation: right, series: [
          {axisId: android - app_sessions.mcvr2, id: android - app_sessions.mcvr2,
            name: Product Added To Cart (Android)}, {axisId: ios - app_sessions.mcvr2,
            id: ios - app_sessions.mcvr2, name: Product Added To Cart
              (iOS)}], showLabels: true, showValues: true, unpinAxis: false, tickDensity: default,
        type: linear}]
    x_axis_label: Session Start Date
    series_types:
      app_sessions.cnt_purchase: line
      app_sessions.overall_conversion_rate: line
      app_sessions.mcvr1: line
      app_sessions.mcvr2: line
      android - app_sessions.mcvr2: line
      ios - app_sessions.mcvr2: line
      app_sessions.cnt_has_address: area
    series_colors:
      app_sessions.overall_conversion_rate: "#FBB555"
      app_sessions.count: "#75E2E2"
      app_sessions.mcvr1: "#FBB555"
      app_sessions.mcvr2: "#e21c79"
      android - app_sessions.mcvr2: "#9d51f0"
      ios - app_sessions.mcvr2: "#ba85f4"
      android - app_sessions.cnt_has_address: "#7a9fd1"
      ios - app_sessions.cnt_has_address: "#c6d5eb"
      app_sessions.cnt_has_address: "#c2c2c2"
    series_labels:
      app_sessions.count: Number Of Sessions (30 min.)
      app_sessions.overall_conversion_rate: Conversion Rate
      app_sessions.mcvr1: 'mCVR1: Address Confirmed'
      app_sessions.mcvr2: 'mCVR2: Product Added To Cart'
      android - app_sessions.mcvr2: 'mCVR2: Product Added To Cart (Android)'
      ios - app_sessions.mcvr2: 'mCVR2: Product Added To Cart (iOS)'
      android - app_sessions.cnt_has_address: Sessions With Address
        (Android)
      ios - app_sessions.cnt_has_address: Sessions With Address (iOS)
    series_point_styles:
      android - app_sessions.mcvr2: square
      app_sessions.mcvr2: diamond
    defaults_version: 1
    hidden_fields: []
    listen:
      Platform: app_sessions.device_type
      Session Start Date: app_sessions.session_start_at_date
      Granularity: app_sessions.timeframe_picker
      Is New User: app_sessions.is_new_user
      Country: app_sessions.country
      Hub: app_sessions.hub_code
      Session Day of Week: app_sessions.session_start_at_day_of_week
    row: 20
    col: 0
    width: 12
    height: 6
  - title: mCVR3
    name: mCVR3
    model: flink_v3
    explore: app_sessions
    type: looker_column
    fields: [app_sessions.cnt_add_to_cart, app_sessions.mcvr3,
      app_sessions.session_start_date_granularity]
    filters: {}
    sorts: [app_sessions.session_start_date_granularity]
    limit: 500
    column_limit: 50
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
    stacking: normal
    limit_displayed_rows: false
    legend_position: center
    point_style: circle
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    color_application:
      collection_id: product-custom-collection
      palette_id: product-custom-collection-categorical-0
      options:
        steps: 5
    y_axes: [{label: Sessions With Product Added To Cart, orientation: left, series: [
          {axisId: android - app_sessions.cnt_add_to_cart, id: android
              - app_sessions.cnt_add_to_cart, name: Sessions with Product
              Added To Cart (Android)}, {axisId: ios - app_sessions.cnt_add_to_cart,
            id: ios - app_sessions.cnt_add_to_cart, name: Sessions
              with Product Added To Cart (iOS)}], showLabels: true, showValues: true,
        unpinAxis: false, tickDensity: default, type: linear}, {label: !!null '',
        orientation: right, series: [{axisId: android - app_sessions.mcvr3,
            id: android - app_sessions.mcvr3, name: 'mCVR3: Checkout
              Started (Android)'}, {axisId: ios - app_sessions.mcvr3,
            id: ios - app_sessions.mcvr3, name: 'mCVR3: Checkout Started
              (iOS)'}], showLabels: true, showValues: true, unpinAxis: false, tickDensity: default,
        type: linear}]
    x_axis_label: Session Start Date
    series_types:
      app_sessions.cnt_purchase: line
      app_sessions.overall_conversion_rate: line
      app_sessions.mcvr1: line
      app_sessions.mcvr2: line
      app_sessions.mcvr3: line
      android - app_sessions.mcvr3: line
      ios - app_sessions.mcvr3: line
      app_sessions.cnt_add_to_cart: area
    series_colors:
      app_sessions.overall_conversion_rate: "#FBB555"
      app_sessions.count: "#75E2E2"
      app_sessions.mcvr1: "#FBB555"
      app_sessions.mcvr2: "#9174F0"
      app_sessions.mcvr3: "#e21c79"
      app_sessions.cnt_add_to_cart: "#c2c2c2"
      android - app_sessions.cnt_add_to_cart: "#ba85f4"
      ios - app_sessions.cnt_add_to_cart: "#e1cafa"
      android - app_sessions.mcvr3: "#e5508e"
      ios - app_sessions.mcvr3: "#f7cadd"
    series_labels:
      app_sessions.count: Number Of Sessions (30 min.)
      app_sessions.overall_conversion_rate: Conversion Rate
      app_sessions.mcvr1: 'mCVR1: Address Confirmed'
      app_sessions.mcvr2: 'mCVR2: Product Added To Cart'
      app_sessions.cnt_add_to_cart: Sessions including Product Added
        To Cart
      app_sessions.mcvr3: 'mCVR3: Checkout Started'
      android - app_sessions.cnt_add_to_cart: Sessions with Product
        Added To Cart (Android)
      ios - app_sessions.cnt_add_to_cart: Sessions with Product Added
        To Cart (iOS)
      android - app_sessions.mcvr3: 'mCVR3: Checkout Started (Android)'
      ios - app_sessions.mcvr3: 'mCVR3: Checkout Started (iOS)'
    series_point_styles:
      android - app_sessions.mcvr3: square
      app_sessions.mcvr3: diamond
    defaults_version: 1
    hidden_fields: []
    listen:
      Platform: app_sessions.device_type
      Session Start Date: app_sessions.session_start_at_date
      Granularity: app_sessions.timeframe_picker
      Is New User: app_sessions.is_new_user
      Country: app_sessions.country
      Hub: app_sessions.hub_code
      Session Day of Week: app_sessions.session_start_at_day_of_week
    row: 26
    col: 0
    width: 12
    height: 7
  - title: mCVR4
    name: mCVR4
    model: flink_v3
    explore: app_sessions
    type: looker_column
    fields: [app_sessions.cnt_checkout_started, app_sessions.mcvr4,
      app_sessions.session_start_date_granularity]
    filters: {}
    sorts: [app_sessions.session_start_date_granularity]
    limit: 500
    column_limit: 50
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
    stacking: normal
    limit_displayed_rows: false
    legend_position: center
    point_style: circle
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    color_application:
      collection_id: product-custom-collection
      palette_id: product-custom-collection-categorical-0
      options:
        steps: 5
    y_axes: [{label: Sessions With Checkout Started, orientation: left, series: [
          {axisId: android - app_sessions.cnt_checkout_started, id: android
              - app_sessions.cnt_checkout_started, name: Sessions with
              Checkout Started (Android)}, {axisId: ios - app_sessions.cnt_checkout_started,
            id: ios - app_sessions.cnt_checkout_started, name: Sessions
              with Checkout Started (iOS)}], showLabels: true, showValues: true, unpinAxis: false,
        tickDensity: default, type: linear}, {label: '', orientation: right, series: [
          {axisId: android - app_sessions.mcvr4, id: android - app_sessions.mcvr4,
            name: 'mCVR4: Payment Started (Android)'}, {axisId: ios - app_sessions.mcvr4,
            id: ios - app_sessions.mcvr4, name: 'mCVR4: Payment Started
              (iOS)'}], showLabels: true, showValues: true, unpinAxis: false, tickDensity: default,
        type: linear}]
    x_axis_label: Session Start Date
    series_types:
      app_sessions.cnt_purchase: line
      app_sessions.overall_conversion_rate: line
      app_sessions.mcvr1: line
      app_sessions.mcvr2: line
      app_sessions.mcvr3: line
      app_sessions.mcvr4: line
      android - app_sessions.mcvr4: line
      ios - app_sessions.mcvr4: line
      app_sessions.cnt_checkout_started: area
    series_colors:
      app_sessions.overall_conversion_rate: "#FBB555"
      app_sessions.count: "#75E2E2"
      app_sessions.mcvr1: "#FBB555"
      app_sessions.mcvr2: "#9174F0"
      app_sessions.mcvr3: "#B32F37"
      app_sessions.cnt_add_to_cart: "#9174F0"
      app_sessions.mcvr4: "#e21c79"
      app_sessions.cnt_checkout_started: "#c2c2c2"
      android - app_sessions.cnt_checkout_started: "#ec84af"
      ios - app_sessions.cnt_checkout_started: "#f7cadd"
      android - app_sessions.mcvr4: "#f98662"
      ios - app_sessions.mcvr4: "#fccec0"
    series_labels:
      app_sessions.count: Number Of Sessions (30 min.)
      app_sessions.overall_conversion_rate: Conversion Rate
      app_sessions.mcvr1: 'mCVR1: Address Confirmed'
      app_sessions.mcvr2: 'mCVR2: Product Added To Cart'
      app_sessions.cnt_add_to_cart: Sessions including Product Added
        To Cart
      app_sessions.mcvr3: 'mCVR3: Checkout Started'
      app_sessions.mcvr4: 'mCVR4: Payment Started'
      app_sessions.cnt_checkout_started: Sessions Including Checkout
        Started
      android - app_sessions.cnt_checkout_started: Sessions with Checkout
        Started (Android)
      ios - app_sessions.cnt_checkout_started: Sessions with Checkout
        Started (iOS)
      android - app_sessions.mcvr4: 'mCVR4: Payment Started (Android)'
      ios - app_sessions.mcvr4: 'mCVR4: Payment Started (iOS)'
    series_point_styles:
      android - app_sessions.mcvr4: square
      app_sessions.mcvr4: diamond
    defaults_version: 1
    hidden_fields: []
    listen:
      Platform: app_sessions.device_type
      Session Start Date: app_sessions.session_start_at_date
      Granularity: app_sessions.timeframe_picker
      Is New User: app_sessions.is_new_user
      Country: app_sessions.country
      Hub: app_sessions.hub_code
      Session Day of Week: app_sessions.session_start_at_day_of_week
    row: 33
    col: 0
    width: 12
    height: 7
  filters:
  - name: Platform
    title: Platform
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: button_group
      display: inline
      options: []
    model: flink_v3
    explore: app_sessions
    listens_to_filters: []
    field: app_sessions.device_type
  - name: Session Start Date
    title: Session Start Date
    type: field_filter
    default_value: 30 day ago for 30 day
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
      options: []
    model: flink_v3
    explore: app_sessions
    listens_to_filters: []
    field: app_sessions.session_start_at_date
  - name: Granularity
    title: Granularity
    type: field_filter
    default_value: Day
    allow_multiple_values: true
    required: false
    ui_config:
      type: button_toggles
      display: popover
      options: []
    model: flink_v3
    explore: app_sessions
    listens_to_filters: []
    field: app_sessions.timeframe_picker
  - name: Is New User
    title: Is New User
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: button_group
      display: inline
      options: []
    model: flink_v3
    explore: app_sessions
    listens_to_filters: []
    field: app_sessions.is_new_user
  - name: Country
    title: Country
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: button_group
      display: popover
      options: []
    model: flink_v3
    explore: app_sessions
    listens_to_filters: []
    field: app_sessions.country
  - name: Hub
    title: Hub
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: popover
      options: []
    model: flink_v3
    explore: app_sessions
    listens_to_filters: [Country]
    field: app_sessions.hub_code
  - name: Session Day of Week
    title: Session Day of Week
    type: field_filter
    default_value: Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday
    allow_multiple_values: true
    required: false
    ui_config:
      type: checkboxes
      display: popover
      options: []
    model: flink_v3
    explore: app_sessions
    listens_to_filters: []
    field: app_sessions.session_start_at_day_of_week
