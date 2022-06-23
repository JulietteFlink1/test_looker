- dashboard: monitoring_copy_202109
  title: Product Monitoring Health Metrics
  layout: newspaper
  preferred_viewer: dashboards-next
  refresh: 1 hour
  elements:
  - name: ''
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: |-
      <p align="center" style="font-size:24px;"> <b># Checkout & Payment #</b> </p>
      <p align="center">
      NOTE: Following metrics are controlled by the "Metrics Date" filter and not the "General View Date Range" filter
      <br/>
      NOTE: Android paymentFailed event only triggers when tokenisation fails and not on any other payment errors. To capture all failures and achieve parity with iOS, need to complete
      <a href="https://goflink.atlassian.net/browse/CHECKOUT-45"> this ticket</a>.
      </p>
    row: 17
    col: 0
    width: 24
    height: 3
  - title: iOS
    name: iOS
    model: flink_v3
    explore: monitoring_metrics
    type: single_value
    fields: [monitoring_metrics.payment_status, monitoring_metrics.count, monitoring_metrics.cnt_unique_anonymousid,
      monitoring_metrics.perc_unique_paymentfailure]
    filters:
      monitoring_metrics.payment_status: "-Other"
    sorts: [monitoring_metrics.payment_status desc]
    limit: 500
    total: true
    dynamic_fields: [{_kind_hint: measure, table_calculation: metrics_count, _type_hint: number,
        category: table_calculation, expression: 'if(row()=3, ${monitoring_metrics.count}-(offset(${monitoring_metrics.count},-1)+
          offset(${monitoring_metrics.count}, -2)), ${monitoring_metrics.count})',
        label: Metrics Count, value_format: !!null '', value_format_name: decimal_0},
      {_kind_hint: measure, table_calculation: percentage_of_total, _type_hint: number,
        category: table_calculation, expression: "${unique_users_count}/sum(${unique_users_count})",
        label: Percentage of total, value_format: !!null '', value_format_name: percent_1},
      {_kind_hint: measure, table_calculation: unique_users_count, _type_hint: number,
        category: table_calculation, expression: 'if(row()=3, ${monitoring_metrics.cnt_unique_anonymousid}-(offset(${monitoring_metrics.cnt_unique_anonymousid},-1)+
          offset(${monitoring_metrics.cnt_unique_anonymousid}, -2)), ${monitoring_metrics.cnt_unique_anonymousid})',
        label: Unique Users Count, value_format: !!null '', value_format_name: decimal_0}]
    query_timezone: Europe/Berlin
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    color_application:
      collection_id: product-custom-collection
      palette_id: product-custom-collection-categorical-0
      options:
        steps: 5
    custom_color: "#f98662"
    single_value_title: Users With Payment Failure
    comparison_label: Users With Payment Failure
    value_labels: legend
    label_type: labPer
    series_colors:
      Payment Succeeded: "#FBB555"
      Payment Started: "#fde8cc"
      Payment Failed: "#fccb88"
    series_labels:
      Payment Started: Other Outcome
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
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    defaults_version: 1
    hidden_fields: [monitoring_metrics.count, monitoring_metrics.cnt_unique_anonymousid,
      metrics_count, percentage_of_total]
    y_axes: []
    note_state: collapsed
    note_display: hover
    note_text: Of the Unique IDs that started a payment within the time period, what
      % experienced a payment failure sometime?
    listen:
      Context Device Type: monitoring_metrics.context_device_type
      Metrics Date: monitoring_metrics.timestamp_date
    row: 29
    col: 0
    width: 4
    height: 5
  - name: "========== OVERALL =========="
    type: text
    title_text: "========== OVERALL =========="
    subtitle_text: ''
    body_text: ''
    row: 2
    col: 0
    width: 12
    height: 2
  - name: "========== SELECTED APP VERSION ONLY =========="
    type: text
    title_text: "========== SELECTED APP VERSION ONLY =========="
    subtitle_text: ''
    body_text: ''
    row: 2
    col: 12
    width: 12
    height: 2
  - title: New Tile
    name: New Tile
    model: flink_v3
    explore: monitoring_metrics
    type: single_value
    fields: [monitoring_metrics.timestamp_date, monitoring_metrics.unique_checkoutstarted_per_paymentstarted_perc,
      monitoring_metrics.cnt_unique_checkoutstarted]
    filters: {}
    sorts: [monitoring_metrics.timestamp_date desc]
    limit: 500
    column_limit: 50
    dynamic_fields: [{_kind_hint: measure, table_calculation: checkoutstarted_per_paymentstarted,
        _type_hint: number, category: table_calculation, expression: "${monitoring_metrics.cnt_unique_paymentstarted}/${monitoring_metrics.cnt_unique_checkoutstarted}",
        label: CheckoutStarted per PaymentStarted, value_format: !!null '', value_format_name: percent_0,
        is_disabled: true}, {_kind_hint: measure, table_calculation: ratio_yesterday,
        _type_hint: number, category: table_calculation, expression: "${monitoring_metrics.unique_checkoutstarted_per_paymentstarted_perc}-offset(${monitoring_metrics.unique_checkoutstarted_per_paymentstarted_perc},1)",
        label: Ratio Yesterday, value_format: !!null '', value_format_name: percent_1}]
    query_timezone: Europe/Berlin
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: true
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    custom_color: "#e5508e"
    single_value_title: Users Checkout Started to Payment Started
    comparison_label: Users With CheckoutStarted
    conditional_formatting: [{type: greater than, value: 2, background_color: "#d60000",
        font_color: "#f7cadd", color_application: {collection_id: product-custom-collection,
          palette_id: product-custom-collection-sequential-0}, bold: false, italic: false,
        strikethrough: false, fields: !!null ''}]
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
    series_types: {}
    hidden_fields: [monitoring_metrics.cnt_unique_orderplaced, ratio_yesterday]
    y_axes: []
    note_state: collapsed
    note_display: hover
    note_text: Percentage of Unique IDs with checkoutStarted compared to Unique IDs
      with paymentStarted
    listen:
      Context Device Type: monitoring_metrics.context_device_type
      Metrics Date: monitoring_metrics.timestamp_date
    row: 29
    col: 4
    width: 4
    height: 5
  - title: New Tile
    name: New Tile (2)
    model: flink_v3
    explore: monitoring_metrics
    type: single_value
    fields: [monitoring_metrics.timestamp_date, monitoring_metrics.unique_paymentstarted_per_orderplaced_perc,
      monitoring_metrics.cnt_unique_paymentstarted]
    filters: {}
    sorts: [monitoring_metrics.timestamp_date desc]
    limit: 500
    column_limit: 50
    dynamic_fields: [{_kind_hint: measure, table_calculation: ratio_today, _type_hint: number,
        category: table_calculation, expression: "${monitoring_metrics.cnt_orderplaced}/${monitoring_metrics.cnt_paymentstarted}",
        label: Ratio Today, value_format: !!null '', value_format_name: percent_1,
        is_disabled: true}, {_kind_hint: measure, table_calculation: paymentstarted_per_orderplaced,
        _type_hint: number, category: table_calculation, expression: "${monitoring_metrics.cnt_unique_orderplaced}/${monitoring_metrics.cnt_unique_paymentstarted}",
        label: PaymentStarted per OrderPlaced, value_format: !!null '', value_format_name: percent_0,
        is_disabled: true}, {_kind_hint: measure, table_calculation: ratio_yesterday,
        _type_hint: number, category: table_calculation, expression: "${monitoring_metrics.unique_paymentstarted_per_orderplaced_perc}-offset(${monitoring_metrics.unique_paymentstarted_per_orderplaced_perc},1)",
        label: Ratio Yesterday, value_format: !!null '', value_format_name: percent_1}]
    query_timezone: Europe/Berlin
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: true
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    custom_color: "#FBB555"
    single_value_title: Users Payment Started to Order Placed
    comparison_label: Users With PaymentStarted
    conditional_formatting: [{type: greater than, value: 2, background_color: "#d60000",
        font_color: "#fccb88", color_application: {collection_id: product-custom-collection,
          palette_id: product-custom-collection-sequential-0}, bold: false, italic: false,
        strikethrough: false, fields: !!null ''}]
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
    series_types: {}
    hidden_fields: []
    y_axes: []
    note_state: collapsed
    note_display: hover
    note_text: Percentage of Unique IDs with PaymentStarted compared to Unique IDs
      with OrderPlaced
    listen:
      Context Device Type: monitoring_metrics.context_device_type
      Metrics Date: monitoring_metrics.timestamp_date
    row: 29
    col: 8
    width: 4
    height: 5
  - title: version filter payment failure uniques
    name: version filter payment failure uniques
    model: flink_v3
    explore: monitoring_metrics
    type: single_value
    fields: [monitoring_metrics.payment_status, monitoring_metrics.count, monitoring_metrics.cnt_unique_anonymousid,
      monitoring_metrics.perc_unique_paymentfailure]
    filters:
      monitoring_metrics.payment_status: "-Other"
    sorts: [monitoring_metrics.payment_status desc]
    limit: 500
    total: true
    dynamic_fields: [{_kind_hint: measure, table_calculation: metrics_count, _type_hint: number,
        category: table_calculation, expression: 'if(row()=3, ${monitoring_metrics.count}-(offset(${monitoring_metrics.count},-1)+
          offset(${monitoring_metrics.count}, -2)), ${monitoring_metrics.count})',
        label: Metrics Count, value_format: !!null '', value_format_name: decimal_0},
      {_kind_hint: measure, table_calculation: percentage_of_total, _type_hint: number,
        category: table_calculation, expression: "${unique_users_count}/sum(${unique_users_count})",
        label: Percentage of total, value_format: !!null '', value_format_name: percent_1},
      {_kind_hint: measure, table_calculation: unique_users_count, _type_hint: number,
        category: table_calculation, expression: 'if(row()=3, ${monitoring_metrics.cnt_unique_anonymousid}-(offset(${monitoring_metrics.cnt_unique_anonymousid},-1)+
          offset(${monitoring_metrics.cnt_unique_anonymousid}, -2)), ${monitoring_metrics.cnt_unique_anonymousid})',
        label: Unique Users Count, value_format: !!null '', value_format_name: decimal_0}]
    query_timezone: Europe/Berlin
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    color_application:
      collection_id: product-custom-collection
      palette_id: product-custom-collection-categorical-0
      options:
        steps: 5
    custom_color: "#f98662"
    single_value_title: Users With Payment Failure
    comparison_label: Users With Payment Failure
    value_labels: legend
    label_type: labPer
    series_colors:
      Payment Succeeded: "#FBB555"
      Payment Started: "#fde8cc"
      Payment Failed: "#fccb88"
    series_labels:
      Payment Started: Other Outcome
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
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    defaults_version: 1
    hidden_fields: [monitoring_metrics.count, monitoring_metrics.cnt_unique_anonymousid,
      metrics_count, percentage_of_total]
    y_axes: []
    note_state: collapsed
    note_display: hover
    note_text: Of the Unique IDs that started a payment within the time period, what
      % experienced a payment failure sometime?
    listen:
      Metrics Date: monitoring_metrics.timestamp_date
    row: 29
    col: 12
    width: 4
    height: 5
  - title: version filter payment started uniques
    name: version filter payment started uniques
    model: flink_v3
    explore: monitoring_metrics
    type: single_value
    fields: [monitoring_metrics.timestamp_date, monitoring_metrics.unique_paymentstarted_per_orderplaced_perc,
      monitoring_metrics.cnt_unique_paymentstarted]
    sorts: [monitoring_metrics.timestamp_date desc]
    limit: 500
    column_limit: 50
    dynamic_fields: [{_kind_hint: measure, table_calculation: paymentstarted_per_orderplaced,
        _type_hint: number, category: table_calculation, expression: "${monitoring_metrics.cnt_unique_orderplaced}/${monitoring_metrics.cnt_unique_paymentstarted}",
        label: PaymentStarted per OrderPlaced, value_format: !!null '', value_format_name: percent_0,
        is_disabled: true}, {_kind_hint: measure, table_calculation: ratio_yesterday,
        _type_hint: number, category: table_calculation, expression: "${monitoring_metrics.unique_paymentstarted_per_orderplaced_perc}-offset(${monitoring_metrics.unique_paymentstarted_per_orderplaced_perc},1)",
        label: Ratio Yesterday, value_format: !!null '', value_format_name: percent_1}]
    query_timezone: Europe/Berlin
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: true
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    custom_color: "#FBB555"
    single_value_title: Users Payment Started to Order Placed
    comparison_label: Users With PaymentStarted
    conditional_formatting: [{type: greater than, value: 2, background_color: "#d60000",
        font_color: "#fccb88", color_application: {collection_id: product-custom-collection,
          palette_id: product-custom-collection-sequential-0}, bold: false, italic: false,
        strikethrough: false, fields: !!null ''}]
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
    series_types: {}
    hidden_fields: []
    y_axes: []
    note_state: collapsed
    note_display: hover
    note_text: Percentage of Unique IDs with PaymentStarted compared to Unique IDs
      with OrderPlaced
    listen:
      Metrics Date: monitoring_metrics.timestamp_date
    row: 29
    col: 20
    width: 4
    height: 5
  - title: Number Of Users By App Version
    name: Number Of Users By App Version
    model: flink_v3
    explore: monitoring_metrics
    type: looker_pie
    fields: [monitoring_metrics.full_app_version, monitoring_metrics.cnt_unique_anonymousid]
    filters:
      monitoring_metrics.cnt_checkoutstarted: ">5"
    sorts: [monitoring_metrics.full_app_version desc]
    limit: 500
    column_limit: 50
    dynamic_fields: [{_kind_hint: measure, table_calculation: checkoutstarted_per_paymentstarted,
        _type_hint: number, category: table_calculation, expression: "${monitoring_metrics.cnt_unique_paymentstarted}/${monitoring_metrics.cnt_unique_checkoutstarted}",
        label: CheckoutStarted per PaymentStarted, value_format: !!null '', value_format_name: percent_0,
        is_disabled: true}, {_kind_hint: measure, table_calculation: ratio_yesterday,
        _type_hint: number, category: table_calculation, expression: "${checkoutstarted_per_paymentstarted}-offset(${checkoutstarted_per_paymentstarted},1)",
        label: Ratio Yesterday, value_format: !!null '', value_format_name: percent_1,
        is_disabled: true}]
    query_timezone: Europe/Berlin
    value_labels: legend
    label_type: labPer
    color_application:
      collection_id: product-custom-collection
      palette_id: product-custom-collection-diverging-0
      options:
        steps: 5
    series_colors: {}
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: true
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    custom_color: "#e5508e"
    single_value_title: Unique IDs Checkout Started to Payment Started
    comparison_label: From Yesterday
    conditional_formatting: [{type: greater than, value: 2, background_color: "#d60000",
        font_color: "#f7cadd", color_application: {collection_id: product-custom-collection,
          palette_id: product-custom-collection-sequential-0}, bold: false, italic: false,
        strikethrough: false, fields: !!null ''}]
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
    series_types: {}
    hidden_fields: [monitoring_metrics.cnt_unique_orderplaced]
    y_axes: []
    note_state: expanded
    note_display: hover
    note_text: User approximated using Segment Anonymous ID
    listen:
      Context Device Type: monitoring_metrics.context_device_type
      General View Date Range: monitoring_metrics.timestamp_date
    row: 4
    col: 6
    width: 6
    height: 6
  - title: version filter selected version name
    name: version filter selected version name
    model: flink_v3
    explore: monitoring_metrics
    type: single_value
    fields: [monitoring_metrics.full_app_version]
    filters: {}
    sorts: [monitoring_metrics.full_app_version desc]
    limit: 500
    column_limit: 50
    dynamic_fields: [{_kind_hint: dimension, table_calculation: new_calculation, _type_hint: string_list,
        category: table_calculation, expression: 'offset_list(${monitoring_metrics.full_app_version},0,count(${monitoring_metrics.full_app_version}))',
        label: New Calculation, value_format: !!null '', value_format_name: !!null ''}]
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    single_value_title: Selected Version(s)
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
    series_types: {}
    hidden_fields: [monitoring_metrics.full_app_version]
    y_axes: []
    note_state: collapsed
    note_display: hover
    note_text: The App Versions this side of the board is filtered on
    listen:
      General View Date Range: monitoring_metrics.timestamp_date
      Full App Version: monitoring_metrics.full_app_version
    row: 4
    col: 12
    width: 12
    height: 6
  - title: version filter checkout started uniques
    name: version filter checkout started uniques
    model: flink_v3
    explore: monitoring_metrics
    type: single_value
    fields: [monitoring_metrics.timestamp_date, monitoring_metrics.unique_checkoutstarted_per_paymentstarted_perc,
      monitoring_metrics.cnt_unique_checkoutstarted]
    sorts: [monitoring_metrics.timestamp_date desc]
    limit: 500
    column_limit: 50
    dynamic_fields: [{_kind_hint: measure, table_calculation: ratio_yesterday, _type_hint: number,
        category: table_calculation, expression: "${monitoring_metrics.unique_checkoutstarted_per_paymentstarted_perc}-offset(${monitoring_metrics.unique_checkoutstarted_per_paymentstarted_perc},1)",
        label: Ratio Yesterday, value_format: !!null '', value_format_name: percent_1}]
    query_timezone: Europe/Berlin
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: true
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    custom_color: "#e5508e"
    single_value_title: Users Checkout Started to Payment Started
    comparison_label: Users With CheckoutStarted
    conditional_formatting: [{type: greater than, value: 2, background_color: "#d60000",
        font_color: "#f7cadd", color_application: {collection_id: product-custom-collection,
          palette_id: product-custom-collection-sequential-0}, bold: false, italic: false,
        strikethrough: false, fields: !!null ''}]
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
    series_types: {}
    hidden_fields: [monitoring_metrics.cnt_unique_orderplaced]
    y_axes: []
    note_state: collapsed
    note_display: hover
    note_text: Percentage of Unique IDs with checkoutStarted compared to Unique IDs
      with paymentStarted
    listen:
      Metrics Date: monitoring_metrics.timestamp_date
    row: 29
    col: 16
    width: 4
    height: 5
  - title: Sessions Funnel
    name: Sessions Funnel
    model: flink_v3
    explore: segment_tracking_sessions30
    type: looker_column
    fields: [segment_tracking_sessions30.count, segment_tracking_sessions30.cnt_address_selected,
      segment_tracking_sessions30.cnt_home_viewed, segment_tracking_sessions30.cnt_add_to_cart,
      segment_tracking_sessions30.cnt_view_cart, segment_tracking_sessions30.cnt_checkout_started,
      segment_tracking_sessions30.cnt_payment_started, segment_tracking_sessions30.cnt_purchase]
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
    show_x_axis_ticks: false
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    x_axis_label: Funnel
    hide_legend: false
    series_types: {}
    series_colors:
      segment_tracking_sessions30.count: "#75E2E2"
      segment_tracking_sessions30.cnt_checkout_started: "#e5508e"
      segment_tracking_sessions30.cnt_view_cart: "#B1399E"
      segment_tracking_sessions30.cnt_payment_started: "#f98662"
      segment_tracking_sessions30.cnt_purchase: "#FFD95F"
      segment_tracking_sessions30.cnt_address_selected: "#4276BE"
      segment_tracking_sessions30.cnt_add_to_cart: "#ba85f4"
    series_labels:
      segment_tracking_sessions30.count: Sessions Started
      segment_tracking_sessions30.cnt_view_cart: Sessions With Cart Viewed
      segment_tracking_sessions30.cnt_checkout_started: Sessions With Checkout Started
      segment_tracking_sessions30.cnt_payment_started: Sessions With Payment Started
      segment_tracking_sessions30.cnt_purchase: Sessions With Order Placed
      segment_tracking_sessions30.cnt_address_selected: Sessions With Address Selected
      segment_tracking_sessions30.cnt_home_viewed: Sessions With Home Viewed
      segment_tracking_sessions30.cnt_add_to_cart: Sessions With Add To Cart
    show_dropoff: true
    defaults_version: 1
    up_color: "#c76b4e"
    down_color: "#B1399E"
    total_color: "#C2DD67"
    leftAxisLabelVisible: false
    leftAxisLabel: ''
    rightAxisLabelVisible: false
    rightAxisLabel: ''
    smoothedBars: false
    orientation: automatic
    labelPosition: left
    percentType: total
    percentPosition: inline
    valuePosition: right
    labelColorEnabled: false
    labelColor: "#FFF"
    hidden_fields: []
    y_axes: []
    note_state: expanded
    note_display: hover
    note_text: Open funnel comparing number of sessions from one to next step (same
      data as on the Product Conversion Main dashboard)
    listen:
      Context Device Type: segment_tracking_sessions30.context_device_type
      General View Date Range: segment_tracking_sessions30.session_start_at_date
    row: 10
    col: 0
    width: 12
    height: 7
  - title: Sessions Funnel For Selected Version(s)
    name: Sessions Funnel For Selected Version(s)
    model: flink_v3
    explore: segment_tracking_sessions30
    type: looker_column
    fields: [segment_tracking_sessions30.count, segment_tracking_sessions30.cnt_address_selected,
      segment_tracking_sessions30.cnt_home_viewed, segment_tracking_sessions30.cnt_add_to_cart,
      segment_tracking_sessions30.cnt_view_cart, segment_tracking_sessions30.cnt_checkout_started,
      segment_tracking_sessions30.cnt_payment_started, segment_tracking_sessions30.cnt_purchase]
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
    show_x_axis_ticks: false
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    x_axis_label: Funnel
    hide_legend: false
    series_types: {}
    series_colors:
      segment_tracking_sessions30.count: "#75E2E2"
      segment_tracking_sessions30.cnt_checkout_started: "#e5508e"
      segment_tracking_sessions30.cnt_view_cart: "#B1399E"
      segment_tracking_sessions30.cnt_payment_started: "#f98662"
      segment_tracking_sessions30.cnt_purchase: "#FFD95F"
      segment_tracking_sessions30.cnt_address_selected: "#4276BE"
      segment_tracking_sessions30.cnt_add_to_cart: "#ba85f4"
    series_labels:
      segment_tracking_sessions30.cnt_view_cart: Sessions With Cart Viewed
      segment_tracking_sessions30.cnt_checkout_started: Sessions With Checkout Started
      segment_tracking_sessions30.cnt_payment_started: Sessions With Payment Started
      segment_tracking_sessions30.cnt_purchase: Sessions With Order Placed
      segment_tracking_sessions30.cnt_add_to_cart: Sessions With Add To Cart
      segment_tracking_sessions30.cnt_home_viewed: Sessions With Home Viewed
      segment_tracking_sessions30.cnt_address_selected: Sessions With Address Selected
      segment_tracking_sessions30.count: Sessions Started
    show_dropoff: true
    defaults_version: 1
    up_color: "#c76b4e"
    down_color: "#B1399E"
    total_color: "#C2DD67"
    leftAxisLabelVisible: false
    leftAxisLabel: ''
    rightAxisLabelVisible: false
    rightAxisLabel: ''
    smoothedBars: false
    orientation: automatic
    labelPosition: left
    percentType: total
    percentPosition: inline
    valuePosition: right
    labelColorEnabled: false
    labelColor: "#FFF"
    hidden_fields: []
    y_axes: []
    note_state: collapsed
    note_display: hover
    note_text: Open funnel comparing number of sessions from one to next step for
      the selected app version(s)
    listen:
      General View Date Range: segment_tracking_sessions30.session_start_at_date
      Full App Version: segment_tracking_sessions30.full_app_version
    row: 10
    col: 12
    width: 12
    height: 7
  - name: " (2)"
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: '<p align="center" style="font-size:24px;"> <b># General Overview #</b>
      </p>'
    row: 0
    col: 0
    width: 24
    height: 2
  - title: checkout sessions overall
    name: checkout sessions overall
    model: flink_v3
    explore: checkout_sessions
    type: single_value
    fields: [checkout_sessions.session_start_at_date, checkout_sessions.cnt_payment_started,
      checkout_sessions.cnt_payment_failed, checkout_sessions.cnt_payment_failed_no_order,
      checkout_sessions.paymentfailed_per_paymentstarted_perc]
    filters: {}
    sorts: [checkout_sessions.session_start_at_date desc]
    limit: 500
    dynamic_fields: [{_kind_hint: measure, table_calculation: payment_failed_payment_started,
        _type_hint: number, category: table_calculation, expression: "${checkout_sessions.cnt_payment_failed}/${checkout_sessions.cnt_payment_started}",
        label: payment failed / payment started, value_format: !!null '', value_format_name: percent_1,
        is_disabled: true}, {_kind_hint: measure, table_calculation: new_calculation,
        _type_hint: number, category: table_calculation, expression: "${checkout_sessions.cnt_payment_failed}",
        label: New Calculation, value_format: !!null '', value_format_name: !!null ''},
      {_kind_hint: measure, table_calculation: payment_failed_no_order_payment_started,
        _type_hint: number, category: table_calculation, expression: "${checkout_sessions.cnt_payment_failed_no_order}/${checkout_sessions.cnt_payment_started}",
        label: payment failed no order / payment started, value_format: !!null '',
        value_format_name: percent_1}]
    query_timezone: Europe/Berlin
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    custom_color: "#f98662"
    single_value_title: Payment Started Sessions Have An Payment Failure
    comparison_label: Payment Started Sessions With Payment Failure
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    y_axes: [{label: '', orientation: left, series: [{axisId: checkout_sessions.cnt_payment_started,
            id: checkout_sessions.cnt_payment_started, name: Payment started count}],
        showLabels: true, showValues: true, unpinAxis: false, tickDensity: default,
        tickDensityCustom: 5, type: linear}, {label: !!null '', orientation: right,
        series: [{axisId: payment_failed_payment_started, id: payment_failed_payment_started,
            name: payment failed / payment started}, {axisId: payment_failed_no_order_payment_started,
            id: payment_failed_no_order_payment_started, name: payment failed no order
              / payment started}], showLabels: true, showValues: true, unpinAxis: false,
        tickDensity: default, tickDensityCustom: 5, type: linear}]
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
    series_types: {}
    point_style: none
    series_colors:
      checkout_sessions.cnt_payment_started: "#FBB555"
      payment_failed_payment_started: "#f98662"
      payment_failed_no_order_payment_started: "#d9131b"
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    hidden_fields: [checkout_sessions.cnt_payment_failed, checkout_sessions.cnt_payment_failed_no_order,
      checkout_sessions.cnt_payment_started]
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    listen:
      Context Device Type: checkout_sessions.context_device_type
      Metrics Date: checkout_sessions.session_start_at_date
    row: 22
    col: 0
    width: 6
    height: 5
  - title: payment sessions overall
    name: payment sessions overall
    model: flink_v3
    explore: checkout_sessions
    type: single_value
    fields: [checkout_sessions.session_start_at_date, checkout_sessions.cnt_payment_started,
      checkout_sessions.cnt_payment_failed, checkout_sessions.cnt_payment_failed_no_order,
      checkout_sessions.paymentfailed_noorder_per_paymentstarted_perc]
    filters: {}
    sorts: [checkout_sessions.session_start_at_date desc]
    limit: 500
    dynamic_fields: [{_kind_hint: measure, table_calculation: payment_failed_payment_started,
        _type_hint: number, category: table_calculation, expression: "${checkout_sessions.cnt_payment_failed}/${checkout_sessions.cnt_payment_started}",
        label: payment failed / payment started, value_format: !!null '', value_format_name: percent_1,
        is_disabled: true}, {_kind_hint: measure, table_calculation: new_calculation,
        _type_hint: number, category: table_calculation, expression: "${checkout_sessions.cnt_payment_failed}",
        label: New Calculation, value_format: !!null '', value_format_name: !!null '',
        is_disabled: true}, {_kind_hint: measure, table_calculation: payment_failed_no_order_payment_started,
        _type_hint: number, category: table_calculation, expression: "${checkout_sessions.cnt_payment_failed_no_order}/${checkout_sessions.cnt_payment_started}",
        label: payment failed no order / payment started, value_format: !!null '',
        value_format_name: percent_1, is_disabled: true}, {_kind_hint: measure, table_calculation: new_calculation_1,
        _type_hint: number, category: table_calculation, expression: "${checkout_sessions.cnt_payment_failed_no_order}",
        label: New Calculation, value_format: !!null '', value_format_name: !!null ''}]
    query_timezone: Europe/Berlin
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    custom_color: "#d9131b"
    single_value_title: Payment Started Sessions Have An Payment Failure And No Order
    comparison_label: Payment Started Sessions With Failure No Order
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    y_axes: [{label: '', orientation: left, series: [{axisId: checkout_sessions.cnt_payment_started,
            id: checkout_sessions.cnt_payment_started, name: Payment started count}],
        showLabels: true, showValues: true, unpinAxis: false, tickDensity: default,
        tickDensityCustom: 5, type: linear}, {label: !!null '', orientation: right,
        series: [{axisId: payment_failed_payment_started, id: payment_failed_payment_started,
            name: payment failed / payment started}, {axisId: payment_failed_no_order_payment_started,
            id: payment_failed_no_order_payment_started, name: payment failed no order
              / payment started}], showLabels: true, showValues: true, unpinAxis: false,
        tickDensity: default, tickDensityCustom: 5, type: linear}]
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
    series_types: {}
    point_style: none
    series_colors:
      checkout_sessions.cnt_payment_started: "#FBB555"
      payment_failed_payment_started: "#f98662"
      payment_failed_no_order_payment_started: "#d9131b"
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    hidden_fields: [checkout_sessions.cnt_payment_failed, checkout_sessions.cnt_payment_failed_no_order,
      checkout_sessions.cnt_payment_started]
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    listen:
      Context Device Type: checkout_sessions.context_device_type
      Metrics Date: checkout_sessions.session_start_at_date
    row: 22
    col: 6
    width: 6
    height: 5
  - title: Payment Started Sessions With Payment Failures For This Version
    name: Payment Started Sessions With Payment Failures For This Version
    model: flink_v3
    explore: checkout_sessions
    type: single_value
    fields: [checkout_sessions.session_start_at_date, checkout_sessions.cnt_payment_started,
      checkout_sessions.cnt_payment_failed, checkout_sessions.cnt_payment_failed_no_order,
      checkout_sessions.paymentfailed_per_paymentstarted_perc]
    fill_fields: [checkout_sessions.session_start_at_date]
    filters: {}
    sorts: [checkout_sessions.session_start_at_date desc]
    limit: 500
    dynamic_fields: [{_kind_hint: measure, table_calculation: payment_failed_payment_started,
        _type_hint: number, category: table_calculation, expression: "${checkout_sessions.cnt_payment_failed}/${checkout_sessions.cnt_payment_started}",
        label: payment failed / payment started, value_format: !!null '', value_format_name: percent_1,
        is_disabled: true}, {_kind_hint: measure, table_calculation: new_calculation,
        _type_hint: number, category: table_calculation, expression: "${checkout_sessions.cnt_payment_failed}",
        label: New Calculation, value_format: !!null '', value_format_name: !!null ''},
      {_kind_hint: measure, table_calculation: payment_failed_no_order_payment_started,
        _type_hint: number, category: table_calculation, expression: "${checkout_sessions.cnt_payment_failed_no_order}/${checkout_sessions.cnt_payment_started}",
        label: payment failed no order / payment started, value_format: !!null '',
        value_format_name: percent_1}]
    query_timezone: Europe/Berlin
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    custom_color: "#f98662"
    single_value_title: Payment Started Sessions Have An Payment Failure For This
      Version
    comparison_label: Payment Started Sessions With Failures
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    y_axes: [{label: '', orientation: left, series: [{axisId: checkout_sessions.cnt_payment_started,
            id: checkout_sessions.cnt_payment_started, name: Payment started count}],
        showLabels: true, showValues: true, unpinAxis: false, tickDensity: default,
        tickDensityCustom: 5, type: linear}, {label: !!null '', orientation: right,
        series: [{axisId: payment_failed_payment_started, id: payment_failed_payment_started,
            name: payment failed / payment started}, {axisId: payment_failed_no_order_payment_started,
            id: payment_failed_no_order_payment_started, name: payment failed no order
              / payment started}], showLabels: true, showValues: true, unpinAxis: false,
        tickDensity: default, tickDensityCustom: 5, type: linear}]
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
    series_types: {}
    point_style: none
    series_colors:
      checkout_sessions.cnt_payment_started: "#FBB555"
      payment_failed_payment_started: "#f98662"
      payment_failed_no_order_payment_started: "#d9131b"
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    hidden_fields: [checkout_sessions.cnt_payment_failed, checkout_sessions.cnt_payment_failed_no_order,
      checkout_sessions.cnt_payment_started]
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    listen:
      Metrics Date: checkout_sessions.session_start_at_date
      Full App Version: checkout_sessions.full_app_version
    row: 22
    col: 12
    width: 6
    height: 5
  - title: Sessions With Missed Orders Due To Payment Failure For This Version
    name: Sessions With Missed Orders Due To Payment Failure For This Version
    model: flink_v3
    explore: checkout_sessions
    type: single_value
    fields: [checkout_sessions.session_start_at_date, checkout_sessions.cnt_payment_started,
      checkout_sessions.cnt_payment_failed, checkout_sessions.cnt_payment_failed_no_order,
      checkout_sessions.paymentfailed_noorder_per_paymentstarted_perc]
    filters: {}
    sorts: [checkout_sessions.session_start_at_date desc]
    limit: 500
    dynamic_fields: [{_kind_hint: measure, table_calculation: payment_failed_payment_started,
        _type_hint: number, category: table_calculation, expression: "${checkout_sessions.cnt_payment_failed}/${checkout_sessions.cnt_payment_started}",
        label: payment failed / payment started, value_format: !!null '', value_format_name: percent_1,
        is_disabled: true}, {_kind_hint: measure, table_calculation: new_calculation,
        _type_hint: number, category: table_calculation, expression: "${checkout_sessions.cnt_payment_failed}",
        label: New Calculation, value_format: !!null '', value_format_name: !!null '',
        is_disabled: true}, {_kind_hint: measure, table_calculation: payment_failed_no_order_payment_started,
        _type_hint: number, category: table_calculation, expression: "${checkout_sessions.cnt_payment_failed_no_order}/${checkout_sessions.cnt_payment_started}",
        label: payment failed no order / payment started, value_format: !!null '',
        value_format_name: percent_1, is_disabled: true}, {_kind_hint: measure, table_calculation: new_calculation_1,
        _type_hint: number, category: table_calculation, expression: "${checkout_sessions.cnt_payment_failed_no_order}",
        label: New Calculation, value_format: !!null '', value_format_name: !!null ''}]
    query_timezone: Europe/Berlin
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    custom_color: "#d9131b"
    single_value_title: Payment Started Sessions Have An Payment Failure And No Order
      For This Version
    comparison_label: Payment Started Sessions With Failure No Order
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    y_axes: [{label: '', orientation: left, series: [{axisId: checkout_sessions.cnt_payment_started,
            id: checkout_sessions.cnt_payment_started, name: Payment started count}],
        showLabels: true, showValues: true, unpinAxis: false, tickDensity: default,
        tickDensityCustom: 5, type: linear}, {label: !!null '', orientation: right,
        series: [{axisId: payment_failed_payment_started, id: payment_failed_payment_started,
            name: payment failed / payment started}, {axisId: payment_failed_no_order_payment_started,
            id: payment_failed_no_order_payment_started, name: payment failed no order
              / payment started}], showLabels: true, showValues: true, unpinAxis: false,
        tickDensity: default, tickDensityCustom: 5, type: linear}]
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
    series_types: {}
    point_style: none
    series_colors:
      checkout_sessions.cnt_payment_started: "#FBB555"
      payment_failed_payment_started: "#f98662"
      payment_failed_no_order_payment_started: "#d9131b"
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    hidden_fields: [checkout_sessions.cnt_payment_failed, checkout_sessions.cnt_payment_failed_no_order,
      checkout_sessions.cnt_payment_started]
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    listen:
      Metrics Date: checkout_sessions.session_start_at_date
      Full App Version: checkout_sessions.full_app_version
    row: 22
    col: 18
    width: 6
    height: 5
  - title: Number Of Sessions By App Version
    name: Number Of Sessions By App Version
    model: flink_v3
    explore: segment_tracking_sessions30
    type: looker_pie
    fields: [segment_tracking_sessions30.count, segment_tracking_sessions30.full_app_version]
    filters:
      segment_tracking_sessions30.count: ">25"
    sorts: [segment_tracking_sessions30.full_app_version desc]
    limit: 500
    query_timezone: Europe/Berlin
    value_labels: legend
    label_type: labPer
    color_application:
      collection_id: product-custom-collection
      palette_id: product-custom-collection-sequential-0
      options:
        steps: 5
    series_colors:
      segment_tracking_sessions30.count: "#75E2E2"
      segment_tracking_sessions30.cnt_checkout_started: "#e5508e"
      segment_tracking_sessions30.cnt_view_cart: "#B1399E"
      segment_tracking_sessions30.cnt_payment_started: "#f98662"
      segment_tracking_sessions30.cnt_purchase: "#FFD95F"
      segment_tracking_sessions30.cnt_location_pin_placed: "#3EB0D5"
      segment_tracking_sessions30.cnt_address_selected: "#4276BE"
      segment_tracking_sessions30.cnt_add_to_cart: "#ba85f4"
    series_labels:
      segment_tracking_sessions30.count: Sessions Started
      segment_tracking_sessions30.cnt_view_cart: Sessions With View Cart
      segment_tracking_sessions30.cnt_checkout_started: Sessions With Checkout Started
      segment_tracking_sessions30.cnt_payment_started: Sessions With Payment Started
      segment_tracking_sessions30.cnt_purchase: Sessions With Order Placed
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
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    hide_legend: false
    series_types: {}
    show_dropoff: true
    defaults_version: 1
    up_color: "#c76b4e"
    down_color: "#B1399E"
    total_color: "#C2DD67"
    leftAxisLabelVisible: false
    leftAxisLabel: ''
    rightAxisLabelVisible: false
    rightAxisLabel: ''
    smoothedBars: false
    orientation: automatic
    labelPosition: left
    percentType: total
    percentPosition: inline
    valuePosition: right
    labelColorEnabled: false
    labelColor: "#FFF"
    hidden_fields: []
    y_axes: []
    listen:
      Context Device Type: segment_tracking_sessions30.context_device_type
      General View Date Range: segment_tracking_sessions30.session_start_at_date
    row: 4
    col: 0
    width: 6
    height: 6
  - name: "## Per Session For Selected Version(s) ##"
    type: text
    title_text: "## Per Session For Selected Version(s) ##"
    subtitle_text: ''
    body_text: ''
    row: 20
    col: 12
    width: 12
    height: 2
  - name: "## Per Session ##"
    type: text
    title_text: "## Per Session ##"
    subtitle_text: ''
    body_text: ''
    row: 20
    col: 0
    width: 12
    height: 2
  - name: "## Per User ##"
    type: text
    title_text: "## Per User ##"
    subtitle_text: "(Based on Segment Anonymous ID)"
    body_text: ''
    row: 27
    col: 0
    width: 12
    height: 2
  - name: "## Per User For Selected Version(s) ##"
    type: text
    title_text: "## Per User For Selected Version(s) ##"
    subtitle_text: "(Based on Segment Anonymous ID)"
    body_text: ''
    row: 27
    col: 12
    width: 12
    height: 2
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
    explore: monitoring_metrics
    listens_to_filters: []
    field: monitoring_metrics.context_device_type
  - name: Full App Version
    title: Full App Version
    type: field_filter
    default_value: ios-2.8.0
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: popover
      options: []
    model: flink_v3
    explore: monitoring_metrics
    listens_to_filters: []
    field: monitoring_metrics.full_app_version
  - name: General View Date Range
    title: General View Date Range
    type: field_filter
    default_value: 7 day ago for 7 day
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
      options: []
    model: flink_v3
    explore: monitoring_metrics
    listens_to_filters: []
    field: monitoring_metrics.timestamp_date
  - name: Metrics Date
    title: Metrics Date
    type: field_filter
    default_value: 2021/09/03
    allow_multiple_values: true
    required: false
    ui_config:
      type: day_picker
      display: inline
      options: []
    model: flink_v3
    explore: monitoring_metrics
    listens_to_filters: []
    field: monitoring_metrics.timestamp_date
