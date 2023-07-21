include: "/commercial/views/bigquery_curated/oracle_future_cost_fact.view.lkml"
include: "/core/views/bq_curated/hubs_ct.view.lkml"
include: "/core/views/bq_curated/products.view.lkml"

explore: oracle_spot_cost {

  label: "Oracle Spot Costs"
  group_label: "Commercial"
  description: "This table exposes data from the Oracle future_cost table and shows prices both, for current and future states"
  hidden: yes
  from: oracle_future_cost_fact
  view_name: oracle_future_cost_fact

  join: oracle_future_cost_fact__history {
    sql: LEFT JOIN UNNEST(${oracle_future_cost_fact.history}) as oracle_future_cost_fact__history ;;
    relationship: one_to_many
  }

  access_filter: {
    field: oracle_future_cost_fact.country_iso
    user_attribute: country_iso
  }

  join: hubs_ct {
    view_label: "Hub Data"
    relationship: many_to_one
    type: left_outer
    sql_on: ${hubs_ct.hub_code} = ${oracle_future_cost_fact.hub_code} ;;
  }

  join: products {
    view_label: "Product Data"
    relationship: many_to_one
    type: left_outer
    sql_on:
        ${products.product_sku} = ${oracle_future_cost_fact.sku}
    and ${products.country_iso} = ${oracle_future_cost_fact.country_iso}
        ;;
  }


}
