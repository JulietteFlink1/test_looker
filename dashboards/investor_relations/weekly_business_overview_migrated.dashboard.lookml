- dashboard: 1_weekly_business_overview_migrated
  title: "(1) Weekly Business Overview"
  layout: newspaper
  preferred_viewer: dashboards-next
  elements:
  - name: ''
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: '<img src="https://i.imgur.com/KcWQwrB.png" width="75%"> '
    row: 0
    col: 0
    width: 6
    height: 3
  - title: Weekly Orders
    name: Weekly Orders
    model: flink_v3
    explore: orders_cl
    type: looker_grid
    fields: [orders_cl.cnt_orders, orders_cl.cnt_unique_orders_new_customers,
      orders_cl.cnt_unique_customers, orders_cl.sum_gmv_gross, orders_cl.avg_order_value_gross,
      orders_cl.pct_discount_order_share, orders_cl.pct_discount_value_of_gross_total,
      orders_cl.avg_delivery_fee_gross, orders_cl.pct_delivery_late_over_5_min,
      orders_cl.pct_delivery_late_over_10_min, orders_cl.created_week, orders_cl.pct_acquisition_share,
      orders_cl.avg_fulfillment_time_mm_ss, orders_cl.pct_delivery_in_time, gmv_hubs_4w_age,
      shyftplan_riders_pickers_hours.rider_utr]
    fill_fields: [orders_cl.created_week]
    filters:
      orders_cl.is_internal_order: 'no'
      orders_cl.is_successful_order: ''
      orders_cl.created_date: after 2021/01/25
      orders_cl.is_business_week_completed: 'Yes'
    sorts: [orders_cl.created_week desc]
    limit: 500
    dynamic_fields: [{table_calculation: wow, label: WoW, expression: "( ${orders_cl.cnt_orders}\
          \ - offset(${orders_cl.cnt_orders}, 1) ) / offset(${orders_cl.cnt_orders},\
          \ 1)", value_format: '"▲  "+0%; "▼  "-0%; 0', value_format_name: !!null '',
        _kind_hint: measure, _type_hint: number}, {table_calculation: wow_gmv, label: WoW
          GMV, expression: "( ${orders_cl.sum_gmv_gross} - offset(${orders_cl.sum_gmv_gross},\
          \ 1) ) / offset(${orders_cl.sum_gmv_gross}, 1)", value_format: '"▲  "+0%;
          "▼  "-0%; 0', value_format_name: !!null '', _kind_hint: measure, _type_hint: number},
      {based_on: orders_cl.sum_gmv_gross, _kind_hint: measure, measure: gmv_hubs_4w_age,
        type: sum, _type_hint: number, filters: {orders_cl.weeks_time_between_hub_launch_and_order: ">4"},
        category: measure, expression: !!null '', label: GMV (Hubs >4W age), value_format: !!null '',
        value_format_name: !!null ''}, {_kind_hint: measure, table_calculation: wow_gmv_hubs_4w_age,
        _type_hint: number, category: table_calculation, expression: "( ${gmv_hubs_4w_age}\
          \ - offset(${gmv_hubs_4w_age}, 1) ) / offset(${gmv_hubs_4w_age}, 1)", label: WoW
          GMV (Hubs >4W age), value_format: '"▲  "+0%; "▼  "-0%; 0', value_format_name: !!null ''}]
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
      orders_cl.created_week: left
      orders_cl.cnt_orders: left
    column_order: ["$$$_row_numbers_$$$", orders_cl.created_week, orders_cl.cnt_orders,
      wow, orders_cl.avg_order_value_gross, orders_cl.avg_fulfillment_time_mm_ss,
      orders_cl.pct_delivery_in_time, orders_cl.pct_delivery_late_over_5_min,
      orders_cl.pct_delivery_late_over_10_min, orders_cl.sum_gmv_gross, wow_gmv,
      orders_cl.cnt_unique_customers, orders_cl.cnt_unique_orders_new_customers,
      orders_cl.pct_discount_order_share, orders_cl.pct_acquisition_share, orders_cl.pct_discount_value_of_gross_total,
      shyftplan_riders_pickers_hours.rider_utr, orders_cl.avg_delivery_fee_gross]
    show_totals: true
    show_row_totals: true
    series_column_widths:
      orders_cl.created_date: 125
      orders_cl.cnt_unique_orders: 101
      orders_cl.cnt_unique_orders_new_customers: 83
      orders_cl.cnt_unique_orders_existing_customers: 147
      orders_cl.cnt_unique_customers: 79
      orders_cl.avg_basket_size_gross: 211
      orders_cl.sum_revenue_gross: 173
      orders_cl.avg_reaction_time: 159
      orders_cl.avg_picking_time: 151
      orders_cl.avg_fulfillment_time: 97
      orders_cl.avg_delivery_time: 154
      orders_cl.cnt_orders: 93
      orders_cl.pct_discount_order_share: 84
      orders_cl.sum_discount_amt: 87
      orders_cl.pct_discount_value_of_gross_total: 75
      orders_cl.avg_delivery_fee_gross: 76
      orders_cl.avg_acceptance_time: 175
      orders_cl.sum_gmv_gross: 77
      orders_cl.avg_order_value_gross: 116
      orders_cl.pct_delivery_late_over_5_min: 80
      orders_cl.pct_delivery_late_over_10_min: 84
      wow: 68
      orders_cl.date: 162
      orders_cl.created_week: 106
      orders_cl.pct_acquisition_share: 90
      orders_cl.avg_fulfillment_time_mm_ss: 97
      orders_cl.pct_delivery_in_time: 99
      wow_gmv: 75
      wow_gmv_hubs_4w_age: 95
      shyftplan_riders_pickers_hours.rider_utr: 75
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
          palette_id: 66f971b0-042e-327b-aba6-83922b72a309
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
          custom_colors:
          - "#b1e84d"
          - "#ffffff"
          - "#db3520"
      orders_cl.pct_delivery_in_time:
        is_active: true
        palette:
          palette_id: fe57f38c-addd-8fa5-58aa-f616441a0362
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
          custom_colors:
          - "#ff393f"
          - "#ffffff"
          - "#b1e84d"
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
        fields: [wow, wow_gmv, wow_gmv_hubs_4w_age]}, {type: less than, value: 0,
        background_color: !!null '', font_color: "#EA4335", color_application: {collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2,
          palette_id: 4a00499b-c0fe-4b15-a304-4083c07ff4c4}, bold: true, italic: false,
        strikethrough: false, fields: [wow, wow_gmv, wow_gmv_hubs_4w_age]}]
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
    hidden_fields: [gmv_hubs_4w_age, wow_gmv_hubs_4w_age]
    y_axes: []
    listen:
      Country: hubs.country
      Hub Name: hubs.hub_name
    row: 3
    col: 0
    width: 24
    height: 12
  - title: GMV vs AOV
    name: GMV vs AOV
    model: flink_v3
    explore: orders_cl
    type: looker_line
    fields: [orders_cl.sum_gmv_gross, orders_cl.avg_order_value_gross, orders_cl.created_week]
    fill_fields: [orders_cl.created_week]
    filters:
      orders_cl.is_internal_order: 'no'
      orders_cl.is_successful_order: ''
      orders_cl.created_date: after 2021/01/25
      orders_cl.is_business_week_completed: 'Yes'
    sorts: [orders_cl.created_week desc]
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
            id: orders_cl.avg_order_value_gross, name: AVG Order Value (Gross)}],
        showLabels: true, showValues: true, maxValue: 30, unpinAxis: false, tickDensity: default,
        type: linear}, {label: '', orientation: right, series: [{axisId: orders_cl.sum_gmv_gross,
            id: orders_cl.sum_gmv_gross, name: SUM GMV (gross)}], showLabels: true,
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
      Country: hubs.country
      Hub Name: hubs.hub_name
    row: 15
    col: 0
    width: 12
    height: 8
  - title: Orders by Customer Type
    name: Orders by Customer Type
    model: flink_v3
    explore: orders_cl
    type: looker_column
    fields: [orders_cl.cnt_unique_orders_existing_customers, orders_cl.cnt_unique_orders_new_customers,
      orders_cl.pct_acquisition_share, orders_cl.created_week]
    fill_fields: [orders_cl.created_week]
    filters:
      orders_cl.is_internal_order: 'no'
      orders_cl.is_successful_order: ''
      orders_cl.created_date: after 2021/01/25
      orders_cl.is_business_week_completed: 'Yes'
    sorts: [orders_cl.created_week desc]
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
        showLabels: true, showValues: true, maxValue: !!null '', unpinAxis: false,
        tickDensity: default, type: linear}, {label: '', orientation: right, series: [
          {axisId: orders_cl.pct_acquisition_share, id: orders_cl.pct_acquisition_share,
            name: "% Acquisition Share"}], showLabels: true, showValues: true, unpinAxis: false,
        tickDensity: default, type: linear}]
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
      Country: hubs.country
      Hub Name: hubs.hub_name
    row: 15
    col: 12
    width: 12
    height: 8
  filters:
  - name: Country
    title: Country
    type: field_filter
    default_value: France,Germany,Netherlands
    allow_multiple_values: true
    required: true
    ui_config:
      type: button_group
      display: inline
      options: []
    model: flink_v3
    explore: orders_cl
    listens_to_filters: []
    field: hubs.country
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
