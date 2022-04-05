- dashboard: wip_address_daily_aggregates_2
  title: "[WIP] Address Daily Aggregates 2"
  layout: newspaper
  preferred_viewer: dashboards-next
  description: description
  elements:
  - title: Address Selected
    name: Address Selected
    model: flink_v3
    explore: address_daily_aggregates
    type: single_value
    fields: [address_daily_aggregates.count, address_daily_aggregates.cnt_users_address_selected,
      address_daily_aggregates.cnt_confirmed_and_skipped_area_available, address_daily_aggregates.cnt_address_confirmed_area_available]
    limit: 500
    column_limit: 50
    dynamic_fields: [{category: table_calculation, expression: " (${address_daily_aggregates.cnt_address_confirmed_area_available}+${address_daily_aggregates.cnt_confirmed_and_skipped_area_available})",
        label: confirmed available, value_format: !!null '', value_format_name: !!null '',
        _kind_hint: measure, table_calculation: confirmed_available, _type_hint: number,
        is_disabled: true}, {category: table_calculation, expression: "${confirmed_available}/${address_daily_aggregates.cnt_users_address_selected}",
        label: "% confirmed available", value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: confirmed_available_1, _type_hint: number,
        is_disabled: true}, {category: table_calculation, expression: "(${address_daily_aggregates.cnt_address_confirmed_area_available}+${address_daily_aggregates.cnt_confirmed_and_skipped_area_available})/${address_daily_aggregates.count}",
        label: conversion over active users, value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: cvr, _type_hint: number}, {category: table_calculation,
        expression: 'sum(offset_list(${address_daily_aggregates.cnt_users_address_selected},7,7))/sum(offset_list(${address_daily_aggregates.count},7,7))',
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
    hidden_fields: [address_daily_aggregates.count, address_daily_aggregates.cnt_users_address_selected,
      address_daily_aggregates.cnt_confirmed_and_skipped_area_available, address_daily_aggregates.cnt_address_confirmed_area_available]
    y_axes: []
    note_state: collapsed
    note_display: hover
    note_text: What % of users selected a (new) address? (= users with address selected
      / active users)
    listen:
      Platform: daily_user_aggregates.platform
      App Version: daily_user_aggregates.full_app_version
      Country: daily_user_aggregates.country_iso
      Event Date: address_daily_aggregates.event_date_at_date
      Is New User (First Day): daily_user_aggregates.is_new_user
    row: 7
    col: 1
    width: 4
    height: 2
  - title: Waitlist Intent
    name: Waitlist Intent
    model: flink_v3
    explore: address_daily_aggregates
    type: single_value
    fields: [address_daily_aggregates.cnt_has_waitlist_signup_selected, address_daily_aggregates.count,
      address_daily_aggregates.cnt_waitlist_area_unavailable, address_daily_aggregates.cnt_waitlist_and_browse_area_unavailable]
    limit: 500
    column_limit: 50
    dynamic_fields: [{category: table_calculation, expression: "${address_daily_aggregates.cnt_has_waitlist_signup_selected}-\
          \ (${address_daily_aggregates.cnt_waitlist_area_unavailable}+${address_daily_aggregates.cnt_waitlist_and_browse_area_unavailable})",
        label: waitlist in available area, value_format: !!null '', value_format_name: !!null '',
        _kind_hint: measure, table_calculation: waitlist_in_available_area, _type_hint: number,
        is_disabled: true}, {category: table_calculation, expression: "${waitlist_in_available_area}/${address_daily_aggregates.cnt_has_waitlist_signup_selected}",
        label: "% waitlist available area", value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: waitlist_available_area, _type_hint: number,
        is_disabled: true}, {category: table_calculation, expression: "(${address_daily_aggregates.cnt_waitlist_area_unavailable}+${address_daily_aggregates.cnt_waitlist_and_browse_area_unavailable})/${address_daily_aggregates.count}",
        label: conversion, value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: cvr, _type_hint: number}, {category: table_calculation,
        expression: 'sum(offset_list(${address_daily_aggregates.cnt_has_waitlist_signup_selected},7,7))/sum(offset_list(${address_daily_aggregates.count},7,7))',
        label: conversion last week, value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: conversion_last_week, _type_hint: number,
        is_disabled: true}, {category: table_calculation, expression: "(${conversion_this_week}-${conversion_last_week})*100",
        label: conversion diff, value_format: 0.0 pp, value_format_name: !!null '',
        _kind_hint: measure, table_calculation: conversion_diff, _type_hint: number,
        is_disabled: true}, {category: measure, expression: !!null '', label: New
          Measure, value_format: !!null '', value_format_name: !!null '', based_on: address_daily_aggregates.cnt_has_waitlist_signup_selected,
        _kind_hint: measure, measure: new_measure, type: sum, _type_hint: number,
        filters: {address_daily_aggregates.cnt_has_waitlist_signup_selected: not null}}]
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
    hidden_fields: [address_daily_aggregates.cnt_has_waitlist_signup_selected, address_daily_aggregates.count,
      address_daily_aggregates.cnt_waitlist_area_unavailable, address_daily_aggregates.cnt_waitlist_and_browse_area_unavailable]
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    y_axes: []
    note_state: collapsed
    note_display: hover
    note_text: What % of daily users tap on the join waitlist button in a location
      outside of our delivery zone? (= daily users with waitlist intent in unavailable
      area / active users)
    listen:
      Platform: daily_user_aggregates.platform
      App Version: daily_user_aggregates.full_app_version
      Country: daily_user_aggregates.country_iso
      Event Date: address_daily_aggregates.event_date_at_date
      Is New User (First Day): daily_user_aggregates.is_new_user
    row: 7
    col: 5
    width: 4
    height: 2
  - title: Actions Inside Delivery Area (% Of Active Users)
    name: Actions Inside Delivery Area (% Of Active Users)
    model: flink_v3
    explore: address_daily_aggregates
    type: looker_column
    fields: [address_daily_aggregates.event_date_at_date, address_daily_aggregates.count,
      address_daily_aggregates.cnt_users_location_pin_placed, address_daily_aggregates.cnt_address_confirmed_area_available,
      address_daily_aggregates.cnt_address_skipped_in_available_area, address_daily_aggregates.cnt_available_area,
      address_daily_aggregates.cnt_noaction_area_available, address_daily_aggregates.cnt_confirmed_and_skipped_area_available]
    fill_fields: [address_daily_aggregates.event_date_at_date]
    sorts: [address_daily_aggregates.event_date_at_date desc]
    limit: 500
    column_limit: 50
    dynamic_fields: [{category: table_calculation, expression: "${address_daily_aggregates.cnt_available_area}/${address_daily_aggregates.count}",
        label: "% inside delivery zone", value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: inside_delivery_zone, _type_hint: number},
      {category: table_calculation, expression: "${address_daily_aggregates.cnt_address_confirmed_area_available}/${address_daily_aggregates.count}",
        label: "% address confirmed", value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: address_confirmed, _type_hint: number},
      {category: table_calculation, expression: "${address_daily_aggregates.cnt_confirmed_and_skipped_area_available}/${address_daily_aggregates.count}",
        label: "% skipped and confirmed", value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: skipped_and_confirmed, _type_hint: number},
      {category: table_calculation, expression: "${address_daily_aggregates.cnt_address_skipped_in_available_area}/${address_daily_aggregates.count}",
        label: "% address skipped", value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: address_skipped, _type_hint: number},
      {category: table_calculation, expression: "${address_daily_aggregates.cnt_noaction_area_available}/${address_daily_aggregates.count}",
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
    limit_displayed_rows: true
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
    y_axes: []
    limit_displayed_rows_values:
      show_hide: hide
      first_last: first
      num_rows: '1'
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
    hidden_fields: [address_daily_aggregates.count, address_daily_aggregates.cnt_users_location_pin_placed,
      address_daily_aggregates.cnt_address_confirmed_area_available, address_daily_aggregates.cnt_address_skipped_in_available_area,
      address_daily_aggregates.cnt_available_area, address_daily_aggregates.cnt_noaction_area_available,
      inside_delivery_zone, sum_actions, address_daily_aggregates.cnt_confirmed_and_skipped_area_available]
    note_state: collapsed
    note_display: hover
    note_text: What % of users take key actions while at a deliverable location? (=
      users with action X in deliverable location / active users)
    listen:
      Platform: daily_user_aggregates.platform
      App Version: daily_user_aggregates.full_app_version
      Country: daily_user_aggregates.country_iso
      Event Date: address_daily_aggregates.event_date_at_date
      Is New User (First Day): daily_user_aggregates.is_new_user
    row: 19
    col: 0
    width: 12
    height: 7
  - title: Actions Outside Delivery Area (% Of Active Users)
    name: Actions Outside Delivery Area (% Of Active Users)
    model: flink_v3
    explore: address_daily_aggregates
    type: looker_column
    fields: [address_daily_aggregates.event_date_at_date, address_daily_aggregates.count,
      address_daily_aggregates.cnt_users_location_pin_placed, address_daily_aggregates.cnt_waitlist_area_unavailable,
      address_daily_aggregates.cnt_browse_area_unavailable, address_daily_aggregates.cnt_unavailable_area,
      address_daily_aggregates.cnt_noaction_area_unavailable, address_daily_aggregates.cnt_waitlist_and_browse_area_unavailable]
    fill_fields: [address_daily_aggregates.event_date_at_date]
    sorts: [address_daily_aggregates.event_date_at_date desc]
    limit: 500
    column_limit: 50
    dynamic_fields: [{category: table_calculation, expression: "${address_daily_aggregates.cnt_unavailable_area}/${address_daily_aggregates.count}",
        label: "% inside delivery zone", value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: inside_delivery_zone, _type_hint: number},
      {category: table_calculation, expression: "${address_daily_aggregates.cnt_waitlist_area_unavailable}/${address_daily_aggregates.count}",
        label: "% waitlist intent", value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: waitlist_intent, _type_hint: number},
      {category: table_calculation, expression: "${address_daily_aggregates.cnt_waitlist_and_browse_area_unavailable}/${address_daily_aggregates.count}",
        label: "% waitlist and browse", value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: waitlist_and_browse, _type_hint: number},
      {category: table_calculation, expression: "${address_daily_aggregates.cnt_browse_area_unavailable}/${address_daily_aggregates.count}",
        label: "% selection browse", value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: selection_browse, _type_hint: number},
      {category: table_calculation, expression: "${address_daily_aggregates.cnt_noaction_area_unavailable}/${address_daily_aggregates.count}",
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
    limit_displayed_rows: true
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
    y_axes: []
    limit_displayed_rows_values:
      show_hide: hide
      first_last: first
      num_rows: '1'
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
    hidden_fields: [address_daily_aggregates.count, address_daily_aggregates.cnt_users_location_pin_placed,
      inside_delivery_zone, sum_actions, address_daily_aggregates.cnt_unavailable_area,
      address_daily_aggregates.cnt_waitlist_area_unavailable, address_daily_aggregates.cnt_browse_area_unavailable,
      address_daily_aggregates.cnt_noaction_area_unavailable, address_daily_aggregates.cnt_waitlist_and_browse_area_unavailable]
    note_state: collapsed
    note_display: hover
    note_text: What % of users take key actions while not in a deliverable location?
      (= users with action X in undeliverable location / active users)
    listen:
      Platform: daily_user_aggregates.platform
      App Version: daily_user_aggregates.full_app_version
      Country: daily_user_aggregates.country_iso
      Event Date: address_daily_aggregates.event_date_at_date
      Is New User (First Day): daily_user_aggregates.is_new_user
    row: 19
    col: 12
    width: 12
    height: 7
  - title: Outside Of Delivery Area
    name: Outside Of Delivery Area
    model: flink_v3
    explore: address_daily_aggregates
    type: single_value
    fields: [address_daily_aggregates.cnt_users_location_pin_placed, address_daily_aggregates.cnt_unavailable_area,
      address_daily_aggregates.count]
    limit: 500
    column_limit: 50
    dynamic_fields: [{category: table_calculation, expression: "${address_daily_aggregates.cnt_unavailable_area}/${address_daily_aggregates.count}",
        label: "% Daily users in undeliverable locations over all active daily users",
        value_format: !!null '', value_format_name: percent_1, _kind_hint: measure,
        table_calculation: users_with_unavailable_areas_over_active_users, _type_hint: number},
      {category: table_calculation, expression: 'sum(offset_list(${address_daily_aggregates.cnt_unavailable_area},0,7))/sum(offset_list(${address_daily_aggregates.cnt_users_location_pin_placed},0,7))',
        label: "% Daily users in undeliverable locationslast 7 days", value_format: !!null '',
        value_format_name: percent_1, _kind_hint: measure, table_calculation: users_with_unavailable_area_last_7_days,
        _type_hint: number, is_disabled: true}, {category: table_calculation, expression: 'sum(offset_list(${address_daily_aggregates.cnt_unavailable_area},7,7))/sum(offset_list(${address_daily_aggregates.cnt_users_location_pin_placed},7,7))',
        label: "% Daily users in undeliverable locations prior 7 days", value_format: !!null '',
        value_format_name: percent_1, _kind_hint: measure, table_calculation: users_with_unavailable_area_prior_7_days,
        _type_hint: number, is_disabled: true}, {category: table_calculation, expression: "(${users_with_unavailable_area_last_7_days}-${users_with_unavailable_area_prior_7_days})*100",
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
    hidden_fields: [address_daily_aggregates.cnt_unavailable_area, address_daily_aggregates.cnt_users_location_pin_placed,
      address_daily_aggregates.count]
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
    note_text: What % of users go into the address selection flow (at least 1 location
      pin placed) and end up in an undeliverable location? (= users who have seen
      an undeliverable location / active users)
    listen:
      Platform: daily_user_aggregates.platform
      App Version: daily_user_aggregates.full_app_version
      Country: daily_user_aggregates.country_iso
      Event Date: address_daily_aggregates.event_date_at_date
      Is New User (First Day): daily_user_aggregates.is_new_user
    row: 9
    col: 1
    width: 8
    height: 2
  - title: Outside Of Delivery Area (% Of Active Users)
    name: Outside Of Delivery Area (% Of Active Users)
    model: flink_v3
    explore: address_daily_aggregates
    type: looker_column
    fields: [address_daily_aggregates.cnt_unavailable_area, address_daily_aggregates.event_date_at_date,
      daily_user_aggregates.platform, address_daily_aggregates.cnt_users_location_pin_placed,
      address_daily_aggregates.count]
    pivots: [daily_user_aggregates.platform]
    fill_fields: [address_daily_aggregates.event_date_at_date]
    filters: {}
    sorts: [address_daily_aggregates.event_date_at_date desc, daily_user_aggregates.platform]
    limit: 500
    column_limit: 50
    row_total: right
    dynamic_fields: [{category: table_calculation, expression: "${address_daily_aggregates.cnt_unavailable_area}/${address_daily_aggregates.count}",
        label: "% users in undeliverable location", value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: users_unavailable_area_vs_total, _type_hint: number},
      {category: table_calculation, expression: 'sum(offset_list(${address_daily_aggregates.cnt_unavailable_area},0,7))/sum(offset_list(${address_daily_aggregates.cnt_users_location_pin_placed},0,7))',
        label: "% users in undeliverable location last 7 days", value_format: !!null '',
        value_format_name: percent_1, _kind_hint: measure, table_calculation: users_with_unavailable_area_last_7_days,
        _type_hint: number, is_disabled: true}, {category: table_calculation, expression: 'sum(offset_list(${address_daily_aggregates.cnt_unavailable_area},7,7))/sum(offset_list(${address_daily_aggregates.cnt_users_location_pin_placed},7,7))',
        label: "% users in undeliverable location prior 7 days", value_format: !!null '',
        value_format_name: percent_1, _kind_hint: measure, table_calculation: users_with_unavailable_area_prior_7_days,
        _type_hint: number, is_disabled: true}, {category: table_calculation, expression: "${address_daily_aggregates.cnt_unavailable_area:row_total}/${address_daily_aggregates.count:row_total}",
        label: "% undeliverable location", value_format: !!null '', value_format_name: percent_1,
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
    limit_displayed_rows: true
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
    y_axes: [{label: '', orientation: left, series: [{axisId: android - users_unavailable_area_vs_total,
            id: android - users_unavailable_area_vs_total, name: android}, {axisId: ios
              - users_unavailable_area_vs_total, id: ios - users_unavailable_area_vs_total,
            name: ios}], showLabels: false, showValues: true, unpinAxis: false, tickDensity: default,
        type: linear}]
    limit_displayed_rows_values:
      show_hide: hide
      first_last: first
      num_rows: '1'
    series_types:
      users_with_unavailable_areas_over_active_users: line
      android - users_with_unavailable_areas_over_active_users: line
      ios - users_with_unavailable_areas_over_active_users: line
      android - users_unavailable_area_vs_total: line
      ios - users_unavailable_area_vs_total: line
      unavailable_area: line
      web - users_unavailable_area_vs_total: line
    series_colors:
      address_daily_aggregates.count: "#9eeaea"
      users_with_unavailable_areas_over_active_users: "#B1399E"
      android - address_daily_aggregates.count: "#75E2E2"
      ios - address_daily_aggregates.count: "#9eeaea"
      ios - users_with_unavailable_areas_over_active_users: "#e5508e"
      android - address_daily_aggregates.cnt_users_location_pin_placed: "#75E2E2"
      ios - address_daily_aggregates.cnt_users_location_pin_placed: "#d5f6f6"
      ios - users_unavailable_area_vs_total: "#d7b9f9"
      android - users_unavailable_area_vs_total: "#d7b9f9"
      unavailable_area: "#B1399E"
      web - users_unavailable_area_vs_total: "#d7b9f9"
    series_labels:
      address_daily_aggregates.count: Active Users
      users_with_unavailable_areas_over_active_users: "% Users in undeliverable location"
      android - address_daily_aggregates.count: Active Users (Android)
      ios - address_daily_aggregates.count: Active Users (iOS)
      android - users_with_unavailable_areas_over_active_users: "% Users in undeliverable\
        \ location"
      ios - users_with_unavailable_areas_over_active_users: "% Users in undeliverable\
        \ location"
      android - users_unavailable_area_vs_total: Android
      ios - users_unavailable_area_vs_total: iOS
      unavailable_area: All
      web - users_unavailable_area_vs_total: Web
    series_point_styles:
      android - users_unavailable_area_vs_total: square
      ios - users_unavailable_area_vs_total: diamond
      web - users_unavailable_area_vs_total: triangle-down
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
    single_value_title: Users Who Enter Address Selection And Check An Undeliverable
      Location (Last 7 Days)
    hidden_fields: [address_daily_aggregates.cnt_unavailable_area, address_daily_aggregates.cnt_users_location_pin_placed,
      address_daily_aggregates.count]
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    note_state: collapsed
    note_display: hover
    note_text: What % of users go into the address selection flow (at least 1 location
      pin placed) and end up in an undeliverable location? (= users in undeliverable
      location / active users) Per platform and in total
    listen:
      Platform: daily_user_aggregates.platform
      App Version: daily_user_aggregates.full_app_version
      Country: daily_user_aggregates.country_iso
      Event Date: address_daily_aggregates.event_date_at_date
      Is New User (First Day): daily_user_aggregates.is_new_user
    row: 28
    col: 0
    width: 12
    height: 7
  - title: Address Unidentifiable (% Of Users Who Start Address Selection Flow)
    name: Address Unidentifiable (% Of Users Who Start Address Selection Flow)
    model: flink_v3
    explore: address_daily_aggregates
    type: looker_line
    fields: [address_daily_aggregates.cnt_users_location_pin_placed, address_daily_aggregates.cnt_address_resolution_failed_inside_area,
      address_daily_aggregates.event_date_at_date, address_daily_aggregates.cnt_address_resolution_failed_outside_area,
      daily_user_aggregates.platform]
    pivots: [daily_user_aggregates.platform]
    fill_fields: [address_daily_aggregates.event_date_at_date]
    filters: {}
    sorts: [address_daily_aggregates.event_date_at_date desc, daily_user_aggregates.platform]
    limit: 500
    column_limit: 50
    row_total: right
    dynamic_fields: [{category: table_calculation, expression: "${address_daily_aggregates.cnt_address_resolution_failed_inside_area}/${address_daily_aggregates.cnt_users_location_pin_placed}",
        label: "% unidentified inside", value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: unidentified_inside, _type_hint: number},
      {category: table_calculation, expression: "${address_daily_aggregates.cnt_address_resolution_failed_outside_area}/${address_daily_aggregates.cnt_users_location_pin_placed}",
        label: "% unidentified outside", value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: unidentified_outside, _type_hint: number},
      {category: table_calculation, expression: "${address_daily_aggregates.cnt_address_resolution_failed_inside_area:row_total}/${address_daily_aggregates.cnt_users_location_pin_placed:row_total}",
        label: "% unidentified inside", value_format: !!null '', value_format_name: percent_1,
        _kind_hint: supermeasure, table_calculation: unidentified_inside_1, _type_hint: number},
      {category: table_calculation, expression: "${address_daily_aggregates.cnt_address_resolution_failed_outside_area:row_total}/${address_daily_aggregates.cnt_users_location_pin_placed:row_total}",
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
    limit_displayed_rows: true
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
    limit_displayed_rows_values:
      show_hide: hide
      first_last: first
      num_rows: '1'
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
      web - unidentified_outside: "#B1399E"
    series_labels:
      android - unidentified_inside: Inside Delivery Area (Android)
      android - unidentified_outside: Outside Delivery Area (Android)
      ios - unidentified_inside: Inside Delivery Area (iOS)
      ios - unidentified_outside: Outside Delivery Area (iOS)
      web - unidentified_inside: Inside Delivery Area (Web)
      web - unidentified_outside: Outside Delivery Area (Web)
    series_point_styles:
      android - unidentified_addresses: square
      android - unidentified_outside: square
      android - unidentified_inside: square
      ios - unidentified_outside: diamond
      ios - unidentified_inside: diamond
      web - unidentified_outside: triangle-down
      web - unidentified_inside: triangle-down
    defaults_version: 1
    hidden_fields: [address_daily_aggregates.cnt_users_location_pin_placed, address_daily_aggregates.cnt_address_resolution_failed_inside_area,
      address_daily_aggregates.cnt_address_resolution_failed_outside_area, unidentified_inside_1,
      unidentified_outside_1]
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    note_state: collapsed
    note_display: hover
    note_text: What % users entered the address selection flow (at least 1 location
      pin placed) and checked a location of which we couldn't identify the address?
      (= users with unidentifiable address / users with location pin placed)
    listen:
      Platform: daily_user_aggregates.platform
      App Version: daily_user_aggregates.full_app_version
      Country: daily_user_aggregates.country_iso
      Event Date: address_daily_aggregates.event_date_at_date
      Is New User (First Day): daily_user_aggregates.is_new_user
    row: 28
    col: 12
    width: 12
    height: 7
  - title: Address Tap At Checkout (% Of Users Who View Checkout)
    name: Address Tap At Checkout (% Of Users Who View Checkout)
    model: flink_v3
    explore: address_daily_aggregates
    type: looker_line
    fields: [address_daily_aggregates.event_date_at_date, address_daily_aggregates.cnt_is_checkout_viewed,
      address_daily_aggregates.cnt_is_addres_tappped_at_checkout, daily_user_aggregates.platform]
    pivots: [daily_user_aggregates.platform]
    fill_fields: [address_daily_aggregates.event_date_at_date]
    filters: {}
    sorts: [address_daily_aggregates.event_date_at_date desc, daily_user_aggregates.platform]
    limit: 500
    column_limit: 50
    row_total: right
    dynamic_fields: [{category: table_calculation, expression: "${address_daily_aggregates.cnt_is_addres_tappped_at_checkout}/${address_daily_aggregates.cnt_is_checkout_viewed}",
        label: "% address change at checkout", value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: address_change_at_checkout, _type_hint: number},
      {category: table_calculation, expression: "${address_daily_aggregates.cnt_is_addres_tappped_at_checkout:row_total}/${address_daily_aggregates.cnt_is_checkout_viewed:row_total}",
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
      android - address_change_at_checkout: "#C2DD67"
      ios - address_change_at_checkout: "#72D16D"
      tapped_address_at_checkout: "#B1399E"
      web - address_change_at_checkout: "#48d1b3"
    series_labels:
      android - address_change_at_checkout: Android
      ios - address_change_at_checkout: iOS
      tapped_address_at_checkout: Overall
    series_point_styles:
      android - address_change_at_checkout: triangle
      ios - address_change_at_checkout: triangle
      web - address_change_at_checkout: triangle
    defaults_version: 1
    hidden_fields: [address_daily_aggregates.cnt_is_addres_tappped_at_checkout, address_daily_aggregates.cnt_is_checkout_viewed,
      tapped_address_at_checkout]
    note_state: collapsed
    note_display: hover
    note_text: What % users started checkout and tapped on the address shown on the
      checkout page? Presumably these users tried to change the address at checkout.
      (= users with address tapped at checkout / users with checkout viewed)
    listen:
      Platform: daily_user_aggregates.platform
      App Version: daily_user_aggregates.full_app_version
      Country: daily_user_aggregates.country_iso
      Event Date: address_daily_aggregates.event_date_at_date
      Is New User (First Day): daily_user_aggregates.is_new_user
    row: 37
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
      Event Date: order_comments.created_date
    row: 37
    col: 12
    width: 12
    height: 7
  - title: 'Users With Cart Lost (% Of Users Who View Checkout) '
    name: 'Users With Cart Lost (% Of Users Who View Checkout) '
    model: flink_v3
    explore: address_daily_aggregates
    type: looker_line
    fields: [address_daily_aggregates.event_date_at_date, address_daily_aggregates.count,
      address_daily_aggregates.cnt_is_checkout_viewed, address_daily_aggregates.cnt_is_hub_updated_with_cart,
      daily_user_aggregates.platform]
    pivots: [daily_user_aggregates.platform]
    fill_fields: [address_daily_aggregates.event_date_at_date]
    filters: {}
    sorts: [address_daily_aggregates.event_date_at_date desc, daily_user_aggregates.platform]
    limit: 500
    column_limit: 50
    dynamic_fields: [{category: table_calculation, expression: "${address_daily_aggregates.cnt_is_addres_tappped_at_checkout}/${address_daily_aggregates.cnt_is_checkout_viewed}",
        label: "% address change at checkout", value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: address_change_at_checkout, _type_hint: number,
        is_disabled: true}, {category: table_calculation, expression: "${address_daily_aggregates.cnt_is_hub_updated_with_cart}/${address_daily_aggregates.count}",
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
      android - hub_updated: "#C2DD67"
      ios - hub_updated: "#72D16D"
      web - hub_updated: "#48d1b3"
    series_labels:
      hub_updated: "% Lost Cart Due To Hub Update (Android)"
      android - hub_updated: Android
      ios - hub_updated: iOS
      web - hub_updated: Web
    series_point_styles:
      android - address_change_at_checkout: square
      ios - hub_updated: triangle
      web - hub_updated: triangle
      android - hub_updated: triangle
    defaults_version: 1
    hidden_fields: [address_daily_aggregates.cnt_is_checkout_viewed, address_daily_aggregates.cnt_is_hub_updated_with_cart,
      address_daily_aggregates.count]
    note_state: collapsed
    note_display: hover
    note_text: What % of daily users lose their cart because they changed location
      after having something in the cart? (= \# users who lose their cart due to hub
      update after adding product(s) to cart / \# active users)
    listen:
      Platform: daily_user_aggregates.platform
      App Version: daily_user_aggregates.full_app_version
      Country: daily_user_aggregates.country_iso
      Event Date: address_daily_aggregates.event_date_at_date
    row: 45
    col: 0
    width: 12
    height: 6
  - title: "% Unique Locations Ordered To With Delivery Notes"
    name: "% Unique Locations Ordered To With Delivery Notes"
    model: flink_v3
    explore: order_comments
    type: looker_area
    fields: [order_comments.created_date, order_comments.count, order_comments.cnt_unique_order_locations,
      order_comments.cnt_unique_location_has_customer_notes, order_comments.cnt_unique_location_no_customer_notes]
    fill_fields: [order_comments.created_date]
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
    point_style: circle
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    show_totals_labels: false
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
    ordering: none
    show_null_labels: false
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
      Event Date: order_comments.created_date
    row: 44
    col: 12
    width: 12
    height: 7
  - name: ''
    type: text
    title_text: ''
    body_text: "| Term       | | Definition           | \n|-------------|:-------------:||:-------------|\n\
      | mCVR1  |  | % sessions in which there was a delivery address available (either\
      \ in the current session or a previous one), compared to all sessions | \n|\
      \ Unavailable area |  | The user entered the address selection flow and the\
      \ last location the user checked was in an area we don't deliver to (can't be\
      \ selected as address) | \n| Unidentifiable address |  | The location pin was\
      \ on coordinates that could not be resolved into an address (this can happen\
      \ when the user chooses to use their current location or if they move the location\
      \ pin manually) | \n| New user  |  |  User that hasn't been on the app before\
      \ (= first day) according to their Segment ID | \n\n**See [here](https://docs.google.com/spreadsheets/d/1iN3CkrM8cYLnp6UEce-34c_ziF9p_sxhfEW3oDyfD_k/edit#gid=0)\
      \ for Data Glossary with all KPI definitions.**"
    row: 0
    col: 6
    width: 18
    height: 4
  - name: " (2)"
    type: text
    title_text: ''
    body_text: "<img src=\"https://i.imgur.com/KcWQwrB.png\" width=\"50%\"> \n\nData\
      \ Refreshment Rate: Daily"
    row: 0
    col: 0
    width: 6
    height: 4
  - name: Address Selection
    type: text
    title_text: Address Selection
    subtitle_text: ''
    body_text: ''
    row: 11
    col: 0
    width: 24
    height: 2
  - name: Address Management
    type: text
    title_text: Address Management
    body_text: ''
    row: 35
    col: 0
    width: 24
    height: 2
  - title: Inside Delivery Area Funnel By New/Returning User
    name: Inside Delivery Area Funnel By New/Returning User
    model: flink_v3
    explore: address_daily_aggregates
    type: looker_column
    fields: [address_daily_aggregates.count, address_daily_aggregates.cnt_users_location_pin_placed,
      address_daily_aggregates.cnt_available_area, address_daily_aggregates.cnt_address_confirmed_area_available,
      address_daily_aggregates.cnt_confirmed_and_skipped_area_available, daily_user_aggregates.is_new_user]
    fill_fields: [daily_user_aggregates.is_new_user]
    sorts: [daily_user_aggregates.is_new_user]
    limit: 500
    dynamic_fields: [{category: table_calculation, expression: "${address_daily_aggregates.cnt_address_confirmed_area_available}+${address_daily_aggregates.cnt_confirmed_and_skipped_area_available}",
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
    x_axis_label: Is New User (First Day)
    series_colors:
      address_daily_aggregates.count: "#75E2E2"
      address_daily_aggregates.cnt_users_location_pin_placed: "#3EB0D5"
      address_daily_aggregates.cnt_available_area: "#4691d6"
      address_confirmed_total: "#4276BE"
    series_labels:
      address_daily_aggregates.count: Active users
      address_daily_aggregates.cnt_users_location_pin_placed: Address Flow Started
      address_daily_aggregates.cnt_available_area: Address Inside Delivery Area
      address_confirmed_total: Address Selected
    show_dropoff: true
    hidden_fields: [address_daily_aggregates.cnt_address_confirmed_area_available,
      address_daily_aggregates.cnt_confirmed_and_skipped_area_available]
    defaults_version: 1
    y_axes: []
    note_state: collapsed
    note_display: hover
    note_text: How many daily users progressed through the address selection happy
      path for active users inside the delivery area? (percentages shown are comparing
      the previous step to the next one. For overall address selection conversion,
      see "address selected" tile above)
    listen:
      Platform: daily_user_aggregates.platform
      App Version: daily_user_aggregates.full_app_version
      Country: daily_user_aggregates.country_iso
      Event Date: address_daily_aggregates.event_date_at_date
      Is New User (First Day): daily_user_aggregates.is_new_user
    row: 13
    col: 0
    width: 12
    height: 6
  - title: Outside Delivery Area Funnel By New/Returning User
    name: Outside Delivery Area Funnel By New/Returning User
    model: flink_v3
    explore: address_daily_aggregates
    type: looker_column
    fields: [daily_user_aggregates.is_new_user, address_daily_aggregates.count,
      address_daily_aggregates.cnt_users_location_pin_placed, address_daily_aggregates.cnt_unavailable_area,
      address_daily_aggregates.cnt_waitlist_and_browse_area_unavailable, address_daily_aggregates.cnt_waitlist_area_unavailable]
    fill_fields: [daily_user_aggregates.is_new_user]
    sorts: [daily_user_aggregates.is_new_user]
    limit: 500
    dynamic_fields: [{category: table_calculation, expression: "${address_daily_aggregates.cnt_waitlist_area_unavailable}+${address_daily_aggregates.cnt_waitlist_and_browse_area_unavailable}",
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
    x_axis_label: Is New User (First Day)
    series_colors:
      address_daily_aggregates.count: "#75E2E2"
      address_daily_aggregates.cnt_users_location_pin_placed: "#3EB0D5"
      address_daily_aggregates.cnt_available_area: "#4691d6"
      address_confirmed_total: "#4276BE"
      address_daily_aggregates.cnt_unavailable_area: "#B1399E"
      waitlist_intent_total: "#d36ade"
    series_labels:
      address_daily_aggregates.count: Active Users
      address_daily_aggregates.cnt_users_location_pin_placed: Address Flow Started
      address_daily_aggregates.cnt_available_area: Users With Deliverable Location
      address_confirmed_total: Users With Address
      address_daily_aggregates.cnt_unavailable_area: Users outside Deliverable Location
      waitlist_intent_total: Waitlist Signup Intent
    show_dropoff: true
    hidden_fields: [address_daily_aggregates.cnt_waitlist_and_browse_area_unavailable,
      address_daily_aggregates.cnt_waitlist_area_unavailable]
    defaults_version: 1
    y_axes: []
    note_state: collapsed
    note_display: hover
    note_text: How many user progressed through the address selection happy path for
      users outside the delivery area? (percentages shown are comparing the previous
      step to the next one. For overall waitlist conversion, see "waitlist intent"
      tile above)
    listen:
      Platform: daily_user_aggregates.platform
      App Version: daily_user_aggregates.full_app_version
      Country: daily_user_aggregates.country_iso
      Event Date: address_daily_aggregates.event_date_at_date
      Is New User (First Day): daily_user_aggregates.is_new_user
    row: 13
    col: 12
    width: 12
    height: 6
  - name: Delivery Coverage
    type: text
    title_text: Delivery Coverage
    subtitle_text: ''
    body_text: |-
      <p align="center">
      (NOTE : There appears to be an issue with detecting users outside of delivery area and triggering the unidentified address event (Android) - currently under investigation)
      </p>
    row: 26
    col: 0
    width: 24
    height: 2
  - title: New Tile
    name: New Tile
    model: flink_v3
    explore: daily_user_aggregates
    type: single_value
    fields: [daily_user_aggregates.mcvr_1]
    filters:
      daily_user_aggregates.platform: ''
      daily_user_aggregates.event_date_at_date: 30 days ago for 30 days
      daily_user_aggregates.country_iso: ''
      daily_user_aggregates.hub_code: ''
    limit: 500
    column_limit: 50
    dynamic_fields: [{category: table_calculation, expression: 'sum(offset_list(${daily_user_aggregates.users_with_address},0,7))/sum(offset_list(${daily_user_aggregates.active_users},0,7))',
        label: overall conversion this week, value_format: !!null '', value_format_name: percent_1,
        _kind_hint: measure, table_calculation: overall_conversion_this_week, _type_hint: number,
        is_disabled: true}, {category: table_calculation, expression: 'sum(offset_list(${daily_user_aggregates.users_with_address},7,7))/sum(offset_list(${daily_user_aggregates.active_users},7,7))',
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
    note_text: What was mCVR1 over the selected period? (= users with selected address
      / active users)
    listen:
      Is New User (First Day): daily_user_aggregates.is_new_user
    row: 4
    col: 1
    width: 8
    height: 3
  - title: 'mCVR1: Active Users With Address'
    name: 'mCVR1: Active Users With Address'
    model: flink_v3
    explore: daily_user_aggregates
    type: looker_column
    fields: [daily_user_aggregates.active_users, daily_user_aggregates.platform, daily_user_aggregates.event_date_granularity,
      daily_user_aggregates.mcvr_1]
    pivots: [daily_user_aggregates.platform]
    filters:
      daily_user_aggregates.event_date_at_date: 30 days ago for 30 days
      daily_user_aggregates.country_iso: ''
      daily_user_aggregates.platform: ''
      daily_user_aggregates.timeframe_picker: Day
      daily_user_aggregates.hub_code: ''
      global_filters_and_parameters.datasource_filter: 7 days
      daily_user_aggregates.is_active_user: 'yes'
    sorts: [daily_user_aggregates.platform, daily_user_aggregates.event_date_granularity]
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
    y_axes: [{label: !!null '', orientation: left, series: [{axisId: daily_user_aggregates.mcvr_1,
            id: android - daily_user_aggregates.mcvr_1, name: mCVR1 (Android)}, {
            axisId: daily_user_aggregates.mcvr_1, id: ios - daily_user_aggregates.mcvr_1,
            name: mCVR1 (iOS)}, {axisId: daily_user_aggregates.mcvr_1, id: Row Total
              - daily_user_aggregates.mcvr_1, name: mCVR1 (All)}], showLabels: true,
        showValues: true, maxValue: 1, minValue: 0.5, unpinAxis: false, tickDensity: default,
        type: linear}]
    x_axis_label: Event Date
    series_types:
      daily_user_aggregates.cnt_purchase: line
      daily_user_aggregates.cvr: line
      android - daily_user_aggregates.cvr: line
      ios - daily_user_aggregates.cvr: line
      android - daily_user_aggregates.mcvr_1: line
      ios - daily_user_aggregates.mcvr_1: line
      Row Total - daily_user_aggregates.mcvr_1: line
      web - daily_user_aggregates.mcvr_1: line
    series_colors:
      daily_user_aggregates.cvr: "#FBB555"
      daily_user_aggregates.active_users: "#75E2E2"
      android - daily_user_aggregates.active_users: "#d4d4d4"
      android - daily_user_aggregates.cvr: "#9f71f0"
      ios - daily_user_aggregates.cvr: "#e21c79"
      ios - daily_user_aggregates.active_users: "#ababab"
      android - daily_user_aggregates.mcvr_1: "#c6d5eb"
      ios - daily_user_aggregates.mcvr_1: "#c6d5eb"
      Row Total - daily_user_aggregates.mcvr_1: "#4276BE"
      web - daily_user_aggregates.mcvr_1: "#c6d5eb"
    series_labels:
      daily_user_aggregates.active_users:
      daily_user_aggregates.cvr: Conversion Rate
      android - daily_user_aggregates.active_users: Android Number of Active Users
      ios - daily_user_aggregates.active_users: iOS Number of Active Users
      android - daily_user_aggregates.cvr: Android Conversion Rate
      ios - daily_user_aggregates.cvr: iOS Conversion Rate
      Row Total - daily_user_aggregates.mcvr_1: mCVR1 (All)
      ios - daily_user_aggregates.mcvr_1: mCVR1 (iOS)
      android - daily_user_aggregates.mcvr_1: mCVR1 (Android)
      web - daily_user_aggregates.mcvr_1: mCVR1 (Web)
    series_point_styles:
      android - daily_user_aggregates.cvr: square
      ios - daily_user_aggregates.cvr: diamond
      android - daily_user_aggregates.mcvr_1: square
      ios - daily_user_aggregates.mcvr_1: diamond
      web - daily_user_aggregates.mcvr_1: triangle-down
    defaults_version: 1
    hidden_fields: [daily_user_aggregates.active_users]
    note_state: collapsed
    note_display: hover
    note_text: What was mCVR1 per date over the selected period? (= users with address
      / active users) Per platform and in total
    listen:
      Is New User (First Day): daily_user_aggregates.is_new_user
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
    explore: address_daily_aggregates
    listens_to_filters: []
    field: daily_user_aggregates.platform
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
    explore: address_daily_aggregates
    listens_to_filters: [Platform]
    field: daily_user_aggregates.full_app_version
  - name: Event Date
    title: Event Date
    type: field_filter
    default_value: 30 day ago for 30 day
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
      options: []
    model: flink_v3
    explore: address_daily_aggregates
    listens_to_filters: []
    field: address_daily_aggregates.event_date_at_date
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
    explore: address_daily_aggregates
    listens_to_filters: []
    field: daily_user_aggregates.country_iso
  - name: Is New User (First Day)
    title: Is New User (First Day)
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: button_group
      display: inline
      options: []
    model: flink_v3
    explore: address_daily_aggregates
    listens_to_filters: []
    field: daily_user_aggregates.is_new_user
