view: de_flink_to_gorillas {
  sql_table_name: `flink-data-prod.comp_intel.de_flink_to_gorillas`
    ;;

  dimension: id_left {
    type: string
    sql: ${TABLE}.__id_left ;;
    group_label: "> IDs"
  }

  dimension: id_right {
    type: string
    sql: ${TABLE}.__id_right ;;
    group_label: "> IDs"
  }

  dimension: best_match_score {
    type: number
    sql: ${TABLE}.best_match_score ;;
  }

  dimension: flink_product_name {
    type: string
    sql: ${TABLE}.flink_product_name ;;
  }

  dimension: flink_product_sku {
    type: string
    sql: ${TABLE}.flink_product_sku ;;
  }

  dimension: gorillas_product_id {
    type: string
    sql: ${TABLE}.gorillas_product_id ;;
  }

  dimension: gorillas_product_name {
    type: string
    sql: ${TABLE}.gorillas_product_name ;;
  }

  measure: count {
    type: count
    drill_fields: [gorillas_product_name, flink_product_name]
  }
}
