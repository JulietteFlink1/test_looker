- dashboard: retail_sku_analytics_dashboard
  title: Retail SKU Analytics Dashboard (CT Migrated)
  layout: newspaper
  preferred_viewer: dashboards-next
  refresh: 6 hours
  elements:

  - title: 'SKU Performance: last complete 7 days vs 5 weeks ago'
    name: 'SKU Performance: last complete 7 days vs 5 weeks ago'
    model: flink_v3
    explore: retail_kpis
    type: looker_grid
    fields: [retail_kpis.country_iso, retail_kpis.category_name, retail_kpis.sub_category_name,
      retail_kpis.sku, retail_kpis.product_name, retail_kpis.sum_item_price_net_current,
      retail_kpis.equalized_revenue_current, retail_kpis.equalized_revenue_subcategory_current,
      retail_kpis.pct_eq_revenue_share_subcat_current, retail_kpis.pct_sku_growth,
      retail_kpis.pct_overall_business_growth, retail_kpis.pct_sku_growth_corrected,
      retail_kpis.avg_basket_items, retail_kpis.avg_basket_skus, retail_kpis.avg_basket_value,
      retail_kpis.pct_out_of_stock_current, retail_kpis.avg_equalized_revenue_last_14d_for_7_days,
      retail_kpis.missed_revenue, retail_kpis.sum_count_purchased_current, retail_kpis.sum_count_restocked_current]
    sorts: [retail_kpis.sub_category_name desc, retail_kpis.pct_eq_revenue_share_subcat_current
        desc]
    limit: 500
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
    show_totals: true
    show_row_totals: true
    series_column_widths:
      retail_kpis.sub_category_name: 186
      retail_kpis.category_name: 139
      retail_kpis.sum_item_price_net_current: 123
      retail_kpis.equalized_revenue_current: 147
      retail_kpis.equalized_revenue_subcategory_current: 164
      retail_kpis.pct_eq_revenue_share_subcat_current: 185
      retail_kpis.product_name: 250
      retail_kpis.sku: 91
      retail_kpis.pct_sku_growth: 101
      retail_kpis.pct_overall_business_growth: 135
      retail_kpis.pct_sku_growth_corrected: 96
      retail_kpis.distinct_hub_codes_current: 104
      retail_kpis.avg_basket_items: 108
      retail_kpis.avg_basket_skus: 86
      retail_kpis.avg_basket_value: 75
    series_cell_visualizations:
      retail_kpis.sum_item_price_net_current:
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
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    series_types: {}
    hidden_fields: []
    y_axes: []
    listen:
      Country Iso Filter: retail_kpis.country_iso
      City Filter: retail_kpis.city_filter
      Hub Code Filter: retail_kpis.hub_code_filter
      SKU: retail_kpis.sku
      Parent Category Name: retail_kpis.category_name
      Sub Category Name: retail_kpis.sub_category_name
      Product Name: retail_kpis.product_name
    row: 11
    col: 0
    width: 24
    height: 13


  - title: Equalized Revenue per Week
    name: Equalized Revenue per Week
    model: flink_v3
    explore: retail_kpis
    type: looker_grid
    fields: [retail_kpis.country_iso, retail_kpis.category_name, retail_kpis.sub_category_name,
      retail_kpis.sku, retail_kpis.product_name, retail_kpis.equalized_revenue, retail_kpis.order_week]
    pivots: [retail_kpis.order_week]
    fill_fields: [retail_kpis.order_week]
    filters:
      retail_kpis.country_iso_filter: ''
      retail_kpis.hub_name_filter: ''
    sorts: [retail_kpis.order_week desc, retail_kpis.equalized_revenue desc 0]
    limit: 500
    column_limit: 50
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
    column_order: []
    show_totals: true
    show_row_totals: true
    series_column_widths:
      retail_kpis.sub_category_name: 186
      retail_kpis.category_name: 139
      retail_kpis.sum_item_price_net_current: 125
      retail_kpis.equalized_revenue_current: 140
      retail_kpis.equalized_revenue_subcategory_current: 148
      retail_kpis.pct_eq_revenue_share_subcat_current: 148
      retail_kpis.product_name: 294
      retail_kpis.sku: 91
      retail_kpis.pct_sku_growth: 88
      retail_kpis.pct_overall_business_growth: 109
      retail_kpis.pct_sku_growth_corrected: 96
      retail_kpis.distinct_hub_codes_current: 104
      retail_kpis.equalized_revenue: 156
    series_cell_visualizations:
      retail_kpis.sum_item_price_net_current:
        is_active: true
      retail_kpis.equalized_revenue:
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
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    series_types: {}
    hidden_fields: []
    y_axes: []
    listen:
      Country Iso Filter: retail_kpis.country_iso
      City Filter: retail_kpis.city_filter
      Hub Code Filter: retail_kpis.hub_code_filter
      SKU: retail_kpis.sku
      Parent Category Name: retail_kpis.category_name
      Sub Category Name: retail_kpis.sub_category_name
      Product Name: retail_kpis.product_name
    row: 27
    col: 0
    width: 24
    height: 18


  - title: Product Turnover
    name: Product Turnover
    model: flink_v3
    explore: inventory_stock_count_daily
    type: looker_grid
    fields: [
      hubs.hub_name,
      products.product_sku,
      products.product_name,
      inventory_stock_count_daily.turnover_rate,
      inventory_stock_count_daily.avg_stock_count,
      skus_fulfilled_per_hub_and_date.sum_item_quantity_fulfilled]
    filters:
      hubs.hub_name: "-NULL"
    sorts: [hubs.hub_name desc, skus_fulfilled_per_hub_and_date.sum_item_quantity_fulfilled
        desc]
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
    header_font_size: '12'
    rows_font_size: '12'
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    show_sql_query_menu_options: false
    show_totals: true
    show_row_totals: true
    series_cell_visualizations:
      inventory_stock_count_daily.turnover_rate:
        is_active: true
      skus_fulfilled_per_hub_and_date.sum_item_quantity_fulfilled:
        is_active: true
      inventory_stock_count_daily.avg_stock_count:
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
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 1
    series_types: {}
    hidden_fields: []
    y_axes: []
    listen:
      Tracking Date (only Turn-Over Chart): inventory_stock_count_daily.tracking_date
      Show Category (only Weekly OOS performance): inventory_stock_count_daily.show_category
      Show Sub Category (only Weekly OOS performance): inventory_stock_count_daily.show_sub_category
      Show Country (only Weekly OOS performance): inventory_stock_count_daily.show_country
      Show City (only Weekly OOS performance): inventory_stock_count_daily.show_city
      Show Hub Code (only Weekly OOS performance): inventory_stock_count_daily.show_hub_code
      Show SKU (only Weekly OOS performance): inventory_stock_count_daily.show_sku
      Country Iso Filter: inventory_stock_count_daily.country_iso
      City Filter: hubs.city
      Hub Code Filter: hubs.hub_code
      SKU: products.product_sku
      Parent Category Name: products.category
      Sub Category Name: products.subcategory
      Product Name: products.product_name
    row: 48
    col: 0
    width: 24
    height: 15
  - name: ''
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: |
      <h3 style="color: #e21c79;"><b>Purpose:</b> SKU Performance: last complete 7 days vs 5 weeks ago</h3>
      <span style="font-size: 15px;">We want to compare the performance of products in the last (complete 7 days - **Current Period**) and compare them with a 7-day window 5 weeks ago. (**Previous Period**) to identify best- and poor-performing products</span>


      <span style="color:#919191;font-size:12px;">* Hover over the field names to get additional information </span>
    row: 2
    col: 0
    width: 17
    height: 3
  - name: " (2)"
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: |
      <h3 style="color: #e21c79;"><b>Purpose:</b> Equalized Revenue per Week</h3>
      <span style="font-size: 15px;">We want to show the development of equalized revenue per SKU over time</span>


      <span style="color:#919191;font-size:12px;">* Hover over the field names to get additional information </span>
    row: 24
    col: 0
    width: 23
    height: 3
  - name: " (3)"
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: |
      <h3 style="color: #e21c79;"><b>Purpose:</b> Product Turnover</h3>

      <span style="font-size: 15px;">We want to compare the average stock level with the number of sales, which are condensed in the product turnover metric</span>


      <span style="color:#919191;font-size:12px;">* Hover over the field names to get additional information </span>
    row: 45
    col: 0
    width: 24
    height: 3
  - name: " (4)"
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: '<div style="background-color: #92c5f0;color:#e11d7b;font-size:20px;text-align:
      center;padding: 20px;">This dashboard provides charts to analyze <b>the performance
      of products across multiple  dimensions over time.</b></div>'
    row: 0
    col: 0
    width: 24
    height: 2


  - title: Stock-Out Development over time
    name: Stock-Out Development over time
    model: flink_v3
    explore: inventory_stock_count_daily
    type: looker_grid
    fields: [inventory_stock_count_daily.category_dynamic, inventory_stock_count_daily.sub_category_dynamic,
      inventory_stock_count_daily.country_dynamic, inventory_stock_count_daily.city_dynamic,
      inventory_stock_count_daily.hub_code_dynamic, inventory_stock_count_daily.sku_name_dynamic,
      inventory_stock_count_daily.pct_oos, inventory_stock_count_daily.tracking_week]
    pivots: [inventory_stock_count_daily.tracking_week]
    fill_fields: [inventory_stock_count_daily.tracking_week]
    filters:
      inventory_stock_count_daily.tracking_date: 6 weeks ago for 6 weeks
    sorts: [inventory_stock_count_daily.tracking_week desc, inventory_stock_count_daily.category_dynamic
        desc, inventory_stock_count_daily.sub_category_dynamic desc, inventory_stock_count_daily.country_dynamic
        desc, inventory_stock_count_daily.city_dynamic desc, inventory_stock_count_daily.hub_code_dynamic
        desc, inventory_stock_count_daily.sku_name_dynamic desc]
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
    series_column_widths:
      inventory_stock_count_daily.pct_oos: 108
      inventory_stock_count_daily.category_dynamic: 126
      inventory_stock_count_daily.sub_category_dynamic: 156
      inventory_stock_count_daily.country_dynamic: 120
      inventory_stock_count_daily.city_dynamic: 101
      inventory_stock_count_daily.hub_code_dynamic: 131
      inventory_stock_count_daily.sku_name_dynamic: 569
    series_cell_visualizations:
      inventory_stock_count_daily.pct_oos:
        is_active: false
    conditional_formatting: [{type: along a scale..., value: !!null '', background_color: "#c76b4e",
        font_color: !!null '', color_application: {collection_id: product-custom-collection,
          custom: {id: b3b214f8-0034-fdd7-0961-5d75b71e977c, label: Custom, type: continuous,
            stops: [{color: "#ffffff", offset: 0}, {color: "#ffffff", offset: 50},
              {color: "#e11d7b", offset: 100}]}, options: {steps: 5, constraints: {
              min: {type: minimum}, mid: {type: number, value: 0}, max: {type: maximum}},
            mirror: true, reverse: false, stepped: false}}, bold: false, italic: false,
        strikethrough: false, fields: [inventory_stock_count_daily.pct_oos]}]
    defaults_version: 1
    hidden_fields: []
    y_axes: []
    listen:
      Show Category (only Weekly OOS performance): inventory_stock_count_daily.show_category
      Show Sub Category (only Weekly OOS performance): inventory_stock_count_daily.show_sub_category
      Show Country (only Weekly OOS performance): inventory_stock_count_daily.show_country
      Show City (only Weekly OOS performance): inventory_stock_count_daily.show_city
      Show Hub Code (only Weekly OOS performance): inventory_stock_count_daily.show_hub_code
      Show SKU (only Weekly OOS performance): inventory_stock_count_daily.show_sku
      Country Iso Filter: inventory_stock_count_daily.country_iso
      City Filter: hubs.city
      Hub Code Filter: hubs.hub_code
      SKU: products.product_sku
      Parent Category Name: products.category
      Sub Category Name: products.subcategory
      Product Name: products.product_name
    row: 66
    col: 0
    width: 24
    height: 33
  - name: " (5)"
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: |
      <h3 style="color: #e21c79;"><b>Purpose:</b> Stock-Out Development over time</h3>

      <span style="font-size: 15px;">We want to analyze the stock-out ratio over time in order to see positive/negative trends</span>


      <span style="color:#919191;font-size:12px;">* Hover over the field names to get additional information </span>
    row: 63
    col: 0
    width: 24
    height: 3


  - title: Sub-Category Overview
    name: Sub-Category Overview
    model: flink_v3
    explore: retail_kpis
    type: subtotal
    fields: [retail_kpis.country_iso, retail_kpis.category_name, retail_kpis.sub_category_name,
      retail_kpis.sku, retail_kpis.product_name, retail_kpis.sum_item_price_net_current,
      retail_kpis.equalized_revenue_current, retail_kpis.equalized_revenue_subcategory_current,
      retail_kpis.pct_eq_revenue_share_subcat_current, retail_kpis.pct_sku_growth,
      retail_kpis.pct_overall_business_growth, retail_kpis.pct_sku_growth_corrected,
      retail_kpis.avg_basket_items, retail_kpis.avg_basket_skus, retail_kpis.avg_basket_value,
      retail_kpis.pct_out_of_stock_current, retail_kpis.avg_equalized_revenue_last_14d_for_7_days,
      retail_kpis.missed_revenue, retail_kpis.sum_count_purchased_current, retail_kpis.sum_count_restocked_current]
    filters: {}
    sorts: [retail_kpis.sub_category_name desc, retail_kpis.pct_eq_revenue_share_subcat_current
        desc]
    limit: 500
    column_limit: 50
    query_timezone: Europe/Berlin
    hidden_fields: []
    hidden_points_if_no: []
    series_labels: {}
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
    show_totals: true
    show_row_totals: true
    series_column_widths:
      retail_kpis.sub_category_name: 186
      retail_kpis.category_name: 139
      retail_kpis.sum_item_price_net_current: 123
      retail_kpis.equalized_revenue_current: 147
      retail_kpis.equalized_revenue_subcategory_current: 164
      retail_kpis.pct_eq_revenue_share_subcat_current: 185
      retail_kpis.product_name: 250
      retail_kpis.sku: 91
      retail_kpis.pct_sku_growth: 101
      retail_kpis.pct_overall_business_growth: 135
      retail_kpis.pct_sku_growth_corrected: 96
      retail_kpis.distinct_hub_codes_current: 104
      retail_kpis.avg_basket_items: 108
      retail_kpis.avg_basket_skus: 86
      retail_kpis.avg_basket_value: 75
    series_cell_visualizations:
      retail_kpis.sum_item_price_net_current:
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
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    defaults_version: 0
    series_types: {}
    y_axes: []
    show_null_points: true
    interpolation: linear
    listen:
      Country Iso Filter: retail_kpis.country_iso
      City Filter: retail_kpis.city_filter
      Hub Code Filter: retail_kpis.hub_code_filter
      SKU: retail_kpis.sku
      Parent Category Name: retail_kpis.category_name
      Sub Category Name: retail_kpis.sub_category_name
      Product Name: retail_kpis.product_name
    row: 5
    col: 0
    width: 24
    height: 6


  filters:
  - name: Country Iso Filter
    title: Country Iso Filter
    type: string_filter
    default_value: DE
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
      options: []
  - name: City Filter
    title: City Filter
    type: string_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
      options: []
  - name: Hub Code Filter
    title: Hub Code Filter
    type: string_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
      options: []
  - name: SKU
    title: SKU
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: popover
      options: []
    model: flink_v3
    explore: retail_kpis
    listens_to_filters: []
    field: retail_kpis.sku
  - name: Tracking Date (only Turn-Over Chart)
    title: Tracking Date (only Turn-Over Chart)
    type: field_filter
    default_value: 7 day
    allow_multiple_values: true
    required: false
    ui_config:
      type: relative_timeframes
      display: inline
      options: []
    model: flink_v3
    explore: inventory_stock_count_daily
    listens_to_filters: []
    field: inventory_stock_count_daily.tracking_date
  - name: Parent Category Name
    title: Parent Category Name
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: popover
      options: []
    model: flink_v3
    explore: retail_kpis
    listens_to_filters: []
    field: retail_kpis.category_name
  - name: Sub Category Name
    title: Sub Category Name
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: tag_list
      display: popover
      options: []
    model: flink_v3
    explore: retail_kpis
    listens_to_filters: []
    field: retail_kpis.sub_category_name
  - name: Show Category (only Weekly OOS performance)
    title: Show Category (only Weekly OOS performance)
    type: field_filter
    default_value: 'Yes'
    allow_multiple_values: true
    required: false
    ui_config:
      type: button_toggles
      display: inline
      options: []
    model: flink_v3
    explore: inventory_stock_count_daily
    listens_to_filters: []
    field: inventory_stock_count_daily.show_category
  - name: Show Sub Category (only Weekly OOS performance)
    title: Show Sub Category (only Weekly OOS performance)
    type: field_filter
    default_value: 'Yes'
    allow_multiple_values: true
    required: false
    ui_config:
      type: button_toggles
      display: inline
      options: []
    model: flink_v3
    explore: inventory_stock_count_daily
    listens_to_filters: []
    field: inventory_stock_count_daily.show_sub_category
  - name: Show Country (only Weekly OOS performance)
    title: Show Country (only Weekly OOS performance)
    type: field_filter
    default_value: 'Yes'
    allow_multiple_values: true
    required: false
    ui_config:
      type: button_toggles
      display: inline
      options: []
    model: flink_v3
    explore: inventory_stock_count_daily
    listens_to_filters: []
    field: inventory_stock_count_daily.show_country
  - name: Show City (only Weekly OOS performance)
    title: Show City (only Weekly OOS performance)
    type: field_filter
    default_value: 'Yes'
    allow_multiple_values: true
    required: false
    ui_config:
      type: button_toggles
      display: inline
      options: []
    model: flink_v3
    explore: inventory_stock_count_daily
    listens_to_filters: []
    field: inventory_stock_count_daily.show_city
  - name: Show Hub Code (only Weekly OOS performance)
    title: Show Hub Code (only Weekly OOS performance)
    type: field_filter
    default_value: 'No'
    allow_multiple_values: true
    required: false
    ui_config:
      type: button_toggles
      display: inline
      options: []
    model: flink_v3
    explore: inventory_stock_count_daily
    listens_to_filters: []
    field: inventory_stock_count_daily.show_hub_code
  - name: Show SKU (only Weekly OOS performance)
    title: Show SKU (only Weekly OOS performance)
    type: field_filter
    default_value: 'No'
    allow_multiple_values: true
    required: false
    ui_config:
      type: button_toggles
      display: inline
      options: []
    model: flink_v3
    explore: inventory_stock_count_daily
    listens_to_filters: []
    field: inventory_stock_count_daily.show_sku
  - name: Product Name
    title: Product Name
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: advanced
      display: popover
      options: []
    model: flink_v3
    explore: retail_kpis
    listens_to_filters: []
    field: retail_kpis.product_name
