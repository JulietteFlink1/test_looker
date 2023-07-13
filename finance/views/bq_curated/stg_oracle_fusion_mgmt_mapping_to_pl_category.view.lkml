# Owner: Victor Breda
# 2023-07-13
# This view simply contains a mapping between mgmt_mapping and to which P&L category they belong to
# It is joined to oracle_fusion_general_ledger_mapping in the financial_pl explore
view: stg_oracle_fusion_mgmt_mapping_to_pl_category {
  sql_table_name: `flink-data-dev.dbt_vbreda_staging.stg_oracle_fusion_mgmt_mapping_to_pl_category` ;;

  dimension: mgmt_mapping {
    hidden: yes
    type: string
    sql: ${TABLE}.mgmt_mapping ;;
  }

  dimension: pl_category {
    type: string
    label: "P&L Category"
    description: "P&L Category the transaction belongs to. Based on MGMT Mapping.
    It may be that a transactions belongs to multiple categories. E.g. transactions with MGMT Mapping = Hub Set-up Cost are part of the Operating Profit,
    which in turn is part of the EBITDA calculation."
    sql: ${TABLE}.pl_category ;;
    # link: {
    #   label: "Test drill GL" #or your label of choice
    #   url: "
    #   {% assign vis_config = '{
    #   \"show_view_names\":false,\"show_row_numbers\":true,\"transpose\":false,\"truncate_text\":true,\"hide_totals\":false,\"hide_row_totals\":false,\"size_to_fit\":true,\"table_theme\":\"white\",\"limit_displayed_rows\":false,\"enable_conditional_formatting\":false,\"header_text_alignment\":\"left\",\"header_font_size\":\"12\",\"rows_font_size\":\"12\",\"conditional_formatting_include_totals\":false,\"conditional_formatting_include_nulls\":false,\"show_sql_query_menu_options\":false,\"show_totals\":true,\"show_row_totals\":true,\"truncate_header\":false,\"minimum_column_width\":75,\"series_cell_visualizations\":{\"oracle_fusion_general_ledger_mapping.sum_amt_accounted_value_eur\":{\"is_active\":false}},\"type\":\"looker_grid\",\"x_axis_gridlines\":false,\"y_axis_gridlines\":true,\"show_y_axis_labels\":true,\"show_y_axis_ticks\":true,\"y_axis_tick_density\":\"default\",\"y_axis_tick_density_custom\":5,\"show_x_axis_label\":true,\"show_x_axis_ticks\":true,\"y_axis_scale_mode\":\"linear\",\"x_axis_reversed\":false,\"y_axis_reversed\":false,\"plot_size_by_field\":false,\"trellis\":\"\",\"stacking\":\"\",\"legend_position\":\"center\",\"point_style\":\"none\",\"show_value_labels\":false,\"label_density\":25,\"x_axis_scale\":\"auto\",\"y_axis_combined\":true,\"ordering\":\"none\",\"show_null_labels\":false,\"show_totals_labels\":false,\"show_silhouette\":false,\"totals_color\":\"#808080\",\"defaults_version\":1,\"series_types\":{}
    #   }' %}
    #   {{ link }}&vis_config={{ vis_config | encode_uri }}&toggle=dat,pik,vis&limit=5000"
    # }
    drill_fields: [oracle_fusion_general_ledger_mapping.general_ledger_name,
      oracle_fusion_general_ledger_mapping.hub_code,
      oracle_fusion_general_ledger_mapping.cost_center_name,
      oracle_fusion_general_ledger_mapping.party_name]
  }
}
