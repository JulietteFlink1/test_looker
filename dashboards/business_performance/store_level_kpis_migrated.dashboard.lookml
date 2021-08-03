- dashboard: store_level_kpis_migrated
  title: Store Level KPIs
  layout: newspaper
  preferred_viewer: dashboards-next
  elements:
  - name: Store KPIs
    title: Store KPIs
    model: flink_v3
    explore: orders_cl
    type: looker_grid
    fields: [orders_cl.cnt_orders, orders_cl.cnt_unique_orders_new_customers,
      orders_cl.cnt_unique_customers, orders_cl.sum_gmv_gross, orders_cl.avg_order_value_gross,
      orders_cl.pct_discount_order_share, orders_cl.avg_fulfillment_time_mm_ss,
      orders_cl.sum_discount_amt, orders_cl.pct_discount_value_of_gross_total,
      orders_cl.avg_delivery_fee_gross, orders_cl.pct_delivery_late_over_5_min,
      orders_cl.pct_delivery_late_over_10_min, orders_cl.pct_delivery_in_time,
      hubs.hub_name, shyftplan_riders_pickers_hours.rider_utr, shyftplan_riders_pickers_hours.picker_utr,
      hubs.weeks_time_between_hub_launch_and_today, orders_cl.pct_acquisition_share,
      issue_rates_clean.pct_orders_with_issues, nps_after_order.nps_score]
    filters:
      orders_cl.is_internal_order: 'no'
      orders_cl.is_successful_order: ''
      orders_cl.warehouse_name: "-EMPTY"
    sorts: [orders_cl.cnt_orders desc]
    limit: 500
    dynamic_fields: [{table_calculation: wow, label: WoW, expression: "( ${orders_cl.cnt_orders}\
          \ - offset(${orders_cl.cnt_orders}, 7) ) / offset(${orders_cl.cnt_orders},\
          \ 7)", value_format: '"▲  "+0%; "▼  "-0%; 0', value_format_name: !!null '',
        _kind_hint: measure, _type_hint: number, is_disabled: true}]
    query_timezone: Europe/Berlin
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: false
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: gray
    limit_displayed_rows: false
    enable_conditional_formatting: true
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    color_application:
      collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
    show_sql_query_menu_options: false
    pinned_columns:
      "$$$_row_numbers_$$$": left
      hubs.weeks_time_between_hub_launch_and_today: left
      hubs.hub_name: left
      orders_cl.cnt_orders: left
    column_order: ["$$$_row_numbers_$$$", hubs.hub_name, hubs.weeks_time_between_hub_launch_and_today,
      orders_cl.cnt_orders, orders_cl.avg_order_value_gross, orders_cl.avg_fulfillment_time_mm_ss,
      orders_cl.pct_delivery_in_time, orders_cl.pct_delivery_late_over_5_min,
      orders_cl.pct_delivery_late_over_10_min, shyftplan_riders_pickers_hours.rider_utr,
      shyftplan_riders_pickers_hours.picker_utr, orders_cl.sum_gmv_gross, nps_after_order.nps_score,
      issue_rates_clean.pct_orders_with_issues, orders_cl.sum_discount_amt, orders_cl.cnt_unique_customers,
      orders_cl.cnt_unique_orders_new_customers, orders_cl.pct_acquisition_share,
      orders_cl.pct_discount_order_share, orders_cl.pct_discount_value_of_gross_total,
      orders_cl.avg_delivery_fee_gross]
    show_totals: true
    show_row_totals: true
    series_labels:
      hubs.weeks_time_between_hub_launch_and_today: Weeks since launch
    series_column_widths:
      orders_cl.created_date: 125
      orders_cl.cnt_unique_orders: 101
      orders_cl.cnt_unique_orders_new_customers: 125
      orders_cl.cnt_unique_orders_existing_customers: 147
      orders_cl.cnt_unique_customers: 138
      orders_cl.avg_basket_size_gross: 211
      orders_cl.sum_revenue_gross: 173
      orders_cl.avg_reaction_time: 115
      orders_cl.avg_picking_time: 106
      orders_cl.avg_fulfillment_time: 169
      orders_cl.avg_delivery_time: 154
      orders_cl.cnt_orders: 126
      orders_cl.pct_discount_order_share: 117
      orders_cl.sum_discount_amt: 124
      orders_cl.pct_discount_value_of_gross_total: 117
      orders_cl.avg_delivery_fee_gross: 121
      orders_cl.avg_acceptance_time: 175
      orders_cl.sum_gmv_gross: 99
      orders_cl.avg_order_value_gross: 187
      orders_cl.pct_delivery_late_over_5_min: 122
      orders_cl.pct_delivery_late_over_10_min: 114
      wow: 74
      orders_cl.date: 162
      orders_cl.avg_fulfillment_time_mm_ss: 129
      orders_cl.warehouse_name: 150
      orders_cl.pct_delivery_in_time: 102
      hubs.hub_name: 197
      shyftplan_riders_pickers_hours.rider_utr: 84
      shyftplan_riders_pickers_hours.picker_utr: 84
      orders_cl.weeks_time_since_hub_launch: 106
      hubs.weeks_time_between_hub_launch_and_today: 105
      orders_cl.pct_acquisition_share: 112
      nps_hub_level.avg_nps_score: 61
      issue_rates_clean.pct_orders_with_issues: 70
      nps_after_order.nps_score: 71
    series_cell_visualizations:
      orders_cl.cnt_unique_orders:
        is_active: true
        palette:
          palette_id: 56d0c358-10a0-4fd6-aa0b-b117bef527ab
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      orders_cl.avg_basket_size_gross:
        is_active: true
        palette:
          palette_id: 56d0c358-10a0-4fd6-aa0b-b117bef527ab
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      orders_cl.avg_fulfillment_time:
        is_active: true
        palette:
          palette_id: 84802bdf-40bc-c721-2694-55c5eaeb8519
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
          custom_colors:
          - "#b1e84d"
          - "#ffffff"
          - "#ff393f"
      orders_cl.cnt_orders:
        is_active: true
        palette:
          palette_id: 56d0c358-10a0-4fd6-aa0b-b117bef527ab
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      orders_cl.avg_order_value_gross:
        is_active: true
        palette:
          palette_id: 56d0c358-10a0-4fd6-aa0b-b117bef527ab
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      orders_cl.pct_delivery_late_over_5_min:
        is_active: true
        palette:
          palette_id: cb3356e4-15f7-f4ff-a08f-b6fc17b5c145
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
          custom_colors:
          - "#b1e84d"
          - "#ffffff"
          - "#ff393f"
      wow:
        is_active: false
        palette:
          palette_id: fca4d068-6149-4d2a-cf71-eea5bb78182a
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
          custom_colors:
          - "#e8230a"
          - "#ffffff"
          - "#67e813"
        value_display: true
      orders_cl.pct_delivery_late_over_10_min:
        is_active: true
        palette:
          palette_id: e6c3ca7a-03b3-3cfd-2024-978aa98edb14
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
          custom_colors:
          - "#b1e84d"
          - "#ffffff"
          - "#ff393f"
      orders_cl.avg_fulfillment_time_mm_ss:
        is_active: true
        palette:
          palette_id: 9c1cb5e8-d69e-f228-a723-6fdb29dde6b0
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
          custom_colors:
          - "#b1e84d"
          - "#ffffff"
          - "#f2180f"
      orders_cl.pct_delivery_in_time:
        is_active: true
        palette:
          palette_id: f50c3cde-51ec-380e-bd2c-de3375adfd32
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
          custom_colors:
          - "#ffffff"
          - "#8be631"
      shyftplan_riders_pickers_hours.rider_utr:
        is_active: true
        palette:
          palette_id: 75f72ca5-9735-dbac-21c9-0b8619a2415e
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
          custom_colors:
          - "#ffffff"
          - "#8be631"
      shyftplan_riders_pickers_hours.picker_utr:
        is_active: true
        palette:
          palette_id: 2e132304-c019-8484-fd69-a02667b7a2b5
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
          custom_colors:
          - "#ffffff"
          - "#8be631"
      hubs.weeks_time_between_hub_launch_and_today:
        is_active: false
      nps_hub_level.avg_nps_score:
        is_active: false
      issue_rates_clean.pct_orders_with_issues:
        is_active: false
        palette:
          palette_id: 4e293dbd-6f4d-ba9a-e409-c78a4f4c5b88
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
          custom_colors:
          - "#FF5733"
          - "#ffffff"
      nps_after_order.nps_score:
        is_active: false
    series_text_format:
      wow:
        italic: true
        align: center
    header_font_color: ''
    conditional_formatting: [{type: less than, value: 0.4, background_color: !!null '',
        font_color: "#bf1d1d", color_application: {collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2,
          custom: {id: 875cd87e-c531-33ad-d63e-49281cc2ca1f, label: Custom, type: continuous,
            stops: [{color: "#e61c14", offset: 0}, {color: "#FFFFFF", offset: 50},
              {color: "#27e81e", offset: 100}]}, options: {steps: 5, mirror: false,
            constraints: {min: {type: number, value: -1}, mid: {type: number, value: 0},
              max: {type: number, value: 1}}}}, bold: true, italic: false, strikethrough: false,
        fields: [nps_after_order.nps_score]}, {type: less than, value: 0.6, background_color: !!null '',
        font_color: "#F9AB00", color_application: {collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2,
          palette_id: 4a00499b-c0fe-4b15-a304-4083c07ff4c4}, bold: true, italic: false,
        strikethrough: false, fields: [nps_after_order.nps_score]}, {type: greater
          than, value: 0.02, background_color: !!null '', font_color: "#EA4335", color_application: {
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2, palette_id: 4a00499b-c0fe-4b15-a304-4083c07ff4c4},
        bold: true, italic: false, strikethrough: false, fields: [issue_rates_clean.pct_orders_with_issues]},
      {type: greater than, value: 0.01, background_color: !!null '', font_color: "#F9AB00",
        color_application: {collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2, palette_id: 4a00499b-c0fe-4b15-a304-4083c07ff4c4},
        bold: true, italic: false, strikethrough: false, fields: [issue_rates_clean.pct_orders_with_issues]}]
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
      Country: hubs.country
      City: hubs.city
      Hub Name: hubs.hub_name
      Order Date: orders_cl.created_date
    row: 0
    col: 0
    width: 24
    height: 19
  - name: Hub KPI Evolution
    title: Hub KPI Evolution
    model: flink_v3
    explore: orders_cl
    type: looker_grid
    fields: [hubs.hub_name, orders_cl.date, orders_cl.date_granularity_pass_through,
      orders_cl.KPI, hubs.weeks_time_between_hub_launch_and_today]
    pivots: [orders_cl.date]
    filters:
      orders_cl.is_internal_order: 'no'
      orders_cl.is_successful_order: ''
    sorts: [orders_cl.date desc, orders_cl.KPI desc 0]
    limit: 500
    column_limit: 50
    dynamic_fields: [{table_calculation: wow_growth, label: WoW Growth, expression: "if(${orders_cl.date_granularity_pass_through}\
          \ = \"Day\", ( ${orders_cl.KPI} - pivot_offset(${orders_cl.KPI}, 7)\
          \ ) / pivot_offset(${orders_cl.KPI}, 7),( ${orders_cl.KPI} - pivot_offset(${orders_cl.KPI},\
          \ 1) ) / pivot_offset(${orders_cl.KPI}, 1))\n\n", value_format: '"▲  "+0%;
          "▼  "-0%; 0', value_format_name: !!null '', is_disabled: false, _kind_hint: measure,
        _type_hint: number}]
    query_timezone: Europe/Berlin
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: false
    hide_totals: false
    hide_row_totals: false
    size_to_fit: false
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: true
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    column_order: []
    show_totals: true
    show_row_totals: true
    series_labels:
      hubs.weeks_time_between_hub_launch_and_today: Weeks since launch
    series_column_widths:
      orders_cl.cnt_orders: 99
      orders_cl.created_date: 113
      wow: 83
      hubs.hub_name: 173
      growth: 82
      orders_cl.weeks_time_since_hub_launch: 139
      hubs.weeks_time_between_hub_launch_and_today: 107
    series_cell_visualizations:
      orders_cl.cnt_orders:
        is_active: true
        palette:
          palette_id: 56d0c358-10a0-4fd6-aa0b-b117bef527ab
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
    conditional_formatting: [{type: greater than, value: 0, background_color: '',
        font_color: "#16bf20", color_application: {collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2,
          palette_id: 4a00499b-c0fe-4b15-a304-4083c07ff4c4, options: {constraints: {
              min: {type: minimum}, mid: {type: number, value: 0}, max: {type: maximum}},
            mirror: true, reverse: false, stepped: false}}, bold: false, italic: false,
        strikethrough: false, fields: [wow_growth]}, {type: less than, value: 0, background_color: '',
        font_color: "#EA4335", color_application: {collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2,
          palette_id: 4a00499b-c0fe-4b15-a304-4083c07ff4c4, options: {constraints: {
              min: {type: minimum}, mid: {type: number, value: 0}, max: {type: maximum}},
            mirror: true, reverse: false, stepped: false}}, bold: false, italic: false,
        strikethrough: false, fields: [wow_growth]}]
    x_axis_gridlines: false
    y_axis_gridlines: true
    y_axes: [{label: '', orientation: left, series: [{axisId: Berlin - Wilmersdorf
              - orders_cl.cnt_orders, id: Berlin - Wilmersdorf - orders_cl.cnt_orders,
            name: 'Berlin - Wilmersdorf - Orders # Orders'}, {axisId: Berlin - Wilmersdorf
              - wow, id: Berlin - Wilmersdorf - wow, name: Berlin - Wilmersdorf -
              % WoW}, {axisId: Düsseldorf - Friedrichstadt - orders_cl.cnt_orders,
            id: Düsseldorf - Friedrichstadt - orders_cl.cnt_orders, name: 'Düsseldorf
              - Friedrichstadt - Orders # Orders'}, {axisId: Düsseldorf - Friedrichstadt
              - wow, id: Düsseldorf - Friedrichstadt - wow, name: Düsseldorf - Friedrichstadt
              - % WoW}, {axisId: Düsseldorf - Pempelfort - orders_cl.cnt_orders,
            id: Düsseldorf - Pempelfort - orders_cl.cnt_orders, name: 'Düsseldorf
              - Pempelfort - Orders # Orders'}, {axisId: Düsseldorf - Pempelfort -
              wow, id: Düsseldorf - Pempelfort - wow, name: Düsseldorf - Pempelfort
              - % WoW}, {axisId: Hamburg - Altona - orders_cl.cnt_orders, id: Hamburg
              - Altona - orders_cl.cnt_orders, name: 'Hamburg - Altona - Orders
              # Orders'}, {axisId: Hamburg - Altona - wow, id: Hamburg - Altona -
              wow, name: Hamburg - Altona - % WoW}, {axisId: Hamburg - Rotherbaum
              - orders_cl.cnt_orders, id: Hamburg - Rotherbaum - orders_cl.cnt_orders,
            name: 'Hamburg - Rotherbaum - Orders # Orders'}, {axisId: Hamburg - Rotherbaum
              - wow, id: Hamburg - Rotherbaum - wow, name: Hamburg - Rotherbaum -
              % WoW}, {axisId: Köln - Innenstadt - orders_cl.cnt_orders, id: Köln
              - Innenstadt - orders_cl.cnt_orders, name: 'Köln - Innenstadt - Orders
              # Orders'}, {axisId: Köln - Innenstadt - wow, id: Köln - Innenstadt
              - wow, name: Köln - Innenstadt - % WoW}, {axisId: Köln - Lindenthal
              - orders_cl.cnt_orders, id: Köln - Lindenthal - orders_cl.cnt_orders,
            name: 'Köln - Lindenthal - Orders # Orders'}, {axisId: Köln - Lindenthal
              - wow, id: Köln - Lindenthal - wow, name: Köln - Lindenthal - % WoW},
          {axisId: Köln - Nippes - orders_cl.cnt_orders, id: Köln - Nippes - orders_cl.cnt_orders,
            name: 'Köln - Nippes - Orders # Orders'}, {axisId: Köln - Nippes - wow,
            id: Köln - Nippes - wow, name: Köln - Nippes - % WoW}, {axisId: München
              - Maxvorstadt - orders_cl.cnt_orders, id: München - Maxvorstadt -
              orders_cl.cnt_orders, name: 'München - Maxvorstadt - Orders # Orders'},
          {axisId: München - Maxvorstadt - wow, id: München - Maxvorstadt - wow, name: München
              - Maxvorstadt - % WoW}, {axisId: München - Schwabing Nord - orders_cl.cnt_orders,
            id: München - Schwabing Nord - orders_cl.cnt_orders, name: 'München
              - Schwabing Nord - Orders # Orders'}, {axisId: München - Schwabing Nord
              - wow, id: München - Schwabing Nord - wow, name: München - Schwabing
              Nord - % WoW}, {axisId: Nürnberg - Maxfeld - orders_cl.cnt_orders,
            id: Nürnberg - Maxfeld - orders_cl.cnt_orders, name: 'Nürnberg - Maxfeld
              - Orders # Orders'}], showLabels: true, showValues: true, unpinAxis: false,
        tickDensity: default, tickDensityCustom: 5, type: linear}, {label: !!null '',
        orientation: right, series: [{axisId: Nürnberg - Maxfeld - wow, id: Nürnberg
              - Maxfeld - wow, name: Nürnberg - Maxfeld - % WoW}], showLabels: true,
        showValues: true, unpinAxis: false, tickDensity: default, tickDensityCustom: 5,
        type: linear}]
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
    legend_position: center
    series_types: {}
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    swap_axes: false
    show_null_points: true
    interpolation: linear
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    ordering: none
    show_null_labels: false
    defaults_version: 1
    hidden_fields: [orders_cl.date_granularity_pass_through]
    listen:
      KPI Parameter: orders_cl.KPI_parameter
      Date Granularity: orders_cl.date_granularity
      Country: hubs.country
      City: hubs.city
      Hub Name: hubs.hub_name
      Order Date: orders_cl.created_date
    row: 19
    col: 0
    width: 24
    height: 21
  - title: Issue Rates - Hubs
    name: Issue Rates - Hubs
    model: flink_v3
    explore: orders_cl
    type: looker_column
    fields: [hubs.hub_name, issue_rates_clean.sum_orders_total, issue_rates_clean.sum_orders_with_issues,
      issue_rates_clean.pct_orders_with_issues, issue_rates_clean.sum_damaged,
      issue_rates_clean.pct_orders_damaged_product, issue_rates_clean.sum_missing_product,
      issue_rates_clean.pct_orders_missing_product, issue_rates_clean.sum_perished_product,
      issue_rates_clean.pct_orders_perished_product, issue_rates_clean.sum_wrong_order,
      issue_rates_clean.pct_orders_wrong_order, issue_rates_clean.sum_wrong_product,
      issue_rates_clean.pct_orders_wrong_product]
    filters:
      orders_cl.is_internal_order: 'no'
      orders_cl.is_successful_order: ''
      issue_rates_clean.date: 28 days
    sorts: [issue_rates_clean.pct_orders_with_issues desc]
    limit: 500
    query_timezone: Europe/London
    x_axis_gridlines: false
    y_axis_gridlines: false
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
    totals_color: "#80868B"
    y_axes: [{label: '', orientation: left, series: [{axisId: issue_rates_clean.pct_orders_damaged_product,
            id: issue_rates_clean.pct_orders_damaged_product, name: "% Damaged\
              \ Product Issue Rate"}, {axisId: issue_rates_clean.pct_orders_missing_product,
            id: issue_rates_clean.pct_orders_missing_product, name: "% Missing\
              \ Product Issue Rate"}, {axisId: issue_rates_clean.pct_orders_perished_product,
            id: issue_rates_clean.pct_orders_perished_product, name: "% Perished\
              \ Product Issue Rate"}, {axisId: issue_rates_clean.pct_orders_wrong_order,
            id: issue_rates_clean.pct_orders_wrong_order, name: "% Wrong Order\
              \ Issue Rate"}, {axisId: issue_rates_clean.pct_orders_wrong_product,
            id: issue_rates_clean.pct_orders_wrong_product, name: "% Wrong Product\
              \ Issue Rate"}], showLabels: false, showValues: false, unpinAxis: false,
        tickDensity: default, tickDensityCustom: 5, type: linear}]
    limit_displayed_rows_values:
      show_hide: hide
      first_last: first
      num_rows: 0
    hidden_series: []
    hide_legend: false
    font_size: ''
    series_colors:
      issue_rates_clean.pct_orders_damaged_product: "#F9AB00"
      issue_rates_clean.pct_orders_missing_product: "#1A73E8"
      issue_rates_clean.pct_orders_perished_product: "#12B5CB"
      issue_rates_clean.pct_orders_wrong_order: "#E52592"
      issue_rates_clean.pct_orders_wrong_product: "#E8710A"
    defaults_version: 1
    hidden_fields: [issue_rates_clean.sum_orders_total, issue_rates_clean.sum_orders_with_issues,
      issue_rates_clean.sum_damaged, issue_rates_clean.sum_missing_product,
      issue_rates_clean.sum_perished_product, issue_rates_clean.sum_wrong_order,
      issue_rates_clean.pct_orders_with_issues, issue_rates_clean.sum_wrong_product]
    listen:
      Country: hubs.country
      City: hubs.city
      Hub Name: hubs.hub_name
      Order Date: orders_cl.created_date
    row: 40
    col: 0
    width: 24
    height: 11
  filters:
  - name: Country
    title: Country
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: button_toggles
      display: inline
      options: []
    model: flink_v3
    explore: orders_cl
    listens_to_filters: []
    field: hubs.country
  - name: City
    title: City
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: checkboxes
      display: popover
      options: []
    model: flink_v3
    explore: orders_cl
    listens_to_filters: [Country]
    field: hubs.city
  - name: Hub Name
    title: Hub Name
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: checkboxes
      display: popover
      options: []
    model: flink_v3
    explore: orders_cl
    listens_to_filters: [Country]
    field: hubs.hub_name
  - name: Order Date
    title: Order Date
    type: field_filter
    default_value: 6 week
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
      options: []
    model: flink_v3
    explore: orders_cl
    listens_to_filters: []
    field: orders_cl.created_date
  - name: Date Granularity
    title: Date Granularity
    type: field_filter
    default_value: Day
    allow_multiple_values: true
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
      options: []
    model: flink_v3
    explore: orders_cl
    listens_to_filters: []
    field: orders_cl.date_granularity
  - name: KPI Parameter
    title: KPI Parameter
    type: field_filter
    default_value: orders
    allow_multiple_values: true
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
      options: []
    model: flink_v3
    explore: orders_cl
    listens_to_filters: []
    field: orders_cl.KPI_parameter
