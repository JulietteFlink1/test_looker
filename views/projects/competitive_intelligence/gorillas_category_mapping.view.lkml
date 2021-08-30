view: gorillas_category_mapping{
  sql_table_name: `flink-data-prod.google_sheets.comp_intel_gorillas_category_mapping`
    ;;

  dimension: unique_id {
    group_label: "* IDs *"
    primary_key: yes
    type: string
    sql: concat(${country_iso}, ${category_id},${parent_category_id},${gorillas_collection_id}, ${gorillas_group_id}) ;;
  }




  dimension: country_iso {
    type: string
    sql: ${TABLE}.country_iso ;;
  }

  dimension: category_id {
    type: number
    sql: ${TABLE}.flink_category_id ;;
  }

  dimension: parent_category_id {
    type: number
    sql: ${TABLE}.flink_parent_category_id ;;
  }

  dimension: parent_category_name {
    type: string
    sql: ${TABLE}.flink_parent_category_name ;;
  }

  dimension: sub_category_name {
    type: string
    sql: ${TABLE}.flink_sub_category_name ;;
  }

  dimension: gorillas_collection_id {
    type: string
    sql: ${TABLE}.gorillas_collection_id ;;
  }

  dimension: gorillas_collection_name {
    type: string
    sql: ${TABLE}.gorillas_collection_name ;;
  }

  dimension: gorillas_group_id {
    type: string
    sql: ${TABLE}.gorillas_group_id ;;
  }

  dimension: gorillas_group_name {
    type: string
    sql: ${TABLE}.gorillas_group_name ;;
  }

  measure: count {
    type: count
    drill_fields: [gorillas_collection_name, sub_category_name, gorillas_group_name, parent_category_name]
  }
}
