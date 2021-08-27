- dashboard: checkout_main_dashboard_
  title: 'Checkout Main Dashboard'
  layout: newspaper
  preferred_viewer: dashboards-next
  elements:
  - title: mCVR3 Over Time
    name: mCVR3 Over Time
    model: flink_v3
    explore: segment_tracking_sessions30
    type: looker_column
    fields: [segment_tracking_sessions30.cnt_add_to_cart, segment_tracking_sessions30.mcvr3,
      segment_tracking_sessions30.context_device_type, segment_tracking_sessions30.session_start_date_granularity]
    pivots: [segment_tracking_sessions30.context_device_type]
    filters:
      segment_tracking_sessions30.returning_customer: ''
      segment_tracking_sessions30.timeframe_picker: Day
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
      Country: segment_tracking_sessions30.country
      Derived Hub: segment_tracking_sessions30.hub_code
      Context Device Type: segment_tracking_sessions30.context_device_type
      Context App Version: segment_tracking_sessions30.context_app_version
      Session Start At Date: segment_tracking_sessions30.session_start_at_date
    row: 21
    col: 0
    width: 12
    height: 6
  - title: mCVR4 Over Time
    name: mCVR4 Over Time
    model: flink_v3
    explore: segment_tracking_sessions30
    type: looker_column
    fields: [segment_tracking_sessions30.cnt_checkout_started, segment_tracking_sessions30.mcvr4,
      segment_tracking_sessions30.context_device_type, segment_tracking_sessions30.session_start_date_granularity]
    pivots: [segment_tracking_sessions30.context_device_type]
    filters:
      segment_tracking_sessions30.returning_customer: ''
      segment_tracking_sessions30.timeframe_picker: Day
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
      Country: segment_tracking_sessions30.country
      Derived Hub: segment_tracking_sessions30.hub_code
      Context Device Type: segment_tracking_sessions30.context_device_type
      Context App Version: segment_tracking_sessions30.context_app_version
      Session Start At Date: segment_tracking_sessions30.session_start_at_date
    row: 21
    col: 12
    width: 12
    height: 6
  - title: Conversion Per App Version
    name: Conversion Per App Version
    model: flink_v3
    explore: segment_tracking_sessions30
    type: looker_grid
    fields: [segment_tracking_sessions30.full_app_version, segment_tracking_sessions30.count,
      segment_tracking_sessions30.overall_conversion_rate, segment_tracking_sessions30.mcvr1,
      segment_tracking_sessions30.mcvr2, segment_tracking_sessions30.mcvr3, segment_tracking_sessions30.mcvr4]
    filters:
      segment_tracking_sessions30.returning_customer: ''
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
      Derived Hub: segment_tracking_sessions30.hub_code
      Context Device Type: segment_tracking_sessions30.context_device_type
      Context App Version: segment_tracking_sessions30.context_app_version
      Session Start At Date: segment_tracking_sessions30.session_start_at_date
    row: 33
    col: 0
    width: 24
    height: 10
  - title: Conversion Over Time
    name: Conversion Over Time
    model: flink_v3
    explore: segment_tracking_sessions30
    type: looker_column
    fields: [segment_tracking_sessions30.count, segment_tracking_sessions30.overall_conversion_rate,
      segment_tracking_sessions30.context_device_type, segment_tracking_sessions30.session_start_date_granularity]
    pivots: [segment_tracking_sessions30.context_device_type]
    filters:
      segment_tracking_sessions30.timeframe_picker: Day
      segment_tracking_sessions30.returning_customer: ''
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
      Country: segment_tracking_sessions30.country
      Derived Hub: segment_tracking_sessions30.hub_code
      Context Device Type: segment_tracking_sessions30.context_device_type
      Context App Version: segment_tracking_sessions30.context_app_version
      Session Start At Date: segment_tracking_sessions30.session_start_at_date
    row: 27
    col: 0
    width: 12
    height: 6
  - title: NL orders per payment method (last 10 days)
    name: NL orders per payment method (last 10 days)
    model: flink_v3
    explore: orders_cl
    type: looker_grid
    fields: [orders_cl.date, orders_cl.payment_type, orders_cl.cnt_orders]
    pivots: [orders_cl.payment_type]
    filters:
      hubs.country: ''
      hubs.hub_name: ''
      orders_cl.is_internal_order: 'no'
      orders_cl.is_successful_order: 'yes'
      orders_cl.created_date: after 10 days ago
      orders_cl.payment_type: "-EMPTY"
      orders_cl.country_iso: NL
    sorts: [orders_cl.date, orders_cl.payment_type]
    limit: 500
    query_timezone: Europe/Berlin
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: 12
    rows_font_size: 12
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
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
    stacking: normal
    hide_legend: false
    legend_position: center
    series_types: {}
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
    show_null_points: true
    interpolation: linear
    hidden_fields: []
    y_axes: []
    listen: {}
    row: 12
    col: 8
    width: 8
    height: 7
  - title: FR orders per payment method (last 10 days)
    name: FR orders per payment method (last 10 days)
    model: flink_v3
    explore: orders_cl
    type: looker_grid
    fields: [orders_cl.date, orders_cl.payment_type, orders_cl.cnt_orders]
    pivots: [orders_cl.payment_type]
    filters:
      hubs.country: ''
      hubs.hub_name: ''
      orders_cl.is_internal_order: 'no'
      orders_cl.is_successful_order: 'yes'
      orders_cl.created_date: after 10 days ago
      orders_cl.payment_type: "-EMPTY"
      orders_cl.country_iso: FR
    sorts: [orders_cl.date desc, orders_cl.payment_type]
    limit: 500
    query_timezone: Europe/Berlin
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
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
        palette:
          palette_id: 42be587c-e6f9-b924-f0f0-8ca952f79089
          collection_id: product-custom-collection
          custom_colors:
          - "#ffffff"
          - "#ec84af"
          - "#e5508e"
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
    stacking: normal
    hide_legend: false
    legend_position: center
    series_types: {}
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
    show_null_points: true
    interpolation: linear
    hidden_fields: []
    y_axes: []
    listen: {}
    row: 12
    col: 16
    width: 8
    height: 7
  - name: "## Orders 10 days evolution ## "
    type: text
    title_text: "## Orders 10 days evolution ## "
    subtitle_text: "(filters do not apply)"
    body_text: ''
    row: 0
    col: 0
    width: 24
    height: 2
  - name: "## Microconversions Details ##"
    type: text
    title_text: "## Microconversions Details ##"
    subtitle_text: ''
    body_text: ''
    row: 19
    col: 0
    width: 24
    height: 2
  - title: DE orders per payment method (last 10 days)
    name: DE orders per payment method (last 10 days)
    model: flink_v3
    explore: orders_cl
    type: looker_grid
    fields: [orders_cl.date, orders_cl.cnt_orders, orders_cl.payment_type]
    pivots: [orders_cl.payment_type]
    filters:
      hubs.country: ''
      hubs.hub_name: ''
      orders_cl.is_internal_order: 'no'
      orders_cl.is_successful_order: 'yes'
      orders_cl.created_date: after 10 days ago
      orders_cl.payment_type: "-EMPTY"
      orders_cl.country_iso: DE
    sorts: [orders_cl.payment_type, orders_cl.date]
    limit: 500
    query_timezone: Europe/Berlin
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
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
        palette:
          palette_id: 1517df5f-30de-ffde-593c-86f9912707f1
          collection_id: product-custom-collection
          custom_colors:
          - "#ffffff"
          - "#fbb6a0"
          - "#fa9e81"
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
    stacking: normal
    hide_legend: false
    legend_position: center
    series_types: {}
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
    show_null_points: true
    interpolation: linear
    hidden_fields: []
    y_axes: []
    listen: {}
    row: 12
    col: 0
    width: 8
    height: 7
  - title: FR orders evolution (last 10 days)
    name: FR orders evolution (last 10 days)
    model: flink_v3
    explore: orders_cl
    type: looker_line
    fields: [orders_cl.date, orders_cl.cnt_orders]
    filters:
      hubs.country: France
      hubs.hub_name: ''
      orders_cl.is_internal_order: 'no'
      orders_cl.is_successful_order: 'yes'
      orders_cl.created_date: after 10 days ago
    sorts: [orders_cl.date]
    limit: 500
    column_limit: 50
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
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
    color_application:
      collection_id: product-custom-collection
      palette_id: product-custom-collection-diverging-0
      options:
        steps: 5
    y_axes: [{label: '', orientation: left, series: [{axisId: orders_cl.cnt_orders,
            id: orders_cl.cnt_orders, name: "# Orders"}], showLabels: true, showValues: true,
        maxValue: 500, minValue: 0, unpinAxis: false, tickDensity: custom, tickDensityCustom: 22,
        type: linear}]
    series_types: {}
    series_colors:
      orders_cl.cnt_orders: "#ec84af"
    trend_lines: []
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    hidden_fields: []
    listen: {}
    row: 2
    col: 16
    width: 8
    height: 4
  - title: NL orders evolution (last 10 days)
    name: NL orders evolution (last 10 days)
    model: flink_v3
    explore: orders_cl
    type: looker_line
    fields: [orders_cl.date, orders_cl.cnt_orders]
    filters:
      hubs.country: Netherlands
      hubs.hub_name: ''
      orders_cl.is_internal_order: 'no'
      orders_cl.is_successful_order: 'yes'
      orders_cl.created_date: after 10 days ago
    sorts: [orders_cl.date]
    limit: 500
    column_limit: 50
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
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
    color_application:
      collection_id: product-custom-collection
      palette_id: product-custom-collection-diverging-0
      options:
        steps: 5
    y_axes: [{label: '', orientation: left, series: [{axisId: orders_cl.cnt_orders,
            id: orders_cl.cnt_orders, name: "# Orders"}, {axisId: orders_cl.KPI,
            id: orders_cl.KPI, name: KPI - Dynamic}], showLabels: true, showValues: true,
        maxValue: !!null '', unpinAxis: false, tickDensity: custom, tickDensityCustom: 46,
        type: linear}]
    series_types: {}
    series_colors:
      orders_cl.cnt_orders: "#7a9fd1"
    trend_lines: []
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    hidden_fields: []
    listen: {}
    row: 2
    col: 8
    width: 8
    height: 4
  - title: DE orders evolution (last 10 days)
    name: DE orders evolution (last 10 days)
    model: flink_v3
    explore: orders_cl
    type: looker_line
    fields: [orders_cl.date, orders_cl.cnt_orders]
    filters:
      hubs.country: Germany
      hubs.hub_name: ''
      orders_cl.is_internal_order: 'no'
      orders_cl.is_successful_order: 'yes'
      orders_cl.created_date: after 10 days ago
    sorts: [orders_cl.date]
    limit: 500
    column_limit: 50
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
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
    color_application:
      collection_id: product-custom-collection
      palette_id: product-custom-collection-diverging-0
      options:
        steps: 5
    y_axes: [{label: '', orientation: left, series: [{axisId: orders_cl.cnt_orders,
            id: orders_cl.cnt_orders, name: "# Orders"}, {axisId: orders_cl.KPI,
            id: orders_cl.KPI, name: KPI - Dynamic}], showLabels: true, showValues: true,
        maxValue: !!null '', unpinAxis: false, tickDensity: custom, tickDensityCustom: 46,
        type: linear}]
    series_types: {}
    trend_lines: []
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    hidden_fields: []
    listen: {}
    row: 2
    col: 0
    width: 8
    height: 4
  - name: "## Orders 10 days evolution with payment methods ## "
    type: text
    title_text: "## Orders 10 days evolution with payment methods ## "
    subtitle_text: "(filters do not apply)"
    body_text: ''
    row: 10
    col: 0
    width: 24
    height: 2
  - title: New Tile
    name: New Tile
    model: flink_v3
    explore: segment_tracking_sessions30
    type: single_value
    fields: [segment_tracking_sessions30.session_start_at_date, segment_tracking_sessions30.cnt_payment_started,
      segment_tracking_sessions30.cnt_purchase]
    fill_fields: [segment_tracking_sessions30.session_start_at_date]
    filters:
      segment_tracking_sessions30.session_start_at_date: 7 days
      segment_tracking_sessions30.context_device_type: ''
      segment_tracking_sessions30.returning_customer: ''
      segment_tracking_sessions30.country: Germany
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
    custom_color: "#f98662"
    single_value_title: Order Completed if Payment Started AVG Last 7 Days
    comparison_label: From Prior 7 Days
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
    listen: {}
    row: 6
    col: 0
    width: 8
    height: 4
  - title: New Tile
    name: New Tile (2)
    model: flink_v3
    explore: segment_tracking_sessions30
    type: single_value
    fields: [segment_tracking_sessions30.session_start_at_date, segment_tracking_sessions30.cnt_payment_started,
      segment_tracking_sessions30.cnt_purchase]
    fill_fields: [segment_tracking_sessions30.session_start_at_date]
    filters:
      segment_tracking_sessions30.session_start_at_date: 7 days
      segment_tracking_sessions30.context_device_type: ''
      segment_tracking_sessions30.returning_customer: ''
      segment_tracking_sessions30.country: Netherlands
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
    custom_color: "#7a9fd1"
    single_value_title: Order Completed if Payment Started AVG Last 7 Days
    comparison_label: From Prior 7 Days
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
    listen: {}
    row: 6
    col: 8
    width: 8
    height: 4
  - title: New Tile
    name: New Tile (3)
    model: flink_v3
    explore: segment_tracking_sessions30
    type: single_value
    fields: [segment_tracking_sessions30.session_start_at_date, segment_tracking_sessions30.cnt_payment_started,
      segment_tracking_sessions30.cnt_purchase]
    fill_fields: [segment_tracking_sessions30.session_start_at_date]
    filters:
      segment_tracking_sessions30.session_start_at_date: 7 days
      segment_tracking_sessions30.context_device_type: ''
      segment_tracking_sessions30.returning_customer: ''
      segment_tracking_sessions30.country: France
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
    custom_color: "#ec84af"
    single_value_title: Order Completed if Payment Started AVG Last 7 Days
    comparison_label: From Prior 7 Days
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
    listen: {}
    row: 6
    col: 16
    width: 8
    height: 4
  filters:
  - name: Context Device Type
    title: Context Device Type
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
    explore: segment_tracking_sessions30
    listens_to_filters: []
    field: segment_tracking_sessions30.country
  - name: Derived Hub
    title: Derived Hub
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
    listens_to_filters: []
    field: segment_tracking_sessions30.hub_code
  - name: Session Start At Date
    title: Session Start At Date
    type: field_filter
    default_value: 7 day
    allow_multiple_values: true
    required: false
    ui_config:
      type: relative_timeframes
      display: inline
      options: []
    model: flink_v3
    explore: segment_tracking_sessions30
    listens_to_filters: []
    field: segment_tracking_sessions30.session_start_at_date
  - name: Context App Version
    title: Context App Version
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
    listens_to_filters: []
    field: segment_tracking_sessions30.context_app_version
