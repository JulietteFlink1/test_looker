view: warehouse_allocation {
  sql_table_name: `flink-data-prod.saleor_prod_global.warehouse_allocation`
    ;;
  drill_fields: [id]

  dimension: id {
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

  dimension: order_line_id {
    type: number
    hidden: yes
    sql: ${TABLE}.order_line_id ;;
  }

  dimension: quantity_allocated {
    type: number
    sql: ${TABLE}.quantity_allocated ;;
  }

  dimension: stock_id {
    type: number
    hidden: yes
    sql: ${TABLE}.stock_id ;;
  }

}
