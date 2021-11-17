view: hubs_duplicates_check {
  derived_table: {
    sql: SELECT * from `flink-data-dev.sandbox_elvira.hubs_duplicates_check`
      ;;
  }

  dimension: hub_code {
    type: string
    sql: ${TABLE}.hub_code ;;
  }

  dimension: records {
    type: number
    hidden:  yes
    sql: ${TABLE}.f0_ ;;
  }

  measure: number_of_records {
    hidden:  no
    type: sum
    sql: ${records};;
  }

}
