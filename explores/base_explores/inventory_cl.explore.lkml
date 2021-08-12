include: "/views/bigquery_tables/curated_layer/inventory.view"
include: "/views/bigquery_tables/curated_layer/hubs_ct.view"
include: "/views/bigquery_tables/curated_layer/products.view"


explore: inventory_cl{
  from: inventory
  view_name: inventory_cl
  hidden: yes

  join: hubs {
    from: hubs_ct
    sql_on: ${inventory_cl.hub_id} = ${hubs.supply_channel_id} ;;
    relationship: many_to_one
    type: left_outer
  }

  join: products {
    sql_on: ${inventory_cl.sku} =  ${products.product_sku};;
    relationship: many_to_one
    type: left_outer
  }


}

explore: hourly_inventory {
  extends: [inventory_cl]
  persist_with: flink_hourly_datagroup
}
