- dashboard: customer_care_performance2
  title: Customer Care Performance
  layout: newspaper
  preferred_viewer: dashboards-next
  description: ''
  elements:
  - title: KPIs - Overview
    name: KPIs - Overview
    model: flink_v3
    explore: cc_contacts
    type: looker_grid
    fields: [cc_contacts.date, cc_contacts.date_granularity_pass_through,
      cc_contacts.number_of_contacts, cc_orders_hourly2.contact_rate, cc_contacts.share_deflected_by_bot,
      cc_contacts.median_time_to_agent_reply_minutes, cc_contacts.median_time_last_close_minutes,
      cc_contacts.avg_csat, cc_contacts.median_median_time_to_agent_reply_minutes,
      cc_orders_hourly2.cc_refunded_order_rate, cc_orders_hourly2.cc_discounted_order_rate]
    filters: {}
    sorts: [cc_contacts.date desc]
    limit: 500
    column_limit: 50
    dynamic_fields: [{category: table_calculation, expression: "(case(when(diff_days(to_date(${cc_contacts.date}),offset(to_date(${cc_contacts.date}),7))\
          \ = null,null),\n  \n  when(${cc_contacts.date_granularity_pass_through}\
          \ = \"Day\" \n    AND diff_days(to_date(${cc_contacts.date}),offset(to_date(${cc_contacts.date}),7))\
          \ = -7,\n    ( ${cc_orders_hourly2.contact_rate} - offset(${cc_orders_hourly2.contact_rate},\
          \ 7) ) ),\n  when(${cc_contacts.date_granularity_pass_through} = \"\
          Day\"  AND offset(to_date(${cc_contacts.date}),7) = null,null),\n \
          \ when(${cc_contacts.date_granularity_pass_through} = \"Day\" \n  \
          \  AND diff_days(to_date(${cc_contacts.date}),\n      offset(to_date(${cc_contacts.date}),7))\
          \ = -8,( ${cc_orders_hourly2.contact_rate} - offset(${cc_orders_hourly2.contact_rate},\
          \ 6) ) ),\n  when(${cc_contacts.date_granularity_pass_through} = \"\
          Day\" \n    AND diff_days(to_date(${cc_contacts.date}),\n      offset(to_date(${cc_contacts.date}),7))\
          \ = -9,( ${cc_orders_hourly2.contact_rate} - offset(${cc_orders_hourly2.contact_rate},\
          \ 5) ) ),\n  when(${cc_contacts.date_granularity_pass_through} = \"\
          Day\" \n    AND diff_days(to_date(${cc_contacts.date}),\n      offset(to_date(${cc_contacts.date}),7))\
          \ = -11\n    AND diff_days(to_date(${cc_contacts.date}),\n      offset(to_date(${cc_contacts.date}),5))\
          \ = -7\n    ,( ${cc_orders_hourly2.contact_rate} - offset(${cc_orders_hourly2.contact_rate},\
          \ 5) )),\n  when(${cc_contacts.date_granularity_pass_through} = \"\
          Week\" OR ${cc_contacts.date_granularity_pass_through} = \"Month\"\
          , \n  ( ${cc_orders_hourly2.contact_rate} - offset(${cc_orders_hourly2.contact_rate},\
          \ 1) ) ),null)) * 100", label: PoP Contact Rate, value_format: '"▲  "+0.0pp;
          "▼  "-0.0pp; 0', value_format_name: !!null '', _kind_hint: measure, table_calculation: pop_contact_rate,
        _type_hint: number}]
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
    show_sql_query_menu_options: false
    column_order: ["$$$_row_numbers_$$$", cc_contacts.date, cc_contacts.number_of_contacts,
      cc_orders_hourly2.contact_rate, pop_contact_rate, cc_contacts.share_deflected_by_bot,
      cc_contacts.median_time_to_agent_reply_minutes, cc_contacts.median_median_time_to_agent_reply_minutes,
      cc_contacts.median_time_last_close_minutes, cc_contacts.avg_csat]
    show_totals: true
    show_row_totals: true
    truncate_header: false
    series_column_widths:
      cc_contacts.number_of_contacts: 128
      cc_contacts.avg_time_last_close_minutes: 120
      cc_contacts.avg_time_to_agent_reply_minutes: 191
      cc_contacts.share_deflected_by_bot: 161
      cc_contacts.avg_time_first_close_minutes: 135
      cc_contacts.date: 97
      pop_contacts: 145
    series_cell_visualizations:
      cc_contacts.number_of_contacts:
        is_active: true
      cc_contacts.share_deflected_by_bot:
        is_active: true
      cc_contacts.avg_time_last_close_minutes:
        is_active: true
        palette:
          palette_id: d48bf60f-2e79-2feb-69fc-0726beaee7f2
          collection_id: product-custom-collection
          custom_colors:
          - "#b1e84d"
          - "#ffffff"
          - "#f2180f"
      cc_contacts.avg_time_to_agent_reply_minutes:
        is_active: true
        palette:
          palette_id: bd990ab7-9ff8-6d39-ca2a-99d048dd483a
          collection_id: product-custom-collection
          custom_colors:
          - "#b1e84d"
          - "#ffffff"
          - "#f2180f"
      cc_contacts.avg_time_first_close_minutes:
        is_active: true
        palette:
          palette_id: 852e22ed-a714-0e15-322a-0c20c42e16a2
          collection_id: product-custom-collection
          custom_colors:
          - "#b1e84d"
          - "#ffffff"
          - "#f2180f"
      cc_contacts.number_of_contact_per_agent:
        is_active: true
        palette:
          palette_id: 2f2cfd8f-9dbb-0406-cdb9-12fe190b1e92
          collection_id: product-custom-collection
          custom_colors:
          - "#b1e84d"
          - "#ffffff"
          - "#f2180f"
      cc_contacts.share_reply_on_another_day:
        is_active: true
        palette:
          palette_id: 5a0d94d6-74e6-0486-649f-9894089e0431
          collection_id: product-custom-collection
          custom_colors:
          - "#b1e84d"
          - "#ffffff"
          - "#f2180f"
      cc_contacts.median_time_last_close_minutes:
        is_active: true
        palette:
          palette_id: fd1bbe19-5485-5332-13ce-09743216aaea
          collection_id: product-custom-collection
          custom_colors:
          - "#b1e84d"
          - "#ffffff"
          - "#f2180f"
      cc_contacts.median_time_to_agent_reply_minutes:
        is_active: true
        palette:
          palette_id: 1827b1ea-ce6d-fd29-d92e-fc1ece52cbb2
          collection_id: product-custom-collection
          custom_colors:
          - "#b1e84d"
          - "#ffffff"
          - "#f2180f"
      cc_contacts.avg_csat:
        is_active: true
        palette:
          palette_id: f5c1b683-c02e-6b5a-c980-1ff8e2b1bbd6
          collection_id: product-custom-collection
          custom_colors:
          - "#f2180f"
          - "#ffffff"
          - "#b1e84d"
      cc_contacts.median_median_time_to_agent_reply_minutes:
        is_active: true
        palette:
          palette_id: 406f7fd6-8529-48db-8bab-9a9d01687a1f
          collection_id: product-custom-collection
          custom_colors:
          - "#b1e84d"
          - "#ffffff"
          - "#f2180f"
      cc_orders_hourly2.contact_rate:
        is_active: true
        palette:
          palette_id: a3f79267-2f95-cf75-2f9e-ad47b7f5536f
          collection_id: product-custom-collection
          custom_colors:
          - "#b1e84d"
          - "#ffffff"
          - "#f2180f"
      cc_orders_hourly2.cc_refunded_order_rate:
        is_active: true
        palette:
          palette_id: ec3a2d50-c162-bfcd-3edb-f42741aa5d7c
          collection_id: product-custom-collection
          custom_colors:
          - "#b1e84d"
          - "#ffffff"
          - "#f2180f"
      cc_orders_hourly2.cc_discounted_order_rate:
        is_active: true
        palette:
          palette_id: 6b24b3f8-f86c-0ca7-a21f-5a627bb85843
          collection_id: product-custom-collection
          custom_colors:
          - "#b1e84d"
          - "#ffffff"
          - "#f2180f"
    conditional_formatting: [{type: less than, value: 0, background_color: '', font_color: "#72D16D",
        color_application: {collection_id: product-custom-collection, palette_id: product-custom-collection-diverging-0,
          options: {constraints: {min: {type: minimum}, mid: {type: number, value: 0},
              max: {type: maximum}}, mirror: true, reverse: false, stepped: false}},
        bold: false, italic: false, strikethrough: false, fields: [pop_contact_rate]},
      {type: greater than, value: 0, background_color: '', font_color: "#ff5242",
        color_application: {collection_id: product-custom-collection, palette_id: product-custom-collection-diverging-0,
          options: {steps: 5, constraints: {min: {type: minimum}, mid: {type: number,
                value: -20}, max: {type: maximum}}, mirror: true, reverse: false,
            stepped: false}}, bold: false, italic: false, strikethrough: false, fields: [
          pop_contact_rate]}]
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
    hidden_fields: [cc_contacts.date_granularity_pass_through]
    y_axes: []
    listen:
      Source Type: cc_contacts.source_type
      Date Granularity: cc_contacts.date_granularity
      Date: cc_contacts.contact_created_date
      Contact Reason: cc_contacts.contact_reason
      Day of Week: cc_contacts.contact_created_day_of_week
      Country: cc_contacts.country_iso
      Team Name: cc_contacts.team_name
      Is Deflected By Bot (Yes / No): cc_contacts.is_deflected_by_bot
    row: 9
    col: 0
    width: 24
    height: 8
  - title: Contact Reasons
    name: Contact Reasons
    model: flink_v3
    explore: cc_contacts
    type: looker_grid
    fields: [cc_contacts.number_of_contacts, cc_contacts.date, cc_contacts.contact_reason,
      percent_of_intercom_contacts_contacts, cc_contacts.avg_csat]
    pivots: [cc_contacts.date]
    filters: {}
    sorts: [cc_contacts.date, cc_contacts.number_of_contacts desc 0]
    limit: 500
    column_limit: 50
    dynamic_fields: [{category: table_calculation, expression: "case(when(diff_days(to_date(${cc_contacts.date}),offset(to_date(${cc_contacts.date}),7))\
          \ = null,null),\n  \n  when(${cc_contacts.date_granularity_pass_through}\
          \ = \"Day\" \n    AND diff_days(to_date(${cc_contacts.date}),offset(to_date(${cc_contacts.date}),7))\
          \ = -7,\n    ( ${cc_contacts.number_of_contacts} - offset(${cc_contacts.number_of_contacts},\
          \ 7) ) / offset(${cc_contacts.number_of_contacts}, 7)),\n  when(${cc_contacts.date_granularity_pass_through}\
          \ = \"Day\"  AND offset(to_date(${cc_contacts.date}),7) = null,null),\n\
          \  when(${cc_contacts.date_granularity_pass_through} = \"Day\" \n \
          \   AND diff_days(to_date(${cc_contacts.date}),\n      offset(to_date(${cc_contacts.date}),7))\
          \ = -8,( ${cc_contacts.number_of_contacts} - offset(${cc_contacts.number_of_contacts},\
          \ 6) ) / offset(${cc_contacts.number_of_contacts}, 6)),\n  when(${cc_contacts.date_granularity_pass_through}\
          \ = \"Day\" \n    AND diff_days(to_date(${cc_contacts.date}),\n   \
          \   offset(to_date(${cc_contacts.date}),7)) = -9,( ${cc_contacts.number_of_contacts}\
          \ - offset(${cc_contacts.number_of_contacts}, 5) ) / offset(${cc_contacts.number_of_contacts},\
          \ 5)),\n  when(${cc_contacts.date_granularity_pass_through} = \"Day\"\
          \ \n    AND diff_days(to_date(${cc_contacts.date}),\n      offset(to_date(${cc_contacts.date}),7))\
          \ = -11\n    AND diff_days(to_date(${cc_contacts.date}),\n      offset(to_date(${cc_contacts.date}),5))\
          \ = -7\n    ,( ${cc_contacts.number_of_contacts} - offset(${cc_contacts.number_of_contacts},\
          \ 5) ) / offset(${cc_contacts.number_of_contacts}, 5)),\n  when(${cc_contacts.date_granularity_pass_through}\
          \ = \"Week\" OR ${cc_contacts.date_granularity_pass_through} = \"Month\"\
          , \n  ( ${cc_contacts.number_of_contacts} - offset(${cc_contacts.number_of_contacts},\
          \ 1) ) / offset(${cc_contacts.number_of_contacts}, 1)),null)",
        label: 'PoP # contacts', value_format: '"▲  "+0%; "▼  "-0%; 0', value_format_name: !!null '',
        _kind_hint: measure, table_calculation: pop_contacts, _type_hint: number,
        is_disabled: true}, {args: [cc_contacts.number_of_contacts], calculation_type: percent_of_column_sum,
        category: table_calculation, based_on: cc_contacts.number_of_contacts,
        label: 'Percent of * Intercom contacts * # contacts', source_field: cc_contacts.number_of_contacts,
        table_calculation: percent_of_intercom_contacts_contacts, value_format: !!null '',
        value_format_name: percent_0, _kind_hint: measure, _type_hint: number}]
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
    column_order: ["$$$_row_numbers_$$$", cc_contacts.date, cc_contacts.number_of_contacts,
      pop_contacts, cc_contacts.share_deflected_by_bot, cc_contacts.avg_time_to_agent_reply_minutes,
      cc_contacts.avg_time_first_close_minutes, cc_contacts.avg_time_last_close_minutes,
      cc_contacts.avg_number_of_reopens]
    show_totals: true
    show_row_totals: true
    series_labels:
      percent_of_intercom_contacts_contacts: "% contacts"
    series_column_widths:
      cc_contacts.number_of_contacts: 128
      cc_contacts.avg_time_last_close_minutes: 120
      cc_contacts.avg_time_to_agent_reply_minutes: 191
      cc_contacts.share_deflected_by_bot: 161
      cc_contacts.avg_time_first_close_minutes: 135
      cc_contacts.date: 97
      pop_contacts: 145
    series_cell_visualizations:
      cc_contacts.number_of_contacts:
        is_active: false
      cc_contacts.share_deflected_by_bot:
        is_active: true
      cc_contacts.avg_time_last_close_minutes:
        is_active: true
        palette:
          palette_id: d48bf60f-2e79-2feb-69fc-0726beaee7f2
          collection_id: product-custom-collection
          custom_colors:
          - "#b1e84d"
          - "#ffffff"
          - "#f2180f"
      cc_contacts.avg_time_to_agent_reply_minutes:
        is_active: true
        palette:
          palette_id: bd990ab7-9ff8-6d39-ca2a-99d048dd483a
          collection_id: product-custom-collection
          custom_colors:
          - "#b1e84d"
          - "#ffffff"
          - "#f2180f"
      cc_contacts.avg_time_first_close_minutes:
        is_active: true
        palette:
          palette_id: 852e22ed-a714-0e15-322a-0c20c42e16a2
          collection_id: product-custom-collection
          custom_colors:
          - "#b1e84d"
          - "#ffffff"
          - "#f2180f"
      cc_contacts.number_of_contact_per_agent:
        is_active: true
        palette:
          palette_id: 2f2cfd8f-9dbb-0406-cdb9-12fe190b1e92
          collection_id: product-custom-collection
          custom_colors:
          - "#b1e84d"
          - "#ffffff"
          - "#f2180f"
      cc_contacts.share_reply_on_another_day:
        is_active: true
        palette:
          palette_id: 5a0d94d6-74e6-0486-649f-9894089e0431
          collection_id: product-custom-collection
          custom_colors:
          - "#b1e84d"
          - "#ffffff"
          - "#f2180f"
      percent_of_intercom_contacts_contacts:
        is_active: true
      cc_contacts.avg_csat:
        is_active: true
        palette:
          palette_id: 1bb9fc64-262e-1b85-c0e4-f5fa336705ab
          collection_id: product-custom-collection
          custom_colors:
          - "#f2180f"
          - "#ffffff"
          - "#b1e84d"
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
    hidden_fields: []
    y_axes: []
    title_hidden: true
    listen:
      Source Type: cc_contacts.source_type
      Date Granularity: cc_contacts.date_granularity
      Date: cc_contacts.contact_created_date
      Contact Reason: cc_contacts.contact_reason
      Day of Week: cc_contacts.contact_created_day_of_week
      Country: cc_contacts.country_iso
      Team Name: cc_contacts.team_name
      Is Deflected By Bot (Yes / No): cc_contacts.is_deflected_by_bot
    row: 44
    col: 0
    width: 24
    height: 10
  - title: "# Contacts"
    name: "# Contacts"
    model: flink_v3
    explore: cc_contacts
    type: single_value
    fields: [cc_contacts.number_of_contacts, cc_contacts.contact_created_date]
    fill_fields: [cc_contacts.contact_created_date]
    filters:
      cc_contacts.contact_created_date: 8 days ago for 8 days
    sorts: [cc_contacts.contact_created_date desc]
    limit: 500
    column_limit: 50
    dynamic_fields: [{category: table_calculation, expression: "(${cc_contacts.number_of_contacts}-offset(${cc_contacts.number_of_contacts},7))/offset(${cc_contacts.number_of_contacts},7)",
        label: WoW, value_format: !!null '', value_format_name: percent_0, _kind_hint: measure,
        table_calculation: wow, _type_hint: number}]
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: true
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    comparison_label: ''
    series_types: {}
    defaults_version: 1
    hidden_fields: []
    y_axes: []
    note_state: collapsed
    note_display: hover
    note_text: Number of contacts Started yesterday
    listen:
      Source Type: cc_contacts.source_type
      Contact Reason: cc_contacts.contact_reason
      Day of Week: cc_contacts.contact_created_day_of_week
      Country: cc_contacts.country_iso
      Team Name: cc_contacts.team_name
      Is Deflected By Bot (Yes / No): cc_contacts.is_deflected_by_bot
    row: 3
    col: 3
    width: 7
    height: 3
  - title: "% Deflection Rate"
    name: "% Deflection Rate"
    model: flink_v3
    explore: cc_contacts
    type: single_value
    fields: [cc_contacts.contact_created_date, cc_contacts.share_deflected_by_bot]
    fill_fields: [cc_contacts.contact_created_date]
    filters:
      cc_contacts.contact_created_date: 8 days ago for 8 days
    sorts: [cc_contacts.contact_created_date desc]
    limit: 500
    column_limit: 50
    dynamic_fields: [{category: table_calculation, expression: "(${cc_contacts.share_deflected_by_bot}\
          \ - offset(${cc_contacts.share_deflected_by_bot},7)) *100", label: WoW,
        value_format: 0.0 pp, value_format_name: !!null '', _kind_hint: measure, table_calculation: wow,
        _type_hint: number}]
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    single_value_title: ''
    value_format: ''
    series_types: {}
    defaults_version: 1
    hidden_fields: []
    y_axes: []
    note_state: collapsed
    note_display: hover
    note_text: "% contacts deflected by bot yesterday"
    listen:
      Source Type: cc_contacts.source_type
      Contact Reason: cc_contacts.contact_reason
      Day of Week: cc_contacts.contact_created_day_of_week
      Country: cc_contacts.country_iso
      Team Name: cc_contacts.team_name
      Is Deflected By Bot (Yes / No): cc_contacts.is_deflected_by_bot
    row: 6
    col: 17
    width: 7
    height: 3
  - name: ''
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: "#### Yesterday's KPIs"
    row: 3
    col: 0
    width: 3
    height: 6
  - name: " (2)"
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: '<img src="https://i.imgur.com/KcWQwrB.png" width="25%"> '
    row: 0
    col: 0
    width: 24
    height: 3
  - title: Median Closing Time
    name: Median Closing Time
    model: flink_v3
    explore: cc_contacts
    type: single_value
    fields: [cc_contacts.contact_created_date, cc_contacts.median_time_last_close_minutes]
    fill_fields: [cc_contacts.contact_created_date]
    filters:
      cc_contacts.contact_created_date: 8 days ago for 8 days
    sorts: [cc_contacts.contact_created_date desc]
    limit: 500
    column_limit: 50
    dynamic_fields: [{category: table_calculation, expression: "(${cc_contacts.median_time_last_close_minutes}\
          \ - offset(${cc_contacts.median_time_last_close_minutes},7))/offset(${cc_contacts.median_time_last_close_minutes},7) ",
        label: WoW, value_format: !!null '', value_format_name: percent_0, _kind_hint: measure,
        table_calculation: wow, _type_hint: number}]
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: true
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_types: {}
    defaults_version: 1
    hidden_fields: []
    y_axes: []
    note_state: collapsed
    note_display: hover
    note_text: Median Time to close a contact that started yesterday. In case
      a contact was closed then reopened, we consider the last closed event.
    listen:
      Source Type: cc_contacts.source_type
      Contact Reason: cc_contacts.contact_reason
      Day of Week: cc_contacts.contact_created_day_of_week
      Country: cc_contacts.country_iso
      Team Name: cc_contacts.team_name
      Is Deflected By Bot (Yes / No): cc_contacts.is_deflected_by_bot
    row: 6
    col: 10
    width: 7
    height: 3
  - title: CSAT
    name: CSAT
    model: flink_v3
    explore: cc_contacts
    type: single_value
    fields: [cc_contacts.avg_csat, cc_contacts.contact_created_date]
    fill_fields: [cc_contacts.contact_created_date]
    filters:
      cc_contacts.contact_created_date: 8 days ago for 8 days
    sorts: [cc_contacts.contact_created_date desc]
    limit: 500
    column_limit: 50
    dynamic_fields: [{category: table_calculation, expression: "(${cc_contacts.avg_csat}\
          \ - offset(${cc_contacts.avg_csat},7)) *100", label: WoW, value_format: 0.0
          pp, value_format_name: !!null '', _kind_hint: measure, table_calculation: wow,
        _type_hint: number}]
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    single_value_title: ''
    value_format: ''
    series_types: {}
    defaults_version: 1
    hidden_fields: []
    y_axes: []
    note_state: collapsed
    note_display: hover
    note_text: Average Customer Satisfaction Score based on the rating given by customers
      at the end of the contact. From 0% to 100%
    listen:
      Source Type: cc_contacts.source_type
      Contact Reason: cc_contacts.contact_reason
      Day of Week: cc_contacts.contact_created_day_of_week
      Country: cc_contacts.country_iso
      Team Name: cc_contacts.team_name
      Is Deflected By Bot (Yes / No): cc_contacts.is_deflected_by_bot
    row: 6
    col: 3
    width: 7
    height: 3
  - title: Median Response Time per Day of the Week
    name: Median Response Time per Day of the Week
    model: flink_v3
    explore: cc_contacts
    type: looker_column
    fields: [cc_contacts.contact_created_day_of_week, cc_contacts.median_median_time_to_agent_reply_minutes,
      cc_contacts.contact_created_day_of_week_number]
    sorts: [cc_contacts.contact_created_day_of_week_number]
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
    series_colors:
      cc_contacts.median_median_time_to_agent_reply_minutes: "#f98662"
    defaults_version: 1
    hidden_fields: [cc_contacts.contact_created_day_of_week_number]
    y_axes: []
    listen:
      Source Type: cc_contacts.source_type
      Date: cc_contacts.contact_created_date
      Contact Reason: cc_contacts.contact_reason
      Day of Week: cc_contacts.contact_created_day_of_week
      Country: cc_contacts.country_iso
      Team Name: cc_contacts.team_name
      Is Deflected By Bot (Yes / No): cc_contacts.is_deflected_by_bot
    row: 67
    col: 0
    width: 12
    height: 6
  - name: " (3)"
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: |2-
       <font size = "5"><center><font color="4276BE"><b>Response Time</b></font> </center></font>

      Median Response Time (Minutes) is the median response time for the agents to any message in any contact.
    row: 64
    col: 0
    width: 24
    height: 3
  - title: Median Response Time per Team
    name: Median Response Time per Team
    model: flink_v3
    explore: cc_contacts
    type: looker_column
    fields: [cc_contacts.median_median_time_to_agent_reply_minutes, cc_contacts.team_name]
    filters:
      cc_contacts.team_id: NOT NULL
    sorts: [cc_contacts.median_median_time_to_agent_reply_minutes desc]
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
    series_colors:
      cc_contacts.median_median_time_to_agent_reply_minutes: "#7a9fd1"
    defaults_version: 1
    hidden_fields: []
    y_axes: []
    listen:
      Source Type: cc_contacts.source_type
      Date: cc_contacts.contact_created_date
      Contact Reason: cc_contacts.contact_reason
      Day of Week: cc_contacts.contact_created_day_of_week
      Country: cc_contacts.country_iso
      Team Name: cc_contacts.team_name
      Is Deflected By Bot (Yes / No): cc_contacts.is_deflected_by_bot
    row: 67
    col: 12
    width: 12
    height: 6
  - title: Median Response Time per Hour of the Day
    name: Median Response Time per Hour of the Day
    model: flink_v3
    explore: cc_contacts
    type: looker_column
    fields: [cc_contacts.median_median_time_to_agent_reply_minutes, cc_contacts.contact_hour]
    filters:
      cc_contacts.contact_hour: "[7, 23]"
    sorts: [cc_contacts.contact_hour]
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
    series_colors:
      cc_contacts.median_median_time_to_agent_reply_minutes: "#f98662"
    defaults_version: 1
    hidden_fields: []
    y_axes: []
    listen:
      Source Type: cc_contacts.source_type
      Date: cc_contacts.contact_created_date
      Contact Reason: cc_contacts.contact_reason
      Day of Week: cc_contacts.contact_created_day_of_week
      Country: cc_contacts.country_iso
      Team Name: cc_contacts.team_name
      Is Deflected By Bot (Yes / No): cc_contacts.is_deflected_by_bot
    row: 73
    col: 0
    width: 24
    height: 6
  - title: Contact Reasons - Repartition over Time
    name: Contact Reasons - Repartition over Time
    model: flink_v3
    explore: cc_contacts
    type: looker_column
    fields: [cc_contacts.number_of_contacts, cc_contacts.date, cc_contacts.contact_reason]
    pivots: [cc_contacts.contact_reason]
    filters: {}
    sorts: [cc_contacts.date, cc_contacts.number_of_contacts desc 0,
      cc_contacts.contact_reason]
    limit: 500
    column_limit: 50
    dynamic_fields: [{category: table_calculation, expression: "case(when(diff_days(to_date(${cc_contacts.date}),offset(to_date(${cc_contacts.date}),7))\
          \ = null,null),\n  \n  when(${cc_contacts.date_granularity_pass_through}\
          \ = \"Day\" \n    AND diff_days(to_date(${cc_contacts.date}),offset(to_date(${cc_contacts.date}),7))\
          \ = -7,\n    ( ${cc_contacts.number_of_contacts} - offset(${cc_contacts.number_of_contacts},\
          \ 7) ) / offset(${cc_contacts.number_of_contacts}, 7)),\n  when(${cc_contacts.date_granularity_pass_through}\
          \ = \"Day\"  AND offset(to_date(${cc_contacts.date}),7) = null,null),\n\
          \  when(${cc_contacts.date_granularity_pass_through} = \"Day\" \n \
          \   AND diff_days(to_date(${cc_contacts.date}),\n      offset(to_date(${cc_contacts.date}),7))\
          \ = -8,( ${cc_contacts.number_of_contacts} - offset(${cc_contacts.number_of_contacts},\
          \ 6) ) / offset(${cc_contacts.number_of_contacts}, 6)),\n  when(${cc_contacts.date_granularity_pass_through}\
          \ = \"Day\" \n    AND diff_days(to_date(${cc_contacts.date}),\n   \
          \   offset(to_date(${cc_contacts.date}),7)) = -9,( ${cc_contacts.number_of_contacts}\
          \ - offset(${cc_contacts.number_of_contacts}, 5) ) / offset(${cc_contacts.number_of_contacts},\
          \ 5)),\n  when(${cc_contacts.date_granularity_pass_through} = \"Day\"\
          \ \n    AND diff_days(to_date(${cc_contacts.date}),\n      offset(to_date(${cc_contacts.date}),7))\
          \ = -11\n    AND diff_days(to_date(${cc_contacts.date}),\n      offset(to_date(${cc_contacts.date}),5))\
          \ = -7\n    ,( ${cc_contacts.number_of_contacts} - offset(${cc_contacts.number_of_contacts},\
          \ 5) ) / offset(${cc_contacts.number_of_contacts}, 5)),\n  when(${cc_contacts.date_granularity_pass_through}\
          \ = \"Week\" OR ${cc_contacts.date_granularity_pass_through} = \"Month\"\
          , \n  ( ${cc_contacts.number_of_contacts} - offset(${cc_contacts.number_of_contacts},\
          \ 1) ) / offset(${cc_contacts.number_of_contacts}, 1)),null)",
        label: 'PoP # contacts', value_format: '"▲  "+0%; "▼  "-0%; 0', value_format_name: !!null '',
        _kind_hint: measure, table_calculation: pop_contacts, _type_hint: number,
        is_disabled: true}, {args: [cc_contacts.number_of_contacts], calculation_type: percent_of_column_sum,
        category: table_calculation, based_on: cc_contacts.number_of_contacts,
        label: 'Percent of * Intercom contacts * # contacts', source_field: cc_contacts.number_of_contacts,
        table_calculation: percent_of_intercom_contacts_contacts, value_format: !!null '',
        value_format_name: percent_0, _kind_hint: measure, _type_hint: number, is_disabled: true}]
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
    stacking: percent
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: desc
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    y_axes: [{label: "% contacts", orientation: left, series: [{axisId: General
              - HR Job inquiry - cc_contacts.number_of_contacts, id: General
              - HR Job inquiry - cc_contacts.number_of_contacts, name: General
              - HR Job inquiry}, {axisId: General - Other - cc_contacts.number_of_contacts,
            id: General - Other - cc_contacts.number_of_contacts, name: General
              - Other}, {axisId: Live Order - Cancellation - cc_contacts.number_of_contacts,
            id: Live Order - Cancellation - cc_contacts.number_of_contacts,
            name: Live Order - Cancellation}, {axisId: Live Order - Change order details
              - cc_contacts.number_of_contacts, id: Live Order - Change
              order details - cc_contacts.number_of_contacts, name: Live
              Order - Change order details}, {axisId: Live Order - Order status -
              cc_contacts.number_of_contacts, id: Live Order - Order status
              - cc_contacts.number_of_contacts, name: Live Order - Order
              status}, {axisId: Post Delivery  - Delivery Issue  - cc_contacts.number_of_contacts,
            id: Post Delivery  - Delivery Issue  - cc_contacts.number_of_contacts,
            name: 'Post Delivery  - Delivery Issue '}, {axisId: Post Delivery - Fulfilment
              Issue - cc_contacts.number_of_contacts, id: Post Delivery
              - Fulfilment Issue - cc_contacts.number_of_contacts, name: Post
              Delivery - Fulfilment Issue}, {axisId: Post Delivery - Rider Issue -
              cc_contacts.number_of_contacts, id: Post Delivery - Rider
              Issue - cc_contacts.number_of_contacts, name: Post Delivery
              - Rider Issue}, {axisId: User Journey - Address Issue - cc_contacts.number_of_contacts,
            id: User Journey - Address Issue - cc_contacts.number_of_contacts,
            name: User Journey - Address Issue}, {axisId: User Journey - Feedback
              - cc_contacts.number_of_contacts, id: User Journey - Feedback
              - cc_contacts.number_of_contacts, name: User Journey - Feedback},
          {axisId: User Journey - Information Request - cc_contacts.number_of_contacts,
            id: User Journey - Information Request - cc_contacts.number_of_contacts,
            name: User Journey - Information Request}, {axisId: User Journey - Invoice
              Request - cc_contacts.number_of_contacts, id: User Journey
              - Invoice Request - cc_contacts.number_of_contacts, name: User
              Journey - Invoice Request}, {axisId: User Journey - Payment Issue -
              cc_contacts.number_of_contacts, id: User Journey - Payment
              Issue - cc_contacts.number_of_contacts, name: User Journey
              - Payment Issue}, {axisId: User Journey - Technical Issue - cc_contacts.number_of_contacts,
            id: User Journey - Technical Issue - cc_contacts.number_of_contacts,
            name: User Journey - Technical Issue}, {axisId: User Journey - User Account
              - cc_contacts.number_of_contacts, id: User Journey - User
              Account - cc_contacts.number_of_contacts, name: User Journey
              - User Account}, {axisId: User Journey - Voucher Issue - cc_contacts.number_of_contacts,
            id: User Journey - Voucher Issue - cc_contacts.number_of_contacts,
            name: User Journey - Voucher Issue}, {axisId: cc_contacts.contact_reason___null
              - cc_contacts.number_of_contacts, id: cc_contacts.contact_reason___null
              - cc_contacts.number_of_contacts, name: "∅"}], showLabels: true,
        showValues: true, unpinAxis: false, tickDensity: default, tickDensityCustom: 5,
        type: linear}]
    series_types: {}
    series_labels:
      percent_of_intercom_contacts_contacts: "% contacts"
    column_group_spacing_ratio: 0.1
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    column_order: ["$$$_row_numbers_$$$", cc_contacts.date, cc_contacts.number_of_contacts,
      pop_contacts, cc_contacts.share_deflected_by_bot, cc_contacts.avg_time_to_agent_reply_minutes,
      cc_contacts.avg_time_first_close_minutes, cc_contacts.avg_time_last_close_minutes,
      cc_contacts.avg_number_of_reopens]
    show_totals: true
    show_row_totals: true
    series_column_widths:
      cc_contacts.number_of_contacts: 128
      cc_contacts.avg_time_last_close_minutes: 120
      cc_contacts.avg_time_to_agent_reply_minutes: 191
      cc_contacts.share_deflected_by_bot: 161
      cc_contacts.avg_time_first_close_minutes: 135
      cc_contacts.date: 97
      pop_contacts: 145
    series_cell_visualizations:
      cc_contacts.number_of_contacts:
        is_active: false
      cc_contacts.share_deflected_by_bot:
        is_active: true
      cc_contacts.avg_time_last_close_minutes:
        is_active: true
        palette:
          palette_id: d48bf60f-2e79-2feb-69fc-0726beaee7f2
          collection_id: product-custom-collection
          custom_colors:
          - "#b1e84d"
          - "#ffffff"
          - "#f2180f"
      cc_contacts.avg_time_to_agent_reply_minutes:
        is_active: true
        palette:
          palette_id: bd990ab7-9ff8-6d39-ca2a-99d048dd483a
          collection_id: product-custom-collection
          custom_colors:
          - "#b1e84d"
          - "#ffffff"
          - "#f2180f"
      cc_contacts.avg_time_first_close_minutes:
        is_active: true
        palette:
          palette_id: 852e22ed-a714-0e15-322a-0c20c42e16a2
          collection_id: product-custom-collection
          custom_colors:
          - "#b1e84d"
          - "#ffffff"
          - "#f2180f"
      cc_contacts.number_of_contact_per_agent:
        is_active: true
        palette:
          palette_id: 2f2cfd8f-9dbb-0406-cdb9-12fe190b1e92
          collection_id: product-custom-collection
          custom_colors:
          - "#b1e84d"
          - "#ffffff"
          - "#f2180f"
      cc_contacts.share_reply_on_another_day:
        is_active: true
        palette:
          palette_id: 5a0d94d6-74e6-0486-649f-9894089e0431
          collection_id: product-custom-collection
          custom_colors:
          - "#b1e84d"
          - "#ffffff"
          - "#f2180f"
      percent_of_intercom_contacts_contacts:
        is_active: true
      cc_contacts.avg_csat:
        is_active: true
        palette:
          palette_id: 1bb9fc64-262e-1b85-c0e4-f5fa336705ab
          collection_id: product-custom-collection
          custom_colors:
          - "#f2180f"
          - "#ffffff"
          - "#b1e84d"
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    hidden_fields: []
    listen:
      Source Type: cc_contacts.source_type
      Date Granularity: cc_contacts.date_granularity
      Date: cc_contacts.contact_created_date
      Contact Reason: cc_contacts.contact_reason
      Day of Week: cc_contacts.contact_created_day_of_week
      Country: cc_contacts.country_iso
      Team Name: cc_contacts.team_name
      Is Deflected By Bot (Yes / No): cc_contacts.is_deflected_by_bot
    row: 54
    col: 0
    width: 24
    height: 10
  - title: Median Response Time
    name: Median Response Time
    model: flink_v3
    explore: cc_contacts
    type: single_value
    fields: [cc_contacts.contact_created_date, cc_contacts.median_median_time_to_agent_reply_minutes]
    fill_fields: [cc_contacts.contact_created_date]
    filters:
      cc_contacts.contact_created_date: 8 days ago for 8 days
    sorts: [cc_contacts.contact_created_date desc]
    limit: 500
    column_limit: 50
    dynamic_fields: [{category: table_calculation, expression: "(${cc_contacts.median_median_time_to_agent_reply_minutes}\
          \ - offset(${cc_contacts.median_median_time_to_agent_reply_minutes},7))/offset(${cc_contacts.median_median_time_to_agent_reply_minutes},7) ",
        label: WoW, value_format: !!null '', value_format_name: percent_0, _kind_hint: measure,
        table_calculation: wow, _type_hint: number}]
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: true
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    series_types: {}
    defaults_version: 1
    hidden_fields: []
    y_axes: []
    note_state: collapsed
    note_display: hover
    note_text: Median Agent Response Time to any message yesterday
    listen:
      Source Type: cc_contacts.source_type
      Contact Reason: cc_contacts.contact_reason
      Day of Week: cc_contacts.contact_created_day_of_week
      Country: cc_contacts.country_iso
      Team Name: cc_contacts.team_name
      Is Deflected By Bot (Yes / No): cc_contacts.is_deflected_by_bot
    row: 3
    col: 17
    width: 7
    height: 3
  - title: Contact Rate
    name: Contact Rate
    model: flink_v3
    explore: cc_contacts
    type: single_value
    fields: [cc_contacts.contact_created_date, cc_orders_hourly2.contact_rate]
    fill_fields: [cc_contacts.contact_created_date]
    filters:
      cc_contacts.contact_created_date: 8 days ago for 8 days
    sorts: [cc_contacts.contact_created_date desc]
    limit: 500
    column_limit: 50
    dynamic_fields: [{category: table_calculation, expression: "(${cc_orders_hourly2.contact_rate}\
          \ - offset(${cc_orders_hourly2.contact_rate},7)) *100", label: WoW, value_format: 0.0
          pp, value_format_name: !!null '', _kind_hint: measure, table_calculation: wow,
        _type_hint: number}]
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: true
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    single_value_title: ''
    value_format: ''
    series_types: {}
    defaults_version: 1
    hidden_fields: []
    y_axes: []
    note_state: collapsed
    note_display: hover
    note_text: "# contacts started / # Successful Orders yesterday"
    listen:
      Source Type: cc_contacts.source_type
      Contact Reason: cc_contacts.contact_reason
      Day of Week: cc_contacts.contact_created_day_of_week
      Country: cc_contacts.country_iso
      Team Name: cc_contacts.team_name
      Is Deflected By Bot (Yes / No): cc_contacts.is_deflected_by_bot
    row: 3
    col: 10
    width: 7
    height: 3
  - name: " (4)"
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: ' <font size = "5"><center><font color="4276BE"><b>Contact Reasons</b></font>
      </center></font>'
    row: 42
    col: 0
    width: 24
    height: 2
  - name: " (5)"
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: |2-
       <font size = "5"><center><font color="4276BE"><b>CSAT</b></font> </center></font>


      CSAT is the customer satisfaction score based on the rating of the contact by the customer.
    row: 79
    col: 0
    width: 24
    height: 3
  - title: "% contacts with CSAT over Time"
    name: "% contacts with CSAT over Time"
    model: flink_v3
    explore: cc_contacts
    type: looker_column
    fields: [cc_contacts.number_of_rated_contacts, cc_contacts.date,
      cc_contacts.share_rated_contacts]
    sorts: [cc_contacts.date]
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
    y_axes: [{label: '', orientation: left, series: [{axisId: cc_contacts.number_of_rated_contacts,
            id: cc_contacts.number_of_rated_contacts, name: "# contacts\
              \ with CSAT"}], showLabels: true, showValues: true, unpinAxis: false,
        tickDensity: default, tickDensityCustom: 5, type: linear}, {label: !!null '',
        orientation: right, series: [{axisId: cc_contacts.share_contacts_with_refunds,
            id: cc_contacts.share_contacts_with_refunds, name: "% contacts\
              \ with Refunds"}], showLabels: true, showValues: true, unpinAxis: false,
        tickDensity: default, tickDensityCustom: 5, type: linear}]
    series_types:
      cc_contacts.share_rated_contacts: line
    series_colors:
      cc_contacts.number_of_rated_contacts: "#fccec0"
      cc_contacts.share_rated_contacts: "#7a9fd1"
    defaults_version: 1
    hidden_fields: []
    note_state: collapsed
    note_display: hover
    note_text: "# contacts with a Rating / # All contacts"
    listen:
      Source Type: cc_contacts.source_type
      Date Granularity: cc_contacts.date_granularity
      Date: cc_contacts.contact_created_date
      Contact Reason: cc_contacts.contact_reason
      Day of Week: cc_contacts.contact_created_day_of_week
      Country: cc_contacts.country_iso
      Team Name: cc_contacts.team_name
      Is Deflected By Bot (Yes / No): cc_contacts.is_deflected_by_bot
    row: 101
    col: 0
    width: 16
    height: 7
  - title: CSAT per Contact Reason
    name: CSAT per Contact Reason
    model: flink_v3
    explore: cc_contacts
    type: looker_grid
    fields: [cc_contacts.contact_reason, cc_contacts.avg_csat, cc_contacts.number_of_rated_contacts]
    filters: {}
    sorts: [cc_contacts.avg_csat desc]
    limit: 500
    column_limit: 50
    dynamic_fields: [{category: table_calculation, expression: "case(when(diff_days(to_date(${cc_contacts.date}),offset(to_date(${cc_contacts.date}),7))\
          \ = null,null),\n  \n  when(${cc_contacts.date_granularity_pass_through}\
          \ = \"Day\" \n    AND diff_days(to_date(${cc_contacts.date}),offset(to_date(${cc_contacts.date}),7))\
          \ = -7,\n    ( ${cc_contacts.number_of_contacts} - offset(${cc_contacts.number_of_contacts},\
          \ 7) ) / offset(${cc_contacts.number_of_contacts}, 7)),\n  when(${cc_contacts.date_granularity_pass_through}\
          \ = \"Day\"  AND offset(to_date(${cc_contacts.date}),7) = null,null),\n\
          \  when(${cc_contacts.date_granularity_pass_through} = \"Day\" \n \
          \   AND diff_days(to_date(${cc_contacts.date}),\n      offset(to_date(${cc_contacts.date}),7))\
          \ = -8,( ${cc_contacts.number_of_contacts} - offset(${cc_contacts.number_of_contacts},\
          \ 6) ) / offset(${cc_contacts.number_of_contacts}, 6)),\n  when(${cc_contacts.date_granularity_pass_through}\
          \ = \"Day\" \n    AND diff_days(to_date(${cc_contacts.date}),\n   \
          \   offset(to_date(${cc_contacts.date}),7)) = -9,( ${cc_contacts.number_of_contacts}\
          \ - offset(${cc_contacts.number_of_contacts}, 5) ) / offset(${cc_contacts.number_of_contacts},\
          \ 5)),\n  when(${cc_contacts.date_granularity_pass_through} = \"Day\"\
          \ \n    AND diff_days(to_date(${cc_contacts.date}),\n      offset(to_date(${cc_contacts.date}),7))\
          \ = -11\n    AND diff_days(to_date(${cc_contacts.date}),\n      offset(to_date(${cc_contacts.date}),5))\
          \ = -7\n    ,( ${cc_contacts.number_of_contacts} - offset(${cc_contacts.number_of_contacts},\
          \ 5) ) / offset(${cc_contacts.number_of_contacts}, 5)),\n  when(${cc_contacts.date_granularity_pass_through}\
          \ = \"Week\" OR ${cc_contacts.date_granularity_pass_through} = \"Month\"\
          , \n  ( ${cc_contacts.number_of_contacts} - offset(${cc_contacts.number_of_contacts},\
          \ 1) ) / offset(${cc_contacts.number_of_contacts}, 1)),null)",
        label: 'PoP # contacts', value_format: '"▲  "+0%; "▼  "-0%; 0', value_format_name: !!null '',
        _kind_hint: measure, table_calculation: pop_contacts, _type_hint: number,
        is_disabled: true}, {args: [cc_contacts.number_of_contacts], calculation_type: percent_of_column_sum,
        category: table_calculation, based_on: cc_contacts.number_of_contacts,
        label: 'Percent of * Intercom contacts * # contacts', source_field: cc_contacts.number_of_contacts,
        table_calculation: percent_of_intercom_contacts_contacts, value_format: !!null '',
        value_format_name: percent_0, _kind_hint: measure, _type_hint: number, is_disabled: true}]
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
    column_order: ["$$$_row_numbers_$$$", cc_contacts.contact_reason, cc_contacts.avg_csat,
      cc_contacts.number_of_contacts]
    show_totals: true
    show_row_totals: true
    series_labels:
      percent_of_intercom_contacts_contacts: "% contacts"
    series_column_widths:
      cc_contacts.number_of_contacts: 128
      cc_contacts.avg_time_last_close_minutes: 120
      cc_contacts.avg_time_to_agent_reply_minutes: 191
      cc_contacts.share_deflected_by_bot: 161
      cc_contacts.avg_time_first_close_minutes: 135
      cc_contacts.date: 97
      pop_contacts: 145
    series_cell_visualizations:
      cc_contacts.number_of_contacts:
        is_active: true
      cc_contacts.share_deflected_by_bot:
        is_active: true
      cc_contacts.avg_time_last_close_minutes:
        is_active: true
        palette:
          palette_id: d48bf60f-2e79-2feb-69fc-0726beaee7f2
          collection_id: product-custom-collection
          custom_colors:
          - "#b1e84d"
          - "#ffffff"
          - "#f2180f"
      cc_contacts.avg_time_to_agent_reply_minutes:
        is_active: true
        palette:
          palette_id: bd990ab7-9ff8-6d39-ca2a-99d048dd483a
          collection_id: product-custom-collection
          custom_colors:
          - "#b1e84d"
          - "#ffffff"
          - "#f2180f"
      cc_contacts.avg_time_first_close_minutes:
        is_active: true
        palette:
          palette_id: 852e22ed-a714-0e15-322a-0c20c42e16a2
          collection_id: product-custom-collection
          custom_colors:
          - "#b1e84d"
          - "#ffffff"
          - "#f2180f"
      cc_contacts.number_of_contact_per_agent:
        is_active: true
        palette:
          palette_id: 2f2cfd8f-9dbb-0406-cdb9-12fe190b1e92
          collection_id: product-custom-collection
          custom_colors:
          - "#b1e84d"
          - "#ffffff"
          - "#f2180f"
      cc_contacts.share_reply_on_another_day:
        is_active: true
        palette:
          palette_id: 5a0d94d6-74e6-0486-649f-9894089e0431
          collection_id: product-custom-collection
          custom_colors:
          - "#b1e84d"
          - "#ffffff"
          - "#f2180f"
      percent_of_intercom_contacts_contacts:
        is_active: true
      cc_contacts.avg_csat:
        is_active: true
        palette:
          palette_id: 1bb9fc64-262e-1b85-c0e4-f5fa336705ab
          collection_id: product-custom-collection
          custom_colors:
          - "#f2180f"
          - "#ffffff"
          - "#b1e84d"
      cc_contacts.number_of_rated_contacts:
        is_active: true
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
    hidden_fields: []
    y_axes: []
    listen:
      Source Type: cc_contacts.source_type
      Date Granularity: cc_contacts.date_granularity
      Date: cc_contacts.contact_created_date
      Contact Reason: cc_contacts.contact_reason
      Day of Week: cc_contacts.contact_created_day_of_week
      Country: cc_contacts.country_iso
      Team Name: cc_contacts.team_name
      Is Deflected By Bot (Yes / No): cc_contacts.is_deflected_by_bot
    row: 91
    col: 0
    width: 24
    height: 10
  - name: " (6)"
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: ' <font size = "5"><center><font color="4276BE"><b>Bot Performance</b></font>
      </center></font>'
    row: 108
    col: 0
    width: 24
    height: 2
  - title: "% Deflection Rate over Time"
    name: "% Deflection Rate over Time"
    model: flink_v3
    explore: cc_contacts
    type: looker_column
    fields: [cc_contacts.date, cc_contacts.share_deflected_by_bot, cc_contacts.number_of_deflected_by_bot]
    filters: {}
    sorts: [cc_contacts.date]
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
    y_axes: [{label: '', orientation: left, series: [{axisId: cc_contacts.number_of_rated_contacts,
            id: cc_contacts.number_of_rated_contacts, name: "# contacts\
              \ with CSAT"}], showLabels: true, showValues: true, unpinAxis: false,
        tickDensity: default, tickDensityCustom: 5, type: linear}, {label: !!null '',
        orientation: right, series: [{axisId: cc_contacts.share_contacts_with_refunds,
            id: cc_contacts.share_contacts_with_refunds, name: "% contacts\
              \ with Refunds"}], showLabels: true, showValues: true, unpinAxis: false,
        tickDensity: default, tickDensityCustom: 5, type: linear}]
    series_types:
      cc_contacts.share_rated_contacts: line
      cc_contacts.share_deflected_by_bot: line
    series_colors:
      cc_contacts.number_of_rated_contacts: "#f98662"
      cc_contacts.share_rated_contacts: "#7a9fd1"
      cc_contacts.share_deflected_by_bot: "#f98662"
      cc_contacts.number_of_deflected_by_bot: "#c6d5eb"
    defaults_version: 1
    hidden_fields: []
    listen:
      Source Type: cc_contacts.source_type
      Date Granularity: cc_contacts.date_granularity
      Date: cc_contacts.contact_created_date
      Contact Reason: cc_contacts.contact_reason
      Day of Week: cc_contacts.contact_created_day_of_week
      Country: cc_contacts.country_iso
      Team Name: cc_contacts.team_name
      Is Deflected By Bot (Yes / No): cc_contacts.is_deflected_by_bot
    row: 110
    col: 0
    width: 24
    height: 7
  - title: Bot CSAT
    name: Bot CSAT
    model: flink_v3
    explore: cc_contacts
    type: single_value
    fields: [cc_contacts.avg_csat]
    filters: {}
    limit: 500
    column_limit: 50
    dynamic_fields: [{category: table_calculation, expression: "(${cc_contacts.avg_csat}\
          \ - offset(${cc_contacts.avg_csat},7)) *100", label: WoW, value_format: 0.0
          pp, value_format_name: !!null '', _kind_hint: measure, table_calculation: wow,
        _type_hint: number, is_disabled: true}]
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
    value_format: ''
    series_types: {}
    defaults_version: 1
    hidden_fields: []
    y_axes: []
    listen:
      Source Type: cc_contacts.source_type
      Date: cc_contacts.contact_created_date
      Contact Reason: cc_contacts.contact_reason
      Day of Week: cc_contacts.contact_created_day_of_week
      Country: cc_contacts.country_iso
      Team Name: cc_contacts.team_name
      Is Deflected By Bot (Yes / No): cc_contacts.is_deflected_by_bot
    row: 82
    col: 12
    width: 6
    height: 3
  - title: Overall CSAT
    name: Overall CSAT
    model: flink_v3
    explore: cc_contacts
    type: single_value
    fields: [cc_contacts.avg_csat]
    limit: 500
    column_limit: 50
    dynamic_fields: [{category: table_calculation, expression: "(${cc_contacts.avg_csat}\
          \ - offset(${cc_contacts.avg_csat},7)) *100", label: WoW, value_format: 0.0
          pp, value_format_name: !!null '', _kind_hint: measure, table_calculation: wow,
        _type_hint: number, is_disabled: true}]
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    custom_color: "#E31C79"
    single_value_title: ''
    value_format: ''
    series_types: {}
    defaults_version: 1
    hidden_fields: []
    y_axes: []
    listen:
      Source Type: cc_contacts.source_type
      Date: cc_contacts.contact_created_date
      Contact Reason: cc_contacts.contact_reason
      Day of Week: cc_contacts.contact_created_day_of_week
      Country: cc_contacts.country_iso
      Team Name: cc_contacts.team_name
      Is Deflected By Bot (Yes / No): cc_contacts.is_deflected_by_bot
    row: 82
    col: 0
    width: 6
    height: 3
  - title: "% contacts with CSAT"
    name: "% contacts with CSAT"
    model: flink_v3
    explore: cc_contacts
    type: single_value
    fields: [cc_contacts.share_rated_contacts]
    limit: 500
    column_limit: 50
    dynamic_fields: [{category: table_calculation, expression: "(${cc_contacts.avg_csat}\
          \ - offset(${cc_contacts.avg_csat},7)) *100", label: WoW, value_format: 0.0
          pp, value_format_name: !!null '', _kind_hint: measure, table_calculation: wow,
        _type_hint: number, is_disabled: true}]
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    single_value_title: ''
    value_format: ''
    series_types: {}
    defaults_version: 1
    hidden_fields: []
    y_axes: []
    listen:
      Source Type: cc_contacts.source_type
      Date: cc_contacts.contact_created_date
      Contact Reason: cc_contacts.contact_reason
      Day of Week: cc_contacts.contact_created_day_of_week
      Country: cc_contacts.country_iso
      Team Name: cc_contacts.team_name
      Is Deflected By Bot (Yes / No): cc_contacts.is_deflected_by_bot
    row: 82
    col: 6
    width: 6
    height: 3
  - title: Agent CSAT
    name: Agent CSAT
    model: flink_v3
    explore: cc_contacts
    type: single_value
    fields: [cc_contacts.avg_csat]
    filters: {}
    limit: 500
    column_limit: 50
    dynamic_fields: [{category: table_calculation, expression: "(${cc_contacts.avg_csat}\
          \ - offset(${cc_contacts.avg_csat},7)) *100", label: WoW, value_format: 0.0
          pp, value_format_name: !!null '', _kind_hint: measure, table_calculation: wow,
        _type_hint: number, is_disabled: true}]
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
    value_format: ''
    series_types: {}
    defaults_version: 1
    hidden_fields: []
    y_axes: []
    listen:
      Source Type: cc_contacts.source_type
      Date: cc_contacts.contact_created_date
      Contact Reason: cc_contacts.contact_reason
      Day of Week: cc_contacts.contact_created_day_of_week
      Country: cc_contacts.country_iso
      Team Name: cc_contacts.team_name
      Is Deflected By Bot (Yes / No): cc_contacts.is_deflected_by_bot
    row: 82
    col: 18
    width: 6
    height: 3
  - title: CSAT per Team
    name: CSAT per Team
    model: flink_v3
    explore: cc_contacts
    type: looker_column
    fields: [cc_contacts.team_name, cc_contacts.avg_csat]
    filters:
      cc_contacts.team_id: NOT NULL
    sorts: [cc_contacts.avg_csat desc]
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
    series_colors:
      cc_contacts.median_median_time_to_agent_reply_minutes: "#7a9fd1"
      cc_contacts.avg_csat: "#7a9fd1"
    defaults_version: 1
    hidden_fields: []
    y_axes: []
    listen:
      Source Type: cc_contacts.source_type
      Date: cc_contacts.contact_created_date
      Contact Reason: cc_contacts.contact_reason
      Day of Week: cc_contacts.contact_created_day_of_week
      Country: cc_contacts.country_iso
      Team Name: cc_contacts.team_name
      Is Deflected By Bot (Yes / No): cc_contacts.is_deflected_by_bot
    row: 101
    col: 16
    width: 8
    height: 7
  - name: " (7)"
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: ' <font size = "5"><center><font color="4276BE"><b>Contact Rate</b></font>
      </center></font>'
    row: 17
    col: 0
    width: 24
    height: 2
  - title: "% Contact Rate over Time"
    name: "% Contact Rate over Time"
    model: flink_v3
    explore: cc_contacts
    type: looker_line
    fields: [cc_contacts.date, cc_orders_hourly2.contact_rate, cc_contacts.number_of_contacts]
    sorts: [cc_contacts.date]
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
    point_style: none
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    color_application:
      collection_id: product-custom-collection
      palette_id: product-custom-collection-categorical-0
      options:
        steps: 5
    y_axes: [{label: '', orientation: left, series: [{axisId: cc_contacts.number_of_rated_contacts,
            id: cc_contacts.number_of_rated_contacts, name: "# contacts\
              \ with CSAT"}], showLabels: true, showValues: true, unpinAxis: false,
        tickDensity: default, tickDensityCustom: 5, type: linear}, {label: !!null '',
        orientation: right, series: [{axisId: cc_contacts.share_contacts_with_refunds,
            id: cc_contacts.share_contacts_with_refunds, name: "% contacts\
              \ with Refunds"}], showLabels: true, showValues: true, unpinAxis: false,
        tickDensity: default, tickDensityCustom: 5, type: linear}]
    series_types:
      cc_contacts.number_of_contacts: column
    series_colors:
      cc_contacts.number_of_rated_contacts: "#f98662"
      cc_contacts.share_rated_contacts: "#7a9fd1"
      cc_contacts.share_deflected_by_bot: "#f98662"
      cc_contacts.number_of_deflected_by_bot: "#7a9fd1"
      cc_orders_hourly2.contact_rate: "#4276BE"
      cc_contacts.number_of_contacts: "#fccec0"
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    hidden_fields: []
    note_state: collapsed
    note_display: hover
    note_text: 'Contact Rate = # contacts Started / # Successful Orders.

      '
    listen:
      Source Type: cc_contacts.source_type
      Date Granularity: cc_contacts.date_granularity
      Date: cc_contacts.contact_created_date
      Contact Reason: cc_contacts.contact_reason
      Day of Week: cc_contacts.contact_created_day_of_week
      Country: cc_contacts.country_iso
      Team Name: cc_contacts.team_name
      Is Deflected By Bot (Yes / No): cc_contacts.is_deflected_by_bot
    row: 19
    col: 0
    width: 24
    height: 8
  - title: "% CSAT over Time"
    name: "% CSAT over Time"
    model: flink_v3
    explore: cc_contacts
    type: looker_line
    fields: [cc_contacts.date, cc_contacts.avg_csat]
    sorts: [cc_contacts.date]
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
    point_style: none
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    y_axes: [{label: '', orientation: left, series: [{axisId: cc_contacts.number_of_rated_contacts,
            id: cc_contacts.number_of_rated_contacts, name: "# contacts\
              \ with CSAT"}], showLabels: true, showValues: true, unpinAxis: false,
        tickDensity: default, tickDensityCustom: 5, type: linear}, {label: !!null '',
        orientation: right, series: [{axisId: cc_contacts.share_contacts_with_refunds,
            id: cc_contacts.share_contacts_with_refunds, name: "% contacts\
              \ with Refunds"}], showLabels: true, showValues: true, unpinAxis: false,
        tickDensity: default, tickDensityCustom: 5, type: linear}]
    series_types: {}
    series_colors:
      cc_contacts.number_of_rated_contacts: "#fccec0"
      cc_contacts.share_rated_contacts: "#7a9fd1"
      cc_contacts.avg_csat: "#7a9fd1"
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    hidden_fields: []
    listen:
      Source Type: cc_contacts.source_type
      Date Granularity: cc_contacts.date_granularity
      Date: cc_contacts.contact_created_date
      Contact Reason: cc_contacts.contact_reason
      Day of Week: cc_contacts.contact_created_day_of_week
      Country: cc_contacts.country_iso
      Team Name: cc_contacts.team_name
      Is Deflected By Bot (Yes / No): cc_contacts.is_deflected_by_bot
    row: 85
    col: 0
    width: 24
    height: 6
  - title: "% Deflection Rate per Country"
    name: "% Deflection Rate per Country"
    model: flink_v3
    explore: cc_contacts
    type: looker_line
    fields: [cc_contacts.share_deflected_by_bot, cc_contacts.number_of_deflected_by_bot,
      cc_orders_hourly2.country_iso, cc_contacts.date]
    pivots: [cc_orders_hourly2.country_iso]
    filters:
      cc_orders_hourly2.country_iso: "-NULL"
    sorts: [cc_orders_hourly2.country_iso, cc_contacts.date]
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
    point_style: none
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    y_axes: [{label: '', orientation: left, series: [{axisId: cc_contacts.number_of_rated_contacts,
            id: cc_contacts.number_of_rated_contacts, name: "# contacts\
              \ with CSAT"}], showLabels: true, showValues: true, unpinAxis: false,
        tickDensity: default, tickDensityCustom: 5, type: linear}, {label: !!null '',
        orientation: right, series: [{axisId: cc_contacts.share_contacts_with_refunds,
            id: cc_contacts.share_contacts_with_refunds, name: "% contacts\
              \ with Refunds"}], showLabels: true, showValues: true, unpinAxis: false,
        tickDensity: default, tickDensityCustom: 5, type: linear}]
    series_types: {}
    series_colors:
      cc_contacts.number_of_rated_contacts: "#f98662"
      cc_contacts.share_rated_contacts: "#7a9fd1"
      cc_contacts.share_deflected_by_bot: "#f98662"
      cc_contacts.number_of_deflected_by_bot: "#7a9fd1"
      DE - cc_contacts.share_deflected_by_bot: "#7a9fd1"
      FR - cc_contacts.share_deflected_by_bot: "#f98662"
      NL - cc_contacts.share_deflected_by_bot: "#72D16D"
      AT - cc_contacts.share_deflected_by_bot: "#FFD95F"
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    show_row_numbers: true
    transpose: false
    truncate_text: true
    size_to_fit: true
    series_cell_visualizations:
      cc_contacts.share_deflected_by_bot:
        is_active: true
      cc_contacts.number_of_deflected_by_bot:
        is_active: true
    table_theme: white
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    hide_totals: false
    hide_row_totals: false
    hidden_fields: [cc_contacts.number_of_deflected_by_bot]
    note_state: collapsed
    note_display: hover
    note_text: Use Weekly or Monthly granularity to limit seasonality effects
    listen:
      Source Type: cc_contacts.source_type
      Date Granularity: cc_contacts.date_granularity
      Date: cc_contacts.contact_created_date
      Contact Reason: cc_contacts.contact_reason
      Day of Week: cc_contacts.contact_created_day_of_week
      Country: cc_contacts.country_iso
      Team Name: cc_contacts.team_name
      Is Deflected By Bot (Yes / No): cc_contacts.is_deflected_by_bot
    row: 117
    col: 0
    width: 24
    height: 9
  - title: Contact Rate per Country
    name: Contact Rate per Country
    model: flink_v3
    explore: cc_contacts
    type: looker_line
    fields: [cc_contacts.date, cc_orders_hourly2.contact_rate, cc_orders_hourly2.country_iso]
    pivots: [cc_orders_hourly2.country_iso]
    filters:
      cc_contacts.source_type: ''
      cc_orders_hourly2.country_iso: "-NULL"
    sorts: [cc_contacts.date, cc_orders_hourly2.country_iso]
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
    point_style: none
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: false
    interpolation: linear
    color_application:
      collection_id: product-custom-collection
      palette_id: product-custom-collection-categorical-0
      options:
        steps: 5
    y_axes: [{label: '', orientation: left, series: [{axisId: cc_contacts.number_of_rated_contacts,
            id: cc_contacts.number_of_rated_contacts, name: "# contacts\
              \ with CSAT"}], showLabels: true, showValues: true, unpinAxis: false,
        tickDensity: default, tickDensityCustom: 5, type: linear}, {label: !!null '',
        orientation: right, series: [{axisId: cc_contacts.share_contacts_with_refunds,
            id: cc_contacts.share_contacts_with_refunds, name: "% contacts\
              \ with Refunds"}], showLabels: true, showValues: true, unpinAxis: false,
        tickDensity: default, tickDensityCustom: 5, type: linear}]
    series_types:
      cc_contacts.number_of_contacts: column
    series_colors:
      cc_contacts.number_of_rated_contacts: "#f98662"
      cc_contacts.share_rated_contacts: "#7a9fd1"
      cc_contacts.share_deflected_by_bot: "#f98662"
      cc_contacts.number_of_deflected_by_bot: "#7a9fd1"
      cc_orders_hourly2.contact_rate: "#4276BE"
      cc_contacts.number_of_contacts: "#fccec0"
      FR - cc_orders_hourly2.contact_rate: "#f98662"
      DE - cc_orders_hourly2.contact_rate: "#7a9fd1"
      AT - cc_orders_hourly2.contact_rate: "#FFD95F"
      NL - cc_orders_hourly2.contact_rate: "#72D16D"
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    hidden_fields: []
    listen:
      Date Granularity: cc_contacts.date_granularity
      Date: cc_contacts.contact_created_date
      Contact Reason: cc_contacts.contact_reason
      Day of Week: cc_contacts.contact_created_day_of_week
      Country: cc_contacts.country_iso
      Team Name: cc_contacts.team_name
      Is Deflected By Bot (Yes / No): cc_contacts.is_deflected_by_bot
    row: 35
    col: 0
    width: 24
    height: 7
  - title: "% Deflection Rate per Contact Reason"
    name: "% Deflection Rate per Contact Reason"
    model: flink_v3
    explore: cc_contacts
    type: looker_bar
    fields: [cc_contacts.contact_reason, cc_contacts.share_deflected_by_bot]
    filters:
      cc_orders_hourly2.country_iso: "-NULL"
      cc_contacts.share_deflected_by_bot: ">0"
    sorts: [cc_contacts.share_deflected_by_bot desc]
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
    show_null_points: true
    interpolation: linear
    y_axes: [{label: '', orientation: left, series: [{axisId: cc_contacts.number_of_rated_contacts,
            id: cc_contacts.number_of_rated_contacts, name: "# contacts\
              \ with CSAT"}], showLabels: true, showValues: true, unpinAxis: false,
        tickDensity: default, tickDensityCustom: 5, type: linear}, {label: !!null '',
        orientation: right, series: [{axisId: cc_contacts.share_contacts_with_refunds,
            id: cc_contacts.share_contacts_with_refunds, name: "% contacts\
              \ with Refunds"}], showLabels: true, showValues: true, unpinAxis: false,
        tickDensity: default, tickDensityCustom: 5, type: linear}]
    series_types: {}
    series_colors:
      cc_contacts.number_of_rated_contacts: "#f98662"
      cc_contacts.share_rated_contacts: "#7a9fd1"
      cc_contacts.share_deflected_by_bot: "#f98662"
      cc_contacts.number_of_deflected_by_bot: "#7a9fd1"
      DE - cc_contacts.share_deflected_by_bot: "#7a9fd1"
      FR - cc_contacts.share_deflected_by_bot: "#f98662"
      NL - cc_contacts.share_deflected_by_bot: "#72D16D"
      AT - cc_contacts.share_deflected_by_bot: "#FFD95F"
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    show_row_numbers: true
    transpose: false
    truncate_text: true
    size_to_fit: true
    series_cell_visualizations:
      cc_contacts.share_deflected_by_bot:
        is_active: true
      cc_contacts.number_of_deflected_by_bot:
        is_active: true
    table_theme: white
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 1
    hide_totals: false
    hide_row_totals: false
    hidden_fields: []
    note_state: collapsed
    note_display: hover
    note_text: Use Weekly or Monthly granularity to limit seasonality effects
    listen:
      Source Type: cc_contacts.source_type
      Date Granularity: cc_contacts.date_granularity
      Date: cc_contacts.contact_created_date
      Contact Reason: cc_contacts.contact_reason
      Day of Week: cc_contacts.contact_created_day_of_week
      Country: cc_contacts.country_iso
      Team Name: cc_contacts.team_name
      Is Deflected By Bot (Yes / No): cc_contacts.is_deflected_by_bot
    row: 126
    col: 0
    width: 24
    height: 9
  - name: " (8)"
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: ' <font size = "5"><center><font color="4276BE"><b>Refunds</b></font>
      </center></font>'
    row: 135
    col: 0
    width: 24
    height: 2
  - title: Refunded Orders
    name: Refunded Orders
    model: flink_v3
    explore: cc_contacts
    type: looker_column
    fields: [cc_contacts.date, cc_orders_hourly2.sum_number_of_refunded_orders,
      cc_orders_hourly2.cc_refunded_order_rate]
    filters: {}
    sorts: [cc_contacts.date]
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
    y_axes: [{label: '', orientation: left, series: [{axisId: cc_orders_hourly2.sum_number_of_refunded_orders,
            id: cc_orders_hourly2.sum_number_of_refunded_orders, name: "# CC Refunded\
              \ Orders"}], showLabels: true, showValues: true, unpinAxis: false, tickDensity: default,
        type: linear}, {label: '', orientation: right, series: [{axisId: cc_orders_hourly2.cc_refunded_order_rate,
            id: cc_orders_hourly2.cc_refunded_order_rate, name: "% Refunded Orders"}],
        showLabels: true, showValues: true, unpinAxis: false, tickDensity: default,
        type: linear}]
    series_types:
      cc_contacts.share_rated_contacts: line
      cc_contacts.share_deflected_by_bot: line
      cc_orders_hourly2.cc_refunded_order_rate: line
    series_colors:
      cc_contacts.number_of_rated_contacts: "#f98662"
      cc_contacts.share_rated_contacts: "#7a9fd1"
      cc_contacts.share_deflected_by_bot: "#f98662"
      cc_contacts.number_of_deflected_by_bot: "#c6d5eb"
      cc_orders_hourly2.sum_number_of_refunded_orders: "#c6d5eb"
      cc_orders_hourly2.cc_refunded_order_rate: "#4276BE"
    defaults_version: 1
    hidden_fields: []
    listen:
      Source Type: cc_contacts.source_type
      Date Granularity: cc_contacts.date_granularity
      Date: cc_contacts.contact_created_date
      Contact Reason: cc_contacts.contact_reason
      Day of Week: cc_contacts.contact_created_day_of_week
      Country: cc_contacts.country_iso
      Team Name: cc_contacts.team_name
      Is Deflected By Bot (Yes / No): cc_contacts.is_deflected_by_bot
    row: 137
    col: 0
    width: 12
    height: 8
  - title: CC Discounted Orders
    name: CC Discounted Orders
    model: flink_v3
    explore: cc_contacts
    type: looker_column
    fields: [cc_contacts.date, cc_orders_hourly2.sum_number_of_cc_discounted_orders,
      cc_orders_hourly2.cc_discounted_order_rate]
    filters: {}
    sorts: [cc_contacts.date]
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
    y_axes: [{label: '', orientation: left, series: [{axisId: cc_orders_hourly2.sum_number_of_cc_discounted_orders,
            id: cc_orders_hourly2.sum_number_of_cc_discounted_orders, name: "# CC Discounted\
              \ Orders"}], showLabels: true, showValues: true, unpinAxis: false, tickDensity: default,
        type: linear}, {label: '', orientation: right, series: [{axisId: cc_orders_hourly2.cc_discounted_order_rate,
            id: cc_orders_hourly2.cc_discounted_order_rate, name: "% CC Discounted\
              \ Orders"}], showLabels: true, showValues: true, unpinAxis: false, tickDensity: default,
        type: linear}]
    series_types:
      cc_contacts.share_rated_contacts: line
      cc_contacts.share_deflected_by_bot: line
      cc_orders_hourly2.cc_refunded_order_rate: line
      cc_orders_hourly2.cc_discounted_order_rate: line
    series_colors:
      cc_contacts.number_of_rated_contacts: "#f98662"
      cc_contacts.share_rated_contacts: "#7a9fd1"
      cc_contacts.share_deflected_by_bot: "#f98662"
      cc_contacts.number_of_deflected_by_bot: "#c6d5eb"
      cc_orders_hourly2.sum_number_of_refunded_orders: "#c6d5eb"
      cc_orders_hourly2.cc_refunded_order_rate: "#4276BE"
      cc_orders_hourly2.cc_discounted_order_rate: "#f98662"
      cc_orders_hourly2.sum_number_of_cc_discounted_orders: "#fccec0"
    defaults_version: 1
    hidden_fields: []
    note_state: collapsed
    note_display: hover
    note_text: 'The date represents the moment where the CC discount was used, not
      the moment where it was issued by the agent. '
    listen:
      Source Type: cc_contacts.source_type
      Date Granularity: cc_contacts.date_granularity
      Date: cc_contacts.contact_created_date
      Contact Reason: cc_contacts.contact_reason
      Day of Week: cc_contacts.contact_created_day_of_week
      Country: cc_contacts.country_iso
      Team Name: cc_contacts.team_name
      Is Deflected By Bot (Yes / No): cc_contacts.is_deflected_by_bot
    row: 154
    col: 0
    width: 12
    height: 8
  - title: "% Contact Rate over Time Without Deflection"
    name: "% Contact Rate over Time Without Deflection"
    model: flink_v3
    explore: cc_contacts
    type: looker_line
    fields: [cc_contacts.date, cc_orders_hourly2.contact_rate, cc_contacts.number_of_contacts]
    filters: {}
    sorts: [cc_contacts.date]
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
    point_style: none
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    color_application:
      collection_id: product-custom-collection
      palette_id: product-custom-collection-categorical-0
      options:
        steps: 5
    y_axes: [{label: '', orientation: left, series: [{axisId: cc_contacts.number_of_rated_contacts,
            id: cc_contacts.number_of_rated_contacts, name: "# contacts\
              \ with CSAT"}], showLabels: true, showValues: true, unpinAxis: false,
        tickDensity: default, tickDensityCustom: 5, type: linear}, {label: !!null '',
        orientation: right, series: [{axisId: cc_contacts.share_contacts_with_refunds,
            id: cc_contacts.share_contacts_with_refunds, name: "% contacts\
              \ with Refunds"}], showLabels: true, showValues: true, unpinAxis: false,
        tickDensity: default, tickDensityCustom: 5, type: linear}]
    series_types:
      cc_contacts.number_of_contacts: column
    series_colors:
      cc_contacts.number_of_rated_contacts: "#f98662"
      cc_contacts.share_rated_contacts: "#7a9fd1"
      cc_contacts.share_deflected_by_bot: "#f98662"
      cc_contacts.number_of_deflected_by_bot: "#7a9fd1"
      cc_orders_hourly2.contact_rate: "#4276BE"
      cc_contacts.number_of_contacts: "#fccec0"
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    hidden_fields: []
    note_state: collapsed
    note_display: hover
    note_text: "Contact Rate = # Contacts Started / # Successful Orders. Excluding\
      \ Contacts Deflected by Bot \n"
    listen:
      Source Type: cc_contacts.source_type
      Date Granularity: cc_contacts.date_granularity
      Date: cc_contacts.contact_created_date
      Contact Reason: cc_contacts.contact_reason
      Day of Week: cc_contacts.contact_created_day_of_week
      Country: cc_contacts.country_iso
      Team Name: cc_contacts.team_name
      Is Deflected By Bot (Yes / No): cc_contacts.is_deflected_by_bot
    row: 27
    col: 0
    width: 24
    height: 8
  - title: Refunds > 5euros
    name: Refunds > 5euros
    model: flink_v3
    explore: cc_contacts
    type: looker_line
    fields: [cc_contacts.date, cc_orders_hourly2.cc_refunded_order_over_5_contact_rate,
      cc_orders_hourly2.cc_refunded_order_over_5_rate, cc_orders_hourly2.sum_number_of_refunded_orders_over_5]
    filters: {}
    sorts: [cc_contacts.date]
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
    point_style: none
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    y_axes: [{label: '', orientation: left, series: [{axisId: cc_orders_hourly2.cc_refunded_order_over_5_contact_rate,
            id: cc_orders_hourly2.cc_refunded_order_over_5_contact_rate, name: "% Refunded\
              \ Orders over 5euros / Contacts"}, {axisId: cc_orders_hourly2.cc_refunded_order_over_5_rate,
            id: cc_orders_hourly2.cc_refunded_order_over_5_rate, name: "% Refunded\
              \ Orders over 5euros / Refunded Orders"}], showLabels: true, showValues: true,
        unpinAxis: false, tickDensity: default, type: linear}, {label: '', orientation: right,
        series: [{axisId: cc_orders_hourly2.sum_number_of_refunded_orders_over_5, id: cc_orders_hourly2.sum_number_of_refunded_orders_over_5,
            name: "# CC Refunded Orders >5 euros"}], showLabels: true, showValues: true,
        unpinAxis: false, tickDensity: default, type: linear}]
    series_types:
      cc_orders_hourly2.sum_number_of_refunded_orders_over_5: column
    series_colors:
      cc_contacts.number_of_rated_contacts: "#f98662"
      cc_contacts.share_rated_contacts: "#7a9fd1"
      cc_contacts.share_deflected_by_bot: "#f98662"
      cc_contacts.number_of_deflected_by_bot: "#c6d5eb"
      cc_orders_hourly2.sum_number_of_refunded_orders: "#c6d5eb"
      cc_orders_hourly2.cc_refunded_order_rate: "#4276BE"
      cc_orders_hourly2.cc_refunded_order_over_5_contact_rate: "#4276BE"
      cc_orders_hourly2.cc_refunded_order_over_5_rate: "#f98662"
      cc_orders_hourly2.sum_number_of_refunded_orders_over_5: "#c6d5eb"
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    hidden_fields: []
    listen:
      Source Type: cc_contacts.source_type
      Date Granularity: cc_contacts.date_granularity
      Date: cc_contacts.contact_created_date
      Contact Reason: cc_contacts.contact_reason
      Day of Week: cc_contacts.contact_created_day_of_week
      Country: cc_contacts.country_iso
      Team Name: cc_contacts.team_name
      Is Deflected By Bot (Yes / No): cc_contacts.is_deflected_by_bot
    row: 137
    col: 12
    width: 12
    height: 8
  - name: " (9)"
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: ' <font size = "5"><center><font color="4276BE"><b>Discounts</b></font>
      </center></font>'
    row: 152
    col: 0
    width: 24
    height: 2
  - title: Discount Type Split
    name: Discount Type Split
    model: flink_v3
    explore: cc_contacts
    type: looker_line
    fields: [cc_contacts.date, cc_orders_hourly2.cc_discounted_orders_5_euros,
      cc_orders_hourly2.cc_discounted_orders_free_delivery]
    filters: {}
    sorts: [cc_contacts.date]
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
    point_style: none
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    y_axes: [{label: '', orientation: left, series: [{axisId: cc_orders_hourly2.cc_discounted_orders_5_euros,
            id: cc_orders_hourly2.cc_discounted_orders_5_euros, name: "% 5euros Discounts"},
          {axisId: cc_orders_hourly2.cc_discounted_orders_free_delivery, id: cc_orders_hourly2.cc_discounted_orders_free_delivery,
            name: "% Free Delivery Discounts"}], showLabels: true, showValues: true,
        unpinAxis: false, tickDensity: default, type: linear}]
    series_types: {}
    series_colors:
      cc_contacts.number_of_rated_contacts: "#f98662"
      cc_contacts.share_rated_contacts: "#7a9fd1"
      cc_contacts.share_deflected_by_bot: "#f98662"
      cc_contacts.number_of_deflected_by_bot: "#c6d5eb"
      cc_orders_hourly2.sum_number_of_refunded_orders: "#c6d5eb"
      cc_orders_hourly2.cc_refunded_order_rate: "#4276BE"
      cc_orders_hourly2.cc_discounted_order_rate: "#f98662"
      cc_orders_hourly2.sum_number_of_cc_discounted_orders: "#fccec0"
      cc_orders_hourly2.cc_discounted_orders_5_euros: "#f98662"
      cc_orders_hourly2.cc_discounted_orders_free_delivery: "#4276BE"
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    hidden_fields: []
    listen:
      Source Type: cc_contacts.source_type
      Date Granularity: cc_contacts.date_granularity
      Date: cc_contacts.contact_created_date
      Contact Reason: cc_contacts.contact_reason
      Day of Week: cc_contacts.contact_created_day_of_week
      Country: cc_contacts.country_iso
      Team Name: cc_contacts.team_name
      Is Deflected By Bot (Yes / No): cc_contacts.is_deflected_by_bot
    row: 154
    col: 12
    width: 12
    height: 8
  - title: 'AVG Discount value per Contact '
    name: 'AVG Discount value per Contact '
    model: flink_v3
    explore: cc_contacts
    type: looker_line
    fields: [cc_contacts.date, cc_orders_hourly2.avg_discount_value]
    filters: {}
    sorts: [cc_contacts.date]
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
    point_style: none
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    y_axes: [{label: '', orientation: left, series: [{axisId: cc_orders_hourly2.cc_discounted_orders_5_euros,
            id: cc_orders_hourly2.cc_discounted_orders_5_euros, name: "% 5euros Discounts"},
          {axisId: cc_orders_hourly2.cc_discounted_orders_free_delivery, id: cc_orders_hourly2.cc_discounted_orders_free_delivery,
            name: "% Free Delivery Discounts"}], showLabels: true, showValues: true,
        unpinAxis: false, tickDensity: default, type: linear}]
    series_types: {}
    series_colors:
      cc_contacts.number_of_rated_contacts: "#f98662"
      cc_contacts.share_rated_contacts: "#7a9fd1"
      cc_contacts.share_deflected_by_bot: "#f98662"
      cc_contacts.number_of_deflected_by_bot: "#c6d5eb"
      cc_orders_hourly2.sum_number_of_refunded_orders: "#c6d5eb"
      cc_orders_hourly2.cc_refunded_order_rate: "#4276BE"
      cc_orders_hourly2.cc_discounted_order_rate: "#f98662"
      cc_orders_hourly2.sum_number_of_cc_discounted_orders: "#fccec0"
      cc_orders_hourly2.cc_discounted_orders_5_euros: "#f98662"
      cc_orders_hourly2.cc_discounted_orders_free_delivery: "#4276BE"
      cc_orders_hourly2.avg_discount_value: "#f98662"
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    hidden_fields: []
    listen:
      Source Type: cc_contacts.source_type
      Date Granularity: cc_contacts.date_granularity
      Date: cc_contacts.contact_created_date
      Contact Reason: cc_contacts.contact_reason
      Day of Week: cc_contacts.contact_created_day_of_week
      Country: cc_contacts.country_iso
      Team Name: cc_contacts.team_name
      Is Deflected By Bot (Yes / No): cc_contacts.is_deflected_by_bot
    row: 162
    col: 0
    width: 24
    height: 8
  - title: AVG Discount value per Contact  - Country Split
    name: AVG Discount value per Contact  - Country Split
    model: flink_v3
    explore: cc_contacts
    type: looker_line
    fields: [cc_contacts.date, cc_orders_hourly2.avg_discount_value, cc_orders_hourly2.country_iso]
    pivots: [cc_orders_hourly2.country_iso]
    filters:
      cc_orders_hourly2.country_iso: ''
    sorts: [cc_contacts.date, cc_orders_hourly2.country_iso]
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
    point_style: none
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    y_axes: [{label: '', orientation: left, series: [{axisId: cc_orders_hourly2.cc_discounted_orders_5_euros,
            id: cc_orders_hourly2.cc_discounted_orders_5_euros, name: "% 5euros Discounts"},
          {axisId: cc_orders_hourly2.cc_discounted_orders_free_delivery, id: cc_orders_hourly2.cc_discounted_orders_free_delivery,
            name: "% Free Delivery Discounts"}], showLabels: true, showValues: true,
        unpinAxis: false, tickDensity: default, type: linear}]
    series_types: {}
    series_colors:
      cc_contacts.number_of_rated_contacts: "#f98662"
      cc_contacts.share_rated_contacts: "#7a9fd1"
      cc_contacts.share_deflected_by_bot: "#f98662"
      cc_contacts.number_of_deflected_by_bot: "#c6d5eb"
      cc_orders_hourly2.sum_number_of_refunded_orders: "#c6d5eb"
      cc_orders_hourly2.cc_refunded_order_rate: "#4276BE"
      cc_orders_hourly2.cc_discounted_order_rate: "#f98662"
      cc_orders_hourly2.sum_number_of_cc_discounted_orders: "#fccec0"
      cc_orders_hourly2.cc_discounted_orders_5_euros: "#f98662"
      cc_orders_hourly2.cc_discounted_orders_free_delivery: "#4276BE"
      cc_orders_hourly2.avg_discount_value: "#f98662"
      AT - cc_orders_hourly2.avg_discount_value: "#4276BE"
      DE - cc_orders_hourly2.avg_discount_value: "#f98662"
      FR - cc_orders_hourly2.avg_discount_value: "#FFD95F"
      NL - cc_orders_hourly2.avg_discount_value: "#72D16D"
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    hidden_fields: []
    listen:
      Source Type: cc_contacts.source_type
      Date Granularity: cc_contacts.date_granularity
      Date: cc_contacts.contact_created_date
      Contact Reason: cc_contacts.contact_reason
      Day of Week: cc_contacts.contact_created_day_of_week
      Country: cc_contacts.country_iso
      Team Name: cc_contacts.team_name
      Is Deflected By Bot (Yes / No): cc_contacts.is_deflected_by_bot
    row: 170
    col: 0
    width: 24
    height: 8
  - title: Refunds > 5euros - Country Split
    name: Refunds > 5euros - Country Split
    model: flink_v3
    explore: cc_contacts
    type: looker_line
    fields: [cc_contacts.date, cc_orders_hourly2.cc_refunded_order_over_5_rate,
      cc_orders_hourly2.country_iso]
    pivots: [cc_orders_hourly2.country_iso]
    filters: {}
    sorts: [cc_contacts.date, cc_orders_hourly2.country_iso]
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
    point_style: none
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    y_axes: [{label: '', orientation: left, series: [{axisId: cc_orders_hourly2.cc_refunded_order_over_5_contact_rate,
            id: cc_orders_hourly2.cc_refunded_order_over_5_contact_rate, name: "% Refunded\
              \ Orders over 5euros / Contacts"}, {axisId: cc_orders_hourly2.cc_refunded_order_over_5_rate,
            id: cc_orders_hourly2.cc_refunded_order_over_5_rate, name: "% Refunded\
              \ Orders over 5euros / Refunded Orders"}], showLabels: true, showValues: true,
        unpinAxis: false, tickDensity: default, type: linear}, {label: '', orientation: right,
        series: [{axisId: cc_orders_hourly2.sum_number_of_refunded_orders_over_5, id: cc_orders_hourly2.sum_number_of_refunded_orders_over_5,
            name: "# CC Refunded Orders >5 euros"}], showLabels: true, showValues: true,
        unpinAxis: false, tickDensity: default, type: linear}]
    series_types:
      cc_orders_hourly2.sum_number_of_refunded_orders_over_5: column
    series_colors:
      cc_contacts.number_of_rated_contacts: "#f98662"
      cc_contacts.share_rated_contacts: "#7a9fd1"
      cc_contacts.share_deflected_by_bot: "#f98662"
      cc_contacts.number_of_deflected_by_bot: "#c6d5eb"
      cc_orders_hourly2.sum_number_of_refunded_orders: "#c6d5eb"
      cc_orders_hourly2.cc_refunded_order_rate: "#4276BE"
      cc_orders_hourly2.cc_refunded_order_over_5_contact_rate: "#4276BE"
      cc_orders_hourly2.cc_refunded_order_over_5_rate: "#f98662"
      cc_orders_hourly2.sum_number_of_refunded_orders_over_5: "#c6d5eb"
      AT - cc_orders_hourly2.cc_refunded_order_over_5_rate: "#f98662"
      DE - cc_orders_hourly2.cc_refunded_order_over_5_rate: "#4276BE"
      FR - cc_orders_hourly2.cc_refunded_order_over_5_rate: "#FFD95F"
      NL - cc_orders_hourly2.cc_refunded_order_over_5_rate: "#72D16D"
      cc_orders_hourly2.country_iso___null - cc_orders_hourly2.cc_refunded_order_over_5_rate: "#fde6df"
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    hidden_fields: []
    listen:
      Source Type: cc_contacts.source_type
      Date Granularity: cc_contacts.date_granularity
      Date: cc_contacts.contact_created_date
      Contact Reason: cc_contacts.contact_reason
      Day of Week: cc_contacts.contact_created_day_of_week
      Country: cc_contacts.country_iso
      Team Name: cc_contacts.team_name
      Is Deflected By Bot (Yes / No): cc_contacts.is_deflected_by_bot
    row: 145
    col: 0
    width: 24
    height: 7
  filters:
  - name: Country
    title: Country
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: button_group
      display: inline
      options:
      - AT
      - DE
      - FR
      - NL
    model: flink_v3
    explore: cc_contacts
    listens_to_filters: []
    field: cc_contacts.country_iso
  - name: Date Granularity
    title: Date Granularity
    type: field_filter
    default_value: Day
    allow_multiple_values: true
    required: false
    ui_config:
      type: radio_buttons
      display: inline
      options:
      - Day
      - Week
      - Month
    model: flink_v3
    explore: cc_contacts
    listens_to_filters: []
    field: cc_contacts.date_granularity
  - name: Source Type
    title: Source Type
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: button_group
      display: popover
      options: []
    model: flink_v3
    explore: cc_contacts
    listens_to_filters: []
    field: cc_contacts.source_type
  - name: Date
    title: Date
    type: field_filter
    default_value: 60 day ago for 60 day
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
      options: []
    model: flink_v3
    explore: cc_contacts
    listens_to_filters: []
    field: cc_contacts.contact_created_date
  - name: Day of Week
    title: Day of Week
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: popover
      options: []
    model: flink_v3
    explore: cc_contacts
    listens_to_filters: []
    field: cc_contacts.contact_created_day_of_week
  - name: Team Name
    title: Team Name
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: checkboxes
      display: popover
      options:
      - DE Pharmacy
      - DE External
      - Germany & Austria
      - Netherlands
      - NL External
      - France
      - GDPR Legal
    model: flink_v3
    explore: cc_contacts
    listens_to_filters: []
    field: cc_contacts.team_name
  - name: Contact Reason
    title: Contact Reason
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: popover
      options: []
    model: flink_v3
    explore: cc_contacts
    listens_to_filters: []
    field: cc_contacts.contact_reason
  - name: Is Deflected By Bot (Yes / No)
    title: Is Deflected By Bot (Yes / No)
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: radio_buttons
      display: inline
      options: []
    model: flink_v3
    explore: cc_contacts
    listens_to_filters: []
    field: cc_contacts.is_deflected_by_bot
