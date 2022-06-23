- dashboard: work_in_progress__do_not_use_rider_growth_report_mig
  title: "[WORK IN PROGRESS - DO NOT USE] Rider Growth Report"
  layout: newspaper
  preferred_viewer: dashboards-next
  elements:
  - title: Performance Tabular View
    name: Performance Tabular View
    model: flink_v3
    explore: hiring_funnel_performance_summary
    type: looker_grid
    fields: [hiring_funnel_performance_summary.date_, hiring_funnel_performance_summary.date_date,
      hiring_funnel_performance_summary.number_of_hires, hiring_funnel_performance_summary.number_of_hires_with_first_shift_completed,
      hiring_funnel_performance_summary.avg_days_to_hire, hiring_funnel_performance_summary.avg_days_to_first_shift,
      hiring_funnel_performance_summary.number_of_leads, hiring_funnel_performance_summary.total_spend]
    filters: {}
    sorts: [hiring_funnel_performance_summary.date_ desc]
    subtotals: [hiring_funnel_performance_summary.date_]
    limit: 5000
    column_limit: 50
    dynamic_fields: [{category: table_calculation, expression: "${hiring_funnel_performance_summary.total_spend}\
          \ / ${hiring_funnel_performance_summary.number_of_leads}", label: CPL, value_format: !!null '',
        value_format_name: euro_accounting_1_precision, _kind_hint: measure, table_calculation: cpl,
        _type_hint: number}, {category: table_calculation, expression: "${hiring_funnel_performance_summary.total_spend}\
          \ / ${hiring_funnel_performance_summary.number_of_hires}", label: CPH, value_format: !!null '',
        value_format_name: euro_accounting_1_precision, _kind_hint: measure, table_calculation: cph,
        _type_hint: number}, {category: table_calculation, expression: "${hiring_funnel_performance_summary.number_of_hires}\
          \ / ${hiring_funnel_performance_summary.number_of_leads}", label: CVR, value_format: !!null '',
        value_format_name: percent_0, _kind_hint: measure, table_calculation: cvr,
        _type_hint: number}]
    show_view_names: false
    show_row_numbers: false
    transpose: false
    truncate_text: false
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
    series_labels:
      hiring_funnel_performance_summary.date_date: Date
      hiring_funnel_performance_summary.number_of_hires: Hires
      hiring_funnel_performance_summary.number_of_hires_with_first_shift_completed: Hired & Completed
        1st Shift
      hiring_funnel_performance_summary.avg_days_to_hire: Avg. Time to Hire (days)
      hiring_funnel_performance_summary.avg_days_to_first_shift: Avg. Time to 1st Shift
        (days)
      hiring_funnel_performance_summary.number_of_leads: Leads
      hiring_funnel_performance_summary.total_spend: Costs
    series_cell_visualizations:
      hiring_funnel_performance_summary.number_of_hires:
        is_active: true
    series_collapsed:
      hiring_funnel_performance_summary.date_week: true
      hiring_funnel_performance_summary.date_: true
      hiring_funnel_performance_summary.country: true
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
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    series_types: {}
    listen:
      Country: hiring_funnel_performance_summary.country
      City: hiring_funnel_performance_summary.city
      Position: hiring_funnel_performance_summary.position
      Date Granularity: hiring_funnel_performance_summary.date_granularity
      Date: hiring_funnel_performance_summary.date_date
    row: 6
    col: 0
    width: 24
    height: 12
  - name: Observations
    type: text
    title_text: Observations
    subtitle_text: ''
    body_text: "## Recruitics marketing spend is missing\n\n## Spend does not match\
      \ 100%. Why?\n- City codes from campaigns and ad names do not match with city\
      \ codes in the hub metadata table\n- Campaign or ad names missing city or country\
      \ codes from campaign and ad names. \n"
    row: 0
    col: 0
    width: 24
    height: 6
  - title: Hires (WoW)
    name: Hires (WoW)
    model: flink_v3
    explore: hiring_funnel_performance_summary
    type: looker_column
    fields: [hiring_funnel_performance_summary.date_, hiring_funnel_performance_summary.number_of_hires]
    filters: {}
    sorts: [hiring_funnel_performance_summary.date_]
    limit: 500
    dynamic_fields: [{category: table_calculation, expression: "(${hiring_funnel_performance_summary.number_of_hires}\
          \ - offset(${hiring_funnel_performance_summary.number_of_hires}, -1)) / offset(${hiring_funnel_performance_summary.number_of_hires},\
          \ -1)", label: WoW, value_format: '"▲  "+0%; "▼  "-0%; 0', value_format_name: !!null '',
        _kind_hint: measure, table_calculation: wow, _type_hint: number}]
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
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    y_axes: [{label: '', orientation: left, series: [{axisId: hiring_funnel_performance_summary.number_of_hires,
            id: hiring_funnel_performance_summary.number_of_hires, name: Number of
              Hires}], showLabels: true, showValues: true, unpinAxis: false, tickDensity: default,
        tickDensityCustom: 5, type: linear}, {label: !!null '', orientation: right,
        series: [{axisId: wow, id: wow, name: WoW}], showLabels: true, showValues: true,
        unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear}]
    x_axis_label: Hire Week
    series_types:
      wow: scatter
    defaults_version: 1
    listen:
      Country: hiring_funnel_performance_summary.country
      City: hiring_funnel_performance_summary.city
      Position: hiring_funnel_performance_summary.position
      Date Granularity: hiring_funnel_performance_summary.date_granularity
      Date: hiring_funnel_performance_summary.date_date
    row: 38
    col: 0
    width: 12
    height: 6
  - title: Cost Channel Breakdown
    name: Cost Channel Breakdown
    model: flink_v3
    explore: hiring_funnel_performance_summary
    type: looker_column
    fields: [hiring_funnel_performance_summary.date_, hiring_funnel_performance_summary.channel,
      hiring_funnel_performance_summary.total_spend, hiring_funnel_performance_summary.number_of_leads]
    pivots: [hiring_funnel_performance_summary.channel]
    filters: {}
    sorts: [hiring_funnel_performance_summary.channel, hiring_funnel_performance_summary.date_]
    limit: 500
    row_total: right
    dynamic_fields: [{category: table_calculation, expression: "${hiring_funnel_performance_summary.total_spend:row_total}\
          \ / ${hiring_funnel_performance_summary.number_of_leads:row_total}", label: CPL,
        value_format: !!null '', value_format_name: euro_accounting_1_precision, _kind_hint: supermeasure,
        table_calculation: cpl, _type_hint: number}]
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
    ordering: desc
    show_null_labels: false
    show_totals_labels: true
    show_silhouette: false
    totals_color: "#808080"
    y_axes: [{label: '', orientation: left, series: [{axisId: Facebook - hiring_funnel_performance_summary.total_spend,
            id: Facebook - hiring_funnel_performance_summary.total_spend, name: Facebook
              - Hiring Funnel Performance Summary Total Spend}, {axisId: Google -
              hiring_funnel_performance_summary.total_spend, id: Google - hiring_funnel_performance_summary.total_spend,
            name: Google - Hiring Funnel Performance Summary Total Spend}, {axisId: Recruitics
              - hiring_funnel_performance_summary.total_spend, id: Recruitics - hiring_funnel_performance_summary.total_spend,
            name: Recruitics - Hiring Funnel Performance Summary Total Spend}], showLabels: true,
        showValues: true, unpinAxis: false, tickDensity: default, tickDensityCustom: 5,
        type: linear}, {label: !!null '', orientation: right, series: [{axisId: cpl,
            id: cpl, name: CPL}], showLabels: true, showValues: true, unpinAxis: false,
        tickDensity: default, tickDensityCustom: 5, type: linear}]
    hidden_series: [Recruitics - hiring_funnel_performance_summary.total_spend]
    series_types:
      cpl: line
    defaults_version: 1
    hidden_fields: [hiring_funnel_performance_summary.number_of_leads]
    listen:
      Country: hiring_funnel_performance_summary.country
      City: hiring_funnel_performance_summary.city
      Position: hiring_funnel_performance_summary.position
      Date Granularity: hiring_funnel_performance_summary.date_granularity
      Date: hiring_funnel_performance_summary.date_date
    row: 50
    col: 0
    width: 12
    height: 6
  - title: Leads (WoW)
    name: Leads (WoW)
    model: flink_v3
    explore: hiring_funnel_performance_summary
    type: looker_column
    fields: [hiring_funnel_performance_summary.date_, hiring_funnel_performance_summary.number_of_leads]
    filters: {}
    sorts: [hiring_funnel_performance_summary.date_]
    limit: 500
    column_limit: 50
    dynamic_fields: [{category: table_calculation, expression: "(${hiring_funnel_performance_summary.number_of_leads}\
          \ - offset(${hiring_funnel_performance_summary.number_of_leads}, -1)) / offset(${hiring_funnel_performance_summary.number_of_leads},\
          \ -1)", label: WoW, value_format: '"▲  "+0%; "▼  "-0%; 0', value_format_name: !!null '',
        _kind_hint: measure, table_calculation: wow, _type_hint: number}]
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
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    y_axes: [{label: '', orientation: left, series: [{axisId: hiring_funnel_performance_summary.number_of_hires,
            id: hiring_funnel_performance_summary.number_of_hires, name: Number of
              Hires}], showLabels: true, showValues: true, unpinAxis: false, tickDensity: default,
        tickDensityCustom: 5, type: linear}, {label: !!null '', orientation: right,
        series: [{axisId: wow, id: wow, name: WoW}], showLabels: true, showValues: true,
        unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear}]
    series_types:
      wow: scatter
    defaults_version: 1
    listen:
      Country: hiring_funnel_performance_summary.country
      City: hiring_funnel_performance_summary.city
      Position: hiring_funnel_performance_summary.position
      Date Granularity: hiring_funnel_performance_summary.date_granularity
      Date: hiring_funnel_performance_summary.date_date
    row: 38
    col: 12
    width: 12
    height: 6
  - title: Rejection Breakdown
    name: Rejection Breakdown
    model: flink_v3
    explore: fountain_rejection_breakdown
    type: looker_bar
    fields: [fountain_rejection_breakdown.rejection_reason, fountain_rejection_breakdown.number_of_applicants]
    sorts: [fountain_rejection_breakdown.number_of_applicants desc]
    limit: 500
    total: true
    dynamic_fields: [{category: table_calculation, expression: "${fountain_rejection_breakdown.number_of_applicants}\
          \ / ${fountain_rejection_breakdown.number_of_applicants:total}", label: "%\
          \ of Total", value_format: !!null '', value_format_name: percent_0, _kind_hint: measure,
        table_calculation: of_total, _type_hint: number}]
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
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    y_axes: [{label: !!null '', orientation: top, series: [{axisId: of_total, id: of_total,
            name: "% of Total"}], showLabels: true, showValues: false, unpinAxis: false,
        tickDensity: default, tickDensityCustom: 5, type: linear}, {label: '', orientation: bottom,
        series: [{axisId: fountain_rejection_breakdown.number_of_applicants, id: fountain_rejection_breakdown.number_of_applicants,
            name: Number of Applicants}], showLabels: true, showValues: true, unpinAxis: false,
        tickDensity: default, tickDensityCustom: 5, type: linear}]
    series_types: {}
    defaults_version: 1
    hidden_fields: [fountain_rejection_breakdown.number_of_applicants]
    listen:
      Country: fountain_rejection_breakdown.country
      City: fountain_rejection_breakdown.city
      Position: fountain_rejection_breakdown.position
      Date Granularity: fountain_rejection_breakdown.date_granularity
      Date: fountain_rejection_breakdown.start_date
    row: 58
    col: 12
    width: 12
    height: 8
  - title: Hires Contract Mix
    name: Hires Contract Mix
    model: flink_v3
    explore: hires_contract_mix
    type: looker_column
    fields: [hires_contract_mix.date_, hires_contract_mix.number_of_hires, hires_contract_mix.type_of_contract]
    pivots: [hires_contract_mix.type_of_contract]
    filters: {}
    sorts: [hires_contract_mix.date_, hires_contract_mix.type_of_contract]
    limit: 5000
    column_limit: 50
    row_total: right
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
    stacking: percent
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
    y_axes: [{label: '', orientation: left, series: [{axisId: Full-Time - hires_contract_mix.number_of_hires,
            id: Full-Time - hires_contract_mix.number_of_hires, name: Full-Time},
          {axisId: Mini-Job - hires_contract_mix.number_of_hires, id: Mini-Job - hires_contract_mix.number_of_hires,
            name: Mini-Job}, {axisId: Other - hires_contract_mix.number_of_hires,
            id: Other - hires_contract_mix.number_of_hires, name: Other}, {axisId: Part-Time
              - hires_contract_mix.number_of_hires, id: Part-Time - hires_contract_mix.number_of_hires,
            name: Part-Time}, {axisId: Working Student - hires_contract_mix.number_of_hires,
            id: Working Student - hires_contract_mix.number_of_hires, name: Working
              Student}], showLabels: false, showValues: true, unpinAxis: false, tickDensity: default,
        tickDensityCustom: 5, type: linear}]
    series_types: {}
    defaults_version: 1
    hidden_fields:
    listen:
      Country: hires_contract_mix.country
      City: hires_contract_mix.city
      Position: hires_contract_mix.position
      Date Granularity: hires_contract_mix.date_granularity
      Date: hires_contract_mix.hire_date
    row: 44
    col: 0
    width: 12
    height: 6
  - name: ''
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: "# Performance Evolution"
    row: 36
    col: 9
    width: 8
    height: 2
  - name: " (2)"
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: "# Funnel Deep-Dive"
    row: 56
    col: 9
    width: 7
    height: 2
  - name: " (3)"
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: "# Marketing"
    row: 74
    col: 10
    width: 4
    height: 2
  - title: CVR (Lead To Hire)
    name: CVR (Lead To Hire)
    model: flink_v3
    explore: hiring_funnel_marketing_summary
    type: looker_column
    fields: [hiring_funnel_marketing_summary.CVR, hiring_funnel_marketing_summary.date_]
    filters: {}
    sorts: [hiring_funnel_marketing_summary.date_]
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
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    listen:
      Country: hiring_funnel_marketing_summary.country
      City: hiring_funnel_marketing_summary.city
      Position: hiring_funnel_marketing_summary.position
      Date Granularity: hiring_funnel_marketing_summary.date_granularity
      Date: hiring_funnel_marketing_summary.start_date
    row: 50
    col: 12
    width: 12
    height: 6
  - title: Avg Processing Time (Days)
    name: Avg Processing Time (Days)
    model: flink_v3
    explore: fountain_avg_proc_time
    type: looker_bar
    fields: [fountain_avg_proc_time.title, fountain_avg_proc_time.avg_days_to_stage]
    filters:
      fountain_avg_proc_time.title: "-Idle Hold,-Other,-Rejected,-On Hold"
    sorts: [fountain_avg_proc_time.avg_days_to_stage]
    limit: 500
    dynamic_fields: [{category: table_calculation, expression: "${fountain_avg_proc_time.avg_days_to_stage}\
          \ - offset(${fountain_avg_proc_time.avg_days_to_stage}, -1)", label: Days
          Spent in Stage, value_format: !!null '', value_format_name: decimal_1, _kind_hint: measure,
        table_calculation: days_spent_in_stage, _type_hint: number}, {category: table_calculation,
        expression: 'running_total(${days_spent_in_stage})', label: Running Time (Days),
        value_format: !!null '', value_format_name: decimal_1, _kind_hint: measure,
        table_calculation: running_time_days, _type_hint: number}]
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
    x_axis_label: Stage
    series_types: {}
    defaults_version: 1
    hidden_fields: [fountain_avg_proc_time.avg_days_to_stage]
    listen:
      Country: fountain_avg_proc_time.country
      City: fountain_avg_proc_time.city
      Position: fountain_avg_proc_time.position
      Date: fountain_avg_proc_time.hire_date
    row: 66
    col: 0
    width: 12
    height: 8
  - title: Performance City View
    name: Performance City View
    model: flink_v3
    explore: hiring_funnel_performance_summary
    type: looker_grid
    fields: [hiring_funnel_performance_summary.city, hiring_funnel_performance_summary.date_,
      hiring_funnel_performance_summary.date_date, hiring_funnel_performance_summary.number_of_hires,
      hiring_funnel_performance_summary.number_of_hires_with_first_shift_completed, hiring_funnel_performance_summary.avg_days_to_hire,
      hiring_funnel_performance_summary.avg_days_to_first_shift, hiring_funnel_performance_summary.number_of_leads,
      hiring_funnel_performance_summary.total_spend]
    filters: {}
    sorts: [hiring_funnel_performance_summary.city, hiring_funnel_performance_summary.date_
        desc, hiring_funnel_performance_summary.date_date desc]
    subtotals: [hiring_funnel_performance_summary.date_, hiring_funnel_performance_summary.city]
    limit: 5000
    column_limit: 50
    dynamic_fields: [{category: table_calculation, expression: "${hiring_funnel_performance_summary.total_spend}\
          \ / ${hiring_funnel_performance_summary.number_of_leads}", label: CPL, value_format: !!null '',
        value_format_name: euro_accounting_1_precision, _kind_hint: measure, table_calculation: cpl,
        _type_hint: number}, {category: table_calculation, expression: "${hiring_funnel_performance_summary.total_spend}\
          \ / ${hiring_funnel_performance_summary.number_of_hires}", label: CPH, value_format: !!null '',
        value_format_name: euro_accounting_1_precision, _kind_hint: measure, table_calculation: cph,
        _type_hint: number}, {category: table_calculation, expression: "${hiring_funnel_performance_summary.number_of_hires}\
          \ / ${hiring_funnel_performance_summary.number_of_leads}", label: CVR, value_format: !!null '',
        value_format_name: percent_0, _kind_hint: measure, table_calculation: cvr,
        _type_hint: number}]
    show_view_names: false
    show_row_numbers: false
    transpose: false
    truncate_text: false
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
    series_labels:
      hiring_funnel_performance_summary.date_date: Date
      hiring_funnel_performance_summary.number_of_hires: Hires
      hiring_funnel_performance_summary.number_of_hires_with_first_shift_completed: Hired & Completed
        1st Shift
      hiring_funnel_performance_summary.avg_days_to_hire: Avg. Time to Hire (days)
      hiring_funnel_performance_summary.avg_days_to_first_shift: Avg. Time to 1st Shift
        (days)
      hiring_funnel_performance_summary.number_of_leads: Leads
      hiring_funnel_performance_summary.total_spend: Costs
    series_column_widths:
      hiring_funnel_performance_summary.number_of_hires_with_first_shift_completed: 143
      hiring_funnel_performance_summary.avg_days_to_hire: 113
    series_cell_visualizations:
      hiring_funnel_performance_summary.number_of_hires:
        is_active: true
    series_collapsed:
      hiring_funnel_performance_summary.date_week: true
      hiring_funnel_performance_summary.date_: true
      hiring_funnel_performance_summary.country: true
      hiring_funnel_performance_summary.city: true
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
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    series_types: {}
    listen:
      Country: hiring_funnel_performance_summary.country
      City: hiring_funnel_performance_summary.city
      Position: hiring_funnel_performance_summary.position
      Date Granularity: hiring_funnel_performance_summary.date_granularity
      Date: hiring_funnel_performance_summary.date_date
    row: 18
    col: 0
    width: 24
    height: 18
  - title: Marketing Costs Channel Split
    name: Marketing Costs Channel Split
    model: flink_v3
    explore: hiring_funnel_marketing_summary
    type: looker_grid
    fields: [hiring_funnel_marketing_summary.date_, hiring_funnel_marketing_summary.number_of_leads,
      hiring_funnel_marketing_summary.number_of_approved_applicants, hiring_funnel_marketing_summary.total_spend,
      hiring_funnel_marketing_summary.CVR, hiring_funnel_marketing_summary.channel]
    filters:
      hiring_funnel_marketing_summary.country: DE
      hiring_funnel_marketing_summary.start_week: 7 weeks ago for 7 weeks
    sorts: [hiring_funnel_marketing_summary.date_ desc, hiring_funnel_marketing_summary.number_of_leads
        desc]
    subtotals: [hiring_funnel_marketing_summary.date_]
    limit: 500
    dynamic_fields: [{category: table_calculation, expression: "${hiring_funnel_marketing_summary.total_spend}\
          \ / if(is_null(${hiring_funnel_marketing_summary.number_of_leads}), 0, ${hiring_funnel_marketing_summary.number_of_leads})",
        label: CPL, value_format: !!null '', value_format_name: euro_accounting_1_precision,
        _kind_hint: measure, table_calculation: cpl, _type_hint: number}, {category: table_calculation,
        expression: "${hiring_funnel_marketing_summary.total_spend} / ${hiring_funnel_marketing_summary.number_of_approved_applicants}",
        label: CPH, value_format: !!null '', value_format_name: euro_accounting_1_precision,
        _kind_hint: measure, table_calculation: cph, _type_hint: number}]
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
    series_labels:
      hiring_funnel_marketing_summary.number_of_approved_applicants: Hires
      hiring_funnel_marketing_summary.number_of_leads: Leads
    series_cell_visualizations:
      hiring_funnel_marketing_summary.number_of_leads:
        is_active: true
    series_collapsed:
      hiring_funnel_marketing_summary.date_: true
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
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    series_types: {}
    listen:
      Country: hiring_funnel_performance_summary.country
      City: hiring_funnel_performance_summary.city
      Position: hiring_funnel_marketing_summary.position
      Date Granularity: hiring_funnel_marketing_summary.date_granularity
      Date: hiring_funnel_marketing_summary.start_date
    row: 76
    col: 0
    width: 24
    height: 8
  - title: Marketing Costs City Split
    name: Marketing Costs City Split
    model: flink_v3
    explore: hiring_funnel_marketing_summary
    type: looker_grid
    fields: [hiring_funnel_marketing_summary.date_, hiring_funnel_marketing_summary.city,
      hiring_funnel_marketing_summary.number_of_leads, hiring_funnel_marketing_summary.number_of_approved_applicants,
      hiring_funnel_marketing_summary.total_spend, hiring_funnel_marketing_summary.CVR]
    filters:
      hiring_funnel_marketing_summary.country: DE
      hiring_funnel_marketing_summary.start_week: 7 weeks ago for 7 weeks
      hiring_funnel_performance_summary.city: ''
    sorts: [hiring_funnel_marketing_summary.date_ desc, hiring_funnel_marketing_summary.city,
      hiring_funnel_marketing_summary.number_of_leads desc]
    subtotals: [hiring_funnel_marketing_summary.date_]
    limit: 500
    column_limit: 50
    dynamic_fields: [{category: table_calculation, expression: "${hiring_funnel_marketing_summary.total_spend}\
          \ / if(is_null(${hiring_funnel_marketing_summary.number_of_leads}), 0, ${hiring_funnel_marketing_summary.number_of_leads})",
        label: CPL, value_format: !!null '', value_format_name: euro_accounting_1_precision,
        _kind_hint: measure, table_calculation: cpl, _type_hint: number}, {category: table_calculation,
        expression: "${hiring_funnel_marketing_summary.total_spend} / ${hiring_funnel_marketing_summary.number_of_approved_applicants}",
        label: CPH, value_format: !!null '', value_format_name: euro_accounting_1_precision,
        _kind_hint: measure, table_calculation: cph, _type_hint: number}]
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
    series_labels:
      hiring_funnel_marketing_summary.number_of_approved_applicants: Hires
      hiring_funnel_marketing_summary.number_of_leads: Leads
    series_cell_visualizations:
      hiring_funnel_marketing_summary.number_of_leads:
        is_active: true
    series_collapsed:
      hiring_funnel_marketing_summary.date_: true
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
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    series_types: {}
    listen:
      Country: hiring_funnel_performance_summary.country
      City: hiring_funnel_marketing_summary.city
      Position: hiring_funnel_marketing_summary.position
      Date Granularity: hiring_funnel_marketing_summary.date_granularity
      Date: hiring_funnel_marketing_summary.start_date
    row: 84
    col: 0
    width: 24
    height: 7
  - title: Active Funnel
    name: Active Funnel
    model: flink_v3
    explore: fountain_funnel_pipeline
    type: looker_column
    fields: [fountain_funnel_pipeline.title, fountain_funnel_pipeline.number_of_applicants,
      fountain_funnel_pipeline.events_custom_sort]
    filters:
      fountain_funnel_pipeline.title: "-Rejected,-Other,-On Hold,-Idle Hold"
    sorts: [fountain_funnel_pipeline.events_custom_sort]
    limit: 500
    column_limit: 50
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
    y_axes: [{label: '', orientation: left, series: [{axisId: fountain_funnel_pipeline.number_of_applicants,
            id: fountain_funnel_pipeline.number_of_applicants, name: Number of Applicants}],
        showLabels: true, showValues: true, unpinAxis: false, tickDensity: default,
        tickDensityCustom: 5, type: linear}, {label: !!null '', orientation: right,
        series: [{axisId: stage_conversion, id: stage_conversion, name: Stage Conversion}],
        showLabels: true, showValues: true, unpinAxis: false, tickDensity: default,
        tickDensityCustom: 5, type: linear}]
    x_axis_label: Stage
    series_types:
      stage_conversion: scatter
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
    defaults_version: 1
    hidden_fields: [fountain_funnel_pipeline.events_custom_sort]
    listen:
      Country: fountain_funnel_pipeline.country
      City: fountain_funnel_pipeline.city
      Position: fountain_funnel_pipeline.position
    row: 58
    col: 0
    width: 12
    height: 8
  - title: Average Processing Time (Days)
    name: Average Processing Time (Days)
    model: flink_v3
    explore: fountain_avg_proc_time
    type: looker_column
    fields: [fountain_avg_proc_time.avg_days_to_stage, fountain_avg_proc_time.hire_week]
    fill_fields: [fountain_avg_proc_time.hire_week]
    filters:
      fountain_avg_proc_time.title: Approved,Contract Signature
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
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    y_axes: [{label: Avg. Days to Hire, orientation: left, series: [{axisId: fountain_avg_proc_time.avg_days_to_stage,
            id: fountain_avg_proc_time.avg_days_to_stage, name: Avg Days to Stage}],
        showLabels: true, showValues: true, unpinAxis: false, tickDensity: default,
        tickDensityCustom: 5, type: linear}]
    series_types: {}
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    listen:
      Country: fountain_avg_proc_time.country
      City: fountain_avg_proc_time.city
      Position: fountain_avg_proc_time.position
      Date Granularity: fountain_avg_proc_time.date_granularity
      Date: fountain_avg_proc_time.hire_date
    row: 44
    col: 12
    width: 12
    height: 6
  - title: Leads Breakdown X CPL
    name: Leads Breakdown X CPL
    model: flink_v3
    explore: hiring_funnel_performance_summary
    type: looker_column
    fields: [hiring_funnel_performance_summary.date_, hiring_funnel_performance_summary.number_of_leads,
      hiring_funnel_performance_summary.channel, hiring_funnel_performance_summary.total_spend]
    pivots: [hiring_funnel_performance_summary.channel]
    filters:
      hiring_funnel_performance_summary.date_granularity: Week
      hiring_funnel_performance_summary.country: DE
      hiring_funnel_performance_summary.city: ''
      hiring_funnel_performance_summary.position: Rider
      hiring_funnel_performance_summary.date_date: 7 weeks ago for 7 weeks
    sorts: [hiring_funnel_performance_summary.channel, hiring_funnel_performance_summary.date_]
    limit: 500
    column_limit: 50
    row_total: right
    dynamic_fields: [{category: table_calculation, expression: "(${hiring_funnel_performance_summary.number_of_leads}\
          \ - offset(${hiring_funnel_performance_summary.number_of_leads}, -1)) / offset(${hiring_funnel_performance_summary.number_of_leads},\
          \ -1)", label: WoW, value_format: '"▲  "+0%; "▼  "-0%; 0', value_format_name: !!null '',
        _kind_hint: measure, table_calculation: wow, _type_hint: number, is_disabled: true},
      {category: table_calculation, expression: "${hiring_funnel_performance_summary.total_spend:row_total}\
          \ / if(${hiring_funnel_performance_summary.number_of_leads:row_total}=0,\
          \ null, ${hiring_funnel_performance_summary.number_of_leads:row_total})",
        label: CPL, value_format: !!null '', value_format_name: euro_accounting_1_precision,
        _kind_hint: supermeasure, table_calculation: cpl, _type_hint: number}]
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
    show_totals_labels: true
    show_silhouette: false
    totals_color: "#808080"
    y_axes: [{label: Leads, orientation: left, series: [{axisId: "[utm_source - hiring_funnel_performance_summary.number_of_leads",
            id: "[utm_source - hiring_funnel_performance_summary.number_of_leads",
            name: "[utm_source - Hiring Funnel Performance Summary Number of Leads"},
          {axisId: "[utm_source] - hiring_funnel_performance_summary.number_of_leads",
            id: "[utm_source] - hiring_funnel_performance_summary.number_of_leads",
            name: "[utm_source] - Hiring Funnel Performance Summary Number of Leads"},
          {axisId: Appcast - hiring_funnel_performance_summary.number_of_leads, id: Appcast
              - hiring_funnel_performance_summary.number_of_leads, name: Appcast -
              Hiring Funnel Performance Summary Number of Leads}, {axisId: appjobs
              - hiring_funnel_performance_summary.number_of_leads, id: appjobs - hiring_funnel_performance_summary.number_of_leads,
            name: appjobs - Hiring Funnel Performance Summary Number of Leads}, {
            axisId: Arbeitsagentur - hiring_funnel_performance_summary.number_of_leads,
            id: Arbeitsagentur - hiring_funnel_performance_summary.number_of_leads,
            name: Arbeitsagentur - Hiring Funnel Performance Summary Number of Leads},
          {axisId: ARBEITSAMT - hiring_funnel_performance_summary.number_of_leads,
            id: ARBEITSAMT - hiring_funnel_performance_summary.number_of_leads, name: ARBEITSAMT
              - Hiring Funnel Performance Summary Number of Leads}, {axisId: careers
              - hiring_funnel_performance_summary.number_of_leads, id: careers - hiring_funnel_performance_summary.number_of_leads,
            name: careers - Hiring Funnel Performance Summary Number of Leads}, {
            axisId: eBay - hiring_funnel_performance_summary.number_of_leads, id: eBay
              - hiring_funnel_performance_summary.number_of_leads, name: eBay - Hiring
              Funnel Performance Summary Number of Leads}, {axisId: Facebook - hiring_funnel_performance_summary.number_of_leads,
            id: Facebook - hiring_funnel_performance_summary.number_of_leads, name: Facebook
              - Hiring Funnel Performance Summary Number of Leads}, {axisId: Google
              - hiring_funnel_performance_summary.number_of_leads, id: Google - hiring_funnel_performance_summary.number_of_leads,
            name: Google - Hiring Funnel Performance Summary Number of Leads}, {axisId: Indeed
              - hiring_funnel_performance_summary.number_of_leads, id: Indeed - hiring_funnel_performance_summary.number_of_leads,
            name: Indeed - Hiring Funnel Performance Summary Number of Leads}, {axisId: internaltransfer
              - hiring_funnel_performance_summary.number_of_leads, id: internaltransfer
              - hiring_funnel_performance_summary.number_of_leads, name: internaltransfer
              - Hiring Funnel Performance Summary Number of Leads}, {axisId: jobino
              - hiring_funnel_performance_summary.number_of_leads, id: jobino - hiring_funnel_performance_summary.number_of_leads,
            name: jobino - Hiring Funnel Performance Summary Number of Leads}, {axisId: lieferjobs
              - hiring_funnel_performance_summary.number_of_leads, id: lieferjobs -
              hiring_funnel_performance_summary.number_of_leads, name: lieferjobs -
              Hiring Funnel Performance Summary Number of Leads}, {axisId: master
              - hiring_funnel_performance_summary.number_of_leads, id: master - hiring_funnel_performance_summary.number_of_leads,
            name: master - Hiring Funnel Performance Summary Number of Leads}, {axisId: offline
              - hiring_funnel_performance_summary.number_of_leads, id: offline - hiring_funnel_performance_summary.number_of_leads,
            name: offline - Hiring Funnel Performance Summary Number of Leads}, {
            axisId: raf - hiring_funnel_performance_summary.number_of_leads, id: raf
              - hiring_funnel_performance_summary.number_of_leads, name: raf - Hiring
              Funnel Performance Summary Number of Leads}, {axisId: Reach - hiring_funnel_performance_summary.number_of_leads,
            id: Reach - hiring_funnel_performance_summary.number_of_leads, name: Reach
              - Hiring Funnel Performance Summary Number of Leads}, {axisId: SR -
              hiring_funnel_performance_summary.number_of_leads, id: SR - hiring_funnel_performance_summary.number_of_leads,
            name: SR - Hiring Funnel Performance Summary Number of Leads}, {axisId: SR_API
              - hiring_funnel_performance_summary.number_of_leads, id: SR_API - hiring_funnel_performance_summary.number_of_leads,
            name: SR_API - Hiring Funnel Performance Summary Number of Leads}, {axisId: SR_Indeed
              - hiring_funnel_performance_summary.number_of_leads, id: SR_Indeed -
              hiring_funnel_performance_summary.number_of_leads, name: SR_Indeed -
              Hiring Funnel Performance Summary Number of Leads}, {axisId: tiktok
              - hiring_funnel_performance_summary.number_of_leads, id: tiktok - hiring_funnel_performance_summary.number_of_leads,
            name: tiktok - Hiring Funnel Performance Summary Number of Leads}], showLabels: true,
        showValues: true, unpinAxis: false, tickDensity: default, type: linear}, {
        label: '', orientation: right, series: [{axisId: cpl, id: cpl, name: CPL}],
        showLabels: true, showValues: true, unpinAxis: false, tickDensity: default,
        type: linear}]
    series_types:
      wow: scatter
      cpl: line
    defaults_version: 1
    hidden_fields: [hiring_funnel_performance_summary.total_spend]
    listen: {}
    row: 91
    col: 0
    width: 12
    height: 7
  - title: Hires Breakdown X CPH
    name: Hires Breakdown X CPH
    model: flink_v3
    explore: hiring_funnel_marketing_summary
    type: looker_column
    fields: [hiring_funnel_marketing_summary.date_, hiring_funnel_marketing_summary.number_of_approved_applicants,
      hiring_funnel_marketing_summary.total_spend, hiring_funnel_marketing_summary.channel]
    pivots: [hiring_funnel_marketing_summary.channel]
    filters:
      hiring_funnel_marketing_summary.position: Rider
      hiring_funnel_marketing_summary.country: DE
      hiring_funnel_marketing_summary.start_week: 7 weeks ago for 7 weeks
      hiring_funnel_marketing_summary.date_granularity: Week
      hiring_funnel_performance_summary.country: DE
      hiring_funnel_performance_summary.city: ''
      hiring_funnel_marketing_summary.start_date: 7 weeks ago for 7 weeks
      hiring_funnel_marketing_summary.city: ''
    sorts: [hiring_funnel_marketing_summary.date_, hiring_funnel_marketing_summary.channel]
    limit: 500
    column_limit: 50
    row_total: right
    dynamic_fields: [{category: table_calculation, expression: "${hiring_funnel_marketing_summary.total_spend}\
          \ / if(is_null(${hiring_funnel_marketing_summary.number_of_leads}), 0, ${hiring_funnel_marketing_summary.number_of_leads})",
        label: CPL, value_format: !!null '', value_format_name: euro_accounting_1_precision,
        _kind_hint: measure, table_calculation: cpl, _type_hint: number, is_disabled: true},
      {category: table_calculation, expression: "${hiring_funnel_marketing_summary.total_spend:row_total}\
          \ / ${hiring_funnel_marketing_summary.number_of_approved_applicants:row_total}",
        label: CPH, value_format: !!null '', value_format_name: euro_accounting_1_precision,
        _kind_hint: supermeasure, table_calculation: cph, _type_hint: number}]
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
    y_axes: [{label: Hires, orientation: left, series: [{axisId: "[utm_source - hiring_funnel_marketing_summary.number_of_approved_applicants",
            id: "[utm_source - hiring_funnel_marketing_summary.number_of_approved_applicants",
            name: "[utm_source - Hiring Funnel Marketing Summary Number of Approved\
              \ Applicants"}, {axisId: "[utm_source] - hiring_funnel_marketing_summary.number_of_approved_applicants",
            id: "[utm_source] - hiring_funnel_marketing_summary.number_of_approved_applicants",
            name: "[utm_source] - Hiring Funnel Marketing Summary Number of Approved\
              \ Applicants"}, {axisId: Appcast - hiring_funnel_marketing_summary.number_of_approved_applicants,
            id: Appcast - hiring_funnel_marketing_summary.number_of_approved_applicants,
            name: Appcast - Hiring Funnel Marketing Summary Number of Approved Applicants},
          {axisId: appjobs - hiring_funnel_marketing_summary.number_of_approved_applicants,
            id: appjobs - hiring_funnel_marketing_summary.number_of_approved_applicants,
            name: appjobs - Hiring Funnel Marketing Summary Number of Approved Applicants},
          {axisId: Arbeitsagentur - hiring_funnel_marketing_summary.number_of_approved_applicants,
            id: Arbeitsagentur - hiring_funnel_marketing_summary.number_of_approved_applicants,
            name: Arbeitsagentur - Hiring Funnel Marketing Summary Number of Approved
              Applicants}, {axisId: ARBEITSAMT - hiring_funnel_marketing_summary.number_of_approved_applicants,
            id: ARBEITSAMT - hiring_funnel_marketing_summary.number_of_approved_applicants,
            name: ARBEITSAMT - Hiring Funnel Marketing Summary Number of Approved
              Applicants}, {axisId: careers - hiring_funnel_marketing_summary.number_of_approved_applicants,
            id: careers - hiring_funnel_marketing_summary.number_of_approved_applicants,
            name: careers - Hiring Funnel Marketing Summary Number of Approved Applicants},
          {axisId: eBay - hiring_funnel_marketing_summary.number_of_approved_applicants,
            id: eBay - hiring_funnel_marketing_summary.number_of_approved_applicants,
            name: eBay - Hiring Funnel Marketing Summary Number of Approved Applicants},
          {axisId: Facebook - hiring_funnel_marketing_summary.number_of_approved_applicants,
            id: Facebook - hiring_funnel_marketing_summary.number_of_approved_applicants,
            name: Facebook - Hiring Funnel Marketing Summary Number of Approved Applicants},
          {axisId: Google - hiring_funnel_marketing_summary.number_of_approved_applicants,
            id: Google - hiring_funnel_marketing_summary.number_of_approved_applicants,
            name: Google - Hiring Funnel Marketing Summary Number of Approved Applicants},
          {axisId: Indeed - hiring_funnel_marketing_summary.number_of_approved_applicants,
            id: Indeed - hiring_funnel_marketing_summary.number_of_approved_applicants,
            name: Indeed - Hiring Funnel Marketing Summary Number of Approved Applicants},
          {axisId: internaltransfer - hiring_funnel_marketing_summary.number_of_approved_applicants,
            id: internaltransfer - hiring_funnel_marketing_summary.number_of_approved_applicants,
            name: internaltransfer - Hiring Funnel Marketing Summary Number of Approved
              Applicants}, {axisId: jobino - hiring_funnel_marketing_summary.number_of_approved_applicants,
            id: jobino - hiring_funnel_marketing_summary.number_of_approved_applicants,
            name: jobino - Hiring Funnel Marketing Summary Number of Approved Applicants},
          {axisId: lieferjobs - hiring_funnel_marketing_summary.number_of_approved_applicants,
            id: lieferjobs - hiring_funnel_marketing_summary.number_of_approved_applicants,
            name: lieferjobs - Hiring Funnel Marketing Summary Number of Approved
              Applicants}, {axisId: master - hiring_funnel_marketing_summary.number_of_approved_applicants,
            id: master - hiring_funnel_marketing_summary.number_of_approved_applicants,
            name: master - Hiring Funnel Marketing Summary Number of Approved Applicants},
          {axisId: offline - hiring_funnel_marketing_summary.number_of_approved_applicants,
            id: offline - hiring_funnel_marketing_summary.number_of_approved_applicants,
            name: offline - Hiring Funnel Marketing Summary Number of Approved Applicants},
          {axisId: raf - hiring_funnel_marketing_summary.number_of_approved_applicants,
            id: raf - hiring_funnel_marketing_summary.number_of_approved_applicants,
            name: raf - Hiring Funnel Marketing Summary Number of Approved Applicants},
          {axisId: Reach - hiring_funnel_marketing_summary.number_of_approved_applicants,
            id: Reach - hiring_funnel_marketing_summary.number_of_approved_applicants,
            name: Reach - Hiring Funnel Marketing Summary Number of Approved Applicants},
          {axisId: SR - hiring_funnel_marketing_summary.number_of_approved_applicants,
            id: SR - hiring_funnel_marketing_summary.number_of_approved_applicants,
            name: SR - Hiring Funnel Marketing Summary Number of Approved Applicants},
          {axisId: SR_API - hiring_funnel_marketing_summary.number_of_approved_applicants,
            id: SR_API - hiring_funnel_marketing_summary.number_of_approved_applicants,
            name: SR_API - Hiring Funnel Marketing Summary Number of Approved Applicants},
          {axisId: SR_Indeed - hiring_funnel_marketing_summary.number_of_approved_applicants,
            id: SR_Indeed - hiring_funnel_marketing_summary.number_of_approved_applicants,
            name: SR_Indeed - Hiring Funnel Marketing Summary Number of Approved Applicants},
          {axisId: tiktok - hiring_funnel_marketing_summary.number_of_approved_applicants,
            id: tiktok - hiring_funnel_marketing_summary.number_of_approved_applicants,
            name: tiktok - Hiring Funnel Marketing Summary Number of Approved Applicants}],
        showLabels: true, showValues: true, valueFormat: '', unpinAxis: false, tickDensity: default,
        tickDensityCustom: 5, type: linear}, {label: !!null '', orientation: right,
        series: [{axisId: cph, id: cph, name: CPH}], showLabels: true, showValues: true,
        unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear}]
    series_types:
      cph: line
    series_labels:
      hiring_funnel_marketing_summary.number_of_approved_applicants: Hires
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
    show_totals: true
    show_row_totals: true
    series_cell_visualizations:
      hiring_funnel_marketing_summary.number_of_leads:
        is_active: true
    series_collapsed:
      hiring_funnel_marketing_summary.date_: true
    defaults_version: 1
    hidden_fields: [hiring_funnel_marketing_summary.total_spend]
    listen: {}
    row: 91
    col: 12
    width: 12
    height: 7
  filters:
  - name: Country
    title: Country
    type: field_filter
    default_value: DE
    allow_multiple_values: true
    required: false
    ui_config:
      type: checkboxes
      display: popover
      options: []
    model: flink_v3
    explore: hiring_funnel_performance_summary
    listens_to_filters: []
    field: hiring_funnel_performance_summary.country
  - name: City
    title: City
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: popover
      options: []
    model: flink_v3
    explore: hiring_funnel_performance_summary
    listens_to_filters: []
    field: hiring_funnel_performance_summary.city
  - name: Position
    title: Position
    type: field_filter
    default_value: Rider
    allow_multiple_values: true
    required: false
    ui_config:
      type: checkboxes
      display: popover
      options: []
    model: flink_v3
    explore: hiring_funnel_performance_summary
    listens_to_filters: []
    field: hiring_funnel_performance_summary.position
  - name: Date Granularity
    title: Date Granularity
    type: field_filter
    default_value: Week
    allow_multiple_values: true
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
      options: []
    model: flink_v3
    explore: hiring_funnel_performance_summary
    listens_to_filters: []
    field: hiring_funnel_performance_summary.date_granularity
  - name: Date
    title: Date
    type: field_filter
    default_value: 7 week ago for 7 week
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
      options: []
    model: flink_v3
    explore: hiring_funnel_performance_summary
    listens_to_filters: []
    field: hiring_funnel_performance_summary.date_date
