# If necessary, uncomment the line below to include explore_source.
# include: "retail_kpis.explore.lkml"

view: retail_kpis_rev_per_total {
  derived_table: {
    explore_source: retail_orders_explore {
      column: created_date                           { field: retail_kpis_hubs_and_rev_on_sku_date_level.created_date }

      # column: sum_item_price_net                     { field: order_orderline.sum_item_price_net }
      column: equalized_revenue                      { field: retail_kpis_equalized_revenue.equalized_revenue }
      column: equalized_revenue_current              { field: retail_kpis_equalized_revenue.equalized_revenue_current }
      column: equalized_revenue_previous             { field: retail_kpis_equalized_revenue.equalized_revenue_previous }
      # column: sum_item_price_net_current             { field: retail_kpis_equalized_revenue.sum_item_price_net_current }
      # column: sum_item_price_net_previous            { field: retail_kpis_equalized_revenue.sum_item_price_net_previous }

      bind_all_filters: yes
    }
  }

  dimension: primary_key {
    primary_key: yes
    sql:  CAST(${created_date} as string) ;;
    hidden: yes
  }


  dimension: created_date {
    label: "SKU+Date Level Aggregations Created Date"
    type: date
  }

  dimension: sub_category_name {
    label: "* Sub Category Data * Category Name"
  }


  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~     Measures       ~~~~~~~~~~~~~~~~~~~~~~~~~
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # measure: sum_item_price_net {
  #   label: "per TOTAL: SUM Item Prices sold (net)"
  #   group_label: "Measures per Total"
  #   description: "Sum of sold Item prices (excl. VAT)"
  #   value_format_name: eur
  #   type: sum
  # }
  dimension: equalized_revenue_d {
    label: "per TOTAL: Equalized Revenue"
    group_label: "Measures per Total"
    value_format_name: eur
    type: number
  }
  dimension: equalized_revenue_current_d {
    label: "per TOTAL: Equalized Revenue Current"
    group_label: "Measures per Total"
    value_format_name: eur
    type: number
  }
  dimension: equalized_revenue_previous_d {
    label: "per TOTAL: Equalized Revenue Previous"
    group_label: "Measures per Total"
    value_format_name: eur
    type: number
  }

  measure: equalized_revenue {
    label: "per TOTAL: Equalized Revenue"
    group_label: "Measures per Total"
    value_format_name: eur
    type: sum
  }
  measure: equalized_revenue_current {
    label: "per TOTAL: Equalized Revenue Current"
    group_label: "Measures per Total"
    value_format_name: eur
    type: sum
  }
  measure: equalized_revenue_previous {
    label: "per TOTAL: Equalized Revenue Previous"
    group_label: "Measures per Total"
    value_format_name: eur
    type: sum
  }
  # measure: sum_item_price_net_current {
  #   label: "per TOTAL: Sum Item Price Net Current"
  #   group_label: "Measures per Total"
  #   value_format_name: eur
  #   type: sum
  # }
  # measure: sum_item_price_net_previous {
  #   label: "per TOTAL: Sum Item Price Net Previous"
  #   group_label: "Measures per Total"
  #   value_format_name: eur
  #   type: sum
  # }

  set: _measures {
    fields: [
      # sum_item_price_net, sum_item_price_net_current, sum_item_price_net_previous,
      equalized_revenue, equalized_revenue_current, equalized_revenue_previous, equalized_revenue_current_d, equalized_revenue_d, equalized_revenue_previous_d]
  }

}
