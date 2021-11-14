view: orders_duplicates_check {
  derived_table: {
    sql: SELECT * from `flink-data-dev.sandbox_elvira.orders_duplicate_check`
      ;;
  }


  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: order_number {
    type: string
    sql: ${TABLE}.order_number ;;
  }

  dimension: records {
    type: number
    hidden: yes
    sql: ${TABLE}.number_of_records ;;
  }

  measure: number_of_records {
    hidden:  no
    type: sum
    sql: ${records};;
  }
  set: detail {
    fields: [country_iso, order_number, number_of_records]
  }
}
