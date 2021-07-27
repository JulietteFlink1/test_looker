view: warehouse_stock {
  sql_table_name: `flink-data-prod.saleor_prod_global.warehouse_stock`
    ;;
  drill_fields: [id]
  view_label: "* Product / SKU Data *"

  dimension: id {
    label: "Warehouse Stock ID"
    primary_key: no
    hidden: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: country_iso {
    type: string
    hidden: yes
    sql: ${TABLE}.country_iso ;;
  }

  dimension: unique_id {
    primary_key: yes
    hidden: yes
    type: string
    sql: concat(${country_iso}, ${id}) ;;
  }

  dimension: product_variant_id {
    type: number
    hidden: yes
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
