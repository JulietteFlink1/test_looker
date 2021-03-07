view: warehouse_stock {
  sql_table_name: `flink-backend.saleor_db.warehouse_stock`
    ;;
  drill_fields: [id]

  dimension: id {
    label: "Warehouse Stock ID"
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: _sdc_batched {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}._sdc_batched_at ;;
  }

  dimension_group: _sdc_extracted {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}._sdc_extracted_at ;;
  }

  dimension_group: _sdc_received {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}._sdc_received_at ;;
  }

  dimension: _sdc_sequence {
    type: number
    sql: ${TABLE}._sdc_sequence ;;
  }

  dimension: _sdc_table_version {
    type: number
    sql: ${TABLE}._sdc_table_version ;;
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
