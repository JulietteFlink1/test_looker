view: gorillas_item_mapping {
  sql_table_name: `flink-backend.gsheet_comp_intel_gorillas_item_mapping.Item_Mapping`
    ;;



  dimension: flink_sku {
    type: number
    sql: ${TABLE}.flink_sku ;;
  }

  dimension: gorillas_id {
    type: string
    sql: ${TABLE}.gorillas_id ;;
  }

  dimension: gorillas_label {
    type: string
    sql: ${TABLE}.gorillas_label ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
