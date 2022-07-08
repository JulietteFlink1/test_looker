# If necessary, uncomment the line below to include explore_source.
# include: "flink_v3.model.lkml"

view: skus_fulfilled_per_hub_and_date {
  derived_table: {
    explore_source: order_orderline_cl {
      column: created_date                { field: orders_cl.created_date }
      column: hub_code_lowercase          { field: hubs.hub_code }
      column: product_sku                 { field: products.product_sku }
      column: sum_item_quantity_fulfilled { field: orderline.sum_item_quantity }
      column: sum_item_quantity           { field: orderline.sum_item_quantity }
    }
  }
  dimension: created_date {
    label: "Order Date"
    description: "Order Placement Date/Time"
    type: date
  }
  dimension: hub_code_lowercase {
    label: "* Hubs * Hub Code Lowercase"
  }
  dimension: product_sku {
    label: "* Order Line Items * Product SKU"
  }
  dimension: primary_key {
    primary_key: yes
    hidden: yes
    sql: concat(CAST(${created_date} AS STRING), ${hub_code_lowercase}, ${product_sku}) ;;
  }

  dimension: item_quantity_fulfilled {
    label: "# Item Quantity fulfilled"
    description: "Quantity of Order Line Items fulfilled"
    value_format: "0"
    type: number
    sql: ${TABLE}.sum_item_quantity_fulfilled ;;
  }
  dimension: item_quantity {
    label: "# Item Quantity sold"
    description: "Quantity of Order Line Items sold"
    value_format: "0"
    type: number
    sql: ${TABLE}.sum_item_quantity ;;
  }

  measure: sum_item_quantity_fulfilled {
    label: "Sum Item Quantity fulfilled"
    description: "Quantity of Order Line Items fulfilled"
    value_format: "0"
    type: sum
    sql: ${item_quantity_fulfilled} ;;

  }

  measure:  sum_item_quantity {
    label: "# Item Quantity sold"
    description: "Quantity of Order Line Items sold"
    value_format: "0"
    type: sum
    sql: ${item_quantity} ;;
  }
}
