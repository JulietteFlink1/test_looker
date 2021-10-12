view: gorillas_to_flink_global {
  sql_table_name: `flink-data-prod.comp_intel.gorillas_to_flink_global`
    ;;

  dimension: gorillas_match_id {
    type: string
    sql: ${TABLE}.__id_left ;;
    group_label: "> IDs"
  }

  dimension: flink_match_id {
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

  dimension: flink_product_name {
    type: string
    sql: ${TABLE}.flink_product_name ;;
  }

  dimension: flink_product_sku {
    type: string
    sql: ${TABLE}.flink_sku ;;
  }

  dimension: gorillas_matches_uuid {
    type: string
    sql: ${TABLE}.gorillas_match_uuid ;;
    group_label: "> IDs"
  }

  dimension: gorillas_product_id {
    type: string
    sql: ${TABLE}.gorillas_product_id ;;
    hidden: yes
    primary_key: yes
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
