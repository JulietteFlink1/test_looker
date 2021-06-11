view: gorillas_v1_item_hub_collection_group_allocation {
  sql_table_name: `flink-data-dev.gorillas_v1.item_hub_collection_group_allocation`
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

  dimension: hub_id {
    type: string
    sql: ${TABLE}.hub_id ;;
  }

  dimension: item_id {
    type: string
    sql: ${TABLE}.item_id ;;
  }

  measure: count {
    type: count
    drill_fields: [collection_name]
  }
}
