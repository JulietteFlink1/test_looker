# If necessary, uncomment the line below to include explore_source.
# include: "flink_v3.model.lkml"

view: flink_skus_per_category {
  derived_table: {
    explore_source: product_product_competitive_intelligence {
      column: country_iso { field: product_category.country_iso }
      column: parent_id { field: parent_category.id }
      column: parent_name { field: parent_category.name }
      column: category_id { field: product_category.id }
      column: category_name { field: product_category.name }
      column: hub_code_lowercase { field: hubs.hub_code_lowercase }
      column: warehouse_id { field: warehouse_stock.warehouse_id }
      column: product_id { field: product_product_competitive_intelligence.id }
      column: price_amount { field: product_productvariant.price_amount }
      column: cnt_sku_published {}
      filters: {
        field: product_product_competitive_intelligence.is_published
        value: "yes"
      }
}}

# If necessary, uncomment the line below to include explore_source.
# include: "flink_v3.model.lkml"



  dimension: unique_id {
    group_label: "* IDs *"
    primary_key: yes
    hidden: no
    type: string
    sql: concat(${country_iso},${category_id}, ${hub_code_lowercase}, ${warehouse_id}, ${product_id}, ${price_amount}) ;;
  }

  dimension: product_id {
    label: "Product ID"
    type: number
  }

  dimension: country_iso {
    label: "Country Iso"
  }
  dimension: parent_id {
    label: "Parent Category ID"
    type: number
  }
  dimension: parent_name {
    label: "Parent Category Name"
  }
  dimension: category_id {
    label: "Category ID"
    type: number
  }
  dimension: category_name {
    label: "Category Name"
  }
  dimension: warehouse_id {
    label: "Warehouse ID"
  }

  dimension: hub_code_lowercase {
    label: "* Hubs * Hub Code Lowercase"
  }

  dimension: cnt_sku_published {
    label: "* Product / SKU Data * # SKUs (Published)"
    description: "Count of published SKUs in Assortment"
    value_format: "0"
    type: number
  }

  dimension: price_amount {
    label: "* Product / SKU Data * Price Amount"
    type: number
  }

  measure: avg_flink_skus {
    label: "Avg # of Flink Items"
    type: average
    sql: ${cnt_sku_published} ;;
    value_format: "0"
  }

  # measure: cnt_distinct_items {
  #   type: count
  #   # sql: ${product_id} ;;
  #   # sql_distinct_key: ${product_id};;
  #   value_format: "0"
  # }

  measure: min_price {
    type: min
    sql: ${price_amount} ;;
    value_format: "0.00€"
  }

  measure: max_price {
    type: max
    sql: ${price_amount} ;;
    value_format: "0.00€"
  }

  measure: median_price {
    type: median
    sql: ${price_amount} ;;
    # sql_distinct_key: ${product_id};;
    value_format: "0.00€"
  }

  measure: avg_price {
    type: average
    sql: ${price_amount} ;;
    # sql_distinct_key: ${product_id};;
    value_format: "0.00€"
  }
}
