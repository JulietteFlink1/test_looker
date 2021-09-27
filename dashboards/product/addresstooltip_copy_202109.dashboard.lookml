- dashboard: addresstooltip_copy_202109
  title: Addresstooltip Copy 202109
  layout: newspaper
  preferred_viewer: dashboards-next
  tile_size: 100
  elements:
  - title: Android % Sessions Late Address Change Returning Customers
    name: Android % Sessions Late Address Change Returning Customers
    model: flink_v3
    explore: address_tooltip_sessions
    type: looker_column
    fields: [address_tooltip_sessions.cnt_product_added_to_cart_and_address_confirmed,
      address_tooltip_sessions.cnt_late_address_change_maybe, address_tooltip_sessions.cnt_valid_orderplaced_before_addressconf,
      address_tooltip_sessions.cnt_hub_update_message_viewed, address_tooltip_sessions.full_app_version]
    filters:
      address_tooltip_sessions.returning_customer: 'Yes'
      address_tooltip_sessions.context_device_type: android
      address_tooltip_sessions.count: ">500"
    sorts: [address_tooltip_sessions.full_app_version]
    limit: 500
    column_limit: 50
    dynamic_fields: [{category: table_calculation, expression: "${address_tooltip_sessions.cnt_late_address_change_maybe}-${address_tooltip_sessions.cnt_valid_orderplaced_before_addressconf}",
        label: all late address change, value_format: !!null '', value_format_name: !!null '',
        _kind_hint: measure, table_calculation: all_late_address_change, _type_hint: number},
      {category: table_calculation, expression: "${address_tooltip_sessions.cnt_ontime_address_change}+${address_tooltip_sessions.cnt_afterorder_address_change}",
        label: all ontime address change, value_format: !!null '', value_format_name: !!null '',
        _kind_hint: measure, table_calculation: all_ontime_address_change, _type_hint: number,
        is_disabled: true}, {category: table_calculation, expression: "${all_late_address_change}/(${all_late_address_change}+${all_ontime_address_change})",
        label: "% late address selection", value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: late_address_selection, _type_hint: number,
        is_disabled: true}, {category: table_calculation, expression: "${address_tooltip_sessions.cnt_hub_update_message_viewed}",
        label: hub updated after product added, value_format: !!null '', value_format_name: !!null '',
        _kind_hint: measure, table_calculation: hub_updated_after_product_added, _type_hint: number,
        is_disabled: true}, {category: table_calculation, expression: "${all_late_address_change}/${address_tooltip_sessions.cnt_product_added_to_cart_and_address_confirmed}",
        label: "% late from PATC and AC sessions", value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: late_from_patc_and_ac_sessions, _type_hint: number},
      {category: table_calculation, expression: "${address_tooltip_sessions.cnt_hub_update_message_viewed}/${address_tooltip_sessions.cnt_product_added_to_cart_and_address_confirmed}",
        label: "% lost cart from PATC and AC sessions", value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: lost_cart_from_patc_and_ac_sessions,
        _type_hint: number}]
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
    y_axes: [{label: '', orientation: left, series: [{axisId: address_tooltip_sessions.cnt_product_added_to_cart_and_address_confirmed,
            id: address_tooltip_sessions.cnt_product_added_to_cart_and_address_confirmed,
            name: "# Sessions PATC And Address Confirmed"}], showLabels: true, showValues: true,
        unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear},
      {label: !!null '', orientation: right, series: [{axisId: late_from_patc_and_ac_sessions,
            id: late_from_patc_and_ac_sessions, name: "% late from PATC and AC sessions"}],
        showLabels: true, showValues: true, unpinAxis: false, tickDensity: default,
        tickDensityCustom: 5, type: linear}]
    x_axis_label: App Version
    series_types:
      late_from_patc_and_ac_sessions: line
    series_colors:
      address_tooltip_sessions.count: "#9eeaea"
      late_from_patc_and_ac_sessions: "#e5508e"
      address_tooltip_sessions.cnt_product_added_to_cart_and_address_confirmed: "#d7b9f9"
    series_labels:
      address_tooltip_sessions.count: "# Sessions Started"
      address_tooltip_sessions.cnt_product_added_to_cart: "# Sessions  Product Added\
        \ To Cart"
      address_tooltip_sessions.cnt_product_added_to_cart_and_address_confirmed: "#\
        \ Sessions With PATC And Address Confirmed"
      all_late_address_change: "# Sessions AC After PATC And Not Second Order"
      hub_updated_after_product_added: "# Sessions Cart Lost"
      late_from_patc_and_ac_sessions: "% Address Confirmed After PATC"
    show_dropoff: false
    defaults_version: 1
    hidden_fields: [address_tooltip_sessions.cnt_valid_orderplaced_before_addressconf,
      address_tooltip_sessions.cnt_late_address_change_maybe, address_tooltip_sessions.cnt_hub_update_message_viewed,
      all_late_address_change, lost_cart_from_patc_and_ac_sessions]
    show_null_points: true
    interpolation: linear
    listen:
      App Version: address_tooltip_sessions.full_app_version
    row: 37
    col: 0
    width: 12
    height: 7
  - title: Android % Sessions Address Tooltip Shown
    name: Android % Sessions Address Tooltip Shown
    model: flink_v3
    explore: address_tooltip_sessions
    type: looker_column
    fields: [address_tooltip_sessions.count, address_tooltip_sessions.cnt_tooltip_differentloc,
      address_tooltip_sessions.cnt_tooltip_onboarding, address_tooltip_sessions.cnt_tooltip_outsidearea,
      address_tooltip_sessions.session_start_at_date]
    fill_fields: [address_tooltip_sessions.session_start_at_date]
    filters:
      address_tooltip_sessions.context_device_type: android
    sorts: [address_tooltip_sessions.session_start_at_date desc]
    limit: 500
    column_limit: 50
    dynamic_fields: [{category: table_calculation, expression: "${address_tooltip_sessions.cnt_tooltip_differentloc}/${address_tooltip_sessions.count}",
        label: "% tooltip diffloc", value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: tooltip_diffloc, _type_hint: number},
      {category: table_calculation, expression: "${address_tooltip_sessions.cnt_tooltip_onboarding}/${address_tooltip_sessions.count}",
        label: "% tooltip onboarding", value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: tooltip_onboarding, _type_hint: number}]
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
    show_totals_labels: true
    show_silhouette: false
    totals_color: "#000000"
    y_axes: [{label: '', orientation: left, series: [{axisId: address_tooltip_sessions.count,
            id: address_tooltip_sessions.count, name: address_tooltip_sessions}],
        showLabels: true, showValues: true, unpinAxis: false, tickDensity: default,
        tickDensityCustom: 5, type: linear}, {label: !!null '', orientation: right,
        series: [{axisId: tooltip_onboarding, id: tooltip_onboarding, name: "% tooltip\
              \ onboarding"}, {axisId: tooltip_diffloc, id: tooltip_diffloc, name: "%\
              \ tooltip diffloc"}], showLabels: true, showValues: true, unpinAxis: false,
        tickDensity: default, tickDensityCustom: 5, type: linear}]
    series_types:
      address_tooltip_sessions.count: area
    series_colors:
      address_tooltip_sessions.count: "#9eeaea"
      tooltip_onboarding: "#ec84af"
    series_labels:
      address_tooltip_sessions.count: "# Sessions"
      tooltip_diffloc: "% Tooltip Different Location"
      tooltip_onboarding: "% Tooltip Onboarding"
    label_color: [transparent, "#ffffff", "#ffffff"]
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    hidden_fields: [address_tooltip_sessions.cnt_tooltip_differentloc, address_tooltip_sessions.cnt_tooltip_onboarding,
      address_tooltip_sessions.cnt_tooltip_outsidearea]
    listen:
      App Version: address_tooltip_sessions.full_app_version
      Session Start Date: address_tooltip_sessions.session_start_at_date
    row: 10
    col: 0
    width: 12
    height: 7
  - title: iOS % Sessions Address Tooltip Shown
    name: iOS % Sessions Address Tooltip Shown
    model: flink_v3
    explore: address_tooltip_sessions
    type: looker_column
    fields: [address_tooltip_sessions.count, address_tooltip_sessions.cnt_tooltip_differentloc,
      address_tooltip_sessions.cnt_tooltip_onboarding, address_tooltip_sessions.cnt_tooltip_outsidearea,
      address_tooltip_sessions.session_start_at_date]
    fill_fields: [address_tooltip_sessions.session_start_at_date]
    filters:
      address_tooltip_sessions.context_device_type: ios
    sorts: [address_tooltip_sessions.session_start_at_date desc]
    limit: 500
    column_limit: 50
    dynamic_fields: [{category: table_calculation, expression: "${address_tooltip_sessions.cnt_tooltip_differentloc}/${address_tooltip_sessions.count}",
        label: "% tooltip diffloc", value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: tooltip_diffloc, _type_hint: number},
      {category: table_calculation, expression: "${address_tooltip_sessions.cnt_tooltip_onboarding}/${address_tooltip_sessions.count}",
        label: "% tooltip onboarding", value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: tooltip_onboarding, _type_hint: number}]
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
    show_totals_labels: true
    show_silhouette: false
    totals_color: "#000000"
    y_axes: [{label: '', orientation: left, series: [{axisId: address_tooltip_sessions.count,
            id: address_tooltip_sessions.count, name: address_tooltip_sessions}],
        showLabels: true, showValues: true, unpinAxis: false, tickDensity: default,
        tickDensityCustom: 5, type: linear}, {label: !!null '', orientation: right,
        series: [{axisId: tooltip_onboarding, id: tooltip_onboarding, name: "% tooltip\
              \ onboarding"}, {axisId: tooltip_diffloc, id: tooltip_diffloc, name: "%\
              \ tooltip diffloc"}], showLabels: true, showValues: true, unpinAxis: false,
        tickDensity: default, tickDensityCustom: 5, type: linear}]
    series_types:
      address_tooltip_sessions.count: area
    series_colors:
      address_tooltip_sessions.count: "#9eeaea"
      tooltip_onboarding: "#ec84af"
    series_labels:
      address_tooltip_sessions.count: "# Sessions"
      tooltip_diffloc: "% Tooltip Different Location"
      tooltip_onboarding: "% Tooltip Onboarding"
    label_color: [transparent, "#ffffff", "#ffffff"]
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    hidden_fields: [address_tooltip_sessions.cnt_tooltip_differentloc, address_tooltip_sessions.cnt_tooltip_onboarding,
      address_tooltip_sessions.cnt_tooltip_outsidearea]
    listen:
      App Version: address_tooltip_sessions.full_app_version
      Session Start Date: address_tooltip_sessions.session_start_at_date
    row: 10
    col: 12
    width: 12
    height: 7
  - title: Android % Sessions Address Confirmed If No Previous Address
    name: Android % Sessions Address Confirmed If No Previous Address
    model: flink_v3
    explore: address_tooltip_sessions
    type: looker_column
    fields: [address_tooltip_sessions.count, address_tooltip_sessions.full_app_version,
      address_tooltip_sessions.cnt_address_confirmed]
    filters:
      address_tooltip_sessions.context_device_type: android
      address_tooltip_sessions.count: ">500"
      address_tooltip_sessions.has_previously_set_address: 'No'
    sorts: [address_tooltip_sessions.full_app_version]
    limit: 500
    column_limit: 50
    dynamic_fields: [{category: table_calculation, expression: "${address_tooltip_sessions.cnt_tooltip_differentloc}/${address_tooltip_sessions.count}",
        label: "% tooltip diffloc", value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: tooltip_diffloc, _type_hint: number,
        is_disabled: true}, {category: table_calculation, expression: "${address_tooltip_sessions.cnt_tooltip_onboarding}/${address_tooltip_sessions.count}",
        label: "% tooltip onboarding", value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: tooltip_onboarding, _type_hint: number,
        is_disabled: true}, {category: table_calculation, expression: "${address_tooltip_sessions.cnt_address_confirmed}/${address_tooltip_sessions.count}",
        label: perc, value_format: !!null '', value_format_name: percent_1, _kind_hint: measure,
        table_calculation: perc, _type_hint: number}]
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
    show_totals_labels: true
    show_silhouette: false
    totals_color: "#000000"
    y_axes: [{label: "# Sessions", orientation: left, series: [{axisId: address_tooltip_sessions.count,
            id: address_tooltip_sessions.count, name: "# Sessions"}], showLabels: true,
        showValues: true, unpinAxis: false, tickDensity: default, tickDensityCustom: 5,
        type: linear}, {label: '', orientation: right, series: [{axisId: perc, id: perc,
            name: "% Address Confirmed"}], showLabels: true, showValues: true, unpinAxis: false,
        tickDensity: default, type: linear}]
    x_axis_label: App Version
    series_types:
      perc: line
    series_colors:
      address_tooltip_sessions.count: "#d5f6f6"
      tooltip_onboarding: "#4276BE"
      address_tooltip_sessions.mcvr1: "#4276BE"
      perc: "#4276BE"
    series_labels:
      address_tooltip_sessions.count: "# Sessions"
      address_tooltip_sessions.mcvr1: Address Confirmed
      perc: "% Address Confirmed"
    label_color: [transparent, "#4276BE"]
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    hidden_fields: [address_tooltip_sessions.cnt_address_confirmed]
    listen:
      App Version: address_tooltip_sessions.full_app_version
    row: 19
    col: 0
    width: 12
    height: 7
  - title: iOS % Sessions Address Confirmed If No Previous Address
    name: iOS % Sessions Address Confirmed If No Previous Address
    model: flink_v3
    explore: address_tooltip_sessions
    type: looker_column
    fields: [address_tooltip_sessions.count, address_tooltip_sessions.full_app_version,
      address_tooltip_sessions.cnt_address_confirmed]
    filters:
      address_tooltip_sessions.context_device_type: ios
      address_tooltip_sessions.count: ">500"
      address_tooltip_sessions.has_previously_set_address: 'No'
    sorts: [address_tooltip_sessions.full_app_version]
    limit: 500
    column_limit: 50
    dynamic_fields: [{category: table_calculation, expression: "${address_tooltip_sessions.cnt_tooltip_differentloc}/${address_tooltip_sessions.count}",
        label: "% tooltip diffloc", value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: tooltip_diffloc, _type_hint: number,
        is_disabled: true}, {category: table_calculation, expression: "${address_tooltip_sessions.cnt_tooltip_onboarding}/${address_tooltip_sessions.count}",
        label: "% tooltip onboarding", value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: tooltip_onboarding, _type_hint: number,
        is_disabled: true}, {category: table_calculation, expression: "${address_tooltip_sessions.cnt_address_confirmed}/${address_tooltip_sessions.count}",
        label: perc, value_format: !!null '', value_format_name: percent_1, _kind_hint: measure,
        table_calculation: perc, _type_hint: number}]
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
    show_totals_labels: true
    show_silhouette: false
    totals_color: "#000000"
    y_axes: [{label: "# Sessions", orientation: left, series: [{axisId: address_tooltip_sessions.count,
            id: address_tooltip_sessions.count, name: "# Sessions"}], showLabels: true,
        showValues: true, unpinAxis: false, tickDensity: default, tickDensityCustom: 5,
        type: linear}, {label: '', orientation: right, series: [{axisId: perc, id: perc,
            name: "% Address Confirmed"}], showLabels: true, showValues: true, unpinAxis: false,
        tickDensity: default, type: linear}]
    x_axis_label: App Version
    series_types:
      perc: line
    series_colors:
      address_tooltip_sessions.count: "#d5f6f6"
      tooltip_onboarding: "#4276BE"
      address_tooltip_sessions.mcvr1: "#4276BE"
      perc: "#4276BE"
    series_labels:
      address_tooltip_sessions.count: "# Sessions"
      address_tooltip_sessions.mcvr1: Address Confirmed
      perc: "% Address Confirmed"
    label_color: [transparent, "#4276BE"]
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    hidden_fields: [address_tooltip_sessions.cnt_address_confirmed]
    listen:
      App Version: address_tooltip_sessions.full_app_version
    row: 19
    col: 12
    width: 12
    height: 7
  - name: Did the address tooltip impact mCVR1?
    type: text
    title_text: Did the address tooltip impact mCVR1?
    subtitle_text: "-> no discernible positive impact. mCVR1 is decreasing on iOS "
    body_text: ''
    row: 55
    col: 0
    width: 24
    height: 2
  - name: 'Are users with previously selected address more likely to change their
      address? '
    type: text
    title_text: 'Are users with previously selected address more likely to change
      their address? '
    subtitle_text: "-> no on android, yes on iOS"
    body_text: ''
    row: 26
    col: 1
    width: 23
    height: 2
  - name: 'Are users without previously selected address more likely to confirm an
      address? '
    type: text
    title_text: 'Are users without previously selected address more likely to confirm
      an address? '
    subtitle_text: "-> no"
    body_text: ''
    row: 17
    col: 0
    width: 24
    height: 2
  - name: How many sessions include an address tooltip?
    type: text
    title_text: How many sessions include an address tooltip?
    subtitle_text: ''
    body_text: ''
    row: 8
    col: 0
    width: 24
    height: 2
  - title: Android % Sessions Address Change
    name: Android % Sessions Address Change
    model: flink_v3
    explore: address_tooltip_sessions
    type: looker_column
    fields: [address_tooltip_sessions.count, address_tooltip_sessions.full_app_version,
      address_tooltip_sessions.cnt_address_confirmed]
    filters:
      address_tooltip_sessions.context_device_type: android
      address_tooltip_sessions.count: ">500"
      address_tooltip_sessions.has_previously_set_address: 'Yes'
    sorts: [address_tooltip_sessions.full_app_version]
    limit: 500
    column_limit: 50
    dynamic_fields: [{category: table_calculation, expression: "${address_tooltip_sessions.cnt_tooltip_differentloc}/${address_tooltip_sessions.count}",
        label: "% tooltip diffloc", value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: tooltip_diffloc, _type_hint: number,
        is_disabled: true}, {category: table_calculation, expression: "${address_tooltip_sessions.cnt_tooltip_onboarding}/${address_tooltip_sessions.count}",
        label: "% tooltip onboarding", value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: tooltip_onboarding, _type_hint: number,
        is_disabled: true}, {category: table_calculation, expression: "${address_tooltip_sessions.cnt_address_confirmed}/${address_tooltip_sessions.count}",
        label: perc, value_format: !!null '', value_format_name: percent_1, _kind_hint: measure,
        table_calculation: perc, _type_hint: number}]
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
    show_totals_labels: true
    show_silhouette: false
    totals_color: "#000000"
    y_axes: [{label: "# Sessions", orientation: left, series: [{axisId: address_tooltip_sessions.count,
            id: address_tooltip_sessions.count, name: "# Sessions"}], showLabels: true,
        showValues: true, unpinAxis: false, tickDensity: default, tickDensityCustom: 5,
        type: linear}, {label: '', orientation: right, series: [{axisId: perc, id: perc,
            name: "% Address Confirmed"}], showLabels: true, showValues: true, unpinAxis: false,
        tickDensity: default, type: linear}]
    x_axis_label: App Version
    series_types:
      perc: line
    series_colors:
      address_tooltip_sessions.count: "#d5f6f6"
      tooltip_onboarding: "#4276BE"
      address_tooltip_sessions.mcvr1: "#4276BE"
      perc: "#4276BE"
    series_labels:
      address_tooltip_sessions.count: "# Sessions"
      address_tooltip_sessions.mcvr1: Address Confirmed
      perc: "% Address Confirmed"
    label_color: [transparent, "#4276BE"]
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    hidden_fields: [address_tooltip_sessions.cnt_address_confirmed]
    listen:
      App Version: address_tooltip_sessions.full_app_version
    row: 28
    col: 0
    width: 12
    height: 7
  - title: iOS % Sessions Address Change
    name: iOS % Sessions Address Change
    model: flink_v3
    explore: address_tooltip_sessions
    type: looker_column
    fields: [address_tooltip_sessions.count, address_tooltip_sessions.full_app_version,
      address_tooltip_sessions.cnt_address_confirmed]
    filters:
      address_tooltip_sessions.context_device_type: ios
      address_tooltip_sessions.count: ">500"
      address_tooltip_sessions.has_previously_set_address: 'Yes'
    sorts: [address_tooltip_sessions.full_app_version]
    limit: 500
    column_limit: 50
    dynamic_fields: [{category: table_calculation, expression: "${address_tooltip_sessions.cnt_tooltip_differentloc}/${address_tooltip_sessions.count}",
        label: "% tooltip diffloc", value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: tooltip_diffloc, _type_hint: number,
        is_disabled: true}, {category: table_calculation, expression: "${address_tooltip_sessions.cnt_tooltip_onboarding}/${address_tooltip_sessions.count}",
        label: "% tooltip onboarding", value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: tooltip_onboarding, _type_hint: number,
        is_disabled: true}, {category: table_calculation, expression: "${address_tooltip_sessions.cnt_address_confirmed}/${address_tooltip_sessions.count}",
        label: perc, value_format: !!null '', value_format_name: percent_1, _kind_hint: measure,
        table_calculation: perc, _type_hint: number}]
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
    show_totals_labels: true
    show_silhouette: false
    totals_color: "#000000"
    y_axes: [{label: "# Sessions", orientation: left, series: [{axisId: address_tooltip_sessions.count,
            id: address_tooltip_sessions.count, name: "# Sessions"}], showLabels: true,
        showValues: true, unpinAxis: false, tickDensity: default, tickDensityCustom: 5,
        type: linear}, {label: '', orientation: right, series: [{axisId: perc, id: perc,
            name: "% Address Confirmed"}], showLabels: true, showValues: true, unpinAxis: false,
        tickDensity: default, type: linear}]
    x_axis_label: App Version
    series_types:
      perc: line
    series_colors:
      address_tooltip_sessions.count: "#d5f6f6"
      tooltip_onboarding: "#4276BE"
      address_tooltip_sessions.mcvr1: "#4276BE"
      perc: "#4276BE"
    series_labels:
      address_tooltip_sessions.count: "# Sessions"
      address_tooltip_sessions.mcvr1: Address Confirmed
      perc: "% Address Confirmed"
    label_color: [transparent, "#4276BE"]
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    hidden_fields: [address_tooltip_sessions.cnt_address_confirmed]
    listen:
      App Version: address_tooltip_sessions.full_app_version
    row: 28
    col: 12
    width: 12
    height: 7
  - name: Are returning customers (has ordered before) more likely to change address
      on time (rather than after adding a product)?
    type: text
    title_text: Are returning customers (has ordered before) more likely to change
      address on time (rather than after adding a product)?
    subtitle_text: " -> yes, but there appears to be an increase again one version\
      \ later, check again after another release"
    body_text: ''
    row: 35
    col: 0
    width: 24
    height: 2
  - title: iOS % Sessions Late Address Change Returning Customers
    name: iOS % Sessions Late Address Change Returning Customers
    model: flink_v3
    explore: address_tooltip_sessions
    type: looker_column
    fields: [address_tooltip_sessions.cnt_product_added_to_cart_and_address_confirmed,
      address_tooltip_sessions.cnt_late_address_change_maybe, address_tooltip_sessions.cnt_valid_orderplaced_before_addressconf,
      address_tooltip_sessions.cnt_hub_update_message_viewed, address_tooltip_sessions.full_app_version]
    filters:
      address_tooltip_sessions.returning_customer: 'Yes'
      address_tooltip_sessions.context_device_type: ios
      address_tooltip_sessions.count: ">500"
    sorts: [address_tooltip_sessions.full_app_version]
    limit: 500
    column_limit: 50
    dynamic_fields: [{category: table_calculation, expression: "${address_tooltip_sessions.cnt_late_address_change_maybe}-${address_tooltip_sessions.cnt_valid_orderplaced_before_addressconf}",
        label: all late address change, value_format: !!null '', value_format_name: !!null '',
        _kind_hint: measure, table_calculation: all_late_address_change, _type_hint: number},
      {category: table_calculation, expression: "${address_tooltip_sessions.cnt_ontime_address_change}+${address_tooltip_sessions.cnt_afterorder_address_change}",
        label: all ontime address change, value_format: !!null '', value_format_name: !!null '',
        _kind_hint: measure, table_calculation: all_ontime_address_change, _type_hint: number,
        is_disabled: true}, {category: table_calculation, expression: "${all_late_address_change}/(${all_late_address_change}+${all_ontime_address_change})",
        label: "% late address selection", value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: late_address_selection, _type_hint: number,
        is_disabled: true}, {category: table_calculation, expression: "${address_tooltip_sessions.cnt_hub_update_message_viewed}",
        label: hub updated after product added, value_format: !!null '', value_format_name: !!null '',
        _kind_hint: measure, table_calculation: hub_updated_after_product_added, _type_hint: number,
        is_disabled: true}, {category: table_calculation, expression: "${all_late_address_change}/${address_tooltip_sessions.cnt_product_added_to_cart_and_address_confirmed}",
        label: "% late from PATC and AC sessions", value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: late_from_patc_and_ac_sessions, _type_hint: number},
      {category: table_calculation, expression: "${address_tooltip_sessions.cnt_hub_update_message_viewed}/${address_tooltip_sessions.cnt_product_added_to_cart_and_address_confirmed}",
        label: "% lost cart from PATC and AC sessions", value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: lost_cart_from_patc_and_ac_sessions,
        _type_hint: number}]
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
    y_axes: [{label: '', orientation: left, series: [{axisId: address_tooltip_sessions.cnt_product_added_to_cart_and_address_confirmed,
            id: address_tooltip_sessions.cnt_product_added_to_cart_and_address_confirmed,
            name: "# Sessions PATC And Address Confirmed"}], showLabels: true, showValues: true,
        unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear},
      {label: !!null '', orientation: right, series: [{axisId: late_from_patc_and_ac_sessions,
            id: late_from_patc_and_ac_sessions, name: "% late from PATC and AC sessions"}],
        showLabels: true, showValues: true, unpinAxis: false, tickDensity: default,
        tickDensityCustom: 5, type: linear}]
    x_axis_label: App Version
    series_types:
      late_from_patc_and_ac_sessions: line
    series_colors:
      address_tooltip_sessions.count: "#9eeaea"
      late_from_patc_and_ac_sessions: "#e5508e"
      address_tooltip_sessions.cnt_product_added_to_cart_and_address_confirmed: "#d7b9f9"
    series_labels:
      address_tooltip_sessions.count: "# Sessions Started"
      address_tooltip_sessions.cnt_product_added_to_cart: "# Sessions  Product Added\
        \ To Cart"
      address_tooltip_sessions.cnt_product_added_to_cart_and_address_confirmed: "#\
        \ Sessions With PATC And Address Confirmed"
      all_late_address_change: "# Sessions AC After PATC And Not Second Order"
      hub_updated_after_product_added: "# Sessions Cart Lost"
      late_from_patc_and_ac_sessions: "% Address Confirmed After PATC"
    show_dropoff: false
    defaults_version: 1
    hidden_fields: [address_tooltip_sessions.cnt_valid_orderplaced_before_addressconf,
      address_tooltip_sessions.cnt_late_address_change_maybe, address_tooltip_sessions.cnt_hub_update_message_viewed,
      all_late_address_change, lost_cart_from_patc_and_ac_sessions]
    show_null_points: true
    interpolation: linear
    listen:
      App Version: address_tooltip_sessions.full_app_version
    row: 37
    col: 12
    width: 12
    height: 7
  - name: Are returning customers (has ordered before) less likely to lose cart due
      to late address change? (Android only)
    type: text
    title_text: Are returning customers (has ordered before) less likely to lose cart
      due to late address change? (Android only)
    subtitle_text: " -> yes, but seems to increase again later, check after another\
      \ release"
    body_text: ''
    row: 44
    col: 0
    width: 24
    height: 2
  - title: Android % Sessions Lost Cart Due To Hub Update
    name: Android % Sessions Lost Cart Due To Hub Update
    model: flink_v3
    explore: address_tooltip_sessions
    type: looker_column
    fields: [address_tooltip_sessions.cnt_product_added_to_cart_and_address_confirmed,
      address_tooltip_sessions.cnt_late_address_change_maybe, address_tooltip_sessions.cnt_valid_orderplaced_before_addressconf,
      address_tooltip_sessions.cnt_hub_update_message_viewed, address_tooltip_sessions.full_app_version,
      address_tooltip_sessions.cnt_late_address_change]
    filters:
      address_tooltip_sessions.returning_customer: 'Yes'
      address_tooltip_sessions.context_device_type: android
      address_tooltip_sessions.count: ">500"
    sorts: [address_tooltip_sessions.full_app_version]
    limit: 500
    column_limit: 50
    dynamic_fields: [{category: table_calculation, expression: "${address_tooltip_sessions.cnt_late_address_change_maybe}-${address_tooltip_sessions.cnt_valid_orderplaced_before_addressconf}",
        label: all late address change, value_format: !!null '', value_format_name: !!null '',
        _kind_hint: measure, table_calculation: all_late_address_change, _type_hint: number},
      {category: table_calculation, expression: "${address_tooltip_sessions.cnt_ontime_address_change}+${address_tooltip_sessions.cnt_afterorder_address_change}",
        label: all ontime address change, value_format: !!null '', value_format_name: !!null '',
        _kind_hint: measure, table_calculation: all_ontime_address_change, _type_hint: number,
        is_disabled: true}, {category: table_calculation, expression: "${all_late_address_change}/(${all_late_address_change}+${all_ontime_address_change})",
        label: "% late address selection", value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: late_address_selection, _type_hint: number,
        is_disabled: true}, {category: table_calculation, expression: "${address_tooltip_sessions.cnt_hub_update_message_viewed}",
        label: hub updated after product added, value_format: !!null '', value_format_name: !!null '',
        _kind_hint: measure, table_calculation: hub_updated_after_product_added, _type_hint: number,
        is_disabled: true}, {category: table_calculation, expression: "${all_late_address_change}/${address_tooltip_sessions.cnt_product_added_to_cart_and_address_confirmed}",
        label: "% late from PATC and AC sessions", value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: late_from_patc_and_ac_sessions, _type_hint: number},
      {category: table_calculation, expression: "${address_tooltip_sessions.cnt_hub_update_message_viewed}/${address_tooltip_sessions.cnt_product_added_to_cart_and_address_confirmed}",
        label: "% lost cart from PATC and AC sessions", value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: lost_cart_from_patc_and_ac_sessions,
        _type_hint: number}]
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
    y_axes: [{label: '', orientation: left, series: [{axisId: address_tooltip_sessions.cnt_product_added_to_cart_and_address_confirmed,
            id: address_tooltip_sessions.cnt_product_added_to_cart_and_address_confirmed,
            name: "# Sessions With PATC And Address Confirmed"}], showLabels: true,
        showValues: true, unpinAxis: false, tickDensity: default, tickDensityCustom: 5,
        type: linear}, {label: '', orientation: right, series: [{axisId: lost_cart_from_patc_and_ac_sessions,
            id: lost_cart_from_patc_and_ac_sessions, name: "% lost cart from PATC\
              \ and AC sessions"}], showLabels: true, showValues: true, unpinAxis: false,
        tickDensity: default, type: linear}]
    x_axis_label: App Version
    series_types:
      late_from_patc_and_ac_sessions: line
      lost_cart_from_patc_and_ac_sessions: line
    series_colors:
      address_tooltip_sessions.count: "#9eeaea"
      late_from_patc_and_ac_sessions: "#e5508e"
      address_tooltip_sessions.cnt_product_added_to_cart_and_address_confirmed: "#d7b9f9"
      lost_cart_from_patc_and_ac_sessions: "#e5508e"
    series_labels:
      address_tooltip_sessions.count: "# Sessions Started"
      address_tooltip_sessions.cnt_product_added_to_cart: "# Sessions  Product Added\
        \ To Cart"
      address_tooltip_sessions.cnt_product_added_to_cart_and_address_confirmed: "#\
        \ Sessions With PATC And Address Confirmed"
      all_late_address_change: "# Sessions AC After PATC And Not Second Order"
      hub_updated_after_product_added: "# Sessions Cart Lost"
      late_from_patc_and_ac_sessions: "% Address Confirmed After PATC"
      lost_cart_from_patc_and_ac_sessions: "% Lost Cart Due To Hub Update"
    show_dropoff: false
    defaults_version: 1
    hidden_fields: [address_tooltip_sessions.cnt_valid_orderplaced_before_addressconf,
      address_tooltip_sessions.cnt_late_address_change_maybe, address_tooltip_sessions.cnt_hub_update_message_viewed,
      all_late_address_change, address_tooltip_sessions.cnt_late_address_change, late_from_patc_and_ac_sessions]
    show_null_points: true
    interpolation: linear
    listen:
      App Version: address_tooltip_sessions.full_app_version
    row: 46
    col: 0
    width: 12
    height: 7
  - name: Did the address tooltip impact CR for sessions with product added to cart
      and address confirmed?
    type: text
    title_text: Did the address tooltip impact CR for sessions with product added
      to cart and address confirmed?
    subtitle_text: "-> no discernable impact"
    body_text: ''
    row: 64
    col: 0
    width: 24
    height: 2
  - title: Android CR from sessions with PATC and Address Confirmed
    name: Android CR from sessions with PATC and Address Confirmed
    model: flink_v3
    explore: address_tooltip_sessions
    type: looker_column
    fields: [address_tooltip_sessions.cnt_product_added_to_cart_and_address_confirmed,
      address_tooltip_sessions.full_app_version, address_tooltip_sessions.cnt_order_placed]
    filters:
      address_tooltip_sessions.returning_customer: 'Yes'
      address_tooltip_sessions.context_device_type: android
      address_tooltip_sessions.count: ">500"
      address_tooltip_sessions.product_added_to_cart_count: ">0"
      address_tooltip_sessions.address_confirmed_count: ">0"
    sorts: [address_tooltip_sessions.full_app_version]
    limit: 500
    column_limit: 50
    dynamic_fields: [{category: table_calculation, expression: "${address_tooltip_sessions.cnt_late_address_change_maybe}-${address_tooltip_sessions.cnt_valid_orderplaced_before_addressconf}",
        label: all late address change, value_format: !!null '', value_format_name: !!null '',
        _kind_hint: measure, table_calculation: all_late_address_change, _type_hint: number,
        is_disabled: true}, {category: table_calculation, expression: "${address_tooltip_sessions.cnt_ontime_address_change}+${address_tooltip_sessions.cnt_afterorder_address_change}",
        label: all ontime address change, value_format: !!null '', value_format_name: !!null '',
        _kind_hint: measure, table_calculation: all_ontime_address_change, _type_hint: number,
        is_disabled: true}, {category: table_calculation, expression: "${all_late_address_change}/(${all_late_address_change}+${all_ontime_address_change})",
        label: "% late address selection", value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: late_address_selection, _type_hint: number,
        is_disabled: true}, {category: table_calculation, expression: "${address_tooltip_sessions.cnt_hub_update_message_viewed}",
        label: hub updated after product added, value_format: !!null '', value_format_name: !!null '',
        _kind_hint: measure, table_calculation: hub_updated_after_product_added, _type_hint: number,
        is_disabled: true}, {category: table_calculation, expression: "${all_late_address_change}/${address_tooltip_sessions.cnt_product_added_to_cart_and_address_confirmed}",
        label: "% late from PATC and AC sessions", value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: late_from_patc_and_ac_sessions, _type_hint: number,
        is_disabled: true}, {category: table_calculation, expression: "${address_tooltip_sessions.cnt_hub_update_message_viewed}/${address_tooltip_sessions.cnt_product_added_to_cart_and_address_confirmed}",
        label: "% lost cart from PATC and AC sessions", value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: lost_cart_from_patc_and_ac_sessions,
        _type_hint: number, is_disabled: true}, {category: table_calculation, expression: "${address_tooltip_sessions.cnt_order_placed}/${address_tooltip_sessions.cnt_product_added_to_cart_and_address_confirmed}",
        label: cr, value_format: !!null '', value_format_name: percent_1, _kind_hint: measure,
        table_calculation: cr, _type_hint: number}]
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
    y_axes: [{label: '', orientation: left, series: [{axisId: address_tooltip_sessions.cnt_product_added_to_cart_and_address_confirmed,
            id: address_tooltip_sessions.cnt_product_added_to_cart_and_address_confirmed,
            name: "# Sessions With PATC And Address Confirmed"}], showLabels: true,
        showValues: true, unpinAxis: false, tickDensity: default, tickDensityCustom: 5,
        type: linear}, {label: '', orientation: right, series: [{axisId: cr, id: cr,
            name: cr}], showLabels: true, showValues: true, unpinAxis: false, tickDensity: default,
        type: linear}]
    series_types:
      late_from_patc_and_ac_sessions: line
      cr: line
    series_colors:
      address_tooltip_sessions.count: "#9eeaea"
      late_from_patc_and_ac_sessions: "#e5508e"
      address_tooltip_sessions.cnt_product_added_to_cart_and_address_confirmed: "#d7b9f9"
      cr: "#f98662"
    series_labels:
      address_tooltip_sessions.count: "# Sessions Started"
      address_tooltip_sessions.cnt_product_added_to_cart: "# Sessions  Product Added\
        \ To Cart"
      address_tooltip_sessions.cnt_product_added_to_cart_and_address_confirmed: "#\
        \ Sessions With PATC And Address Confirmed"
      all_late_address_change: "# Sessions AC After PATC And Not Second Order"
      hub_updated_after_product_added: "# Sessions Cart Lost"
      late_from_patc_and_ac_sessions: "% Address Confirmed After PATC"
      cr: "% Order Placed From Sessions With PATC And Address Confirmed"
    show_dropoff: false
    defaults_version: 1
    hidden_fields: [address_tooltip_sessions.cnt_order_placed]
    show_null_points: true
    interpolation: linear
    listen:
      App Version: address_tooltip_sessions.full_app_version
    row: 66
    col: 0
    width: 12
    height: 7
  - title: iOS CR from sessions with PATC and Address Confirmed
    name: iOS CR from sessions with PATC and Address Confirmed
    model: flink_v3
    explore: address_tooltip_sessions
    type: looker_column
    fields: [address_tooltip_sessions.cnt_product_added_to_cart_and_address_confirmed,
      address_tooltip_sessions.full_app_version, address_tooltip_sessions.cnt_order_placed]
    filters:
      address_tooltip_sessions.returning_customer: 'Yes'
      address_tooltip_sessions.context_device_type: ios
      address_tooltip_sessions.count: ">500"
      address_tooltip_sessions.product_added_to_cart_count: ">0"
      address_tooltip_sessions.address_confirmed_count: ">0"
    sorts: [address_tooltip_sessions.full_app_version]
    limit: 500
    column_limit: 50
    dynamic_fields: [{category: table_calculation, expression: "${address_tooltip_sessions.cnt_late_address_change_maybe}-${address_tooltip_sessions.cnt_valid_orderplaced_before_addressconf}",
        label: all late address change, value_format: !!null '', value_format_name: !!null '',
        _kind_hint: measure, table_calculation: all_late_address_change, _type_hint: number,
        is_disabled: true}, {category: table_calculation, expression: "${address_tooltip_sessions.cnt_ontime_address_change}+${address_tooltip_sessions.cnt_afterorder_address_change}",
        label: all ontime address change, value_format: !!null '', value_format_name: !!null '',
        _kind_hint: measure, table_calculation: all_ontime_address_change, _type_hint: number,
        is_disabled: true}, {category: table_calculation, expression: "${all_late_address_change}/(${all_late_address_change}+${all_ontime_address_change})",
        label: "% late address selection", value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: late_address_selection, _type_hint: number,
        is_disabled: true}, {category: table_calculation, expression: "${address_tooltip_sessions.cnt_hub_update_message_viewed}",
        label: hub updated after product added, value_format: !!null '', value_format_name: !!null '',
        _kind_hint: measure, table_calculation: hub_updated_after_product_added, _type_hint: number,
        is_disabled: true}, {category: table_calculation, expression: "${all_late_address_change}/${address_tooltip_sessions.cnt_product_added_to_cart_and_address_confirmed}",
        label: "% late from PATC and AC sessions", value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: late_from_patc_and_ac_sessions, _type_hint: number,
        is_disabled: true}, {category: table_calculation, expression: "${address_tooltip_sessions.cnt_hub_update_message_viewed}/${address_tooltip_sessions.cnt_product_added_to_cart_and_address_confirmed}",
        label: "% lost cart from PATC and AC sessions", value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: lost_cart_from_patc_and_ac_sessions,
        _type_hint: number, is_disabled: true}, {category: table_calculation, expression: "${address_tooltip_sessions.cnt_order_placed}/${address_tooltip_sessions.cnt_product_added_to_cart_and_address_confirmed}",
        label: cr, value_format: !!null '', value_format_name: percent_1, _kind_hint: measure,
        table_calculation: cr, _type_hint: number}]
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
    y_axes: [{label: '', orientation: left, series: [{axisId: address_tooltip_sessions.cnt_product_added_to_cart_and_address_confirmed,
            id: address_tooltip_sessions.cnt_product_added_to_cart_and_address_confirmed,
            name: "# Sessions With PATC And Address Confirmed"}], showLabels: true,
        showValues: true, unpinAxis: false, tickDensity: default, tickDensityCustom: 5,
        type: linear}, {label: '', orientation: right, series: [{axisId: cr, id: cr,
            name: cr}], showLabels: true, showValues: true, unpinAxis: false, tickDensity: default,
        type: linear}]
    series_types:
      late_from_patc_and_ac_sessions: line
      cr: line
    series_colors:
      address_tooltip_sessions.count: "#9eeaea"
      late_from_patc_and_ac_sessions: "#e5508e"
      address_tooltip_sessions.cnt_product_added_to_cart_and_address_confirmed: "#d7b9f9"
      cr: "#f98662"
    series_labels:
      address_tooltip_sessions.count: "# Sessions Started"
      address_tooltip_sessions.cnt_product_added_to_cart: "# Sessions  Product Added\
        \ To Cart"
      address_tooltip_sessions.cnt_product_added_to_cart_and_address_confirmed: "#\
        \ Sessions With PATC And Address Confirmed"
      all_late_address_change: "# Sessions AC After PATC And Not Second Order"
      hub_updated_after_product_added: "# Sessions Cart Lost"
      late_from_patc_and_ac_sessions: "% Address Confirmed After PATC"
      cr: "% Order Placed From Sessions With PATC And Address Confirmed"
    show_dropoff: false
    defaults_version: 1
    hidden_fields: [address_tooltip_sessions.cnt_order_placed]
    show_null_points: true
    interpolation: linear
    listen:
      App Version: address_tooltip_sessions.full_app_version
    row: 66
    col: 12
    width: 12
    height: 7
  - name: Are returning customers less likely to have the intent to contact customer
      service?
    type: text
    title_text: Are returning customers less likely to have the intent to contact
      customer service?
    subtitle_text: ''
    body_text: ''
    row: 53
    col: 0
    width: 24
    height: 2
  - title: mCVR1 by Android Version
    name: mCVR1 by Android Version
    model: flink_v3
    explore: address_tooltip_sessions
    type: looker_column
    fields: [address_tooltip_sessions.mcvr1, address_tooltip_sessions.count, address_tooltip_sessions.full_app_version]
    filters:
      address_tooltip_sessions.count: ">500"
      address_tooltip_sessions.context_device_type: android
    sorts: [address_tooltip_sessions.full_app_version]
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
    y_axes: [{label: "# Sessions", orientation: left, series: [{axisId: address_tooltip_sessions.count,
            id: address_tooltip_sessions.count, name: address_tooltip_sessions}],
        showLabels: true, showValues: true, unpinAxis: false, tickDensity: default,
        tickDensityCustom: 5, type: linear}, {label: '', orientation: right, series: [
          {axisId: address_tooltip_sessions.mcvr1, id: address_tooltip_sessions.mcvr1,
            name: mCVR1}], showLabels: true, showValues: true, unpinAxis: false, tickDensity: default,
        tickDensityCustom: 5, type: linear}]
    x_axis_label: App Version
    series_types:
      address_tooltip_sessions.mcvr1: line
    series_colors:
      address_tooltip_sessions.count: "#d5f6f6"
      address_tooltip_sessions.mcvr1: "#4276BE"
    series_point_styles:
      address_tooltip_sessions.mcvr1: square
    defaults_version: 1
    listen: {}
    row: 57
    col: 0
    width: 12
    height: 7
  - title: mCVR1 by iOS Version
    name: mCVR1 by iOS Version
    model: flink_v3
    explore: address_tooltip_sessions
    type: looker_column
    fields: [address_tooltip_sessions.mcvr1, address_tooltip_sessions.count, address_tooltip_sessions.full_app_version]
    filters:
      address_tooltip_sessions.count: ">500"
      address_tooltip_sessions.context_device_type: ios
    sorts: [address_tooltip_sessions.full_app_version]
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
    y_axes: [{label: "# Sessions", orientation: left, series: [{axisId: address_tooltip_sessions.count,
            id: address_tooltip_sessions.count, name: address_tooltip_sessions}],
        showLabels: true, showValues: true, unpinAxis: false, tickDensity: default,
        tickDensityCustom: 5, type: linear}, {label: '', orientation: right, series: [
          {axisId: address_tooltip_sessions.mcvr1, id: address_tooltip_sessions.mcvr1,
            name: mCVR1}], showLabels: true, showValues: true, unpinAxis: false, tickDensity: default,
        tickDensityCustom: 5, type: linear}]
    x_axis_label: App Version
    series_types:
      address_tooltip_sessions.mcvr1: line
    series_colors:
      address_tooltip_sessions.count: "#d5f6f6"
      address_tooltip_sessions.mcvr1: "#4276BE"
    series_point_styles:
      address_tooltip_sessions.mcvr1: square
    defaults_version: 1
    listen: {}
    row: 57
    col: 12
    width: 12
    height: 7
  - name: ''
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: "#####Objective:\nEstimate the impact of introducing the address tooltip,\
      \ post-rollout, without A/B test\n\n#####Address tooltip details:\nFeature was\
      \ included in Android 2.7.0 and iOS 2.9.0 for the first time.\n[Jira Epic](https://goflink.atlassian.net/browse/POST-223)\n\
      \n##### Method: \nWe compare release version to previous versions on key metrics.\
      \ To reduce effects from other changes, comparison was targeted specifically\
      \ towards the sessions that may be impacted.\n\n#####Summary of Findings:\n\
      \   - Around 20% of sessions include an address tooltip\n   - There was no clear\
      \ increase for new users in selecting an address \n   - There was an increase\
      \ in the rate at which existing users change their address on iOS. There was\
      \ no change on Android.\n   - There was a decrease in late address change rate,\
      \ i.e. for sessions in which there was an address change and at least one product\
      \ added to cart, there were less address changes happening after a product had\
      \ already been added. The late address change rate seems to increase again in\
      \ the next version. This should be monitored for upcoming versions."
    row: 0
    col: 0
    width: 24
    height: 8
  filters:
  - name: App Version
    title: App Version
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: popover
      options: []
    model: flink_v3
    explore: address_tooltip_sessions
    listens_to_filters: []
    field: address_tooltip_sessions.full_app_version
  - name: Session Start Date
    title: Session Start Date
    type: field_filter
    default_value: 30 day ago for 30 day
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: inline
      options: []
    model: flink_v3
    explore: address_tooltip_sessions
    listens_to_filters: []
    field: address_tooltip_sessions.session_start_at_date
