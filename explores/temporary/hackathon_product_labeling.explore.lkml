include: "/explores/**/*.explore"
include: "/views/**/*.view"


explore: ean_labels {
  view_label: "* Labels *"

  join: products {
    sql_on: ${products.country_iso} = 'DE' and ${products.product_sku} = ${ean_labels.sku} and ${products.is_published} is true ;;
    type: left_outer
    relationship: one_to_one
  }

  join: orderline {
    sql_on: ${orderline.product_sku} = ${products.product_sku} and ${orderline.country_iso} = 'DE' ;;
    type: left_outer
    relationship: one_to_many
  }

}
