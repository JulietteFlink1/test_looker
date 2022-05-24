- dashboard: hub_kpis
  title: Hub KPIs
  layout: newspaper
  preferred_viewer: dashboards-next
  elements:
  - title: Daily Orders & WoW Growth
    name: Daily Orders & WoW Growth
    model: flink_v3
    explore: orders_customers
    type: looker_column
    fields: [orders_cl.cnt_orders, orders_cl.created_date]
    filters:
      orders_cl.is_internal_order: 'no'
      orders_cl.is_successful_order: 'yes'
      orders_cl.created_date: 28 days ago for 28 days
    sorts: [orders_cl.created_date desc, orders_cl.cnt_orders desc]
    limit: 500
    column_limit: 50
    dynamic_fields: [{table_calculation: wow, label: "% WoW", expression: "( ${orders_cl.cnt_orders}\
          \ - offset(${orders_cl.cnt_orders}, 7) ) / offset(${orders_cl.cnt_orders},\
          \ 7)", value_format: '"▲  "+0%; "▼  "-0%; 0', value_format_name: !!null '',
        is_disabled: false, _kind_hint: measure, _type_hint: number}]
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
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    y_axes: [{label: '', orientation: left, series: [{axisId: orders_cl.cnt_orders,
            id: orders_cl.cnt_orders, name: "# Orders"}], showLabels: true, showValues: true,
        unpinAxis: false, tickDensity: default, type: linear}, {label: '', orientation: right,
        series: [{axisId: wow, id: wow, name: "% WoW"}], showLabels: true, showValues: true,
        unpinAxis: false, tickDensity: default, type: linear}]
    series_types:
      wow: line
    series_colors:
      wow: "#7CB342"
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    enable_conditional_formatting: true
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    series_column_widths:
      orders_cl.cnt_orders: 99
      orders_cl.created_date: 113
      wow: 83
      hubs.hub_name: 173
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
        strikethrough: false, fields: [wow]}, {type: less than, value: 0, background_color: '',
        font_color: "#EA4335", color_application: {collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2,
          palette_id: 4a00499b-c0fe-4b15-a304-4083c07ff4c4, options: {constraints: {
              min: {type: minimum}, mid: {type: number, value: 0}, max: {type: maximum}},
            mirror: true, reverse: false, stepped: false}}, bold: false, italic: false,
        strikethrough: false, fields: [wow]}]
    swap_axes: false
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    hidden_fields: []
    listen:
      Country: hubs.country
      City: hubs.city
      Hub Name: hubs.hub_name
    row: 67
    col: 0
    width: 24
    height: 7
  - name: Logistics Timings
    title: Logistics Timings
    model: flink_v3
    explore: orders_customers
    type: looker_column
    fields: [orders_cl.created_date, orders_cl.avg_reaction_time, orders_cl.avg_picking_time,
      orders_cl.avg_acceptance_time, orders_cl.avg_riding_to_customer_time, orders_cl.avg_fulfillment_time,
      orders_cl.avg_promised_eta]
    filters:
      orders_cl.created_date: 28 days ago for 28 days
      orders_cl.is_internal_order: 'no'
      orders_cl.is_successful_order: 'yes'
      orders_cl.warehouse_name: "-EMPTY"
    sorts: [orders_cl.created_date desc]
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
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    color_application:
      collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      palette_id: 5d189dfc-4f46-46f3-822b-bfb0b61777b1
    y_axes: [{label: '', orientation: left, series: [{axisId: orders_cl.avg_reaction_time,
            id: orders_cl.avg_reaction_time, name: AVG Reaction Time}, {axisId: orders_cl.avg_picking_time,
            id: orders_cl.avg_picking_time, name: AVG Picking Time}, {axisId: orders_cl.avg_acceptance_time,
            id: orders_cl.avg_acceptance_time, name: AVG Acceptance Time}, {axisId: orders_cl.avg_riding_to_customer_time,
            id: orders_cl.avg_riding_to_customer_time, name: AVG Riding To Customer Time}], showLabels: true,
        showValues: true, maxValue: 15, minValue: 0, unpinAxis: false, tickDensity: default,
        type: linear}, {label: !!null '', orientation: right, series: [{axisId: orders_cl.avg_fulfillment_time,
            id: orders_cl.avg_fulfillment_time, name: AVG Fulfillment Time (decimal)},
          {axisId: orders_cl.avg_promised_eta, id: orders_cl.avg_promised_eta,
            name: AVG PDT}], showLabels: true, showValues: true, maxValue: 15, minValue: 0,
        unpinAxis: false, tickDensity: default, type: linear}]
    series_types:
      orders_cl.avg_fulfillment_time: line
      orders_cl.avg_promised_eta: line
    reference_lines: [{reference_type: line, range_start: max, range_end: min, margin_top: deviation,
        margin_value: mean, margin_bottom: deviation, label_position: right, color: "#000000",
        line_value: '10', label: Target}]
    show_row_numbers: true
    transpose: false
    truncate_text: false
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: gray
    enable_conditional_formatting: true
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    pinned_columns:
      hubs.hub_name: left
      orders_cl.cnt_orders: left
    column_order: ["$$$_row_numbers_$$$", hubs.hub_name, orders_cl.cnt_orders, orders_cl.avg_order_value_gross,
      orders_cl.avg_fulfillment_time_mm_ss, orders_cl.pct_delivery_in_time, orders_cl.pct_delivery_late_over_5_min,
      orders_cl.pct_delivery_late_over_10_min, orders_cl.sum_gmv_gross, orders_cl.sum_discount_amt,
      orders_cl.cnt_unique_customers, orders_cl.cnt_unique_orders_new_customers,
      orders_cl.pct_discount_order_share, orders_cl.pct_discount_value_of_gross_total,
      orders_cl.avg_delivery_fee_gross]
    show_totals: true
    show_row_totals: true
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
      orders_cl.avg_riding_to_customer_time: 154
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
      orders_cl.avg_picking_time:
        is_active: true
        palette:
          palette_id: c14d55ca-03b6-c6b4-586d-b335aed5ebea
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
          custom_colors:
          - "#b1e84d"
          - "#ffffff"
          - "#f2180f"
    series_text_format:
      wow:
        italic: true
        align: center
    header_font_color: ''
    conditional_formatting: [{type: greater than, value: 0, background_color: !!null '',
        font_color: "#16bf20", color_application: {collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2,
          custom: {id: 875cd87e-c531-33ad-d63e-49281cc2ca1f, label: Custom, type: continuous,
            stops: [{color: "#e61c14", offset: 0}, {color: "#FFFFFF", offset: 50},
              {color: "#27e81e", offset: 100}]}, options: {steps: 5, mirror: false,
            constraints: {min: {type: number, value: -1}, mid: {type: number, value: 0},
              max: {type: number, value: 1}}}}, bold: true, italic: false, strikethrough: false,
        fields: []}, {type: less than, value: 0, background_color: !!null '', font_color: "#EA4335",
        color_application: {collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2, palette_id: 4a00499b-c0fe-4b15-a304-4083c07ff4c4},
        bold: true, italic: false, strikethrough: false, fields: []}]
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    hidden_fields: []
    listen:
      Country: hubs.country
      City: hubs.city
      Hub Name: hubs.hub_name
    row: 74
    col: 0
    width: 24
    height: 8
  - name: Logistics KPIs - Last 7 days
    title: Logistics KPIs - Last 7 days
    model: flink_v3
    explore: orders_customers
    type: looker_grid
    fields: [hubs.hub_name, orders_cl.cnt_orders, orders_cl.avg_fulfillment_time_mm_ss,
      orders_cl.pct_delivery_late_over_5_min, orders_cl.pct_delivery_late_over_10_min,
      orders_cl.pct_delivery_in_time, shyftplan_riders_pickers_hours.rider_utr,
      shyftplan_riders_pickers_hours.picker_utr, shyftplan_riders_pickers_hours.rider_hours,
      shyftplan_riders_pickers_hours.picker_hours]
    filters:
      orders_cl.created_date: 7 days ago for 7 days
      orders_cl.is_internal_order: 'no'
      orders_cl.is_successful_order: 'yes'
      orders_cl.warehouse_name: "-EMPTY"
    sorts: [orders_cl.cnt_orders desc]
    limit: 500
    column_limit: 50
    query_timezone: Europe/Berlin
    show_view_names: false
    show_row_numbers: false
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
      hubs.hub_name: left
      orders_cl.cnt_orders: left
    column_order: ["$$$_row_numbers_$$$", hubs.hub_name, orders_cl.cnt_orders, orders_cl.avg_order_value_gross,
      orders_cl.avg_fulfillment_time_mm_ss, orders_cl.pct_delivery_in_time, orders_cl.pct_delivery_late_over_5_min,
      orders_cl.pct_delivery_late_over_10_min, orders_cl.sum_gmv_gross, orders_cl.sum_discount_amt,
      orders_cl.cnt_unique_customers, orders_cl.cnt_unique_orders_new_customers,
      orders_cl.pct_discount_order_share, orders_cl.pct_discount_value_of_gross_total,
      orders_cl.avg_delivery_fee_gross]
    show_totals: true
    show_row_totals: true
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
      orders_cl.avg_riding_to_customer_time: 154
      orders_cl.cnt_orders: 113
      orders_cl.pct_discount_order_share: 117
      orders_cl.sum_discount_amt: 124
      orders_cl.pct_discount_value_of_gross_total: 117
      orders_cl.avg_delivery_fee_gross: 121
      orders_cl.avg_acceptance_time: 175
      orders_cl.sum_gmv_gross: 99
      orders_cl.avg_order_value_gross: 187
      orders_cl.pct_delivery_late_over_5_min: 112
      orders_cl.pct_delivery_late_over_10_min: 85
      wow: 74
      orders_cl.date: 162
      orders_cl.avg_fulfillment_time_mm_ss: 123
      orders_cl.warehouse_name: 150
      orders_cl.pct_delivery_in_time: 118
      hubs.hub_name: 113
      shyftplan_riders_pickers_hours.rider_utr: 81
      shyftplan_riders_pickers_hours.picker_utr: 75
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
      nps_after_order.nps_score:
        is_active: true
        palette:
          palette_id: b68c2e8f-2df8-89ad-7b29-bfc02506dee7
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
          custom_colors:
          - "#ffffff"
          - "#8be631"
      shyftplan_riders_pickers_hours.rider_utr:
        is_active: true
        palette:
          palette_id: 379b2697-e5b7-56f2-049f-d3adad8b5699
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
          custom_colors:
          - "#ffffff"
          - "#8be631"
      shyftplan_riders_pickers_hours.picker_utr:
        is_active: true
        palette:
          palette_id: d2a2f346-5d2f-6808-383c-056f0693aac7
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
          custom_colors:
          - "#ffffff"
          - "#8be631"
    series_text_format:
      wow:
        italic: true
        align: center
    header_font_color: ''
    conditional_formatting: [{type: greater than, value: 0, background_color: !!null '',
        font_color: "#16bf20", color_application: {collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2,
          custom: {id: 875cd87e-c531-33ad-d63e-49281cc2ca1f, label: Custom, type: continuous,
            stops: [{color: "#e61c14", offset: 0}, {color: "#FFFFFF", offset: 50},
              {color: "#27e81e", offset: 100}]}, options: {steps: 5, mirror: false,
            constraints: {min: {type: number, value: -1}, mid: {type: number, value: 0},
              max: {type: number, value: 1}}}}, bold: true, italic: false, strikethrough: false,
        fields: []}, {type: less than, value: 0, background_color: !!null '', font_color: "#EA4335",
        color_application: {collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2, palette_id: 4a00499b-c0fe-4b15-a304-4083c07ff4c4},
        bold: true, italic: false, strikethrough: false, fields: []}]
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
    row: 14
    col: 0
    width: 19
    height: 9
  - title: 24 hour Breakdown (Yesterday)
    name: 24 hour Breakdown (Yesterday)
    model: flink_v3
    explore: orders_customers
    type: looker_line
    fields: [orders_cl.cnt_orders, orders_cl.avg_fulfillment_time, orders_cl.order_date_30_min_bins,
      orders_cl.avg_picking_time, orders_cl.avg_riding_to_customer_time, orders_cl.avg_promised_eta,
      orders_cl.pct_delivery_in_time]
    filters:
      orders_cl.is_internal_order: 'no'
      orders_cl.is_successful_order: 'yes'
      orders_cl.created_date: yesterday
      orders_cl.created_day_of_week: ''
      orders_cl.warehouse_name: ''
    sorts: [orders_cl.order_date_30_min_bins]
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
    point_style: none
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    y_axes: [{label: '', orientation: left, series: [{axisId: orders_cl.cnt_orders,
            id: orders_cl.cnt_orders, name: "# Orders"}], showLabels: true, showValues: true,
        unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear},
      {label: !!null '', orientation: right, series: [{axisId: orders_cl.avg_promised_eta,
            id: orders_cl.avg_promised_eta, name: AVG Promised ETA}, {axisId: orders_cl.avg_fulfillment_time,
            id: orders_cl.avg_fulfillment_time, name: AVG Fulfillment Time (decimal)},
          {axisId: orders_cl.avg_picking_time, id: orders_cl.avg_picking_time,
            name: AVG Picking Time}, {axisId: orders_cl.avg_riding_to_customer_time, id: orders_cl.avg_riding_to_customer_time,
            name: AVG Riding To Customer Time}], showLabels: true, showValues: true, unpinAxis: false,
        tickDensity: default, tickDensityCustom: 5, type: linear}, {label: !!null '',
        orientation: right, series: [{axisId: orders_cl.pct_delivery_in_time, id: orders_cl.pct_delivery_in_time,
            name: "% Orders delivered in time"}], showLabels: true, showValues: true,
        unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear}]
    hidden_series: []
    series_types:
      orders_cl.cnt_orders: column
    series_colors:
      orders_cl.cnt_orders: "#78949c"
      orders_cl.avg_fulfillment_time: "#1A73E8"
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    hidden_fields: []
    listen:
      Country: hubs.country
      City: hubs.city
      Hub Name: hubs.hub_name
    row: 82
    col: 0
    width: 24
    height: 10
  - name: ''
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: "<img src=\"https://i.imgur.com/KcWQwrB.png\" width=\"25%\">  \n\n\
      <p>Here is your daily Hub KPI send out</p>"
    row: 0
    col: 0
    width: 24
    height: 4
  - name: Customer Retention
    type: text
    title_text: Customer Retention
    subtitle_text: ''
    body_text: |-
      The table below shows how many new customers were acquired per hub. It might be empty if the hub has been launched in the recent weeks and has not collected enough data.
      <p> <b>Customer Retention</b> shows the percentage of new customers that came back in the following week (or 2 weeks later).
      <br> <b>Order Frequency</b> shows how many orders the returning customers placed on average
      </p>
      <p>
      <i>Note: We only consider data up to 3 calendar weeks ago, otherwise we would include incomplete cohorts</i>
      </p>
    row: 92
    col: 0
    width: 24
    height: 5
  - name: NPS Comments - last 3 days
    title: NPS Comments - last 3 days
    model: flink_v3
    explore: orders_customers
    type: looker_grid
    fields: [orders_cl.created_date, nps_after_order.order_number, nps_after_order.submitted_date,
      nps_after_order.nps_driver, nps_after_order.nps_comment, hubs.hub_name, empty_filter,
      nps_after_order.nps_score, nps_after_order.score]
    filters:
      nps_after_order.score: NOT NULL
      nps_after_order.submitted_date: 3 days ago for 3 days
      orders_cl.is_internal_order: ''
      orders_cl.is_successful_order: ''
      orders_cl.created_date: ''
      empty_filter: 'Yes'
    sorts: [nps_after_order.submitted_date desc]
    limit: 5000
    column_limit: 50
    total: true
    dynamic_fields: [{dimension: empty_filter, label: empty_filter, expression: 'if((${nps_after_order.nps_comment}
          != "∅" OR ${nps_after_order.nps_driver} != "∅"), yes, no)', value_format: !!null '',
        value_format_name: !!null '', _kind_hint: dimension, _type_hint: yesno}]
    query_timezone: Europe/Berlin
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
    column_order: [nps_after_order.submitted_date, orders_cl.created_date, nps_after_order.order_number,
      hubs.hub_name, nps_after_order.score, nps_after_order.nps_driver, nps_after_order.nps_comment,
      nps_after_order.nps_score]
    show_totals: true
    show_row_totals: true
    series_column_widths:
      nps_after_order.submitted_date: 131
      nps_after_order.nps_driver: 443
      nps_after_order.score: 75
      orders_cl.created_date: 87
      nps_after_order.order_number: 88
      nps_after_order.nps_comment: 396
      hubs.hub_name: 99
      orders_cl.avg_promised_eta: 77
      orders_cl.avg_fulfillment_time: 112
      orders_cl.delivery_delay_since_eta: 98
      nps_after_order.pct_detractors: 100
      nps_after_order.nps_score: 75
      nps_after_order.pct_passives: 94
      nps_after_order.pct_promoters: 76
    series_cell_visualizations:
      nps_after_order.cnt_responses:
        is_active: true
      nps_after_order.score:
        is_active: true
      nps_after_order.nps_score:
        is_active: false
    series_value_format:
      nps_after_order.nps_score:
        name: percent_0
        format_string: "#,##0%"
        label: Percent (0)
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
    y_axes: [{label: '', orientation: left, series: [{axisId: nps_after_order.nps_score,
            id: nps_after_order.nps_score, name: "% NPS"}], showLabels: true, showValues: true,
        unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear},
      {label: !!null '', orientation: left, series: [{axisId: nps_after_order.count,
            id: nps_after_order.count, name: NPS After Order}], showLabels: true,
        showValues: true, unpinAxis: false, tickDensity: default, tickDensityCustom: 5,
        type: linear}]
    series_types: {}
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    hidden_fields: [empty_filter]
    title_hidden: true
    listen:
      Country: hubs.country
      City: hubs.city
      Hub Name: hubs.hub_name
    row: 55
    col: 0
    width: 24
    height: 12
  - title: Customer Retention by Hub (Weekly)
    name: Customer Retention by Hub (Weekly)
    model: flink_v3
    explore: orders_customers
    type: looker_grid
    fields: [customers_metrics.first_order_hub, customers_metrics.weeks_time_since_sign_up, orders_cl.cnt_orders,
      orders_cl.cnt_unique_customers, filter_empty]
    pivots: [customers_metrics.weeks_time_since_sign_up]
    filters:
      orders_cl.is_internal_order: 'no'
      orders_cl.is_successful_order: 'yes'
      orders_cl.created_date: after 2020/01/25
      customers_metrics.first_order_week: before 3 weeks ago
      customers_metrics.first_order_hub: ''
      customers_metrics.is_discount_acquisition: ''
      customers_metrics.weeks_time_since_sign_up: "<=2"
      filter_empty: 'Yes'
    sorts: [customers_metrics.weeks_time_since_sign_up, orders_cl.cnt_unique_customers
        desc 0]
    limit: 500
    column_limit: 50
    total: true
    dynamic_fields: [{table_calculation: pcnt_of_cohort_still_active, label: Pcnt
          of Cohort still Active, expression: "${orders_cl.cnt_unique_customers}/pivot_index(${orders_cl.cnt_unique_customers},1)",
        value_format: !!null '', value_format_name: percent_1, _kind_hint: measure,
        _type_hint: number}, {table_calculation: order_frequency, label: Order Frequency,
        expression: "${orders_cl.cnt_orders}/${orders_cl.cnt_unique_customers}",
        value_format: !!null '', value_format_name: decimal_2, _kind_hint: measure,
        _type_hint: number}, {dimension: filter_empty, label: filter_empty, expression: 'if(${customers_metrics.first_order_hub}!="ø",
          yes, no)', value_format: !!null '', value_format_name: !!null '', _kind_hint: dimension,
        _type_hint: yesno}]
    show_view_names: false
    show_row_numbers: false
    transpose: false
    truncate_text: false
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: editable
    limit_displayed_rows: false
    enable_conditional_formatting: true
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    column_order: [customers_metrics.first_order_hub, 0|FIELD|2021-01-18_pcnt_of_cohort_still_active,
      0|FIELD|2021-01-25_pcnt_of_cohort_still_active, 0|FIELD|2021-02-01_pcnt_of_cohort_still_active,
      0|FIELD|2021-02-08_pcnt_of_cohort_still_active, 0|FIELD|2021-02-15_pcnt_of_cohort_still_active,
      0|FIELD|2021-02-22_pcnt_of_cohort_still_active, 0|FIELD|2021-03-01_pcnt_of_cohort_still_active,
      1|FIELD|2021-01-18_pcnt_of_cohort_still_active, 1|FIELD|2021-01-25_pcnt_of_cohort_still_active,
      1|FIELD|2021-02-01_pcnt_of_cohort_still_active, 1|FIELD|2021-02-08_pcnt_of_cohort_still_active,
      1|FIELD|2021-02-15_pcnt_of_cohort_still_active, 1|FIELD|2021-02-22_pcnt_of_cohort_still_active,
      1|FIELD|2021-03-01_pcnt_of_cohort_still_active]
    show_totals: true
    show_row_totals: true
    series_column_widths:
      customers_metrics.first_order_week: 178
      pcnt_of_cohort_still_active: 110
      weekly_cohorts_stable_base.cnt_unique_customers: 137
      customers_metrics.first_order_hub: 227
      orders_cl.cnt_unique_customers: 121
      order_frequency: 97
    series_cell_visualizations:
      pcnt_of_cohort_still_active:
        is_active: false
        value_display: true
        palette:
          palette_id: 56d0c358-10a0-4fd6-aa0b-b117bef527ab
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      orders_cl.cnt_unique_customers:
        is_active: true
        palette:
          palette_id: 4a00499b-c0fe-4b15-a304-4083c07ff4c4
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      order_frequency:
        is_active: false
    series_text_format:
      pcnt_of_cohort_still_active: {}
    header_font_color: ''
    conditional_formatting: [{type: along a scale..., value: !!null '', background_color: "#1A73E8",
        font_color: !!null '', color_application: {collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2,
          palette_id: 56d0c358-10a0-4fd6-aa0b-b117bef527ab}, bold: false, italic: false,
        strikethrough: false, fields: [pcnt_of_cohort_still_active]}, {type: along
          a scale..., value: !!null '', background_color: "#1A73E8", font_color: !!null '',
        color_application: {collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2, palette_id: 56d0c358-10a0-4fd6-aa0b-b117bef527ab,
          options: {steps: 5}}, bold: false, italic: false, strikethrough: false,
        fields: [order_frequency]}]
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
    hidden_fields: [orders_cl.cnt_orders, filter_empty]
    y_axes: []
    title_hidden: true
    listen:
      Country: customers_metrics.country
      City: customers_metrics.first_order_city
      Hub Name: customers_metrics.first_order_hub
    row: 97
    col: 0
    width: 23
    height: 14
  - name: NPS - Timeseries
    title: NPS - Timeseries
    model: flink_v3
    explore: orders_customers
    type: looker_line
    fields: [orders_cl.created_date, nps_after_order.pct_passives, nps_after_order.pct_detractors,
      nps_after_order.pct_promoters, nps_after_order.cnt_responses, nps_after_order.nps_score]
    filters:
      orders_cl.is_internal_order: ''
      orders_cl.is_successful_order: ''
      orders_cl.created_date: 28 days ago for 28 days
    sorts: [orders_cl.created_date desc]
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
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    y_axes: [{label: '', orientation: left, series: [{axisId: nps_after_order.cnt_responses,
            id: nps_after_order.cnt_responses, name: "# NPS Responses"}], showLabels: true,
        showValues: true, unpinAxis: false, tickDensity: default, type: linear}, {
        label: '', orientation: right, series: [{axisId: nps_after_order.nps_score,
            id: nps_after_order.nps_score, name: "% NPS"}], showLabels: true, showValues: true,
        unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear}]
    series_types:
      nps_after_order.cnt_responses: column
    reference_lines: []
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    hidden_fields: [nps_after_order.pct_promoters, nps_after_order.pct_detractors,
      nps_after_order.pct_passives]
    listen:
      Country: hubs.country
      City: hubs.city
      Hub Name: hubs.hub_name
    row: 45
    col: 0
    width: 24
    height: 7
  - name: All time NPS
    title: All time NPS
    model: flink_v3
    explore: orders_customers
    type: marketplace_viz_radial_gauge::radial_gauge-marketplace
    fields: [nps_after_order.nps_score]
    filters:
      hubs.country: ''
      orders_cl.is_internal_order: ''
      orders_cl.is_successful_order: ''
      orders_cl.created_date: after 2021/01/25
    limit: 500
    column_limit: 50
    total: true
    query_timezone: Europe/Berlin
    hidden_fields: []
    hidden_points_if_no: []
    series_labels: {}
    show_view_names: false
    arm_length: 9
    arm_weight: 48
    spinner_length: 153
    spinner_weight: 25
    target_length: 10
    target_gap: 10
    target_weight: 25
    range_min: 0
    range_max: 1
    value_label_type: both
    value_label_font: 12
    value_label_padding: 45
    target_source: 'off'
    target_label_type: both
    target_label_font: 3
    label_font_size: 5
    range_formatting: 0%
    spinner_type: needle
    fill_color: "#0092E5"
    background_color: "#CECECE"
    spinner_color: "#282828"
    range_color: "#282828"
    gauge_fill_type: segment
    fill_colors: ["#EE7772", "#ffed6f", "#7FCDAE"]
    viz_trellis_by: none
    trellis_rows: 2
    trellis_cols: 2
    angle: 90
    cutout: 30
    range_x: 1.6
    range_y: 1.4
    target_label_padding: 1.06
    custom_color_enabled: true
    show_single_value_title: false
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    custom_color: "#7CB342"
    single_value_title: ''
    conditional_formatting: [{type: equal to, value: !!null '', background_color: "#1A73E8",
        font_color: !!null '', color_application: {collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2,
          palette_id: 56d0c358-10a0-4fd6-aa0b-b117bef527ab}, bold: false, italic: false,
        strikethrough: false, fields: !!null ''}]
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
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    y_axes: [{label: '', orientation: left, series: [{axisId: nps_after_order.nps_score,
            id: nps_after_order.nps_score, name: "% NPS"}], showLabels: true, showValues: true,
        unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear},
      {label: !!null '', orientation: left, series: [{axisId: nps_after_order.count,
            id: nps_after_order.count, name: NPS After Order}], showLabels: true,
        showValues: true, unpinAxis: false, tickDensity: default, tickDensityCustom: 5,
        type: linear}]
    series_types: {}
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 0
    listen:
      City: hubs.city
      Hub Name: hubs.hub_name
    row: 39
    col: 0
    width: 8
    height: 6
  - name: NPS Comments
    type: text
    title_text: NPS Comments
    subtitle_text: ''
    body_text: "The table below shows customer responses to our NPS survey. \n<p>\
      \ <i>Note: Responses with empty comments are excluded below. Only comments from\
      \ the last 3 days are shown.</i></p>"
    row: 52
    col: 0
    width: 24
    height: 3
  - name: Logistics KPIs - Yesterday
    title: Logistics KPIs - Yesterday
    model: flink_v3
    explore: orders_customers
    type: looker_grid
    fields: [hubs.hub_name, orders_cl.cnt_orders, orders_cl.avg_fulfillment_time_mm_ss,
      orders_cl.pct_delivery_late_over_5_min, orders_cl.pct_delivery_late_over_10_min,
      orders_cl.pct_delivery_in_time, shyftplan_riders_pickers_hours.rider_utr,
      shyftplan_riders_pickers_hours.picker_utr, shyftplan_riders_pickers_hours.rider_hours,
      shyftplan_riders_pickers_hours.picker_hours]
    filters:
      orders_cl.is_internal_order: 'no'
      orders_cl.is_successful_order: 'yes'
      orders_cl.created_date: yesterday
      orders_cl.warehouse_name: "-EMPTY"
    sorts: [orders_cl.cnt_orders desc]
    limit: 500
    column_limit: 50
    query_timezone: Europe/Berlin
    show_view_names: false
    show_row_numbers: false
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
      hubs.hub_name: left
      orders_cl.cnt_orders: left
    column_order: ["$$$_row_numbers_$$$", hubs.hub_name, orders_cl.cnt_orders, orders_cl.avg_order_value_gross,
      orders_cl.avg_fulfillment_time_mm_ss, orders_cl.pct_delivery_in_time, orders_cl.pct_delivery_late_over_5_min,
      orders_cl.pct_delivery_late_over_10_min, orders_cl.sum_gmv_gross, orders_cl.sum_discount_amt,
      orders_cl.cnt_unique_customers, orders_cl.cnt_unique_orders_new_customers,
      orders_cl.pct_discount_order_share, orders_cl.pct_discount_value_of_gross_total,
      orders_cl.avg_delivery_fee_gross]
    show_totals: true
    show_row_totals: true
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
      orders_cl.avg_riding_to_customer_time: 154
      orders_cl.cnt_orders: 117
      orders_cl.pct_discount_order_share: 117
      orders_cl.sum_discount_amt: 124
      orders_cl.pct_discount_value_of_gross_total: 117
      orders_cl.avg_delivery_fee_gross: 121
      orders_cl.avg_acceptance_time: 175
      orders_cl.sum_gmv_gross: 99
      orders_cl.avg_order_value_gross: 187
      orders_cl.pct_delivery_late_over_5_min: 94
      orders_cl.pct_delivery_late_over_10_min: 97
      wow: 74
      orders_cl.date: 162
      orders_cl.avg_fulfillment_time_mm_ss: 123
      orders_cl.warehouse_name: 150
      orders_cl.pct_delivery_in_time: 126
      hubs.hub_name: 99
      shyftplan_riders_pickers_hours.rider_utr: 77
      shyftplan_riders_pickers_hours.picker_utr: 83
      shyftplan_riders_pickers_hours.rider_hours: 93
      shyftplan_riders_pickers_hours.picker_hours: 82
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
      nps_after_order.nps_score:
        is_active: true
        palette:
          palette_id: b68c2e8f-2df8-89ad-7b29-bfc02506dee7
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
          custom_colors:
          - "#ffffff"
          - "#8be631"
      shyftplan_riders_pickers_hours.rider_utr:
        is_active: true
        palette:
          palette_id: b6f40465-1456-bc4e-a0fe-6a048540d863
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
          custom_colors:
          - "#ffffff"
          - "#8be631"
      shyftplan_riders_pickers_hours.picker_utr:
        is_active: true
        palette:
          palette_id: 15013d95-3258-1a7e-4141-84cc77ee5609
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
          custom_colors:
          - "#ffffff"
          - "#8be631"
    series_text_format:
      wow:
        italic: true
        align: center
    header_font_color: ''
    conditional_formatting: [{type: greater than, value: 0, background_color: !!null '',
        font_color: "#16bf20", color_application: {collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2,
          custom: {id: 875cd87e-c531-33ad-d63e-49281cc2ca1f, label: Custom, type: continuous,
            stops: [{color: "#e61c14", offset: 0}, {color: "#FFFFFF", offset: 50},
              {color: "#27e81e", offset: 100}]}, options: {steps: 5, mirror: false,
            constraints: {min: {type: number, value: -1}, mid: {type: number, value: 0},
              max: {type: number, value: 1}}}}, bold: true, italic: false, strikethrough: false,
        fields: []}, {type: less than, value: 0, background_color: !!null '', font_color: "#EA4335",
        color_application: {collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2, palette_id: 4a00499b-c0fe-4b15-a304-4083c07ff4c4},
        bold: true, italic: false, strikethrough: false, fields: []}]
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
    row: 4
    col: 0
    width: 19
    height: 10
  - name: 30 days NPS
    title: 30 days NPS
    model: flink_v3
    explore: orders_customers
    type: marketplace_viz_radial_gauge::radial_gauge-marketplace
    fields: [nps_after_order.nps_score]
    filters:
      hubs.country: ''
      orders_cl.is_internal_order: ''
      orders_cl.is_successful_order: ''
      orders_cl.created_date: 30 days
    limit: 500
    column_limit: 50
    total: true
    query_timezone: Europe/Berlin
    hidden_fields: []
    hidden_points_if_no: []
    series_labels: {}
    show_view_names: false
    arm_length: 9
    arm_weight: 48
    spinner_length: 153
    spinner_weight: 25
    target_length: 10
    target_gap: 10
    target_weight: 25
    range_min: 0
    range_max: 1
    value_label_type: both
    value_label_font: 12
    value_label_padding: 45
    target_source: 'off'
    target_label_type: both
    target_label_font: 3
    label_font_size: 5
    range_formatting: 0%
    spinner_type: needle
    fill_color: "#0092E5"
    background_color: "#CECECE"
    spinner_color: "#282828"
    range_color: "#282828"
    gauge_fill_type: segment
    fill_colors: ["#EE7772", "#ffed6f", "#7FCDAE"]
    viz_trellis_by: none
    trellis_rows: 2
    trellis_cols: 2
    angle: 90
    cutout: 30
    range_x: 1.6
    range_y: 1.4
    target_label_padding: 1.06
    custom_color_enabled: true
    show_single_value_title: false
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    custom_color: "#7CB342"
    single_value_title: ''
    conditional_formatting: [{type: equal to, value: !!null '', background_color: "#1A73E8",
        font_color: !!null '', color_application: {collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2,
          palette_id: 56d0c358-10a0-4fd6-aa0b-b117bef527ab}, bold: false, italic: false,
        strikethrough: false, fields: !!null ''}]
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
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    y_axes: [{label: '', orientation: left, series: [{axisId: nps_after_order.nps_score,
            id: nps_after_order.nps_score, name: "% NPS"}], showLabels: true, showValues: true,
        unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear},
      {label: !!null '', orientation: left, series: [{axisId: nps_after_order.count,
            id: nps_after_order.count, name: NPS After Order}], showLabels: true,
        showValues: true, unpinAxis: false, tickDensity: default, tickDensityCustom: 5,
        type: linear}]
    series_types: {}
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 0
    listen:
      City: hubs.city
      Hub Name: hubs.hub_name
    row: 39
    col: 8
    width: 8
    height: 6
  - name: 7 days NPS
    title: 7 days NPS
    model: flink_v3
    explore: orders_customers
    type: marketplace_viz_radial_gauge::radial_gauge-marketplace
    fields: [nps_after_order.nps_score]
    filters:
      hubs.country: ''
      orders_cl.is_internal_order: ''
      orders_cl.is_successful_order: ''
      orders_cl.created_date: 7 days
    limit: 500
    column_limit: 50
    total: true
    query_timezone: Europe/Berlin
    hidden_fields: []
    hidden_points_if_no: []
    series_labels: {}
    show_view_names: false
    arm_length: 9
    arm_weight: 48
    spinner_length: 153
    spinner_weight: 25
    target_length: 10
    target_gap: 10
    target_weight: 25
    range_min: 0
    range_max: 1
    value_label_type: both
    value_label_font: 12
    value_label_padding: 45
    target_source: 'off'
    target_label_type: both
    target_label_font: 3
    label_font_size: 5
    range_formatting: 0%
    spinner_type: needle
    fill_color: "#0092E5"
    background_color: "#CECECE"
    spinner_color: "#282828"
    range_color: "#282828"
    gauge_fill_type: segment
    fill_colors: ["#EE7772", "#ffed6f", "#7FCDAE"]
    viz_trellis_by: none
    trellis_rows: 2
    trellis_cols: 2
    angle: 90
    cutout: 30
    range_x: 1.6
    range_y: 1.4
    target_label_padding: 1.06
    custom_color_enabled: true
    show_single_value_title: false
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    custom_color: "#7CB342"
    single_value_title: ''
    conditional_formatting: [{type: equal to, value: !!null '', background_color: "#1A73E8",
        font_color: !!null '', color_application: {collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2,
          palette_id: 56d0c358-10a0-4fd6-aa0b-b117bef527ab}, bold: false, italic: false,
        strikethrough: false, fields: !!null ''}]
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
    limit_displayed_rows: false
    legend_position: center
    point_style: none
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    y_axes: [{label: '', orientation: left, series: [{axisId: nps_after_order.nps_score,
            id: nps_after_order.nps_score, name: "% NPS"}], showLabels: true, showValues: true,
        unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear},
      {label: !!null '', orientation: left, series: [{axisId: nps_after_order.count,
            id: nps_after_order.count, name: NPS After Order}], showLabels: true,
        showValues: true, unpinAxis: false, tickDensity: default, tickDensityCustom: 5,
        type: linear}]
    series_types: {}
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 0
    listen:
      City: hubs.city
      Hub Name: hubs.hub_name
    row: 39
    col: 16
    width: 8
    height: 6
  - name: Post Delivery Issues
    title: Post Delivery Issues
    model: flink_v3
    explore: orders_cl
    type: looker_column
    fields: [cs_post_delivery_issues.cnt_issues_missing_product, cs_post_delivery_issues.cnt_issues_perished_product,
      cs_post_delivery_issues.cnt_issues_wrong_order, cs_post_delivery_issues.cnt_issues_wrong_product,
      cs_post_delivery_issues.cnt_issues, cs_post_delivery_issues.cnt_issues_damaged,
      orders_cl.created_date]
    fill_fields: [orders_cl.created_date]
    filters:
      cs_post_delivery_issues.problem_group: "-EMPTY"
      orders_cl.created_date: 7 days ago for 7 days
    sorts: [orders_cl.created_date]
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
    series_types:
      cs_post_delivery_issues.cnt_issues: scatter
    series_point_styles:
      cs_post_delivery_issues.cnt_issues: diamond
    defaults_version: 1
    hidden_fields: []
    y_axes: []
    listen:
      Country: hubs.country
      City: hubs.city
      Hub Name: hubs.hub_name
    row: 23
    col: 0
    width: 24
    height: 6
  - title: Post Delivery Issues - Yesterday (Detailed)
    name: Post Delivery Issues - Yesterday (Detailed)
    model: flink_v3
    explore: orders_cl
    type: looker_grid
    fields: [hubs.hub_code, orders_cl.created_time, cs_post_delivery_issues.ticket_date,
      cs_post_delivery_issues.order_nr_, cs_post_delivery_issues.problem_group, cs_post_delivery_issues.ordered_product,
      cs_post_delivery_issues.delivered_product]
    filters:
      hubs.country: ''
      cs_post_delivery_issues.ticket_date: 1 days ago for 1 days
    sorts: [cs_post_delivery_issues.ticket_date desc]
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
    series_types: {}
    defaults_version: 1
    column_order: ["$$$_row_numbers_$$$", hubs.hub_code, orders_cl.created_time,
      cs_post_delivery_issues.ticket_date, cs_post_delivery_issues.order_nr_, cs_post_delivery_issues.problem_group,
      cs_post_delivery_issues.ordered_product, cs_post_delivery_issues.delivered_product]
    series_column_widths:
      cs_post_delivery_issues.ticket_date: 103
      cs_post_delivery_issues.hub: 136
      cs_post_delivery_issues.order_nr_: 98
      cs_post_delivery_issues.problem_group: 160
      hubs.hub_code: 127
      orders_cl.created_time: 146
    hidden_fields: []
    y_axes: []
    listen:
      Hub Name: hubs.hub_name
    row: 29
    col: 0
    width: 24
    height: 10
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
      type: dropdown_menu
      display: inline
      options: []
    model: flink_v3
    explore: orders_cl
    listens_to_filters: []
    field: hubs.city
  - name: Hub Name
    title: Hub Name
    type: field_filter
    default_value: DE - Berlin - Friedrichshain
    allow_multiple_values: true
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
      options: []
    model: flink_v3
    explore: orders_cl
    listens_to_filters: []
    field: hubs.hub_name
