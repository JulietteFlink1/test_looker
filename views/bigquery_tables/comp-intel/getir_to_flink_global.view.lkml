view: getir_to_flink_global {
  sql_table_name: `flink-data-prod.comp_intel.getir_to_flink_global`
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

  dimension: flink_product_name {
    type: string
    sql: ${TABLE}.flink_product_name ;;
  }

  dimension: flink_product_sku {
    type: string
    sql: ${TABLE}.flink_product_sku ;;
  }

  dimension: table_uuid {
    type: string
    sql: ${TABLE}.table_uuid ;;
  }

  dimension: getir_product_id {
    type: string
    sql: ${TABLE}.getir_product_id ;;

    primary_key: yes
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
