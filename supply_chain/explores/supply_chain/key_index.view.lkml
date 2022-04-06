# If necessary, uncomment the line below to include explore_source.
# include: "supply_chain.explore.lkml"

view: key_index {
  derived_table: {
    explore_source: supply_chain {
      column: hub_code { field: hubs_ct.hub_code }
      column: sku { field: lexbizz_item.sku }
      column: key_index { field: mean_and_std.key_index }
      bind_all_filters: yes
    }
  }
  dimension: table_uuid  {
    sql: concat(${hub_code},${sku},${key_index}) ;;
    hidden: yes
    primary_key: yes
  }
  dimension: hub_code {
    label: "Hub Code"
    hidden: yes
    description: ""
  }
  dimension: sku {
    label: "SKU"
    hidden: yes
    description: ""
  }
  dimension: key_index {
    label: "Key Index"
    description: ""
    type: number
}

dimension: key_index_tier  {
  type: tier
  tiers: [0,0.5,1,1.5,2,2.5,3,3.5,4,4.5,5,5.5,6]
  style: relational
  sql: ${key_index} ;;
}


measure: count_index {
  label: "Count Key Index"
  type: count_distinct
  sql: ${sku} ;;
}

}
