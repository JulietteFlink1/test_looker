- dashboard: addresses_product_dashboard
  title: Addresses Dashboard
  layout: newspaper
  preferred_viewer: dashboards-next
  description: ''
  elements:
  - title: Address Selected
    name: Address Selected
    model: flink_v3
    explore: address_sessions
    type: single_value
    fields: [address_sessions.count, address_sessions.cnt_address_selected,
      address_sessions.cnt_confirmed_and_skipped_area_available, address_sessions.cnt_address_confirmed_area_available]
    filters:
      address_sessions.is_new_user: ''
    limit: 500
    column_limit: 50
    dynamic_fields: [{category: table_calculation, expression: " (${address_sessions.cnt_address_confirmed_area_available}+${address_sessions.cnt_confirmed_and_skipped_area_available})",
        label: confirmed available, value_format: !!null '', value_format_name: !!null '',
        _kind_hint: measure, table_calculation: confirmed_available, _type_hint: number,
        is_disabled: true}, {category: table_calculation, expression: "${confirmed_available}/${address_sessions.cnt_address_selected}",
        label: "% confirmed available", value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: confirmed_available_1, _type_hint: number,
        is_disabled: true}, {category: table_calculation, expression: "(${address_sessions.cnt_address_confirmed_area_available}+${address_sessions.cnt_confirmed_and_skipped_area_available})/${address_sessions.count}",
        label: conversion over all sessions, value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: conversion_over_all_sessions, _type_hint: number},
      {category: table_calculation, expression: 'sum(offset_list(${address_sessions.cnt_address_selected},7,7))/sum(offset_list(${address_sessions.count},7,7))',
        label: conversion last week, value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: conversion_last_week, _type_hint: number,
        is_disabled: true}, {category: table_calculation, expression: "(${conversion_this_week}-${conversion_last_week})*100",
        label: conversion diff, value_format: 0.0 pp, value_format_name: !!null '',
        _kind_hint: measure, table_calculation: conversion_diff, _type_hint: number,
        is_disabled: true}]
    query_timezone: Europe/Berlin
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    custom_color: ''
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
    series_types: {}
    hidden_fields: [address_sessions.count, address_sessions.cnt_address_selected,
      address_sessions.cnt_confirmed_and_skipped_area_available, address_sessions.cnt_address_confirmed_area_available]
    y_axes: []
    note_state: collapsed
    note_display: hover
    note_text: In what % of all sessions did the user select an address? (= sessions
      with address selected in available area / all sessions)
    listen:
      Platform: address_sessions.device_type
      App Version: address_sessions.full_app_version
      Country: address_sessions.country
      Session Start At Date: address_sessions.session_start_at_date
      Is New User (First Session): address_sessions.is_new_user
    row: 7
    col: 1
    width: 4
    height: 2
  - title: Waitlist Intent
    name: Waitlist Intent
    model: flink_v3
    explore: address_sessions
    type: single_value
    fields: [address_sessions.session_start_at_date, address_sessions.cnt_has_waitlist_signup_selected,
      address_sessions.count, address_sessions.cnt_waitlist_area_unavailable,
      address_sessions.cnt_waitlist_and_browse_area_unavailable]
    filters:
      address_sessions.is_new_user: ''
    sorts: [address_sessions.session_start_at_date desc]
    limit: 500
    column_limit: 50
    dynamic_fields: [{category: table_calculation, expression: "${address_sessions.cnt_has_waitlist_signup_selected}-\
          \ (${address_sessions.cnt_waitlist_area_unavailable}+${address_sessions.cnt_waitlist_and_browse_area_unavailable})",
        label: waitlist in available area, value_format: !!null '', value_format_name: !!null '',
        _kind_hint: measure, table_calculation: waitlist_in_available_area, _type_hint: number,
        is_disabled: true}, {category: table_calculation, expression: "${waitlist_in_available_area}/${address_sessions.cnt_has_waitlist_signup_selected}",
        label: "% waitlist available area", value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: waitlist_available_area, _type_hint: number,
        is_disabled: true}, {category: table_calculation, expression: "(${address_sessions.cnt_waitlist_area_unavailable}+${address_sessions.cnt_waitlist_and_browse_area_unavailable})/${address_sessions.count}",
        label: conversion over overall sessions, value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: conversion_over_overall_sessions,
        _type_hint: number}, {category: table_calculation, expression: 'sum(offset_list(${address_sessions.cnt_has_waitlist_signup_selected},7,7))/sum(offset_list(${address_sessions.count},7,7))',
        label: conversion last week, value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: conversion_last_week, _type_hint: number,
        is_disabled: true}, {category: table_calculation, expression: "(${conversion_this_week}-${conversion_last_week})*100",
        label: conversion diff, value_format: 0.0 pp, value_format_name: !!null '',
        _kind_hint: measure, table_calculation: conversion_diff, _type_hint: number,
        is_disabled: true}, {category: measure, expression: !!null '', label: New
          Measure, value_format: !!null '', value_format_name: !!null '', based_on: address_sessions.cnte_waitlist_signup_selected,
        _kind_hint: measure, measure: new_measure, type: sum, _type_hint: number,
        filters: {address_sessions.cnte_waitlist_signup_selected: not null}}]
    query_timezone: Europe/Berlin
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    custom_color: ''
    single_value_title: ''
    comparison_label: From Prior
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    header_text_alignment: left
    header_font_size: 12
    rows_font_size: 12
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
    hidden_fields: [address_sessions.cnt_has_waitlist_signup_selected, address_sessions.count,
      address_sessions.cnt_waitlist_area_unavailable, address_sessions.cnt_waitlist_and_browse_area_unavailable]
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    y_axes: []
    note_state: collapsed
    note_display: hover
    note_text: In what % of all sessions did the user show intent to join the waitlist
      in an unavailable area? (= sessions with waitlist intent in unavailable area
      / all sessions)
    listen:
      Platform: address_sessions.device_type
      App Version: address_sessions.full_app_version
      Country: address_sessions.country
      Session Start At Date: address_sessions.session_start_at_date
      Is New User (First Session): address_sessions.is_new_user
    row: 7
    col: 5
    width: 4
    height: 2
  - title: Actions Inside Delivery Area (% Over All Sessions)
    name: Actions Inside Delivery Area (% Over All Sessions)
    model: flink_v3
    explore: address_sessions
    type: looker_column
    fields: [address_sessions.session_start_at_date, address_sessions.count,
      address_sessions.cnt_location_pin_placed, address_sessions.cnt_address_confirmed_area_available,
      address_sessions.cnt_address_skipped_in_available_area, address_sessions.cnt_available_area,
      address_sessions.cnt_noaction_area_available, address_sessions.cnt_confirmed_and_skipped_area_available]
    fill_fields: [address_sessions.session_start_at_date]
    filters:
      address_sessions.is_new_user: ''
    sorts: [address_sessions.session_start_at_date desc]
    limit: 500
    column_limit: 50
    dynamic_fields: [{category: table_calculation, expression: "${address_sessions.cnt_available_area}/${address_sessions.count}",
        label: "% inside delivery zone", value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: inside_delivery_zone, _type_hint: number},
      {category: table_calculation, expression: "${address_sessions.cnt_address_confirmed_area_available}/${address_sessions.count}",
        label: "% address confirmed", value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: address_confirmed, _type_hint: number},
      {category: table_calculation, expression: "${address_sessions.cnt_confirmed_and_skipped_area_available}/${address_sessions.count}",
        label: "% skipped and confirmed", value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: skipped_and_confirmed, _type_hint: number},
      {category: table_calculation, expression: "${address_sessions.cnt_address_skipped_in_available_area}/${address_sessions.count}",
        label: "% address skipped", value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: address_skipped, _type_hint: number},
      {category: table_calculation, expression: "${address_sessions.cnt_noaction_area_available}/${address_sessions.count}",
        label: "% no action", value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: no_action, _type_hint: number}, {
        category: table_calculation, expression: "${address_confirmed}+${address_skipped}+${no_action}+${skipped_and_confirmed}",
        label: sum actions, value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: sum_actions, _type_hint: number}]
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
    point_style: none
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: true
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    series_colors:
      of_all_first_sessions_with_confirmed_address: "#4276BE"
      address_confirmed: "#4276BE"
      address_skipped: "#C2DD67"
      no_action: "#fccb88"
      skipped_and_confirmed: "#8593f5"
    series_labels:
      no_action: "% Not Selected or Skipped"
      address_skipped: "% Address Skipped (=Browse Selection)"
      address_confirmed: "% Address Selected"
      skipped_and_confirmed: "% Address Skipped and Selected"
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    hidden_fields: [address_sessions.count, address_sessions.cnt_location_pin_placed,
      address_sessions.cnt_address_confirmed_area_available, address_sessions.cnt_address_skipped_in_available_area,
      address_sessions.cnt_available_area, address_sessions.cnt_noaction_area_available,
      inside_delivery_zone, sum_actions, address_sessions.cnt_confirmed_and_skipped_area_available]
    y_axes: []
    note_state: collapsed
    note_display: hover
    note_text: In what % of all sessions did users take key actions while in an available
      area? (= sessions with action X in available area / all sessions)
    listen:
      Platform: address_sessions.device_type
      App Version: address_sessions.full_app_version
      Country: address_sessions.country
      Session Start At Date: address_sessions.session_start_at_date
      Is New User (First Session): address_sessions.is_new_user
    row: 20
    col: 0
    width: 12
    height: 7
  - title: Actions Outside Delivery Area (% Over All Sessions)
    name: Actions Outside Delivery Area (% Over All Sessions)
    model: flink_v3
    explore: address_sessions
    type: looker_column
    fields: [address_sessions.session_start_at_date, address_sessions.count,
      address_sessions.cnt_location_pin_placed, address_sessions.cnt_waitlist_area_unavailable,
      address_sessions.cnt_browse_area_unavailable, address_sessions.cnt_unavailable_area,
      address_sessions.cnt_noaction_area_unavailable, address_sessions.cnt_waitlist_and_browse_area_unavailable]
    fill_fields: [address_sessions.session_start_at_date]
    filters:
      address_sessions.is_new_user: ''
    sorts: [address_sessions.session_start_at_date desc]
    limit: 500
    column_limit: 50
    dynamic_fields: [{category: table_calculation, expression: "${address_sessions.cnt_unavailable_area}/${address_sessions.count}",
        label: "% inside delivery zone", value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: inside_delivery_zone, _type_hint: number},
      {category: table_calculation, expression: "${address_sessions.cnt_waitlist_area_unavailable}/${address_sessions.count}",
        label: "% waitlist intent", value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: waitlist_intent, _type_hint: number},
      {category: table_calculation, expression: "${address_sessions.cnt_waitlist_and_browse_area_unavailable}/${address_sessions.count}",
        label: "% waitlist and browse", value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: waitlist_and_browse, _type_hint: number},
      {category: table_calculation, expression: "${address_sessions.cnt_browse_area_unavailable}/${address_sessions.count}",
        label: "% selection browse", value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: selection_browse, _type_hint: number},
      {category: table_calculation, expression: "${address_sessions.cnt_noaction_area_unavailable}/${address_sessions.count}",
        label: "% no action", value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: no_action, _type_hint: number}, {
        category: table_calculation, expression: "${waitlist_intent}+${selection_browse}+${no_action}+${waitlist_and_browse}",
        label: sum actions, value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: sum_actions, _type_hint: number}]
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
    point_style: none
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: true
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    series_colors:
      of_all_first_sessions_with_confirmed_address: "#4276BE"
      address_confirmed: "#4276BE"
      address_skipped: "#C2DD67"
      no_action: "#fccb88"
      waitlist_intent: "#d36ade"
      selection_browse: "#C2DD67"
      waitlist_and_browse: "#efa6e9"
    series_labels:
      no_action: "% Not Waitlist or Browse"
      waitlist_and_browse: "% Waitlist and Browse"
      selection_browse: "% Browse Selection"
      waitlist_intent: "% Waitlist Intent"
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    hidden_fields: [address_sessions.count, address_sessions.cnt_location_pin_placed,
      inside_delivery_zone, sum_actions, address_sessions.cnt_unavailable_area,
      address_sessions.cnt_waitlist_area_unavailable, address_sessions.cnt_browse_area_unavailable,
      address_sessions.cnt_noaction_area_unavailable, address_sessions.cnt_waitlist_and_browse_area_unavailable]
    y_axes: []
    note_state: collapsed
    note_display: hover
    note_text: In what % of all sessions did users take key actions while in an unavailable
      area? (= sessions with action X in unavailable area / all sessions)
    listen:
      Platform: address_sessions.device_type
      App Version: address_sessions.full_app_version
      Country: address_sessions.country
      Session Start At Date: address_sessions.session_start_at_date
      Is New User (First Session): address_sessions.is_new_user
    row: 20
    col: 12
    width: 12
    height: 7
  - title: Outside Of Delivery Area
    name: Outside Of Delivery Area
    model: flink_v3
    explore: address_sessions
    type: single_value
    fields: [address_sessions.cnt_location_pin_placed, address_sessions.cnt_unavailable_area,
      address_sessions.count]
    filters:
      address_sessions.is_new_user: ''
    limit: 500
    column_limit: 50
    dynamic_fields: [{category: table_calculation, expression: "${address_sessions.cnt_unavailable_area}/${address_sessions.count}",
        label: "% Sessions with unavailable areas over overall sessions", value_format: !!null '',
        value_format_name: percent_1, _kind_hint: measure, table_calculation: sessions_with_unavailable_areas_over_overall_sessions,
        _type_hint: number}, {category: table_calculation, expression: 'sum(offset_list(${address_sessions.cnt_unavailable_area},0,7))/sum(offset_list(${address_sessions.cnt_location_pin_placed},0,7))',
        label: "% sessions with unavailable area last 7 days", value_format: !!null '',
        value_format_name: percent_1, _kind_hint: measure, table_calculation: sessions_with_unavailable_area_last_7_days,
        _type_hint: number, is_disabled: true}, {category: table_calculation, expression: 'sum(offset_list(${address_sessions.cnt_unavailable_area},7,7))/sum(offset_list(${address_sessions.cnt_location_pin_placed},7,7))',
        label: "% sessions with unavailable area prior 7 days", value_format: !!null '',
        value_format_name: percent_1, _kind_hint: measure, table_calculation: sessions_with_unavailable_area_prior_7_days,
        _type_hint: number, is_disabled: true}, {category: table_calculation, expression: "(${sessions_with_unavailable_area_last_7_days}-${sessions_with_unavailable_area_prior_7_days})*100",
        label: unavailable area diff, value_format: 0.0 pp, value_format_name: !!null '',
        _kind_hint: measure, table_calculation: unavailable_area_diff, _type_hint: number,
        is_disabled: true}]
    query_timezone: Europe/Berlin
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: change
    comparison_reverse_colors: true
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    custom_color: ''
    single_value_title: ''
    comparison_label: From Prior
    hidden_fields: [address_sessions.cnt_unavailable_area, address_sessions.cnt_location_pin_placed,
      address_sessions.count]
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
    series_types: {}
    y_axes: []
    note_state: collapsed
    note_display: hover
    note_text: In what % of all sessions did the user go into the address selection
      flow (at least 1 location pin placed) and end up in an unavailable area? (=
      sessions with unavailable area / all sessions)
    listen:
      Platform: address_sessions.device_type
      App Version: address_sessions.full_app_version
      Country: address_sessions.country
      Session Start At Date: address_sessions.session_start_at_date
      Is New User (First Session): address_sessions.is_new_user
    row: 9
    col: 1
    width: 8
    height: 2
  - title: Outside Of Delivery Area (% Over All Sessions)
    name: Outside Of Delivery Area (% Over All Sessions)
    model: flink_v3
    explore: address_sessions
    type: looker_column
    fields: [address_sessions.cnt_unavailable_area, address_sessions.session_start_at_date,
      address_sessions.device_type, address_sessions.cnt_location_pin_placed,
      address_sessions.count]
    pivots: [address_sessions.device_type]
    fill_fields: [address_sessions.session_start_at_date]
    filters:
      address_sessions.is_new_user: ''
    sorts: [address_sessions.session_start_at_date desc, address_sessions.device_type]
    limit: 500
    column_limit: 50
    row_total: right
    dynamic_fields: [{category: table_calculation, expression: "${address_sessions.cnt_unavailable_area}/${address_sessions.count}",
        label: "% sessions unavailable area vs. location sessions", value_format: !!null '',
        value_format_name: percent_1, _kind_hint: measure, table_calculation: sessions_unavailable_area_vs_address_sessions,
        _type_hint: number}, {category: table_calculation, expression: 'sum(offset_list(${address_sessions.cnt_unavailable_area},0,7))/sum(offset_list(${address_sessions.cnt_location_pin_placed},0,7))',
        label: "% sessions with unavailable area last 7 days", value_format: !!null '',
        value_format_name: percent_1, _kind_hint: measure, table_calculation: sessions_with_unavailable_area_last_7_days,
        _type_hint: number, is_disabled: true}, {category: table_calculation, expression: 'sum(offset_list(${address_sessions.cnt_unavailable_area},7,7))/sum(offset_list(${address_sessions.cnt_location_pin_placed},7,7))',
        label: "% sessions with unavailable area prior 7 days", value_format: !!null '',
        value_format_name: percent_1, _kind_hint: measure, table_calculation: sessions_with_unavailable_area_prior_7_days,
        _type_hint: number, is_disabled: true}, {category: table_calculation, expression: "${address_sessions.cnt_unavailable_area:row_total}/${address_sessions.count:row_total}",
        label: "% unavailable area", value_format: !!null '', value_format_name: percent_1,
        _kind_hint: supermeasure, table_calculation: unavailable_area, _type_hint: number}]
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
    y_axes: [{label: '', orientation: left, series: [{axisId: android - sessions_unavailable_area_vs_address_sessions,
            id: android - sessions_unavailable_area_vs_address_sessions, name: android},
          {axisId: ios - sessions_unavailable_area_vs_address_sessions, id: ios -
              sessions_unavailable_area_vs_address_sessions, name: ios}], showLabels: false,
        showValues: true, unpinAxis: false, tickDensity: default, type: linear}]
    series_types:
      sessions_with_unavailable_areas_over_overall_sessions: line
      android - sessions_with_unavailable_areas_over_overall_sessions: line
      ios - sessions_with_unavailable_areas_over_overall_sessions: line
      android - sessions_unavailable_area_vs_address_sessions: line
      ios - sessions_unavailable_area_vs_address_sessions: line
      unavailable_area: line
    series_colors:
      address_sessions.count: "#9eeaea"
      sessions_with_unavailable_areas_over_overall_sessions: "#B1399E"
      android - address_sessions.count: "#75E2E2"
      ios - address_sessions.count: "#9eeaea"
      ios - sessions_with_unavailable_areas_over_overall_sessions: "#e5508e"
      android - address_sessions.cnt_location_pin_placed: "#75E2E2"
      ios - address_sessions.cnt_location_pin_placed: "#d5f6f6"
      ios - sessions_unavailable_area_vs_address_sessions: "#d7b9f9"
      android - sessions_unavailable_area_vs_address_sessions: "#d7b9f9"
      unavailable_area: "#B1399E"
    series_labels:
      address_sessions.count: Sessions
      sessions_with_unavailable_areas_over_overall_sessions: "% Sessions with unavailable\
        \ area"
      android - address_sessions.count: Sessions (Android)
      ios - address_sessions.count: Sessions (iOS)
      android - sessions_with_unavailable_areas_over_overall_sessions: "% Sessions\
        \ With Unavailable Area"
      ios - sessions_with_unavailable_areas_over_overall_sessions: "% Sessions With\
        \ Unavailable Area"
      android - sessions_unavailable_area_vs_address_sessions: "% Unavailable Area\
        \ (Android)"
      ios - sessions_unavailable_area_vs_address_sessions: "% Unavailable Area (iOS)"
      unavailable_area: "% Unavailable Area (All)"
    series_point_styles:
      android - sessions_unavailable_area_vs_address_sessions: square
      ios - sessions_unavailable_area_vs_address_sessions: diamond
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    custom_color: "#c76b4e"
    single_value_title: Location Sessions With Unavailable Area (Last 7 Days)
    hidden_fields: [address_sessions.cnt_unavailable_area, address_sessions.cnt_location_pin_placed,
      address_sessions.count]
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    note_state: collapsed
    note_display: hover
    note_text: In what % of all sessions did users go into the address selection flow
      (at least 1 location pin placed) and end up in an unavailable area? (= sessions
      with unavailable area / all sessions) Per platform and in total
    listen:
      Platform: address_sessions.device_type
      App Version: address_sessions.full_app_version
      Country: address_sessions.country
      Session Start At Date: address_sessions.session_start_at_date
      Is New User (First Session): address_sessions.is_new_user
    row: 29
    col: 0
    width: 12
    height: 7
  - title: Address Unidentifiable (% Over Address Sessions)
    name: Address Unidentifiable (% Over Address Sessions)
    model: flink_v3
    explore: address_sessions
    type: looker_line
    fields: [address_sessions.cnt_location_pin_placed, address_sessions.cnt_address_resolution_failed_inside_area,
      address_sessions.session_start_at_date, address_sessions.device_type,
      address_sessions.cnt_address_resolution_failed_outside_area]
    pivots: [address_sessions.device_type]
    fill_fields: [address_sessions.session_start_at_date]
    filters:
      address_sessions.is_new_user: ''
    sorts: [address_sessions.session_start_at_date desc, address_sessions.device_type]
    limit: 500
    column_limit: 50
    row_total: right
    dynamic_fields: [{category: table_calculation, expression: "${address_sessions.cnt_address_resolution_failed_inside_area}/${address_sessions.cnt_location_pin_placed}",
        label: "% unidentified inside", value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: unidentified_inside, _type_hint: number},
      {category: table_calculation, expression: "${address_sessions.cnt_address_resolution_failed_outside_area}/${address_sessions.cnt_location_pin_placed}",
        label: "% unidentified outside", value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: unidentified_outside, _type_hint: number},
      {category: table_calculation, expression: "${address_sessions.cnt_address_resolution_failed_inside_area:row_total}/${address_sessions.cnt_location_pin_placed:row_total}",
        label: "% unidentified inside", value_format: !!null '', value_format_name: percent_1,
        _kind_hint: supermeasure, table_calculation: unidentified_inside_1, _type_hint: number},
      {category: table_calculation, expression: "${address_sessions.cnt_address_resolution_failed_outside_area:row_total}/${address_sessions.cnt_location_pin_placed:row_total}",
        label: "% unidentified outside", value_format: !!null '', value_format_name: percent_1,
        _kind_hint: supermeasure, table_calculation: unidentified_outside_1, _type_hint: number}]
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
    show_null_points: true
    interpolation: linear
    y_axes: [{label: !!null '', orientation: left, series: [{axisId: android - unidentified_inside,
            id: android - unidentified_inside, name: Inside Delivery Area (Android)},
          {axisId: android - unidentified_outside, id: android - unidentified_outside,
            name: Outside Delivery Area (Android)}, {axisId: ios - unidentified_inside,
            id: ios - unidentified_inside, name: Inside Delivery Area (iOS)}, {axisId: ios
              - unidentified_outside, id: ios - unidentified_outside, name: Outside
              Delivery Area (iOS)}, {axisId: unidentified_inside_1, id: unidentified_inside_1,
            name: "% unidentified inside"}, {axisId: unidentified_outside_1, id: unidentified_outside_1,
            name: "% unidentified outside"}], showLabels: true, showValues: true,
        unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear}]
    series_types: {}
    series_colors:
      android - unidentified_addresses: "#f98662"
      ios - unidentified_addresses: "#fccb88"
      android - unidentified_inside: "#4691d6"
      android - unidentified_outside: "#B1399E"
      ios - unidentified_inside: "#4691d6"
      ios - unidentified_outside: "#B1399E"
      unidentified_inside_1: "#B1399E"
      unidentified_outside_1: "#d482cc"
    series_labels:
      android - unidentified_inside: Inside Delivery Area (Android)
      android - unidentified_outside: Outside Delivery Area (Android)
      ios - unidentified_inside: Inside Delivery Area (iOS)
      ios - unidentified_outside: Outside Delivery Area (iOS)
    series_point_styles:
      android - unidentified_addresses: square
      android - unidentified_outside: square
      android - unidentified_inside: square
      ios - unidentified_outside: diamond
      ios - unidentified_inside: diamond
    defaults_version: 1
    hidden_fields: [address_sessions.cnt_location_pin_placed, address_sessions.cnt_address_resolution_failed_inside_area,
      address_sessions.cnt_address_resolution_failed_outside_area, unidentified_inside_1,
      unidentified_outside_1]
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    note_state: collapsed
    note_display: hover
    note_text: In what % of sessions where users entered the address selection flow
      (at least 1 location pin placed) did they check a location of which we couldn't
      identify the address? (= sessions with unidentifiable address / sessions with
      location pin placed)
    listen:
      Platform: address_sessions.device_type
      App Version: address_sessions.full_app_version
      Country: address_sessions.country
      Session Start At Date: address_sessions.session_start_at_date
      Is New User (First Session): address_sessions.is_new_user
    row: 29
    col: 12
    width: 12
    height: 7
  - title: Address Tap At Checkout (% Over Checkout Sessions)
    name: Address Tap At Checkout (% Over Checkout Sessions)
    model: flink_v3
    explore: checkout_sessions
    type: looker_line
    fields: [checkout_sessions.session_start_at_date, checkout_sessions.cnt_checkout_started,
      checkout_sessions.cnt_address_change_at_checkout, checkout_sessions.context_device_type]
    pivots: [checkout_sessions.context_device_type]
    fill_fields: [checkout_sessions.session_start_at_date]
    filters:
      checkout_sessions.is_new_user: ''
    sorts: [checkout_sessions.session_start_at_date desc, checkout_sessions.context_device_type]
    limit: 500
    column_limit: 50
    row_total: right
    dynamic_fields: [{category: table_calculation, expression: "${checkout_sessions.cnt_address_change_at_checkout}/${checkout_sessions.cnt_checkout_started}",
        label: "% address change at checkout", value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: address_change_at_checkout, _type_hint: number},
      {category: table_calculation, expression: "${checkout_sessions.cnt_address_change_at_checkout:row_total}/${checkout_sessions.cnt_checkout_started:row_total}",
        label: "% tapped address at checkout", value_format: !!null '', value_format_name: percent_1,
        _kind_hint: supermeasure, table_calculation: tapped_address_at_checkout, _type_hint: number}]
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
    point_style: circle
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    y_axes: [{label: "% Address Tap At Checkout", orientation: left, series: [{axisId: address_change_at_checkout,
            id: android - address_change_at_checkout, name: Android}, {axisId: address_change_at_checkout,
            id: ios - address_change_at_checkout, name: iOS}], showLabels: false,
        showValues: true, unpinAxis: false, tickDensity: default, tickDensityCustom: 5,
        type: linear}]
    series_colors:
      android - address_change_at_checkout: "#f7cadd"
      ios - address_change_at_checkout: "#f7cadd"
      tapped_address_at_checkout: "#B1399E"
    series_labels:
      android - address_change_at_checkout: Android
      ios - address_change_at_checkout: iOS
      tapped_address_at_checkout: Overall
    series_point_styles:
      android - address_change_at_checkout: square
      ios - address_change_at_checkout: diamond
    defaults_version: 1
    hidden_fields: [checkout_sessions.cnt_address_change_at_checkout, checkout_sessions.cnt_checkout_started]
    note_state: collapsed
    note_display: hover
    note_text: In what % of sessions where users started checkout, did they tap on
      the address shown on the checkout page? Presumably these users tried to change
      the address at checkout. (= sessions with address tapped at checkout / sessions
      with checkout started)
    listen:
      Platform: checkout_sessions.context_device_type
      App Version: checkout_sessions.full_app_version
      Country: checkout_sessions.country
      Session Start At Date: checkout_sessions.session_start_at_date
      Is New User (First Session): checkout_sessions.is_new_user
    row: 38
    col: 0
    width: 12
    height: 8
  - title: "% Orders With Delivery Notes"
    name: "% Orders With Delivery Notes"
    model: flink_v3
    explore: order_comments
    type: looker_line
    fields: [order_comments.created_date, order_comments.count, order_comments.cnt_unique_order_locations,
      order_comments.cnt_has_customer_notes]
    fill_fields: [order_comments.created_date]
    filters: {}
    sorts: [order_comments.created_date desc]
    limit: 500
    dynamic_fields: [{category: table_calculation, expression: "${order_comments.cnt_has_customer_notes}/${order_comments.count}",
        label: "%orders with delivery notes", value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: orders_with_delivery_notes, _type_hint: number}]
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
    point_style: circle
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    y_axes: [{label: '', orientation: left, series: [{axisId: order_comments.count,
            id: order_comments.count, name: Orders}], showLabels: true, showValues: true,
        unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear},
      {label: '', orientation: right, series: [{axisId: orders_with_delivery_notes,
            id: orders_with_delivery_notes, name: "% Orders with Delivery Notes"}],
        showLabels: true, showValues: true, unpinAxis: false, tickDensity: default,
        type: linear}]
    series_types:
      order_comments.count: area
    series_colors:
      order_comments.count: "#FFD95F"
      orders_with_delivery_notes: "#4276BE"
    series_labels:
      order_comments.count: Orders
      orders_with_delivery_notes_1: "% Orders With Delivery Notes"
      orders_with_delivery_notes: "% With Delivery Notes"
    hidden_fields: [order_comments.cnt_customer_notes_null, order_comments.cnt_has_customer_notes,
      order_comments.cnt_unique_order_locations]
    defaults_version: 1
    note_state: collapsed
    note_display: hover
    note_text: What % of orders had delivery notes in the address section? (= orders
      with notes / all orders)
    listen:
      Session Start At Date: order_comments.created_date
    row: 46
    col: 12
    width: 12
    height: 7
  - title: 'Sessions With Cart Lost (% Over All Sessions) '
    name: 'Sessions With Cart Lost (% Over All Sessions) '
    model: flink_v3
    explore: checkout_sessions
    type: looker_line
    fields: [checkout_sessions.session_start_at_date, checkout_sessions.count, checkout_sessions.cnt_checkout_started,
      checkout_sessions.cnt_hub_update_message]
    fill_fields: [checkout_sessions.session_start_at_date]
    filters:
      checkout_sessions.is_new_user: ''
    sorts: [checkout_sessions.session_start_at_date desc]
    limit: 500
    column_limit: 50
    dynamic_fields: [{category: table_calculation, expression: "${checkout_sessions.cnt_address_change_at_checkout}/${checkout_sessions.cnt_checkout_started}",
        label: "% address change at checkout", value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: address_change_at_checkout, _type_hint: number,
        is_disabled: true}, {category: table_calculation, expression: "${checkout_sessions.cnt_hub_update_message}/${checkout_sessions.count}",
        label: "% hub updated", value_format: !!null '', value_format_name: percent_2,
        _kind_hint: measure, table_calculation: hub_updated, _type_hint: number}]
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
    point_style: circle
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    y_axes: [{label: '', orientation: left, series: [{axisId: hub_updated, id: hub_updated,
            name: "% Lost Cart Due To Hub Update (Android)"}], showLabels: true, showValues: true,
        unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear}]
    hide_legend: false
    series_colors:
      android - address_change_at_checkout: "#72D16D"
      ios - address_change_at_checkout: "#C2DD67"
      hub_updated: "#B1399E"
    series_labels:
      hub_updated: "% Lost Cart Due To Hub Update (Android)"
    series_point_styles:
      android - address_change_at_checkout: square
    defaults_version: 1
    hidden_fields: [checkout_sessions.cnt_checkout_started, checkout_sessions.cnt_hub_update_message,
      checkout_sessions.count]
    note_state: collapsed
    note_display: hover
    note_text: In what % of all sessions did users lose their cart because they changed
      location after having something in the cart? (= sessions with cart lost due
      to hub update / all sessions)
    listen:
      Platform: checkout_sessions.context_device_type
      App Version: checkout_sessions.full_app_version
      Country: checkout_sessions.country
      Session Start At Date: checkout_sessions.session_start_at_date
      Is New User (First Session): checkout_sessions.is_new_user
    row: 48
    col: 0
    width: 12
    height: 5
  - title: "% Unique Locations Ordered To With Delivery Notes"
    name: "% Unique Locations Ordered To With Delivery Notes"
    model: flink_v3
    explore: order_comments
    type: looker_column
    fields: [order_comments.created_date, order_comments.count, order_comments.cnt_unique_order_locations,
      order_comments.cnt_unique_location_has_customer_notes, order_comments.cnt_unique_location_no_customer_notes]
    fill_fields: [order_comments.created_date]
    filters: {}
    sorts: [order_comments.created_date desc]
    limit: 500
    dynamic_fields: [{category: table_calculation, expression: "(${order_comments.cnt_unique_location_has_customer_notes}+${order_comments.cnt_unique_location_no_customer_notes})-${order_comments.cnt_unique_order_locations}",
        label: "# locations sometimes with notes and sometimes not", value_format: !!null '',
        value_format_name: !!null '', _kind_hint: measure, table_calculation: locations_sometimes_with_notes_and_sometimes_not,
        _type_hint: number}, {category: table_calculation, expression: "${order_comments.cnt_unique_location_has_customer_notes}/${order_comments.cnt_unique_order_locations}",
        label: "% unique locations always has note", value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: unique_locations_always_has_note,
        _type_hint: number}, {category: table_calculation, expression: "${order_comments.cnt_unique_location_no_customer_notes}/${order_comments.cnt_unique_order_locations}",
        label: "% unique locations never has note", value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: unique_locations_never_has_note, _type_hint: number},
      {category: table_calculation, expression: "${locations_sometimes_with_notes_and_sometimes_not}/${order_comments.cnt_unique_order_locations}",
        label: "% unique locations mixed notes", value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: unique_locations_mixed_notes, _type_hint: number}]
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
    stacking: normal
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: true
    show_silhouette: false
    totals_color: "#808080"
    y_axes: [{label: '', orientation: left, series: [{axisId: unique_locations_always_has_note,
            id: unique_locations_always_has_note, name: Always Has Delivery Note},
          {axisId: unique_locations_mixed_notes, id: unique_locations_mixed_notes,
            name: Sometimes Has Delivery Note}], showLabels: true, showValues: true,
        maxValue: !!null '', unpinAxis: false, tickDensity: default, tickDensityCustom: 5,
        type: linear}]
    series_types: {}
    series_colors:
      order_comments.count: "#FFD95F"
      order_comments.cnt_unique_location_has_customer_notes: "#e5508e"
      order_comments.cnt_unique_location_no_customer_notes: "#ec84af"
      locations_sometimes_with_notes_and_sometimes_not: "#f7cadd"
      unique_locations_always_has_note: "#4276BE"
      unique_locations_mixed_notes: "#c6d5eb"
    series_labels:
      order_comments.count: Orders
      orders_with_delivery_notes_1: "% Orders With Delivery Notes"
      unique_locations_mixed_notes: Sometimes Has Delivery Note
      unique_locations_always_has_note: Always Has Delivery Note
    show_null_points: true
    interpolation: linear
    hidden_fields: [order_comments.cnt_customer_notes_null, order_comments.cnt_unique_order_locations,
      order_comments.count, order_comments.cnt_unique_location_has_customer_notes,
      order_comments.cnt_unique_location_no_customer_notes, locations_sometimes_with_notes_and_sometimes_not,
      unique_locations_never_has_note]
    defaults_version: 1
    note_state: collapsed
    note_display: hover
    note_text: What % of unique locations that were ordered to, had delivery notes?
      (= unique order locations with delivery notes / all unique order locations)
    listen:
      Session Start At Date: order_comments.created_date
    row: 53
    col: 12
    width: 12
    height: 7
  - name: ''
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: "| Term       | | Definition           | \n|-------------|:-------------:||:-------------|\n\
      | mCVR1  |  | % sessions in which there was a delivery address available (either\
      \ in the current session or a previous one), compared to all sessions | \n|\
      \ Unavailable area |  | The user entered the address selection flow and the\
      \ last location the user checked was in an area we don't deliver to (can't be\
      \ selected as address) | \n| Unidentifiable address |  | The location pin was\
      \ on coordinates that could not be resolved into an address (this can happen\
      \ when the user chooses to use their current location or if they move the location\
      \ pin manually) | \n| New user  |  |  User that hasn't been on the app before\
      \ (= first session) according to their Segment ID | \n\n**See [here](https://docs.google.com/spreadsheets/d/1iN3CkrM8cYLnp6UEce-34c_ziF9p_sxhfEW3oDyfD_k/edit#gid=0)\
      \ for Data Glossary with all KPI definitions.**"
    row: 0
    col: 6
    width: 18
    height: 4
  - name: " (2)"
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: "<img src=\"https://i.imgur.com/KcWQwrB.png\" width=\"50%\"> \n\nData\
      \ Refreshment Rate: 1 hour"
    row: 0
    col: 0
    width: 6
    height: 4
  - name: Address Selection
    type: text
    title_text: Address Selection
    subtitle_text: ''
    body_text: |-
      <p align="center">
      (NOTE : Android sends more tracking events for unidentified address and outside of delivery area than is truly the case [<a href="https://goflink.atlassian.net/browse/POST-300">bug ticket</a>]. For area availability iOS provides the more reliable numbers)
      </p>
    row: 11
    col: 0
    width: 24
    height: 3
  - name: Address Management
    type: text
    title_text: Address Management
    subtitle_text: ''
    body_text: ''
    row: 36
    col: 0
    width: 24
    height: 2
  - name: "----- Currently only available for android: -----"
    type: text
    title_text: "----- Currently only available for android: -----"
    subtitle_text: ''
    body_text: ''
    row: 46
    col: 0
    width: 12
    height: 2
  - title: Inside Delivery Area Funnel By New/Returning User
    name: Inside Delivery Area Funnel By New/Returning User
    model: flink_v3
    explore: address_sessions
    type: looker_column
    fields: [address_sessions.count, address_sessions.cnt_location_pin_placed,
      address_sessions.cnt_available_area, address_sessions.cnt_address_confirmed_area_available,
      address_sessions.cnt_confirmed_and_skipped_area_available, address_sessions.is_new_user]
    fill_fields: [address_sessions.is_new_user]
    filters: {}
    sorts: [address_sessions.is_new_user desc]
    limit: 500
    dynamic_fields: [{category: table_calculation, expression: "${address_sessions.cnt_address_confirmed_area_available}+${address_sessions.cnt_confirmed_and_skipped_area_available}",
        label: address confirmed total, value_format: !!null '', value_format_name: !!null '',
        _kind_hint: measure, table_calculation: address_confirmed_total, _type_hint: number}]
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
      collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7
      palette_id: fb7bb53e-b77b-4ab6-8274-9d420d3d73f3
      options:
        steps: 5
    x_axis_label: Is New User (First Session)
    series_colors:
      address_sessions.count: "#75E2E2"
      address_sessions.cnt_location_pin_placed: "#3EB0D5"
      address_sessions.cnt_available_area: "#4691d6"
      address_confirmed_total: "#4276BE"
    series_labels:
      address_sessions.count: Sessions Started
      address_sessions.cnt_location_pin_placed: Address Flow Started
      address_sessions.cnt_available_area: Address Inside Delivery Area
      address_confirmed_total: Address Selected
    show_dropoff: true
    hidden_fields: [address_sessions.cnt_address_confirmed_area_available,
      address_sessions.cnt_confirmed_and_skipped_area_available]
    defaults_version: 1
    y_axes: []
    note_state: collapsed
    note_display: hover
    note_text: How many user sessions progressed through the address selection happy
      path for sessions inside the delivery area? (percentages shown are comparing
      the previous step to the next one. For overall address selection conversion,
      see "address selected" tile above)
    listen:
      Platform: address_sessions.device_type
      App Version: address_sessions.full_app_version
      Country: address_sessions.country
      Session Start At Date: address_sessions.session_start_at_date
      Is New User (First Session): address_sessions.is_new_user
    row: 14
    col: 0
    width: 12
    height: 6
  - title: Outside Delivery Area Funnel By New/Returning User
    name: Outside Delivery Area Funnel By New/Returning User
    model: flink_v3
    explore: address_sessions
    type: looker_column
    fields: [address_sessions.is_new_user, address_sessions.count,
      address_sessions.cnt_location_pin_placed, address_sessions.cnt_unavailable_area,
      address_sessions.cnt_waitlist_and_browse_area_unavailable, address_sessions.cnt_waitlist_area_unavailable]
    fill_fields: [address_sessions.is_new_user]
    filters: {}
    sorts: [address_sessions.is_new_user desc]
    limit: 500
    dynamic_fields: [{category: table_calculation, expression: "${address_sessions.cnt_waitlist_area_unavailable}+${address_sessions.cnt_waitlist_and_browse_area_unavailable}",
        label: waitlist intent total, value_format: !!null '', value_format_name: !!null '',
        _kind_hint: measure, table_calculation: waitlist_intent_total, _type_hint: number}]
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
      collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7
      palette_id: fb7bb53e-b77b-4ab6-8274-9d420d3d73f3
      options:
        steps: 5
    x_axis_label: Is New User (First Session)
    series_colors:
      address_sessions.count: "#75E2E2"
      address_sessions.cnt_location_pin_placed: "#3EB0D5"
      address_sessions.cnt_available_area: "#4691d6"
      address_confirmed_total: "#4276BE"
      address_sessions.cnt_unavailable_area: "#B1399E"
      waitlist_intent_total: "#d36ade"
    series_labels:
      address_sessions.count: Sessions Started
      address_sessions.cnt_location_pin_placed: Address Flow Started
      address_sessions.cnt_available_area: Sessions With Location In Available
        Area
      address_confirmed_total: Sessions With Address Selected
      address_sessions.cnt_unavailable_area: Address Outside Delivery Area
      waitlist_intent_total: Waitlist Signup Intent
    show_dropoff: true
    hidden_fields: [address_sessions.cnt_waitlist_and_browse_area_unavailable,
      address_sessions.cnt_waitlist_area_unavailable]
    defaults_version: 1
    y_axes: []
    note_state: collapsed
    note_display: hover
    note_text: How many user sessions progressed through the address selection happy
      path for sessions outside the delivery area? (percentages shown are comparing
      the previous step to the next one. For overall waitlist conversion, see "waitlist
      intent" tile above)
    listen:
      Platform: address_sessions.device_type
      App Version: address_sessions.full_app_version
      Country: address_sessions.country
      Session Start At Date: address_sessions.session_start_at_date
      Is New User (First Session): address_sessions.is_new_user
    row: 14
    col: 12
    width: 12
    height: 6
  - name: Delivery Coverage
    type: text
    title_text: Delivery Coverage
    subtitle_text: ''
    body_text: |-
      <p align="center">
      (NOTE : Android sends more tracking events for unidentified address and outside of delivery area than is truly the case [<a href="https://goflink.atlassian.net/browse/POST-300">bug ticket</a>]. For area availability iOS provides the more reliable numbers)
      </p>
    row: 27
    col: 0
    width: 24
    height: 2
  - title: Leave Checkout To Change Address (% Over Checkout Sessions)
    name: Leave Checkout To Change Address (% Over Checkout Sessions)
    model: flink_v3
    explore: checkout_sessions
    type: looker_line
    fields: [checkout_sessions.session_start_at_date, checkout_sessions.cnt_checkout_started,
      checkout_sessions.context_device_type, checkout_sessions.cnt_address_confirm_after_checkout]
    pivots: [checkout_sessions.context_device_type]
    fill_fields: [checkout_sessions.session_start_at_date]
    filters:
      checkout_sessions.is_new_user: ''
    sorts: [checkout_sessions.session_start_at_date desc, checkout_sessions.context_device_type]
    limit: 500
    column_limit: 50
    row_total: right
    dynamic_fields: [{category: table_calculation, expression: "${checkout_sessions.cnt_address_confirm_after_checkout}/${checkout_sessions.cnt_checkout_started}",
        label: "% address change at checkout", value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: address_change_at_checkout, _type_hint: number},
      {category: table_calculation, expression: "${checkout_sessions.cnt_address_confirm_after_checkout:row_total}/${checkout_sessions.cnt_checkout_started:row_total}",
        label: "% tapped address at checkout", value_format: !!null '', value_format_name: percent_1,
        _kind_hint: supermeasure, table_calculation: tapped_address_at_checkout, _type_hint: number}]
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
    point_style: circle
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    y_axes: [{label: "% Address Tap At Checkout", orientation: left, series: [{axisId: address_change_at_checkout,
            id: android - address_change_at_checkout, name: Android}, {axisId: address_change_at_checkout,
            id: ios - address_change_at_checkout, name: iOS}], showLabels: false,
        showValues: true, unpinAxis: false, tickDensity: default, tickDensityCustom: 5,
        type: linear}]
    series_colors:
      android - address_change_at_checkout: "#f7cadd"
      ios - address_change_at_checkout: "#f7cadd"
      tapped_address_at_checkout: "#B1399E"
    series_labels:
      android - address_change_at_checkout: Android
      ios - address_change_at_checkout: iOS
      tapped_address_at_checkout: Overall
    series_point_styles:
      android - address_change_at_checkout: square
      ios - address_change_at_checkout: diamond
    defaults_version: 1
    hidden_fields: [checkout_sessions.cnt_checkout_started, checkout_sessions.cnt_address_confirm_after_checkout]
    note_state: collapsed
    note_display: hover
    note_text: In what % of sessions where users started checkout, did they leave
      checkout and subsequently changed their address without having placed an order
      first? (= sessions with address selected after checkout started without order
      in-between / sessions with checkout started)
    listen:
      Platform: checkout_sessions.context_device_type
      App Version: checkout_sessions.full_app_version
      Country: checkout_sessions.country
      Session Start At Date: checkout_sessions.session_start_at_date
      Is New User (First Session): checkout_sessions.is_new_user
    row: 38
    col: 12
    width: 12
    height: 8
  - title: New Tile
    name: New Tile
    model: flink_v3
    explore: app_sessions
    type: single_value
    fields: [app_sessions.mcvr1]
    filters:
      app_sessions.device_type: ''
      app_sessions.session_start_at_date: 30 days ago for 30 days
      app_sessions.country: ''
      app_sessions.hub_code: ''
      app_sessions.session_start_at_day_of_week: Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday
    limit: 500
    column_limit: 50
    dynamic_fields: [{category: table_calculation, expression: 'sum(offset_list(${app_sessions.cnt_session_with_address},0,7))/sum(offset_list(${app_sessions.count},0,7))',
        label: overall conversion this week, value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: overall_conversion_this_week, _type_hint: number,
        is_disabled: true}, {category: table_calculation, expression: 'sum(offset_list(${app_sessions.cnt_session_with_address},7,7))/sum(offset_list(${app_sessions.count},7,7))',
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
    custom_color: "#000000"
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
    note_state: collapsed
    note_display: hover
    note_text: What was mCVR1 over the selected period? (= sessions with has address
      / all sessions)
    listen:
      Is New User (First Session): app_sessions.is_new_user
    row: 4
    col: 1
    width: 8
    height: 3
  - title: 'mCVR1: Sessions With A Selected Address'
    name: 'mCVR1: Sessions With A Selected Address'
    model: flink_v3
    explore: app_sessions
    type: looker_column
    fields: [app_sessions.count, app_sessions.device_type, app_sessions.session_start_date_granularity,
      app_sessions.mcvr1]
    pivots: [app_sessions.device_type]
    filters:
      app_sessions.session_start_at_date: 30 days ago for 30 days
      app_sessions.country: ''
      app_sessions.device_type: ''
      app_sessions.timeframe_picker: Day
      app_sessions.hub_code: ''
      app_sessions.session_start_at_day_of_week: Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday
    sorts: [app_sessions.device_type, app_sessions.session_start_date_granularity]
    limit: 500
    column_limit: 50
    row_total: right
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
    y_axes: [{label: !!null '', orientation: left, series: [{axisId: app_sessions.mcvr1,
            id: android - app_sessions.mcvr1, name: mCVR1 (Android)}, {axisId: app_sessions.mcvr1,
            id: ios - app_sessions.mcvr1, name: mCVR1 (iOS)}, {axisId: app_sessions.mcvr1,
            id: Row Total - app_sessions.mcvr1, name: mCVR1 (All)}], showLabels: true,
        showValues: true, maxValue: 1, minValue: 0.6, unpinAxis: false, tickDensity: default,
        type: linear}]
    x_axis_label: Session Start Date
    series_types:
      app_sessions.cnt_purchase: line
      app_sessions.overall_conversion_rate: line
      android - app_sessions.overall_conversion_rate: line
      ios - app_sessions.overall_conversion_rate: line
      android - app_sessions.mcvr1: line
      ios - app_sessions.mcvr1: line
      Row Total - app_sessions.mcvr1: line
    series_colors:
      app_sessions.overall_conversion_rate: "#FBB555"
      app_sessions.count: "#75E2E2"
      android - app_sessions.count: "#d4d4d4"
      android - app_sessions.overall_conversion_rate: "#9f71f0"
      ios - app_sessions.overall_conversion_rate: "#e21c79"
      ios - app_sessions.count: "#ababab"
      android - app_sessions.mcvr1: "#c6d5eb"
      ios - app_sessions.mcvr1: "#c6d5eb"
      Row Total - app_sessions.mcvr1: "#4276BE"
    series_labels:
      app_sessions.count: Number Of Sessions (30 min.)
      app_sessions.overall_conversion_rate: Conversion Rate
      android - app_sessions.count: Android Number Of Sessions
      ios - app_sessions.count: iOS Number Of Sessions
      android - app_sessions.overall_conversion_rate: Android Conversion Rate
      ios - app_sessions.overall_conversion_rate: iOS Conversion Rate
      Row Total - app_sessions.mcvr1: mCVR1 (All)
      ios - app_sessions.mcvr1: mCVR1 (iOS)
      android - app_sessions.mcvr1: mCVR1 (Android)
    series_point_styles:
      android - app_sessions.overall_conversion_rate: square
      ios - app_sessions.overall_conversion_rate: diamond
      android - app_sessions.mcvr1: square
      ios - app_sessions.mcvr1: diamond
    defaults_version: 1
    hidden_fields: [app_sessions.count]
    note_state: collapsed
    note_display: hover
    note_text: What was mCVR1 per date over the selected period? (= sessions with
      has address / all sessions) Per platform and in total
    listen:
      Is New User (First Session): app_sessions.is_new_user
    row: 4
    col: 9
    width: 14
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
    explore: address_sessions
    listens_to_filters: []
    field: address_sessions.device_type
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
    explore: address_sessions
    listens_to_filters: [Platform]
    field: address_sessions.full_app_version
  - name: Session Start At Date
    title: Session Start At Date
    type: field_filter
    default_value: 30 day ago for 30 day
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
      options: []
    model: flink_v3
    explore: address_sessions
    listens_to_filters: []
    field: address_sessions.session_start_at_date
  - name: Country
    title: Country
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: popover
      options: []
    model: flink_v3
    explore: address_sessions
    listens_to_filters: []
    field: address_sessions.country
  - name: Is New User (First Session)
    title: Is New User (First Session)
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: button_group
      display: inline
      options: []
    model: flink_v3
    explore: address_sessions
    listens_to_filters: []
    field: address_sessions.is_new_user
