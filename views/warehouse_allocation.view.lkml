view: warehouse_allocation {
  sql_table_name: `flink-backend.saleor_db_global.warehouse_allocation`
    ;;
  drill_fields: [id]

  dimension: id {
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

  dimension: order_line_id {
    type: number
    sql: ${TABLE}.order_line_id ;;
  }

  dimension: quantity_allocated {
    type: number
    sql: ${TABLE}.quantity_allocated ;;
  }

  dimension: stock_id {
    type: number
    sql: ${TABLE}.stock_id ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }
}
