view: getir_hubs {
  sql_table_name: `flink-data-prod.curated.getir_hubs`
    ;;

  dimension: hub_id {
    type: string
    sql: ${TABLE}.hub_id ;;
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension_group: partition_timestamp {
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
    sql: ${TABLE}.partition_timestamp ;;
  }

  dimension_group: time_scraped {
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
    sql: ${TABLE}.time_scraped ;;
  }

  dimension: warehouse_region {
    type: number
    sql: ${TABLE}.warehouse_region ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
