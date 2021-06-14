# If necessary, uncomment the line below to include explore_source.
# include: "flink_v3.model.lkml"

view: comparison_skus_per_category {
  derived_table: {
    persist_for: "24 hours"
    explore_source: gorillas_v1_item_hub_collection_group_allocation {
      column: country_iso {}
      column: collection_id {}
      column: collection_name {}
      column: group_id {}
      column: group_label {}
      column: hub_id {}
      column: cnt_distinct_items { field: gorillas_v1_items.cnt_distinct_items }
      filters: {
        field: gorillas_v1_items.time_scraped_date
        value: "1 days"
      }
    }
  }
  dimension: country_iso {
    label: "Country Iso"
  }
  dimension: collection_id {
    label: "Collection ID"
  }
  dimension: collection_name {
    label: "Collection Name"
  }
  dimension: group_id {
    label: "Group ID"
  }
  dimension: group_label {
    label: "Group Name"
  }
  dimension: hub_id {
    label: "Hub ID"
  }
  dimension: cnt_distinct_items {
    type: number
  }


  measure: avg_gorillas_skus {
    label: "Avg # of Gorillas Items"
    type: average
    sql: ${cnt_distinct_items} ;;
    value_format: "0"
  }
}
