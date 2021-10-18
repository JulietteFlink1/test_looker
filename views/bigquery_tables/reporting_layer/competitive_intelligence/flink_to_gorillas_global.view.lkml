view: flink_to_gorillas_global {
  sql_table_name: `flink-data-prod.comp_intel.flink_to_gorillas_global`
    ;;

  dimension: flink_match_id {
    type: string
    sql: ${TABLE}.__id_left ;;
    group_label: "> IDs"
  }

  dimension: gorillas_match_id {
    type: string
    sql: ${TABLE}.__id_right ;;
    group_label: "> IDs"
  }

  dimension: match_type {
    type:  string
    sql: ${TABLE}.match_type ;;
  }

  dimension: best_match_score {
    type: number
    sql: ${TABLE}.match_score ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: flink_matches_uuid {
    type: string
    sql: ${TABLE}.flink_matches_uuid ;;
    group_label: "> IDs"
  }

  dimension: flink_product_name {
    type: string
    sql: ${TABLE}.flink_product_name ;;
  }

  dimension: flink_product_sku {
    type: string
    sql: ${TABLE}.flink_sku ;;
    hidden: yes
    primary_key: yes
  }

  dimension: gorillas_product_id {
    type: string
    sql: ${TABLE}.gorillas_product_id ;;
    hidden: yes
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
