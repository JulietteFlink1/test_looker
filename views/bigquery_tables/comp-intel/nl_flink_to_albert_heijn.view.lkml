#this view is to be deleted when relevant Looks have been updated
#replaced by flink_to_albert_heijn_global

view: nl_flink_to_albert_heijn {
  sql_table_name: `flink-data-prod.comp_intel.flink_to_albert_heijn_global`
    ;;

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
    sql: ${TABLE}.match_score ;;
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
