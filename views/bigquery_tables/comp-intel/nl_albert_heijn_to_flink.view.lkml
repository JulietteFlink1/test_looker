view: nl_albert_heijn_to_flink {
  sql_table_name: `flink-data-prod.comp_intel.nl_albert_heijn_to_flink`
    ;;

  dimension: __id_left {
    type: string
    sql: ${TABLE}.__id_left ;;
  }

  dimension: __id_right {
    type: string
    sql: ${TABLE}.__id_right ;;
  }

  dimension: albert_heijn_product_id {
    type: string
    sql: ${TABLE}.albert_heijn_product_id ;;
  }

  dimension: albert_heijn_product_name {
    type: string
    sql: ${TABLE}.albert_heijn_product_name ;;
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

  measure: count {
    type: count
    drill_fields: [albert_heijn_product_name, flink_product_name]
  }
}
