# If necessary, uncomment the line below to include explore_source.
# include: "supply_chain.explore.lkml"

view: v2_avg_waste_index_per_hub {
  derived_table: {
    explore_source: supply_chain {
      column: hub_code { field: hubs_ct.hub_code }
      column: avg_waste_index { field: avg_waste_index_per_hub.avg_waste_index }
      bind_all_filters: yes
    }
  }
  dimension: hub_code {
    label: "Hub Code"
    hidden: yes
    description: ""
    primary_key: yes
  }
  dimension: avg_waste_index {
    label: "AVG Waste Risk Index"
    group_label: "> Waste Risk Metrics"
    description: ""
    value_format: "#,##0.00"
    type: number
  }
}
