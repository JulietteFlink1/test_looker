- dashboard: business_performance_migrated
  title: Daily/Weekly/Monthly Business Performance
  layout: newspaper
  preferred_viewer: dashboards-next
  elements:
  - title: Orders by Customer Type
    name: Orders by Customer Type
    model: flink_v3
    explore: orders_cl
    type: looker_column
    fields: [orders_cl.cnt_unique_orders_existing_customers, orders_cl.cnt_unique_orders_new_customers,
      orders_cl.pct_discount_order_share, orders_cl.pct_acquisition_share, orders_cl.date]
    filters:
      orders_cl.is_successful_order: 'yes'
      hubs.country: ''
      hubs.hub_name: ''
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
            id: orders_cl.cnt_unique_orders_existing_customers, name: "# Orders Existing\
              \ Customers"}, {axisId: orders_cl.cnt_unique_orders_new_customers, id: orders_cl.cnt_unique_orders_new_customers,
            name: "# Orders New Customers"}], showLabels: true, showValues: true,
        unpinAxis: false, tickDensity: default, type: linear}, {label: '', orientation: right,
        series: [{axisId: orders_cl.pct_acquisition_share, id: orders_cl.pct_acquisition_share,
            name: "% Acquisition Share"}, {axisId: orders_cl.pct_discount_order_share,
            id: orders_cl.pct_discount_order_share, name: "% Discount Order Share"}],
        showLabels: true, showValues: true, unpinAxis: false, tickDensity: default,
        type: linear}]
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
      Date Granularity: orders_cl.date_granularity
      Country Iso: hubs.country_iso
      City: hubs.city
      Hub Name: orders_cl.warehouse_name
      Order Day of Week: orders_cl.created_day_of_week
      'Order Date ': global_filters_and_parameters.datasource_filter
    row: 13
    col: 8
    width: 8
    height: 6
  - name: ''
    type: text
    title_text: ''
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
  - title: Daily Orders
    name: Daily Orders
    model: flink_v3
    explore: orders_cl
    type: looker_grid
    fields: [orders_cl.date_granularity_pass_through, orders_cl.date, orders_cl.cnt_orders,
      orders_cl.sum_gmv_gross, orders_cl.avg_order_value_gross, orders_cl.pct_discount_order_share,
      orders_cl.avg_fulfillment_time_mm_ss, orders_cl.pct_discount_value_of_gross_total,
      orders_cl.pct_delivery_late_over_5_min, orders_cl.pct_delivery_late_over_10_min,
      orders_cl.pct_delivery_in_time, shyftplan_riders_pickers_hours.rider_utr, orders_cl.pct_acquisition_share,
      orders_cl.avg_pdt_mm_ss, orders_cl.pct_fulfillment_over_30_min]
    filters:
      orders_cl.is_successful_order: 'yes'
      hubs.country: ''
      hubs.hub_name: ''
    sorts: [orders_cl.date desc]
    limit: 500
    dynamic_fields: [{_kind_hint: measure, table_calculation: pop, _type_hint: number,
        category: table_calculation, expression: "case(when(diff_days(to_date(${orders_cl.date}),offset(to_date(${orders_cl.date}),7))\
          \ = null,null),\n  \n  when(${orders_cl.date_granularity_pass_through} =\
          \ \"Day\" \n    AND diff_days(to_date(${orders_cl.date}),offset(to_date(${orders_cl.date}),7))\
          \ = -7,\n    ( ${orders_cl.cnt_orders} - offset(${orders_cl.cnt_orders},\
          \ 7) ) / offset(${orders_cl.cnt_orders}, 7)),\n  when(${orders_cl.date_granularity_pass_through}\
          \ = \"Day\"  AND offset(to_date(${orders_cl.date}),7) = null,null),\n  when(${orders_cl.date_granularity_pass_through}\
          \ = \"Day\" \n    AND diff_days(to_date(${orders_cl.date}),\n      offset(to_date(${orders_cl.date}),7))\
          \ != -7,( ${orders_cl.cnt_orders} - offset(${orders_cl.cnt_orders}, 6) )\
          \ / offset(${orders_cl.cnt_orders}, 6)),\n  when(${orders_cl.date_granularity_pass_through}\
          \ = \"Week\" OR ${orders_cl.date_granularity_pass_through} = \"Month\",\
          \ \n  ( ${orders_cl.cnt_orders} - offset(${orders_cl.cnt_orders}, 1) ) /\
          \ offset(${orders_cl.cnt_orders}, 1)),null)", label: PoP, value_format: '"▲  "+0%;
          "▼  "-0%; 0', value_format_name: !!null ''}, {_kind_hint: measure, table_calculation: pop_gmv,
        _type_hint: number, category: table_calculation, expression: "\n\ncase(when(diff_days(to_date(${orders_cl.date}),offset(to_date(${orders_cl.date}),7))\
          \ = null,null),\n  \n  when(${orders_cl.date_granularity_pass_through} =\
          \ \"Day\" \n    AND diff_days(to_date(${orders_cl.date}),offset(to_date(${orders_cl.date}),7))\
          \ = -7,\n    ( ${orders_cl.sum_gmv_gross} - offset(${orders_cl.sum_gmv_gross},\
          \ 7) ) / offset(${orders_cl.sum_gmv_gross}, 7)),\n  when(${orders_cl.date_granularity_pass_through}\
          \ = \"Day\"  AND offset(to_date(${orders_cl.date}),7) = null,null),\n  when(${orders_cl.date_granularity_pass_through}\
          \ = \"Day\" \n    AND diff_days(to_date(${orders_cl.date}),\n      offset(to_date(${orders_cl.date}),7))\
          \ != -7,( ${orders_cl.sum_gmv_gross} - offset(${orders_cl.sum_gmv_gross},\
          \ 6) ) / offset(${orders_cl.sum_gmv_gross}, 6)),\n  when(${orders_cl.date_granularity_pass_through}\
          \ = \"Week\" OR ${orders_cl.date_granularity_pass_through} = \"Month\",\
          \ \n  ( ${orders_cl.sum_gmv_gross} - offset(${orders_cl.sum_gmv_gross},\
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
    column_order: ["$$$_row_numbers_$$$", orders_cl.date, orders_cl.cnt_orders, pop,
      orders_cl.sum_gmv_gross, pop_gmv, orders_cl.avg_order_value_gross, orders_cl.avg_fulfillment_time_mm_ss,
      orders_cl.avg_pdt_mm_ss, orders_cl.pct_delivery_in_time, orders_cl.pct_delivery_late_over_5_min,
      orders_cl.pct_delivery_late_over_10_min, orders_cl.pct_fulfillment_over_30_min,
      shyftplan_riders_pickers_hours.rider_utr, orders_cl.pct_acquisition_share, orders_cl.pct_discount_order_share,
      orders_cl.pct_discount_value_of_gross_total]
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
      orders_cl.avg_fulfillment_time_mm_ss: 120
      orders_cl.pct_delivery_in_time: 96
      wow_gmv: 77
      shyftplan_riders_pickers_hours.rider_utr: 79
      shyftplan_riders_pickers_hours.picker_utr: 80
      orders_cl.avg_pdt_mm_ss: 111
      orders_cl.pct_fulfillment_over_30_min: 88
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
      orders_cl.avg_pdt_mm_ss:
        is_active: true
        palette:
          palette_id: ef391fdc-586b-c137-d48b-94c757a9b1b6
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
          custom_colors:
          - "#b1e84d"
          - "#ffffff"
          - "#f2180f"
      orders_cl.pct_fulfillment_over_30_min:
        is_active: true
        palette:
          palette_id: 8b4ba165-ffc5-1cf5-9749-a9c77e4a522d
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
    query_fields:
      measures:
      - align: right
        can_filter: true
        category: measure
        default_filter_value:
        description: Count of successful Orders
        enumerations:
        field_group_label: "* Basic Counts (Orders / Customers etc.) *"
        fill_style:
        fiscal_month_offset: 0
        has_allowed_values: false
        hidden: false
        is_filter: false
        is_numeric: true
        label: "* Orders * # Orders"
        label_from_parameter:
        label_short: "# Orders"
        map_layer:
        name: orders_cl.cnt_orders
        strict_value_format: false
        requires_refresh_on_sort: false
        sortable: true
        suggestions:
        tags: []
        type: count
        user_attribute_filter_types:
        - number
        - advanced_filter_number
        value_format: '0'
        view: orders_cl
        view_label: "* Orders *"
        dynamic: false
        week_start_day: monday
        dimension_group:
        error:
        field_group_variant: "# Orders"
        measure: true
        parameter: false
        primary_key: false
        project_name: flink_v1
        scope: orders_cl
        suggest_dimension: orders_cl.cnt_orders
        suggest_explore: orders_cl
        suggestable: false
        is_fiscal: false
        is_timeframe: false
        can_time_filter: false
        time_interval:
        lookml_link: "/projects/flink_v1/files/views%2Fbigquery_tables%2Fcurated_layer%2Forders.view.lkml?line=1443"
        permanent:
        source_file: views/extended_tables/orders_using_hubs.view.lkml
        source_file_path: flink_v1/views/extended_tables/orders_using_hubs.view.lkml
        sql:
        sql_case:
        filters:
      - align: right
        can_filter: true
        category: measure
        default_filter_value:
        description: Sum of Gross Merchandise Value of orders incl. fees and before
          deduction of discounts (incl. VAT)
        enumerations:
        field_group_label: "* Monetary Values *"
        fill_style:
        fiscal_month_offset: 0
        has_allowed_values: false
        hidden: false
        is_filter: false
        is_numeric: true
        label: "* Orders * SUM GMV (Gross)"
        label_from_parameter:
        label_short: SUM GMV (Gross)
        map_layer:
        name: orders_cl.sum_gmv_gross
        strict_value_format: false
        requires_refresh_on_sort: false
        sortable: true
        suggestions:
        tags: []
        type: sum
        user_attribute_filter_types:
        - number
        - advanced_filter_number
        value_format: '"€"#,##0'
        view: orders_cl
        view_label: "* Orders *"
        dynamic: false
        week_start_day: monday
        dimension_group:
        error:
        field_group_variant: SUM GMV (Gross)
        measure: true
        parameter: false
        primary_key: false
        project_name: flink_v1
        scope: orders_cl
        suggest_dimension: orders_cl.sum_gmv_gross
        suggest_explore: orders_cl
        suggestable: false
        is_fiscal: false
        is_timeframe: false
        can_time_filter: false
        time_interval:
        lookml_link: "/projects/flink_v1/files/views%2Fbigquery_tables%2Fcurated_layer%2Forders.view.lkml?line=1319"
        permanent:
        source_file: views/extended_tables/orders_using_hubs.view.lkml
        source_file_path: flink_v1/views/extended_tables/orders_using_hubs.view.lkml
        sql: "${gmv_gross}"
        sql_case:
        filters:
      - align: right
        can_filter: true
        category: measure
        default_filter_value:
        description: Average value of orders considering total gross order values.
          Includes fees (gross), before deducting discounts.
        enumerations:
        field_group_label: "* Monetary Values *"
        fill_style:
        fiscal_month_offset: 0
        has_allowed_values: false
        hidden: false
        is_filter: false
        is_numeric: true
        label: "* Orders * AVG Order Value (Gross)"
        label_from_parameter:
        label_short: AVG Order Value (Gross)
        map_layer:
        name: orders_cl.avg_order_value_gross
        strict_value_format: false
        requires_refresh_on_sort: false
        sortable: true
        suggestions:
        tags: []
        type: average
        user_attribute_filter_types:
        - number
        - advanced_filter_number
        value_format: '"€"#,##0.00'
        view: orders_cl
        view_label: "* Orders *"
        dynamic: false
        week_start_day: monday
        dimension_group:
        error:
        field_group_variant: AVG Order Value (Gross)
        measure: true
        parameter: false
        primary_key: false
        project_name: flink_v1
        scope: orders_cl
        suggest_dimension: orders_cl.avg_order_value_gross
        suggest_explore: orders_cl
        suggestable: false
        is_fiscal: false
        is_timeframe: false
        can_time_filter: false
        time_interval:
        lookml_link: "/projects/flink_v1/files/views%2Fbigquery_tables%2Fcurated_layer%2Forders.view.lkml?line=1244"
        permanent:
        source_file: views/extended_tables/orders_using_hubs.view.lkml
        source_file_path: flink_v1/views/extended_tables/orders_using_hubs.view.lkml
        sql: "${gmv_gross}"
        sql_case:
        filters:
      - align: right
        can_filter: true
        category: measure
        default_filter_value:
        description: Share of Orders which had some Discount applied
        enumerations:
        field_group_label: "* Marketing *"
        fill_style:
        fiscal_month_offset: 0
        has_allowed_values: false
        hidden: false
        is_filter: false
        is_numeric: true
        label: "* Orders * % Discount Order Share"
        label_from_parameter:
        label_short: "% Discount Order Share"
        map_layer:
        name: orders_cl.pct_discount_order_share
        strict_value_format: false
        requires_refresh_on_sort: false
        sortable: true
        suggestions:
        tags: []
        type: number
        user_attribute_filter_types:
        - number
        - advanced_filter_number
        value_format: 0%
        view: orders_cl
        view_label: "* Orders *"
        dynamic: false
        week_start_day: monday
        dimension_group:
        error:
        field_group_variant: "% Discount Order Share"
        measure: true
        parameter: false
        primary_key: false
        project_name: flink_v1
        scope: orders_cl
        suggest_dimension: orders_cl.pct_discount_order_share
        suggest_explore: orders_cl
        suggestable: false
        is_fiscal: false
        is_timeframe: false
        can_time_filter: false
        time_interval:
        lookml_link: "/projects/flink_v1/files/views%2Fbigquery_tables%2Fcurated_layer%2Forders.view.lkml?line=1667"
        permanent:
        source_file: views/extended_tables/orders_using_hubs.view.lkml
        source_file_path: flink_v1/views/extended_tables/orders_using_hubs.view.lkml
        sql: "${cnt_orders_with_discount} / NULLIF(${cnt_orders}, 0)"
        sql_case:
        filters:
      - align: right
        can_filter: true
        category: measure
        default_filter_value:
        description: Average Fulfillment Time considering order placement to delivery.
          Outliers excluded (<1min or >30min)
        enumerations:
        field_group_label: "* Operations / Logistics *"
        fill_style:
        fiscal_month_offset: 0
        has_allowed_values: false
        hidden: false
        is_filter: false
        is_numeric: true
        label: "* Orders * AVG Fulfillment Time (MM:SS)"
        label_from_parameter:
        label_short: AVG Fulfillment Time (MM:SS)
        map_layer:
        name: orders_cl.avg_fulfillment_time_mm_ss
        strict_value_format: false
        requires_refresh_on_sort: false
        sortable: true
        suggestions:
        tags: []
        type: average
        user_attribute_filter_types:
        - number
        - advanced_filter_number
        value_format: mm:ss
        view: orders_cl
        view_label: "* Orders *"
        dynamic: false
        week_start_day: monday
        dimension_group:
        error:
        field_group_variant: AVG Fulfillment Time (MM:SS)
        measure: true
        parameter: false
        primary_key: false
        project_name: flink_v1
        scope: orders_cl
        suggest_dimension: orders_cl.avg_fulfillment_time_mm_ss
        suggest_explore: orders_cl
        suggestable: false
        is_fiscal: false
        is_timeframe: false
        can_time_filter: false
        time_interval:
        lookml_link: "/projects/flink_v1/files/views%2Fbigquery_tables%2Fcurated_layer%2Forders.view.lkml?line=1172"
        permanent:
        source_file: views/extended_tables/orders_using_hubs.view.lkml
        source_file_path: flink_v1/views/extended_tables/orders_using_hubs.view.lkml
        sql: "${fulfillment_time} * 60 / 86400.0"
        sql_case:
        filters:
      - align: right
        can_filter: true
        category: measure
        default_filter_value:
        description: Dividing Total Discount amounts over GMV
        enumerations:
        field_group_label: "* Marketing *"
        fill_style:
        fiscal_month_offset: 0
        has_allowed_values: false
        hidden: false
        is_filter: false
        is_numeric: true
        label: "* Orders * % Discount Value Share"
        label_from_parameter:
        label_short: "% Discount Value Share"
        map_layer:
        name: orders_cl.pct_discount_value_of_gross_total
        strict_value_format: false
        requires_refresh_on_sort: false
        sortable: true
        suggestions:
        tags: []
        type: number
        user_attribute_filter_types:
        - number
        - advanced_filter_number
        value_format: 0%
        view: orders_cl
        view_label: "* Orders *"
        dynamic: false
        week_start_day: monday
        dimension_group:
        error:
        field_group_variant: "% Discount Value Share"
        measure: true
        parameter: false
        primary_key: false
        project_name: flink_v1
        scope: orders_cl
        suggest_dimension: orders_cl.pct_discount_value_of_gross_total
        suggest_explore: orders_cl
        suggestable: false
        is_fiscal: false
        is_timeframe: false
        can_time_filter: false
        time_interval:
        lookml_link: "/projects/flink_v1/files/views%2Fbigquery_tables%2Fcurated_layer%2Forders.view.lkml?line=1677"
        permanent:
        source_file: views/extended_tables/orders_using_hubs.view.lkml
        source_file_path: flink_v1/views/extended_tables/orders_using_hubs.view.lkml
        sql: "${sum_discount_amt} / NULLIF(${sum_gmv_gross}, 0)"
        sql_case:
        filters:
      - align: right
        can_filter: true
        category: measure
        default_filter_value:
        description: Share of orders delivered >5min later than PDT
        enumerations:
        field_group_label: "* Operations / Logistics *"
        fill_style:
        fiscal_month_offset: 0
        has_allowed_values: false
        hidden: false
        is_filter: false
        is_numeric: true
        label: "* Orders * % Orders delayed >5min"
        label_from_parameter:
        label_short: "% Orders delayed >5min"
        map_layer:
        name: orders_cl.pct_delivery_late_over_5_min
        strict_value_format: false
        requires_refresh_on_sort: false
        sortable: true
        suggestions:
        tags: []
        type: number
        user_attribute_filter_types:
        - number
        - advanced_filter_number
        value_format: 0%
        view: orders_cl
        view_label: "* Orders *"
        dynamic: false
        week_start_day: monday
        dimension_group:
        error:
        field_group_variant: "% Orders delayed >5min"
        measure: true
        parameter: false
        primary_key: false
        project_name: flink_v1
        scope: orders_cl
        suggest_dimension: orders_cl.pct_delivery_late_over_5_min
        suggest_explore: orders_cl
        suggestable: false
        is_fiscal: false
        is_timeframe: false
        can_time_filter: false
        time_interval:
        lookml_link: "/projects/flink_v1/files/views%2Fbigquery_tables%2Fcurated_layer%2Forders.view.lkml?line=1697"
        permanent:
        source_file: views/extended_tables/orders_using_hubs.view.lkml
        source_file_path: flink_v1/views/extended_tables/orders_using_hubs.view.lkml
        sql: "${cnt_orders_delayed_over_5_min} / NULLIF(${cnt_orders_with_delivery_eta_available},\
          \ 0)"
        sql_case:
        filters:
      - align: right
        can_filter: true
        category: measure
        default_filter_value:
        description: Share of orders delivered >10min later than PDT
        enumerations:
        field_group_label: "* Operations / Logistics *"
        fill_style:
        fiscal_month_offset: 0
        has_allowed_values: false
        hidden: false
        is_filter: false
        is_numeric: true
        label: "* Orders * % Orders delayed >10min"
        label_from_parameter:
        label_short: "% Orders delayed >10min"
        map_layer:
        name: orders_cl.pct_delivery_late_over_10_min
        strict_value_format: false
        requires_refresh_on_sort: false
        sortable: true
        suggestions:
        tags: []
        type: number
        user_attribute_filter_types:
        - number
        - advanced_filter_number
        value_format: 0%
        view: orders_cl
        view_label: "* Orders *"
        dynamic: false
        week_start_day: monday
        dimension_group:
        error:
        field_group_variant: "% Orders delayed >10min"
        measure: true
        parameter: false
        primary_key: false
        project_name: flink_v1
        scope: orders_cl
        suggest_dimension: orders_cl.pct_delivery_late_over_10_min
        suggest_explore: orders_cl
        suggestable: false
        is_fiscal: false
        is_timeframe: false
        can_time_filter: false
        time_interval:
        lookml_link: "/projects/flink_v1/files/views%2Fbigquery_tables%2Fcurated_layer%2Forders.view.lkml?line=1707"
        permanent:
        source_file: views/extended_tables/orders_using_hubs.view.lkml
        source_file_path: flink_v1/views/extended_tables/orders_using_hubs.view.lkml
        sql: "${cnt_orders_delayed_over_10_min} / NULLIF(${cnt_orders_with_delivery_eta_available},\
          \ 0)"
        sql_case:
        filters:
      - align: right
        can_filter: true
        category: measure
        default_filter_value:
        description: Share of orders delivered no later than PDT
        enumerations:
        field_group_label: "* Operations / Logistics *"
        fill_style:
        fiscal_month_offset: 0
        has_allowed_values: false
        hidden: false
        is_filter: false
        is_numeric: true
        label: "* Orders * % Orders delivered in time"
        label_from_parameter:
        label_short: "% Orders delivered in time"
        map_layer:
        name: orders_cl.pct_delivery_in_time
        strict_value_format: false
        requires_refresh_on_sort: false
        sortable: true
        suggestions:
        tags: []
        type: number
        user_attribute_filter_types:
        - number
        - advanced_filter_number
        value_format: 0%
        view: orders_cl
        view_label: "* Orders *"
        dynamic: false
        week_start_day: monday
        dimension_group:
        error:
        field_group_variant: "% Orders delivered in time"
        measure: true
        parameter: false
        primary_key: false
        project_name: flink_v1
        scope: orders_cl
        suggest_dimension: orders_cl.pct_delivery_in_time
        suggest_explore: orders_cl
        suggestable: false
        is_fiscal: false
        is_timeframe: false
        can_time_filter: false
        time_interval:
        lookml_link: "/projects/flink_v1/files/views%2Fbigquery_tables%2Fcurated_layer%2Forders.view.lkml?line=1687"
        permanent:
        source_file: views/extended_tables/orders_using_hubs.view.lkml
        source_file_path: flink_v1/views/extended_tables/orders_using_hubs.view.lkml
        sql: "${cnt_orders_delayed_under_0_min} / NULLIF(${cnt_orders_with_delivery_eta_available},\
          \ 0)"
        sql_case:
        filters:
      - align: right
        can_filter: true
        category: measure
        default_filter_value:
        description:
        enumerations:
        field_group_label: UTR
        fill_style:
        fiscal_month_offset: 0
        has_allowed_values: false
        hidden: false
        is_filter: false
        is_numeric: true
        label: "* Shifts * AVG Rider UTR"
        label_from_parameter:
        label_short: AVG Rider UTR
        map_layer:
        name: shyftplan_riders_pickers_hours.rider_utr
        strict_value_format: false
        requires_refresh_on_sort: false
        sortable: true
        suggestions:
        tags: []
        type: number
        user_attribute_filter_types:
        - number
        - advanced_filter_number
        value_format: "#,##0.00"
        view: shyftplan_riders_pickers_hours
        view_label: "* Shifts *"
        dynamic: false
        week_start_day: monday
        dimension_group:
        error:
        field_group_variant: AVG Rider UTR
        measure: true
        parameter: false
        primary_key: false
        project_name: flink_v1
        scope: shyftplan_riders_pickers_hours
        suggest_dimension: shyftplan_riders_pickers_hours.rider_utr
        suggest_explore: orders_cl
        suggestable: false
        is_fiscal: false
        is_timeframe: false
        can_time_filter: false
        time_interval:
        lookml_link: "/projects/flink_v1/files/views%2Fprojects%2Fcleaning%2Fshyftplan_riders_pickers_hours_clean.view.lkml?line=161"
        permanent:
        source_file: views/projects/cleaning/shyftplan_riders_pickers_hours_clean.view.lkml
        source_file_path: flink_v1/views/projects/cleaning/shyftplan_riders_pickers_hours_clean.view.lkml
        sql: "${adjusted_orders_riders} / NULLIF(${rider_hours}, 0)"
        sql_case:
        filters:
      - align: right
        can_filter: true
        category: measure
        default_filter_value:
        description: Share of New Customer Acquisitions over Total Orders
        enumerations:
        field_group_label: "* Marketing *"
        fill_style:
        fiscal_month_offset: 0
        has_allowed_values: false
        hidden: false
        is_filter: false
        is_numeric: true
        label: "* Orders * % Acquisition Share"
        label_from_parameter:
        label_short: "% Acquisition Share"
        map_layer:
        name: orders_cl.pct_acquisition_share
        strict_value_format: false
        requires_refresh_on_sort: false
        sortable: true
        suggestions:
        tags: []
        type: number
        user_attribute_filter_types:
        - number
        - advanced_filter_number
        value_format: 0%
        view: orders_cl
        view_label: "* Orders *"
        dynamic: false
        week_start_day: monday
        dimension_group:
        error:
        field_group_variant: "% Acquisition Share"
        measure: true
        parameter: false
        primary_key: false
        project_name: flink_v1
        scope: orders_cl
        suggest_dimension: orders_cl.pct_acquisition_share
        suggest_explore: orders_cl
        suggestable: false
        is_fiscal: false
        is_timeframe: false
        can_time_filter: false
        time_interval:
        lookml_link: "/projects/flink_v1/files/views%2Fbigquery_tables%2Fcurated_layer%2Forders.view.lkml?line=1657"
        permanent:
        source_file: views/extended_tables/orders_using_hubs.view.lkml
        source_file_path: flink_v1/views/extended_tables/orders_using_hubs.view.lkml
        sql: "${cnt_unique_orders_new_customers} / NULLIF(${cnt_orders}, 0)"
        sql_case:
        filters:
      - align: right
        can_filter: true
        category: measure
        default_filter_value:
        description: Average Promised Fulfillment Time (PDT) a shown to customer
        enumerations:
        field_group_label: "* Operations / Logistics *"
        fill_style:
        fiscal_month_offset: 0
        has_allowed_values: false
        hidden: false
        is_filter: false
        is_numeric: true
        label: "* Orders * AVG PDT (MM:SS)"
        label_from_parameter:
        label_short: AVG PDT (MM:SS)
        map_layer:
        name: orders_cl.avg_pdt_mm_ss
        strict_value_format: false
        requires_refresh_on_sort: false
        sortable: true
        suggestions:
        tags: []
        type: average
        user_attribute_filter_types:
        - number
        - advanced_filter_number
        value_format: mm:ss
        view: orders_cl
        view_label: "* Orders *"
        dynamic: false
        week_start_day: monday
        dimension_group:
        error:
        field_group_variant: AVG PDT (MM:SS)
        measure: true
        parameter: false
        primary_key: false
        project_name: flink_v1
        scope: orders_cl
        suggest_dimension: orders_cl.avg_pdt_mm_ss
        suggest_explore: orders_cl
        suggestable: false
        is_fiscal: false
        is_timeframe: false
        can_time_filter: false
        time_interval:
        lookml_link: "/projects/flink_v1/files/views%2Fbigquery_tables%2Fcurated_layer%2Forders.view.lkml?line=1144"
        permanent:
        source_file: views/extended_tables/orders_using_hubs.view.lkml
        source_file_path: flink_v1/views/extended_tables/orders_using_hubs.view.lkml
        sql: "${delivery_eta_minutes} * 60 / 86400.0"
        sql_case:
        filters:
      - align: right
        can_filter: true
        category: measure
        default_filter_value:
        description: Share of orders delivered > 30min
        enumerations:
        field_group_label: "* Operations / Logistics *"
        fill_style:
        fiscal_month_offset: 0
        has_allowed_values: false
        hidden: false
        is_filter: false
        is_numeric: true
        label: "* Orders * % Orders fulfilled >30min"
        label_from_parameter:
        label_short: "% Orders fulfilled >30min"
        map_layer:
        name: orders_cl.pct_fulfillment_over_30_min
        strict_value_format: false
        requires_refresh_on_sort: false
        sortable: true
        suggestions:
        tags: []
        type: number
        user_attribute_filter_types:
        - number
        - advanced_filter_number
        value_format: 0%
        view: orders_cl
        view_label: "* Orders *"
        dynamic: false
        week_start_day: monday
        dimension_group:
        error:
        field_group_variant: "% Orders fulfilled >30min"
        measure: true
        parameter: false
        primary_key: false
        project_name: flink_v1
        scope: orders_cl
        suggest_dimension: orders_cl.pct_fulfillment_over_30_min
        suggest_explore: orders_cl
        suggestable: false
        is_fiscal: false
        is_timeframe: false
        can_time_filter: false
        time_interval:
        lookml_link: "/projects/flink_v1/files/views%2Fbigquery_tables%2Fcurated_layer%2Forders.view.lkml?line=1782"
        permanent:
        source_file: views/extended_tables/orders_using_hubs.view.lkml
        source_file_path: flink_v1/views/extended_tables/orders_using_hubs.view.lkml
        sql: "${cnt_orders_fulfilled_over_30_min} / NULLIF(${cnt_orders}, 0)"
        sql_case:
        filters:
      dimensions:
      - align: left
        can_filter: true
        category: dimension
        default_filter_value:
        description: 'To use the parameter value in a table calculation (e.g WoW,
          % Growth) we need to materialize it into a dimension '
        enumerations:
        field_group_label: "* Parameters *"
        fill_style:
        fiscal_month_offset: 0
        has_allowed_values: false
        hidden: false
        is_filter: false
        is_numeric: false
        label: "* Orders * Date Granularity Pass Through"
        label_from_parameter:
        label_short: Date Granularity Pass Through
        map_layer:
        name: orders_cl.date_granularity_pass_through
        strict_value_format: false
        requires_refresh_on_sort: false
        sortable: true
        suggestions:
        tags: []
        type: string
        user_attribute_filter_types:
        - string
        - advanced_filter_string
        value_format:
        view: orders_cl
        view_label: "* Orders *"
        dynamic: false
        week_start_day: monday
        dimension_group:
        error:
        field_group_variant: Date Granularity Pass Through
        measure: false
        parameter: false
        primary_key: false
        project_name: flink_v1
        scope: orders_cl
        suggest_dimension: orders_cl.date_granularity_pass_through
        suggest_explore: orders_cl
        suggestable: true
        is_fiscal: false
        is_timeframe: false
        can_time_filter: false
        time_interval:
        lookml_link: "/projects/flink_v1/files/views%2Fbigquery_tables%2Fcurated_layer%2Forders.view.lkml?line=1010"
        permanent:
        source_file: views/extended_tables/orders_using_hubs.view.lkml
        source_file_path: flink_v1/views/extended_tables/orders_using_hubs.view.lkml
        sql: |-
          {% if date_granularity._parameter_value == 'Day' %}
                        "Day"
                      {% elsif date_granularity._parameter_value == 'Week' %}
                        "Week"
                      {% elsif date_granularity._parameter_value == 'Month' %}
                        "Month"
                      {% endif %}
        sql_case:
        filters:
      - align: left
        can_filter: true
        category: dimension
        default_filter_value:
        description:
        enumerations:
        field_group_label: "* Dates and Timestamps *"
        fill_style:
        fiscal_month_offset: 0
        has_allowed_values: false
        hidden: false
        is_filter: false
        is_numeric: false
        label: "* Orders * Date (Dynamic)"
        label_from_parameter: orders_cl.date_granularity
        label_short: Date (Dynamic)
        map_layer:
        name: orders_cl.date
        strict_value_format: false
        requires_refresh_on_sort: false
        sortable: true
        suggestions:
        tags: []
        type: string
        user_attribute_filter_types:
        - string
        - advanced_filter_string
        value_format:
        view: orders_cl
        view_label: "* Orders *"
        dynamic: false
        week_start_day: monday
        dimension_group:
        error:
        field_group_variant: Date (Dynamic)
        measure: false
        parameter: false
        primary_key: false
        project_name: flink_v1
        scope: orders_cl
        suggest_dimension: orders_cl.date
        suggest_explore: orders_cl
        suggestable: true
        is_fiscal: false
        is_timeframe: false
        can_time_filter: false
        time_interval:
        lookml_link: "/projects/flink_v1/files/views%2Fbigquery_tables%2Fcurated_layer%2Forders.view.lkml?line=996"
        permanent:
        source_file: views/extended_tables/orders_using_hubs.view.lkml
        source_file_path: flink_v1/views/extended_tables/orders_using_hubs.view.lkml
        sql: |-
          {% if date_granularity._parameter_value == 'Day' %}
                ${created_date}
              {% elsif date_granularity._parameter_value == 'Week' %}
                ${created_week}
              {% elsif date_granularity._parameter_value == 'Month' %}
                ${created_month}
              {% endif %}
        sql_case:
        filters:
        sorted:
          desc: true
          sort_index: 0
      table_calculations:
      - label: PoP
        name: pop
        expression: "case(when(diff_days(to_date(${orders_cl.date}),offset(to_date(${orders_cl.date}),7))\
          \ = null,null),\n  \n  when(${orders_cl.date_granularity_pass_through} =\
          \ \"Day\" \n    AND diff_days(to_date(${orders_cl.date}),offset(to_date(${orders_cl.date}),7))\
          \ = -7,\n    ( ${orders_cl.cnt_orders} - offset(${orders_cl.cnt_orders},\
          \ 7) ) / offset(${orders_cl.cnt_orders}, 7)),\n  when(${orders_cl.date_granularity_pass_through}\
          \ = \"Day\"  AND offset(to_date(${orders_cl.date}),7) = null,null),\n  when(${orders_cl.date_granularity_pass_through}\
          \ = \"Day\" \n    AND diff_days(to_date(${orders_cl.date}),\n      offset(to_date(${orders_cl.date}),7))\
          \ != -7,( ${orders_cl.cnt_orders} - offset(${orders_cl.cnt_orders}, 6) )\
          \ / offset(${orders_cl.cnt_orders}, 6)),\n  when(${orders_cl.date_granularity_pass_through}\
          \ = \"Week\" OR ${orders_cl.date_granularity_pass_through} = \"Month\",\
          \ \n  ( ${orders_cl.cnt_orders} - offset(${orders_cl.cnt_orders}, 1) ) /\
          \ offset(${orders_cl.cnt_orders}, 1)),null)"
        can_pivot: true
        sortable: false
        type: number
        align: right
        measure: true
        is_table_calculation: true
        dynamic: true
        value_format: '"▲  "+0%; "▼  "-0%; 0'
        is_numeric: true
      - label: PoP (GMV)
        name: pop_gmv
        expression: "\n\ncase(when(diff_days(to_date(${orders_cl.date}),offset(to_date(${orders_cl.date}),7))\
          \ = null,null),\n  \n  when(${orders_cl.date_granularity_pass_through} =\
          \ \"Day\" \n    AND diff_days(to_date(${orders_cl.date}),offset(to_date(${orders_cl.date}),7))\
          \ = -7,\n    ( ${orders_cl.sum_gmv_gross} - offset(${orders_cl.sum_gmv_gross},\
          \ 7) ) / offset(${orders_cl.sum_gmv_gross}, 7)),\n  when(${orders_cl.date_granularity_pass_through}\
          \ = \"Day\"  AND offset(to_date(${orders_cl.date}),7) = null,null),\n  when(${orders_cl.date_granularity_pass_through}\
          \ = \"Day\" \n    AND diff_days(to_date(${orders_cl.date}),\n      offset(to_date(${orders_cl.date}),7))\
          \ != -7,( ${orders_cl.sum_gmv_gross} - offset(${orders_cl.sum_gmv_gross},\
          \ 6) ) / offset(${orders_cl.sum_gmv_gross}, 6)),\n  when(${orders_cl.date_granularity_pass_through}\
          \ = \"Week\" OR ${orders_cl.date_granularity_pass_through} = \"Month\",\
          \ \n  ( ${orders_cl.sum_gmv_gross} - offset(${orders_cl.sum_gmv_gross},\
          \ 1) ) / offset(${orders_cl.sum_gmv_gross}, 1)),null)"
        can_pivot: true
        sortable: false
        type: number
        align: right
        measure: true
        is_table_calculation: true
        dynamic: true
        value_format: '"▲  "+0%; "▼  "-0%; 0'
        is_numeric: true
      pivots: []
    listen:
      Date Granularity: orders_cl.date_granularity
      Country Iso: hubs.country_iso
      City: hubs.city
      Hub Name: orders_cl.warehouse_name
      Order Day of Week: orders_cl.created_day_of_week
      'Order Date ': global_filters_and_parameters.datasource_filter
    row: 6
    col: 0
    width: 24
    height: 7
  - title: GMV vs AOV
    name: GMV vs AOV
    model: flink_v3
    explore: orders_cl
    type: looker_line
    fields: [orders_cl.sum_gmv_gross, orders_cl.avg_order_value_gross, orders_cl.date]
    filters:
      orders_cl.is_successful_order: 'yes'
      hubs.country: ''
      hubs.hub_name: ''
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
      Date Granularity: orders_cl.date_granularity
      Country Iso: hubs.country_iso
      City: hubs.city
      Hub Name: orders_cl.warehouse_name
      Order Day of Week: orders_cl.created_day_of_week
      'Order Date ': global_filters_and_parameters.datasource_filter
    row: 13
    col: 0
    width: 8
    height: 6
  - title: Orders vs Fulfillment Time
    name: Orders vs Fulfillment Time
    model: flink_v3
    explore: orders_cl
    type: looker_line
    fields: [orders_cl.cnt_orders, orders_cl.avg_fulfillment_time, orders_cl.avg_promised_eta,
      orders_cl.date]
    filters:
      orders_cl.is_successful_order: 'yes'
      hubs.country: ''
      hubs.hub_name: ''
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
          {axisId: orders_cl.avg_promised_eta, id: orders_cl.avg_promised_eta, name: AVG
              PDT}], showLabels: true, showValues: true, unpinAxis: false, tickDensity: default,
        tickDensityCustom: 5, type: linear}]
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
      Date Granularity: orders_cl.date_granularity
      Country Iso: hubs.country_iso
      City: hubs.city
      Hub Name: orders_cl.warehouse_name
      Order Day of Week: orders_cl.created_day_of_week
      'Order Date ': global_filters_and_parameters.datasource_filter
    row: 13
    col: 16
    width: 8
    height: 6
  - title: Operations - Order Timings
    name: Operations - Order Timings
    model: flink_v3
    explore: orders_cl
    type: looker_column
    fields: [orders_cl.avg_fulfillment_time, orders_cl.avg_reaction_time, orders_cl.avg_picking_time,
      orders_cl.avg_acceptance_time, orders_cl.avg_delivery_time, orders_cl.avg_promised_eta,
      orders_cl.date, orders_cl.avg_delivery_time_estimate, orders_cl.avg_return_to_hub_time,
      orders_cl.avg_at_customer_time]
    filters:
      orders_cl.is_successful_order: 'yes'
      hubs.country: ''
      hubs.hub_name: ''
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
      orders_cl.avg_delivery_time_estimate: line
    series_colors:
      orders_cl.cnt_orders: "#F9AB00"
      orders_cl.avg_fulfillment_time: "#e88359"
    series_labels:
      orders_cl.avg_fulfillment_time: AVG Fulfillment Time (dec.)
    trend_lines: []
    show_null_points: true
    interpolation: linear
    defaults_version: 1
    hidden_fields: []
    listen:
      Date Granularity: orders_cl.date_granularity
      Country Iso: hubs.country_iso
      City: hubs.city
      Hub Name: orders_cl.warehouse_name
      Order Day of Week: orders_cl.created_day_of_week
      'Order Date ': global_filters_and_parameters.datasource_filter
    row: 19
    col: 0
    width: 11
    height: 6
  - title: Orders
    name: Orders
    model: flink_v3
    explore: orders_cl
    type: single_value
    fields: [orders_cl.created_date, orders_cl.cnt_orders]
    fill_fields: [orders_cl.created_date]
    filters:
      orders_cl.is_successful_order: 'yes'
      orders_cl.created_date: 28 days ago for 28 days
      hubs.country: ''
      hubs.hub_name: ''
    sorts: [orders_cl.created_date desc]
    limit: 500
    dynamic_fields: [{table_calculation: display_number, label: display_number, expression: 'max(${running_orders})',
        value_format: !!null '', value_format_name: decimal_0, is_disabled: true,
        _kind_hint: dimension, _type_hint: number}, {category: table_calculation,
        expression: "(${orders_cl.cnt_orders} - offset(${orders_cl.cnt_orders}, 7))\
          \ / offset(${orders_cl.cnt_orders}, 7)", label: WoW, value_format: !!null '',
        value_format_name: percent_0, _kind_hint: measure, table_calculation: wow,
        _type_hint: number}]
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
      Date Granularity: orders_cl.date_granularity
      Country Iso: hubs.country_iso
      City: hubs.city
      Hub Name: orders_cl.warehouse_name
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
    fill_fields: [orders_cl.created_date]
    filters:
      orders_cl.is_successful_order: 'yes'
      orders_cl.created_date: 28 days ago for 28 days
      hubs.country: ''
      hubs.hub_name: ''
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
        is_disabled: true, _kind_hint: measure, _type_hint: number}, {category: table_calculation,
        expression: "(${orders_cl.sum_gmv_gross} - offset(${orders_cl.sum_gmv_gross},\
          \ 7)) / offset(${orders_cl.sum_gmv_gross}, 7)", label: WoW, value_format: !!null '',
        value_format_name: percent_0, _kind_hint: measure, table_calculation: wow,
        _type_hint: number}]
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
      Date Granularity: orders_cl.date_granularity
      Country Iso: hubs.country_iso
      City: hubs.city
      Hub Name: orders_cl.warehouse_name
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
      orders_cl.is_successful_order: 'yes'
      orders_cl.created_date: yesterday
      hubs.country: ''
      hubs.hub_name: ''
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
      Date Granularity: orders_cl.date_granularity
      Country Iso: hubs.country_iso
      City: hubs.city
      Hub Name: orders_cl.warehouse_name
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
      orders_cl.is_successful_order: 'yes'
      orders_cl.created_date: 28 days ago for 28 days
      hubs.live: ''
      hubs.country: ''
      hubs.hub_name: ''
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
      Date Granularity: orders_cl.date_granularity
      Country Iso: hubs.country_iso
      City: hubs.city
      Hub Name: orders_cl.warehouse_name
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
      orders_cl.is_successful_order: 'yes'
      hubs.country: ''
      hubs.hub_name: ''
      orders_cl.created_date: 30 days ago for 30 days
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
      Date Granularity: orders_cl.date_granularity
      Country Iso: hubs.country_iso
      City: hubs.city
      Hub Name: orders_cl.warehouse_name
      Order Day of Week: orders_cl.created_day_of_week
      'Order Date ': global_filters_and_parameters.datasource_filter
    row: 19
    col: 11
    width: 4
    height: 6
  - name: " (2)"
    type: text
    title_text: ''
    body_text: '<img src="https://i.imgur.com/KcWQwrB.png" width="75%"> '
    row: 0
    col: 0
    width: 8
    height: 4
  - name: " (3)"
    type: text
    title_text: ''
    body_text: |-
      ### Performance

      #### Yesterday
    row: 4
    col: 0
    width: 3
    height: 2
  - title: NPS
    name: NPS
    model: flink_v3
    explore: orders_cl
    type: looker_line
    fields: [nps_after_order.nps_score, orders_cl.date, nps_after_order.cnt_responses]
    filters:
      orders_cl.is_successful_order: 'yes'
      hubs.country: ''
      hubs.hub_name: ''
    sorts: [orders_cl.date]
    limit: 500
    column_limit: 50
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
    y_axes: [{label: '', orientation: left, series: [{axisId: nps_after_order.nps_score,
            id: nps_after_order.nps_score, name: "% NPS"}], showLabels: true, showValues: true,
        unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear},
      {label: !!null '', orientation: left, series: [{axisId: nps_after_order.count,
            id: nps_after_order.count, name: NPS After Order}], showLabels: true,
        showValues: true, unpinAxis: false, tickDensity: default, tickDensityCustom: 5,
        type: linear}]
    trellis_rows: 2
    series_types:
      nps_after_order.cnt_responses: area
    series_colors:
      nps_after_order.cnt_responses: "#ffe48f"
      nps_after_order.nps_score: "#E7428C"
    series_labels: {}
    hidden_fields: []
    hidden_points_if_no: []
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
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    listen:
      Date Granularity: orders_cl.date_granularity
      Country Iso: hubs.country_iso
      City: hubs.city
      Hub Name: orders_cl.warehouse_name
      Order Day of Week: orders_cl.created_day_of_week
      'Order Date ': global_filters_and_parameters.datasource_filter
    row: 19
    col: 15
    width: 9
    height: 6
  - title: Issue Rates - Timeseries
    name: Issue Rates - Timeseries
    model: flink_v3
    explore: order_orderline_cl
    type: looker_column
    fields: [orders_cl.date, orderline.pct_wrong_product_issue_rate, orderline.pct_missing_product_issue_rate,
      orderline.pct_perished_product_issue_rate, orderline.pct_damaged_product_issue_rate,
      orderline.pct_cancelled_product_issue_rate, orderline.pct_swapped_product_issue_rate]
    filters:
      orders_cl.is_successful_order: 'yes'
      hubs.country: ''
      hubs.hub_name: ''
    sorts: [orders_cl.date]
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
    defaults_version: 1
    listen:
      Country Iso: hubs.country_iso
      City: hubs.city
      Hub Name: orders_cl.warehouse_name
      Order Day of Week: orders_cl.created_day_of_week
      'Order Date ': global_filters_and_parameters.datasource_filter
    row: 25
    col: 0
    width: 24
    height: 6
  - title: Pre-Order Fulfillment Rate
    name: Pre-Order Fulfillment Rate
    model: flink_v3
    explore: order_orderline_cl
    type: looker_line
    fields: [orders_cl.date, orderline.pct_pre_order_fulfillment_rate]
    filters:
      orders_cl.is_successful_order: 'yes'
      hubs.country: ''
      hubs.hub_name: ''
    sorts: [orders_cl.date]
    limit: 500
    column_limit: 50
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
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
    y_axes: [{label: '', orientation: left, series: [{axisId: orderline.pct_pre_order_fulfillment_rate,
            id: orderline.pct_pre_order_fulfillment_rate, name: "% Pre-Order Fulfillment\
              \ Rate"}], showLabels: false, showValues: false, unpinAxis: true, tickDensity: default,
        tickDensityCustom: 5, type: linear}]
    series_types: {}
    series_colors:
      orderline.pct_pre_order_fulfillment_rate: "#e5508e"
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    listen:
      Country Iso: hubs.country_iso
      City: hubs.city
      Hub Name: orders_cl.warehouse_name
      Order Day of Week: orders_cl.created_day_of_week
      'Order Date ': global_filters_and_parameters.datasource_filter
    row: 31
    col: 0
    width: 24
    height: 6
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
      options: []
    model: flink_v3
    explore: orders_cl
    listens_to_filters: []
    field: hubs.country_iso
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
    field: orders_cl.warehouse_name
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
  - name: 'Order Date '
    title: 'Order Date '
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
    field: global_filters_and_parameters.datasource_filter
