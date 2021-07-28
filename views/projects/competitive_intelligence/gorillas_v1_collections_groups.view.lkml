view: gorillas_v1_collections_groups {
  sql_table_name: `flink-data-dev.gorillas_v1.collections_groups`
    ;;

  dimension: collection_id {
    type: string
    sql: ${TABLE}.collection_id ;;
  }

  dimension: collection_name {
    type: string
    sql: ${TABLE}.collection_name ;;
  }

  dimension: country_iso {
    type: string
    sql: ${TABLE}.countryIso ;;
  }

  dimension: group_id {
    type: string
    sql: ${TABLE}.group_id ;;
  }

  dimension: group_label {
    type: string
    sql: ${TABLE}.group_label ;;
  }

  measure: count {
    type: count
    drill_fields: [collection_name]
  }
}
