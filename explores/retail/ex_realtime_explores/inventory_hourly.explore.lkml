include: "/views/bigquery_tables/curated_layer/*.view"

explore: inventory_hourly {
  from: products
  view_name: products

  persist_with: flink_hourly_datagroup
  hidden: yes

  join: inventory {
    sql_on: ${inventory.sku} = ${products.product_sku} ;;
    relationship: one_to_many
    type: left_outer
    sql_where: (${inventory.is_most_recent_record} = TRUE) ;;
  }


}
