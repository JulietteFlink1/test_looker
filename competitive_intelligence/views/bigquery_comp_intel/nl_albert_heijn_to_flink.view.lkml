#this view is to be deleted when relevant Looks have been updated
#replaced by albert_heijn_to_flink_global

view: nl_albert_heijn_to_flink {
  sql_table_name: `flink-data-prod.comp_intel.albert_heijn_to_flink_global`
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
