view: flink_to_getir_global {
  sql_table_name: `flink-data-prod.comp_intel.flink_to_getir_fuzzy_matching`
    ;;

  dimension: match_score {
    type: number
    sql: ${TABLE}.match_score ;;
  }

  dimension: match_type {
    type: string
    sql: ${TABLE}.match_type ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: table_uuid {
    type: string
    sql: ${TABLE}.table_uuid ;;
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
