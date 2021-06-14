# If necessary, uncomment the line below to include explore_source.
# include: "flink_v3.model.lkml"

view: flink_skus_per_category {
  derived_table: {
    explore_source: product_product {
      column: country_iso { field: product_category.country_iso }
      column: parent_id { field: parent_category.id }
      column: parent_name { field: parent_category.name }
      column: id { field: product_category.id }
      column: name { field: product_category.name }
      column: hub_code_lowercase { field: hubs.hub_code_lowercase }
      column: warehouse_id { field: warehouse_stock.warehouse_id }
      column: cnt_sku_published {}
      filters: {
        field: product_product.is_published
        value: "yes"
      }
      filters: {
        field: order_orderline_facts.is_internal_order
        value: "no"
      }
      filters: {
        field: order_orderline_facts.is_successful_order
        value: "yes"
      }
    }
  }

  dimension: unique_id {
    group_label: "* IDs *"
    primary_key: yes
    type: string
    sql: concat(${country_iso}, ${parent_id},${id}) ;;
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
  dimension: id {
    label: "Category ID"
    type: number
  }
  dimension: name {
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

  measure: avg_flink_skus {
    label: "Avg # of Flink Items"
    type: average
    sql: ${cnt_sku_published} ;;
    value_format: "0"
  }
}
