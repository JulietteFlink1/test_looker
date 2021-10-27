# If necessary, uncomment the line below to include explore_source.
# include: "order_orderline_cl.explore.lkml"

view: sku_level_aggregated_metrics {
  view_label: "* Order Metrics aggregated on SKU level *"
  derived_table: {
    explore_source: order_orderline_cl_retail_customized {
      column: sku                   { field: products.product_sku }
      column: avg_order_value_gross { field: orders_cl.avg_order_value_gross }
      column: avg_order_value_net   { field: orders_cl.avg_order_value_net }
      column: cnt_orders            { field: orders_cl.cnt_orders }

      bind_all_filters: yes
    }
  }
  dimension: sku {
    label: "SKU"
    primary_key: yes
  }

  measure: avg_order_value_gross {
    label: "AVG Order Value (Gross)"
    description: "Average value of orders considering total gross order values. Includes fees (gross), before deducting discounts."
    value_format_name: eur
    type: average
  }

  measure: avg_order_value_net {
    label: "AVG Order Value (Net)"
    description: "Average value of orders considering total net order values. Includes fees (net), before deducting discounts."
    value_format_name: eur
    type: average
  }
  measure: cnt_orders {
    label: "# Orders"
    description: "Count of successful Orders"
    value_format: "0"
    type: average
  }
}
