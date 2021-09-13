- dashboard: copy_product_main
  title: COPY Product Main
  layout: newspaper
  preferred_viewer: dashboards-next
  crossfilter_enabled: true
  elements:
  - name: Conversion Overview AVG Last 7 Days
    type: text
    title_text: Conversion Overview AVG Last 7 Days
    subtitle_text: ''
    body_text: ''
    row: 0
    col: 7
    width: 10
    height: 3
  - title: Sessions Per Platform
    name: Sessions Per Platform
    model: flink_v3
    explore: segment_tracking_sessions30
    type: looker_pie
    fields: [segment_tracking_sessions30.cnt_purchase, segment_tracking_sessions30.overall_conversion_rate,
      segment_tracking_sessions30.context_device_type, segment_tracking_sessions30.count]
    filters: {}
    sorts: [segment_tracking_sessions30.cnt_purchase desc]
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
      android: "#9eeaea"
      ios: "#d5f6f6"
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
    hidden_fields: [segment_tracking_sessions30.overall_conversion_rate, segment_tracking_sessions30.cnt_purchase]
    series_types: {}
    font_size: 12
    hidden_points_if_no: []
    y_axes: []
    note_state: expanded
    note_display: hover
    note_text: Click on platform to filter the board for that platform only
    listen:
      Country: segment_tracking_sessions30.country
      Session Start At Date: segment_tracking_sessions30.session_start_at_date
      Platform: segment_tracking_sessions30.context_device_type
      Hub: segment_tracking_sessions30.hub_code
      Returning Customer (Yes / No): segment_tracking_sessions30.returning_customer
      Is User's First Session (Yes / No): segment_tracking_sessions30.is_first_session
    row: 3
    col: 19
    width: 5
    height: 4
  - title: mcvr2
    name: mcvr2
    model: flink_v3
    explore: segment_tracking_sessions30
    type: single_value
    fields: [segment_tracking_sessions30.session_start_at_date, segment_tracking_sessions30.mcvr2,
      segment_tracking_sessions30.cnt_add_to_cart, segment_tracking_sessions30.cnt_has_address]
    fill_fields: [segment_tracking_sessions30.session_start_at_date]
    filters:
      segment_tracking_sessions30.session_start_at_date: 14 days ago for 14 days
    sorts: [segment_tracking_sessions30.session_start_at_date desc]
    limit: 500
    column_limit: 50
    dynamic_fields: [{category: table_calculation, expression: 'sum(offset_list(${segment_tracking_sessions30.cnt_add_to_cart},0,7))/sum(offset_list(${segment_tracking_sessions30.cnt_has_address},0,7))',
        label: mcvr2 this week, value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: mcvr2_this_week, _type_hint: number},
      {category: table_calculation, expression: 'sum(offset_list(${segment_tracking_sessions30.cnt_add_to_cart},7,7))/sum(offset_list(${segment_tracking_sessions30.cnt_has_address},7,7))',
        label: mcvr2 last week, value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: mcvr2_last_week, _type_hint: number},
      {_kind_hint: measure, table_calculation: mcvr2_diff, _type_hint: number, category: table_calculation,
        expression: "${mcvr2_this_week}-${mcvr2_last_week}", label: mcvr2 diff, value_format: !!null '',
        value_format_name: percent_1}]
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    color_application:
      collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7
      palette_id: fb7bb53e-b77b-4ab6-8274-9d420d3d73f3
    custom_color: "#9174F0"
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
    hidden_fields: [segment_tracking_sessions30.session_start_at_date, mcvr1_last_week,
      segment_tracking_sessions30.mcvr2, mcvr2_last_week, segment_tracking_sessions30.cnt_add_to_cart,
      segment_tracking_sessions30.cnt_has_address]
    series_types: {}
    y_axes: []
    note_state: collapsed
    note_display: hover
    note_text: In what % of sessions did the user add a product to the cart, compared
      to the number of sessions in which the user had an address (and was therefore
      able to add a product to cart)? (= sessions with product added to cart / sessions
      with address)
    listen:
      Country: segment_tracking_sessions30.country
      Platform: segment_tracking_sessions30.context_device_type
      Hub: segment_tracking_sessions30.hub_code
      Returning Customer (Yes / No): segment_tracking_sessions30.returning_customer
      Is User's First Session (Yes / No): segment_tracking_sessions30.is_first_session
    row: 3
    col: 10
    width: 5
    height: 2
  - title: mcvr3
    name: mcvr3
    model: flink_v3
    explore: segment_tracking_sessions30
    type: single_value
    fields: [segment_tracking_sessions30.session_start_at_date, segment_tracking_sessions30.mcvr3,
      segment_tracking_sessions30.cnt_add_to_cart, segment_tracking_sessions30.cnt_checkout_started]
    fill_fields: [segment_tracking_sessions30.session_start_at_date]
    filters:
      segment_tracking_sessions30.session_start_at_date: 14 days ago for 14 days
    sorts: [segment_tracking_sessions30.session_start_at_date desc]
    limit: 500
    column_limit: 50
    dynamic_fields: [{_kind_hint: measure, table_calculation: mcvr3_this_week, _type_hint: number,
        category: table_calculation, expression: 'sum(offset_list(${segment_tracking_sessions30.cnt_checkout_started},0,7))/sum(offset_list(${segment_tracking_sessions30.cnt_add_to_cart},0,7))',
        label: mcvr3 this week, value_format: !!null '', value_format_name: percent_1},
      {_kind_hint: measure, table_calculation: mcvr3_last_week, _type_hint: number,
        category: table_calculation, expression: 'sum(offset_list(${segment_tracking_sessions30.cnt_checkout_started},7,7))/sum(offset_list(${segment_tracking_sessions30.cnt_add_to_cart},7,7))',
        label: mcvr3 last week, value_format: !!null '', value_format_name: percent_1},
      {_kind_hint: measure, table_calculation: mcvr3_diff, _type_hint: number, category: table_calculation,
        expression: "${mcvr3_this_week}-${mcvr3_last_week}", label: mcvr3 diff, value_format: !!null '',
        value_format_name: percent_1}]
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
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
    hidden_fields: [segment_tracking_sessions30.session_start_at_date, mcvr1_last_week,
      mcvr2_last_week, segment_tracking_sessions30.mcvr3, mcvr3_last_week, segment_tracking_sessions30.cnt_checkout_started,
      segment_tracking_sessions30.cnt_add_to_cart]
    series_types: {}
    y_axes: []
    note_state: collapsed
    note_display: hover
    note_text: In what % of sessions was checkout started, compared to the number
      of sessions in which a product was added to cart? (= sessions with checkout
      started / sessions with product added to cart)
    listen:
      Country: segment_tracking_sessions30.country
      Platform: segment_tracking_sessions30.context_device_type
      Hub: segment_tracking_sessions30.hub_code
      Returning Customer (Yes / No): segment_tracking_sessions30.returning_customer
      Is User's First Session (Yes / No): segment_tracking_sessions30.is_first_session
    row: 5
    col: 5
    width: 5
    height: 2
  - title: mcvr4
    name: mcvr4
    model: flink_v3
    explore: segment_tracking_sessions30
    type: single_value
    fields: [segment_tracking_sessions30.session_start_at_date, segment_tracking_sessions30.mcvr4,
      segment_tracking_sessions30.cnt_checkout_started, segment_tracking_sessions30.cnt_payment_started]
    fill_fields: [segment_tracking_sessions30.session_start_at_date]
    filters:
      segment_tracking_sessions30.session_start_at_date: 14 days ago for 14 days
    sorts: [segment_tracking_sessions30.session_start_at_date desc]
    limit: 500
    column_limit: 50
    dynamic_fields: [{_kind_hint: measure, table_calculation: mcvr4_this_week, _type_hint: number,
        category: table_calculation, expression: 'sum(offset_list(${segment_tracking_sessions30.cnt_payment_started},0,7))/sum(offset_list(${segment_tracking_sessions30.cnt_checkout_started},0,7))',
        label: mcvr4 this week, value_format: !!null '', value_format_name: percent_1},
      {_kind_hint: measure, table_calculation: mcvr4_last_week, _type_hint: number,
        category: table_calculation, expression: 'sum(offset_list(${segment_tracking_sessions30.cnt_payment_started},7,7))/sum(offset_list(${segment_tracking_sessions30.cnt_checkout_started},7,7))',
        label: mcvr4 last week, value_format: !!null '', value_format_name: percent_1},
      {_kind_hint: measure, table_calculation: mcvr4_diff, _type_hint: number, category: table_calculation,
        expression: "${mcvr4_this_week}-${mcvr4_last_week}", label: mcvr4 diff, value_format: !!null '',
        value_format_name: percent_1}]
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    color_application:
      collection_id: product-custom-collection
      palette_id: product-custom-collection-categorical-0
    custom_color: "#f98662"
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
    hidden_fields: [segment_tracking_sessions30.session_start_at_date, mcvr1_last_week,
      mcvr2_last_week, mcvr3_last_week, segment_tracking_sessions30.mcvr4, mcvr4_last_week,
      segment_tracking_sessions30.cnt_checkout_started, segment_tracking_sessions30.cnt_payment_started]
    series_types: {}
    y_axes: []
    note_state: collapsed
    note_display: hover
    note_text: In what % of sessions was payment started, compared to the number of
      sessions in which checkout was started? (=sessions with payment started / sessions
      with checkout started)
    listen:
      Country: segment_tracking_sessions30.country
      Platform: segment_tracking_sessions30.context_device_type
      Hub: segment_tracking_sessions30.hub_code
      Returning Customer (Yes / No): segment_tracking_sessions30.returning_customer
      Is User's First Session (Yes / No): segment_tracking_sessions30.is_first_session
    row: 5
    col: 10
    width: 5
    height: 2
  - title: Conversion Rate
    name: Conversion Rate
    model: flink_v3
    explore: segment_tracking_sessions30
    type: single_value
    fields: [segment_tracking_sessions30.session_start_at_date, segment_tracking_sessions30.count,
      segment_tracking_sessions30.cnt_purchase, segment_tracking_sessions30.overall_conversion_rate]
    fill_fields: [segment_tracking_sessions30.session_start_at_date]
    filters:
      segment_tracking_sessions30.session_start_at_date: 14 days ago for 14 days
    sorts: [segment_tracking_sessions30.session_start_at_date desc]
    limit: 500
    column_limit: 50
    dynamic_fields: [{_kind_hint: measure, table_calculation: overall_conversion_this_week,
        _type_hint: number, category: table_calculation, expression: 'sum(offset_list(${segment_tracking_sessions30.cnt_purchase},0,7))/sum(offset_list(${segment_tracking_sessions30.count},0,7))',
        label: overall conversion this week, value_format: !!null '', value_format_name: percent_1},
      {_kind_hint: measure, table_calculation: overall_conversion_last_week, _type_hint: number,
        category: table_calculation, expression: 'sum(offset_list(${segment_tracking_sessions30.cnt_purchase},7,7))/sum(offset_list(${segment_tracking_sessions30.count},7,7))',
        label: overall conversion last week, value_format: !!null '', value_format_name: percent_1},
      {_kind_hint: measure, table_calculation: overall_conversion_diff, _type_hint: number,
        category: table_calculation, expression: "${overall_conversion_this_week}-${overall_conversion_last_week}",
        label: overall conversion diff, value_format: !!null '', value_format_name: percent_1}]
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    color_application:
      collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7
      palette_id: fb7bb53e-b77b-4ab6-8274-9d420d3d73f3
    custom_color: "#FBB555"
    single_value_title: ''
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
    hidden_fields: [segment_tracking_sessions30.session_start_at_date, mcvr1_last_week,
      mcvr2_last_week, mcvr3_last_week, mcvr4_last_week, segment_tracking_sessions30.overall_conversion_rate,
      overall_conversion_last_week, segment_tracking_sessions30.count, segment_tracking_sessions30.cnt_purchase]
    series_types: {}
    y_axes: []
    note_state: collapsed
    note_display: hover
    note_text: In what % of sessions was an order placed, compared to the total number
      of sessions? (= sessions with order placed / all sessions)
    listen:
      Country: segment_tracking_sessions30.country
      Platform: segment_tracking_sessions30.context_device_type
      Hub: segment_tracking_sessions30.hub_code
      Returning Customer (Yes / No): segment_tracking_sessions30.returning_customer
      Is User's First Session (Yes / No): segment_tracking_sessions30.is_first_session
    row: 3
    col: 0
    width: 5
    height: 4
  - title: Conversion Overall Funnel
    name: Conversion Overall Funnel
    model: flink_v3
    explore: segment_tracking_sessions30
    type: looker_funnel
    fields: [segment_tracking_sessions30.count, segment_tracking_sessions30.cnt_has_address,
      segment_tracking_sessions30.cnt_home_viewed, segment_tracking_sessions30.cnt_add_to_cart,
      segment_tracking_sessions30.cnt_view_cart, segment_tracking_sessions30.cnt_checkout_started,
      segment_tracking_sessions30.cnt_payment_started, segment_tracking_sessions30.cnt_purchase]
    sorts: [segment_tracking_sessions30.cnt_add_to_cart desc]
    limit: 500
    column_limit: 50
    dynamic_fields: [{_kind_hint: measure, table_calculation: session_started_30_min,
        _type_hint: number, category: table_calculation, expression: "${segment_tracking_sessions30.count}",
        label: Session Started (30 min.), value_format: !!null '', value_format_name: !!null ''},
      {_kind_hint: measure, table_calculation: location_pin_placed, _type_hint: number,
        category: table_calculation, expression: "${segment_tracking_sessions30.cnt_location_pin_placed}",
        label: Location Pin Placed, value_format: !!null '', value_format_name: !!null ''},
      {category: table_calculation, expression: "${segment_tracking_sessions30.cnt_has_address}",
        label: Has Address, value_format: !!null '', value_format_name: !!null '',
        _kind_hint: measure, table_calculation: has_address, _type_hint: number},
      {_kind_hint: measure, table_calculation: home_viewed, _type_hint: number, category: table_calculation,
        expression: "${segment_tracking_sessions30.cnt_home_viewed}", label: Home
          Viewed, value_format: !!null '', value_format_name: !!null ''}, {_kind_hint: measure,
        table_calculation: product_added_to_cart, _type_hint: number, category: table_calculation,
        expression: "${segment_tracking_sessions30.cnt_add_to_cart}", label: Product
          Added To Cart, value_format: !!null '', value_format_name: !!null ''}, {
        _kind_hint: measure, table_calculation: cart_viewed, _type_hint: number, category: table_calculation,
        expression: "${segment_tracking_sessions30.cnt_view_cart}", label: Cart Viewed,
        value_format: !!null '', value_format_name: !!null ''}, {_kind_hint: measure,
        table_calculation: checkout_started, _type_hint: number, category: table_calculation,
        expression: "${segment_tracking_sessions30.cnt_checkout_started}", label: Checkout
          Started, value_format: !!null '', value_format_name: !!null ''}, {_kind_hint: measure,
        table_calculation: payment_started, _type_hint: number, category: table_calculation,
        expression: "${segment_tracking_sessions30.cnt_payment_started}", label: Payment
          Started, value_format: !!null '', value_format_name: !!null ''}, {_kind_hint: measure,
        table_calculation: order_placed, _type_hint: number, category: table_calculation,
        expression: "${segment_tracking_sessions30.cnt_purchase}", label: Order Placed,
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
      collection_id: product-custom-collection
      custom:
        id: 4865d5d2-c68e-7742-1aaa-0ab50121cdbf
        label: Custom
        type: discrete
        colors:
        - "#75E2E2"
        - "#4276BE"
        - "#604fc1"
        - "#9174F0"
        - "#B1399E"
        - "#f98662"
        - "#FFD95F"
        - "#C2DD67"
        - "#72D16D"
      options:
        steps: 5
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
    hidden_fields: [segment_tracking_sessions30.count, segment_tracking_sessions30.cnt_home_viewed,
      segment_tracking_sessions30.cnt_add_to_cart, segment_tracking_sessions30.cnt_view_cart,
      segment_tracking_sessions30.cnt_checkout_started, segment_tracking_sessions30.cnt_payment_started,
      segment_tracking_sessions30.cnt_purchase, segment_tracking_sessions30.cnt_has_address,
      location_pin_placed, home_viewed]
    y_axes: []
    listen:
      Country: segment_tracking_sessions30.country
      Session Start At Date: segment_tracking_sessions30.session_start_at_date
      Platform: segment_tracking_sessions30.context_device_type
      Hub: segment_tracking_sessions30.hub_code
      Returning Customer (Yes / No): segment_tracking_sessions30.returning_customer
      Is User's First Session (Yes / No): segment_tracking_sessions30.is_first_session
    row: 21
    col: 12
    width: 12
    height: 7
  - title: Conversion Over Time
    name: Conversion Over Time
    model: flink_v3
    explore: segment_tracking_sessions30
    type: looker_column
    fields: [segment_tracking_sessions30.count, segment_tracking_sessions30.overall_conversion_rate,
      segment_tracking_sessions30.context_device_type, segment_tracking_sessions30.session_start_date_granularity]
    pivots: [segment_tracking_sessions30.context_device_type]
    filters: {}
    sorts: [segment_tracking_sessions30.context_device_type, segment_tracking_sessions30.session_start_date_granularity]
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
              - segment_tracking_sessions30.count, id: android - segment_tracking_sessions30.count,
            name: Android Number Of Sessions}, {axisId: ios - segment_tracking_sessions30.count,
            id: ios - segment_tracking_sessions30.count, name: iOS Number Of Sessions}],
        showLabels: true, showValues: true, unpinAxis: false, tickDensity: default,
        type: linear}, {label: Conversion Rate, orientation: right, series: [{axisId: android
              - segment_tracking_sessions30.overall_conversion_rate, id: android -
              segment_tracking_sessions30.overall_conversion_rate, name: Android Conversion
              Rate}, {axisId: ios - segment_tracking_sessions30.overall_conversion_rate,
            id: ios - segment_tracking_sessions30.overall_conversion_rate, name: iOS
              Conversion Rate}], showLabels: true, showValues: true, maxValue: !!null '',
        minValue: 0, unpinAxis: false, tickDensity: default, type: linear}]
    x_axis_label: Session Start Date
    series_types:
      segment_tracking_sessions30.cnt_purchase: line
      segment_tracking_sessions30.overall_conversion_rate: line
      android - segment_tracking_sessions30.overall_conversion_rate: line
      ios - segment_tracking_sessions30.overall_conversion_rate: line
    series_colors:
      segment_tracking_sessions30.overall_conversion_rate: "#FBB555"
      segment_tracking_sessions30.count: "#75E2E2"
      android - segment_tracking_sessions30.count: "#9eeaea"
      android - segment_tracking_sessions30.overall_conversion_rate: "#FBB555"
      ios - segment_tracking_sessions30.overall_conversion_rate: "#ffe48f"
      ios - segment_tracking_sessions30.count: "#d5f6f6"
    series_labels:
      segment_tracking_sessions30.count: Number Of Sessions (30 min.)
      segment_tracking_sessions30.overall_conversion_rate: Conversion Rate
      android - segment_tracking_sessions30.count: Android Number Of Sessions
      ios - segment_tracking_sessions30.count: iOS Number Of Sessions
      android - segment_tracking_sessions30.overall_conversion_rate: Android Conversion
        Rate
      ios - segment_tracking_sessions30.overall_conversion_rate: iOS Conversion Rate
    series_point_styles:
      android - segment_tracking_sessions30.overall_conversion_rate: square
    defaults_version: 1
    hidden_fields: []
    listen:
      Session Start Date Granularity: segment_tracking_sessions30.timeframe_picker
      Country: segment_tracking_sessions30.country
      Session Start At Date: segment_tracking_sessions30.session_start_at_date
      Platform: segment_tracking_sessions30.context_device_type
      Hub: segment_tracking_sessions30.hub_code
      Returning Customer (Yes / No): segment_tracking_sessions30.returning_customer
      Is User's First Session (Yes / No): segment_tracking_sessions30.is_first_session
    row: 7
    col: 0
    width: 12
    height: 7
  - title: Conversion Per App Version
    name: Conversion Per App Version
    model: flink_v3
    explore: segment_tracking_sessions30
    type: looker_grid
    fields: [segment_tracking_sessions30.full_app_version, segment_tracking_sessions30.count,
      segment_tracking_sessions30.overall_conversion_rate, segment_tracking_sessions30.mcvr1,
      segment_tracking_sessions30.mcvr2, segment_tracking_sessions30.mcvr3, segment_tracking_sessions30.mcvr4]
    sorts: [segment_tracking_sessions30.count desc]
    limit: 500
    column_limit: 50
    total: true
    dynamic_fields: [{_kind_hint: measure, table_calculation: percent_of_total, _type_hint: number,
        category: table_calculation, expression: "${segment_tracking_sessions30.count}/sum(${segment_tracking_sessions30.count})",
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
    show_totals: true
    show_row_totals: true
    series_labels:
      segment_tracking_sessions30.overall_conversion_rate: Conversion Rate
      segment_tracking_sessions30.count: Number Of Sessions
      segment_tracking_sessions30.full_app_version: App Version
      segment_tracking_sessions30.mcvr1: 'mCVR1: Address Confirmed'
      segment_tracking_sessions30.mcvr2: 'mCVR2: Product Added'
      segment_tracking_sessions30.mcvr3: 'mCVR3: Checkout Started'
      segment_tracking_sessions30.mcvr4: 'mCVR4: Payment Started'
    series_cell_visualizations:
      segment_tracking_sessions30.count:
        is_active: true
        palette:
          palette_id: 85de97da-2ded-4dec-9dbd-e6a7d36d5825
          collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7
    series_text_format:
      segment_tracking_sessions30.full_app_version: {}
    conditional_formatting: [{type: along a scale..., value: !!null '', background_color: !!null '',
        font_color: !!null '', color_application: {collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7,
          custom: {id: 34c5ef35-7a19-1abf-db65-b50f4362f118, label: Custom, type: continuous,
            stops: [{color: "#f9cd3e", offset: 0}, {color: "#ffffff", offset: 100}]},
          options: {steps: 5, constraints: {min: {type: percentile, value: 10}, max: {
                type: percentile, value: 90}, mid: {type: middle}}, mirror: false,
            stepped: false, reverse: false}}, bold: false, italic: false, strikethrough: false,
        fields: [segment_tracking_sessions30.overall_conversion_rate]}, {type: along
          a scale..., value: !!null '', background_color: !!null '', font_color: !!null '',
        color_application: {collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7, palette_id: 85de97da-2ded-4dec-9dbd-e6a7d36d5825,
          options: {steps: 5, reverse: true, constraints: {min: {type: number, value: 0.1},
              max: {type: number, value: 0.5}}}}, bold: false, italic: false, strikethrough: false,
        fields: [segment_tracking_sessions30.mcvr1]}, {type: along a scale..., value: !!null '',
        background_color: !!null '', font_color: !!null '', color_application: {collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7,
          custom: {id: 0ac7b200-63df-df75-5a8c-5600e5a62c12, label: Custom, type: continuous,
            stops: [{color: "#ffffff", offset: 0}, {color: "#5b64d6", offset: 50},
              {color: "#483ebf", offset: 100}]}, options: {steps: 5, reverse: true,
            constraints: {max: {type: number, value: 0.5}, min: {type: number, value: 0.1},
              mid: {type: middle}}}}, bold: false, italic: false, strikethrough: false,
        fields: [segment_tracking_sessions30.mcvr2]}, {type: along a scale..., value: !!null '',
        background_color: !!null '', font_color: !!null '', color_application: {collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7,
          custom: {id: 98b24405-6be0-5236-5644-5bc0b6c987c8, label: Custom, type: continuous,
            stops: [{color: "#ffffff", offset: 0}, {color: "#e5508e", offset: 100}]},
          options: {steps: 5, reverse: true, constraints: {min: {type: number, value: 0.1},
              max: {type: number, value: 0.8}}}}, bold: false, italic: false, strikethrough: false,
        fields: [segment_tracking_sessions30.mcvr3]}, {type: along a scale..., value: !!null '',
        background_color: !!null '', font_color: !!null '', color_application: {collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7,
          custom: {id: c28106dc-76a8-fd37-510d-43b7968e0262, label: Custom, type: continuous,
            stops: [{color: "#ffffff", offset: 0}, {color: "#f98662", offset: 100}]},
          options: {steps: 5, reverse: true, constraints: {min: {type: number, value: 0.1},
              max: {type: number, value: 0.8}}}}, bold: false, italic: false, strikethrough: false,
        fields: [segment_tracking_sessions30.mcvr4]}]
    series_types: {}
    defaults_version: 1
    column_order: ["$$$_row_numbers_$$$", segment_tracking_sessions30.full_app_version,
      segment_tracking_sessions30.count, percent_of_total, segment_tracking_sessions30.overall_conversion_rate,
      segment_tracking_sessions30.mcvr1, segment_tracking_sessions30.mcvr2, segment_tracking_sessions30.mcvr3,
      segment_tracking_sessions30.mcvr4]
    series_column_widths:
      percent_of_total: 132
    hidden_fields: []
    y_axes: []
    listen:
      Country: segment_tracking_sessions30.country
      Session Start At Date: segment_tracking_sessions30.session_start_at_date
      Platform: segment_tracking_sessions30.context_device_type
      Hub: segment_tracking_sessions30.hub_code
      Returning Customer (Yes / No): segment_tracking_sessions30.returning_customer
      Is User's First Session (Yes / No): segment_tracking_sessions30.is_first_session
    row: 28
    col: 0
    width: 24
    height: 9
  - title: mCVR1 Over Time
    name: mCVR1 Over Time
    model: flink_v3
    explore: segment_tracking_sessions30
    type: looker_column
    fields: [segment_tracking_sessions30.count, segment_tracking_sessions30.mcvr1,
      segment_tracking_sessions30.context_device_type, segment_tracking_sessions30.session_start_date_granularity]
    pivots: [segment_tracking_sessions30.context_device_type]
    filters: {}
    sorts: [segment_tracking_sessions30.context_device_type, segment_tracking_sessions30.session_start_date_granularity]
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
              - segment_tracking_sessions30.count, id: android - segment_tracking_sessions30.count,
            name: Sessions Started (Android)}, {axisId: ios - segment_tracking_sessions30.count,
            id: ios - segment_tracking_sessions30.count, name: Sessions Started (iOS)}],
        showLabels: true, showValues: true, unpinAxis: false, tickDensity: default,
        type: linear}, {label: '', orientation: right, series: [{axisId: android -
              segment_tracking_sessions30.mcvr1, id: android - segment_tracking_sessions30.mcvr1,
            name: 'mCVR1: Address Confirmed (Android)'}, {axisId: ios - segment_tracking_sessions30.mcvr1,
            id: ios - segment_tracking_sessions30.mcvr1, name: 'mCVR1: Address Confirmed
              (iOS)'}], showLabels: true, showValues: true, unpinAxis: false, tickDensity: default,
        type: linear}]
    x_axis_label: Session Start Date
    series_types:
      segment_tracking_sessions30.cnt_purchase: line
      segment_tracking_sessions30.overall_conversion_rate: line
      segment_tracking_sessions30.mcvr1: line
      android - segment_tracking_sessions30.mcvr1: line
      ios - segment_tracking_sessions30.mcvr1: line
    series_colors:
      segment_tracking_sessions30.overall_conversion_rate: "#FBB555"
      segment_tracking_sessions30.count: "#75E2E2"
      segment_tracking_sessions30.mcvr1: "#4276BE"
      android - segment_tracking_sessions30.count: "#9eeaea"
      android - segment_tracking_sessions30.mcvr1: "#4276BE"
      ios - segment_tracking_sessions30.mcvr1: "#7a9fd1"
      ios - segment_tracking_sessions30.count: "#d5f6f6"
    series_labels:
      segment_tracking_sessions30.count: Number Of Sessions (30 min.)
      segment_tracking_sessions30.overall_conversion_rate: Conversion Rate
      segment_tracking_sessions30.mcvr1: 'mCVR1: Address Confirmed'
      android - segment_tracking_sessions30.count: Sessions Started (Android)
      ios - segment_tracking_sessions30.count: Sessions Started (iOS)
      android - segment_tracking_sessions30.mcvr1: 'mCVR1: Has Address (Android)'
      ios - segment_tracking_sessions30.mcvr1: 'mCVR1: Has Address (iOS)'
    series_point_styles:
      android - segment_tracking_sessions30.mcvr1: square
    defaults_version: 1
    hidden_fields: []
    listen:
      Session Start Date Granularity: segment_tracking_sessions30.timeframe_picker
      Country: segment_tracking_sessions30.country
      Session Start At Date: segment_tracking_sessions30.session_start_at_date
      Platform: segment_tracking_sessions30.context_device_type
      Hub: segment_tracking_sessions30.hub_code
      Returning Customer (Yes / No): segment_tracking_sessions30.returning_customer
      Is User's First Session (Yes / No): segment_tracking_sessions30.is_first_session
    row: 7
    col: 12
    width: 12
    height: 7
  - title: mCVR2 Over Time
    name: mCVR2 Over Time
    model: flink_v3
    explore: segment_tracking_sessions30
    type: looker_column
    fields: [segment_tracking_sessions30.session_start_date_granularity, segment_tracking_sessions30.cnt_has_address,
      segment_tracking_sessions30.mcvr2, segment_tracking_sessions30.context_device_type]
    pivots: [segment_tracking_sessions30.context_device_type]
    filters: {}
    sorts: [segment_tracking_sessions30.context_device_type, segment_tracking_sessions30.session_start_date_granularity]
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
    y_axes: [{label: Sessions With Home Viewed, orientation: left, series: [{axisId: android
              - segment_tracking_sessions30.cnt_home_viewed, id: android - segment_tracking_sessions30.cnt_home_viewed,
            name: Sessions with Home Viewed (Android)}, {axisId: ios - segment_tracking_sessions30.cnt_home_viewed,
            id: ios - segment_tracking_sessions30.cnt_home_viewed, name: Sessions
              with Home Viewed (iOS)}], showLabels: true, showValues: true, unpinAxis: false,
        tickDensity: default, type: linear}, {label: '', orientation: right, series: [
          {axisId: android - segment_tracking_sessions30.mcvr2, id: android - segment_tracking_sessions30.mcvr2,
            name: Product Added To Cart (Android)}, {axisId: ios - segment_tracking_sessions30.mcvr2,
            id: ios - segment_tracking_sessions30.mcvr2, name: Product Added To Cart
              (iOS)}], showLabels: true, showValues: true, unpinAxis: false, tickDensity: default,
        type: linear}]
    x_axis_label: Session Start Date
    series_types:
      segment_tracking_sessions30.cnt_purchase: line
      segment_tracking_sessions30.overall_conversion_rate: line
      segment_tracking_sessions30.mcvr1: line
      segment_tracking_sessions30.mcvr2: line
      android - segment_tracking_sessions30.mcvr2: line
      ios - segment_tracking_sessions30.mcvr2: line
    series_colors:
      segment_tracking_sessions30.overall_conversion_rate: "#FBB555"
      segment_tracking_sessions30.count: "#75E2E2"
      segment_tracking_sessions30.mcvr1: "#FBB555"
      segment_tracking_sessions30.mcvr2: "#9174F0"
      segment_tracking_sessions30.cnt_home_viewed: "#592EC2"
      android - segment_tracking_sessions30.cnt_home_viewed: "#8f83d3"
      ios - segment_tracking_sessions30.cnt_home_viewed: "#cfcaec"
      android - segment_tracking_sessions30.mcvr2: "#9d51f0"
      ios - segment_tracking_sessions30.mcvr2: "#ba85f4"
      android - segment_tracking_sessions30.cnt_has_address: "#7a9fd1"
      ios - segment_tracking_sessions30.cnt_has_address: "#c6d5eb"
    series_labels:
      segment_tracking_sessions30.count: Number Of Sessions (30 min.)
      segment_tracking_sessions30.overall_conversion_rate: Conversion Rate
      segment_tracking_sessions30.mcvr1: 'mCVR1: Address Confirmed'
      segment_tracking_sessions30.mcvr2: 'mCVR2: Product Added To Cart'
      segment_tracking_sessions30.cnt_home_viewed: Sessions Including Home Viewed
      android - segment_tracking_sessions30.cnt_home_viewed: Sessions with Home Viewed
        (Android)
      ios - segment_tracking_sessions30.cnt_home_viewed: Sessions with Home Viewed
        (iOS)
      android - segment_tracking_sessions30.mcvr2: 'mCVR2: Product Added To Cart (Android)'
      ios - segment_tracking_sessions30.mcvr2: 'mCVR2: Product Added To Cart (iOS)'
      android - segment_tracking_sessions30.cnt_has_address: Sessions With Address
        (Android)
      ios - segment_tracking_sessions30.cnt_has_address: Sessions With Address (iOS)
    series_point_styles:
      android - segment_tracking_sessions30.mcvr2: square
    defaults_version: 1
    hidden_fields: []
    listen:
      Session Start Date Granularity: segment_tracking_sessions30.timeframe_picker
      Country: segment_tracking_sessions30.country
      Session Start At Date: segment_tracking_sessions30.session_start_at_date
      Platform: segment_tracking_sessions30.context_device_type
      Hub: segment_tracking_sessions30.hub_code
      Returning Customer (Yes / No): segment_tracking_sessions30.returning_customer
      Is User's First Session (Yes / No): segment_tracking_sessions30.is_first_session
    row: 14
    col: 0
    width: 12
    height: 7
  - title: mcvr1
    name: mcvr1
    model: flink_v3
    explore: segment_tracking_sessions30
    type: single_value
    fields: [segment_tracking_sessions30.session_start_at_date, segment_tracking_sessions30.count,
      segment_tracking_sessions30.cnt_has_address]
    fill_fields: [segment_tracking_sessions30.session_start_at_date]
    filters:
      segment_tracking_sessions30.session_start_at_date: 14 days ago for 14 days
    sorts: [segment_tracking_sessions30.session_start_at_date desc]
    limit: 500
    column_limit: 50
    dynamic_fields: [{category: table_calculation, expression: 'sum(offset_list(${segment_tracking_sessions30.cnt_has_address},0,7))/sum(offset_list(${segment_tracking_sessions30.count},0,7))',
        label: overall conversion this week, value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: overall_conversion_this_week, _type_hint: number},
      {category: table_calculation, expression: 'sum(offset_list(${segment_tracking_sessions30.cnt_has_address},7,7))/sum(offset_list(${segment_tracking_sessions30.count},7,7))',
        label: overall conversion last week, value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: overall_conversion_last_week, _type_hint: number},
      {_kind_hint: measure, table_calculation: overall_conversion_diff, _type_hint: number,
        category: table_calculation, expression: "${overall_conversion_this_week}-${overall_conversion_last_week}",
        label: overall conversion diff, value_format: !!null '', value_format_name: percent_1}]
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    color_application:
      collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7
      palette_id: fb7bb53e-b77b-4ab6-8274-9d420d3d73f3
    custom_color: "#4276BE"
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
    hidden_fields: [segment_tracking_sessions30.session_start_at_date, mcvr1_last_week,
      mcvr2_last_week, mcvr3_last_week, mcvr4_last_week, overall_conversion_last_week,
      segment_tracking_sessions30.count, segment_tracking_sessions30.cnt_has_address]
    series_types: {}
    y_axes: []
    note_state: expanded
    note_display: hover
    note_text: In what % of the sessions did the user have an address (either selected
      in the current session or a previous one), compared to all sessions? (= sessions
      with address / all sessions)
    listen:
      Country: segment_tracking_sessions30.country
      Platform: segment_tracking_sessions30.context_device_type
      Hub: segment_tracking_sessions30.hub_code
      Returning Customer (Yes / No): segment_tracking_sessions30.returning_customer
      Is User's First Session (Yes / No): segment_tracking_sessions30.is_first_session
    row: 3
    col: 5
    width: 5
    height: 2
  - title: mCVR3 Over Time
    name: mCVR3 Over Time
    model: flink_v3
    explore: segment_tracking_sessions30
    type: looker_column
    fields: [segment_tracking_sessions30.cnt_add_to_cart, segment_tracking_sessions30.mcvr3,
      segment_tracking_sessions30.context_device_type, segment_tracking_sessions30.session_start_date_granularity]
    pivots: [segment_tracking_sessions30.context_device_type]
    filters: {}
    sorts: [segment_tracking_sessions30.context_device_type, segment_tracking_sessions30.session_start_date_granularity]
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
          {axisId: android - segment_tracking_sessions30.cnt_add_to_cart, id: android
              - segment_tracking_sessions30.cnt_add_to_cart, name: Sessions with Product
              Added To Cart (Android)}, {axisId: ios - segment_tracking_sessions30.cnt_add_to_cart,
            id: ios - segment_tracking_sessions30.cnt_add_to_cart, name: Sessions
              with Product Added To Cart (iOS)}], showLabels: true, showValues: true,
        unpinAxis: false, tickDensity: default, type: linear}, {label: !!null '',
        orientation: right, series: [{axisId: android - segment_tracking_sessions30.mcvr3,
            id: android - segment_tracking_sessions30.mcvr3, name: 'mCVR3: Checkout
              Started (Android)'}, {axisId: ios - segment_tracking_sessions30.mcvr3,
            id: ios - segment_tracking_sessions30.mcvr3, name: 'mCVR3: Checkout Started
              (iOS)'}], showLabels: true, showValues: true, unpinAxis: false, tickDensity: default,
        type: linear}]
    x_axis_label: Session Start Date
    series_types:
      segment_tracking_sessions30.cnt_purchase: line
      segment_tracking_sessions30.overall_conversion_rate: line
      segment_tracking_sessions30.mcvr1: line
      segment_tracking_sessions30.mcvr2: line
      segment_tracking_sessions30.mcvr3: line
      android - segment_tracking_sessions30.mcvr3: line
      ios - segment_tracking_sessions30.mcvr3: line
    series_colors:
      segment_tracking_sessions30.overall_conversion_rate: "#FBB555"
      segment_tracking_sessions30.count: "#75E2E2"
      segment_tracking_sessions30.mcvr1: "#FBB555"
      segment_tracking_sessions30.mcvr2: "#9174F0"
      segment_tracking_sessions30.cnt_home_viewed: "#592EC2"
      segment_tracking_sessions30.mcvr3: "#B32F37"
      segment_tracking_sessions30.cnt_add_to_cart: "#9174F0"
      android - segment_tracking_sessions30.cnt_add_to_cart: "#ba85f4"
      ios - segment_tracking_sessions30.cnt_add_to_cart: "#e1cafa"
      android - segment_tracking_sessions30.mcvr3: "#e5508e"
      ios - segment_tracking_sessions30.mcvr3: "#f7cadd"
    series_labels:
      segment_tracking_sessions30.count: Number Of Sessions (30 min.)
      segment_tracking_sessions30.overall_conversion_rate: Conversion Rate
      segment_tracking_sessions30.mcvr1: 'mCVR1: Address Confirmed'
      segment_tracking_sessions30.mcvr2: 'mCVR2: Product Added To Cart'
      segment_tracking_sessions30.cnt_home_viewed: Sessions Including Home Viewed
      segment_tracking_sessions30.cnt_add_to_cart: Sessions including Product Added
        To Cart
      segment_tracking_sessions30.mcvr3: 'mCVR3: Checkout Started'
      android - segment_tracking_sessions30.cnt_add_to_cart: Sessions with Product
        Added To Cart (Android)
      ios - segment_tracking_sessions30.cnt_add_to_cart: Sessions with Product Added
        To Cart (iOS)
      android - segment_tracking_sessions30.mcvr3: 'mCVR3: Checkout Started (Android)'
      ios - segment_tracking_sessions30.mcvr3: 'mCVR3: Checkout Started (iOS)'
    series_point_styles:
      android - segment_tracking_sessions30.mcvr3: square
    defaults_version: 1
    hidden_fields: []
    listen:
      Session Start Date Granularity: segment_tracking_sessions30.timeframe_picker
      Country: segment_tracking_sessions30.country
      Session Start At Date: segment_tracking_sessions30.session_start_at_date
      Platform: segment_tracking_sessions30.context_device_type
      Hub: segment_tracking_sessions30.hub_code
      Returning Customer (Yes / No): segment_tracking_sessions30.returning_customer
      Is User's First Session (Yes / No): segment_tracking_sessions30.is_first_session
    row: 14
    col: 12
    width: 12
    height: 7
  - title: mCVR4 Over Time
    name: mCVR4 Over Time
    model: flink_v3
    explore: segment_tracking_sessions30
    type: looker_column
    fields: [segment_tracking_sessions30.cnt_checkout_started, segment_tracking_sessions30.mcvr4,
      segment_tracking_sessions30.context_device_type, segment_tracking_sessions30.session_start_date_granularity]
    pivots: [segment_tracking_sessions30.context_device_type]
    filters: {}
    sorts: [segment_tracking_sessions30.context_device_type, segment_tracking_sessions30.session_start_date_granularity]
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
          {axisId: android - segment_tracking_sessions30.cnt_checkout_started, id: android
              - segment_tracking_sessions30.cnt_checkout_started, name: Sessions with
              Checkout Started (Android)}, {axisId: ios - segment_tracking_sessions30.cnt_checkout_started,
            id: ios - segment_tracking_sessions30.cnt_checkout_started, name: Sessions
              with Checkout Started (iOS)}], showLabels: true, showValues: true, unpinAxis: false,
        tickDensity: default, type: linear}, {label: '', orientation: right, series: [
          {axisId: android - segment_tracking_sessions30.mcvr4, id: android - segment_tracking_sessions30.mcvr4,
            name: 'mCVR4: Payment Started (Android)'}, {axisId: ios - segment_tracking_sessions30.mcvr4,
            id: ios - segment_tracking_sessions30.mcvr4, name: 'mCVR4: Payment Started
              (iOS)'}], showLabels: true, showValues: true, unpinAxis: false, tickDensity: default,
        type: linear}]
    x_axis_label: Session Start Date
    series_types:
      segment_tracking_sessions30.cnt_purchase: line
      segment_tracking_sessions30.overall_conversion_rate: line
      segment_tracking_sessions30.mcvr1: line
      segment_tracking_sessions30.mcvr2: line
      segment_tracking_sessions30.mcvr3: line
      segment_tracking_sessions30.mcvr4: line
      android - segment_tracking_sessions30.mcvr4: line
      ios - segment_tracking_sessions30.mcvr4: line
    series_colors:
      segment_tracking_sessions30.overall_conversion_rate: "#FBB555"
      segment_tracking_sessions30.count: "#75E2E2"
      segment_tracking_sessions30.mcvr1: "#FBB555"
      segment_tracking_sessions30.mcvr2: "#9174F0"
      segment_tracking_sessions30.cnt_home_viewed: "#592EC2"
      segment_tracking_sessions30.mcvr3: "#B32F37"
      segment_tracking_sessions30.cnt_add_to_cart: "#9174F0"
      segment_tracking_sessions30.mcvr4: "#E57947"
      segment_tracking_sessions30.cnt_checkout_started: "#B32F37"
      android - segment_tracking_sessions30.cnt_checkout_started: "#ec84af"
      ios - segment_tracking_sessions30.cnt_checkout_started: "#f7cadd"
      android - segment_tracking_sessions30.mcvr4: "#f98662"
      ios - segment_tracking_sessions30.mcvr4: "#fccec0"
    series_labels:
      segment_tracking_sessions30.count: Number Of Sessions (30 min.)
      segment_tracking_sessions30.overall_conversion_rate: Conversion Rate
      segment_tracking_sessions30.mcvr1: 'mCVR1: Address Confirmed'
      segment_tracking_sessions30.mcvr2: 'mCVR2: Product Added To Cart'
      segment_tracking_sessions30.cnt_home_viewed: Sessions Including Home Viewed
      segment_tracking_sessions30.cnt_add_to_cart: Sessions including Product Added
        To Cart
      segment_tracking_sessions30.mcvr3: 'mCVR3: Checkout Started'
      segment_tracking_sessions30.mcvr4: 'mCVR4: Payment Started'
      segment_tracking_sessions30.cnt_checkout_started: Sessions Including Checkout
        Started
      android - segment_tracking_sessions30.cnt_checkout_started: Sessions with Checkout
        Started (Android)
      ios - segment_tracking_sessions30.cnt_checkout_started: Sessions with Checkout
        Started (iOS)
      android - segment_tracking_sessions30.mcvr4: 'mCVR4: Payment Started (Android)'
      ios - segment_tracking_sessions30.mcvr4: 'mCVR4: Payment Started (iOS)'
    series_point_styles:
      android - segment_tracking_sessions30.mcvr4: square
    defaults_version: 1
    hidden_fields: []
    listen:
      Session Start Date Granularity: segment_tracking_sessions30.timeframe_picker
      Country: segment_tracking_sessions30.country
      Session Start At Date: segment_tracking_sessions30.session_start_at_date
      Platform: segment_tracking_sessions30.context_device_type
      Hub: segment_tracking_sessions30.hub_code
      Returning Customer (Yes / No): segment_tracking_sessions30.returning_customer
      Is User's First Session (Yes / No): segment_tracking_sessions30.is_first_session
    row: 21
    col: 0
    width: 12
    height: 7
  - name: ''
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: "<img src=\"https://i.imgur.com/KcWQwrB.png\" width=\"50%\"> \n\nData\
      \ Refreshment Rate: <=1 hour"
    row: 0
    col: 0
    width: 6
    height: 3
  - name: " (2)"
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: |+
      <p align="center">
      Please see <a href="https://docs.google.com/spreadsheets/d/1iN3CkrM8cYLnp6UEce-34c_ziF9p_sxhfEW3oDyfD_k/edit#gid=0"> here</a> for Data Glossary with all KPI definitions.
      <br/><br/>
      NOTE: tracking data is missing for >70% of <I>iOS</I> users between app version iOS 2.1.1 (released 03.05.2021) and 2.3.0 (released 14.06.2021).
      </p>


    row: 0
    col: 17
    width: 7
    height: 3
  - title: New Tile
    name: New Tile
    model: flink_v3
    explore: segment_tracking_sessions30
    type: single_value
    fields: [segment_tracking_sessions30.session_start_at_date, segment_tracking_sessions30.cnt_payment_started,
      segment_tracking_sessions30.cnt_purchase]
    fill_fields: [segment_tracking_sessions30.session_start_at_date]
    filters:
      segment_tracking_sessions30.session_start_at_date: 14 days ago for 14 days
    sorts: [segment_tracking_sessions30.session_start_at_date desc]
    limit: 500
    column_limit: 50
    dynamic_fields: [{_kind_hint: measure, table_calculation: mcvr5_this_week, _type_hint: number,
        category: table_calculation, expression: 'sum(offset_list(${segment_tracking_sessions30.cnt_purchase},0,7))/sum(offset_list(${segment_tracking_sessions30.cnt_payment_started},0,7))',
        label: mcvr5 this week, value_format: !!null '', value_format_name: percent_1},
      {_kind_hint: measure, table_calculation: mcvr5_last_week, _type_hint: number,
        category: table_calculation, expression: 'sum(offset_list(${segment_tracking_sessions30.cnt_purchase},7,7))/sum(offset_list(${segment_tracking_sessions30.cnt_payment_started},7,7))',
        label: mcvr5 last week, value_format: !!null '', value_format_name: percent_1},
      {_kind_hint: measure, table_calculation: mcvr5_diff, _type_hint: number, category: table_calculation,
        expression: "${mcvr5_this_week}-${mcvr5_last_week}", label: mcvr5 diff, value_format: !!null '',
        value_format_name: percent_1}]
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
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
    hidden_fields: [segment_tracking_sessions30.session_start_at_date, mcvr1_last_week,
      mcvr2_last_week, mcvr3_last_week, mcvr4_last_week, segment_tracking_sessions30.cnt_payment_started,
      segment_tracking_sessions30.cnt_purchase, mcvr5_last_week]
    series_types: {}
    y_axes: []
    note_state: collapsed
    note_display: hover
    note_text: In what % of sessions was payment completed (order placed), compared
      to the number of sessions in which payment was started? (= sessions with payment
      started / sessions with order placed)
    listen:
      Country: segment_tracking_sessions30.country
      Platform: segment_tracking_sessions30.context_device_type
      Hub: segment_tracking_sessions30.hub_code
      Returning Customer (Yes / No): segment_tracking_sessions30.returning_customer
      Is User's First Session (Yes / No): segment_tracking_sessions30.is_first_session
    row: 3
    col: 15
    width: 4
    height: 4
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
    explore: segment_tracking_sessions30
    listens_to_filters: []
    field: segment_tracking_sessions30.context_device_type
  - name: Session Start At Date
    title: Session Start At Date
    type: field_filter
    default_value: 7 day
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
      options: []
    model: flink_v3
    explore: segment_tracking_sessions30
    listens_to_filters: []
    field: segment_tracking_sessions30.session_start_at_date
  - name: Session Start Date Granularity
    title: Session Start Date Granularity
    type: field_filter
    default_value: Day
    allow_multiple_values: true
    required: false
    ui_config:
      type: button_toggles
      display: popover
      options: []
    model: flink_v3
    explore: segment_tracking_sessions30
    listens_to_filters: []
    field: segment_tracking_sessions30.timeframe_picker
  - name: Returning Customer (Yes / No)
    title: Returning Customer (Yes / No)
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: button_group
      display: inline
      options: []
    model: flink_v3
    explore: segment_tracking_sessions30
    listens_to_filters: []
    field: segment_tracking_sessions30.returning_customer
  - name: Is User's First Session (Yes / No)
    title: Is User's First Session (Yes / No)
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: button_group
      display: inline
      options: []
    model: flink_v3
    explore: segment_tracking_sessions30
    listens_to_filters: []
    field: segment_tracking_sessions30.is_first_session
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
    explore: segment_tracking_sessions30
    listens_to_filters: []
    field: segment_tracking_sessions30.country
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
    explore: segment_tracking_sessions30
    listens_to_filters: [Country]
    field: segment_tracking_sessions30.hub_code
