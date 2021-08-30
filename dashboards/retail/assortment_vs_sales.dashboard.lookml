- dashboard: assortment_vs_sales
  title: "Assortment vs Sales (CT Migrated)"
  layout: newspaper
  preferred_viewer: dashboards-next
  elements:

  - title: Number of SKUs vs GMV
    name: Number of SKUs vs GMV
    model: flink_v3
    explore: order_orderline_cl
    type: looker_bar
    fields: [products.category, products.cnt_sku_published, orderline.sum_item_price_gross]
    filters:
      products.is_published: 'yes'
      orders_cl.is_successful_order: 'yes'
    sorts: [products.cnt_sku_published desc, products.category]
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
    point_style: circle_outline
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
      collection_id: flink
      palette_id: flink-categorical-0
      options:
        steps: 5
    y_axes: [{label: '', orientation: top, series: [{axisId: products.cnt_sku_published,
            id: products.cnt_sku_published, name: Number of Published SKUs}],
        showLabels: true, showValues: true, maxValue: 500, unpinAxis: false, tickDensity: default,
        type: linear}, {label: '', orientation: bottom, series: [{axisId: orderline.sum_item_price_gross,
            id: orderline.sum_item_price_gross, name: GMV}], showLabels: true,
        showValues: true, unpinAxis: false, tickDensity: custom, tickDensityCustom: 5,
        type: linear}]
    hide_legend: false
    series_types:
      products.cnt_sku_published: line
      new_calculation: line
    series_colors:
      orderline.sum_item_price_gross: "#e31c79"
      new_calculation: "#f5e175"
      products.cnt_sku_published: "#F0D22B"
    series_labels:
      new_calculation: Proportion of Published SKUs
      orderline.sum_item_price_gross: GMV
      products.cnt_sku_published: Number of Published SKUs
    label_color: ["#f5e175", "#ed6ba7"]
    defaults_version: 1
    hidden_fields: []
    listen:
      Hub Name: hubs.hub_name
      Order Date: orders_cl.created_date
      City: hubs.city
      Country: hubs.country
      Order Day of Week: orders_cl.created_day_of_week
    row: 28
    col: 0
    width: 11
    height: 20


  - title: Number of SKUs vs Units Sold
    name: Number of SKUs vs Units Sold
    model: flink_v3
    explore: order_orderline_cl
    type: looker_bar
    fields: [products.category, products.cnt_sku_published, orderline.sum_item_quantity]
    filters:
      products.is_published: 'yes'
      orders_cl.is_successful_order: 'yes'
    sorts: [products.cnt_sku_published desc, products.category]
    limit: 500
    dynamic_fields: [{_kind_hint: measure, table_calculation: proportion_of_published_skus,
        _type_hint: number, category: table_calculation, expression: "${products.cnt_sku_published}/sum(${products.cnt_sku_published})",
        label: Proportion of Published SKUs, value_format: !!null '', value_format_name: percent_1,
        is_disabled: true}]
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
    point_style: circle_outline
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
      collection_id: flink
      palette_id: flink-categorical-0
      options:
        steps: 5
    y_axes: [{label: '', orientation: top, series: [{axisId: products.cnt_sku_published,
            id: products.cnt_sku_published, name: Published SKUs}], showLabels: true,
        showValues: true, maxValue: 500, unpinAxis: false, tickDensity: default, type: linear},
      {label: '', orientation: bottom, series: [{axisId: orderline.sum_item_quantity,
            id: orderline.sum_item_quantity, name: Count SKUs Sold}],
        showLabels: true, showValues: true, minValue: 0, unpinAxis: false, tickDensity: custom,
        tickDensityCustom: 4, type: linear}]
    hide_legend: false
    series_types:
      products.cnt_sku_published: line
      new_calculation: line
      proportion_of_published_skus: line
    series_colors:
      orderline.sum_item_price_gross: "#5AA8EA"
      new_calculation: "#F0D22B"
      orderline.sum_item_quantity: "#5AA8EA"
      proportion_of_published_skus: "#f5e175"
      products.cnt_sku_published: "#F0D22B"
    series_labels:
      new_calculation: Percent of Total SKUs Published
      orderline.sum_item_price_gross: Past 2 Week GMV
      orderline.sum_item_quantity: Number of Units Sold
      products.cnt_sku_published: Number of Published SKUs
    label_color: ["#f5e175", "#5AA8EA"]
    defaults_version: 1
    hidden_fields: []
    listen:
      Hub Name: hubs.hub_name
      Order Date: orders_cl.created_date
      City: hubs.city
      Country: hubs.country
      Order Day of Week: orders_cl.created_day_of_week
    row: 28
    col: 11
    width: 11
    height: 20
  - name: ''
    type: text
    title_text: ''
    subtitle_text: ''
    body_text: "### The following charts show each parent category's GMV and number\
      \ of units sold relative to the number of published SKUs within that category.\n\
      \n#### Example Use Cases:\n\n* In the Berlin Kreuzberg Hub, **Süß, Salzig**\
      \ accounts for a massive 10.5% of all SKUs published, yet the GMV from the past\
      \ month is only 6,000 €, or 5.9% of total GMV. It may be possible to conclude\
      \ that there are too many **Süß, Salzig** SKUs in the assortment.\n\n* In the\
      \ Berlin Mitte Hub, **Obst, Gemüse** and **Alkohol** each make up 8.2% of all\
      \ SKUs published, yet the GMV and Number of Units Sold are all above 15%. Therefore\
      \ you may conclude that these parent categories should make up more of the total\
      \ assortment.\n\n⚠️ **These charts should be filtered by hub and used for insights\
      \ on a hub level basis only**.\nEach hub has its own unique assortment. For\
      \ example, **Brötchen, Brot** has **200 unique SKUs** across Germany, but only\
      \ **34 unique SKUs** in the Berlin Kreuzberg hub, so the proportions won't be\
      \ accurate if all unique SKUs across Germany are included. \n\nThe yellow line\
      \ in the top chart shows the proportion of unique SKUs published in each parent\
      \ category. For example, if there are a total of 2000 SKUs published in a hub,\
      \ and 200 of those SKUs are Alkohol, then Alkohol would make up 10% of all SKUs\
      \ in that hub. \n\n**Note:** this yellow line only shows us how much space items\
      \ occupy in each parent category within the Flink App. It does not tell us how\
      \ much physical space each item occupies on a shelf in a hub.\nAlso note that\
      \ SKUs that did not sell and were not part of any orders within the *Order Date*\
      \ timeframe are not included in the SKU count, so longer timeframes, like \"\
      is in the past 28 complete days\", will be more accurate than shorter timeframes."
    row: 0
    col: 0
    width: 22
    height: 8
  - title: Proportion of SKUs vs GMV & Units Sold
    name: Proportion of SKUs vs GMV & Units Sold
    model: flink_v3
    explore: order_orderline_cl
    type: looker_bar
    fields: [products.category, products.cnt_sku_published, orderline.sum_item_price_gross,
      orderline.sum_item_quantity]
    filters:
      products.is_published: 'yes'
      orders_cl.is_successful_order: 'yes'
    sorts: [total_sold desc]
    limit: 500
    column_limit: 50
    dynamic_fields: [{_kind_hint: measure, table_calculation: of_published_skus, _type_hint: number,
        category: table_calculation, expression: "${products.cnt_sku_published}/sum(${products.cnt_sku_published})",
        label: "% of Published SKUs", value_format: !!null '', value_format_name: percent_1},
      {_kind_hint: measure, table_calculation: total_sold, _type_hint: number, category: table_calculation,
        expression: "${orderline.sum_item_price_gross}/sum(${orderline.sum_item_price_gross})",
        label: "% Total Sold", value_format: !!null '', value_format_name: percent_1},
      {_kind_hint: measure, table_calculation: of_units_sold, _type_hint: number,
        category: table_calculation, expression: "${orderline.sum_item_quantity}/sum(${orderline.sum_item_quantity})",
        label: "% of Units Sold", value_format: !!null '', value_format_name: percent_1}]
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
    point_style: circle_outline
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
      collection_id: flink
      palette_id: flink-categorical-0
      options:
        steps: 5
    y_axes: [{label: '', orientation: top, series: [{axisId: of_published_skus, id: of_published_skus,
            name: "% of Published SKUs"}], showLabels: false, showValues: true, maxValue: 0.25,
        unpinAxis: false, tickDensity: custom, tickDensityCustom: 3, type: linear},
      {label: '', orientation: bottom, series: [{axisId: total_sold, id: total_sold,
            name: "% of GMV"}], showLabels: false, showValues: true, maxValue: 0.25,
        minValue: 0, unpinAxis: false, tickDensity: custom, tickDensityCustom: 2,
        type: linear}, {label: '', orientation: bottom, series: [{axisId: of_units_sold,
            id: of_units_sold, name: "% of Units Sold"}], showLabels: false, showValues: true,
        maxValue: 0.25, minValue: 0, unpinAxis: false, tickDensity: custom, tickDensityCustom: 0,
        type: linear}]
    hide_legend: false
    series_types:
      products.cnt_sku_published: area
      new_calculation: line
      of_published_skus: line
    series_colors:
      orderline.sum_item_price_gross: "#e31c79"
      new_calculation: "#f5e175"
      of_published_skus: "#F0D22B"
      total_sold: "#e31c79"
      of_units_sold: "#5AA8EA"
    series_labels:
      new_calculation: Proportion of Published SKUs
      orderline.sum_item_price_gross: GMV
      total_sold: "% of GMV"
    label_color: ["#f5e175", "#ed6ba7", "#5AA8EA"]
    defaults_version: 1
    hidden_fields: [products.cnt_sku_published, orderline.sum_item_price_gross,
      orderline.sum_item_quantity]
    listen:
      Hub Name: hubs.hub_name
      Order Date: orders_cl.created_date
      City: hubs.city
      Country: hubs.country
      Order Day of Week: orders_cl.created_day_of_week
    row: 8
    col: 0
    width: 22
    height: 20




  filters:
  - name: Order Day of Week
    title: Order Day of Week
    type: field_filter
    default_value: ''
    allow_multiple_values: true
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
      options: []
    model: flink_v3
    explore: order_orderline_cl
    listens_to_filters: []
    field: orders_cl.created_day_of_week

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
    explore: order_orderline_cl
    listens_to_filters: []
    field: hubs.country

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
    explore: order_orderline_cl
    listens_to_filters: []
    field: hubs.city

  - name: Hub Name
    title: Hub Name
    type: field_filter
    default_value: DE - Berlin - Kreuzberg
    allow_multiple_values: true
    required: false
    ui_config:
      type: dropdown_menu
      display: inline
      options: []
    model: flink_v3
    explore: order_orderline_cl
    listens_to_filters: []
    field: hubs.hub_name

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
    explore: order_orderline_cl
    listens_to_filters: []
    field: orders_cl.created_date
