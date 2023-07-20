# If necessary, uncomment the line below to include explore_source.
# include: "supply_chain.explore.lkml"

view: avg_waste_index_per_hub {
  derived_table: {
    explore_source: supply_chain {
      column: hub_code { field: hubs_ct.hub_code }
      column: product_sku { field: products.product_sku }
      column: key_index { field: waste_index.key_index }
      column: count_index { field: waste_index.count_index }
    bind_all_filters: yes
    }
  }
  dimension: hub_code {
    label: "Hub Code"
    hidden: yes
    description: ""
  }
  dimension: product_sku {
    label: "SKU"
    hidden: yes
    description: ""
  }
  dimension: key_index {
    label: "Waste Risk Index"
    hidden: yes
    description: ""
    type: number
  }
  dimension: count_index {
    label: "Count Waste Risk Index"
    hidden: yes
    description: ""
    type: number
  }

  dimension: table_uuid {
    primary_key: yes
    hidden: yes
    sql: concat(${hub_code}, ${product_sku}, ${key_index}) ;;
  }

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~   Measures   ~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


  measure: avg_waste_index {
    label: "AVG Waste Risk Index"
    sql: ${key_index}  ;;
    type: average_distinct
    value_format_name: decimal_2

  }

}
