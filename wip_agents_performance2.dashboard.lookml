- dashboard: wip_agents_performance2
  title: "[WIP] Agents Performance"
  layout: newspaper
  preferred_viewer: dashboards-next
  description: ''
  elements:
  - title: Agents Performance over Time
    name: Agents Performance over Time
    model: flink_v3
    explore: cc_contacts
    type: looker_grid
    fields: [cc_contacts.number_of_contacts, cc_contact_agents.team_name,
      cc_contact_agents.agent_name, cc_contact_agents.agent_email, cc_contacts.date,
      cc_contacts.avg_csat, cc_contacts.median_time_last_close_minutes]
    pivots: [cc_contacts.date]
    filters:
      cc_contacts.source_type: ''
      cc_contacts.contact_reason: ''
      cc_contacts.team_name: ''
      cc_contacts.contact_created_day_of_week: ''
      cc_contact_agents.agent_id: NOT NULL
      cc_contact_agents.agent_email: "-NULL"
    sorts: [cc_contacts.date, cc_contact_agents.team_name, cc_contact_agents.agent_name]
    limit: 500
    column_limit: 50
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
    color_application:
      collection_id: product-custom-collection
      palette_id: product-custom-collection-categorical-0
      options:
        steps: 5
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    series_column_widths:
      2022-02-21_cc_contacts.number_of_contacts: 92
    series_cell_visualizations:
      cc_contacts.number_of_contacts:
        is_active: true
      cc_contacts.avg_csat:
        is_active: true
        palette:
          palette_id: dc575c04-afe6-30ce-b1fc-88010d5c0426
          collection_id: product-custom-collection
          custom_colors:
          - "#f2180f"
          - "#ffffff"
          - "#b1e84d"
      cc_contacts.median_time_last_close_minutes:
        is_active: true
        palette:
          palette_id: 5bf04137-d88d-e1a9-586e-5fb6134de927
          collection_id: product-custom-collection
          custom_colors:
          - "#b1e84d"
          - "#ffffff"
          - "#f2180f"
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
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    y_axes: [{label: '', orientation: left, series: [{axisId: cc_contacts.number_of_rated_contacts,
            id: cc_contacts.number_of_rated_contacts, name: "# Contacts\
              \ with CSAT"}], showLabels: true, showValues: true, unpinAxis: false,
        tickDensity: default, tickDensityCustom: 5, type: linear}, {label: !!null '',
        orientation: right, series: [{axisId: cc_contacts.share_contacts_with_refunds,
            id: cc_contacts.share_contacts_with_refunds, name: "% Contacts\
              \ with Refunds"}], showLabels: true, showValues: true, unpinAxis: false,
        tickDensity: default, tickDensityCustom: 5, type: linear}]
    series_types: {}
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
    listen:
      Team Name: cc_contact_agents.team_name
      Agent Name: cc_contact_agents.agent_name
      Country Iso: cc_contacts.country_iso
      Date: cc_contacts.contact_created_date
      Date Granularity: cc_contacts.date_granularity
    row: 20
    col: 0
    width: 24
    height: 9
  - title: Last Week Agents Performance
    name: Last Week Agents Performance
    model: flink_v3
    explore: cc_contacts
    type: looker_grid
    fields: [cc_contact_agents.team_name, cc_contact_agents.agent_name,
      cc_contact_agents.agent_email, cc_contacts.number_of_contacts,
      cc_contacts.avg_csat, cc_contacts.median_time_last_close_minutes,
      cc_contacts.date, cc_contacts.avg_number_of_contacts_hourly]
    pivots: [cc_contacts.date]
    filters:
      cc_contacts.source_type: ''
      cc_contacts.date_granularity: Week
      cc_contacts.contact_created_date: 1 weeks ago for 1 weeks
      cc_contacts.contact_reason: ''
      cc_contacts.team_name: ''
      cc_contacts.contact_created_day_of_week: ''
      cc_contact_agents.contact_created_timestamp_week: 1 weeks ago for
        1 weeks
      cc_contact_agents.agent_id: NOT NULL
    sorts: [cc_contacts.date, cc_contact_agents.team_name, cc_contacts.number_of_contacts
        desc 0]
    limit: 500
    column_limit: 50
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
    color_application:
      collection_id: product-custom-collection
      palette_id: product-custom-collection-categorical-0
      options:
        steps: 5
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    series_column_widths:
      2022-02-21_cc_contacts.number_of_contacts: 92
    series_cell_visualizations:
      cc_contacts.number_of_contacts:
        is_active: true
      cc_contacts.avg_csat:
        is_active: true
        palette:
          palette_id: dc575c04-afe6-30ce-b1fc-88010d5c0426
          collection_id: product-custom-collection
          custom_colors:
          - "#f2180f"
          - "#ffffff"
          - "#b1e84d"
      cc_contacts.median_time_last_close_minutes:
        is_active: true
        palette:
          palette_id: 5bf04137-d88d-e1a9-586e-5fb6134de927
          collection_id: product-custom-collection
          custom_colors:
          - "#b1e84d"
          - "#ffffff"
          - "#f2180f"
      cc_contacts.avg_number_of_contacts_hourly:
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
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    y_axes: [{label: '', orientation: left, series: [{axisId: cc_contacts.number_of_rated_contacts,
            id: cc_contacts.number_of_rated_contacts, name: "# Contacts\
              \ with CSAT"}], showLabels: true, showValues: true, unpinAxis: false,
        tickDensity: default, tickDensityCustom: 5, type: linear}, {label: !!null '',
        orientation: right, series: [{axisId: cc_contacts.share_contacts_with_refunds,
            id: cc_contacts.share_contacts_with_refunds, name: "% Contacts\
              \ with Refunds"}], showLabels: true, showValues: true, unpinAxis: false,
        tickDensity: default, tickDensityCustom: 5, type: linear}]
    series_types: {}
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
    listen:
      Team Name: cc_contact_agents.team_name
      Agent Name: cc_contact_agents.agent_name
      Country Iso: cc_contacts.country_iso
    row: 7
    col: 0
    width: 24
    height: 13
  - name: ''
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: '<img src="https://i.imgur.com/KcWQwrB.png" width="70%"> '
    row: 0
    col: 0
    width: 7
    height: 6
  - name: " (2)"
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: "\n\n### Overview\n\nThis report monitors performance of the **customer\
      \ care agents**.\n\n### Structure\n- **Last Week Agents Performance**\n- **Agents\
      \ Performance over Time**\n\n### Note\n- In case 2 (or more) agents wrote in\
      \ the same contact, the contact's statistics are attributed to both\
      \ (or all) of them. "
    row: 0
    col: 7
    width: 17
    height: 7
  filters:
  - name: Country Iso
    title: Country Iso
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: button_group
      display: inline
      options:
      - NL
      - AT
      - DE
      - FR
    model: flink_v3
    explore: cc_contacts
    listens_to_filters: []
    field: cc_contacts.country_iso
  - name: Date Granularity
    title: Date Granularity
    type: field_filter
    default_value: Week
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
  - name: Date
    title: Date
    type: field_filter
    default_value: 4 week ago for 4 week
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
  - name: Team Name
    title: Team Name
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: checkboxes
      display: popover
      options: []
    model: flink_v3
    explore: cc_contacts
    listens_to_filters: []
    field: cc_contact_agents.team_name
  - name: Agent Name
    title: Agent Name
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
      options: []
    model: flink_v3
    explore: cc_contacts
    listens_to_filters: [Team Name]
    field: cc_contact_agents.agent_name
