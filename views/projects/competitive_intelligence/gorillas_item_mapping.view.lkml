view: gorillas_item_mapping {
  sql_table_name: `flink-backend.gsheet_comp_intel_gorillas_item_mapping.Item_Mapping`
    ;;


  dimension: gorillas_ean {
    type: number
    value_format: "0"
    sql: ${TABLE}.gorillas_ean ;;
  }

  dimension: flink_name {
    type: string
    sql: ${TABLE}.flink_name ;;
  }

  dimension: gorillas_name {
    type: string
    sql: ${TABLE}.gorillas_name ;;
  }

  dimension: flink_sku {
    type: number
    value_format: "0"
    sql: ${TABLE}.flink_sku ;;
  }

  dimension: gorillas_id {
    type: string
    sql: ${TABLE}.gorillas_id ;;
  }

  dimension: best_match_score {
    type: number
    value_format: "0.#########"
    sql: ${TABLE}.best_match_score ;;
  }

  dimension: flink_ean {
    type: number
    value_format: "0"
    sql: ${TABLE}.flink_ean ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
