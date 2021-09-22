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
    hidden: yes
  }

  dimension: flink_product_sku {
    type: string
    sql: ${TABLE}.flink_product_sku ;;
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
    hidden: yes
  }

}
