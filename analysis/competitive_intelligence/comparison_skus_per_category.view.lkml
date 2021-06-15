# If necessary, uncomment the line below to include explore_source.
# include: "flink_v3.model.lkml"

view: comparison_skus_per_category {
  derived_table: {
    explore_source: gorillas_v1_item_hub_collection_group_allocation {
      column: country_iso {}
      column: parent_category_id { field: gorillas_category_mapping.parent_category_id }
      column: category_id { field: gorillas_category_mapping.category_id }
      column: min_price { field: gorillas_v1_items.min_price }
      column: max_price { field: gorillas_v1_items.max_price }
      column: median_price { field: gorillas_v1_items.median_price }
      column: avg_price { field: gorillas_v1_items.avg_price }
      column: cnt_distinct_items { field: gorillas_v1_items.cnt_distinct_items }
      filters: {
        field: gorillas_v1_items.time_scraped_date
        value: "1 days"
      }
    }
  }
  dimension: country_iso {
    label: "Gorillas Item Hub Collection Group Allocation Country Iso"
  }
  dimension: parent_category_id {
    type: number
  }
  dimension: category_id {
    type: number
  }
  dimension: min_price {
    type: number
  }
  dimension: max_price {
    type: number
  }
  dimension: median_price {
    type: number
  }
  dimension: avg_price {
    value_format: "0.00€"
    type: number
  }
  dimension: cnt_distinct_items {
    type: number
  }
}
