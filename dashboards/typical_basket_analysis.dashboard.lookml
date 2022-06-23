- dashboard: wip_typical_basket_analysis_
  title: 'WIP Typical Basket Analysis '
  layout: newspaper
  preferred_viewer: dashboards-next
  elements:
  - title: Most Popular Triplets
    name: Most Popular Triplets
    model: flink_v3
    explore: typical_basket_analysis
    type: looker_grid
    fields: [typical_basket_analysis.category_a, typical_basket_analysis.category_b, typical_basket_analysis.category_c,
      typical_basket_analysis.support, typical_basket_analysis.confidence]
    filters:
      typical_basket_analysis.size: '3'
      typical_basket_analysis.avg_orders_per_month: All
      typical_basket_analysis.category_a: "-Special,-Neu hinzugefügte Produkte ��"
      typical_basket_analysis.category_b: "-Special,-Neu hinzugefügte Produkte ��"
      typical_basket_analysis.category_c: "-Special,-Neu hinzugefügte Produkte ��"
    sorts: [typical_basket_analysis.support desc]
    limit: 100
    dynamic_fields: [{measure: sum_of_occurrences, based_on: typical_basket_analysis.occurrences,
        expression: '', label: Sum of Occurrences, type: sum, _kind_hint: measure,
        _type_hint: number}]
    query_timezone: Europe/Berlin
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: false
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    column_order: ["$$$_row_numbers_$$$", typical_basket_analysis.category_a, typical_basket_analysis.category_b,
      typical_basket_analysis.category_c, typical_basket_analysis.support, typical_basket_analysis.confidence]
    show_totals: true
    show_row_totals: true
    series_labels:
      sum_of_occurrences: "# Orders with these Categories"
      typical_basket_analysis.confidence: Likelihood that C is bought if A&B were bought
      typical_basket_analysis.support: "% Orders with at least 1 item of each group"
      typical_basket_analysis.category_a: Category/Sub-Category/Substitute A
      typical_basket_analysis.category_b: Category/Sub-Category/Substitute B
      typical_basket_analysis.category_c: Category/Sub-Category/Substitute C
    series_cell_visualizations:
      sum_of_occurrences:
        is_active: true
      typical_basket_analysis.confidence:
        is_active: true
      typical_basket_analysis.support:
        is_active: true
    series_value_format:
      typical_basket_analysis.confidence:
        name: percent_0
        decimals: '0'
        format_string: "#,##0%"
        label: Percent (0)
        label_prefix: Percent
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
    note_state: expanded
    note_display: above
    title_hidden: true
    listen:
      Granularity: typical_basket_analysis.granularity
      Country: typical_basket_analysis.country_iso
    row: 22
    col: 0
    width: 24
    height: 9
  - title: Most Popular Pairs
    name: Most Popular Pairs
    model: flink_v3
    explore: typical_basket_analysis
    type: looker_grid
    fields: [typical_basket_analysis.category_a, typical_basket_analysis.category_b, typical_basket_analysis.confidence,
      typical_basket_analysis.support]
    filters:
      typical_basket_analysis.size: '2'
      typical_basket_analysis.avg_orders_per_month: All
      typical_basket_analysis.category_a: "-Special,-Neu hinzugefügte Produkte ��"
      typical_basket_analysis.category_b: "-Special,-Neu hinzugefügte Produkte ��"
    sorts: [typical_basket_analysis.support desc]
    limit: 100
    column_limit: 50
    dynamic_fields: [{measure: sum_of_occurrences, based_on: typical_basket_analysis.occurrences,
        expression: '', label: Sum of Occurrences, type: sum, _kind_hint: measure,
        _type_hint: number}]
    query_timezone: Europe/Berlin
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: false
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    column_order: ["$$$_row_numbers_$$$", typical_basket_analysis.category_a, typical_basket_analysis.category_b,
      typical_basket_analysis.support, typical_basket_analysis.confidence]
    show_totals: true
    show_row_totals: true
    series_labels:
      sum_of_occurrences: "# Orders with these Categories"
      typical_basket_analysis.confidence: Likelihood that B is bought if A is bought
      typical_basket_analysis.support: "% Orders with at least 1 item of each group"
      typical_basket_analysis.category_a: Category/Sub-Category/Substitute A
      typical_basket_analysis.category_b: Category/Sub-Category/Substitute B
    series_cell_visualizations:
      sum_of_occurrences:
        is_active: true
      typical_basket_analysis.confidence:
        is_active: true
      typical_basket_analysis.support:
        is_active: true
    series_value_format:
      typical_basket_analysis.confidence:
        name: percent_0
        decimals: '0'
        format_string: "#,##0%"
        label: Percent (0)
        label_prefix: Percent
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
    note_state: expanded
    note_display: above
    title_hidden: true
    listen:
      Granularity: typical_basket_analysis.granularity
      Country: typical_basket_analysis.country_iso
    row: 11
    col: 0
    width: 24
    height: 7
  - title: Most Popular Category/Sub-Category/Substitute
    name: Most Popular Category/Sub-Category/Substitute
    model: flink_v3
    explore: typical_basket_analysis
    type: looker_grid
    fields: [typical_basket_analysis.category_a, typical_basket_analysis.support]
    filters:
      typical_basket_analysis.size: '1'
      typical_basket_analysis.avg_orders_per_month: All
      typical_basket_analysis.category_a: "-Special,-Neu hinzugefügte Produkte ��"
    sorts: [typical_basket_analysis.support desc]
    limit: 100
    column_limit: 50
    dynamic_fields: [{measure: sum_of_occurrences, based_on: typical_basket_analysis.occurrences,
        expression: '', label: Sum of Occurrences, type: sum, _kind_hint: measure,
        _type_hint: number}]
    query_timezone: Europe/Berlin
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: false
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    column_order: ["$$$_row_numbers_$$$", typical_basket_analysis.category_a, typical_basket_analysis.category_b,
      typical_basket_analysis.category_c, typical_basket_analysis.occurrences, typical_basket_analysis.confidence,
      sum_of_occurrences]
    show_totals: true
    show_row_totals: true
    series_labels:
      sum_of_occurrences: "# Orders with these Categories"
      typical_basket_analysis.confidence: Likelihood that C is bought if A&B were bought
      typical_basket_analysis.support: "% Orders with at least one item of the group"
      typical_basket_analysis.category_a: Category/Sub-Category/Substitute
    series_cell_visualizations:
      sum_of_occurrences:
        is_active: true
      typical_basket_analysis.confidence:
        is_active: true
      typical_basket_analysis.support:
        is_active: true
    series_value_format:
      typical_basket_analysis.confidence:
        name: percent_0
        decimals: '0'
        format_string: "#,##0%"
        label: Percent (0)
        label_prefix: Percent
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
      Granularity: typical_basket_analysis.granularity
      Country: typical_basket_analysis.country_iso
    row: 0
    col: 0
    width: 24
    height: 6
  - name: Most Popular Pairs (2)
    type: text
    title_text: Most Popular Pairs
    subtitle_text: ''
    body_text: |+
      ⚠️The pairs will appear **twice** in a **different order**  e.g.: *A) Käse B) Gemüse*  and *A) Gemüse   B) Käse*

      -  **% Orders with at least one item of each group** will be the same (it's independant of the order). *e.g. 9% of the orders have Gemüse and Käse*

      - **% Likelihood that B is bought if A is bought** will differ depending on the order.  *e.g. 50% of the customers who buy Käse also buy Gemüse  but only 30% of the customers who buy Gemüse also buy Käse*

    row: 6
    col: 0
    width: 24
    height: 5
  - name: Most Popular Triplets (2)
    type: text
    title_text: Most Popular Triplets
    subtitle_text: ''
    body_text: |+
      ⚠️The triplets will appear **three times** in a **different order**  e.g.: *A) Käse B) Gemüse  C) Obst* and *A) Gemüse   B) Obst  C) Käse* and *A) Käse B) Obst  C) Gemüse*

      -  **% Orders with at least one item of each group** will be the same for the 3 rows (it's independant of the order). *e.g. 9% of the orders have Gemüse, Käse and Obst*

      - **% Likelihood that C is bought if A&B are bought** will differ depending on the order.  *e.g. 50% of the customers who buy Käse and Obst also buy Gemüse  but only 30% of the customers who buy Gemüse and Obst also buy Käse*

    row: 18
    col: 0
    width: 24
    height: 4
  - title: 'Most Popular Category/Sub-Category/Substitute % per AVG # Orders /month'
    name: 'Most Popular Category/Sub-Category/Substitute % per AVG # Orders /month'
    model: flink_v3
    explore: typical_basket_analysis
    type: looker_grid
    fields: [typical_basket_analysis.category_a, typical_basket_analysis.avg_orders_per_month,
      orders_with_at_least_1_item]
    pivots: [typical_basket_analysis.avg_orders_per_month]
    filters:
      typical_basket_analysis.size: '1'
      typical_basket_analysis.avg_orders_per_month: ''
      typical_basket_analysis.category_a: "-Special,-Neu hinzugefügte Produkte ��"
    sorts: [typical_basket_analysis.avg_orders_per_month, orders_with_at_least_1_item
        desc 0]
    limit: 100
    column_limit: 50
    dynamic_fields: [{measure: sum_of_occurrences, based_on: typical_basket_analysis.occurrences,
        expression: '', label: Sum of Occurrences, type: sum, _kind_hint: measure,
        _type_hint: number}, {category: measure, expression: '', label: "% Orders\
          \ with at least 1 item", value_format: !!null '', value_format_name: percent_2,
        based_on: typical_basket_analysis.support, _kind_hint: measure, measure: orders_with_at_least_1_item,
        type: sum, _type_hint: number}]
    query_timezone: Europe/Berlin
    show_view_names: false
    show_row_numbers: true
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
    column_order: ["$$$_row_numbers_$$$", typical_basket_analysis.category_a, typical_basket_analysis.category_b,
      typical_basket_analysis.category_c, typical_basket_analysis.occurrences, typical_basket_analysis.confidence,
      sum_of_occurrences]
    show_totals: true
    show_row_totals: true
    series_labels:
      sum_of_occurrences: "# Orders with these Categories"
      typical_basket_analysis.confidence: Likelihood that C is bought if A&B were bought
      typical_basket_analysis.support: "% Orders with at least one item of the group"
      typical_basket_analysis.category_a: Category/Sub-Category/Substitute
    series_cell_visualizations:
      sum_of_occurrences:
        is_active: true
      typical_basket_analysis.confidence:
        is_active: true
      typical_basket_analysis.support:
        is_active: true
      sum_of_support:
        is_active: true
      orders_with_at_least_1_item:
        is_active: true
    series_value_format:
      typical_basket_analysis.confidence:
        name: percent_0
        decimals: '0'
        format_string: "#,##0%"
        label: Percent (0)
        label_prefix: Percent
      typical_basket_analysis.support:
        name: percent_0
        decimals: '0'
        format_string: "#,##0%"
        label: Percent (0)
        label_prefix: Percent
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
      Granularity: typical_basket_analysis.granularity
      Country: typical_basket_analysis.country_iso
    row: 35
    col: 0
    width: 24
    height: 9
  - name: Basket Analysis per Order Frequency
    type: text
    title_text: Basket Analysis per Order Frequency
    subtitle_text: ''
    body_text: |
      - Most popular Categories/Sub-Categories/Substitute for customers who order <=1x, ..... >10x a month.
      - We consider **only customers whose first order is < 30 days ago**, so the AVG orders per month is not biased by customers who are engaged for less than a full month.
    row: 31
    col: 0
    width: 24
    height: 4
  filters:
  - name: Country
    title: Country
    type: field_filter
    default_value: DE
    allow_multiple_values: true
    required: false
    ui_config:
      type: button_toggles
      display: inline
      options:
      - DE
      - NL
      - FR
    model: flink_v3
    explore: typical_basket_analysis
    listens_to_filters: []
    field: typical_basket_analysis.country_iso
  - name: Granularity
    title: Granularity
    type: field_filter
    default_value: subcategory
    allow_multiple_values: true
    required: false
    ui_config:
      type: button_toggles
      display: inline
      options:
      - category
      - subcategory
      - substitute_group
    model: flink_v3
    explore: typical_basket_analysis
    listens_to_filters: []
    field: typical_basket_analysis.granularity
