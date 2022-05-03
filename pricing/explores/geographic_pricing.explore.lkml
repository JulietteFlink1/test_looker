include: "/**/*.view"
include: "/**/products_hub_assignment_v2.view"
# include: "/**/products_hub_assignment.view"
include: "/**/replenishment_purchase_orders.view"

explore: geographic_pricing {

  extends: [order_lineitems_margins]

  group_label: "Pricing"
  label: "Geographic Pricing"
  hidden: no

  join: geographic_pricing_sku_cluster {
    sql_on: ${geographic_pricing_sku_cluster.sku}           = ${orderline.product_sku} ;;
    relationship: many_to_one #changed from one_to_many
  }

  join: geographic_pricing_hub_cluster {
    sql_on: ${geographic_pricing_hub_cluster.hub_code}           = ${orderline.hub_code} ;;
    relationship: many_to_one #changed from one_to_many
  }


}
