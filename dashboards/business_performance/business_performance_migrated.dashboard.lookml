- dashboard: business_performance_migrated
  title: Daily/Weekly/Monthly Business Performance
  layout: newspaper
  preferred_viewer: dashboards-next
  elements:
  - name: Orders by Customer Type
    title: Orders by Customer Type
    model: flink_v3
    explore: orders_cl
    type: looker_column
    fields: [orders_cl.cnt_unique_orders_existing_customers, orders_cl.cnt_unique_orders_new_customers,
      orders_cl.pct_discount_order_share, orders_cl.pct_acquisition_share, orders_cl.date]
    filters:
      orders_cl.is_internal_order: 'no'
      orders_cl.is_successful_order: 'yes'
    sorts: [orders_cl.date]
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
    y_axes: [{label: "# Orders", orientation: left, series: [{axisId: orders_cl.cnt_unique_orders_existing_customers,
            id: orders_cl.cnt_unique_orders_existing_customers, name: "# Orders\
              \ Existing Customers"}, {axisId: orders_cl.cnt_unique_orders_new_customers,
            id: orders_cl.cnt_unique_orders_new_customers, name: "# Orders New Customers"}],
        showLabels: true, showValues: true, unpinAxis: false, tickDensity: default,
        type: linear}, {label: '', orientation: right, series: [{axisId: orders_cl.pct_acquisition_share,
            id: orders_cl.pct_acquisition_share, name: "% Acquisition Share"}, {
            axisId: orders_cl.pct_discount_order_share, id: orders_cl.pct_discount_order_share,
            name: "% Discount Order Share"}], showLabels: true, showValues: true,
        unpinAxis: false, tickDensity: default, type: linear}]
    series_types:
      orders_cl.pct_discount_order_share: line
      orders_cl.pct_acquisition_share: line
    series_colors:
      orders_cl.cnt_orders: "#F9AB00"
      orders_cl.avg_fulfillment_time: "#1A73E8"
      orders_cl.sum_revenue_gross: "#F9AB00"
      orders_cl.avg_basket_size_gross: "#1A73E8"
      orders_cl.pct_acquisition_share: "#7CB342"
      orders_cl.pct_discount_order_share: "#EA4335"
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    hidden_fields: []
    listen:
      Order Day of Week: orders_cl.created_day_of_week
      Country: hubs.country
      Order Date: orders_cl.created_date
      City: hubs.city
      Hub Name: hubs.hub_name
      Date Granularity: orders_cl.date_granularity
    row: 13
    col: 8
    width: 8
    height: 6
  - name: ''
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: |
      ##### Please see [here](https://docs.google.com/spreadsheets/d/1iN3CkrM8cYLnp6UEce-34c_ziF9p_sxhfEW3oDyfD_k/edit#gid=0) for Data Glossary with all KPI definitions.

      Note that now you can switch between Daily/Weekly/Monthly date granularity (top right corner).

      **"PoP"** stands for **"Period over Period"**, because depending on the chosen date granularity, it will represent something different.

      * In the *Daily* report, it represents WoW (e.g. yesterday vs. same day last week)
      * In *Weekly* mode, it represents WoW (week versus previous full week)
      * In *Monthly* mode, it represents MoM (month versus previous full month)
    row: 0
    col: 8
    width: 15
    height: 4
  - name: Daily Orders
    title: Daily Orders
    model: flink_v3
    explore: orders_cl
    type: looker_grid
    fields: [orders_cl.date_granularity_pass_through, orders_cl.date, orders_cl.cnt_orders,
      orders_cl.cnt_unique_orders_new_customers, orders_cl.cnt_unique_customers,
      orders_cl.sum_gmv_gross, orders_cl.avg_order_value_gross, orders_cl.pct_discount_order_share,
      orders_cl.avg_fulfillment_time_mm_ss, orders_cl.sum_discount_amt, orders_cl.pct_discount_value_of_gross_total,
      orders_cl.avg_delivery_fee_gross, orders_cl.pct_delivery_late_over_5_min,
      orders_cl.pct_delivery_late_over_10_min, orders_cl.pct_delivery_in_time,
      shyftplan_riders_pickers_hours.rider_utr, shyftplan_riders_pickers_hours.picker_utr]
    filters:
      orders_cl.is_internal_order: 'no'
      orders_cl.is_successful_order: 'yes'
    sorts: [orders_cl.date desc]
    limit: 500
    dynamic_fields: [{_kind_hint: measure, table_calculation: pop, _type_hint: number,
        category: table_calculation, expression: "case(when(diff_days(to_date(${orders_cl.date}),offset(to_date(${orders_cl.date}),7))\
          \ = null,null),\n  \n  when(${orders_cl.date_granularity_pass_through}\
          \ = \"Day\" \n    AND diff_days(to_date(${orders_cl.date}),offset(to_date(${orders_cl.date}),7))\
          \ = -7,\n    ( ${orders_cl.cnt_orders} - offset(${orders_cl.cnt_orders},\
          \ 7) ) / offset(${orders_cl.cnt_orders}, 7)),\n  when(${orders_cl.date_granularity_pass_through}\
          \ = \"Day\"  AND offset(to_date(${orders_cl.date}),7) = null,null),\n\
          \  when(${orders_cl.date_granularity_pass_through} = \"Day\" \n    AND\
          \ diff_days(to_date(${orders_cl.date}),\n      offset(to_date(${orders_cl.date}),7))\
          \ != -7,( ${orders_cl.cnt_orders} - offset(${orders_cl.cnt_orders},\
          \ 6) ) / offset(${orders_cl.cnt_orders}, 6)),\n  when(${orders_cl.date_granularity_pass_through}\
          \ = \"Week\" OR ${orders_cl.date_granularity_pass_through} = \"Month\"\
          , \n  ( ${orders_cl.cnt_orders} - offset(${orders_cl.cnt_orders}, 1)\
          \ ) / offset(${orders_cl.cnt_orders}, 1)),null)", label: PoP, value_format: '"▲  "+0%;
          "▼  "-0%; 0', value_format_name: !!null ''}, {_kind_hint: measure, table_calculation: pop_gmv,
        _type_hint: number, category: table_calculation, expression: "\n\ncase(when(diff_days(to_date(${orders_cl.date}),offset(to_date(${orders_cl.date}),7))\
          \ = null,null),\n  \n  when(${orders_cl.date_granularity_pass_through}\
          \ = \"Day\" \n    AND diff_days(to_date(${orders_cl.date}),offset(to_date(${orders_cl.date}),7))\
          \ = -7,\n    ( ${orders_cl.sum_gmv_gross} - offset(${orders_cl.sum_gmv_gross},\
          \ 7) ) / offset(${orders_cl.sum_gmv_gross}, 7)),\n  when(${orders_cl.date_granularity_pass_through}\
          \ = \"Day\"  AND offset(to_date(${orders_cl.date}),7) = null,null),\n\
          \  when(${orders_cl.date_granularity_pass_through} = \"Day\" \n    AND\
          \ diff_days(to_date(${orders_cl.date}),\n      offset(to_date(${orders_cl.date}),7))\
          \ != -7,( ${orders_cl.sum_gmv_gross} - offset(${orders_cl.sum_gmv_gross},\
          \ 6) ) / offset(${orders_cl.sum_gmv_gross}, 6)),\n  when(${orders_cl.date_granularity_pass_through}\
          \ = \"Week\" OR ${orders_cl.date_granularity_pass_through} = \"Month\"\
          , \n  ( ${orders_cl.sum_gmv_gross} - offset(${orders_cl.sum_gmv_gross},\
          \ 1) ) / offset(${orders_cl.sum_gmv_gross}, 1)),null)", label: PoP (GMV),
        value_format: '"▲  "+0%; "▼  "-0%; 0', value_format_name: !!null ''}]
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
      orders_cl.date: left
      orders_cl.cnt_orders: left
      pop: left
    column_order: ["$$$_row_numbers_$$$", orders_cl.date, orders_cl.cnt_orders,
      pop, orders_cl.avg_order_value_gross, orders_cl.avg_fulfillment_time_mm_ss,
      orders_cl.pct_delivery_in_time, orders_cl.pct_delivery_late_over_5_min,
      orders_cl.pct_delivery_late_over_10_min, shyftplan_riders_pickers_hours.rider_utr,
      shyftplan_riders_pickers_hours.picker_utr, orders_cl.sum_gmv_gross, pop_gmv,
      orders_cl.sum_discount_amt, orders_cl.cnt_unique_customers, orders_cl.cnt_unique_orders_new_customers,
      orders_cl.pct_discount_order_share, orders_cl.pct_discount_value_of_gross_total,
      orders_cl.avg_delivery_fee_gross]
    show_totals: true
    show_row_totals: true
    series_column_widths:
      orders_cl.created_date: 107
      orders_cl.cnt_unique_orders: 101
      orders_cl.cnt_unique_orders_new_customers: 116
      orders_cl.cnt_unique_orders_existing_customers: 147
      orders_cl.cnt_unique_customers: 97
      orders_cl.avg_basket_size_gross: 211
      orders_cl.sum_revenue_gross: 173
      orders_cl.avg_reaction_time: 115
      orders_cl.avg_picking_time: 106
      orders_cl.avg_fulfillment_time: 169
      orders_cl.avg_delivery_time: 154
      orders_cl.cnt_orders: 102
      orders_cl.pct_discount_order_share: 110
      orders_cl.sum_discount_amt: 117
      orders_cl.pct_discount_value_of_gross_total: 106
      orders_cl.avg_delivery_fee_gross: 121
      orders_cl.avg_acceptance_time: 175
      orders_cl.sum_gmv_gross: 92
      orders_cl.avg_order_value_gross: 131
      orders_cl.pct_delivery_late_over_5_min: 106
      orders_cl.pct_delivery_late_over_10_min: 103
      wow: 86
      orders_cl.date: 162
      orders_cl.avg_fulfillment_time_mm_ss: 142
      orders_cl.pct_delivery_in_time: 96
      wow_gmv: 77
      shyftplan_riders_pickers_hours.rider_utr: 79
      shyftplan_riders_pickers_hours.picker_utr: 80
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
          palette_id: 8f7dc6b2-5328-e9ee-721c-335c43e6ecc5
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
          custom_colors:
          - "#ffffff"
          - "#8be631"
      shyftplan_riders_pickers_hours.rider_utr:
        is_active: true
        palette:
          palette_id: 32ddf646-1409-43fd-1155-e46f4a32389e
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
          custom_colors:
          - "#ffffff"
          - "#8be631"
      shyftplan_riders_pickers_hours.picker_utr:
        is_active: true
        palette:
          palette_id: fd5a79ec-7acd-9867-526a-bbab20ea6210
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
        fields: [pop_gmv, pop]}, {type: less than, value: 0, background_color: !!null '',
        font_color: "#EA4335", color_application: {collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2,
          palette_id: 4a00499b-c0fe-4b15-a304-4083c07ff4c4}, bold: true, italic: false,
        strikethrough: false, fields: [pop_gmv, pop]}]
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
    hidden_fields: [orders_cl.date_granularity_pass_through]
    y_axes: []
    listen:
      Order Day of Week: orders_cl.created_day_of_week
      Country: hubs.country
      Order Date: orders_cl.created_date
      City: hubs.city
      Hub Name: hubs.hub_name
      Date Granularity: orders_cl.date_granularity
    row: 6
    col: 0
    width: 24
    height: 7
  - name: GMV vs AOV
    title: GMV vs AOV
    model: flink_v3
    explore: orders_cl
    type: looker_line
    fields: [orders_cl.sum_gmv_gross, orders_cl.avg_order_value_gross, orders_cl.date]
    filters:
      orders_cl.is_internal_order: 'no'
      orders_cl.is_successful_order: 'yes'
    sorts: [orders_cl.date]
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
    point_style: none
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    y_axes: [{label: '', orientation: left, series: [{axisId: orders_cl.avg_order_value_gross,
            id: orders_cl.avg_order_value_gross, name: AVG Basket Size (Gross)}],
        showLabels: true, showValues: true, unpinAxis: false, tickDensity: default,
        type: linear}, {label: '', orientation: right, series: [{axisId: orders_cl.sum_gmv_gross,
            id: orders_cl.sum_gmv_gross, name: SUM Revenue (Gross)}], showLabels: true,
        showValues: true, unpinAxis: false, tickDensity: default, type: linear}]
    series_types:
      orders_cl.sum_gmv_gross: column
    series_colors:
      orders_cl.cnt_orders: "#F9AB00"
      orders_cl.avg_fulfillment_time: "#1A73E8"
      orders_cl.avg_order_value_gross: "#1A73E8"
      orders_cl.sum_gmv_gross: "#F9AB00"
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    hidden_fields: []
    listen:
      Order Day of Week: orders_cl.created_day_of_week
      Country: hubs.country
      Order Date: orders_cl.created_date
      City: hubs.city
      Hub Name: hubs.hub_name
      Date Granularity: orders_cl.date_granularity
    row: 13
    col: 0
    width: 8
    height: 6
  - name: Orders vs Fulfillment Time
    title: Orders vs Fulfillment Time
    model: flink_v3
    explore: orders_cl
    type: looker_line
    fields: [orders_cl.cnt_orders, orders_cl.avg_fulfillment_time, orders_cl.avg_promised_eta,
      orders_cl.date]
    filters:
      orders_cl.is_internal_order: 'no'
      orders_cl.is_successful_order: 'yes'
    sorts: [orders_cl.date]
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
    show_null_points: true
    interpolation: linear
    y_axes: [{label: '', orientation: left, series: [{axisId: orders_cl.cnt_orders,
            id: orders_cl.cnt_orders, name: "# Orders"}], showLabels: true, showValues: true,
        unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear},
      {label: !!null '', orientation: right, series: [{axisId: orders_cl.avg_fulfillment_time,
            id: orders_cl.avg_fulfillment_time, name: AVG Fulfillment Time (decimal)},
          {axisId: orders_cl.avg_promised_eta, id: orders_cl.avg_promised_eta,
            name: AVG PDT}], showLabels: true, showValues: true, unpinAxis: false,
        tickDensity: default, tickDensityCustom: 5, type: linear}]
    series_types:
      orders_cl.cnt_orders: column
    series_colors:
      orders_cl.cnt_orders: "#F9AB00"
      orders_cl.avg_fulfillment_time: "#1A73E8"
      orders_cl.avg_promised_eta: "#7CB342"
    series_labels:
      orders_cl.avg_fulfillment_time: AVG Fulfillment Time (dec.)
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    hidden_fields: []
    listen:
      Order Day of Week: orders_cl.created_day_of_week
      Country: hubs.country
      Order Date: orders_cl.created_date
      City: hubs.city
      Hub Name: hubs.hub_name
      Date Granularity: orders_cl.date_granularity
    row: 13
    col: 16
    width: 8
    height: 6
  - name: Logistics - Order Timings
    title: Logistics - Order Timings
    model: flink_v3
    explore: orders_cl
    type: looker_column
    fields: [orders_cl.avg_fulfillment_time, orders_cl.avg_reaction_time, orders_cl.avg_picking_time,
      orders_cl.avg_acceptance_time, orders_cl.avg_delivery_time, orders_cl.avg_promised_eta,
      orders_cl.date]
    filters:
      orders_cl.is_internal_order: 'no'
      orders_cl.is_successful_order: 'yes'
    sorts: [orders_cl.date]
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
    y_axes: [{label: '', orientation: left, series: [{axisId: orders_cl.avg_reaction_time,
            id: orders_cl.avg_reaction_time, name: AVG Reaction Time}, {axisId: orders_cl.avg_picking_time,
            id: orders_cl.avg_picking_time, name: AVG Picking Time}, {axisId: orders_cl.avg_acceptance_time,
            id: orders_cl.avg_acceptance_time, name: AVG Acceptance Time}, {axisId: orders_cl.avg_delivery_time,
            id: orders_cl.avg_delivery_time, name: AVG Delivery Time}], showLabels: true,
        showValues: true, unpinAxis: false, tickDensity: default, type: linear}, {
        label: !!null '', orientation: right, series: [{axisId: orders_cl.avg_promised_eta,
            id: orders_cl.avg_promised_eta, name: AVG PDT}, {axisId: orders_cl.avg_fulfillment_time,
            id: orders_cl.avg_fulfillment_time, name: AVG Fulfillment Time (dec.)}],
        showLabels: true, showValues: true, unpinAxis: false, tickDensity: default,
        tickDensityCustom: 5, type: linear}]
    series_types:
      orders_cl.avg_fulfillment_time: line
      orders_cl.avg_promised_eta: line
    series_colors:
      orders_cl.cnt_orders: "#F9AB00"
      orders_cl.avg_fulfillment_time: "#1A73E8"
    series_labels:
      orders_cl.avg_fulfillment_time: AVG Fulfillment Time (dec.)
    trend_lines: []
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    hidden_fields: []
    listen:
      Order Day of Week: orders_cl.created_day_of_week
      Country: hubs.country
      Order Date: orders_cl.created_date
      City: hubs.city
      Hub Name: hubs.hub_name
      Date Granularity: orders_cl.date_granularity
    row: 19
    col: 0
    width: 13
    height: 6
  - title: Orders
    name: Orders
    model: flink_v3
    explore: orders_cl
    type: single_value
    fields: [orders_cl.created_date, orders_cl.cnt_orders]
    filters:
      orders_cl.is_internal_order: 'no'
      orders_cl.is_successful_order: 'yes'
      orders_cl.created_date: 28 days ago for 28 days
    sorts: [orders_cl.created_date desc]
    limit: 500
    dynamic_fields: [{table_calculation: display_number, label: display_number, expression: 'max(${running_orders})',
        value_format: !!null '', value_format_name: decimal_0, is_disabled: true,
        _kind_hint: dimension, _type_hint: number}, {_kind_hint: measure, table_calculation: wow,
        _type_hint: number, category: table_calculation, expression: 'if(diff_days(${orders_cl.created_date},offset(${orders_cl.created_date},7))
          =-7,( ${orders_cl.cnt_orders} - offset(${orders_cl.cnt_orders}, 7) )
          / offset(${orders_cl.cnt_orders}, 7),( ${orders_cl.cnt_orders} - offset(${orders_cl.cnt_orders},
          6) ) / offset(${orders_cl.cnt_orders}, 6))', label: WoW, value_format: !!null '',
        value_format_name: percent_0}]
    query_timezone: Europe/Berlin
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: true
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    color_application:
      collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7
      palette_id: fb7bb53e-b77b-4ab6-8274-9d420d3d73f3
    single_value_title: Orders
    value_format: "#,##0"
    conditional_formatting: [{type: equal to, value: !!null '', background_color: "#1A73E8",
        font_color: !!null '', color_application: {collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2,
          palette_id: 56d0c358-10a0-4fd6-aa0b-b117bef527ab}, bold: false, italic: false,
        strikethrough: false, fields: !!null ''}]
    x_axis_gridlines: false
    y_axis_gridlines: false
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
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
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    y_axes: [{label: '', orientation: left, series: [{axisId: running_orders, id: running_orders,
            name: Running orders}], showLabels: false, showValues: false, unpinAxis: false,
        tickDensity: default, tickDensityCustom: 5, type: linear}]
    limit_displayed_rows_values:
      show_hide: hide
      first_last: first
      num_rows: 0
    hide_legend: false
    series_types: {}
    trend_lines: []
    defaults_version: 1
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    header_text_alignment: left
    header_font_size: 12
    rows_font_size: 12
    groupBars: true
    labelSize: 10pt
    showLegend: true
    hidden_fields: []
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    listen:
      Country: hubs.country
      City: hubs.city
      Hub Name: hubs.hub_name
      Date Granularity: orders_cl.date_granularity
    row: 4
    col: 3
    width: 5
    height: 2
  - title: GMV
    name: GMV
    model: flink_v3
    explore: orders_cl
    type: single_value
    fields: [orders_cl.created_date, orders_cl.sum_gmv_gross]
    filters:
      orders_cl.is_internal_order: 'no'
      orders_cl.is_successful_order: 'yes'
      orders_cl.created_date: 28 days ago for 28 days
    sorts: [orders_cl.created_date desc]
    limit: 500
    dynamic_fields: [{table_calculation: running_orders, label: Running orders, expression: 'running_total(${orders_cl.cnt_orders})',
        value_format: !!null '', value_format_name: !!null '', is_disabled: true,
        _kind_hint: dimension, _type_hint: 'null'}, {table_calculation: display_number,
        label: display_number, expression: 'max(${running_orders})', value_format: !!null '',
        value_format_name: decimal_0, is_disabled: true, _kind_hint: dimension, _type_hint: number},
      {table_calculation: running_gmv, label: running_GMV, expression: 'running_total(${orders_cl.sum_gmv_gross})',
        value_format: !!null '', value_format_name: eur, is_disabled: true, _kind_hint: measure,
        _type_hint: number}, {table_calculation: display_value, label: display value,
        expression: 'max(${running_gmv})', value_format: !!null '', value_format_name: eur,
        is_disabled: true, _kind_hint: measure, _type_hint: number}, {_kind_hint: measure,
        table_calculation: wow, _type_hint: number, category: table_calculation, expression: 'if(diff_days(${orders_cl.created_date},offset(${orders_cl.created_date},7))
          =-7,( ${orders_cl.sum_gmv_gross}- offset(${orders_cl.sum_gmv_gross},
          7) ) / offset(${orders_cl.sum_gmv_gross}, 7),( ${orders_cl.sum_gmv_gross}
          - offset(${orders_cl.sum_gmv_gross}, 6) ) / offset(${orders_cl.sum_gmv_gross},
          6))', label: WoW, value_format: !!null '', value_format_name: percent_0}]
    query_timezone: Europe/Berlin
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: true
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    color_application:
      collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7
      palette_id: fb7bb53e-b77b-4ab6-8274-9d420d3d73f3
    single_value_title: GMV
    value_format: '"€"0, "K"'
    conditional_formatting: [{type: equal to, value: !!null '', background_color: "#1A73E8",
        font_color: !!null '', color_application: {collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2,
          palette_id: 56d0c358-10a0-4fd6-aa0b-b117bef527ab}, bold: false, italic: false,
        strikethrough: false, fields: !!null ''}]
    x_axis_gridlines: false
    y_axis_gridlines: false
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
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
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    y_axes: [{label: '', orientation: left, series: [{axisId: running_orders, id: running_orders,
            name: Running orders}], showLabels: false, showValues: false, unpinAxis: false,
        tickDensity: default, tickDensityCustom: 5, type: linear}]
    limit_displayed_rows_values:
      show_hide: hide
      first_last: first
      num_rows: 0
    hide_legend: false
    series_types: {}
    trend_lines: []
    defaults_version: 1
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    header_text_alignment: left
    header_font_size: 12
    rows_font_size: 12
    groupBars: true
    labelSize: 10pt
    showLegend: true
    hidden_fields: []
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    listen:
      Country: hubs.country
      City: hubs.city
      Hub Name: hubs.hub_name
      Date Granularity: orders_cl.date_granularity
    row: 4
    col: 8
    width: 5
    height: 2
  - title: AVG Fulfillment time
    name: AVG Fulfillment time
    model: flink_v3
    explore: orders_cl
    type: single_value
    fields: [orders_cl.avg_fulfillment_time_mm_ss]
    filters:
      orders_cl.is_internal_order: 'no'
      orders_cl.is_successful_order: 'yes'
      orders_cl.created_date: yesterday
    limit: 500
    query_timezone: Europe/Berlin
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    single_value_title: Avg. Fulfillment Time
    value_format: mm:ss
    x_axis_gridlines: false
    y_axis_gridlines: false
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
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
    show_null_points: true
    interpolation: linear
    y_axes: [{label: '', orientation: left, series: [{axisId: orders_cl.avg_fulfillment_time_mm_ss,
            id: orders_cl.avg_fulfillment_time_mm_ss, name: AVG Fulfillment Time}],
        showLabels: false, showValues: true, minValue: 0.0055, valueFormat: '', unpinAxis: false,
        tickDensity: default, type: linear}]
    limit_displayed_rows_values:
      show_hide: hide
      first_last: first
      num_rows: 0
    hide_legend: false
    series_types: {}
    trend_lines: []
    swap_axes: false
    defaults_version: 1
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    header_text_alignment: left
    header_font_size: 12
    rows_font_size: 12
    groupBars: true
    labelSize: 10pt
    showLegend: true
    hidden_fields: []
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    listen:
      Country: hubs.country
      City: hubs.city
      Hub Name: hubs.hub_name
      Date Granularity: orders_cl.date_granularity
    row: 4
    col: 13
    width: 5
    height: 2
  - title: Live Hubs
    name: Live Hubs
    model: flink_v3
    explore: orders_cl
    type: single_value
    fields: [orders_cl.created_date, orders_cl.cnt_unique_hubs]
    filters:
      orders_cl.is_internal_order: 'no'
      orders_cl.is_successful_order: 'yes'
      orders_cl.created_date: 28 days ago for 28 days
      hubs.live: ''
    sorts: [orders_cl.created_date desc]
    limit: 500
    column_limit: 50
    dynamic_fields: [{table_calculation: hubs_live, label: "# Hubs Live", expression: 'max(offset_list(${orders_cl.cnt_unique_hubs},0,3))',
        value_format: !!null '', value_format_name: !!null '', _kind_hint: measure,
        _type_hint: number}, {table_calculation: wow, label: WoW, expression: "(${hubs_live}\
          \ - offset(${hubs_live}, 7)) / offset(${hubs_live}, 7)", value_format: !!null '',
        value_format_name: percent_0, is_disabled: false, _kind_hint: measure, _type_hint: number}]
    query_timezone: Europe/Berlin
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: false
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    single_value_title: Live Hubs
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
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
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    y_axes: [{label: '', orientation: left, series: [{axisId: hubs.cnt_distinct_hubs,
            id: hubs.cnt_distinct_hubs, name: Cnt Distinct Hubs}], showLabels: false,
        showValues: false, unpinAxis: false, tickDensity: default, tickDensityCustom: 5,
        type: linear}]
    series_types: {}
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    header_text_alignment: left
    header_font_size: 12
    rows_font_size: 12
    defaults_version: 1
    hidden_fields: [orders_cl.cnt_unique_hubs]
    listen:
      Country: hubs.country
      City: hubs.city
      Hub Name: hubs.hub_name
      Date Granularity: orders_cl.date_granularity
    row: 4
    col: 18
    width: 5
    height: 2
  - title: 30 days NPS
    name: 30 days NPS
    model: flink_v3
    explore: orders_cl
    type: marketplace_viz_radial_gauge::radial_gauge-marketplace
    fields: [nps_after_order.nps_score]
    filters:
      orders_cl.is_internal_order: 'no'
      orders_cl.is_successful_order: 'yes'
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
      Order Day of Week: orders_cl.created_day_of_week
      Country: hubs.country
      Order Date: orders_cl.created_date
      City: hubs.city
      Hub Name: hubs.hub_name
      Date Granularity: orders_cl.date_granularity
    row: 19
    col: 13
    width: 11
    height: 6
  - name: " (2)"
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: '<img src="https://i.imgur.com/KcWQwrB.png" width="75%"> '
    row: 0
    col: 0
    width: 8
    height: 4
  - name: " (3)"
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: |-
      ### Performance

      #### Yesterday
    row: 4
    col: 0
    width: 3
    height: 2
  - title: Issue Rates - Timeseries
    name: Issue Rates - Timeseries
    model: flink_v3
    explore: orders_cl
    type: looker_column
    fields: [orders_cl.date, issue_rates_clean.sum_damaged, issue_rates_clean.sum_missing_product,
      issue_rates_clean.sum_orders_with_issues, issue_rates_clean.sum_perished_product,
      issue_rates_clean.sum_orders_total, issue_rates_clean.sum_wrong_order,
      issue_rates_clean.sum_wrong_product, issue_rates_clean.pct_orders_wrong_product,
      issue_rates_clean.pct_orders_missing_product, issue_rates_clean.pct_orders_perished_product,
      issue_rates_clean.pct_orders_wrong_order, issue_rates_clean.pct_orders_damaged_product,
      issue_rates_clean.pct_orders_with_issues]
    filters:
      orders_cl.is_internal_order: 'no'
      orders_cl.is_successful_order: 'yes'
      issue_rates_clean.date: 28 days ago for 28 days
    sorts: [orders_cl.date]
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
    totals_color: "#808080"
    y_axes: [{label: '', orientation: left, series: [{axisId: issue_rates_clean.pct_orders_wrong_product,
            id: issue_rates_clean.pct_orders_wrong_product, name: "% Wrong Product\
              \ Issue Rate"}, {axisId: issue_rates_clean.pct_orders_missing_product,
            id: issue_rates_clean.pct_orders_missing_product, name: "% Missing\
              \ Product Issue Rate"}, {axisId: issue_rates_clean.pct_orders_perished_product,
            id: issue_rates_clean.pct_orders_perished_product, name: "% Perished\
              \ Product Issue Rate"}, {axisId: issue_rates_clean.pct_orders_wrong_order,
            id: issue_rates_clean.pct_orders_wrong_order, name: "% Wrong Order\
              \ Issue Rate"}, {axisId: issue_rates_clean.pct_orders_damaged_product,
            id: issue_rates_clean.pct_orders_damaged_product, name: "% Damaged\
              \ Product Issue Rate"}], showLabels: true, showValues: false, unpinAxis: false,
        tickDensity: default, tickDensityCustom: 5, type: linear}]
    series_types: {}
    series_colors:
      issue_rate_hub_level.pct_orders_wrong_product: "#1A73E8"
      issue_rate_hub_level.pct_orders_damaged_product: "#F9AB00"
    hidden_fields: [issue_rates_clean.sum_damaged, issue_rates_clean.sum_missing_product,
      issue_rates_clean.sum_orders_with_issues, issue_rates_clean.sum_perished_product,
      issue_rates_clean.sum_wrong_order, issue_rates_clean.sum_orders_total,
      issue_rates_clean.sum_wrong_product, issue_rates_clean.pct_orders_with_issues]
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    listen:
      Order Day of Week: orders_cl.created_day_of_week
      Country: hubs.country
      Order Date: orders_cl.created_date
      City: hubs.city
      Hub Name: hubs.hub_name
      Date Granularity: orders_cl.date_granularity
    row: 25
    col: 0
    width: 24
    height: 6
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
    listens_to_filters: []
    field: hubs.city
  - name: Hub Name
    title: Hub Name
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: popover
      options: []
    model: flink_v3
    explore: orders_cl
    listens_to_filters: []
    field: hubs.hub_name
  - name: Order Day of Week
    title: Order Day of Week
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
    listens_to_filters: []
    field: orders_cl.created_day_of_week
  - name: Order Date
    title: Order Date
    type: field_filter
    default_value: 28 day ago for 28 day
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
      type: button_toggles
      display: inline
      options: []
    model: flink_v3
    explore: orders_cl
    listens_to_filters: []
    field: orders_cl.date_granularity
