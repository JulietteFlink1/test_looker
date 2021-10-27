include: "/explores/base_explores/**/*.explore"
include: "/**/*.view"


explore: order_orderline_cl_retail_customized {
  extends: [order_orderline_cl]
  group_label: "Retail"
  label: "Orders & Items (Retail Version)"
  hidden: no

  join: sku_level_aggregated_metrics {
    sql_on:  ${sku_level_aggregated_metrics.sku} = ${products.product_sku};;
    type: left_outer
    relationship: many_to_one
  }
}
