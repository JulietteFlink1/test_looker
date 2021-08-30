- dashboard: intraday_voucher_redemption_monitoring_ct_migrated_ii
  title: Intraday Voucher Redemption Monitoring (CT Migrated II)
  layout: newspaper
  preferred_viewer: dashboards-next
  elements:
  - title: Intraday Voucher Redemption Monitoring - DE
    name: Intraday Voucher Redemption Monitoring - DE
    model: flink_v3
    explore: orders_discounts_hourly
    type: looker_line
    fields: [discounts.discount_code, orders_cl.count, orders_cl.created_hour]
    pivots: [discounts.discount_code]
    filters:
      orders_cl.created_date: today
      orders_cl.count: ">3"
      orders_cl.is_internal_order: 'no'
      orders_cl.is_successful_order: 'yes'
      hubs.country: Germany
      hubs.hub_name: ''
    sorts: [discounts.discount_code, orders_cl.created_hour desc]
    limit: 500
    total: true
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
    defaults_version: 1
    hidden_fields: []
    y_axes: []
    listen:
      Code: discounts.discount_code
      Used: discounts.used
    row: 2
    col: 0
    width: 13
    height: 8
  - title: 'Voucher Redemption - # Orders DE'
    name: 'Voucher Redemption - # Orders DE'
    model: flink_v3
    explore: orders_discounts_hourly
    type: looker_column
    fields: [discounts.discount_code, orders_cl.count]
    filters:
      orders_cl.created_date: today
      orders_cl.is_internal_order: 'no'
      orders_cl.is_successful_order: 'yes'
      hubs.country: Germany
      hubs.hub_name: ''
    sorts: [orders_cl.count desc]
    limit: 500
    total: true
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
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    series_types: {}
    hidden_fields: []
    y_axes: []
    listen:
      Code: discounts.discount_code
      Used: discounts.used
    row: 2
    col: 13
    width: 11
    height: 8
  - name: Germany
    type: text
    title_text: Germany
    body_text: ''
    row: 0
    col: 0
    width: 24
    height: 2
  - title: Intraday Voucher Redemption Monitoring - NL
    name: Intraday Voucher Redemption Monitoring - NL
    model: flink_v3
    explore: orders_discounts_hourly
    type: looker_line
    fields: [orders_cl.created_hour, discounts.discount_code, orders_cl.count]
    pivots: [discounts.discount_code]
    filters:
      orders_cl.created_date: today
      orders_cl.count: ">3"
      orders_cl.is_internal_order: 'no'
      orders_cl.is_successful_order: 'yes'
      hubs.country: Netherlands
      hubs.hub_name: ''
    sorts: [orders_cl.created_hour desc, discounts.discount_code]
    limit: 500
    total: true
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
    defaults_version: 1
    hidden_fields: []
    y_axes: []
    listen:
      Code: discounts.discount_code
      Used: discounts.used
    row: 12
    col: 0
    width: 13
    height: 8
  - title: 'Voucher Redemption - # Orders NL'
    name: 'Voucher Redemption - # Orders NL'
    model: flink_v3
    explore: orders_discounts_hourly
    type: looker_column
    fields: [discounts.discount_code, orders_cl.count]
    filters:
      orders_cl.created_date: today
      orders_cl.is_internal_order: 'no'
      orders_cl.is_successful_order: 'yes'
      hubs.country: Netherlands
      hubs.hub_name: ''
    sorts: [orders_cl.count desc]
    limit: 500
    total: true
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
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    series_types: {}
    hidden_fields: []
    y_axes: []
    listen:
      Code: discounts.discount_code
      Used: discounts.used
    row: 12
    col: 13
    width: 11
    height: 8
  - name: Netherlands
    type: text
    title_text: Netherlands
    body_text: ''
    row: 10
    col: 0
    width: 24
    height: 2
  - title: Intraday Voucher Redemption Monitoring - FR
    name: Intraday Voucher Redemption Monitoring - FR
    model: flink_v3
    explore: orders_discounts_hourly
    type: looker_line
    fields: [discounts.discount_code, orders_cl.created_hour, orders_cl.count]
    pivots: [discounts.discount_code]
    filters:
      orders_cl.created_date: today
      orders_cl.count: ">1"
      orders_cl.is_internal_order: 'no'
      orders_cl.is_successful_order: 'yes'
      hubs.country: France
      hubs.hub_name: ''
    sorts: [orders_cl.created_hour desc, discounts.discount_code]
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
    defaults_version: 1
    hidden_fields: []
    y_axes: []
    listen:
      Code: discounts.discount_code
      Used: discounts.used
    row: 22
    col: 0
    width: 13
    height: 7
  - title: 'Voucher Redemption - # Orders FR'
    name: 'Voucher Redemption - # Orders FR'
    model: flink_v3
    explore: orders_discounts_hourly
    type: looker_column
    fields: [discounts.discount_code, orders_cl.count]
    filters:
      orders_cl.created_date: today
      orders_cl.is_internal_order: 'no'
      orders_cl.is_successful_order: 'yes'
      hubs.country: France
      hubs.hub_name: ''
    sorts: [orders_cl.count desc]
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
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    series_types: {}
    hidden_fields: []
    y_axes: []
    listen:
      Code: discounts.discount_code
      Used: discounts.used
    row: 22
    col: 13
    width: 11
    height: 7
  - name: France
    type: text
    title_text: France
    body_text: ''
    row: 20
    col: 0
    width: 24
    height: 2
  filters:
  - name: Code
    title: Code
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: popover
      options: []
    model: flink_v3
    explore: orders_discounts_hourly
    listens_to_filters: []
    field: discounts.discount_code
  - name: Used
    title: Used
    type: field_filter
    default_value: ">10"
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: inline
      options: []
    model: flink_v3
    explore: orders_discounts_hourly
    listens_to_filters: []
    field: discounts.used
