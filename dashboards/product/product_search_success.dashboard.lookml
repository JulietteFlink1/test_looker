- dashboard: product_search_success_updated
  title: Product Search Success Updated
  layout: newspaper
  preferred_viewer: dashboards-next
  description: ''
  elements:
  - title: Most Commonly Searched Terms
    name: Most Commonly Searched Terms
    model: flink_v3
    explore: product_search_executed
    type: looker_wordcloud
    fields: [product_search_executed.search_query_clean, search_query_len, product_search_executed.cnt_unique_anonymousid]
    filters:
      product_search_executed.search_query: "-NULL"
      search_query_len: ">1"
    sorts: [product_search_executed.cnt_unique_anonymousid desc]
    limit: 150
    dynamic_fields: [{dimension: new_dimension, _kind_hint: dimension, _type_hint: number,
        category: dimension, expression: 'length(${product_search_executed.search_query})',
        label: New Dimension, value_format: !!null '', value_format_name: !!null ''},
      {dimension: search_query_len, _kind_hint: dimension, _type_hint: number, category: dimension,
        expression: 'length(${product_search_executed.search_query_clean})', label: search
          query len, value_format: !!null '', value_format_name: decimal_0}]
    query_timezone: Europe/Berlin
    color_application:
      collection_id: aed851c8-b22d-4b01-8fff-4b02b91fe78d
      palette_id: a77d2b8b-ee06-4086-8459-cfff9cccb2d2
      options:
        steps: 5
        reverse: true
    rotation: true
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
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    series_types: {}
    hidden_fields: [search_query_len]
    y_axes: []
    note_state: collapsed
    note_display: hover
    note_text: Common queries where size increases with number of unique users that
      searched for this. Filtered out single letters.
    listen:
      Search Results Total Count: product_search_executed.search_results_total_count
      Search Results Available Count: product_search_executed.search_results_available_count
      Search Results Unavailable Count: product_search_executed.search_results_unavailable_count
      Search Date: product_search_executed.timestamp_date
      Country: product_search_executed.country_clean
      Hub: product_search_executed.derived_hub
      Search Engine: product_search_executed.search_engine
    row: 2
    col: 14
    width: 10
    height: 12
  - name: "## Did Users Find What They Are Looking For? ##"
    type: text
    title_text: "## Did Users Find What They Are Looking For? ##"
    subtitle_text: ''
    body_text: ''
    row: 0
    col: 0
    width: 14
    height: 2
  - name: "## What Did Users Do After Searching? ##"
    type: text
    title_text: "## What Did Users Do After Searching? ##"
    subtitle_text: ''
    body_text: ''
    row: 27
    col: 0
    width: 24
    height: 2
  - name: "## What Were Users Looking For? ##"
    type: text
    title_text: "## What Were Users Looking For? ##"
    subtitle_text: ''
    body_text: ''
    row: 0
    col: 14
    width: 10
    height: 2
  - title: only unavailable KPI
    name: only unavailable KPI
    model: flink_v3
    explore: product_search_executed
    type: single_value
    fields: [product_search_executed.timestamp_date, product_search_executed.count,
      product_search_executed.cnt_nonzero_only_unavailable_results, sum_search_results_total,
      sum_search_results_unavailable]
    fill_fields: [product_search_executed.timestamp_date]
    filters:
      product_search_executed.timestamp_date: 14 days
      product_search_executed.event: '"product_search_executed"'
      product_search_executed.search_query: "-NULL"
    sorts: [product_search_executed.timestamp_date desc]
    limit: 500
    column_limit: 50
    dynamic_fields: [{_kind_hint: measure, table_calculation: unavailability_ratio_this_week,
        _type_hint: number, category: table_calculation, expression: 'mean(offset_list(${sum_search_results_unavailable}/(${sum_search_results_total}),0,7))',
        label: unavailability ratio this week, value_format: !!null '', value_format_name: percent_2},
      {_kind_hint: measure, table_calculation: unavailability_ratio_last_week, _type_hint: number,
        category: table_calculation, expression: 'mean(offset_list(${sum_search_results_unavailable}/(${sum_search_results_total}),7,7))',
        label: unavailability ratio last week, value_format: !!null '', value_format_name: percent_2},
      {_kind_hint: measure, table_calculation: percentage_this_vs_last_week, _type_hint: number,
        category: table_calculation, expression: "${unavailability_ratio_this_week}-${unavailability_ratio_last_week}",
        label: percentage this vs last week, value_format: !!null '', value_format_name: percent_2},
      {based_on: product_search_executed.search_results_total_count, _kind_hint: measure,
        measure: sum_search_results_total, type: sum, _type_hint: number, category: measure,
        expression: !!null '', label: sum search results total, value_format: !!null '',
        value_format_name: !!null ''}, {based_on: product_search_executed.search_results_unavailable_count,
        _kind_hint: measure, measure: sum_search_results_unavailable, type: sum, _type_hint: number,
        category: measure, expression: !!null '', label: sum search results unavailable,
        value_format: !!null '', value_format_name: !!null ''}]
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: true
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    custom_color: "#9334E6"
    single_value_title: Search Results Out Of Stock (AVG Last 7 Days)
    comparison_label: From Prior 7 Days
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
    hidden_fields: [product_search_executed.count, percentage_non_zero_results_last_week,
      product_search_executed.cnt_nonzero_only_unavailable_results, percentage_only_unavailable_results_last_week,
      sum_search_results_total, sum_search_results_unavailable, unavailability_ratio_last_week]
    y_axes: []
    note_state: expanded
    note_display: above
    note_text: Percentage of the returned results that were products out of stock
    listen:
      Country: product_search_executed.country_clean
      Hub: product_search_executed.derived_hub
      Search Engine: product_search_executed.search_engine
    row: 2
    col: 7
    width: 7
    height: 5
  - title: Search Results Overview
    name: Search Results Overview
    model: flink_v3
    explore: product_search_executed
    type: looker_area
    fields: [product_search_executed.timestamp_date, product_search_executed.count,
      product_search_executed.cnt_nonzero_available_results, product_search_executed.cnt_zero_available_results,
      product_search_executed.cnt_nonzero_only_unavailable_results, product_search_executed.cnt_nonzero_total_results,
      product_search_executed.cnt_zero_total_results]
    fill_fields: [product_search_executed.timestamp_date]
    filters:
      product_search_executed.search_query: "-NULL"
      product_search_executed.event: '"product_search_executed"'
    sorts: [product_search_executed.timestamp_date desc]
    limit: 500
    column_limit: 50
    dynamic_fields: [{_kind_hint: measure, table_calculation: percentage_searches_has_available_products,
        _type_hint: number, category: table_calculation, expression: "${product_search_executed.cnt_nonzero_available_results}/(${product_search_executed.count})",
        label: Percentage searches has available products, value_format: !!null '',
        value_format_name: percent_2}, {_kind_hint: measure, table_calculation: percentage_nonzero_results,
        _type_hint: number, category: table_calculation, expression: "${product_search_executed.cnt_nonzero_total_results}/(${product_search_executed.count})",
        label: Percentage nonzero results, value_format: !!null '', value_format_name: percent_2},
      {_kind_hint: measure, table_calculation: percentage_searches_has_only_unavailable_results,
        _type_hint: number, category: table_calculation, expression: "${product_search_executed.cnt_nonzero_only_unavailable_results}/${product_search_executed.count}",
        label: Percentage searches has only unavailable results, value_format: !!null '',
        value_format_name: percent_2}, {_kind_hint: measure, table_calculation: percentage_searches_has_no_results,
        _type_hint: number, category: table_calculation, expression: "${product_search_executed.cnt_zero_total_results}/${product_search_executed.count}",
        label: Percentage searches has no results, value_format: !!null '', value_format_name: percent_2}]
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
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    color_application:
      collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      palette_id: c65a64ce-7f46-476b-a320-41345941e5b1
      options:
        steps: 5
        reverse: false
    series_types: {}
    series_colors: {}
    defaults_version: 1
    ordering: none
    show_null_labels: false
    hidden_fields: [product_search_executed.cnt_nonzero_available_results, product_search_executed.cnt_zero_available_results,
      percentage_nonzero_results, product_search_executed.cnt_nonzero_only_unavailable_results,
      product_search_executed.cnt_nonzero_total_results, product_search_executed.count,
      product_search_executed.cnt_zero_total_results]
    y_axes: []
    note_state: collapsed
    note_display: hover
    note_text: 'Percentage of the search results that resulted in: the users being
      shown product(s) that are in stock, the user being shown only product(s) that
      are out of stock, or the user not getting any results (product not found / not
      in offering)'
    listen:
      Search Date: product_search_executed.timestamp_date
      Country: product_search_executed.country_clean
      Hub: product_search_executed.derived_hub
      Search Engine: product_search_executed.search_engine
    row: 7
    col: 0
    width: 14
    height: 7
  - title: Top 10 Events Following Search Execution
    name: Top 10 Events Following Search Execution
    model: flink_v3
    explore: product_search_executed
    type: looker_bar
    fields: [product_search_executed.next_event, product_search_executed.count]
    filters:
      product_search_executed.count: ">5"
      product_search_executed.search_query: "-NULL"
      product_search_executed.next_event: "-api%"
    sorts: [product_search_executed.count desc]
    limit: 10
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
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    y_axes: [{label: Occurence Count, orientation: bottom, series: [{axisId: product_search_executed.count,
            id: product_search_executed.count, name: Product Search Keywords}],
        showLabels: true, showValues: true, valueFormat: '[>=1000000]0,," M";[>=1000]0,"
          k";0', unpinAxis: false, tickDensity: default, tickDensityCustom: 5, type: linear}]
    x_axis_label: Event After Product Search
    hide_legend: false
    series_types: {}
    series_colors:
      product_search_executed.count: "#079c98"
    defaults_version: 1
    hidden_fields: []
    listen:
      Search Results Total Count: product_search_executed.search_results_total_count
      Search Results Available Count: product_search_executed.search_results_available_count
      Search Results Unavailable Count: product_search_executed.search_results_unavailable_count
      Search Date: product_search_executed.timestamp_date
      Country: product_search_executed.country_clean
      Hub: product_search_executed.derived_hub
      Search Engine: product_search_executed.search_engine
    row: 29
    col: 0
    width: 24
    height: 9
  - title: product search keywords KPI zero results
    name: product search keywords KPI zero results
    model: flink_v3
    explore: product_search_executed
    type: single_value
    fields: [product_search_executed.timestamp_date, product_search_executed.count,
      product_search_executed.cnt_nonzero_total_results, product_search_executed.cnt_zero_total_results]
    fill_fields: [product_search_executed.timestamp_date]
    filters:
      product_search_executed.timestamp_date: 14 days
      product_search_executed.event: '"product_search_executed"'
      product_search_executed.search_query: "-NULL"
    sorts: [product_search_executed.timestamp_date desc]
    limit: 500
    column_limit: 50
    dynamic_fields: [{_kind_hint: measure, table_calculation: percentage_zero_results_this_week,
        _type_hint: number, category: table_calculation, expression: 'mean(offset_list(${product_search_executed.cnt_zero_total_results}/(${product_search_executed.cnt_zero_total_results}+${product_search_executed.cnt_nonzero_total_results}),0,7))',
        label: percentage zero results this week, value_format: !!null '', value_format_name: percent_2},
      {_kind_hint: measure, table_calculation: percentage_zero_results_last_week,
        _type_hint: number, category: table_calculation, expression: 'mean(offset_list(${product_search_executed.cnt_zero_total_results}/(${product_search_executed.cnt_zero_total_results}+${product_search_executed.cnt_nonzero_total_results}),7,7))',
        label: percentage zero results last week, value_format: !!null '', value_format_name: percent_2},
      {_kind_hint: measure, table_calculation: percentage_zero_results_this_vs_last_week,
        _type_hint: number, category: table_calculation, expression: "${percentage_zero_results_last_week}-${percentage_zero_results_this_week}",
        label: percentage zero results this vs last week, value_format: !!null '',
        value_format_name: percent_2}]
    custom_color_enabled: true
    show_single_value_title: true
    show_comparison: true
    comparison_type: change
    comparison_reverse_colors: true
    show_comparison_label: true
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    custom_color: "#1A73E8"
    single_value_title: Search Returned Zero Products (AVG Last 7 days)
    comparison_label: From Prior 7 Days
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
    hidden_fields: [product_search_executed.count, product_search_executed.cnt_nonzero_total_results,
      product_search_executed.cnt_zero_total_results, percentage_non_zero_results_last_week,
      percentage_zero_results_last_week]
    y_axes: []
    note_state: expanded
    note_display: above
    note_text: Percentage of searches that returned zero product matches
    listen:
      Country: product_search_executed.country_clean
      Hub: product_search_executed.derived_hub
      Search Engine: product_search_executed.search_engine
    row: 2
    col: 0
    width: 7
    height: 5
  - title: Product Search Results Details
    name: Product Search Results Details
    model: flink_v3
    explore: product_search_executed
    type: looker_grid
    fields: [product_search_executed.search_query_clean, search_query_length,
      product_search_executed.count, product_search_executed.cnt_unique_anonymousid,
      product_search_executed.cnt_nonzero_available_results, product_search_executed.cnt_zero_available_results,
      product_search_executed.cnt_nonzero_only_unavailable_results, product_search_executed.cnt_nonzero_total_results,
      product_search_executed.cnt_zero_total_results, sum_search_results_total,
      sum_search_results_unavailable]
    filters:
      product_search_executed.search_query: "-NULL"
      product_search_executed.event: '"product_search_executed"'
      product_search_executed.cnt_unique_anonymousid: ">5"
      search_query_length: ">1"
    sorts: [product_search_executed.cnt_unique_anonymousid desc]
    limit: 500
    column_limit: 50
    dynamic_fields: [{_kind_hint: measure, table_calculation: percentage_searches_has_available_products,
        _type_hint: number, category: table_calculation, expression: "${product_search_executed.cnt_nonzero_available_results}/(${product_search_executed.count})",
        label: Percentage searches has available products, value_format: !!null '',
        value_format_name: percent_2}, {_kind_hint: measure, table_calculation: percentage_nonzero_results,
        _type_hint: number, category: table_calculation, expression: "${product_search_executed.cnt_nonzero_total_results}/(${product_search_executed.count})",
        label: Percentage nonzero results, value_format: !!null '', value_format_name: percent_2},
      {_kind_hint: measure, table_calculation: percentage_searches_has_only_unavailable_results,
        _type_hint: number, category: table_calculation, expression: "${product_search_executed.cnt_nonzero_only_unavailable_results}/${product_search_executed.count}",
        label: Percentage searches has only unavailable results, value_format: !!null '',
        value_format_name: percent_2}, {_kind_hint: measure, table_calculation: percentage_searches_has_no_results,
        _type_hint: number, category: table_calculation, expression: "${product_search_executed.cnt_zero_total_results}/${product_search_executed.count}",
        label: Percentage searches has no results, value_format: !!null '', value_format_name: percent_2},
      {_kind_hint: measure, table_calculation: unavailability_ratio, _type_hint: number,
        category: table_calculation, description: Amount of out-of-stock results for
          this query compared to the total number of results for this query, expression: "${sum_search_results_unavailable}/${sum_search_results_total}",
        label: Unavailability Ratio, value_format: !!null '', value_format_name: percent_2},
      {dimension: search_query_length, _kind_hint: dimension, _type_hint: number,
        category: dimension, expression: 'length(${product_search_executed.search_query_clean})',
        label: search query length, value_format: !!null '', value_format_name: !!null ''},
      {based_on: product_search_executed.search_results_total_count, _kind_hint: measure,
        measure: sum_search_results_total, type: sum, _type_hint: number, category: measure,
        expression: !!null '', label: sum search results total, value_format: !!null '',
        value_format_name: !!null ''}, {based_on: product_search_executed.search_results_unavailable_count,
        _kind_hint: measure, measure: sum_search_results_unavailable, type: sum, _type_hint: number,
        category: measure, expression: !!null '', label: sum search results unavailable,
        value_format: !!null '', value_format_name: !!null ''}]
    show_view_names: true
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
    color_application:
      collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
      palette_id: c65a64ce-7f46-476b-a320-41345941e5b1
      options:
        steps: 5
        reverse: false
    show_sql_query_menu_options: false
    pinned_columns:
      "$$$_row_numbers_$$$": left
      product_search_executed.search_query_clean: left
    column_order: ["$$$_row_numbers_$$$", product_search_executed.search_query_clean,
      product_search_executed.cnt_unique_anonymousid, product_search_executed.count,
      unavailability_ratio, product_search_executed.cnt_zero_total_results, percentage_searches_has_no_results,
      product_search_executed.cnt_nonzero_only_unavailable_results, percentage_searches_has_only_unavailable_results,
      product_search_executed.cnt_nonzero_available_results, percentage_searches_has_available_products,
      sum_search_results_total, sum_search_results_unavailable]
    show_totals: true
    show_row_totals: true
    series_labels:
      product_search_executed.search_query: Search Query
      product_search_executed.count: "# Searches"
      product_search_executed.cnt_nonzero_only_unavailable_results: Unavailable
        Results Only
      product_search_executed.cnt_zero_total_results: No results
      percentage_searches_has_available_products: "%  Has Available Results"
      percentage_searches_has_only_unavailable_results: "% Has Unavailable Only"
      percentage_searches_has_no_results: "% No Results"
      product_search_executed.cnt_unique_anonymousid: Unique Users Count
      product_search_executed.cnt_nonzero_available_results: Available Results
      unavailability_ratio: Unavailability Ratio
      product_search_executed.search_query_initcap: Search Query
      product_search_executed.search_query_clean: Search Query
    series_column_widths: {}
    series_cell_visualizations:
      product_search_executed.count:
        is_active: true
        palette:
          palette_id: b0de9e6d-3de9-167f-a2aa-b82c245968ec
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
          custom_colors:
          - "#FFFFFF"
          - "#30c23d"
      product_search_executed.cnt_nonzero_only_unavailable_results:
        is_active: false
      product_search_executed.cnt_unique_anonymousid:
        is_active: true
        palette:
          palette_id: ef0927d5-a0d8-c3ce-9ade-98c322a064e8
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
          custom_colors:
          - "#FFFFFF"
          - "#b3c246"
      unavailability_ratio:
        is_active: true
        palette:
          palette_id: 440c3a7c-1989-53d2-93ee-70beafa46328
          collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2
          custom_colors:
          - "#1a73e8"
          - "#E52592"
    series_text_format:
      product_search_executed.search_query: {}
      product_search_executed.cnt_nonzero_only_unavailable_results: {}
    conditional_formatting: [{type: along a scale..., value: !!null '', background_color: !!null '',
        font_color: !!null '', color_application: {collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2,
          palette_id: c65a64ce-7f46-476b-a320-41345941e5b1, options: {steps: 5, stepped: false,
            mirror: false, constraints: {min: {type: percentile, value: 4}, max: {
                type: percentile, value: 96}}}}, bold: false, italic: false, strikethrough: false,
        fields: [percentage_searches_has_only_unavailable_results, percentage_searches_has_no_results]},
      {type: along a scale..., value: !!null '', background_color: !!null '', font_color: !!null '',
        color_application: {collection_id: 7c56cc21-66e4-41c9-81ce-a60e1c3967b2, palette_id: c65a64ce-7f46-476b-a320-41345941e5b1,
          options: {steps: 5, reverse: true, constraints: {max: {type: percentile,
                value: 96}, min: {type: percentile, value: 4}}}}, bold: false, italic: false,
        strikethrough: false, fields: [percentage_searches_has_available_products]}]
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
    stacking: normal
    legend_position: center
    series_types: {}
    point_style: none
    series_colors: {}
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    ordering: none
    show_null_labels: false
    hidden_fields: [product_search_executed.cnt_zero_available_results, percentage_nonzero_results,
      product_search_executed.cnt_nonzero_total_results, search_query_length,
      sum_search_results_total, sum_search_results_unavailable]
    y_axes: []
    note_state: expanded
    note_display: below
    note_text: |-
      <p align="center">
      =========================== NOTE ==========================
      For a fraction of the searches a query that is within our offering returns no results, e.g. "Bier". The cause was investigated and a ticket to resolve it created.
      ====================================================================
      </p>
    listen:
      Search Results Total Count: product_search_executed.search_results_total_count
      Search Results Available Count: product_search_executed.search_results_available_count
      Search Results Unavailable Count: product_search_executed.search_results_unavailable_count
      Search Date: product_search_executed.timestamp_date
      Country: product_search_executed.country_clean
      Hub: product_search_executed.derived_hub
      Search Engine: product_search_executed.search_engine
    row: 14
    col: 0
    width: 24
    height: 13
  filters:
  - name: Search Date
    title: Search Date
    type: field_filter
    default_value: 7 day
    allow_multiple_values: true
    required: false
    ui_config:
      type: relative_timeframes
      display: inline
      options: []
    model: flink_v3
    explore: product_search_executed
    listens_to_filters: []
    field: product_search_executed.timestamp_date
  - name: Search Results Total Count
    title: Search Results Total Count
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
      options: []
    model: flink_v3
    explore: product_search_executed
    listens_to_filters: []
    field: product_search_executed.search_results_total_count
  - name: Search Results Available Count
    title: Search Results Available Count
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
      options: []
    model: flink_v3
    explore: product_search_executed
    listens_to_filters: []
    field: product_search_executed.search_results_available_count
  - name: Search Results Unavailable Count
    title: Search Results Unavailable Count
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
      options: []
    model: flink_v3
    explore: product_search_executed
    listens_to_filters: []
    field: product_search_executed.search_results_unavailable_count
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
    explore: product_search_executed
    listens_to_filters: []
    field: product_search_executed.country_clean
  # - name: City
  #   title: City
  #   type: field_filter
  #   default_value: ''
  #   allow_multiple_values: true
  #   required: false
  #   ui_config:
  #     type: dropdown_menu
  #     display: inline
  #     options: []
  #   model: flink_v3
  #   explore: product_search_executed
  #   listens_to_filters: []
  #   field: product_search_executed.city_clean
  - name: Hub
    title: Hub
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
      options: []
    model: flink_v3
    explore: product_search_executed
    listens_to_filters: [City]
    field: product_search_executed.derived_hub
  - name: Search Engine
    title: Search Engine
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: popover
      options: []
    model: flink_v3
    explore: product_search_executed
    listens_to_filters: []
    field: product_search_executed.search_engine
