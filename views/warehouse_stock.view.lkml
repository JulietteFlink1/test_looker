view: warehouse_stock {
  sql_table_name: `flink-backend.saleor_db_global.warehouse_stock`
    ;;
  drill_fields: [id]

  dimension: id {
    label: "Warehouse Stock ID"
    primary_key: no
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: unique_id {
    primary_key: yes
    type: string
    sql: concat(${country_iso}, ${id}) ;;
  }

  dimension: product_variant_id {
    type: number
    sql: ${TABLE}.product_variant_id ;;
  }

  dimension: quantity {
    label: "Stock quantity"
    type: number
    sql: ${TABLE}.quantity ;;
  }

  dimension: warehouse_id {
    type: string
    sql: ${TABLE}.warehouse_id ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }

##########
## SUMS ##
##########

  measure: sum_stock_quantity {
    label: "SUM Stock Quantity"
    description: "Quantity of SKU in stock"
    hidden:  no
    type: sum
    sql: ${quantity};;
    value_format: "0"
  }

}
