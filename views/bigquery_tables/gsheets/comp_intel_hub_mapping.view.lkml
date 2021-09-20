view: comp_intel_hub_mapping {
  sql_table_name: `flink-data-prod.google_sheets.comp_intel_hub_mapping`
    ;;

  dimension: unique_id {
    primary_key: yes
    hidden: yes
    type: string
    sql: concat(${flink_hub_id}, ${gorillas_hub_id} ;;
  }

  dimension: flink_hub_id {
    type: string
    sql: ${TABLE}.flink_hub_id ;;
  }

  dimension: gorillas_hub_id {
    type: string
    sql: ${TABLE}.gorillas_hub_id ;;
  }
}
