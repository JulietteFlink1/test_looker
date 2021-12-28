view: flink_to_getir_global {
  sql_table_name: `flink-data-prod.comp_intel.flink_to_getir_fuzzy_matching`
    ;;

  dimension: __id_left {
    type: string
    sql: ${TABLE}.__id_left ;;
  }

  dimension: __id_right {
    type: string
    sql: ${TABLE}.__id_right ;;
  }

  dimension: best_match_score {
    type: number
    sql: ${TABLE}.best_match_score ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: flink_fuzzy_match_uuid {
    type: string
    sql: ${TABLE}.flink_fuzzy_match_uuid ;;
  }

  dimension: flink_product_name {
    type: string
    sql: ${TABLE}.flink_product_name ;;
  }

  dimension: flink_product_sku {
    type: string
    sql: ${TABLE}.flink_product_sku ;;
  }

  dimension: getir_product_id {
    type: string
    sql: ${TABLE}.getir_product_id ;;
  }

  dimension: getir_product_name {
    type: string
    sql: ${TABLE}.getir_product_name ;;
  }

  measure: count {
    type: count
    drill_fields: [flink_product_name, getir_product_name]
  }
}
