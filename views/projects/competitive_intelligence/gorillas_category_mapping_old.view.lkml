view: gorillas_category_mapping_old {
  sql_table_name: `flink-backend.gsheet_comp_intel_gorillas_category_mapping.mapping`
    ;;

  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: gorillas_collection_id {
    type: string
    sql: ${TABLE}.gorillas_collection_id ;;
  }

  dimension: gorillas_group_id {
    type: string
    sql: ${TABLE}.gorillas_group_id ;;
  }

  dimension: category_id {
    type: number
    sql: ${TABLE}.category_id ;;
  }


  dimension: parent_category_id {
    type: number
    sql: ${TABLE}.parent_category_id ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
