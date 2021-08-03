include: "/views/bigquery_tables/curated_layer/inventory_ct.view"
include: "/views/bigquery_tables/curated_layer/hubs_ct.view"
include: "/views/bigquery_tables/curated_layer/products_ct.view"


explore: inventory_cl{
  from: inventory_ct
  view_name: inventory_cl
  hidden: yes

  join: hubs_ct {
    sql_on: ${inventory_cl.hub_id} = ${hubs_ct.supply_channel_id} ;;
    relationship: many_to_one
    type: left_outer
  }

  join: products_ct {
    sql_on: ${inventory_cl.sku} =  ${products_ct.product_sku};;
    relationship: many_to_one
    type: left_outer
  }


}
