view: lineitem_duplicates_check {
  derived_table: {
    sql: SELECT * from `flink-data-dev.sandbox_elvira.lineitems_duplicates_check`
      ;;
  }

  dimension: order_lineitem_uuid {
    type: string
    sql: ${TABLE}.order_lineitem_uuid ;;
  }

  dimension: records {
    type: number
    hidden: yes
    sql: ${TABLE}.f0_ ;;
  }

  measure: number_of_records {
    hidden:  no
    type: sum
    sql: ${records};;
  }
}
