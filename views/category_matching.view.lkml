view: category_matching {
  sql_table_name: `flink-data-dev.competitive_intelligence.category_matching`
    ;;

  dimension: flink_category_id {
    type: number
    sql: ${TABLE}.flink_category_id ;;
  }

  dimension: flink_category_name {
    type: string
    sql: ${TABLE}.flink_category_name ;;
  }

  dimension: flink_country_iso {
    type: string
    sql: ${TABLE}.flink_country_iso ;;
  }

  dimension: gorillas_category_name {
    type: string
    sql: ${TABLE}.gorillas_category_name ;;
  }

  measure: count {
    type: count
    drill_fields: [gorillas_category_name, flink_category_name]
  }
}
