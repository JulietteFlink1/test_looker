view: comp_intel_hub_mapping {
  sql_table_name: `flink-data-dev.competitive_intelligence.comp_intel_hub_mapping`
    ;;

  dimension: flink_hub_id {
    type: string
    sql: ${TABLE}.flink_hub_id ;;
  }

  dimension: flink_hub_label {
    type: string
    sql: ${TABLE}.flink_hub_label ;;
  }

  dimension: gorillas_hub_id {
    type: string
    sql: ${TABLE}.gorillas_hub_id ;;
  }

  dimension: gorillas_hub_label {
    type: string
    sql: ${TABLE}.gorillas_hub_label ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
